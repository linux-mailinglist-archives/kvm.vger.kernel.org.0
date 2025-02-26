Return-Path: <kvm+bounces-39295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26023A46429
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 16:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB3BB3A8BEB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354882248BF;
	Wed, 26 Feb 2025 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0kA2XlS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0852222AC
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740582591; cv=none; b=j1RhHFDRfGWCcA+WZdrt8FP783EQA0UxL3D9UfKKzANKh3yfQt291pR1WVI9t3GKfkcYQpKxcbSm0UkwLG3Xch9TlSRRZDpBwLdcg40ST+W7L+ncQeW6SEJjyM1xjapidb6EqqeE5tYDhzvbaLUdNwBQ5IyENZTDm75phx+PO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740582591; c=relaxed/simple;
	bh=f+JcHykjxTZFTDq/eT/tHmhbgQ7PgeB7/sVSehqyJsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eE+9cvHtn33uJq2MUa1NIkpImaNrhe6vxj+xTDFSW//MdKsDBYK/Sb8t/XZZWGgLs7IuixdMfkSKJpuugaB75OA+RpB12dlMaRcwNWZhP5LEqckHXqkTm7RyYrGEAFju1VldduafO++1CKWTA0ekFAMUesTes8gLeaouq6xrnCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q0kA2XlS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc46431885so22452568a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 07:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740582589; x=1741187389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnUeBhYFrXtRVAE+1VSkjnuyhs0+AJ9A1kP+9+KXHxQ=;
        b=q0kA2XlSZ9C2JmEpGgHdcvPgPy8Omfs8EQ8w7FmkaYD3RpkIQUsrFWknH5Il5bLjb5
         /q6B/kn3Vg7oSGf7ZMGJVbYa31yKjAPH+hNnpJ9DhyU/VOv6ezz9ZhnXaH6J2Jy4k7Ie
         7sqPywAKTEXzJussumbDiWAzCvhahJdo9Yks07rzl1MeWYrF55uTRnvwIl8aoiPY4JeL
         auyB38pd715U+bw0b0WQ4BlvlUmtKki/MKm6O3U39NeA8L5Ttq4cKnoO3FBucHiBdWPG
         RKzeb6uqNBaA1JTv+AsaWmbT3MzdbOZJ+ZlndwtwlfRi7Brne1XM+ELXMDExJUPcv8At
         gnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740582589; x=1741187389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnUeBhYFrXtRVAE+1VSkjnuyhs0+AJ9A1kP+9+KXHxQ=;
        b=Y9DP2OujjA7PG51iUXjTGPYWf81ueTdgrqWbco/D6ycuAiwj9lJpECm/eqlAF7Zh9n
         eCWHIuyJ7BFFEegOv84N9wMO+MudmtviR3sMdLCWqWUYNJnYb8vGTD64eK9Acx6KZc++
         BqPzONQgK4x/PU1NhtUvShLqN33Wme5miLuX0BSUrlklMABGo0UYjF1le68OYymRahsx
         u7cZC1sqdR1klChM3StG4JO5z8kxeLEOAnDA2QiybQBSP2HaITGpuJOxm2SLi/y2aOqq
         d0c7xEFXbr/1x612a3t7nBPc0jRHft4VpDMyZeyil7bkLgh/ea0mjDkpkiC+wsy2Jkjh
         wGZw==
X-Gm-Message-State: AOJu0YxOmDqWHgG+DzLFMsKUIxi83UVe1y3h9wv/eNJlbbQbMnNpyRs6
	f/xmwBPMvK8RgyshfroD2TgGMwe654aLxpEPsiQHF9LLAdnHxPQ5kRK5AVU+nc8EDUQKlqL+k47
	pwg==
X-Google-Smtp-Source: AGHT+IF/YoeAp4u44Kx7Qnv7VmCTpIY9TSm7LKVpQs02ER1hKMoo9615p3CL8zyHuinzZmAK+WeeMrcPMdQ=
X-Received: from pjboh8.prod.google.com ([2002:a17:90b:3a48:b0:2fc:2b96:2d4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c05:b0:2ef:2d9f:8e58
 with SMTP id 98e67ed59e1d1-2fce8744b89mr28668780a91.34.1740582588967; Wed, 26
 Feb 2025 07:09:48 -0800 (PST)
Date: Wed, 26 Feb 2025 07:09:47 -0800
In-Reply-To: <20250219151505.3538323-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219151505.3538323-1-michael.roth@amd.com> <20250219151505.3538323-2-michael.roth@amd.com>
Message-ID: <Z78uu3VNoIu48--7@google.com>
Subject: Re: [PATCH v5 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	pankaj.gupta@amd.com, dionnaglaze@google.com, huibo.wang@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 19, 2025, Michael Roth wrote:
> +  - If the supplied number of pages is sufficient, userspace must write
> +    the certificate table blob (in the format defined by the GHCB spec)
> +    into the address corresponding to `gfn` and set `ret` to 0 to indicate
> +    success. If no certificate data is available, then userspace can
> +    either write an empty certificate table into the address corresponding
> +    to `gfn`, or it can disable ``KVM_EXIT_SNP_REQ_CERTS`` (via
> +    ``KVM_CAP_EXIT_SNP_REQ_CERTS``), in which case KVM will handle

This doesn't match the code.  As is, KVM only allows *enabling* cert requests.
Userspace can only "disable" cert requests by doing nothing.

> +    returning an empty certificate table to the guest.
> +
> +  - If the number of pages supplied is not sufficient, userspace must set
> +    the required number of pages in `npages` and then set `ret` to
> +    ``ENOSPC``.
> +
> +  - If the certificate cannot be immediately provided, userspace should set
> +    `ret` to ``EAGAIN``, which will inform the guest to retry the request
> +    later. One scenario where this would be useful is if the certificate
> +    is in the process of being updated and cannot be fetched until the
> +    update completes (see the NOTE below regarding how file-locking can
> +    be used to orchestrate such updates between management/guests).
> +
> +  - If some other error occurred, userspace must set `ret` to ``EIO``.
> +    (This is to reserve special meaning for unused error codes in the
> +    future.)

I would phrase this differently, and say that KVM responds with -1 (or whatever
the generic KVM-defined error value is) to the guest if ret is set to EIO, and
then state that all other "return" values are reserved.  Because EIO isn't a
placeholder, it's full on ABI once this lands.

> +8.42 KVM_CAP_EXIT_SNP_REQ_CERTS
> +-------------------------------
> +
> +:Capability: KVM_CAP_EXIT_SNP_REQ_CERTS
> +:Architectures: x86
> +:Type: vm
> +
> +This capability, if enabled, will cause KVM to exit to userspace with
> +KVM_EXIT_SNP_REQ_CERTS exit reason to allow for fetching SNP attestation
> +certificates from userspace.
> +
> +Calling KVM_CHECK_EXTENSION for this capability will return a non-zero
> +value to indicate KVM support for KVM_EXIT_SNP_REQ_CERTS.
> +
> +The 1st argument to KVM_ENABLE_CAP should be 1 to indicate userspace support
> +for handling this event.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0b7af5902ff7..8b11d1a64378 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1459,6 +1459,7 @@ struct kvm_arch {
>  	struct kvm_x86_msr_filter __rcu *msr_filter;
>  
>  	u32 hypercall_exit_enabled;
> +	bool snp_certs_enabled;

Given that this is obviously specific to SNP, I think it belongs in kvm_sev_info.
And trying to enable the capability on a non-SNP VM should fail.

Actually, rather than a generic capability, what about using the SEV "attributes"
to enumerate support, and then use KVM_MEMORY_ENCRYPT_OP to enable cert requests.
That way we don't need to add yet more plumbing to KVM, and it fits with the
direction Paolo went for KVM_SEV_INIT2.

E.g. I think the KVM side of things ends up like:

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..675795a83c44 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -467,6 +467,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV                        1
 #  define KVM_X86_SEV_VMSA_FEATURES    0
+#  define KVM_X86_SNP_SNP_REQ_CERTS    1
 
 struct kvm_vmx_nested_state_data {
        __u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -704,6 +705,8 @@ enum sev_cmd_id {
        KVM_SEV_SNP_LAUNCH_START = 100,
        KVM_SEV_SNP_LAUNCH_UPDATE,
        KVM_SEV_SNP_LAUNCH_FINISH,
+       KVM_SEV_SNP_ENABLE_REQ_CERTS,
+
 
        KVM_SEV_NR_MAX,
 };
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..ddadd14551fc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2123,7 +2123,9 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
        case KVM_X86_SEV_VMSA_FEATURES:
                *val = sev_supported_vmsa_features;
                return 0;
-
+       case KVM_X86_SNP_SNP_REQ_CERTS
+               *val = 1;
+               return 0;
        default:
                return -ENXIO;
        }
@@ -2535,6 +2537,15 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
        return ret;
 }
 
+static int snp_enable_certs(struct kvm *kvm)
+{
+       if (kvm->created_vcpus || !sev_snp_guest(kvm))
+               return -EINVAL;
+
+       to_kvm_sev_info(kvm)->snp_certs_enabled = true;
+       return 0;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
        struct kvm_sev_cmd sev_cmd;
@@ -2640,6 +2651,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
        case KVM_SEV_SNP_LAUNCH_FINISH:
                r = snp_launch_finish(kvm, &sev_cmd);
                break;
+       case KVM_SEV_SNP_ENABLE_REQ_CERTS:
+               r = snp_enable_certs(kvm);
+               break;
        default:
                r = -EINVAL;
                goto out;


>  	/* Guest can access the SGX PROVISIONKEY. */
>  	bool sgx_provisioning_allowed;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0dbb25442ec1..a18e8eed533b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4088,6 +4088,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>  	return ret;
>  }
>  
> +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_control_area *control = &svm->vmcb->control;
> +
> +	if (vcpu->run->snp_req_certs.ret) {

This should be READ_ONCE() to avoid weirdness if userspace is scribbling kvm_run.

Aha!  Idea.  To reduce indentation and dedup some code, add a helper to fill the
error field.  And then you can use a switch statement too.  E.g.

	switch (ret) {
	case 0:
		return snp_handle_guest_req(svm, control->exit_info_1,
					    control->exit_info_2);
	case ENOSPC:
		vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_LEN);
	case EAGAIN:
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
	case EIO:
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
	default:
		break;
	}

	return -EINVAL;

> @@ -4124,6 +4146,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  		if (!PAGE_ALIGNED(data_gpa))
>  			goto request_invalid;
>  
> +		if (vcpu->kvm->arch.snp_certs_enabled) {
> +			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
> +			vcpu->run->snp_req_certs.gfn = gpa_to_gfn(data_gpa);
> +			vcpu->run->snp_req_certs.npages = data_npages;
> +			vcpu->run->snp_req_certs.ret = 0;
> +			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
> +			return 0; /* fetch certs from userspace */
> +		}
> +
>  		/*
>  		 * As per GHCB spec (see "SNP Extended Guest Request"), the
>  		 * certificate table is terminated by 24-bytes of zeroes.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 02159c967d29..67ff4a89ac81 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4774,6 +4774,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_READONLY_MEM:
>  		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
>  		break;
> +	case KVM_CAP_EXIT_SNP_REQ_CERTS:
> +		r = 1;

This should be conditional on KVM supporting SNP.  Or if we don't want the support
to be dynamic based on hardware capabilities and module params, at least conditional
on KVM supporting SEV in the Kconfig.

> +		break;
>  	default:
>  		break;
>  	}
> @@ -6734,6 +6737,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		mutex_unlock(&kvm->lock);
>  		break;
>  	}
> +	case KVM_CAP_EXIT_SNP_REQ_CERTS:
> +		if (cap->args[0] != 1) {

Definitely prefer a proper #define for the flag.  Or as above, put "ENABLE" in
the name and ignore the args entirely (probably my vote).

> +			r = -EINVAL;
> +			break;
> +		}
> +		kvm->arch.snp_certs_enabled = true;

This should be guarded with a check that vCPUs haven't been created, so that KVM
doesn't have to think about what can go wrong if userspace toggle the capability
while vCPUs are running.

> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 45e6d8fca9b9..83c4e6929df7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -135,6 +135,12 @@ struct kvm_xen_exit {
>  	} u;
>  };
>  
> +struct kvm_exit_snp_req_certs {
> +	__u64 gfn;
> +	__u32 npages;

Space is not at a premium.  Given that data_npages is a u64, and KVM typically
tracks the number of guest pages with gfn_t, I think it makes sense to have this
be a u64.

> +	__u32 ret;

Same here, use a u64.  No reason to pack this tightly.

> +};
> +
>  #define KVM_S390_GET_SKEYS_NONE   1
>  #define KVM_S390_SKEYS_MAX        1048576
>  
> @@ -178,6 +184,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_SNP_REQ_CERTS    40
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -446,6 +453,8 @@ struct kvm_run {
>  			__u64 gpa;
>  			__u64 size;
>  		} memory_fault;
> +		/* KVM_EXIT_SNP_REQ_CERTS */
> +		struct kvm_exit_snp_req_certs snp_req_certs;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -929,6 +938,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_PRE_FAULT_MEMORY 236
>  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>  #define KVM_CAP_X86_GUEST_MODE 238
> +#define KVM_CAP_EXIT_SNP_REQ_CERTS 239
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
> index fcdfea767fca..4c4ed8bc71d7 100644
> --- a/include/uapi/linux/sev-guest.h
> +++ b/include/uapi/linux/sev-guest.h
> @@ -95,5 +95,13 @@ struct snp_ext_report_req {
>  
>  #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
>  #define SNP_GUEST_VMM_ERR_BUSY		2
> +/*
> + * The GHCB spec essentially states that all non-zero error codes other than
> + * those explicitly defined above should be treated as an error by the guest.
> + * Define a generic error to cover that case, and choose a value that is not
> + * likely to overlap with new explicit error codes should more be added to
> + * the GHCB spec later.
> + */
> +#define SNP_GUEST_VMM_ERR_GENERIC       ((u32)~0U)

Why cast to a u32?  The "U" should take care of things.  If you need to cast, it
should be __u32.

>  
>  #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
> -- 
> 2.25.1
> 

