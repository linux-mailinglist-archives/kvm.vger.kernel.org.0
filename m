Return-Path: <kvm+bounces-43790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 211B5A961E6
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A410D3BB31B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67A527BF7D;
	Tue, 22 Apr 2025 08:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JnWtZCem"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A8026E160;
	Tue, 22 Apr 2025 08:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310245; cv=none; b=WhZqLcr0UPLbImoaLZd1TjLTZYmtVBNuES/50wKjpYgawihnqjnwULgRGWBKyq4gsoZFMtSeEIsVI2wdCvE1mDggQHrV19AuBelCKQGsPNxjv5J/wRgvqw94tmLVI3RwOZm+Gpp3j0zv3r3DZFqGhLkd6OiPnxT+IJs8dezwA2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310245; c=relaxed/simple;
	bh=aWr+xmLoTKg2tDQZaCGwz9J/S4J+P9FdT8tCeINTuvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acAugUCEI627UEKOGB8B9AHRxr83yv4JH5DkB4Eunn0X5U9wjwGsKagQtQX3V050BhrR9aTmh3BD2jsYLOi0f55pdIuh1/+pYuJI1vTXjN/Q19JzeeUGINf7kq9yri4LfuP7nP+6Wa1Qn9GCN/dFAl9Dt/ztnYdpj0f+0L+LXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JnWtZCem; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9j1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9j1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310205;
	bh=PfH0d70H/awMl+pIfi176SABhujHw41azze32+OJXmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnWtZCemkFX6NCD7mP/s8qoAFT3h3Gb+Fvc+J5Mk02eaVtZrWyrmVnlpXwmVAvy41
	 houfWnQz9wGOKn2yRaZanE3IjEltuS0f/5cW2rlJmBwVly9l6LLAqVurtWi3thuZcM
	 ji5BPEgLgOQkXAsMX4hjSxG1dqBUP9qrDSURde+feL4tlBBsfHS0nQPq1ugkmkwkBm
	 Qf94NiRrS85WPrGN0VWgL6mlH/GHv4SGGPAIIC3MsntY56esV8EU1L6d8KeTVhVlvC
	 nqDxaHuS3Och/kSL44qglJbmmo1kO2jM0JXyCV2y6tezwHqg8Wal5lhgPQfwgfhBGG
	 UQBpBNOph9P0Q==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 31/34] x86/msr: Rename native_read_msr() to native_rdmsrq()
Date: Tue, 22 Apr 2025 01:22:12 -0700
Message-ID: <20250422082216.1954310-32-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/hyperv/ivm.c      | 2 +-
 arch/x86/include/asm/msr.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index dfddf522e838..8860c6c0f013 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -319,7 +319,7 @@ int hv_snp_boot_ap(u32 cpu, unsigned long start_ip)
 	asm volatile("movl %%ds, %%eax;" : "=a" (vmsa->ds.selector));
 	hv_populate_vmcb_seg(vmsa->ds, vmsa->gdtr.base);
 
-	vmsa->efer = native_read_msr(MSR_EFER);
+	vmsa->efer = native_rdmsrq(MSR_EFER);
 
 	vmsa->cr4 = native_read_cr4();
 	vmsa->cr3 = __native_read_cr3();
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index dfaac42b6258..4c7aa9e7fbac 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -160,7 +160,7 @@ static __always_inline bool is_msr_imm_insn(void *ip)
  *        native_rdmsrq_no_trace()    native_read_msr_safe()         |
  *                   /      \                                        |
  *                  /        \                                       |
- * native_rdmsr_no_trace()    native_read_msr()                      |
+ * native_rdmsr_no_trace()    native_rdmsrq()                        |
  *                                                                   |
  *                                                                   |
  *                                                                   |
@@ -263,7 +263,7 @@ do {							\
 	(void)((high) = (u32)(__val >> 32));		\
 } while (0)
 
-static inline u64 native_read_msr(u32 msr)
+static inline u64 native_rdmsrq(u32 msr)
 {
 	u64 val = native_rdmsrq_no_trace(msr);
 
-- 
2.49.0


