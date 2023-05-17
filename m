Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4DB70704E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjEQSA1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 17 May 2023 14:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEQSA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 14:00:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D294D213B
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 11:00:23 -0700 (PDT)
Received: from kwepemm600006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QM13m5xglzTkfy;
        Thu, 18 May 2023 01:55:32 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 kwepemm600006.china.huawei.com (7.193.23.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 02:00:20 +0800
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.023;
 Wed, 17 May 2023 19:00:18 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: RE: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Topic: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Index: AQHZZwvyoTfThYxWf0yKNVt4c9uQr68cQ2uAgABJ1QCAQm5ckA==
Date:   Wed, 17 May 2023 18:00:18 +0000
Message-ID: <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
        <20230404154050.2270077-9-oliver.upton@linux.dev>
        <87o7o26aty.wl-maz@kernel.org> <86pm8iv8tj.wl-maz@kernel.org>
In-Reply-To: <86pm8iv8tj.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
Sorry for jumping late. I am updating the Qemu code for the VCPU hotplug
to reflect Oliver's SMCCC filtering changes and I have few doubts.

Please scroll below.

> From: Marc Zyngier <maz@kernel.org>
> Sent: Wednesday, April 5, 2023 12:59 PM
> To: Oliver Upton <oliver.upton@linux.dev>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org; Paolo Bonzini
> <pbonzini@redhat.com>; James Morse <james.morse@arm.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>; yuzenghui <yuzenghui@huawei.com>; Sean
> Christopherson <seanjc@google.com>; Salil Mehta <salil.mehta@huawei.com>
> Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for
> KVM_EXIT_HYPERCALL
> 
> On Wed, 05 Apr 2023 08:35:05 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 04 Apr 2023 16:40:45 +0100,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > In anticipation of user hypercall filters, add the necessary plumbing to
> > > get SMCCC calls out to userspace. Even though the exit structure has
> > > space for KVM to pass register arguments, let's just avoid it altogether
> > > and let userspace poke at the registers via KVM_GET_ONE_REG.
> > >
> > > This deliberately stretches the definition of a 'hypercall' to cover
> > > SMCs from EL1 in addition to the HVCs we know and love. KVM doesn't
> > > support EL1 calls into secure services, but now we can paint that as a
> > > userspace problem and be done with it.
> > >
> > > Finally, we need a flag to let userspace know what conduit instruction
> > > was used (i.e. SMC vs. HVC).
> > >
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  Documentation/virt/kvm/api.rst    | 18 ++++++++++++++++--
> > >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> > >  arch/arm64/kvm/handle_exit.c      |  4 +++-
> > >  arch/arm64/kvm/hypercalls.c       | 16 ++++++++++++++++
> > >  4 files changed, 39 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst  b/Documentation/virt/kvm/api.rst
> > > index 9b01e3d0e757..9497792c4ee5 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -6221,11 +6221,25 @@ to the byte array.
> > >  			__u64 flags;
> > >  		} hypercall;
> > >
> > > -Unused.  This was once used for 'hypercall to userspace'.  To  implement
> > > -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> > > +
> > > +It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
> > > +``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
> > > +requires a guest to interact with host userpace.
> > >
> > >  .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
> > >
> > > +For arm64:
> > > +----------
> > > +
> > > +``nr`` contains the function ID of the guest's SMCCC call. Userspace is
> > > +expected to use the ``KVM_GET_ONE_REG`` ioctl to retrieve the call
> > > +parameters from the vCPU's GPRs.
> > > +
> > > +Definition of ``flags``:
> > > + - ``KVM_HYPERCALL_EXIT_SMC``: Indicates that the guest used the SMC
> > > +   conduit to initiate the SMCCC call. If this bit is 0 then the guest
> > > +   used the HVC conduit for the SMCCC call.
> > > +
> > >  ::
> > >
> > >  		/* KVM_EXIT_TPR_ACCESS */
> > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > index f9672ef1159a..f86446c5a7e3 100644
> > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > @@ -472,12 +472,16 @@ enum {
> > >  enum kvm_smccc_filter_action {
> > >  	KVM_SMCCC_FILTER_HANDLE = 0,
> > >  	KVM_SMCCC_FILTER_DENY,
> > > +	KVM_SMCCC_FILTER_FWD_TO_USER,
> > >
> > >  #ifdef __KERNEL__
> > >  	NR_SMCCC_FILTER_ACTIONS
> > >  #endif
> > >  };
> > >
> > > +/* arm64-specific KVM_EXIT_HYPERCALL flags */
> > > +#define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
> > > +
> > >  #endif
> > >
> > >  #endif /* __ARM_KVM_H__ */
> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 68f95dcd41a1..3f43e20c48b6 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -71,7 +71,9 @@ static int handle_smc(struct kvm_vcpu *vcpu)
> > >  	 * Trap exception, not a Secure Monitor Call exception [...]"
> > >  	 *
> > >  	 * We need to advance the PC after the trap, as it would
> > > -	 * otherwise return to the same address...
> > > +	 * otherwise return to the same address. Furthermore, pre-incrementing
> > > +	 * the PC before potentially exiting to userspace maintains the same
> > > +	 * abstraction for both SMCs and HVCs.
> >
> > nit: this comment really needs to find its way in the documentation so
> > that a VMM author can determine the PC of the SMC/HVC. This is
> > specially important for 32bit, which has a 16bit encodings for
> > SMC/HVC.
> >
> > And thinking of it, this outlines a small flaw in this API. If
> > luserspace needs to find out about the address of the HVC/SMC, it
> > needs to know the *size* of the instruction. But we don't propagate
> > the ESR value. I think this still works by construction (userspace can
> > check PSTATE and work out whether we're in ARM or Thumb mode), but
> > this feels fragile.
> >
> > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > flag?


I think we would need "Immediate value" of the ESR_EL2 register in the
user-space/VMM to be able to construct the syndrome value. I cannot see
where it is being sent? 

Please correct me if I am missing anything here.


> Just to make this a quicker round trip, I hacked the following
> together. If you agree with it, I'll stick it on top and get the ball
> rolling.
> 
> Thanks,
> 
> 	M.
> 
> From 9b830e7a3819c2771074bebe66c1d5f20394e3cc Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 5 Apr 2023 12:48:58 +0100
> Subject: [PATCH] KVM: arm64: Expose SMC/HVC width to userspace
> 
> When returning to userspace to handle a SMCCC call, we consistently
> set PC to point to the instruction immediately after the HVC/SMC.
> 
> However, should userspace need to know the exact address of the
> trapping instruction, it needs to know about the *size* of that
> instruction. For AArch64, this is pretty easy. For AArch32, this
> is a bit more funky, as Thumb has 16bit encodings for both HVC
> and SMC.
> 
> Expose this to userspace with a new flag that directly derives
> from ESR_EL2.IL. Also update the documentation to reflect the PC
> state at the point of exit.
> 
> Finally, this fixes a small buglet where the hypercall.{args,ret}
> fields would not be cleared on exit, and could contain some
> random junk.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/api.rst    |  8 ++++++++
>  arch/arm64/include/uapi/asm/kvm.h |  3 ++-
>  arch/arm64/kvm/hypercalls.c       | 16 +++++++++++-----
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst
> b/Documentation/virt/kvm/api.rst
> index c8ab2f730945..103f945959ed 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6244,6 +6244,14 @@ Definition of ``flags``:
>     conduit to initiate the SMCCC call. If this bit is 0 then the guest
>     used the HVC conduit for the SMCCC call.
> 
> + - ``KVM_HYPERCALL_EXIT_16BIT``: Indicates that the guest used a 16bit
> +   instruction to initiate the SMCCC call. If this bit is 0 then the
> +   guest used a 32bit instruction. An AArch64 guest always has this
> +   bit set to 0.
> +
> +At the point of exit, PC points to the instruction immediately following
> +the trapping instruction.
> +
>  ::
> 
>  		/* KVM_EXIT_TPR_ACCESS */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h
> b/arch/arm64/include/uapi/asm/kvm.h
> index 3dcfa4bfdf83..b1c1edf85480 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -491,7 +491,8 @@ struct kvm_smccc_filter {
>  };
> 
>  /* arm64-specific KVM_EXIT_HYPERCALL flags */
> -#define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
> +#define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
> +#define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
> 
>  #endif
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 9a35d6d18193..3b6523f25afc 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -222,13 +222,19 @@ static void kvm_prepare_hypercall_exit(struct
> kvm_vcpu *vcpu, u32 func_id)
>  {
>  	u8 ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
>  	struct kvm_run *run = vcpu->run;
> -
> -	run->exit_reason = KVM_EXIT_HYPERCALL;
> -	run->hypercall.nr = func_id;
> -	run->hypercall.flags = 0;
> +	u64 flags = 0;
> 
>  	if (ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64)
> -		run->hypercall.flags |= KVM_HYPERCALL_EXIT_SMC;
> +		flags |= KVM_HYPERCALL_EXIT_SMC;
> +
> +	if (!kvm_vcpu_trap_il_is32bit(vcpu))
> +		flags |= KVM_HYPERCALL_EXIT_16BIT;
> +
> +	run->exit_reason = KVM_EXIT_HYPERCALL;
> +	run->hypercall = (typeof(run->hypercall)) {
> +		.nr	= func_id,


Earlier this was the place holder for the "immediate value"

Best regards
Salil
