Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E459818186
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfEHVOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:14:14 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46429 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHVON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 17:14:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id h21so117570ljk.13
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 14:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XmgWTsaMk7FJwL0S+4Yx4ZiYciZqrs8IjHNXC9pllJQ=;
        b=PzBgyfMdADWW+sgrqdbUjbunUuQ8bsInnb5l433iPVwQ+g1DXG4N7l6QNvbfRRNOIk
         qd4y4BVypzJweUsowuzrTD7e45G0MtqE5CxgZLlNqa8RgU+RRqdXNnp7T1ljzpxp5u+B
         JRAQ6p5w7weTqLbLVXiuIb7YH8qpK/cnTJiqTnLMSD40od/jCpdBOcXbdOvYBp4/Kpbf
         icPloQojGBGf7HZhOGRnMuCuyQ7wFOgMEn462HOW4Jgw/Vb7na0r/OdJ+LOQZEMrcZ+z
         S6dqQ177ognYzZ0eLZhu4Lf99Sebp8lzADtFhLiTVpOlKb9F74aCW/CEmjzPfHZYINam
         fbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XmgWTsaMk7FJwL0S+4Yx4ZiYciZqrs8IjHNXC9pllJQ=;
        b=oXzmpXmUz37i+qBg4PotorTr6FngA/CXaOGiAt8jazcSyMbzweOPQFv8np5/C5dl/U
         uJ/rRAIhD14NSlyKS0PTPc6cB3VTc18eWKyqxGqmBssdC1V/Cc9NpcD9Nw+dopPX0For
         xVlcka7do1k4djVKWwRPVDPjygDq9tP5SjrmDQOLk2ZfErR9gyuzBVhOJe+3UnKRB+U4
         gnxYHTqA/G8zqNFRBmVSYD3w3vs8tSVNrC0TizgyD+4pCKBljI2x4/VtFsbx8u6AHO01
         dBJqJ+BIptM2U1/rX/8p69BgjKmJ1rtZow673bNCwCepM4N706pCu618I4piseINnqH2
         Vzxg==
X-Gm-Message-State: APjAAAWd2x08uTEZeXBvOWL6/3sTQxU/FhKRZvlzx151Ag55Y5vtW3l7
        A1tjtmO8pP6J+1dLRwWxu8Oj3n4TUq5XS+dIzEJYKQ==
X-Google-Smtp-Source: APXvYqyPty29eEty05I/iwa/YMDVBKE7a1LfZERkS+aH1YvgQaUvAg9u+mmr7f7RtolPrd/CbOB4yvUKwU75hGypXzQ=
X-Received: by 2002:a2e:8857:: with SMTP id z23mr535288ljj.73.1557350050638;
 Wed, 08 May 2019 14:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <1557317799-39866-1-git-send-email-pbonzini@redhat.com>
 <20190508142023.GA13834@linux.intel.com> <CAAAPnDE0ujH4eTX=4umTTEmUMyaZ7M0B3qxWa7oUUD-Ls7Ta+A@mail.gmail.com>
 <20190508181339.GD19656@linux.intel.com>
In-Reply-To: <20190508181339.GD19656@linux.intel.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 8 May 2019 14:13:59 -0700
Message-ID: <CAAAPnDF=T8FHqLrHUDB9g9QzWJcct2mddqUW0O7zja7Ae0uy-Q@mail.gmail.com>
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
Date: Wed, May 8, 2019 at 11:13 AM
To: Aaron Lewis
Cc: Paolo Bonzini, <linux-kernel@vger.kernel.org>,
<kvm@vger.kernel.org>, Peter Shier

> On Wed, May 08, 2019 at 10:53:12AM -0700, Aaron Lewis wrote:
> > nested_run_pending is also checked in
> > nested_vmx_check_vmentry_postreqs
> > (https://elixir.bootlin.com/linux/v5.1/source/arch/x86/kvm/vmx/nested.c#L2709)
> > so I think the setting needs to be moved to just prior to that call
> > with Paolo's rollback along with another for if the prereqs and
> > postreqs fail.  I put a patch together below:
>
> Gah, I missed that usage (also, it's now nested_vmx_check_guest_state()).
>
> Side topic, I think the VM_ENTRY_LOAD_BNDCFGS check should be gated by
> nested_run_pending, a la the EFER check.'
>
> > ------------------------------------
> >
> > nested_run_pending=1 implies we have successfully entered guest mode.
> > Move setting from external state in vmx_set_nested_state() until after
> > all other checks are complete.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 6401eb7ef19c..cf1f810223d2 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >   if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> >   return 0;
> >
> > - vmx->nested.nested_run_pending =
> > - !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
>
> Alternatively, it might be better to leave nested_run_pending where it
> is and instead add a label to handle clearing the flag on error.  IIUC,
> the real issue is that nested_run_pending is left set after a failed
> vmx_set_nested_state(), not that its shouldn't be set in the shadow
> VMCS handling.
>
> Patch attached, though it's completely untested.  The KVM selftests are
> broken for me right now, grrr.
>
> > -
> >   if (nested_cpu_has_shadow_vmcs(vmcs12) &&
> >       vmcs12->vmcs_link_pointer != -1ull) {
> >   struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> > @@ -5480,14 +5477,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >   return -EINVAL;
> >   }
> >
> > + vmx->nested.nested_run_pending =
> > + !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> > +
> >   if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
> > -     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
> > +     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual)) {
> > +     vmx->nested.nested_run_pending = 0;
> >   return -EINVAL;
> > + }
> >
> >   vmx->nested.dirty_vmcs12 = true;
> >   ret = nested_vmx_enter_non_root_mode(vcpu, false);
> > - if (ret)
> > + if (ret) {
> > + vmx->nested.nested_run_pending = 0;
> >   return -EINVAL;
> > + }
> >
> >   return 0;
> >  }

Here is an update based on your patch.  I ran these changes against
the test vmx_set_nested_state_test, and it run successfully.

That's correct that we are only concerned about restoring the state of
nested_run_pending, so it's fine to set it where we do as long as we
back the state change out before returning if we get an error.

---------------------------------------------

nested_run_pending=1 implies we have successfully entered guest mode.
Move setting from external state in vmx_set_nested_state() until after
all other checks are complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Tested-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6401eb7ef19c..fe5814df5149 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5468,28 +5468,36 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);

  if (kvm_state->size < sizeof(kvm_state) + 2 * sizeof(*vmcs12))
- return -EINVAL;
+ goto error_guest_mode_einval;

  if (copy_from_user(shadow_vmcs12,
     user_kvm_nested_state->data + VMCS12_SIZE,
-    sizeof(*vmcs12)))
- return -EFAULT;
+    sizeof(*vmcs12))) {
+ ret = -EFAULT;
+ goto error_guest_mode;
+ }

  if (shadow_vmcs12->hdr.revision_id != VMCS12_REVISION ||
      !shadow_vmcs12->hdr.shadow_vmcs)
- return -EINVAL;
+ goto error_guest_mode_einval;
  }

  if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
      nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
- return -EINVAL;
+ goto error_guest_mode_einval;

  vmx->nested.dirty_vmcs12 = true;
  ret = nested_vmx_enter_non_root_mode(vcpu, false);
  if (ret)
- return -EINVAL;
+ goto error_guest_mode_einval;

  return 0;
+
+error_guest_mode_einval:
+ ret = -EINVAL;
+error_guest_mode:
+ vmx->nested.nested_run_pending = 0;
+ return ret;
 }

 void nested_vmx_vcpu_setup(void)
