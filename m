Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA617F5B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfEHRx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:53:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39134 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfEHRx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:53:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id q10so18270196ljc.6
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXuwbV2MomMhbfyVRrBaEuMWaMX3B/IUoMF1tjnif/4=;
        b=F8u8ZwXk2F2XX1EmUFc4kMkf/eW28sPItGSkR2bYWu6rAGtelSzq8Dq1VxeMkGahCs
         cCU18fvMfZ5DQu8IdRpt3bN7ZLsMWXXW+qqR4DxUAQ87flufGAog4FeAtBRgzim9Rnxf
         TJevNLvCGQIObgV2l+7raw39c8QfIUsFQomYV4WyNp3HAobTuT7fSWpOf2sZlFlbGCHa
         FVjMbUAWUxgQ36En9+dEELEou9dMHunmjTUvJaMNCYK90nwe2PPk/kFFAyrAf6bL55Yc
         cZCBT5QdzR24NlIR43JDCs+XW/ylRLZ2PFOufrIxCf30X2GiNYsJMsMCXJbugm1FFN7e
         CRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXuwbV2MomMhbfyVRrBaEuMWaMX3B/IUoMF1tjnif/4=;
        b=ooUXWDo0RyIfyWj66IdF34bPwCVNRbuTlcbHux0VGaHCnT/doIiAC5JzQWL1369mYx
         p7xzEGrPDhnFjuCYL2RMCSGYgWsfmB8lGtkXCcNrsdPFL0n/6QLC/HkndlDknGld/6fo
         CUcvaIByf8WHgQxsvo+o4jZ6cU69plTJWMbnjBKfKiUC+jlqzxNrHEXaJkQ7u7mt7BsB
         rsJSDYs7wq24i3HLtwwnVoW8WuVLHOTc+5j/2w26cAocXFgmdYsjUJw5A2aizMRjS/av
         od4PFsXZN2zFqQaMc8PcUxl2wi2Qxdat0znyrZLHTWiGy2JLIID5t6tubZRY21g8yFLA
         yv0Q==
X-Gm-Message-State: APjAAAUF69af5tH5dl+JS9FnkXD2nsl3QzAoNbmlziC2AjJXcADqA2J2
        ZZzW9UioApn89waFbc+N59CzlAtY8TfHrQmDX4Btdw==
X-Google-Smtp-Source: APXvYqzIT5Iu46E8bY9noFllKoIdXh+tajEgsWfK5I5lzHEed5wuBHVtMvZR9CbTsMHIC6J9vWebpWLdw2B2IWUYyqU=
X-Received: by 2002:a2e:95c7:: with SMTP id y7mr9330668ljh.29.1557338004342;
 Wed, 08 May 2019 10:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <1557317799-39866-1-git-send-email-pbonzini@redhat.com> <20190508142023.GA13834@linux.intel.com>
In-Reply-To: <20190508142023.GA13834@linux.intel.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 8 May 2019 10:53:12 -0700
Message-ID: <CAAAPnDE0ujH4eTX=4umTTEmUMyaZ7M0B3qxWa7oUUD-Ls7Ta+A@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: nVMX: Set nested_run_pending in
 vmx_set_nested_state after checks complete
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, May 8, 2019 at 7:20 AM
To: Paolo Bonzini
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Peter
Shier, Aaron Lewis

> On Wed, May 08, 2019 at 02:16:39PM +0200, Paolo Bonzini wrote:
> > From: Aaron Lewis <aaronlewis@google.com>
>
> If this is actually attributed to Aaron it needs his SOB.
>
> > nested_run_pending=1 implies we have successfully entered guest mode.
> > Move setting from external state in vmx_set_nested_state() until after
> > all other checks are complete.
>
> It'd be helpful to at least mention the flag is consumed by
> nested_vmx_enter_non_root_mode().
>
> > Based on a patch by Aaron Lewis.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
>
> For the code itself:
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
> >  arch/x86/kvm/vmx/nested.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index cec77f30f61c..e58caff92694 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5420,9 +5420,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >       if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> >               return 0;
> >
> > -     vmx->nested.nested_run_pending =
> > -             !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> > -
> >       if (nested_cpu_has_shadow_vmcs(vmcs12) &&
> >           vmcs12->vmcs_link_pointer != -1ull) {
> >               struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> > @@ -5446,9 +5443,14 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >               return -EINVAL;
> >
> >       vmx->nested.dirty_vmcs12 = true;
> > +     vmx->nested.nested_run_pending =
> > +             !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> > +
> >       ret = nested_vmx_enter_non_root_mode(vcpu, false);
> > -     if (ret)
> > +     if (ret) {
> > +             vmx->nested.nested_run_pending = 0;
> >               return -EINVAL;
> > +     }
> >
> >       return 0;
> >  }
> > --
> > 1.8.3.1
> >

nested_run_pending is also checked in
nested_vmx_check_vmentry_postreqs
(https://elixir.bootlin.com/linux/v5.1/source/arch/x86/kvm/vmx/nested.c#L2709)
so I think the setting needs to be moved to just prior to that call
with Paolo's rollback along with another for if the prereqs and
postreqs fail.  I put a patch together below:

------------------------------------

nested_run_pending=1 implies we have successfully entered guest mode.
Move setting from external state in vmx_set_nested_state() until after
all other checks are complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6401eb7ef19c..cf1f810223d2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
  return 0;

- vmx->nested.nested_run_pending =
- !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
-
  if (nested_cpu_has_shadow_vmcs(vmcs12) &&
      vmcs12->vmcs_link_pointer != -1ull) {
  struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
@@ -5480,14 +5477,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  return -EINVAL;
  }

+ vmx->nested.nested_run_pending =
+ !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
+
  if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
-     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
+     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual)) {
+     vmx->nested.nested_run_pending = 0;
  return -EINVAL;
+ }

  vmx->nested.dirty_vmcs12 = true;
  ret = nested_vmx_enter_non_root_mode(vcpu, false);
- if (ret)
+ if (ret) {
+ vmx->nested.nested_run_pending = 0;
  return -EINVAL;
+ }

  return 0;
 }
