Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4741E03C
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352741AbhI3Rer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 13:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352681AbhI3Req (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 13:34:46 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F50CC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:33:03 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z24so28542899lfu.13
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iKfk6HbG6TObfzRUE4EIW/odvNzsG1SnwK5+/9/zkj0=;
        b=FZRkwMcuX90szqNm8YFb+9IVR7uiAeZo8r7TCRXR3IDZfCNFSlSfMMhs/4798maVNE
         eNU1fPnAEMfL3RKUFRSjECHb286st1nKKy6Q2PA3fRGGfggOVmy7coNju0QA7C157LJa
         XvFraoQx4x64Rww3mHpMWwfFF1ixtkG3dVgr/l2iAv/YJAIqMZCFin3oW6uQeOH2KOqF
         NQoxJq8LAvdo0J7SOXyJ6xMUyrE8fRAxgmKVixVYkUCdr9bcniWqFe/GP+fNCU4uU8cG
         u8GocJ0vHGdAEfCQhL4DrmOH6gHADQYm+8pAFClVByMFLRyOEs716JBCAZ0c+R2rLiJy
         Hf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iKfk6HbG6TObfzRUE4EIW/odvNzsG1SnwK5+/9/zkj0=;
        b=Q0zecaD1nCOXr4I6H89IAVUqIVCMnDiWlXeJdjrR8M//8fNKXqzakp59Z/1VSHOf3y
         chuWV6ul84LDUDw1euFazc95bT7gva/4oAN1G6qxfiMCU3ryPosfz3TNDg0gARh1tYBl
         T4+e/hHrCayOLPAGZ02LOieA5c8JvIsgKPyRyL/Qeaop/v1VQypYw26iQuVhxIpfqdB5
         cCQZaIsDvQqcIIcUPRhmibL4uF0QxDgiYAF5SsAe/LGFojJB+LGl/yhRd8Rm3okl1jpn
         NxiFCmruoCAET2tcOKo1qfuZGqEiYotrT3Y3Iy52T9K9mgxeM4itrAfJOHy5/Dw1Gzx8
         mgTQ==
X-Gm-Message-State: AOAM531LxFWR4jLbqhxDj4bsL/VQvt4jCCWoZSyCp9GdcGMqRNBSiKJ4
        kACYIx1zKEOos2V1KFjydg1JO3bqbZKABRUjzLwSkg==
X-Google-Smtp-Source: ABdhPJzq/VatrgxhazbFBsyW1Zf46+5YaQA0HtXNK2rb6j4UxNfmN8UeiVWKq+G80yaEkN4sKybzTxB+SboJZ9UvAR4=
X-Received: by 2002:a2e:719:: with SMTP id 25mr7561449ljh.251.1633023180023;
 Thu, 30 Sep 2021 10:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org> <YVXvM2kw8PDou4qO@google.com>
In-Reply-To: <YVXvM2kw8PDou4qO@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 30 Sep 2021 10:32:49 -0700
Message-ID: <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested event
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Marc Zyngier wrote:
> > On Thu, 23 Sep 2021 20:16:04 +0100, Oliver Upton <oupton@google.com> wrote:
> > > @@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> > >             if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> > >                     kvm_vcpu_sleep(vcpu);
> > >
> > > +           if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > > +                   kvm_vcpu_suspend(vcpu);
> > > +
>
> ...
>
> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 275a27368a04..5e5ef9ff4fba 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
> > >     } else {
> > >             trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> > >             vcpu->stat.wfi_exit_stat++;
> > > -           kvm_vcpu_block(vcpu);
> > > -           kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > > +           kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > >     }
> > >
> > >     kvm_incr_pc(vcpu);
> >
> > This is a change in behaviour. At the point where the blocking
> > happens, PC will have already been incremented. I'd rather you don't
> > do that. Instead, make the helper available and call into it directly,
> > preserving the current semantics.
>
> Is there architectural behavior that KVM can emulate?  E.g. if you were to probe a
> physical CPU while it's waiting, would you observe the pre-WFI PC, or the post-WFI
> PC?  Following arch behavior would be ideal because it eliminates subjectivity.
> Regardless of the architectural behavior, changing KVM's behavior should be
> done explicitly in a separate patch.
>
> Irrespective of PC behavior, I would caution against using a request for handling
> WFI.  Deferring the WFI opens up the possibility for all sorts of ordering
> oddities, e.g. if KVM exits to userspace between here and check_vcpu_requests(),
> then KVM can end up with a "spurious" pending KVM_REQ_SUSPEND if maniupaltes vCPU
> state.  I highly doubt that userspace VMMs would actually do that, as it would
> basically require a signal from userspace, but it's not impossible, and at the
> very least the pending request is yet another thing to worry about in the future.
>
> Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.

Yeah, I don't think the punt is necessary for anything but the case
where userspace sets the MP state to request WFI behavior. A helper
method amongst all WFI cases is sufficient, and using the deferral for
everything is a change in behavior.

> > It is also likely to clash with Sean's kvm_vcpu_block() rework, but we
> > can work around that.
>
> Ya.  Oliver, can you Cc me on future patches?  I'll try to keep my eyeballs on this
> series.

Sure thing :)
