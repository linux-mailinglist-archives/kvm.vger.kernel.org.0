Return-Path: <kvm+bounces-8021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 577B4849C0F
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 14:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C15A61F24D5E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78C6210E6;
	Mon,  5 Feb 2024 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kmh8xrCS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0191720DC8;
	Mon,  5 Feb 2024 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707140373; cv=none; b=AnPqe3rwKUzgSJVNxdNEsDh9ZMHggMmc1WBwZfBf+Lx/2FXTFtMFtyH+jo5JeGHUey0VA9wL5VexqBpJTusuMTHeJf1oMVg/nUslonwK0W8Qh+zwV3A2bPaSsWfXE38DMFBtK/J/3XjGPvbc71lHS6i3U0L2dCyAPAspcvDzDrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707140373; c=relaxed/simple;
	bh=jYL0WlN0JFknygqVRceY0Io+Uft9euKFIpXTFZDsbYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hAVXDQxDQWEub9ej7N6MH7SESlJKSPbLyNlxyOukhOSPVt5Axy167OkQOXgvNgVCk8tEi/evruQmWMedVINfQ5C2o1wA9uNSU6S/2WS2CgFCpG0II1iUwRo+uCscsB5AtpuTNQbjjvgeyp2stcMU8AnyyDR1XmHQeFpWi4szF7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kmh8xrCS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8939C433C7;
	Mon,  5 Feb 2024 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707140372;
	bh=jYL0WlN0JFknygqVRceY0Io+Uft9euKFIpXTFZDsbYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Kmh8xrCSjmzqIQgS3kcpFKRPfXqeeZAJDkQo+FiQic4cvVlxS0lVtYQT5N/YhCazx
	 IVGbQBFjHKmhinN9e2GrOC1pQF9hBaCM5uXf0+3tADwoBh/jnEYelnxxuYzsISiqLT
	 8MEvoEQGweVPLT7vbiqjYj5Eyzn+iptLdm9YiaCwKKifCR9DJWt7YxXNi1LOBz6ASv
	 IoIXYf4Rv4W7M6BdMRCRq1d6lzZ9zEIu00sQ/PTqhiMV/baGF0w88muOXy/E7ATHn8
	 IUCtCNFz7slyor5zIgyUNpQP7cA77f7S0DHBllhAc5g/TercIYVn/mo3vB0hChFGY5
	 8nGDgwxl7qF6Q==
X-Mailer: emacs 29.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Amit Machhiwal <amachhiw@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jordan Niethe <jniethe5@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
	"Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due
 to empty 'arch_compat'
In-Reply-To: <20240205132607.2776637-1-amachhiw@linux.ibm.com>
References: <20240205132607.2776637-1-amachhiw@linux.ibm.com>
Date: Mon, 05 Feb 2024 19:09:24 +0530
Message-ID: <87sf2758tv.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Amit Machhiwal <amachhiw@linux.ibm.com> writes:

> Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
> below error as L1 qemu sends PVR value 'arch_compat' == 0 via
> ppc_set_compat ioctl. This triggers a condition failure in
> kvmppc_set_arch_compat() resulting in an EINVAL.
>
> qemu-system-ppc64: Unable to set CPU compatibility mode in KVM: Invalid
> argument
>
> Also, a value of 0 for arch_compat generally refers the default
> compatibility of the host. But, arch_compat, being a Guest Wide Element
> in nested API v2, cannot be set to 0 in GSB as PowerVM (L0) expects a
> non-zero value. A value of 0 triggers a kernel trap during a reboot and
> consequently causes it to fail:
>
> [   22.106360] reboot: Restarting system
> KVM: unknown exit, hardware reason ffffffffffffffea
> NIP 0000000000000100   LR 000000000000fe44 CTR 0000000000000000 XER 0000000020040092 CPU#0
> MSR 0000000000001000 HID0 0000000000000000  HF 6c000000 iidx 3 didx 3
> TB 00000000 00000000 DECR 0
> GPR00 0000000000000000 0000000000000000 c000000002a8c300 000000007fe00000
> GPR04 0000000000000000 0000000000000000 0000000000001002 8000000002803033
> GPR08 000000000a000000 0000000000000000 0000000000000004 000000002fff0000
> GPR12 0000000000000000 c000000002e10000 0000000105639200 0000000000000004
> GPR16 0000000000000000 000000010563a090 0000000000000000 0000000000000000
> GPR20 0000000105639e20 00000001056399c8 00007fffe54abab0 0000000105639288
> GPR24 0000000000000000 0000000000000001 0000000000000001 0000000000000000
> GPR28 0000000000000000 0000000000000000 c000000002b30840 0000000000000000
> CR 00000000  [ -  -  -  -  -  -  -  -  ]     RES 000@ffffffffffffffff
>  SRR0 0000000000000000  SRR1 0000000000000000    PVR 0000000000800200 VRSAVE 0000000000000000
> SPRG0 0000000000000000 SPRG1 0000000000000000  SPRG2 0000000000000000  SPRG3 0000000000000000
> SPRG4 0000000000000000 SPRG5 0000000000000000  SPRG6 0000000000000000  SPRG7 0000000000000000
> HSRR0 0000000000000000 HSRR1 0000000000000000
>  CFAR 0000000000000000
>  LPCR 0000000000020400
>  PTCR 0000000000000000   DAR 0000000000000000  DSISR 0000000000000000
>
>  kernel:trap=0xffffffea | pc=0x100 | msr=0x1000
>
> This patch updates kvmppc_set_arch_compat() to use the host PVR value if
> 'compat_pvr' == 0 indicating that qemu doesn't want to enforce any
> specific PVR compat mode.
>

Reviewed-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>

>
> Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
> ---
>
> Changes v1 -> v2:
>     - Added descriptive error log in the patch description when
>       `arch_compat == 0` passed in GSB
>     - Added a helper function for PCR to capabilities mapping
>     - Added relevant comments around the changes being made
>
> v1: https://lore.kernel.org/lkml/20240118095653.2588129-1-amachhiw@linux.ibm.com/
>
>  arch/powerpc/kvm/book3s_hv.c          | 25 +++++++++++++++++++++++--
>  arch/powerpc/kvm/book3s_hv_nestedv2.c | 23 +++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 52427fc2a33f..270ab9cf9a54 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -391,6 +391,23 @@ static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
>  /* Dummy value used in computing PCR value below */
>  #define PCR_ARCH_31    (PCR_ARCH_300 << 1)
>  
> +static inline unsigned long map_pcr_to_cap(unsigned long pcr)
> +{
> +	unsigned long cap = 0;
> +
> +	switch (pcr) {
> +	case PCR_ARCH_300:
> +		cap = H_GUEST_CAP_POWER9;
> +		break;
> +	case PCR_ARCH_31:
> +		cap = H_GUEST_CAP_POWER10;
> +	default:
> +		break;
> +	}
> +
> +	return cap;
> +}
> +
>  static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  {
>  	unsigned long host_pcr_bit = 0, guest_pcr_bit = 0, cap = 0;
> @@ -424,11 +441,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  			break;
>  		case PVR_ARCH_300:
>  			guest_pcr_bit = PCR_ARCH_300;
> -			cap = H_GUEST_CAP_POWER9;
>  			break;
>  		case PVR_ARCH_31:
>  			guest_pcr_bit = PCR_ARCH_31;
> -			cap = H_GUEST_CAP_POWER10;
>  			break;
>  		default:
>  			return -EINVAL;
> @@ -440,6 +455,12 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  		return -EINVAL;
>  
>  	if (kvmhv_on_pseries() && kvmhv_is_nestedv2()) {
> +		/*
> +		 * 'arch_compat == 0' would mean the guest should default to
> +		 * L1's compatibility. In this case, the guest would pick
> +		 * host's PCR and evaluate the corresponding capabilities.
> +		 */
> +		cap = map_pcr_to_cap(guest_pcr_bit);
>  		if (!(cap & nested_capabilities))
>  			return -EINVAL;
>  	}
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> index 5378eb40b162..6042bdc70230 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -138,6 +138,7 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  	vector128 v;
>  	int rc, i;
>  	u16 iden;
> +	u32 arch_compat = 0;
>  
>  	vcpu = gsm->data;
>  
> @@ -347,8 +348,26 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  			break;
>  		}
>  		case KVMPPC_GSID_LOGICAL_PVR:
> -			rc = kvmppc_gse_put_u32(gsb, iden,
> -						vcpu->arch.vcore->arch_compat);
> +			/*
> +			 * Though 'arch_compat == 0' would mean the default
> +			 * compatibility, arch_compat, being a Guest Wide
> +			 * Element, cannot be filled with a value of 0 in GSB
> +			 * as this would result into a kernel trap.
> +			 * Hence, when `arch_compat == 0`, arch_compat should
> +			 * default to L1's PVR.
> +			 *
> +			 * Rework this when PowerVM supports a value of 0
> +			 * for arch_compat for KVM API v2.
> +			 */
> +			if (!vcpu->arch.vcore->arch_compat) {
> +				if (cpu_has_feature(CPU_FTR_ARCH_31))
> +					arch_compat = PVR_ARCH_31;
> +				else if (cpu_has_feature(CPU_FTR_ARCH_300))
> +					arch_compat = PVR_ARCH_300;
> +			} else {
> +				arch_compat = vcpu->arch.vcore->arch_compat;
> +			}
> +			rc = kvmppc_gse_put_u32(gsb, iden, arch_compat);
>  			break;
>  		}
>  
>
> base-commit: 6764c317b6bb91bd806ef79adf6d9c0e428b191e
> -- 
> 2.43.0

