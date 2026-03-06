Return-Path: <kvm+bounces-73015-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPTwEqWqqmnjVAEAu9opvQ
	(envelope-from <kvm+bounces-73015-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:21:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F4021E985
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 25CCD3023041
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F86037BE7C;
	Fri,  6 Mar 2026 10:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q8JHiOQ4"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2F33B6D1;
	Fri,  6 Mar 2026 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792480; cv=fail; b=JAMTyCGz3cdh6kJSDCjDdrCJIPYA6cW2U+KqWLta659GBlYpC8JgSbUXMQhxVn6M8MJ3RQfXYhxIN3aiZSdO8V/8m9LmkPhoTLtLUHuDkiWJy5jQILtcscWEdeMeDALr676D6uBnl2AeWI/HlIwz5qmmuBmb1UJPdIBhS0CF4eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792480; c=relaxed/simple;
	bh=NxiehPBOdYcUbm6csZYPh4mb8iPDEgp64OI0r870AA8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ph0OrsmFQSya540zHWoBSIqiY3CZB1i5nhHIck/yR+dTsfScKMC/srrajA1XOTeQ0DRB2j7N9bs7rS0ipvMaOlHLot0yxMlyy/22Dsavp0coIXrBDqa6ti+Cw9lS0bYBQzOITLHWWTnGHVgVEhkdnS889vh/2PuLo3gKtqs7OSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q8JHiOQ4; arc=fail smtp.client-ip=40.107.200.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpFHFHM6nJVNCh9kahetqny7Lwx/aeGFuI4fD2UxpE0D+PVj9U5nkxS2reNhIHUF1NmYozM1fFe9iGEdxUX2AwmM/AqLOrC9Z7FjYyIK6Ti9ELI36k7GBlS4SXr5WwJclqEiSwK+9+GjU2oR2IIctgs8zdWY0H4rWDp4JekGpF4SrTePjoy9mmd0R0WQdZb+R8dlPF2MnzVuG7pypwH6Phjt5Kw1boKi+c9RsQEsZNGdUmHMC+uamyarLKjdmYL06nGHkGPtq9ssSDk+nkaZWXccIQkbB6sg3NnQ78ZNSnvlmuk+g5Og5+IuLaQvA/j1HuWSu5e9LvtDdAFO3ASKZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQZjczQZ/IRBefRoD4deUjqaAoeeVFMQI/jZsO2yTVk=;
 b=U/YP+T4iXVJ0vLp/vBhYQaomdMvZ6ueYWqvtJCkUyNFFmzcqAnGr1/Xonzlj2KNJLErAe0m507iQxNSy+WBdyJcb3XgQQg49Ki+79w1ZRPQC0qJH7YN6YFsHY17C68UDUMOYcyrUb6j+uDLMheTnCfnyS2BXqhT0i1CAtqGm+KowMi6gBmo59o95FDBr+Qkm3U+U0xJ1riNjS+42aurNdW+Mg/RIXuokWJq0JO7lhRqo3sO4LfmKWxxwSiKJmJ7TKZqryBf2617+YHu7tLf7hnLaTSKU3r/dwVawDw8a/2rLTJY5uq6jPfn2a9T+gdTu6+ByVG+IjIaWiavHqCxgPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=zytor.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQZjczQZ/IRBefRoD4deUjqaAoeeVFMQI/jZsO2yTVk=;
 b=q8JHiOQ4ktWMzHsx5i8leaCE/TgIX6TnB5MDnvg9X9jiYh27RI1y62Xy7/4Hpp5Xv786BLH/NSMxSh8RZKV2SUKdEDWlAQmQch6vNlvsmK/89YzHAF/OawxsJ/CvN6yHY5SVhJuqIO9qfn9BcTV90CEqIYy3VUeLIq0I6/YILkw=
Received: from BN0PR04CA0043.namprd04.prod.outlook.com (2603:10b6:408:e8::18)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.22; Fri, 6 Mar 2026 10:21:15 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:e8:cafe::88) by BN0PR04CA0043.outlook.office365.com
 (2603:10b6:408:e8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.19 via Frontend Transport; Fri,
 6 Mar 2026 10:21:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Fri, 6 Mar 2026 10:21:15 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Mar
 2026 04:21:11 -0600
From: Sairaj Kodilkar <sarunkod@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <suravee.suthikulpanit@amd.com>, <vasant.hegde@amd.com>,
	<nikunj.dadhania@amd.com>, <Manali.Shukla@amd.com>, Sairaj Kodilkar
	<sarunkod@amd.com>
Subject: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
Date: Fri, 6 Mar 2026 15:50:47 +0530
Message-ID: <20260306102047.29760-1-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|DM4PR12MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8dc440-ff5a-477e-0025-08de7b6a194b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	UvPlLwQp98mM3LxtDnTWl5+O3r1lIESTJu3WuhloplyI8oWT0njnJUtwKJBby4BQN1KcvlSgZNrNtdqFyF7N8/s1pgyvCfxTftcfv3u1KntgGfVYo1azcujDXhSyiYw7eSAyi3l26SsUBouqHJIjGNiX0pk6NS1LLHpHZ1W8wZoJxcF5C/otfd2Aw3A545L4NTF5A4+Sij2WjqibYtVQ9nqiftTUJsmwqj00uVYE1GY/s7InQIC1Atm2S9GK+yTVlr01kYAKDX4areVoRjIxONhZLU6f3D7aHVl2ASMnU9QFG+/pVTHgBzp/NtLfxqJouRvwyFeRHTGLk7E91w5+h+91lSI4NhwM+50UtejgDT9aWIOyEprUY9kyVbuPsJVqlJux5EwwfftJASvLxvnd6nrcNyP9FGubqWMPtxO+4DKMr5Q3EAohL6hGSocI21xSNLduIz42zr1is6w6RRVPKJrHEnko3zfk0cR2tr2J7RiSDnCOPRDAGdy/j5wMqsdOoko0NYyBB/CDDbyryjM5nhedPZ9WeJw9t9uMNGb7Hwu7xFbW8zNuAMVpPL7cC1O8r6i38kujNKuDZeD1VLIBhoA5PRHwARjmjski5dQKWvG/UYBcJEcRV04oulvcp6YHKIo1/8xffccfH0gimNm/hZWNfjzy6hAa5iP19lBaMSeCSQtfPTlBZf3JghMtEWpSFjv/7iG/kcmQ4wnJJSSgvjoff/0MphXM1aH15WWfpXKbqDs2ORZCXxKAQU4KFN9AukR5JJpVIWsj7DZTSy/ezQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aJeG7OKWPCa7vW0+OuwhIPG0LGQnKx4XjsHEvJeykVscM1mIAf234K1Jz4UsYOLM120PepP4leGho0BzaYmJkXuTB5OXlS1z5moWknslu8yshUuNVwVbubxu8JVG5ff7by8bOnL/H0rWkwZkz0bD2R0dqPouGRu6xpIM9VRH48DE5X3EVqnWMQ/6XZML1m/+3/mmfBd+jAuN53AQDhugrdGXSL80ZU1NijxdiQ8sERdKbAszrfl8vLS4ZWFd+SkLhs11SVbJpFR/ro6Vhdy79b1UNRt0aR++L3OzSCABZWNY7gx5PXctlW7AEnOVquwost/d5ctu3P9I7dMsyc4M7zqqe5NwtQO2d5nv6yzf8ktY/FGrrReqp3ZiBgztct1k76zOC6KjOusJZmP0z/TGWlD5JxjCG5Na5z3pbAgT5HIBnG1pjlRvXIa3H3tMsXj4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 10:21:15.3882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8dc440-ff5a-477e-0025-08de7b6a194b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745
X-Rspamd-Queue-Id: B1F4021E985
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-73015-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sarunkod@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

AMD and Intel both provides support for 128 bit cmpxchg operands using
cmpxchg8b/cmpxchg16b instructions (opcode 0FC7). However, kvm does not
support emulating cmpxchg16b (i.e when destination memory is 128 bit and
REX.W = 1) which causes emulation failure when QEMU guest performs a
cmpxchg16b on a memory region setup as a IO.

Hence extend cmpxchg8b to perform cmpxchg16b when the destination memory
is 128 bit.

Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
---
Background:

The AMD IOMMU driver writes 256-bit device table entries with two
128-bit cmpxchg operations. For guests using hardware-accelerated
vIOMMU (still in progress), QEMU traps device table accesses to set up
nested page tables. Without 128-bit cmpxchg emulation, KVM cannot
handle these traps and DTE access emulation fails.

QEMU implementation that traps DTE accesses:
https://github.com/AMDESE/qemu-iommu/blob/wip/for_iommufd_hw_queue-v8_amd_viommu_20260106/hw/i386/amd_viommu.c#L517
---
 arch/x86/kvm/emulate.c     | 48 +++++++++++++++++++++++++++++++-------
 arch/x86/kvm/kvm_emulate.h |  1 +
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..e1a08cd3274b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2188,17 +2188,18 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
 	return rc;
 }
 
-static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
+static int __handle_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 {
-	u64 old = ctxt->dst.orig_val64;
+	u64 old64 = ctxt->dst.orig_val64;
 
-	if (ctxt->dst.bytes == 16)
+	/* Use of the REX.W prefix promotes operation to 128 bits */
+	if (ctxt->rex_bits & REX_W)
 		return X86EMUL_UNHANDLEABLE;
 
-	if (((u32) (old >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
-	    ((u32) (old >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
-		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old >> 0);
-		*reg_write(ctxt, VCPU_REGS_RDX) = (u32) (old >> 32);
+	if (((u32) (old64 >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
+	    ((u32) (old64 >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
+		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old64 >> 0);
+		*reg_write(ctxt, VCPU_REGS_RDX) = (u32) (old64 >> 32);
 		ctxt->eflags &= ~X86_EFLAGS_ZF;
 	} else {
 		ctxt->dst.val64 = ((u64)reg_read(ctxt, VCPU_REGS_RCX) << 32) |
@@ -2209,6 +2210,37 @@ static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int __handle_cmpxchg16b(struct x86_emulate_ctxt *ctxt)
+{
+	__uint128_t old128 = ctxt->dst.val128;
+
+	/* Use of the REX.W prefix promotes operation to 128 bits */
+	if (!(ctxt->rex_bits & REX_W))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (((u64) (old128 >> 0) != (u64) reg_read(ctxt, VCPU_REGS_RAX)) ||
+	    ((u64) (old128 >> 64) != (u64) reg_read(ctxt, VCPU_REGS_RDX))) {
+		*reg_write(ctxt, VCPU_REGS_RAX) = (u64) (old128 >> 0);
+		*reg_write(ctxt, VCPU_REGS_RDX) = (u64) (old128 >> 64);
+		ctxt->eflags &= ~X86_EFLAGS_ZF;
+	} else {
+		ctxt->dst.val128 =
+			((__uint128_t) reg_read(ctxt, VCPU_REGS_RCX) << 64) |
+			(u64) reg_read(ctxt, VCPU_REGS_RBX);
+
+		ctxt->eflags |= X86_EFLAGS_ZF;
+	}
+	return X86EMUL_CONTINUE;
+}
+
+static int em_cmpxchgxb(struct x86_emulate_ctxt *ctxt)
+{
+	if (ctxt->dst.bytes == 16)
+		return __handle_cmpxchg16b(ctxt);
+
+	return __handle_cmpxchg8b(ctxt);
+}
+
 static int em_ret(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
@@ -4097,7 +4129,7 @@ static const struct gprefix pfx_0f_c7_7 = {
 
 
 static const struct group_dual group9 = { {
-	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8b), N, N, N, N, N, N,
+	N, I(DstMem64 | Lock | PageTable, em_cmpxchgxb), N, N, N, N, N, N,
 }, {
 	N, N, N, N, N, N, N,
 	GP(0, &pfx_0f_c7_7),
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53..a1e95c57d40e 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -268,6 +268,7 @@ struct operand {
 	union {
 		unsigned long val;
 		u64 val64;
+		__uint128_t val128;
 		char valptr[sizeof(avx256_t)];
 		sse128_t vec_val;
 		avx256_t vec_val2;
-- 
2.34.1


