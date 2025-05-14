Return-Path: <kvm+bounces-46432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 144F1AB63FB
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9475A164A8C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84874207A32;
	Wed, 14 May 2025 07:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QYp9SUMm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBCB1FCFFC;
	Wed, 14 May 2025 07:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207198; cv=fail; b=o0XIMz1HCXs0eCW9ncXLzdycPyqxfuN0ykmbVmzRBQPxCOgs2DtxXJjZPoSd2WVoBFV5uhMRKtR80liMklS6hYr7Z0BcWCJYRqt1/1CNqe9uVxbdUwVI+eWvAme5Q74p61CxnawuMQ6rrXMH/Updnlw1ZMd6IHe2f64c6r/smSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207198; c=relaxed/simple;
	bh=WYsNTp6KzZJJnVAfaMJzyAUZbC+GVZWLHTDPXuGv2H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkgCr2s04peaM4RemL/82HJPixfIVO5E6juZOnzlSjM95bkFp6CW01pDNr1zxrcfHTLN7gUwuxUov/qIXEN6vpjkEdUXGhcYUMTSsmxwl0mq7/M9FjQtRKMDU9pQcC8E5QEoFgQ+brwd08g+1+xHyRHXb9reUJ/Dw264AmcM9IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QYp9SUMm; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/BAuOlgNasdQ9IzmM5E+/QSchhqHA6DP4HWZxCycO9IFajDZoxU6He65BljTcMYxyIhgfm1vJ7z4yTXNKMhizFvAESiHERMZnBhOTPtDBA9K/2FlA69WhGWL7wtByPjjN4IVKVIZmsmDLWYeF67AghHCzvv98Un5XEaDctkHbzs3bTi2/lZ+FHpUl+HO5M57uIHVHXRbXKS4OxOTIINY9Yq39yuIyX5FbQaMChU9t6Z1jWFm2WXUpj0y11yk36G8W35HwujDgQ+eQ13Qw0zOfZLhjj1P8/X8SdsFCt8ixGKqlPddlTZrMA7e6NUTg5EvEL3lpaZFRzEiNU0YyHyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFZYeWWDFBpE+73aqGPyWuchOwOtVRAFFqoZ44v3VXU=;
 b=cmUpSgA+qM669Ot0iXKsPQs3j/qsMVOLy0AurWBCW0ftjwua39ERhxbv5HLhq3EeUpotayJNyrKKw8HtEOvNnSYmNbE/z4Kbjde5qmBFsuAJK2jwHUFKZ9rFZH2GZmnoWJqrWGmUyxzv2UdoUXZRmPZ1vqYVTczHHwDHytur+QxiFtZ0qyPqNMso2OHn/ShNLM5RHuX3NrggKb/Poh6/rX1/xbCtnfDZ+5JJQFP2Ifhnp6K8U4BFWZI+t5eOQwcZbheO8UUPeF1dA6DNTvsVJMoLjr8P5hrg8oR2RjK64FUyk7mHuYz/ZYQHNmydBnAIn4mhHuTQFfn2u3djhOP7zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFZYeWWDFBpE+73aqGPyWuchOwOtVRAFFqoZ44v3VXU=;
 b=QYp9SUMmWCxxI7bzKkJvueNNbr37PWjFfydma6diLAAUyfOwHHub+I+aFplwahbx8lrQFiSQ0DVb/etTlzHWf6oF9cb196bnbNrzkhlYI8EI9NpGBVkBjKor73LCkN56Rvww91JOFocTS/JEhyUVjAYf2jf4Dc+ny3PoSQnSxxw=
Received: from SN4PR0501CA0004.namprd05.prod.outlook.com
 (2603:10b6:803:40::17) by SA1PR12MB8858.namprd12.prod.outlook.com
 (2603:10b6:806:385::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 14 May
 2025 07:19:52 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:803:40:cafe::ff) by SN4PR0501CA0004.outlook.office365.com
 (2603:10b6:803:40::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Wed,
 14 May 2025 07:19:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:19:52 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:19:43 -0500
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
Subject: [RFC PATCH v6 04/32] KVM: x86: Move lapic get/set_reg64() helpers to common code
Date: Wed, 14 May 2025 12:47:35 +0530
Message-ID: <20250514071803.209166-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|SA1PR12MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: 242da1c1-135b-4415-ce6f-08dd92b7b80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w/6yXpYobZW+lMK20VbRQoQastWzQ8QSLbXsUUPPjOpPxIfIK046eCrjk2gd?=
 =?us-ascii?Q?w/QTUgdEJw+Ng+/2tL+0mX7DpEUWs7R+2UfHBqLcydcjIebkg9NXuHvl91zK?=
 =?us-ascii?Q?zCNy24CSW0bwa7pdvgnGhvHAoITj361U2n5xMmceiay/mwKnEqS0KI5QmiWw?=
 =?us-ascii?Q?bhhsM4qy6Tv2gL+1CZuQC+wxGFLhjM7YvGHiL0mFtGf+9f6XIVi7H7VJgqpy?=
 =?us-ascii?Q?J0ID9PVpOCEib3EJI2rZTjPwsneo8HzGhgMXLFWLC7dtoZ+5zXLQZMH+Ecct?=
 =?us-ascii?Q?IovrkS3OrhnrmF8glq9QnJeLAsvDIaqBEgHO6CJ1E3aAncJgpTU3kvi+VvBN?=
 =?us-ascii?Q?/nMkzsl3CX2owW7e6IlAXkWlEm3mC3tPTCC3PngHw32PgjQ1lJSsWMJYWfuP?=
 =?us-ascii?Q?AGykSlUYpWkZp1gAMQgeaBVDIHk0Kv9aNOCHJA2POky5pyYTghEVuQjxp28m?=
 =?us-ascii?Q?lZJyOv0SIdpqdEg2yOVjOFmR5gX0NUD9yZD/m8E9RrVznxbpw8NqmMb897A4?=
 =?us-ascii?Q?19/PBaz4TDDh7MTQroJovKg5iNzXOYy3ufZftdKMX4qJXba+TMHJX1Awhu2j?=
 =?us-ascii?Q?jzF8eUXtv45pHp6VWdXZnlzEIrnVvvbco85KXzl1xSqqPARQ6YG5PuJiE3vo?=
 =?us-ascii?Q?q39OYHlYiCb+Rh3mATZXDL8LkJd/Jm88bwgDSfVxUMsq2U0jrxicTJ2BA1eM?=
 =?us-ascii?Q?w46rxXgaKT0pSzCilwQCMVaclIBxqOp4Z5PR8T41Cky1gi8gnaRnI8hf/b18?=
 =?us-ascii?Q?bIr9n58UFanNcFxzWA2BlPmakb3QIqAIj7xmAvRAorvZ5Pdz7urhn5otB5HP?=
 =?us-ascii?Q?Gbenzfg7LzjU/sY6NlG7EfcC/v97D+POxPhsRRen4ptQLAWK8nv1Ec8ZL5hX?=
 =?us-ascii?Q?OgwnYJgxkKRpdb8UTXcQ9YwkSi8S+86fEw2PpLHxZnVA2dgixezIIjBpx7er?=
 =?us-ascii?Q?b8+NLOmwTlLKkmoGf86CAwFRDd18EzqCi+4L5eGcU3g/WzRhgUdJbpol7OCw?=
 =?us-ascii?Q?5WHGSov5z9pPAmMaXH8T5MpAhCMxfKSxCSMBlRXg98cXiqYVQo1p1+2ALkEU?=
 =?us-ascii?Q?Atduju04Y63Z/6rSRgUKm7CEbNDP/oYD7vWYA43EVOD4Av1hlEHfbiu0tl20?=
 =?us-ascii?Q?DJ0vp+vN/ocRoV6moaiR5b2n2L+lrGxYCkRHHBqyj0SVoQLzGxSjAu8Fv+PN?=
 =?us-ascii?Q?2aeR07C3D3N7q1gDZk8ar0B2B82jTNw5DWQ+B3JMe77nlhzFjX8Nj+YojA9A?=
 =?us-ascii?Q?YIXDnpkbd/cszXPsDgI7YCqAOuf2/RMHgT6soIBdMxvmsqOJiN4u04qi4xLt?=
 =?us-ascii?Q?en53GqIlJehFWNmAvI0oRXBND71rDQ2o4AMs4hZhvkmc2nhQU1QThSn98pAs?=
 =?us-ascii?Q?oJjTqyVp3DAUKQoDACKFx9TkZa4pDCU38F8K4MPUAUD3irnerBbe6+I6oj0j?=
 =?us-ascii?Q?KentMsASt9IogVaT5XDHNu7OnLUib1L/P3Stq0j9vWSQQdQYRB9aLf1xGSfV?=
 =?us-ascii?Q?ADgt/3GZCmmlisGTuPoKyT/h0DSiamnq+83V?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:19:52.0129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 242da1c1-135b-4415-ce6f-08dd92b7b80a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8858

Move the __kvm_lapic_get_reg64() and __kvm_lapic_set_reg64() helper
functions to apic.h in order to reuse them in the Secure AVIC guest
APIC driver in later patches to read/write APIC_ICR from/to the
APIC backing page.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 12 ++++++++++++
 arch/x86/kvm/lapic.c        | 20 ++++----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4851fb9e23a6..5b4926b405aa 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,6 +535,18 @@ static inline void apic_set_reg(char *regs, int reg_off, u32 val)
 	*((u32 *) (regs + reg_off)) = val;
 }
 
+static __always_inline u64 apic_get_reg64(char *regs, int reg)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	return *((u64 *) (regs + reg));
+}
+
+static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	*((u64 *) (regs + reg)) = val;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b9f9ccedafe3..457cbe3fa402 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -82,27 +82,15 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	apic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	return *((u64 *) (regs + reg));
-}
-
 static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 {
-	return __kvm_lapic_get_reg64(apic->regs, reg);
-}
-
-static __always_inline void __kvm_lapic_set_reg64(char *regs, int reg, u64 val)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	*((u64 *) (regs + reg)) = val;
+	return apic_get_reg64(apic->regs, reg);
 }
 
 static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 						int reg, u64 val)
 {
-	__kvm_lapic_set_reg64(apic->regs, reg, val);
+	apic_set_reg64(apic->regs, reg, val);
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
@@ -3041,9 +3029,9 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			if (set) {
 				icr = apic_get_reg(s->regs, APIC_ICR) |
 				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
-				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
+				apic_set_reg64(s->regs, APIC_ICR, icr);
 			} else {
-				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
+				icr = apic_get_reg64(s->regs, APIC_ICR);
 				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 			}
 		}
-- 
2.34.1


