Return-Path: <kvm+bounces-43778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F94A96190
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A2BF3AC67E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743C226A0D1;
	Tue, 22 Apr 2025 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PxUOo6k2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F7265CC0;
	Tue, 22 Apr 2025 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310240; cv=none; b=a7Qww9YUgn+fcZm4L4GOpM7vG3PZ0P2XZsvE3d6uuk7vFcZtnRmEtru1kzTVTseMt7SWmaDGJdGCHl4S34Qam+PJxRjFMZt1aJLeHM7bKTM4anBFyIvB2C++bFULg/47qCOJLNKy8LxQ5aamMaLQOShkSbhgTQ22UrpY2Z4lGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310240; c=relaxed/simple;
	bh=fFY2exO1b2EjO/RUxQ7qiqFgDPzzyBF3dGw0te3RS3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaRvbCd2I13K4Eue5/GUj+bmdvQ8gcnyAIYs8Z2He1uri1aEGm9ZuoNAeZXnwKPo3pisoFAS6DPaQQGu2zw1pWFsZ2ud/yt2CgJd2Q4qMRTupW18c0Dw+GwfuGp+n+METS4A20c38DjphVbC4zEwjDjYVPB70SFRm0mGp5C4mD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PxUOo6k2; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9Q1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9Q1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310167;
	bh=1VgQf4QInSDQLzZ+1XUhguUTrkXvawFaEvDB+uGxtVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxUOo6k2ygRA60Nwwh//GGmJ2Ha25YqcuuadFmBT9kb1B0PYfv6Aywtx1iVRLb9BX
	 Fj19RkC5hv8Sp/5xrXDu9u9ly5DcABPKX/vm0TRbuxcIZElbLl9gCac7HgrOAD88Tn
	 2pYSZ/+5KDeI4ZgydWimYqeKvfaOFnXYFTKuKkphpfKHP7Oxq5j7JldvtBkd7nq6BZ
	 t/NtOGh8DANYccVS0g5u+IJWleUBogtX3IuQR6ftaSD3LJp8UXHEPuFjDNC7EcRq10
	 df5RT52Kc7UjBWr8D24hnur7y8Zo5qGDf32z3E6BpdSccjOFnylRA2HEY5y5jIKf7W
	 fG4OSdCdfxxgw==
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
Subject: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
Date: Tue, 22 Apr 2025 01:21:53 -0700
Message-ID: <20250422082216.1954310-13-xin@zytor.com>
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

As pmu_msr_{read,write}() are now wrappers of pmu_msr_chk_emulated(),
remove them and use pmu_msr_chk_emulated() directly.

While at it, convert the data type of MSR index to u32 in functions
called in pmu_msr_chk_emulated().

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/xen/enlighten_pv.c | 17 ++++++++++-------
 arch/x86/xen/pmu.c          | 24 ++++--------------------
 arch/x86/xen/xen-ops.h      |  3 +--
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 1418758b57ff..b5a8bceb5f56 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1089,8 +1089,9 @@ static void xen_write_cr4(unsigned long cr4)
 static u64 xen_do_read_msr(unsigned int msr, int *err)
 {
 	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
+	bool emulated;
 
-	if (pmu_msr_read(msr, &val, err))
+	if (pmu_msr_chk_emulated(msr, &val, true, &emulated) && emulated)
 		return val;
 
 	if (err)
@@ -1133,6 +1134,7 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 			     unsigned int high, int *err)
 {
 	u64 val;
+	bool emulated;
 
 	switch (msr) {
 	case MSR_FS_BASE:
@@ -1162,12 +1164,13 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 	default:
 		val = (u64)high << 32 | low;
 
-		if (!pmu_msr_write(msr, val)) {
-			if (err)
-				*err = native_write_msr_safe(msr, low, high);
-			else
-				native_write_msr(msr, low, high);
-		}
+		if (pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated)
+			return;
+
+		if (err)
+			*err = native_write_msr_safe(msr, low, high);
+		else
+			native_write_msr(msr, low, high);
 	}
 }
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 95caae97a394..afb02f43ee3f 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -128,7 +128,7 @@ static inline uint32_t get_fam15h_addr(u32 addr)
 	return addr;
 }
 
-static inline bool is_amd_pmu_msr(unsigned int msr)
+static bool is_amd_pmu_msr(u32 msr)
 {
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
@@ -194,8 +194,7 @@ static bool is_intel_pmu_msr(u32 msr_index, int *type, int *index)
 	}
 }
 
-static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
-				  int index, bool is_read)
+static bool xen_intel_pmu_emulate(u32 msr, u64 *val, int type, int index, bool is_read)
 {
 	uint64_t *reg = NULL;
 	struct xen_pmu_intel_ctxt *ctxt;
@@ -257,7 +256,7 @@ static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
 	return false;
 }
 
-static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
+static bool xen_amd_pmu_emulate(u32 msr, u64 *val, bool is_read)
 {
 	uint64_t *reg = NULL;
 	int i, off = 0;
@@ -298,8 +297,7 @@ static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
 	return false;
 }
 
-static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
-				 bool *emul)
+bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read, bool *emul)
 {
 	int type, index = 0;
 
@@ -313,20 +311,6 @@ static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
 	return true;
 }
 
-bool pmu_msr_read(u32 msr, u64 *val)
-{
-	bool emulated;
-
-	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
-}
-
-bool pmu_msr_write(u32 msr, u64 val)
-{
-	bool emulated;
-
-	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
-}
-
 static u64 xen_amd_read_pmc(int counter)
 {
 	struct xen_pmu_amd_ctxt *ctxt;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index a1875e10be31..fde9f9d7415f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -271,8 +271,7 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool pmu_msr_read(u32 msr, u64 *val);
-bool pmu_msr_write(u32 msr, u64 val);
+bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read, bool *emul);
 int pmu_apic_update(uint32_t reg);
 u64 xen_read_pmc(int counter);
 
-- 
2.49.0


