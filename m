Return-Path: <kvm+bounces-15959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 111938B27FA
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34B5A1C21342
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306B41514D8;
	Thu, 25 Apr 2024 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vBM6aTcn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7C152533
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068874; cv=none; b=GKmWncwhkn0NFLhN5Nk7YcosvbEbyAqDMVsxW05fjbd1p6gSA5EKySjuPTFhJeI638gJ0lfUiFAOC/pfEfFIw+BWN5JZIDW+HHDGWbtsY/+8zTU545uP6UNkzi+FWFdUg+N4ujyC3w540/6TGJ7CFoAgHfQVl2985ISih17t56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068874; c=relaxed/simple;
	bh=bdfjYgs716k1uC57XY7KT8AtVilTUrCEJVDOzBHxwqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZvx0LSRTb4yBcWqdt3HN/C6XkIKL0pkqgcSyeRDAkC9mXaZfi/spl1ot58Y+LS/xfVHG7Zcfq7DBVfbFw6HoKtFKos3r7IWnL5AXhvqkdrp+aPV0vspIXyfyQtqowE9LZDM9/aCbhHbjud51GSz+MGo+IbOw7VOXBSIJv861R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vBM6aTcn; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso2515236276.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068872; x=1714673672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OjCdRp9zkD3arq1XZ7abaeTHNnTRhOgDmoPo22LWgTM=;
        b=vBM6aTcn0cp9LR8aq330B1adP7JVCqXuZepHx/Wm/1kc/GiyLB8iRJkUFm7/l8LAXh
         r4DzaM+7J4xKCjRsvuwM9/T4BfGyk9OcFTvzjoSKVH5jKPDMx7fc0a5KovrQBa1pirLH
         JMH4A7hwUOMEC5gwizVcTGBN8twl3AWHUjUKzSVWZ9AY71efpguWA5iz9txnDFCaEQpL
         +rzYYwZUiARQL45zQ1XlXcqy84hfAixZxkzM9oNlkgsDSmwwyzEVQ25AVKILbdEQm348
         +2YekEfm4xgEsu/2jKBZWiUuPDCJNKiHBOJv1S5pYa6IyE8YGJ+oJM10CTCyqLhK61iz
         Xpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068872; x=1714673672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjCdRp9zkD3arq1XZ7abaeTHNnTRhOgDmoPo22LWgTM=;
        b=aPM7oO63ravOCULgHRV7EJZSFfVh1ixNpF5NL2eddt5FO8uJ993rMVFyCGCBIDJJQk
         /FyRh3/JfFbsAZRADB1tTV7IA9qQAsfa3r2dVdTm0mgSVlNADnGZIjalrhdKk0j5kqmI
         Ias+LQ5WkM8QO1U4xvG+66c2V18fdHW53JiAKyq4wIhuSJIO8BGYIWFD3ATf1cebT61P
         DrYz2JSlroCliin+wuv4Oh4DeVvkOJfZUBL7HpNLbADeAd89k99Dfv3fxptrJ5yQbiRp
         T57XibOByhpCxAmwfoOVO3xmagWPclMM/A+FjzdquapM6i8IQls7J4XHWTm1oc8UyldQ
         zRzA==
X-Gm-Message-State: AOJu0YyhNh0mPUTtjqeZwQ+i6i4XvEjAy/CJgSZWepfSsCldH7d+bVZk
	SjoKV59cs26BmvyGKM+LZB1DFduh/B9bwTJ476AASAjI/aLrYQ38KFMCsEmoHwKJY59DjdDjPje
	fQg==
X-Google-Smtp-Source: AGHT+IH5cTJqQnUYTxkvi9tU0uXTyJy7rXI5hE74upFYWxYI5XkmyoXp4+CkOaVX5KDJzYcFg4u1nyGwWmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150d:b0:dda:ce5f:b4c3 with SMTP id
 q13-20020a056902150d00b00ddace5fb4c3mr125683ybu.1.1714068871887; Thu, 25 Apr
 2024 11:14:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:15 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-4-seanjc@google.com>
Subject: [PATCH 03/10] KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the "INVALID" internal MSR error return code to "UNSUPPORTED" to
try and make it more clear that access was denied because the MSR itself
is unsupported/unknown.  "INVALID" is too ambiguous, as it could just as
easily mean the value for WRMSR as invalid.

Avoid UNKNOWN and UNIMPLEMENTED, as the error code is used for MSRs that
_are_ actually implemented by KVM, e.g. if the MSR is unsupported because
an associated feature flag is not present in guest CPUID.

Opportunistically beef up the comments for the internal MSR error codes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 12 ++++++------
 arch/x86/kvm/x86.h     | 15 +++++++++++----
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 00f0c0b506d4..6e518edbd2aa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2806,7 +2806,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f10b5f8f364b..0ad2e7545de3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1963,7 +1963,7 @@ int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9ef1fa4b90b..2b07f0f11aeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1710,7 +1710,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
 
 	*data = msr.data;
@@ -1907,7 +1907,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID)
+	if (ret == KVM_MSR_RET_UNSUPPORTED)
 		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
 
@@ -1952,7 +1952,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID) {
+	if (ret == KVM_MSR_RET_UNSUPPORTED) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
 		if (kvm_msr_ignored_check(index, 0, false))
@@ -2021,7 +2021,7 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
-	case KVM_MSR_RET_INVALID:
+	case KVM_MSR_RET_UNSUPPORTED:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
 	case KVM_MSR_RET_FILTERED:
 		return KVM_MSR_EXIT_REASON_FILTER;
@@ -4172,7 +4172,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    kvm_is_msr_to_save(msr))
 			break;
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
@@ -4533,7 +4533,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 		}
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a03829e9c6ac..ba54028af2df 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -505,11 +505,18 @@ enum kvm_msr_access {
 
 /*
  * Internal error codes that are used to indicate that MSR emulation encountered
- * an error that should result in #GP in the guest, unless userspace
- * handles it.
+ * an error that should result in #GP in the guest, unless userspace handles it.
+ * Note, '1', '0', and negative numbers are off limits, as they are used by KVM
+ * as part of KVM's lightly documented internal KVM_RUN return codes.
+ *
+ * UNSUPPORTED	- The MSR isn't supported, either because it is completely
+ *		  unknown to KVM, or because the MSR should not exist according
+ *		  to the vCPU model.
+ *
+ * FILTERED	- Access to the MSR is denied by a userspace MSR filter.
  */
-#define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
-#define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
+#define  KVM_MSR_RET_UNSUPPORTED	2
+#define  KVM_MSR_RET_FILTERED		3
 
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
-- 
2.44.0.769.g3c40516874-goog


