Return-Path: <kvm+bounces-44505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D40A9E1DE
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03F571A84EE1
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0B42561C5;
	Sun, 27 Apr 2025 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KWyRQEL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377DC252288;
	Sun, 27 Apr 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745696; cv=none; b=DI0gz4H2t8y9N9NpOiaQIRleSFy0/KsJu1k1Ite+CW5pLmuwXXoRaFHAwU+sC1GPB1hoGaVqQm/K08I9wQQAqp1a9ta6cA2f9XOXLiFqQ/C+T5msR2RFnEtWn0K8K0T5pMIeELKn8BfCdJ3dyQRku9xNsgXSqJ5hNzTQX4bxAuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745696; c=relaxed/simple;
	bh=pW3voMF8Xqx6GB4G/eyK4Dk3grrAReZ5nJVKI31Bgdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA836qL7b/TXZ2qruC7l8G4LlojlcRPsuj5tCydZmV7ht7blfPW1XFHoBVPlOoYflKNgbW86eMThJHIpYFUy6gvteGNLjZg2XoX9z9P12v4W5Udq9m/jw+y6/TqqsLxGi1CbyJAYzhhw0H+xFUZEs8HEoORzBopr1QtYJL3sX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KWyRQEL6; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRS31598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRS31598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745646;
	bh=ww5dv1kvWZ0hKlTWKo3XMFLAAgaLDk8n8xkXdISYuaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWyRQEL66fAHV5eykZ+izg3lbpESUMtd68WZhhJwP14wWG/hgXkgGIvWv0ZXV/gOD
	 Mw8D+vKdE6Qskwm5qPFDUCPHnQ7ncyfk9wV5UaHbeMBo0b8YJSjBSb5+YWDgidWJb2
	 bskcxi6K7ytWT3S0BGqcFT7kelRsaDt4wCITFMW8vERo8a0GziQKM7YSO8CbBPc8L3
	 5eBh5oms9QnwzLqAzEhhBk5fgV1EPx0Frh5WjPHmbdwplf8X4aOym1U3sU58RMmE2E
	 bDNrkJzlL5ku6Y53PblHMjUL9I7Uskk38Od3ywKhjfyPrR93UZa4n29vPs87Rj31qa
	 8xhVQE6+v9+HA==
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
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 06/15] x86/xen/msr: Return u64 consistently in Xen PMC read functions
Date: Sun, 27 Apr 2025 02:20:18 -0700
Message-ID: <20250427092027.1598740-7-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pv_ops PMC read API is defined as:
        u64 (*read_pmc)(int counter);

But Xen PMC read functions return unsigned long long, make them
return u64 consistently.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/xen/pmu.c     | 6 +++---
 arch/x86/xen/xen-ops.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index f06987b0efc3..9c1682af620a 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -346,7 +346,7 @@ bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err)
 	return true;
 }
 
-static unsigned long long xen_amd_read_pmc(int counter)
+static u64 xen_amd_read_pmc(int counter)
 {
 	struct xen_pmu_amd_ctxt *ctxt;
 	uint64_t *counter_regs;
@@ -366,7 +366,7 @@ static unsigned long long xen_amd_read_pmc(int counter)
 	return counter_regs[counter];
 }
 
-static unsigned long long xen_intel_read_pmc(int counter)
+static u64 xen_intel_read_pmc(int counter)
 {
 	struct xen_pmu_intel_ctxt *ctxt;
 	uint64_t *fixed_counters;
@@ -396,7 +396,7 @@ static unsigned long long xen_intel_read_pmc(int counter)
 	return arch_cntr_pair[counter].counter;
 }
 
-unsigned long long xen_read_pmc(int counter)
+u64 xen_read_pmc(int counter)
 {
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return xen_amd_read_pmc(counter);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 63c13a2ccf55..735f58780704 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -277,7 +277,7 @@ static inline void xen_pmu_finish(int cpu) {}
 bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
 bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
 int pmu_apic_update(uint32_t reg);
-unsigned long long xen_read_pmc(int counter);
+u64 xen_read_pmc(int counter);
 
 #ifdef CONFIG_SMP
 
-- 
2.49.0


