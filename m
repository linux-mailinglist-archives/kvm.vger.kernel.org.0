Return-Path: <kvm+bounces-6804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505E883A2FD
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 836F11C23653
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5B8171CE;
	Wed, 24 Jan 2024 07:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j14Fku5M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C267168DD;
	Wed, 24 Jan 2024 07:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706081788; cv=none; b=CYuwle92RtJo7CppH1kG8wxA4NlqY8CFq9NPw36ZpKDWejhmFkMUczWq4Bep1r0iQ4K0neco5qrMtn/XBkHizVEGbnKHStTLhM+PVQTVW7zBR6p0jnEyWN5b/ARvRedQngOrAXVlFhELOtFUyaykQuPNgIvxTxRISFzB46UXJu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706081788; c=relaxed/simple;
	bh=LtV2lJtgnwiVmQbeUtkYL0cjel7dINRSK5cU4NbTPYU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q+CuV232WJlNOjbEPHfv43p+JJlM2kCYmkUT1jET7//uGgg2Zl/zpO3grG1EJNLbi+H1E9AAXVfT8synex4WsDR6Hl8AhS3uHDhdMpv0liZxxQ65KwlgNTDrz7uQwDoizKNhP8hYi3mrBU3FgMddX5j01srObNHXFboPK7cTz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j14Fku5M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F0CC433C7;
	Wed, 24 Jan 2024 07:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706081787;
	bh=LtV2lJtgnwiVmQbeUtkYL0cjel7dINRSK5cU4NbTPYU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=j14Fku5MIP7QS3obZiZv85tNEyLdKApuOxrGUo+lZuNiBkZ/t2OUCeO3/pK3U+CUp
	 NvnygqfFatP3hWUNiAhS5bN35oLcLzsKmNlKTTzdv22D74EqpqL8ST0sqYs73nTkRX
	 jJpbC3CPKlcHfLMoCnhKpKrzp1bHOgRSrk5OVjzNA9CYpBtpqXxpk4nKAkPVWpe30V
	 TYJSKX7LAT6mq8y5V6ItglnxSlFnqF6Fg3XGAjAfxDU8cWXauNv7GJCjMgadMksntD
	 ee4NTmnbdLKSaYqkKCoWtREx6vwgL3A0jnvezYzR0stXpYUPtwVA2E2dFEQOSxlgGX
	 qz+c5fuc5K7ZA==
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
	Amit Machhiwal <amit.machhiwal@ibm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to
 empty 'arch_compat'
In-Reply-To: <20240118095653.2588129-1-amachhiw@linux.ibm.com>
References: <20240118095653.2588129-1-amachhiw@linux.ibm.com>
Date: Wed, 24 Jan 2024 13:06:19 +0530
Message-ID: <87v87jp4i4.fsf@kernel.org>
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
>
> This patch updates kvmppc_set_arch_compat() to use the host PVR value if
> 'compat_pvr' == 0 indicating that qemu doesn't want to enforce any
> specific PVR compat mode.
>
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c          |  2 +-
>  arch/powerpc/kvm/book3s_hv_nestedv2.c | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1ed6ec140701..9573d7f4764a 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -439,7 +439,7 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  	if (guest_pcr_bit > host_pcr_bit)
>  		return -EINVAL;
>  
> -	if (kvmhv_on_pseries() && kvmhv_is_nestedv2()) {
> +	if (kvmhv_on_pseries() && kvmhv_is_nestedv2() && arch_compat) {
>  		if (!(cap & nested_capabilities))
>  			return -EINVAL;
>  	}
>

Instead of that arch_compat check, would it better to do

	if (kvmhv_on_pseries() && kvmhv_is_nestedv2()) {
		if (cap && !(cap & nested_capabilities))
			return -EINVAL;
	}

ie, if a capability is requested, then check against nested_capbilites
to see if the capability exist.



> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> index fd3c4f2d9480..069a1fcfd782 100644
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
> @@ -347,8 +348,15 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  			break;
>  		}
>  		case KVMPPC_GSID_LOGICAL_PVR:
> -			rc = kvmppc_gse_put_u32(gsb, iden,
> -						vcpu->arch.vcore->arch_compat);
> +			if (!vcpu->arch.vcore->arch_compat) {
> +				if (cpu_has_feature(CPU_FTR_ARCH_31))
> +					arch_compat = PVR_ARCH_31;
> +				else if (cpu_has_feature(CPU_FTR_ARCH_300))
> +					arch_compat = PVR_ARCH_300;
> +			} else {
> +				arch_compat = vcpu->arch.vcore->arch_compat;
> +			}
> +			rc = kvmppc_gse_put_u32(gsb, iden, arch_compat);
>

Won't a arch_compat = 0 work here?. ie, where you observing the -EINVAL from
the first hunk or does this hunk have an impact? 

>  			break;
>  		}
>  
> -- 
> 2.43.0

-aneesh

