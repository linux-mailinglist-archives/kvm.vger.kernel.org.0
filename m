Return-Path: <kvm+bounces-48909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8F9AD465D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E3217ACBBE
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8BA26E70A;
	Tue, 10 Jun 2025 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zWeIDV5C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E226058E
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596305; cv=none; b=bGgeuuVkHyKMg28YaKpRXp6RhqFITn1l1AhnH4qoPpAZtfYY0GW3DY1z1OKUSjIPDq/LVWSfr/8i3uNWYHnYiqsk1HPW52e6jBZfyU5GxnUXc+XnIL37+t9nE/GeR06KTaZSzEX+ucACXZh2N4ohAnaBVTXuMQvX0DbSWXfpDSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596305; c=relaxed/simple;
	bh=c5jtKerqKCl4XHYQy4zQoY0B/Fac2DEBJ4FzYctBNv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aieCC/LE96s9bg2lFe46nsFEmhlgoxAhpKS9szDJ3uu9hzSVGLcyRnYMoLfy8Lqc9DHkdOWKTk2EO7gnZQx/HBYb0fg/oizTv6FF4UCKLejpg5uCbp4/wX6NfnIuEn0/yy3af02MX/iJUhq6HJN0kObAfjQa+lonES17ziZT5HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zWeIDV5C; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-312df02acf5so190135a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596303; x=1750201103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ngowtUk0pmcEMi5JuRIJTHwRoFQ1ps0rBy51903B/GI=;
        b=zWeIDV5CHVk0D/5klqWTa1coPM/vYL0/gH3lgbPMh4zgTMA1gSRjN563LRE0U1rCiK
         tLkOizHE0LEFMWwJet8vG4aXoX/WCPcCyuChQfndK2fPZgTtKYMBxl7WJyiSA9PSwJRP
         yiMuMXA1di7AtS+kgDPUagaOFbWAlcDXsEe3FbuJae6YvXHarulhdTHN/D28nafBbGQc
         064ar++kJjVaBNSJki63CVAWAKePlesEUJvgKuZyOHbC/utuT0jllagElQ8PSYl/kWqn
         sORFlGzbtunYMEnwVOYrC/x0+s36O39C6NssnOclOMzcshYESIxocWDvPERNxdtsfGBX
         rCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596303; x=1750201103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ngowtUk0pmcEMi5JuRIJTHwRoFQ1ps0rBy51903B/GI=;
        b=iqgsfSltZ8dksmriiUtrk6+YKQWupp6OZtoWyC/A6LCjdQk6e/ypwiO35ybKjUKt7M
         XN9OPMarh0yzsOrW75ETM3lcFkgjGZLi3+OhOBGp2suqh8h5TP6UIxpCg6QcK8Sy9Lov
         wF1njmTpn8La/2sCAPAMOSFqK43tO/vGqdE6gqVdRtH62ITt9D+KJ1f4G4WLH7lI4ciE
         4Im7/pNZNzjSHmFUEM9DOWGUTD6TbyKFO6kb1Y5flGe9BS/0qKSTX0kQerWefyXeODqR
         jYzWk5LIxs99BIYBbI4Y5sMMjeVXmrcG0/QA+T8sGto4U1gyHFDaOcnnJmmV9XWEzYN2
         LKBA==
X-Gm-Message-State: AOJu0Ywj+QjULLbd0/oadbTVXq7uO9cX+kGkKgc2OAhXoeKgpho6WCiR
	VhV98cheCx25nzB6Gb8U53Fplf8yHkGe1HaAIF/+qGaqmw5CO7jyy/NEmCUziyMkTytF1bQnnNt
	hgEJ8Ew==
X-Google-Smtp-Source: AGHT+IE8f4mjqFSxcWHB/Sxh/pqjjROaBQQ9c1q90hSKtUQsBQheucaQE9iY6C+1XXLQyaspE5G0Cxh4kFM=
X-Received: from pjbpx2.prod.google.com ([2002:a17:90b:2702:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3908:b0:311:ab20:1591
 with SMTP id 98e67ed59e1d1-313af9711a2mr1372038a91.15.1749596303034; Tue, 10
 Jun 2025 15:58:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:30 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-26-seanjc@google.com>
Subject: [PATCH v2 25/32] KVM: SVM: Move svm_msrpm_offset() to nested.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move svm_msrpm_offset() from svm.c to nested.c now that all usage of the
u32-index offsets is nested virtualization specific.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    | 23 -----------------------
 arch/x86/kvm/svm/svm.h    |  1 -
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cf148f7db887..13de4f63a9c2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -197,6 +197,29 @@ void recalc_intercepts(struct vcpu_svm *svm)
 static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 
+static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
+
+static u32 svm_msrpm_offset(u32 msr)
+{
+	u32 offset;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
+		if (msr < msrpm_ranges[i] ||
+		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
+			continue;
+
+		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
+		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
+
+		/* Now we have the u8 offset - but need the u32 offset */
+		return offset / 4;
+	}
+
+	/* MSR not in any range */
+	return MSR_INVALID;
+}
+
 int __init nested_svm_init_msrpm_merge_offsets(void)
 {
 	static const u32 merge_msrs[] __initconst = {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e4d08dba5f8..5008e929b1a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -195,29 +195,6 @@ static DEFINE_MUTEX(vmcb_dump_mutex);
  */
 static int tsc_aux_uret_slot __read_mostly = -1;
 
-static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
-
-u32 svm_msrpm_offset(u32 msr)
-{
-	u32 offset;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
-		if (msr < msrpm_ranges[i] ||
-		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
-			continue;
-
-		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
-		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
-
-		/* Now we have the u8 offset - but need the u32 offset */
-		return offset / 4;
-	}
-
-	/* MSR not in any range */
-	return MSR_INVALID;
-}
-
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 91c4eb2232e0..a0c14256cc56 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -666,7 +666,6 @@ BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 /* svm.c */
 extern bool dump_invalid_vmcb;
 
-u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
-- 
2.50.0.rc0.642.g800a2b2222-goog


