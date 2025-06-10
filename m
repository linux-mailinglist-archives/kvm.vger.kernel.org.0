Return-Path: <kvm+bounces-48823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59479AD4158
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1362817356A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76D624728D;
	Tue, 10 Jun 2025 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UxVC2oFh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4B24500E;
	Tue, 10 Jun 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578244; cv=fail; b=nE6fbdWMHzsXZ4ajwGOaMPW1h+JqeA+Lay0WsPyTF/sGhpW8dpBAAHrjj+3u3iWFgu8bwETEsakh65jqx/EAtHFrx5nW05eBU9xN05DDCI0oKJGyVql1TCoE4/i3cDjpCk2rgR+Z2pHGrzKvR49LlKEMKyEenqSiJSErlEYT56c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578244; c=relaxed/simple;
	bh=iED+QB3PJAqIvuKWlR/hab6oyvOeRjasq5nyy6/Bwn0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4kFEQ6/XPJ1Im1bmIXXroibcohzMgyxg9nZs144vRUu4870TkFora/MlGLFtC6FnkjYVaVYwJEt+qW43SQwSqITh7vwuDDw1oMpBw5hX8dpji/XVKKD9ezbXdCMYBzghcglvOExSjbr3rNtlpw40+2XvKPvJs8VQrUJxEanvYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UxVC2oFh; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koujEadI7gsKkZiacZohFn8Hg24UX8EyvhxFFPbJcd4f3Ee4qlY+1h1G0W21CUYpcNH5upKSXoaUz4aV+WyQoZydoIhcirhw1XVh+HTWxkzYRCHT12ma2b4lkvOBeOgbAUSBbe8reUvKon8kHFNnMAoheIH5Gj6uhnfUtkPD95v/dLiFdRyQyM/fGXvDrKJZ98SVCG50MDromDnrrcGf4P1m/hxvuDptlqO63tEtEaELc91phXXZyxaONGM3Nd0VNC2KTFNKqzqj8JBxXgQRM7Rv1a7izVgmEMQAVbTRfrT8LVhRUTuaga8MwLbcxKr+Jvgsnz2xZHJGWy0RAAPVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgL2IvzceWYrHBiYUvDgLzH+IbjBWZ/amAjG5cw4AKk=;
 b=gXk4Q9kecKyfCgmeYlIkVbfdxSNBCKmfuQw06Du/f7TjpyaX1f+C6H03IlvlnDVBVMwc+Iv6sSb4wVtQLepbs/Ojw25wiiwAcTahiacNFFzKOlsz6d/Vp97suqukLVNOsA7dKdT2Kgw/bYLG+Rtl88WY8vP96YY21To83UZvMebtf6mxx+HS4nHawg+/fzwkDgNVnRVArNYz9p0b72NzUe7Gwp7huWdhIh48zojgr2CV71hq8mZ72rv11GPlforHVmghGw2azfczKcxKPyKAyaiVgjnTslVbWRLKjBzl3Sb0SQ1IroHTVQGfYdGUvV5Fq8F6ZSbZqm4tz0Qj3fKLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgL2IvzceWYrHBiYUvDgLzH+IbjBWZ/amAjG5cw4AKk=;
 b=UxVC2oFh5/1b+VZ7LPkYxCdtc/ue6oGjl6jI+0a+WimSnNADrYqnhU5sJfzmT5LZP9flDzBYSnnKW4Sw2CMjmiLlRXS1ruKLyDxsztAnNPfeQbjlUqfTN78bpreOMTxrVuScBlimOGw0IqiRKNl9I8OdiGPFD1RsespKlvnuTe4=
Received: from CH2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:610:59::37)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 17:57:16 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::5c) by CH2PR03CA0027.outlook.office365.com
 (2603:10b6:610:59::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Tue,
 10 Jun 2025 17:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:57:16 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:57:08 -0500
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
Subject: [RFC PATCH v7 07/37] KVM: lapic: Rename lapic get/set_reg() helpers
Date: Tue, 10 Jun 2025 23:23:54 +0530
Message-ID: <20250610175424.209796-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|BY5PR12MB4180:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1f9c88-0e26-4377-bead-08dda8483cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?POn6LEgrICVnRXo8oclwuO0USdt6sHGDYTEbajvZna9HMOJ/nBZQ24qF5y7B?=
 =?us-ascii?Q?F766c9q9U05oQ5VVNIbjPfXpzrnwRtMVQFYIwiIpX+EpsIbX4fb/vGjZCieb?=
 =?us-ascii?Q?g8UAsZhPBPktNmiqy8erjE1oZhZRC9uchpTv6KKCgue0K4X/X5ERziWSEH71?=
 =?us-ascii?Q?yN3sHxBUFN0vRvhtuzfvq5oWNO78xkQvCDjkEEnL8711e9fxWqal58vYri6N?=
 =?us-ascii?Q?YPRxdt099WK4Ou3GDCl7v2kWauBMzWoNDrmSTcdy1bqvp/5U37nAtJYAoXKm?=
 =?us-ascii?Q?VuGZOqpr2pk2yT6PWCyJveiJ8wE46zPByzHyu7x3R42ZW1JBSWCZKdwfk/1J?=
 =?us-ascii?Q?I2aara4fFiSX+D0Ya6QU2C/7t3FuofPaPkgwhFkTFNehJ/S+uqmfeXYsCpFn?=
 =?us-ascii?Q?gaY2HOsdWJ5Gl2uQtV2iHQQPYgNnRJ/l6TtmfUsRfYg9a3tg4MjptnRiEW8M?=
 =?us-ascii?Q?kUClMNumJKmuwKOXwGvP6sIFvV+wOV0xrDUX7WXGntl09jUCLYJmhOPJjePN?=
 =?us-ascii?Q?SClvYsa/VJYz/J1m2RgMETrGLtOzecIkSrzJz/yYMLgIzm0Sfym9I4jY1Pqy?=
 =?us-ascii?Q?FnrbfWQ5A8luLzMxY/imuVbTbTa1+60k6NsJnb48yxv0az0WNEr50hGqiDbl?=
 =?us-ascii?Q?1PDReEwaHvtvvTx529wMtPNZOFvB0fT4tz/uf0MOfIBYsCUjYGhBKGvMlSb2?=
 =?us-ascii?Q?2Blfzno20Kk/OtSpiYbntoMW4zqN8mFIPDToxgELFCUub7QZ/vPl2edyDNfO?=
 =?us-ascii?Q?7OpjVssDXFcLcOixfzv0T83I/PoYjuVdBAOdFabvqn1YSeuVoffuOaQtEZR1?=
 =?us-ascii?Q?MtcHTfQsJ09omFGBMPkYxUN5xiYdPNAaXIIxqnvbQCrtTBhavs9il027zVmL?=
 =?us-ascii?Q?Y5uRt9Axo+vDUlmxW2fqB3Q82cDBqlkvKGIh5GVTSFwTH8gNg12kwF1elBab?=
 =?us-ascii?Q?L8BBtDmnnXgppDKLBP9HJjhomKHsndg5Jz45LPnZXM9LgeKCgSs7YfIOt01Y?=
 =?us-ascii?Q?VHp8Z209JeIv9sImiF0wKYFOHQ0iEA20X33WntROn5mzB1YZy/+lKCd0ii0u?=
 =?us-ascii?Q?uCZaU5+RyASA6+tkNXyUh2+yV78FUG0eITq5nSCJRxQ5K3mjGlRngxGK6V1u?=
 =?us-ascii?Q?BJkYljHfKFZQT+6v4iPI/HQgX+/Bk/l+NEEmbD+mFYt/ccSGzv4bi1vQpKWN?=
 =?us-ascii?Q?ZrqwuNx7yVkkGn7dgEK1H5m29pq4v22uKWVOGhPSwweGFn3KhhY5GRG+HIWG?=
 =?us-ascii?Q?IIvpcyS+ETfl6fpS/Bqen2QxAkHKN63tZdhL40uDR1astNCgglI36Uo3wTGa?=
 =?us-ascii?Q?binfR0yOGbpS0ZXeipENwh54+d3udl0mSEOSZEMnYISzMUxj94PQQEUkBg/b?=
 =?us-ascii?Q?NYJ/N3mU7vPhuBUmNf6PS/JPqHp0CiYcxxC3qfQ+D5tvA3bhnBbKaOPvWPPy?=
 =?us-ascii?Q?NGJoFW5P9t525AYTe5J3fTk5tSsg9Kov9XXTmy29B9L+EAAxiUeuAfNRDGz4?=
 =?us-ascii?Q?5s5wrtJDlupn4MfogBrRdGAcX9BD9/2WO9kP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:57:16.6761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1f9c88-0e26-4377-bead-08dda8483cc7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180

In preparation for moving kvm-internal __kvm_lapic_set_reg(),
__kvm_lapic_get_reg() to apic.h for use in Secure AVIC apic driver,
rename them to signify that they are part of apic api.

While at it, fix line wrap in kvm_apic_get_state().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 13 ++++++-------
 arch/x86/kvm/lapic.h |  4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d168b5659a4f..1893a650519d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -79,14 +79,14 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void __kvm_lapic_set_reg(void *regs, int reg_off, u32 val)
+static inline void apic_set_reg(void *regs, int reg_off, u32 val)
 {
 	*((u32 *) (regs + reg_off)) = val;
 }
 
 static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
-	__kvm_lapic_set_reg(apic->regs, reg_off, val);
+	apic_set_reg(apic->regs, reg_off, val);
 }
 
 static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
@@ -3078,12 +3078,12 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		if (!kvm_x86_ops.x2apic_icr_is_split) {
 			if (set) {
-				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
-				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+				icr = apic_get_reg(s->regs, APIC_ICR) |
+				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
 				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
 			} else {
 				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
-				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 			}
 		}
 	}
@@ -3099,8 +3099,7 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	 * Get calculated timer current count for remaining timer period (if
 	 * any) and store it in the returned register set.
 	 */
-	__kvm_lapic_set_reg(s->regs, APIC_TMCCT,
-			    __apic_read(vcpu->arch.apic, APIC_TMCCT));
+	apic_set_reg(s->regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
 
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ce89bf0b974..a49e4c21db35 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -165,14 +165,14 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 __kvm_lapic_get_reg(void *regs, int reg_off)
+static inline u32 apic_get_reg(void *regs, int reg_off)
 {
 	return *((u32 *) (regs + reg_off));
 }
 
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
-	return __kvm_lapic_get_reg(apic->regs, reg_off);
+	return apic_get_reg(apic->regs, reg_off);
 }
 
 DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-- 
2.34.1


