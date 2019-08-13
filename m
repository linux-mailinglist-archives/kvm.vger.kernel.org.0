Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3968B8A0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfHMMfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:35:09 -0400
Received: from 8.mo179.mail-out.ovh.net ([46.105.75.26]:40605 "EHLO
        8.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbfHMMfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:35:09 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2019 08:35:07 EDT
Received: from player728.ha.ovh.net (unknown [10.109.159.222])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 5C29A13E876
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 14:18:41 +0200 (CEST)
Received: from kaod.org (lfbn-1-2240-157.w90-76.abo.wanadoo.fr [90.76.60.157])
        (Authenticated sender: clg@kaod.org)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id 5823B8BF0F57;
        Tue, 13 Aug 2019 12:18:35 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] KVM: PPC: Book3S HV: Don't push XIVE context when
 not using XIVE device
To:     Paul Mackerras <paulus@ozlabs.org>, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20190813095845.GA9567@blackberry>
 <20190813100100.GC9567@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <d8435ea8-cfa5-9a3b-b081-b5541b6052b3@kaod.org>
Date:   Tue, 13 Aug 2019 14:18:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813100100.GC9567@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12295108461400460262
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedggeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2019 12:01, Paul Mackerras wrote:
> At present, when running a guest on POWER9 using HV KVM but not using
> an in-kernel interrupt controller (XICS or XIVE), for example if QEMU
> is run with the kernel_irqchip=off option, the guest entry code goes
> ahead and tries to load the guest context into the XIVE hardware, even
> though no context has been set up.
> 
> To fix this, we check that the "CAM word" is non-zero before pushing
> it to the hardware.  The CAM word is initialized to a non-zero value
> in kvmppc_xive_connect_vcpu() and kvmppc_xive_native_connect_vcpu(),
> and is now cleared in kvmppc_xive_{,native_}cleanup_vcpu.

If a "CAM word" is defined, it means the vCPU (VP) was enabled at the
XIVE HW level. So this is the criteria to consider that a vCPU needs
to update (push) its XIVE thread interrupt context when scheduled
to run.


Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> 
> Cc: stable@vger.kernel.org # v4.11+
> Reported-by: Cédric Le Goater <clg@kaod.org>
> Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 ++
>  arch/powerpc/kvm/book3s_xive.c          | 11 ++++++++++-
>  arch/powerpc/kvm/book3s_xive_native.c   |  3 +++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 2e7e788..07181d0 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -942,6 +942,8 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
>  	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
>  	li	r9, TM_QW1_OS
>  	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
> +	cmpwi	r8, 0
> +	beq	no_xive
>  	li	r7, TM_QW1_OS + TM_WORD2
>  	mfmsr	r0
>  	andi.	r0, r0, MSR_DR		/* in real mode? */
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index 09f838a..586867e 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -67,8 +67,14 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
>  	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
>  	u64 pq;
>  
> -	if (!tima)
> +	/*
> +	 * Nothing to do if the platform doesn't have a XIVE
> +	 * or this vCPU doesn't have its own XIVE context
> +	 * (e.g. because it's not using an in-kernel interrupt controller).
> +	 */
> +	if (!tima || !vcpu->arch.xive_cam_word)
>  		return;
> +
>  	eieio();
>  	__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
>  	__raw_writel(vcpu->arch.xive_cam_word, tima + TM_QW1_OS + TM_WORD2);
> @@ -1146,6 +1152,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
>  	/* Disable the VP */
>  	xive_native_disable_vp(xc->vp_id);
>  
> +	/* Clear the cam word so guest entry won't try to push context */
> +	vcpu->arch.xive_cam_word = 0;
> +
>  	/* Free the queues */
>  	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
>  		struct xive_q *q = &xc->queues[i];
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 368427f..11b91b4 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -81,6 +81,9 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
>  	/* Disable the VP */
>  	xive_native_disable_vp(xc->vp_id);
>  
> +	/* Clear the cam word so guest entry won't try to push context */
> +	vcpu->arch.xive_cam_word = 0;
> +
>  	/* Free the queues */
>  	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
>  		kvmppc_xive_native_cleanup_queue(vcpu, i);
> 

