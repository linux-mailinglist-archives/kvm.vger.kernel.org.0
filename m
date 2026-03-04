Return-Path: <kvm+bounces-72722-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JFRNIV6qGmHuwAAu9opvQ
	(envelope-from <kvm+bounces-72722-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:31:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE0320660F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 131E5318852B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64EF3D3D14;
	Wed,  4 Mar 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="guorWFut"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161223D34A9
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648114; cv=none; b=rQidtrdiG02RDANwyb98vB6URK4tJOY16zxmnHHk2/3WV2TwCPEsbjvsW9wRkxlAyAl1KajP1B/zNx/0LZudad/n/nicR35m1Av1tOR+YQi+goMIPbxTV4iB6u+vnMid2/t86nwdvRQDAgMpzpuFV+rLdpllk1acSB2+MT6Ev7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648114; c=relaxed/simple;
	bh=w0fJWokOyWUWajqVIT+j5dZD4HdLLo1t7Fu/mRVcycI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9BrgKbLve9fsU65eEJhFh/OBae6adlhUwiBip5Oh7rpTovyGU4RYeRI6s+kOwGjvRidWkiKmP1+Tx4kZLY1Dd14QxpgAHHVT/A8j53+uNMdkVHE1C0oZptbmWsbElaAR/Kbis6Bs5MMoTid5lOQfofwutq07anNwQlAL71GGCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=guorWFut; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648113; x=1804184113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w0fJWokOyWUWajqVIT+j5dZD4HdLLo1t7Fu/mRVcycI=;
  b=guorWFut5nhmLhEC0eSJVFp+DKCNGyYbqAZe5p36oXDpC/E8c/ZjTZYp
   0laCcVL6GMAo9rlSzdqMBb0g2h+ua/XefOVG7oITlR2DzhkRnmLwuQSje
   +omFRRI3uW4NF8TsfqKaB4qPScovqsGLTyyVFM3O4So/P2kghtvzFUYxP
   7IO4tpcSK9sl53dzz2Q2dtSvNhAgrCisStA+DsBMcS9poQEthi2IvNyJW
   vI8JrkWpIz6iHTMV+dT1H4z7UgUT9VIEQ18lryZF9CXAzDteDhDIKyCEo
   MhpR0sON0lI1IwSjE3pXIARlukSlNHrfhDhCD7toxKvqXSmPpEDvb7wbS
   w==;
X-CSE-ConnectionGUID: ZLOwOpdUR8GLOepllSCiKQ==
X-CSE-MsgGUID: UXhMkV/LREy2k0evfOrgrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909308"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909308"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:12 -0800
X-CSE-ConnectionGUID: DcMg9nmPQqGWiHwMF3Gjag==
X-CSE-MsgGUID: dAKDEJrLSFazhBKLONOqCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542797"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:11 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 04/13] target/i386: Adjust maximum number of PMU counters
Date: Wed,  4 Mar 2026 10:07:03 -0800
Message-ID: <20260304180713.360471-5-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FE0320660F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72722-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Changing either MAX_GP_COUNTERS or MAX_FIXED_COUNTERS affects the
VMState layout and therefore requires bumping the migration version
IDs.  Adjust both limits together to avoid repeated VMState version
bumps in follow-up patches.

To support full-width writes, QEMU needs to handle the alias MSRs
starting at 0x4c1.  With the current limits, the alias range can
extend into MSR_MCG_EXT_CTL (0x4d0).  Reducing MAX_GP_COUNTERS from 18
to 15 avoids the overlap while still leaving room for future expansion
beyond current hardware (which supports at most 10 GP counters).

Increase MAX_FIXED_COUNTERS to 7 to support additional fixed counters
(e.g. Topdown metric events).

With these changes, bump version_id to prevent migration to older
QEMU, and bump minimum_version_id to prevent migration from older
QEMU, which could otherwise result in VMState overflows.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.h     | 8 ++------
 target/i386/machine.c | 4 ++--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6d3e70395dbd..23d4ee13abfa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1749,12 +1749,8 @@ typedef struct {
 #define CPU_NB_REGS CPU_NB_REGS32
 #endif
 
-#define MAX_FIXED_COUNTERS 3
-/*
- * This formula is based on Intel's MSR. The current size also meets AMD's
- * needs.
- */
-#define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
+#define MAX_FIXED_COUNTERS 7
+#define MAX_GP_COUNTERS    15
 
 #define NB_OPMASK_REGS 8
 
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 1125c8a64ec5..7d08a05835fc 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -685,8 +685,8 @@ static bool pmu_enable_needed(void *opaque)
 
 static const VMStateDescription vmstate_msr_architectural_pmu = {
     .name = "cpu/msr_architectural_pmu",
-    .version_id = 1,
-    .minimum_version_id = 1,
+    .version_id = 2,
+    .minimum_version_id = 2,
     .needed = pmu_enable_needed,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT64(env.msr_fixed_ctr_ctrl, X86CPU),
-- 
2.53.0


