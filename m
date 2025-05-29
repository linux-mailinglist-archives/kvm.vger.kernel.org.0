Return-Path: <kvm+bounces-48039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E279EAC8517
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 231CD9E74BC
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6922925B683;
	Thu, 29 May 2025 23:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0V2Wu2g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4200257AC7
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562024; cv=none; b=lu9GTg3xflqvqX2ziGpS5M3ELVuax2KFCz0laZ8EfvRQ16H90m9RNyrcYFCyA+5vOA+GnSYHUOxlQONmhu3+cymr2xZ7iHo+SVX9omIIQfJqP7a4vKICqudFJedHZj6/WyTFjLz2xSnU+oe2ISw0CGebWQYMeyNNzBOMnC0bAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562024; c=relaxed/simple;
	bh=eYS+Lck7J7NtnTgt+Xbb2Hm4K+2mmZvHByON8oXuZf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NXhp9z9zXzglLBI2l+CQapDcvZrnOu/49J/wYtFIUBvDAVS2aAjywRF3ammbnaOcjkPJs6qIKjzUVkATgQPfxDv9uvbXGOhEx2TwXIDdfEgj5nRdJBW5ZGeNiGxBRd5qZRHwSikGstoLnFmojevUshMWYwP16RMYfwVSKYzd+3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0V2Wu2g; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31220ecc573so1267714a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562022; x=1749166822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oNN/zWlAdCOTCYjL0/iu5zuT8BBhNAO0bA3PJaIztLA=;
        b=p0V2Wu2gmhKXTwroC33wQVDcq/mUMcFRoT2NjRbbJvbnc+NOFz2qBK6bIei96GL4HS
         EJue5L6pervUEBSl4upZWMLeDOMghhPzlBOrgXJPff2Aok21Cl3e6CchWAoQKPe/RLYU
         WwTuep6sodKSbogWnnwu3UzQB67noQhmDemXpCX69uBFI3/0ll+vmvUXEpyA3IKb6ZZT
         QmDDhYFQPdON4cahDev4lFRDDPyPaOm6F3tJRDp+MsIRmlt7e9i9mRtakPm1MmL4vGuw
         20zLY5pC0zwqbnqRgse9KKspgmXy+Y0YEI6DMyxCAGd5/BbKVyZygEqW/eVfny8dIMrX
         GeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562022; x=1749166822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNN/zWlAdCOTCYjL0/iu5zuT8BBhNAO0bA3PJaIztLA=;
        b=YMwEt7TlJJXOSmU8kgh6bSrqECg36JsKjBT9sA7HmAI1iDpiOJoZE70LnQ49uXD8VP
         eF0kXN2T3Mc/molXhUJcThMYhXtIpA5uORb679KhrrG7/QkGwqfdi1inW/kRpyTWB9fn
         9U9USUbemIszLUClFJLQ+hbDJxFvATLTyG4kwhWVw5MOqDtMWS69g1xf93u5Kr6ZDdBx
         g4KHyHMH8QHWDQYIgFRwP51B78WDfIE9oYXrm0XiwBttXiloI1CUCo3PIqKjtOmrQnTR
         sDkul/88oQH8ocjjCngpwpZ7FViqBbT7BmkPkEpL8HnXl/8PqUQslzP21V5WS+yWndsr
         gTjQ==
X-Gm-Message-State: AOJu0YyLPLbZl1TD9XA/5n69XzAxottlZUO8c6BRiNRc9SC3zvlzS4Ks
	ctie9FI4xhqaVrojSksu6HNIpCRPz/G44v1F6rAq+hvv1FAb0MJfKz2r4DEQWD90unzvHjZygqd
	T8We0QA==
X-Google-Smtp-Source: AGHT+IH+PXciz+zBKCuObqiMXeINT6X3kbY5JJY5ZjXV3ituZw1+c952NsssBTZ6rQI8gtfDairM+EJRMXE=
X-Received: from pjbcz5.prod.google.com ([2002:a17:90a:d445:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2883:b0:311:e8cc:424a
 with SMTP id 98e67ed59e1d1-312415391b5mr2428524a91.14.1748562022221; Thu, 29
 May 2025 16:40:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:48 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-4-seanjc@google.com>
Subject: [PATCH 03/28] KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the unnecessary and dangerous value-terminated behavior of
direct_access_msrs, and simply iterate over the actual size of the array.
The use in svm_set_x2apic_msr_interception() is especially sketchy, as it
relies on unused capacity being zero-initialized, and '0' being outside
the range of x2APIC MSRs.

To ensure the array and shadow_msr_intercept stay synchronized, simply
assert that their sizes are identical (note the six 64-bit-only MSRs).

Note, direct_access_msrs will soon be removed entirely; keeping the assert
synchronized with the array isn't expected to be along-term maintenance
burden.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++++-------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 25165d57f1e5..36a99b87a47f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -86,7 +86,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
-} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
+} direct_access_msrs[] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
@@ -144,9 +144,12 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
-	{ .index = MSR_INVALID,				.always = false },
 };
 
+static_assert(ARRAY_SIZE(direct_access_msrs) ==
+	      MAX_DIRECT_ACCESS_MSRS - 6 * !IS_ENABLED(CONFIG_X86_64));
+#undef MAX_DIRECT_ACCESS_MSRS
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -767,9 +770,10 @@ static int direct_access_msr_slot(u32 msr)
 {
 	u32 i;
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		if (direct_access_msrs[i].index == msr)
 			return i;
+	}
 
 	return -ENOENT;
 }
@@ -891,7 +895,7 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 {
 	int i;
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
 		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
@@ -908,7 +912,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (!x2avic_enabled)
 		return;
 
-	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		int index = direct_access_msrs[i].index;
 
 		if ((index < APIC_BASE_MSR) ||
@@ -936,7 +940,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	 * will automatically get filtered through the MSR filter, so we are
 	 * back in sync after this.
 	 */
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		u32 msr = direct_access_msrs[i].index;
 		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
 		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
@@ -974,7 +978,7 @@ static __init int init_msrpm_offsets(void)
 
 	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		u32 offset;
 
 		offset = svm_msrpm_offset(direct_access_msrs[i].index);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6f3c6a153a0..f1e466a10219 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	47
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.49.0.1204.g71687c7c1d-goog


