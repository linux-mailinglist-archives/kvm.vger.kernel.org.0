Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E247E416CC4
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 09:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244321AbhIXHWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244273AbhIXHWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 03:22:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F26DC061574
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 00:20:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n2so5832103plk.12
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 00:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oa6c5pdb6GgT+FciQG9zGryGSgSV0wDGRTDly5jSdik=;
        b=Yb8BC8+W8zNJ2cn6C+2RpR53j2vs6KwDm3Q0f/gzO14zIh5KXkaWH8KHkJLfKvq/Gt
         Tvd67QkiEuG2mLPoLbndnQmE3KpY+0IqGKcsf6kG5YVEqGkhLSn85eM84xm3e7jZGZIs
         zHpgI6i+lu05G+eLTl7ihnBzI10EADdGbnS+ZkD2CPbD52aBb5kKgEZdL8exiVx01EPs
         Rj1gflu+ib3d88jvp7c+KFMw6VgWW8pYfg/3Sk/X5/XrjbmJ1yOouczfljbaFPuNOX9K
         76DZQ7y34SwmHbayWrhTeJyUEbosSNA3bxtX1njDRagU+RoNFCgTHy+mW3M2nDxp9vNn
         HYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oa6c5pdb6GgT+FciQG9zGryGSgSV0wDGRTDly5jSdik=;
        b=m5onB4jU04hspRDq2xrhH1Yh9nTpVUb+EJsMrb2ezFmY3urc3tcv0//KrkA1Myasax
         WfqCXqbVEY7BVtdf64liTyN7KzztdYVzlH7ABYaO/adieWsVXB+A2k4zp7SJv5YwrrHM
         ina6UT3jwWcdMi9nQRHgA5FyNXpWOv3RreYT6YXuOlwRhdrXeiQuAHUiymNd0StB4dT3
         uvJ2yeGMYWU6TxOma4v8GEAvhCdNZSeo1S4qDZBGIuNHWxrTEAh1zPwnBEcTwK6J1F+k
         H7WHvSX/yGM/TmNUqw9jqfH6RWwuO3oH9z3Ikr98reAotWlVZcLChjbGiMafEfSgTbKd
         Up7Q==
X-Gm-Message-State: AOAM5329JvXFifgibpKYQzfZQcfWGQsL2Tfht4Lw56WJYYQxzl3gozsW
        op4hQH8/47p+NC4AElBuYOCCUSl8mX73W8ZpxLPupg==
X-Google-Smtp-Source: ABdhPJyQE81Xvn5qKelAV4RVuvdM8+D6Sr0NIlWcPD2y3ECryKNkbPx229P43Hc2o82o3mdURpHlbiPyX4ZN9pQ1DwE=
X-Received: by 2002:a17:90b:a02:: with SMTP id gg2mr161551pjb.110.1632468047511;
 Fri, 24 Sep 2021 00:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com> <20210916181510.963449-7-oupton@google.com>
 <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
In-Reply-To: <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 24 Sep 2021 00:20:31 -0700
Message-ID: <CAAeT=FxcW0+cVgfkoU8LWndxM1njC6rDhoWuL+JwXXbPRpYnyg@mail.gmail.com>
Subject: Re: [PATCH v8 6/8] KVM: arm64: Allow userspace to configure a guest's
 counter-timer offset
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

I have additional questions/comments.

> > +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> > +-----------------------------------------
> > +
> > +:Parameters: in kvm_device_attr.addr the address for the timer offset is a
> > +             pointer to a __u64
> > +
> > +Returns:
> > +
> > +        ======= ==================================
> > +        -EFAULT Error reading/writing the provided
> > +                parameter address
> > +        -ENXIO  Timer offsetting not implemented
> > +        ======= ==================================
> > +
> > +Specifies the guest's counter-timer offset from the host's virtual counter.
> > +The guest's physical counter value is then derived by the following
> > +equation:
> > +
> > +  guest_cntpct = host_cntvct - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> > +
> > +The guest's virtual counter value is derived by the following equation:
> > +
> > +  guest_cntvct = host_cntvct - KVM_REG_ARM_TIMER_OFFSET
> > +                       - KVM_ARM_VCPU_TIMER_PHYS_OFFSET

Although KVM_REG_ARM_TIMER_OFFSET is available only if userspace
opt-in KVM_CAP_ARM_VTIMER_OFFSET, setting this attribute doesn't
depend on the capability, correct ?

> > +KVM does not allow the use of varying offset values for different vCPUs;
> > +the last written offset value will be broadcasted to all vCPUs in a VM.

What if a new vCPU is added after KVM_ARM_VCPU_TIMER_PHYS_OFFSET
is set (for other existing vCPUs) ?  Don't we want to set the offset for
the newly created vCPU as well ?

I'm a bit concerned about extra cost during Live Migration of a VM
that has large number of vCPUs if setting this is done by each vCPU
because that invokes update_timer_offset(), which sets the offset
for every vCPU that is owned by the guest holding kvm->lock,
two times (e.g. for a VM who number of vCPUs is KVM_MAX_VCPUS,
which is 512, the offset setting is done 524288 times).
Userspace can be implemented to run this just for single vCPU though.


> In my understanding, the offset that the code below specifies
> to call update_vtimer_cntvoff() is (guest's virtual counter) offset
> from the host's counter, which is always same as guest's virtual
> counter offset from the guest's physical counter-timer before this patch.
>
> int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> {
>         struct arch_timer_context *timer;
>
>         switch (regid) {
>         <...>
>         case KVM_REG_ARM_TIMER_CNT:
>                 timer = vcpu_vtimer(vcpu);
>                 update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
>                 break;
>         <...>
>
> With this patch, since the guest's counter-timer offset from the host's
> counter can be set by userspace, doesn't the code need to specify
> guest's virtual counter offset (from guest's physical counter-timer) ?


Thanks,
Reiji
