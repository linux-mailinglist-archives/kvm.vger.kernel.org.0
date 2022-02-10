Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFDC4B051E
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 06:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiBJFcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 00:32:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiBJFcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 00:32:04 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F23510A1
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 21:32:06 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n23so8335828pfo.1
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 21:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZU6aXT6WOCOFQgPGsHOstXdVDds/C1lctEDu/mBT3w=;
        b=h3mRlMtBGU5u0GoeO7EcpZ/06kyk/u4OLHB5BYOgTLh8a/TFlrf5DX/Ck9MvNq6jPW
         7Hp450MRg3aNwkbQ/p0L2zaAYcpLTRIfeCtTH9FXEhF5bM9yp1LWTHD72PeKBeApIj5J
         skuUef7Ts/UDtAZgvwGJ/5rloPeAVBuIVXqOnOgPLaPOiFNTQYxXJJ0Y8AyVE4UuPIyE
         ob66wKHEuGxx4YC1Eut0ybfs4vDKxKYShO8euaicMgtygNpugtRxfIn4UnTl/F16a8Ux
         dFjYjt+VlQV4qKBwPOs157mOLAXYB1VHx3Y+Hwb4LKGGscqw1KfUkOIp7xOlwPCbgc4D
         Jhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZU6aXT6WOCOFQgPGsHOstXdVDds/C1lctEDu/mBT3w=;
        b=Zg47AMCxoWYRk/bP409kctLZLSkm90sFAPXeEbMfkBUh8jEF4UE3PIGf9/SB9VBcl1
         MRPpNe/f5zUy8kijDGV4SpbsXS5YveDmPLVKlL6HGdMZ9qB42y9Oz/YiFgBBZM9QIlQq
         SvWOT5V/Vs1okTtg178afXedDXGEzudZEQMTK3tT1t9l6s819rx/J27JgLfHo7lO9Gyq
         s499cK2BSG6FYv7w+L2FD6aEUS9w7EB4HmNYEL9aktZ+c2rXyYMwIizAAl4GgcShBMOO
         8gvsejpwGnRkkC4Ogm8x6gD/tPHZqYnm2dEtCBgxvKk/RLT2xvbHlL4RINHm2+r4U0qL
         OWuA==
X-Gm-Message-State: AOAM532WQG8ILnOuywmddulZNf46tzBqGQzUKhD5sZkykg2K0k+SFrC9
        dxNDpV/GwVsiGEP4wu/ldCAtPG35AhySJQt+iW3KlqiwmPxmag==
X-Google-Smtp-Source: ABdhPJyNKBSpkqzfE+GzX+y0f2tzGqnCaxEZw7x45ANtyzSNuRAMJN0rP7ubqIwc9bc8pEuUOGyhEgg/IDb/eyb/JDI=
X-Received: by 2002:a62:17cd:: with SMTP id 196mr5950083pfx.39.1644471125318;
 Wed, 09 Feb 2022 21:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com> <87a6f15skj.wl-maz@kernel.org>
 <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com> <875ypo5jqi.wl-maz@kernel.org>
In-Reply-To: <875ypo5jqi.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 9 Feb 2022 21:31:49 -0800
Message-ID: <CAAeT=FwF=agQH-2u0fzGL4eUzz5-=6M=zwXiaxyucPf+n_ihxQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Feb 9, 2022 at 4:04 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
>
> On Wed, 09 Feb 2022 05:32:36 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Tue, Feb 8, 2022 at 6:41 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > In [1], I suggested another approach that didn't require extra state,
> > > and moved the existing checks under the kvm lock. What was wrong with
> > > that approach?
> >
> > With that approach, even for a vcpu that has a broken set of features,
> > which leads kvm_reset_vcpu() to fail for the vcpu, the vcpu->arch.features
> > are checked by other vCPUs' vcpu_allowed_register_width() until the
> > vcpu->arch.target is set to -1.
> > Due to this, I would think some or possibly all vCPUs' kvm_reset_vcpu()
> > may or may not fail (e.g. if userspace tries to configure vCPU#0 with
> > 32bit EL1, and vCPU#1 and #2 with 64 bit EL1, KVM_ARM_VCPU_INIT
> > for either vCPU#0, or both vCPU#1 and #2 should fail.  But, with that
> > approach, it doesn't always work that way.  Instead, KVM_ARM_VCPU_INIT
> > for all vCPUs could fail or KVM_ARM_VCPU_INIT for vCPU#0 and #1 could
> > fail while the one for CPU#2 works).
> > Also, even after the first KVM_RUN for vCPUs are already done,
> > (the first) KVM_ARM_VCPU_INIT for another vCPU could cause the
> > kvm_reset_vcpu() for those vCPUs to fail.
> >
> > I would think those behaviors are odd, and I wanted to avoid them.
>
> OK, fair enough. But then you need to remove most of the uses of
> KVM_ARM_VCPU_EL1_32BIT so that it is only used as a userspace
> interface and

Yes, I will.

> maybe not carried as part of the vcpu feature flag anymore.

At the first call of kvm_reset_vcpu() for the guest, the new kvm
flag is not set yet. So, KVM_ARM_VCPU_EL1_32BIT will be needed
by the function (unless we pass the flag as an argument for the
function or by any other way).

> Also, we really should turn all these various bits in the kvm struct
> into a set of flags. I have a patch posted there[1] for this, feel
> free to pick it up.

Thank you for the suggestion. But, kvm->arch.el1_reg_width is not
a binary because it needs to indicate an uninitialized state.  So, it
won't fit perfectly with kvm->arch.flags, which is introduced by [1]
as it is. Of course it's feasible by using 2 bits of the flags though...

Thanks,
Reiji

>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20211004174849.2831548-2-maz@kernel.org
>
> --
> Without deviation from the norm, progress is not possible.
