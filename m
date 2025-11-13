Return-Path: <kvm+bounces-63082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D8DC5A7E5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 64E5E354818
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D40328B77;
	Thu, 13 Nov 2025 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rE3BmQm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FBF328277
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075670; cv=none; b=b5YsWuRE0Kl9GKpoI9CuZ/z3eoMQBmqg1EL2Vn5eH0ZxyBHsZKiZjkTD7/vAjLHjarMGlg6od4ZLHmbe/kMovUT0xTiW5rEvK/WjeCjC2KU/hmJRoMGEREFNWdXHVZPA1R3T1XvRW5W9Ie+PGWvTuIlzkQb6mOKdKKM7CFJNddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075670; c=relaxed/simple;
	bh=2cAaiT7PwEONFCqUofJOhZ6cE7DYhfdQ4UzvpT5ZsdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tz+mIlPXtHS1BXlmjhaJzdHKibHRqmMjafGv6FYsVfSQEvBehzv5u9afsGXSEKN+uMzakIOSo4t14ESL+DwnnG7eIDpsgkVpXz/j7GCHEvn5/H2qjgAugNITnItFTIDp9ZdV3GxuXbt12R3tvxf/8y0IOOwi8NGlt3Kf4KBFrZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rE3BmQm8; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7aa148105a2so1227534b3a.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075668; x=1763680468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J2lWLpeuuyBK53QPv4qNMGBjvWcQwd5w2nRNuz2NzOE=;
        b=rE3BmQm8Ovbo3uuqiHMp5ElE1LFyOyw6eTdEy7hDvPU5OgHRxDsS6F/WRMIuFyKvVj
         CamCfNbnPD/O5532D22WplAuE5AFcpnVwXyR6Cl6Cqj9dmYkKzoGoGR70VJNlSsI6RFA
         h/D8J6KF2qR3xR8e1uT+jF6kHnRGbJS2KIN/HuCfqFf6eHk+Fz7Xlg1aP3t1tCiuUXh7
         4Oa6sxYcqEfdnHFa8yqBc19waohdEEVUK07AHfoLQZ8nbAAOhsN3vfNlEvSHFtXvZbZ3
         4gj5XwS8/9xAuIYpLBmCx6UpEWAsBfXRWBcZHrbTlz6EvOe03OYTBmex4FRXxksWHth7
         JIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075668; x=1763680468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2lWLpeuuyBK53QPv4qNMGBjvWcQwd5w2nRNuz2NzOE=;
        b=kYXXlnHbgq0QwYKTbozBSIGZ+Km2YsDMzl1u4Ya1jcwC+5VuHDh09v/2PDP47Fw8OJ
         yjUR3RQbOH2GITKASmuBKczz16FJWk11HBK/iPqjqm2r5AeDkHj0d3Uhvkd0PZzJRcAE
         WZOb6d804jD0zikvtPSP4DoTRGDfahmNeeQAYNeDWA3VMf/G7z0KFVJG4Nte35lijBXF
         rB0DrkJBqD+/x9bBjycxzyzTcINC350GPBFtzlCWBAif94LtkL+lsPU+IgyTFNfQ9cF7
         qReeAEaztLo/tgzOd3WGULzXxY3yXyUxJ27vBNfe7rRwm9GCPURKqg6sSSrAQHPwHKji
         OV2g==
X-Gm-Message-State: AOJu0YyUXiu0z6qn2/mlHr6nenzSFuSnigudYYH3w2EAcM2AVx2dxI1a
	WaxTjs0QSr1fIS6h79wRnMaqcOK0eB6Kg7eWCqXLanWcIkmIALftNV8log7+g47tDlq6065HSet
	dNVM0Fw==
X-Google-Smtp-Source: AGHT+IHan7juNCTesxajsOJG+sgoRX3ywKoCLEi5QJfT5EvEdURi+6sFH21a+77jUqkiLHJ6mATnDLb5PRM=
X-Received: from pge25.prod.google.com ([2002:a05:6a02:2d19:b0:bc4:8a19:36d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:628d:b0:35b:d302:e7be
 with SMTP id adf61e73a8af0-35bd302fa22mr558094637.2.1763075667988; Thu, 13
 Nov 2025 15:14:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:18 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: SVM: Extract OS-visible workarounds setup to helper function
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the initialization of the global OSVW variables to a helper function
so that svm_enable_virtualization_cpu() isn't polluted with a pile of what
is effectively legacy code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 90 +++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0101da1a3c26..d3f0cc5632d1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -417,6 +417,54 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 		vcpu->arch.osvw.status |= 1;
 }
 
+static void svm_init_os_visible_workarounds(void)
+{
+	u64 len, status;
+	int err;
+
+	/*
+	 * Get OS-Visible Workarounds (OSVW) bits.
+	 *
+	 * Note that it is possible to have a system with mixed processor
+	 * revisions and therefore different OSVW bits. If bits are not the same
+	 * on different processors then choose the worst case (i.e. if erratum
+	 * is present on one processor and not on another then assume that the
+	 * erratum is present everywhere).
+	 *
+	 * Note #2!  The OSVW MSRs are used to communciate that an erratum is
+	 * NOT present!  Software must assume erratum as present if its bit is
+	 * set in OSVW_STATUS *or* the bit number exceeds OSVW_ID_LENGTH.  If
+	 * either RDMSR fails, simply zero out the length to treat all errata
+	 * as being present.  Similarly, use the *minimum* length across all
+	 * CPUs, not the maximum length.
+	 *
+	 * If the length is zero, then is KVM already treating all errata as
+	 * being present and there's nothing left to do.
+	 */
+	if (!osvw_len)
+		return;
+
+	if (!boot_cpu_has(X86_FEATURE_OSVW)) {
+		osvw_status = osvw_len = 0;
+		return;
+	}
+
+	err = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
+	if (!err)
+		err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
+
+	guard(spinlock)(&osvw_lock);
+
+	if (err) {
+		osvw_status = osvw_len = 0;
+	} else {
+		if (len < osvw_len)
+			osvw_len = len;
+		osvw_status |= status;
+		osvw_status &= (1ULL << osvw_len) - 1;
+	}
+}
+
 static bool __kvm_is_svm_supported(void)
 {
 	int cpu = smp_processor_id();
@@ -537,47 +585,7 @@ static int svm_enable_virtualization_cpu(void)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 	}
 
-
-	/*
-	 * Get OS-Visible Workarounds (OSVW) bits.
-	 *
-	 * Note that it is possible to have a system with mixed processor
-	 * revisions and therefore different OSVW bits. If bits are not the same
-	 * on different processors then choose the worst case (i.e. if erratum
-	 * is present on one processor and not on another then assume that the
-	 * erratum is present everywhere).
-	 *
-	 * Note #2!  The OSVW MSRs are used to communciate that an erratum is
-	 * NOT present!  Software must assume erratum as present if its bit is
-	 * set in OSVW_STATUS *or* the bit number exceeds OSVW_ID_LENGTH.  If
-	 * either RDMSR fails, simply zero out the length to treat all errata
-	 * as being present.  Similarly, use the *minimum* length across all
-	 * CPUs, not the maximum length.
-	 *
-	 * If the length is zero, then is KVM already treating all errata as
-	 * being present and there's nothing left to do.
-	 */
-	if (osvw_len && cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
-		u64 len, status = 0;
-		int err;
-
-		err = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
-		if (!err)
-			err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
-
-		guard(spinlock)(&osvw_lock);
-
-		if (err) {
-			osvw_status = osvw_len = 0;
-		} else {
-			if (len < osvw_len)
-				osvw_len = len;
-			osvw_status |= status;
-			osvw_status &= (1ULL << osvw_len) - 1;
-		}
-	} else {
-		osvw_status = osvw_len = 0;
-	}
+	svm_init_os_visible_workarounds();
 
 	svm_init_erratum_383();
 
-- 
2.52.0.rc1.455.g30608eb744-goog


