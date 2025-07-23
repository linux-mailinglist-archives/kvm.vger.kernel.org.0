Return-Path: <kvm+bounces-53306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 662FBB0F9FF
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08293166A22
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A95A223DDF;
	Wed, 23 Jul 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pvYP9RtP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8962206BB
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294001; cv=none; b=IfqAoWPzAdePLnYyvePQwwyvmAYjbUauBKGKdxx9AEnmEuSohcM/cI5ieId74YpS4DoNBRzzGJQTymMgD/0p9YwLlEYmRtZnUYWcXwEyYu1HoZN9eG/cC5WFgY3cUWDrHvuJhLO/5pQCk6Q8F3HFVdMd+1ITRd3KOqKabiZICSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294001; c=relaxed/simple;
	bh=eWymMRmLfscJuffkwMDNgqpA4cVY4kBbJFGJ+bFrOmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ClZ0N2v1b0XrqegTSoyU62arrzjqNJvI6KOWzW6PUv6vIeG8tJUwfrFFhbBVCbiRcPs96bKZUFaHuGte+W5DmnTuGXAkU68fM77cdj4mRGjX2JZP96H+OeY7h2WdoVfQvbZjn4xwtPGYUkFhC42mRRRb7yg6FuEMUsVmWU03Pho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pvYP9RtP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31220ecc586so104739a91.2
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 11:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753293999; x=1753898799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZfDzw+qVz0o/w7Bp6MxT59VuQisbldYUAGH/6NuUrY=;
        b=pvYP9RtPXYNw6SMtX4kszuUXq5gsYKT6m11XjsnNaTLntlrLmZzADOQESG48RP2CKf
         D6l46EsgXwu71UenSFrRkQiEYqOF2DMEjAbOIOsREiyurHS9dIKvfyDYKPLwU7muW+VF
         PaILNSdC7Xta/X/83gI6pdxqxFWXlTcaeddBeSm4rWUOB77c0vQZyPKG9pdereqLTII4
         kMcyKygx3MMLltzU313BgKUVFjGRn3MME8e4qdroVJnAdbCnZBQHLNdayigHjjUzJqhe
         Glzo7Z/5JmEryiys3S0ifhQkxAZeAx3evtCMIppNksGKnhy4/dkSc5DoKgGhI2Crw3r8
         T/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753293999; x=1753898799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZfDzw+qVz0o/w7Bp6MxT59VuQisbldYUAGH/6NuUrY=;
        b=OMr5Z0A1VNwSG98kAZOjRmvB3mqGFKtuE5NOHCAK83gubZmtZy/pn2c4PCakiiLutx
         1+vPjDDpGo9dpMFKGORNMhg5yCl17OXNfvDqcV6gx7kX1SONkM3TSkf9cUdFXGcCbfFt
         EnehmeMfVTWRWyOuW26yUJtNfqewdaUVyl4zdiW9DY84Va42U1jYIVQtNPxUDyzlJrUD
         CKQ0aBUdBSs3oVsOb0ZQW1llGoDt8kqNQlDXnL0sRFA39Jc1g+UbfzqLGpCPR0h6nts6
         e24AElQ4PcLNlm0WGp4bllfrToSlFS5w1gwetb3pSzNrj1zP0i+7sIWv9f+Z+RZH3Pmx
         gThQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjF55w2hYXiHBMq+dEntZphajLpfItgwQWlgQFt0AmDUSoc6TVqxgBiW0wwOLJaw9zBo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf0Wkdaebk2H87auKdpmn4F87Aconi3KIZ5UgEW39IVcTjHNPv
	pm7L+4g1T11+2nfauBsgn3EZoLnzGXPgyYEHBoslVkcvrjvF06ROFsomqXUSCJJqXiUZ8soHubm
	UYMAcLQ==
X-Google-Smtp-Source: AGHT+IF3hX1FXykh7Df5O4ildAUw6dsX0iRQymh7GSo9oxT9J1zy8hJ9dw+7n83OiW1YjgBQlL2K8mHkgqw=
X-Received: from pjm4.prod.google.com ([2002:a17:90b:2fc4:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:530f:b0:311:ffe8:20ee
 with SMTP id 98e67ed59e1d1-31e5071ccdfmr6877046a91.11.1753293999283; Wed, 23
 Jul 2025 11:06:39 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:06:37 -0700
In-Reply-To: <20250422161304.579394-3-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com> <20250422161304.579394-3-zack.rusin@broadcom.com>
Message-ID: <aIEkrc7Mdf2ia1Mm@google.com>
Subject: Re: [PATCH v2 2/5] KVM: x86: Allow enabling of the vmware backdoor
 via a cap
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Doug Covelli <doug.covelli@broadcom.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Zack Rusin wrote:
> @@ -6735,6 +6734,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		mutex_unlock(&kvm->lock);
>  		break;
>  	}
> +#ifdef CONFIG_KVM_VMWARE
> +	case KVM_CAP_X86_VMWARE_BACKDOOR:

I much perfer using a single KVM_CAP_X86_VMWARE capability.  More below.

> +		r = -EINVAL;
> +		if (cap->args[0] & ~1)

Using bit 0 for "enable" needs to be #defined arch/x86/include/uapi/asm/kvm.h.

At that point, adding more capabilities for the other VMware functionality doesn't
make much sense, especially since the capabilities that are added in later patches
don't have the kvm->created_vcpus protection, i.e. are likely buggy.

E.g. with the below diff (completely untested, probably won't apply cleanly?)
spread across three-ish patches, the accessors can be:

static inline bool kvm_is_vmware_cap_enabled(struct kvm *kvm, u64 cap)
{
	return kvm->arch.vmware.caps & cap;
}

static inline bool kvm_is_vmware_backdoor_enabled(struct kvm_vcpu *vcpu)
{
	return kvm_is_vmware_cap_enabled(kvm, KVM_VMWARE_ENABLE_BACKDOOR);
}

static inline bool kvm_is_vmware_hypercall_enabled(struct kvm *kvm)
{
	return kvm_is_vmware_cap_enabled(kvm, KVM_VMWARE_ENABLE_HYPERCALL);
}

static inline bool kvm_vmware_nested_backdoor_l0_enabled(struct kvm *kvm)
{
	return kvm_is_vmware_backdoor_enabled(kvm) &&
	       kvm_is_vmware_cap_enabled(kvm, KVM_VMWARE_ENABLE_NESTED_BACKDOOR);
}

---
 arch/x86/include/asm/kvm_host.h |  4 +---
 arch/x86/include/uapi/asm/kvm.h |  4 ++++
 arch/x86/kvm/x86.c              | 34 ++++++++++++---------------------
 3 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 639c49db0106..1433cdd14675 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1219,9 +1219,7 @@ struct kvm_xen {
 #ifdef CONFIG_KVM_VMWARE
 /* VMware emulation context */
 struct kvm_vmware {
-	bool backdoor_enabled;
-	bool hypercall_enabled;
-	bool nested_backdoor_l0_enabled;
+	u64 caps;
 };
 #endif
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e019111e2150..ae578422d6f4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -1013,4 +1013,8 @@ struct kvm_tdx_init_mem_region {
 	__u64 nr_pages;
 };
 
+#define KVM_VMWARE_ENABLE_BACKDOOR		_BITULL(0)
+#define KVM_VMWARE_ENABLE_HYPERCALL		_BITULL(1)
+#define KVM_VMWARE_ENABLE_NESTED_BACKDOOR	_BITULL(2)
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7234333a92d8..b9e2faf0ceb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -126,6 +126,10 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
+#define KVM_CAP_VMWARE_VALID_MASK (KVM_VMWARE_CAP_ENABLE_BACKDOOR | \
+				   KVM_VMWARE_ENABLE_HYPERCALL | \
+				   KVM_VMWARE_ENABLE_NESTED_BACKDOOR)
+
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -4708,11 +4712,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
 	case KVM_CAP_X86_GUEST_MODE:
-#ifdef CONFIG_KVM_VMWARE
-	case KVM_CAP_X86_VMWARE_BACKDOOR:
-	case KVM_CAP_X86_VMWARE_HYPERCALL:
-	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
-#endif
 		r = 1;
 		break;
 	case KVM_CAP_PRE_FAULT_MEMORY:
@@ -4836,6 +4835,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+#ifdef CONFIG_KVM_VMWARE
+	case KVM_CAP_X86_VMWARE:
+		return KVM_CAP_VMWARE_VALID_MASK;
+#endif
 	default:
 		break;
 	}
@@ -6669,31 +6672,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	}
 #ifdef CONFIG_KVM_VMWARE
-	case KVM_CAP_X86_VMWARE_BACKDOOR:
+	case KVM_CAP_X86_VMWARE:
 		r = -EINVAL;
-		if (cap->args[0] & ~1)
+		if (cap->args[0] & ~KVM_CAP_VMWARE_VALID_MASK)
 			break;
+
 		mutex_lock(&kvm->lock);
 		if (!kvm->created_vcpus) {
-			kvm->arch.vmware.backdoor_enabled = cap->args[0];
+			kvm->arch.vmware.caps = cap->args[0];
 			r = 0;
 		}
 		mutex_unlock(&kvm->lock);
 		break;
-	case KVM_CAP_X86_VMWARE_HYPERCALL:
-		r = -EINVAL;
-		if (cap->args[0] & ~1)
-			break;
-		kvm->arch.vmware.hypercall_enabled = cap->args[0];
-		r = 0;
-		break;
-	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
-		r = -EINVAL;
-		if (cap->args[0] & ~1)
-			break;
-		kvm->arch.vmware.nested_backdoor_l0_enabled = cap->args[0];
-		r = 0;
-		break;
 #endif
 	default:
 		r = -EINVAL;

base-commit: 77a53b6f5d1c2dabef34d890d212910ed1f43bcb
--

