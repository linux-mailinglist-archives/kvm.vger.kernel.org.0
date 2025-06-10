Return-Path: <kvm+bounces-48821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FCAAD4152
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423AB17C033
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894892472A4;
	Tue, 10 Jun 2025 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C5fiizCR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46969245028;
	Tue, 10 Jun 2025 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578197; cv=fail; b=CVnqOLquSKr9AuO+cceLl77OG1UmSmSRdBy4hvwnr8/tF7HNHCjy53hF01BFWMwzF/u/xJrHgT5Ii6AsXTpIJmK3Elb3bPETDya2JzsEzLVyxxwhHYTebwXxPAE779O0GCqIJeFUAdmNh8Bm2CiAjVpHrMZBaxVx3r5NTrhTe/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578197; c=relaxed/simple;
	bh=+Iv6pb1VUktJUUZZV3eeBWm2HUIJUVegFDrnbRmxeaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gR7uXAv/rc2eiGJ87UehQLS3vBZ16pzIleDXD+2fo+/SSeghZVb23KNqq3Tk1NSzWe+gDy70gth0BKlf7jeb3IRn4FXwjnbJ6wMJ1dKcn3r3jHYMucySCNY9rdPuDEwFJGNKZZETthw0S8EFPme13fb/loSobqvIDA5i2QvAm+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C5fiizCR; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8msASahqEZWqHkmljTCRiAkj2ufkzlS5c3fYO+NJs8zXK01kM+QYomJ9HmDMEnSnYgxiwSuvyMAgNgMo0lZvI3v3Mn73w2frfifNMwBZueBlRZUCNgf7p7Ne+SovoOIxJHUZCVBsg8bDofwZozbwi8bQJ0SOF/OnKYkJZeHZHm43ltmyQw4IAbJMghs3awXxG20WMA4tNXBFKJ5abspbSD2oyhaOy1yz8ypdinkVsMDvEuqRhUDID5aiX0CBqPT6QKstdP6fY9z19OmhPYRTsg26+fdu/2vX7ZiS6XtiDzVxCl8//vHZuYFML8wgqgfyzygBamlSnd57Tf3s1MtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBgwPSooq+6Fs/zPKxJqn9/m2JQj7FSM7mLP9mEuNe4=;
 b=xPO3D7lFxQJkg8eQslfTkH+8B0Mucma9MMabJUJLBb0a4hIwZWZP9xMrRHrigDV/WDNXIqi4q9pUudsQ11LcdpSHqXt/EA8p8KH3PTo1ypa2V7sT+agcGo+4afvzAjbC/90zIQA3yvBeayVx0Ol7/u//foKZKp7pvzH2r2Oo2fH7TyE93z3C4/l7p8jv/s5VSUFENnF6tAhwi9hrduwXEfUxA5dsiXRfNaWiGmkPllKpSOfraXWA3/Eh6ydiwHZaQbK59Pr/wFDze1W45gcn0tOCR1rhPUGLUUCQmQMbJicj4iFq+WRh1DrlCdWqjnPAo+I0rn921TjnmtkWgUevNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBgwPSooq+6Fs/zPKxJqn9/m2JQj7FSM7mLP9mEuNe4=;
 b=C5fiizCRXjxGETv4/fpkPeVgLpUz+qHuuDmYe53nXZVXASNlpNFRA8Vz7lVFf8s1toCdXkWYsFhGnaQIRyQ7maDrj5VX/Jlo/uQ/vfHFeDp0Avkef54pzs63mcQK8kfe2QxVRA82avETIjUZbX2wI9O0lmvgRSEHpZeV3Ob/cTA=
Received: from CH5PR05CA0001.namprd05.prod.outlook.com (2603:10b6:610:1f0::19)
 by IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 17:56:34 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::a0) by CH5PR05CA0001.outlook.office365.com
 (2603:10b6:610:1f0::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.18 via Frontend Transport; Tue,
 10 Jun 2025 17:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:56:33 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:56:26 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 05/37] KVM: lapic: Change lapic regs base address to void pointer
Date: Tue, 10 Jun 2025 23:23:52 +0530
Message-ID: <20250610175424.209796-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|IA0PR12MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9d310e-866c-400c-9c2b-08dda848232f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HeeF/L2OYwceoDUzsg23jer0510EFEMwzXglwO5vOhWN5s/teAaSUac4RsWp?=
 =?us-ascii?Q?IkpZhWmUyDNvguvRRgdX5a19+DubBEFgLRIH6sID2nArwdDgnmkta5YJWx6B?=
 =?us-ascii?Q?1dOg97MlS9m7DVuQZti98vTsGeafbQdIyddjXTS61e4Qd2MeKrNCrdQU+ma6?=
 =?us-ascii?Q?w+3hSn8faq5r440GAGWLq+nqQ7nhfEg9KQXGgOZCidbcXYjmRzOWLxXddxku?=
 =?us-ascii?Q?mx4Qaon8hF/TaEwsuG7wswwiP52MytE0WYyw/q3AeGDOLD6+jTaipoQZ2c8x?=
 =?us-ascii?Q?exvc6qquOTjJXfEaU5G2O+DFESuZt93XOq3fohThNtN2+PIFBEolEx26NVMw?=
 =?us-ascii?Q?6Y0NNaaPwcBEP/dQ76FwjscWYzAYsntuBTpx/Wf/B4oACIPFZVJosOWPCG2L?=
 =?us-ascii?Q?UZS33FnYOQ1f5M0X3USlTwsW6FJk0vLPbbSfigMFG4XVyPZFPcAzg4tkpjOo?=
 =?us-ascii?Q?ysCqF+c4fbK1F6ISbm+OUkc4GJgwdz/0cVmvLuPfgqDTSato+4DW+p+fGmo4?=
 =?us-ascii?Q?FwvnRKcRoK3Rnc5INVhD75dioFPCQmZ4YOLJ3qEY3dITeRvVGktFUeYvMT4k?=
 =?us-ascii?Q?NwCqQeZQtiijySPnoPwCD74HXvoVEBkkG4gwPYjq4BlVma6Yl8D1lZuDT5wz?=
 =?us-ascii?Q?eQjK6AiDkfd+CqF4RtKNqHNtrmC/cVQbEV0RWmeAfj3BsKSm/SToKZQR1DY5?=
 =?us-ascii?Q?WFOCBQ+nof5d1g+LfWoZVHKgRshCYqZeL9cScKWlmPWrHKOQCc1B8R2LuUhT?=
 =?us-ascii?Q?F4YbZYE9skYshRvTvy2mrB8wkiRGXM/ANZfwdahKgN/8F8L9cMV9TQW6bkKh?=
 =?us-ascii?Q?/xe9KYbtVGvghRI0kG8tJC6o5qtbGfI4O0VFbfP4DY80jGaTw2qgHzCgt/ja?=
 =?us-ascii?Q?/cstfcdehAl97EYiUsYgWwMx+qO3zpCyITYSzcsEEmZa7DcYBtwx1JgamuM4?=
 =?us-ascii?Q?auhV04P+9+j1d1RZkk6uyMdwLG42FPlglhmql1jd3ejJGPlhC0MaasazmgQh?=
 =?us-ascii?Q?iCoe34q1Fu/oohXyGQtdOqSTwHqZbpJ4XsQWiB0b0T3qYvZE6GEGnW8+aak2?=
 =?us-ascii?Q?5lckr/af29ccj2aTs0tGSWFP5tkdDJktkeKy5ZcPQF1sADPCtPZv/PCwkJYA?=
 =?us-ascii?Q?JgkPTTHQ/C6ZwWC58CK2AOQMohj8KABbtu/CySa6fACdc1M2gkXNLd/nTTkH?=
 =?us-ascii?Q?DjnV9DS0ewO0gBKzNyav3v612eSaJyMvBS6Lr1C745Z/7Pcgq1WUcNZWBdlp?=
 =?us-ascii?Q?3TzHRzhmhGq1xs45UtvcHY5Nj6ZaAjdfeUf3nWpPfmid3i3QH1x5hXYL9exT?=
 =?us-ascii?Q?Q0mjnyMmcbmUPu+lxCDv902gL592Np8R4yqnhpRtxbLjbLDxr0O/qxiFoQqq?=
 =?us-ascii?Q?dbyO0A/jmbnE8agd/R3r/azJYAULq/xpm0h3ro+i/v/8+HwznYTKrcqU9w5I?=
 =?us-ascii?Q?KKsL3i2GhX8OvaJc3aNgKZNRu5EdsTzeNq4q9pyUvhAUi/sp6tywTZx84gY4?=
 =?us-ascii?Q?mZoikG1DHhW5UPAszOLZ9CI8AZz9U4mR2Mmc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:56:33.7365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9d310e-866c-400c-9c2b-08dda848232f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750

Change lapic regs base address from "char *" to "void *" in KVM
lapic's set/reg helper functions. Pointer arithmetic for "void *"
and "char *" operate identically. With "void *" there is less
of a chance of doing the wrong thing, e.g. neglecting to cast and
reading a byte instead of the desired apic reg size.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 6 +++---
 arch/x86/kvm/lapic.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 096db088d6b7..27b246ee3ada 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -79,7 +79,7 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
+static inline void __kvm_lapic_set_reg(void *regs, int reg_off, u32 val)
 {
 	*((u32 *) (regs + reg_off)) = val;
 }
@@ -89,7 +89,7 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	__kvm_lapic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
+static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	return *((u64 *) (regs + reg));
@@ -100,7 +100,7 @@ static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 	return __kvm_lapic_get_reg64(apic->regs, reg);
 }
 
-static __always_inline void __kvm_lapic_set_reg64(char *regs, int reg, u64 val)
+static __always_inline void __kvm_lapic_set_reg64(void *regs, int reg, u64 val)
 {
 	BUILD_BUG_ON(reg != APIC_ICR);
 	*((u64 *) (regs + reg)) = val;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index eb9bda52948c..7ce89bf0b974 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -165,7 +165,7 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
+static inline u32 __kvm_lapic_get_reg(void *regs, int reg_off)
 {
 	return *((u32 *) (regs + reg_off));
 }
-- 
2.34.1


