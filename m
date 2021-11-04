Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED93A445A87
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhKDTZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhKDTZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:25:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9CC061203
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 12:22:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s24so8997512plp.0
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 12:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CbCOkVgrvGwUj1HRipggXYF/2vqn58uVsvwjzzGP78A=;
        b=YNYfE+OHS550Pt1VmJfPe7D1qsnyY/XSWFFbfNj5Cu88sOlDFAgkfwDOnO3rRTZm6X
         wfziquftGetgh8kld7Lk6xJIwMkV4Mr1eUhBK48mjO+y5sukaxFQVqIYOlG9E3Y3/gUm
         hAnDFSQnIJ2kh+LrzNS+j8B5L5E/7l4aLm1LbVhxVQv0sYV+A92uNR8mjBnWCKFTw7mt
         ifIOo2BafgCyj3nij3KU/CKA5Y9OeAynJS0Cx8Q+KJhiepew2GQhEUw81HGoqwCNbpjl
         FXQ0gAl2NmMKt3QgsJ6a7OBp4wVLa7JZUaO4DL5TorTW3FR/f94lgdk0SfaMjbTDssFJ
         GP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CbCOkVgrvGwUj1HRipggXYF/2vqn58uVsvwjzzGP78A=;
        b=P/6Uz91AlyNYuP+d3948QJwnIs/F2tsZMALVwL7Gco6HsLpYUsl4/ONC4p7J7N3Ibb
         HUM1eVSoxlH2oE7VaMRqTU8+GFLQZX55AYBuhOaWyknIm0TXmgnnPaFAzKJUfmDwyg8v
         LOs8sKiqrb6UmAI2dVtJw9b7LBuKggK9cSm0ADOS6yqbrmBlo80gqSp6XseMfdtnLbk7
         er8vDN2R/DdyUx/hkA90ayKjW8PGvsvVzObCDE1tDhRReAx6Ye48BvvrzFXlqIngk4XW
         vAPtPDNJhLKY148IEI3vGT3p/Cxo1Q/Y4BOUTgXw0mE+r6pjs85FQMtrgZt8JaM+p3hP
         m9Cg==
X-Gm-Message-State: AOAM532XvXH2Vr1Zo2BJmX8aEvZKfuGEo0Q/VxKHdVmj1UIkCgDDYXMA
        UFHONLPDTqZc4sRqO6XvR5nf4Q==
X-Google-Smtp-Source: ABdhPJz4MeWwYK5z0NWJItZ6cxPPO7hANkUjATRrxU4Skb9ku5mHasVaSuO2JF5XAv1g0tJxxB+6SQ==
X-Received: by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id j10-20020a170902f24a00b00141c6fc2e18mr33905963plc.55.1636053777322;
        Thu, 04 Nov 2021 12:22:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10sm6067020pfc.104.2021.11.04.12.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 12:22:56 -0700 (PDT)
Date:   Thu, 4 Nov 2021 19:22:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <paul@xen.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: Make sure KVM_CPUID_FEATURES really are
 KVM_CPUID_FEATURES
Message-ID: <YYQzDLLE4WavR2Q6@google.com>
References: <20211104183020.4341-1-paul@xen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104183020.4341-1-paul@xen.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 04, 2021, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Currently when kvm_update_cpuid_runtime() runs, it assumes that the
> KVM_CPUID_FEATURES leaf is located at 0x40000001. This is not true,
> however, if Hyper-V support is enabled. In this case the KVM leaves will
> be offset.
> 
> This patch introdues as new 'kvm_cpuid_base' field into struct
> kvm_vcpu_arch to track the location of the KVM leaves and function
> kvm_update_cpuid_base() (called from kvm_update_cpuid_runtime()) to locate
> the leaves using the 'KVMKVMKVM\0\0\0' signature. Adjustment of
> KVM_CPUID_FEATURES will hence now target the correct leaf.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>

scripts/get_maintainer.pl is your friend :-)

> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 50 +++++++++++++++++++++++++++++----
>  2 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88fce6ab4bbd..21133ffa23e9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -725,6 +725,7 @@ struct kvm_vcpu_arch {
>  
>  	int cpuid_nent;
>  	struct kvm_cpuid_entry2 *cpuid_entries;
> +	u32 kvm_cpuid_base;
>  
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2d70edb0f323..2cfb8ec4f570 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -99,11 +99,46 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>  	return 0;
>  }
>  
> +static void kvm_update_cpuid_base(struct kvm_vcpu *vcpu)
> +{
> +	u32 function;
> +
> +	for (function = 0x40000000; function < 0x40010000; function += 0x100) {

No small part of me wants to turn hypervisor_cpuid_base() into a macro, but that's
probably more pain than gain.  But I do think it would be worth providing a macro
to iterate over possible bases and share that with the guest-side code.

> +		struct kvm_cpuid_entry2 *best = kvm_find_cpuid_entry(vcpu, function, 0);

Declare "struct kvm_cpuid_entry2 *best" outside of the loop to shorten this line.
I'd also vote to rename "best" to "entry".  KVM's "best" terminology is a remnant
of misguided logic that applied Intel's bizarre out-of-range behavior to internal
KVM lookups.

> +
> +		if (best) {
> +			char signature[12];
> +
> +			*(u32 *)&signature[0] = best->ebx;

Just make signature a u32[3], then the casting craziness goes away.

> +			*(u32 *)&signature[4] = best->ecx;
> +			*(u32 *)&signature[8] = best->edx;
> +
> +			if (!memcmp(signature, "KVMKVMKVM\0\0\0", 12))

The "KVMKVMKVM\0\0\0" magic string belongs in a #define that's shared with the
guest-side code.  I

> +				break;
> +		}
> +	}
> +	vcpu->arch.kvm_cpuid_base = function;

Unconditionally setting kvm_cpuid_base is silly because then kvm_get_cpuid_base()
needs to check multiple "error" values.

E.g. all of the above can be done as:

	struct kvm_cpuid_entry2 *entry;
	u32 base, signature[3];

	vcpu->arch.kvm_cpuid_base = 0;

	virt_for_each_possible_hypervisor_base(base) {
		entry = kvm_find_cpuid_entry(vcpu, base, 0);
		if (!entry)
			continue;

		signature[0] = entry->ebx;
		signature[1] = entry->ecx;
		signature[2] = entry->edx;

		if (!memcmp(signature, KVM_CPUID_SIG, sizeof(signature))) {
			vcpu->arch.kvm_cpuid_base = base;
			break;
		}
	}

> +}
> +
> +static inline bool kvm_get_cpuid_base(struct kvm_vcpu *vcpu, u32 *function)
> +{
> +	if (vcpu->arch.kvm_cpuid_base < 0x40000000 ||
> +	    vcpu->arch.kvm_cpuid_base >= 0x40010000)
> +		return false;
> +
> +	*function = vcpu->arch.kvm_cpuid_base;
> +	return true;

If '0' is the "doesn't exist" value, then this helper goes away.

> +}
> +
>  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>  {
> +	u32 base;
>  	struct kvm_cpuid_entry2 *best;
>  
> -	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> +	if (!kvm_get_cpuid_base(vcpu, &base))
> +		return;

... and then this becomes:

	if (!vcpu->arch.kvm_cpuid_base)
		return;

Actually, since this is a repated pattern and is likely going to be limited to
getting KVM_CPUID_FEATURES, just add:

struct kvm_find_cpuid_entry kvm_find_kvm_cpuid_features(void)
{
	u32 base = vcpu->arch.kvm_cpuid_base;

	if (!base)
		return NULL;

	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
}

and then all of the indentation churn goes away.

> +
> +	best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);
>  
>  	/*
>  	 * save the feature bitmap to avoid cpuid lookup for every PV
> @@ -116,6 +151,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
> +	u32 base;
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	if (best) {
> @@ -142,10 +178,14 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
> -	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> -		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +	kvm_update_cpuid_base(vcpu);

The KVM base doesn't need to be rechecked for runtime updates.  Runtime updates
are to handle changes in guest state, e.g. reported XSAVE size in response to a
CR4.OSXSAVE change.  The raw CPUID entries themselves cannot change at runtime.
I suspect you did this here because kvm_update_cpuid_runtime() is called before
kvm_vcpu_after_set_cpuid(), but that has the very bad side effect of doing an
_expensive_ lookup on every runtime update, which can get very painful if there's
no KVM_CPUID_FEATURES to be found.

If you include the prep patch (pasted at the bottom), then this can simply be
(note the somewhat silly name; I think it's worth clarifying that it's the
KVM_CPUID_* base that's being updated):

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c99d2731076..5dd8c26e9f86 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -245,6 +245,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
        vcpu->arch.cpuid_entries = e2;
        vcpu->arch.cpuid_nent = nent;
 
+       kvm_update_kvm_cpuid_base(vcpu);
        kvm_update_cpuid_runtime(vcpu);
        kvm_vcpu_after_set_cpuid(vcpu);
 
> +
> +	if (kvm_get_cpuid_base(vcpu, &base)) {
> +		best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);

This is wrong.  base will be >0x40000000 and <0x40010000, and KVM_CPUID_FEATURES
is 0x40000001, i.e. this will lookup 0x80000001 for the default base.  The '+'
needs to be an '|'.

> +		if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> +		    (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> +			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> +	}
>  
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>  		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
> -- 
> 2.20.1


From 02d58c124f5aab1b0ef28cfc8a6ff6b6c58df969 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Nov 2021 12:17:23 -0700
Subject: [PATCH] KVM: x86: Add helper to consolidate core logic of
 SET_CPUID{2} flows

Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
only difference between the two ioctls() is the format of the userspace
struct.  A future fix will add yet more code to the core logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 751aa85a3001..0c99d2731076 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -232,6 +232,25 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }

+static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+			 int nent)
+{
+	int r;
+
+	r = kvm_check_cpuid(e2, nent);
+	if (r)
+		return r;
+
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
+
+	kvm_update_cpuid_runtime(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
+
+	return 0;
+}
+
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
@@ -268,18 +287,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		e2[i].padding[2] = 0;
 	}

-	r = kvm_check_cpuid(e2, cpuid->nent);
-	if (r) {
+	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
+	if (r)
 		kvfree(e2);
-		goto out_free_cpuid;
-	}
-
-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = cpuid->nent;
-
-	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);

 out_free_cpuid:
 	kvfree(e);
@@ -303,20 +313,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			return PTR_ERR(e2);
 	}

-	r = kvm_check_cpuid(e2, cpuid->nent);
-	if (r) {
+	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
+	if (r)
 		kvfree(e2);
-		return r;
-	}

-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = cpuid->nent;
-
-	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
-
-	return 0;
+	return r;
 }

 int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
--
