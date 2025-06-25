Return-Path: <kvm+bounces-50699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D1EAE866E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF78C4A3E55
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B28265CC5;
	Wed, 25 Jun 2025 14:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXKF5nIu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF02263C9B
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750861624; cv=none; b=tsdyhd105VpG87yWmGCKUhojB+6zEZ53OoTpVhijSergWGrsj2Q5z6Xixc6/gnRYyNUEnZEHQVyQ4MK11XRx0hRpK7TnVFKXmf9uXY68nO9HNf/f+YY7wAyftjHvayfjj0rmg9thFpnri5AhQRPkPHkXmE2KmUZpNBuSI1po1n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750861624; c=relaxed/simple;
	bh=LvLnzyr3vAZjpdtmYQn4wwkLh2F0NDzqxwVEWNjNVo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CAi5pFX8oaRkw9Mm3GYCyk26oiQVnFQiCVxgFPj05zlDC9FHvfMZE+DPtBQ1HiTxa8jxTxCulRvVLntkXdRuS+EMh3PXNgYKMXX9XNoU7sbgTHeXuBhBs8iz6Ux8UQR1NABgtyplECXbf21lFVB8ryXBXBK2Cxn+eYyJ7iTxDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXKF5nIu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af08594fso4600782a91.2
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750861622; x=1751466422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LqVMdCAZAey66o/1p6aeh7UwiWAEI36u9H2rba3E01Q=;
        b=oXKF5nIuWxSeFAogeHckOFpAvo8G1bm/q45QaGV2t11VZLP2bFNZ23s7e4VeVToxBT
         l+Hxv6GNfUn8Y15A7BQMY1pwZgrKp63GFwu7xvh1CzwKLCZS2sL8AwdSKs36Colat3MH
         om65nf+FjSTiL3n7qyGY58ShJ9fZTpOQp/G+NjdwbK1/+Fgr5fqf6c2lVSdt1qq8kN4E
         MS9qmgCkKDGgaH7d/b19a9nuU5cwH0LkWKQ+piylbZctp/fpHCgF6Wt5oDm0EEtWF126
         aeWKB0SK1bzc2OHsec+gKctzqBdEDWitAHJekSu+iLMznCwocVO1jtmzwRQ+XIMl4Yb3
         st1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750861622; x=1751466422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LqVMdCAZAey66o/1p6aeh7UwiWAEI36u9H2rba3E01Q=;
        b=b/wLSyNWQlrfOCcmeQq1hRX4ONyBNmadCd7zN9o1FnTqic0wvUtzZF7SmpxgGxNTh5
         cEvJ6RTkpAODnWLfkSS/AcWVIpOucIR+XAn57JjjLzD+PzBBqKPPN+PAdmVpuTj9mbe5
         nElo0MuGdEVZg0mxOZdfaazX0L5xECHVm0F6DWzee7hxey5BQC1Znn82/byK8jnuaWru
         yTjFz9KYpfKzQNPD+XL7ZWNf/3d5aG1pTN+PaR8oJWgoG6lS051zX9t/XUkA+XWtUkes
         /WlxVhVoIVGGgEic2FaaTvlhXuqp2ZjJN55NGmNI+ijHcJ+QWZdqMmKKcTQZibQAjuFT
         7WHg==
X-Forwarded-Encrypted: i=1; AJvYcCWJD4bO+Jp9UsfQaSwC9lyiN84TFZjxM+rLkaiqy6RZAbME1cFo6YiL/FcoOypufodCu0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbNZmM4UJsdv4ciOBDq7kfwI/m3itjXYzSJNIfwUqjTUKDc17W
	IKtztEOgd3CdY56yRxMMp/U0/SMV/6sMBwADyRK8QKSGFgVjT40ilEms0LZu/+nas2uuYde4L/t
	yVRrE+A==
X-Google-Smtp-Source: AGHT+IFvtXdOzEa1J5d/MjZviYWBVd/F026YGiyeNlLCIhwIcJz6LGFpk1sJXrklT9EXqYs7gJe9H6WjCuE=
X-Received: from pjbnd12.prod.google.com ([2002:a17:90b:4ccc:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574d:b0:312:f0d0:bc4
 with SMTP id 98e67ed59e1d1-315f25e3026mr4648024a91.5.1750861621801; Wed, 25
 Jun 2025 07:27:01 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:27:00 -0700
In-Reply-To: <20250408093213.57962-5-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250408093213.57962-1-nikunj@amd.com> <20250408093213.57962-5-nikunj@amd.com>
Message-ID: <aFwHNNJXCrAzCGci@google.com>
Subject: Re: [PATCH v6 4/4] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com
Content-Type: text/plain; charset="us-ascii"

The previous patch to add GUEST_TSC_FREQ needs to squashed with this patch.  It's
impossible to review the snp_secure_tsc_enabled() logic in particular without the
details added in this patch.

And once you rebase on kvm-x86 next (i.e. the MSR interception rework), adding
support for GUEST_TSC_FREQ will be like three lines of code, i.e. not worth
landing in a separate patch.

On Tue, Apr 08, 2025, Nikunj A Dadhania wrote:
> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> 
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests.
> 
> As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
> should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
> the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.
> 
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>  arch/x86/kvm/svm/sev.c          | 15 ++++++++++++++-
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 460306b35a4b..075af0dcee25 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -839,7 +839,8 @@ struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
>  	__u16 flags;
> -	__u8 pad0[6];
> +	__u8 pad0[2];
> +	__u32 desired_tsc_khz;
>  	__u64 pad1[4];
>  };
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 50263b473f95..bcb262ff42bb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2205,6 +2205,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		if (!kvm->arch.default_tsc_khz)

Hmm, so there's an existing flaw related to the TSC frequency.  Ideally, KVM
shouldn't allow KVM_SET_TSC_KHZ on a vCPU with a "secure" TSC, i.e. on a TDX
vCPU or on a newfangled SNP vCPU.  I'm not sure that's worth addressing though,
because it doesn't put KVM in any danger, it can only cause problems for guest
timing.  Yeah, I guess we leave it, because it's not really any different than
enumerating a TSC frequency in CPUID 0x15 and then telling KVM something
different.

> +			return -EINVAL;
> +
> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2445,7 +2453,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  			return ret;
>  		}
>  
> -		svm->vcpu.arch.guest_state_protected = true;
> +		vcpu->arch.guest_state_protected = true;
> +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
> +
>  		/*
>  		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
>  		 * be _always_ ON. Enable it only after setting
> @@ -3059,6 +3069,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;

I don't see anything in here that prevents userspace from stuffing SECURE_TSC
into vmsa_features, which means the WARN_ON_ONCE() in snp_secure_tsc_enabled is
user-triggerable.

Unless I'm missing something, this need to do something like:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 45283a2d8c4a..09044f2524c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -405,9 +405,13 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
        struct sev_platform_init_args init_args = {0};
        bool es_active = vm_type != KVM_X86_SEV_VM;
+       bool snp_active = vm_type -= KVM_X86_SNP_VM;
        u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
        int ret;
 
+       if (!snp_active)
+               valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+
        if (kvm->created_vcpus)
                return -EINVAL;
 
@@ -436,7 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        if (sev->es_active && !sev->ghcb_version)
                sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
-       if (vm_type == KVM_X86_SNP_VM)
+       if (snp_active)
                sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
        ret = sev_asid_new(sev);
@@ -449,7 +453,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
                goto e_free;
 
        /* This needs to happen after SEV/SNP firmware initialization. */
-       if (vm_type == KVM_X86_SNP_VM) {
+       if (snp_active) {
                ret = snp_guest_req_init(kvm);
                if (ret)
                        goto e_free;

