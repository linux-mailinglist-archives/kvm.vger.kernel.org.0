Return-Path: <kvm+bounces-23094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 079839462F7
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 276DF1C213B6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388C41A83C5;
	Fri,  2 Aug 2024 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Xww6kSm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65661A34CF
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622793; cv=none; b=MRSsIpIe49fNspNQ2YYjcjvy60me8OLbKZbXz40F7hEbbxbUbwIUGBhpA7lez4OMktnlFZAkAZcpIGcTMlI2rCuQ5xeMHuAoLi5rSg7jlhlcN7F4i+xBhAt5CRt+PSPZCIkN1RckIlkq2S0wfWpb+XAcpTV8mwlb1JnL9ZUeq2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622793; c=relaxed/simple;
	bh=rb4xVIVY12PSC4y2haLtDlo9YGZcnbCa7i6qL/X40NM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=etS4g1N6DDRxx9cCuZHZEInA2t4Ja7I8RT3xkyHz2MRa12/iO/fikyRyy6mKLQpqQ05Ud3AapRvXR9VWFXeGqkmhokmfEc5Dy9H5YrgTdjCJE8IdzqTckhvolCSF+cP7qd21HJe5ZZ1wZQojpgRu577UAD7G8JXnkZ3hZlHEdT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Xww6kSm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fed6fe8002so64752545ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622791; x=1723227591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=liDh8TaOioVIlAl31U6Easr9NJIvPr0hlSoyEcDP6UE=;
        b=0Xww6kSm+NM6D6+poBthSBRbfoW6SAnZYFV37gYD/vgqomcqPMHIVB8Jrix9hoJgwi
         poFX2B+8Nt9egjVvUPevUyMdxohuRn0n7Uu7CwOsllnLvWEeBLezkROdqpNmDzFLxNx9
         aj+smqjqpxkdQrLWhyHGIVxS+YoL4Fe9JjS4g8VB9/fa+MtJjQonfY9aFLYN4dzDO2XL
         IUtOoyeiYhxuOkSqNhxLCWn+1i9oNPXA/0FhYYUCXgJt6uivdYy1xtI51zZ/++8U95iW
         UdX9k+wCbprDtXlqdlas+epOBtzB2jmIMsNCzJZ0snTfLkVllKuOKNtn+irTAFSfG7XP
         MWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622791; x=1723227591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=liDh8TaOioVIlAl31U6Easr9NJIvPr0hlSoyEcDP6UE=;
        b=tt7HEclBrQRkuU1YwD8lNUpxP9s0cMuasiRSlGeHNSw9+b4aemunNgsSa5LWWeMaSr
         voXdYRhlJ1eDD8lybueCGm9Ec6DTGJg0ds0vAeSKLh8CBK839YS02deB51fewqhLqJax
         w/m1wL/x/tRMmB9hkErRAIDCqcuerU3wevM/OhgwMamXb6jLrK9ziSuUoPwNuyF8tXYN
         nEf5LfdZBYnjO+PIdvYlLx10uQo1ciGgTnfbwcr1wYZjErMpqsq7QD1soNEPs6wPr+Oh
         2OiApRXiLZlQMMvvZ5IM24b6ytu/USvWZU/V5FaP6gopn93lmbXriexxwCD46p7S1jOs
         tfYw==
X-Gm-Message-State: AOJu0YzRKwx1uEEkUd4vCCfqoexjg+QQ5b1S8amCc3jFHiAgA1nKgkIz
	SOP/e/EqDkwVmzttZV0N2XPJEzF3xQj2evpp4sw8/CYe5f9aUEl7Ro4kpSMzjVDw0plPmHf+lLq
	niQ==
X-Google-Smtp-Source: AGHT+IHrMYkp+Sv0Ir8/V6sg9voPRnli4M+1aNojNmkpNZwkU3BYmG8QxRHCV+CafGj4pShbs7Gk5NQON2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea08:b0:1fc:6ebf:9095 with SMTP id
 d9443c01a7336-1ff570da24dmr2269805ad.0.1722622791041; Fri, 02 Aug 2024
 11:19:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:32 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-8-seanjc@google.com>
Subject: [PATCH v2 07/10] KVM: x86: Funnel all fancy MSR return value handling
 into a common helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a common helper, kvm_do_msr_access(), to invoke the "leaf" APIs that
are type and access specific, and more importantly to handle errors that
are returned from the leaf APIs.  I.e. turn kvm_msr_ignored_check() from a
a helper that is called on an error, into a trampoline that detects errors
*and* applies relevant side effects, e.g. logging unimplemented accesses.

Because the leaf APIs are used for guest accesses, userspace accesses, and
KVM accesses, and because KVM supports restricting access to MSRs from
userspace via filters, the error handling is subtly non-trivial.  E.g. KVM
has had at least one bug escape due to making each "outer" function handle
errors.  See commit 3376ca3f1a20 ("KVM: x86: Fix KVM_GET_MSRS stack info
leak").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 86 +++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52f11682dd09..4de1d7f17109 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -304,25 +304,40 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 
 static struct kmem_cache *x86_emulator_cache;
 
-/*
- * When called, it means the previous get/set msr reached an invalid msr.
- * Return true if we want to ignore/silent this failed msr access.
- */
-static bool kvm_msr_ignored_check(u32 msr, u64 data, bool write)
+typedef int (*msr_access_t)(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			    bool host_initiated);
+
+static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
+					     u64 *data, bool host_initiated,
+					     enum kvm_msr_access rw,
+					     msr_access_t msr_access_fn)
 {
-	const char *op = write ? "wrmsr" : "rdmsr";
-
-	if (ignore_msrs) {
-		if (report_ignored_msrs)
-			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
-				      op, msr, data);
-		/* Mask the error */
-		return true;
-	} else {
+	const char *op = rw == MSR_TYPE_W ? "wrmsr" : "rdmsr";
+	int ret;
+
+	BUILD_BUG_ON(rw != MSR_TYPE_R && rw != MSR_TYPE_W);
+
+	/*
+	 * Zero the data on read failures to avoid leaking stack data to the
+	 * guest and/or userspace, e.g. if the failure is ignored below.
+	 */
+	ret = msr_access_fn(vcpu, msr, data, host_initiated);
+	if (ret && rw == MSR_TYPE_R)
+		*data = 0;
+
+	if (ret != KVM_MSR_RET_UNSUPPORTED)
+		return ret;
+
+	if (!ignore_msrs) {
 		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
-				      op, msr, data);
-		return false;
+				      op, msr, *data);
+		return ret;
 	}
+
+	if (report_ignored_msrs)
+		kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n", op, msr, *data);
+
+	return 0;
 }
 
 static struct kmem_cache *kvm_alloc_emulator_cache(void)
@@ -1685,16 +1700,8 @@ static int kvm_get_feature_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 
 static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	int r;
-
-	/* Unconditionally clear the output for simplicity */
-	*data = 0;
-	r = kvm_get_feature_msr(vcpu, index, data, true);
-
-	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
-		r = 0;
-
-	return r;
+	return kvm_do_msr_access(vcpu, index, data, true, MSR_TYPE_R,
+				 kvm_get_feature_msr);
 }
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
@@ -1881,16 +1888,17 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	return kvm_x86_call(set_msr)(vcpu, &msr);
 }
 
+static int _kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			bool host_initiated)
+{
+	return __kvm_set_msr(vcpu, index, *data, host_initiated);
+}
+
 static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 				     u32 index, u64 data, bool host_initiated)
 {
-	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
-
-	if (ret == KVM_MSR_RET_UNSUPPORTED)
-		if (kvm_msr_ignored_check(index, data, true))
-			ret = 0;
-
-	return ret;
+	return kvm_do_msr_access(vcpu, index, &data, host_initiated, MSR_TYPE_W,
+				 _kvm_set_msr);
 }
 
 /*
@@ -1929,16 +1937,8 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				     u32 index, u64 *data, bool host_initiated)
 {
-	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
-
-	if (ret == KVM_MSR_RET_UNSUPPORTED) {
-		/* Unconditionally clear *data for simplicity */
-		*data = 0;
-		if (kvm_msr_ignored_check(index, 0, false))
-			ret = 0;
-	}
-
-	return ret;
+	return kvm_do_msr_access(vcpu, index, data, host_initiated, MSR_TYPE_R,
+				 __kvm_get_msr);
 }
 
 static int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
-- 
2.46.0.rc2.264.g509ed76dc8-goog


