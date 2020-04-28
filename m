Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE31BB302
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgD1ApZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726257AbgD1ApY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 20:45:24 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AF6C03C1A8;
        Mon, 27 Apr 2020 17:45:24 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i27so29722536ota.7;
        Mon, 27 Apr 2020 17:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cb11Hz0A50XPcbceB5dfVGRAlvbIEBuFr97ApgK/EIk=;
        b=dfX+cUxbNOS4J9ZCOwQpOqI92SoKUcnor4d3XsnJ4WIy7r01vyToWMna64GFtWnLCP
         AcutTza8nkh1hyhiRFV/7y/d+8Ff6tIfVKG59Fmmwbd4PDDpZ+3nk5lKyowA5pfJbrQt
         6ixen0G9HUIfyDcex4mza/kOS45Pa5YaQFcLG+7ujYI8zcw7FHyW/DfLCeoPZs50Yruw
         dQhr9GnCPBQ6y2e7S84+LA1YY+Z+YiKk1llyLUTWaEG9ME4sMHd4cRBirvdGmwZgRquk
         s22MNyb83XKAzJIv/wSFqMpjcm8LDat4o4nlpaH0/w78pyPtWV0ZJMTIIFnzD3NrV6yS
         Sidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cb11Hz0A50XPcbceB5dfVGRAlvbIEBuFr97ApgK/EIk=;
        b=beAod2YoRdU6UieqYW6ZvZH0K9zw8s8R0iRhW7mLhEKB0BolU6cetS+atBjSsIXwZe
         CVFgabPt+wYWDeU0b/XQ8mrWXu3RBD3XuxkfPzY7cY2PgUUce5V0ngDH5hpfaGWhnllq
         1a5pWZFzvQtYrKE9hwvCe18EtiXMeKuDxJBwYIcSmVS/t2tmH2ICyDaWrZs5ewrHsqyo
         lGK0fIVA9mGe6vL//ha13AqFpbCoJQSsnspsUsd1CY+aagrx+YUJ/cVEatvJZRiwwImj
         TWUZ/QKWxjZ5tKHUTVebVlVkdB4hnIzq/WpMi1Q/IKWPMpV7UgxZ4CccmE92FqYHnn01
         M2YQ==
X-Gm-Message-State: AGi0PuaWyqwD5RB1xLyN3j63KrQOlH7FrYvYh6TMsc16CIV979x4v53H
        vNT+BMaio2/F2XpUkIthJW7KFlSbu9OcozSe4R0=
X-Google-Smtp-Source: APiQypIYhx+Tjrfud5bCA777zLf4UxvF2A1uz559fKwaXGVCs30bAwIoZRpiDrVm0IZl58QX359yfiaIn8N6PIXHX/0=
X-Received: by 2002:a9d:7f04:: with SMTP id j4mr21498257otq.185.1588034724101;
 Mon, 27 Apr 2020 17:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-6-git-send-email-wanpengli@tencent.com> <20200427184253.GR14870@linux.intel.com>
In-Reply-To: <20200427184253.GR14870@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 Apr 2020 08:45:13 +0800
Message-ID: <CANRm+CyxcxqQrOJVjvxSpWrpqjkvrsa5ts9RO57FR=cdNcpZgQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: VMX: Handle preemption timer fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 at 02:42, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Apr 24, 2020 at 02:22:44PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > This patch implements handle preemption timer fastpath, after timer fire
> > due to VMX-preemption timer counts down to zero, handle it as soon as
> > possible and vmentry immediately without checking various kvm stuff when
> > possible.
> >
> > Testing on SKX Server.
> >
> > cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):
> >
> > 5540.5ns -> 4602ns       17%
> >
> > kvm-unit-test/vmexit.flat:
> >
> > w/o avanced timer:
> > tscdeadline_immed: 2885    -> 2431.25  15.7%
> > tscdeadline:       5668.75 -> 5188.5    8.4%
> >
> > w/ adaptive advance timer default -1:
> > tscdeadline_immed: 2965.25 -> 2520     15.0%
> > tscdeadline:       4663.75 -> 4537      2.7%
> >
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Cc: Haiwei Li <lihaiwei@tencent.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index d21b66b..028967a 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6560,12 +6560,28 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
> >       }
> >  }
> >
> > +static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
>
> Somewhat offtopic, would it make sense to add a fastpath_t typedef?  These
> enum lines are a bit long...
>
> > +{
> > +     struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> > +     if (!vmx->req_immediate_exit &&
> > +             !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
>
> Bad indentation.
>
> Also, this is is identical to handle_preemption_timer(), why not something
> like:
>
> static bool __handle_preemption_timer(struct vcpu)
> {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>
>         if (!vmx->req_immediate_exit &&
>             !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
>                 kvm_lapic_expired_hv_timer(vcpu);
>                 return true;
>         }
>
>         return false;
> }
>
> static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
> {
>         if (__handle_preemption_timer(vcpu))
>                 return EXIT_FASTPATH_CONT_RUN;
>         return EXIT_FASTPATH_NONE;
> }
>
> static int handle_preemption_timer(struct kvm_vcpu *vcpu)
> {
>         __handle_preemption_timer(vcpu);
>         return 1;
> }
>

Great! Thanks for making this nicer.

    Wanpeng
