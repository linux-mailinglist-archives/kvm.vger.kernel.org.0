Return-Path: <kvm+bounces-39682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 472E9A494C4
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:23:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 234DD3B4F3D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2376C255E54;
	Fri, 28 Feb 2025 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zr1J+j1R"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1B6276D3B;
	Fri, 28 Feb 2025 09:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734579; cv=fail; b=s6HDXv6OHRbrqFvLPlChiiEPi9FglQV6kV6DhFIaJTaEYsZhq3DinngreK58k6G3eYYSKYURWLfoyn6B21G70FjRqswZORLUbGVRcaDc7LHEwXLmJrGTr6Qy3CQ8XkJfOk0XpLw1FRC8a2bT+rQ0gAuHNHtg/tt+FrPimWb2ZmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734579; c=relaxed/simple;
	bh=y2yK87GmOElZx7YoojZ0MU/vatdks/OAxnvGNc+M38Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6UVD/sw4P6vcWoDk7icmKFRWjO/lZ3OPLzE+NmuP2vPqjh5p5/0fpxHeIs8zMn/CBefdAl9k2pDOrk2zaF8MM3yjFRC1y9PEq+dmlIoaBqVdFmUwyiaqtdFrNuNPpfjvwyXk9TvqXp9Er+ib55D0nQ0WPGZGkxsVWR2AXt3qrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zr1J+j1R; arc=fail smtp.client-ip=40.107.92.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JneHbrRlN9XqtLVIRw+ERGl2KLTyT9UDntO/dhCU96IWbDLDnJBOw80kwPFIGTCUUPIxFvRroapBwGDosp3ifeQY7LAn2bB4jl0PtjOZjJ/SesKCGs0YVBQElCrtB1RnoVqcaClRwsI/M2JdoTInFFcK2lpVPO9o8/jnBzGgnQTcfjc3nUrc7CZmGAYkyu9sXyrQC+vU3Tacjo8dIGbM+yJYKOdrrGzk4WXWr0HldWkNkzoLIK/C7B7AOoWU8CApd8nBu9H52ETBRFE9sUxxYNI0FOmeLZdsCD2Ekp4QMNsIBSmhviz99sTNpT48ux5jJs3SAgS/o3MyOSyz4cybVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1WMtFLwBm619ady0UKmZ95YE9M2q0JzD4sS7SkelFo=;
 b=PtZ0lHenAVG01aPhSfSh6tlk+qQwhBWozX8LWSK6kbOzP7S/v4X+6Ad1Q5fmDXDkADY+uNSMIZXDz3lyPMj8+DYZc+t7RxG/B3s+dC3CcongYdO0XYYou1ci2SdW2p8Z4Ty+ijbunj8cBHBR6JM4GmZ3cAlePtChsrbfpbTPt2oUcOY0B1ZIq5Hn1Ovw5PW3fbad7vcL5GXSr92gPTgwzSRGzcJNzOWG6mLPFib0pi0+PuH2TYHLx1ej0XMbQ8JEclCgSAM2pCLiAUpyCXJS9fE0iIzRm5MPRrTkO1oi9T/hk0llkOsrYFTcqHldTDHYtrr2Qf7c+/fbje6iAC5HvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1WMtFLwBm619ady0UKmZ95YE9M2q0JzD4sS7SkelFo=;
 b=zr1J+j1RVFGfcs07r62iXx5edkQpn75Db5X2X6lu2aNxB8QHYWTDps1Qkr8HCv8qkmkTQr585S4FDKFSeFlopCryJanyMpxv5fguTK4iixSyT7ipv05eLD0b31FxJYMeO5CrKfjeysJofQwc4UnJCLggSj5NsT49CfWXCgK0PWo=
Received: from SJ0P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::34)
 by PH8PR12MB7229.namprd12.prod.outlook.com (2603:10b6:510:227::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:22:52 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::be) by SJ0P220CA0003.outlook.office365.com
 (2603:10b6:a03:41b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.20 via Frontend Transport; Fri,
 28 Feb 2025 09:22:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:22:52 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:20:16 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 16/19] KVM: x86: Secure AVIC: Add IOAPIC EOI support for level interrupts
Date: Fri, 28 Feb 2025 14:21:12 +0530
Message-ID: <20250228085115.105648-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|PH8PR12MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d84d417-7d45-400d-f35e-08dd57d97a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?flP6HIPp3RaVgGOSa1uDTM+8ZWkk89KE/a2p3UUiSEJLeQSJTrCJ7X009O6V?=
 =?us-ascii?Q?5vOePNW+SOY0gpZiP86i196qhz96lk6RPGa/0JfjpO2sD0nB8XhA7ylubmgM?=
 =?us-ascii?Q?fzTtzdL+tDqvtV4g61qC+ZfzhSAtFEQA+Xb6uxePUo0BTPyBBwkhbSPprLDD?=
 =?us-ascii?Q?wUVrIEVne9U3ZxtQJn3rrymTbjEW+db3aUWv89jNSvfryckOacCky3z/zXXu?=
 =?us-ascii?Q?ICb1idjAHHXrLgrU1obXxqj0y7TgBAYJ5aTW3Uwe/8Y+o3XTMu2RUzzk0ckX?=
 =?us-ascii?Q?83NCRxlz+pYwk1I5rxBQvkWSoN0JGQ6pERCYMS+1ofF1TB+wnx+Ar5G3LpNe?=
 =?us-ascii?Q?xzjVya/+0wsZY6vrbVv7ya2Hir1Xgd9HMW46gZYJmlq2xSttrDy6OlNwFBOD?=
 =?us-ascii?Q?mEabGzShPvalEGHJNfrSo4PmCOF5bsd4pHaNUVZg0+lp3m97bB9N/c0SbKOm?=
 =?us-ascii?Q?VfCwnjxhBMRVEHPmm2FFTRN0WM7bKAn0931tE5UB7JsGN7q7ShwyE72v3fNa?=
 =?us-ascii?Q?zn1sqcQ1ddikO8oSEmdR3SF6mXrNS2oQEjj4ewvPLfNy9TQUoWPlLe3fmSyk?=
 =?us-ascii?Q?cnVExBpahqe6qka7cbKDauyTSuFIngnzZ6Jn5hGOAxAIlWoMUF+R3Emli8CA?=
 =?us-ascii?Q?b+/t5OvWH27xpWIKDvE6yEaxhhaxrkR4LIPK55P6RGp8+MfmSXCmtJZ+VoHn?=
 =?us-ascii?Q?t0I3DvFGAg9v9YkgTV+wbgB+C38kApdlzG6o9TlKhLeazn+lu87PQSMlfnGe?=
 =?us-ascii?Q?cm6m9RdZPU0ACU6ouNjmoWp+kVrqRI5DGEP+++dfwu996U04Yjh0Nb563Zq1?=
 =?us-ascii?Q?aXtPUrLRSkE3waOx2jYDLomov1VYeiYEMuF5R0ZB8jh+s2EN/LeGT9SzcYhd?=
 =?us-ascii?Q?Yp7eiCqMhbWRUbxFwdTP0MsuOZj4E16+1dHzHjK9qfQmQUYc2vcN40OaOJOu?=
 =?us-ascii?Q?tyP6qIaG3bYTuNZblnn60t49h97TFYRv2FoSzdf/Qmj03r/E5o6R57yzgq2n?=
 =?us-ascii?Q?GdF1fIDs3BbfskuTJcwbVYwXS5vIyTqhRW2C66Ieh23QiG6Yi78PqllJkI3I?=
 =?us-ascii?Q?j5lc/4p3XCc7l6TGwArk9sE8/dTgkmTYgmpx0co0EbzMRPRbXCu6buCQtfFx?=
 =?us-ascii?Q?Pok3yoi6FGLXf8Eq1QFExmbk50TuPXIObE2baQagMePkGhj+2b4PB4s61pXe?=
 =?us-ascii?Q?j6ozGgj7V1g19gT9QF5kC8wt8bwusY0NmTNmVNtr7E6cuqP7yfta13+XKhf3?=
 =?us-ascii?Q?aCPspxz4UsYQY2z+hKFcWrpDZAHYTEEfwRPK2kbQ41sNjgm7/2IBlKVz66pg?=
 =?us-ascii?Q?EEj5YzvMjWs/JkSosDFIviaCasrJzsnnf6wgI4hGYGpPxLWWy9OwEFXS43wR?=
 =?us-ascii?Q?BvO39kCLTQoWa8L6qXMTSMztjy9aYyrL3FunZIs1lCBonqi5NtpRnJ/cua/0?=
 =?us-ascii?Q?LV2QRe+3qs4/XIlbI4wUXxi7G/vrtC/giEu/QodY8unSFA8H/+YTF/MMvbvN?=
 =?us-ascii?Q?akRkIWO7fyEkfRE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:22:52.4438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d84d417-7d45-400d-f35e-08dd57d97a32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7229

Secure AVIC accelerates EOI writes for edge-triggered interrupts.
For level-triggered interrupts, EOI msr write is forwarded to
hypervisor. Handle APIC_EOI msr write VMGEXIT and propagate EOI
writes to IOAPIC. Current implementation reuses unused host APIC_ISR
regs space to maintain information about active level-triggered
interrupts. As host APIC_TMR state is updated from IOAPIC redirect
entry, host APIC_TMR is used to identify level-triggered IOAPIC
interrupts.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/lapic.h   |  5 +++++
 arch/x86/kvm/svm/sev.c | 26 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a1367689d53c..4e41c7ea4f66 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -159,6 +159,11 @@ static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
+static inline int kvm_lapic_test_vector(int vec, void *bitmap)
+{
+	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+}
+
 static inline void kvm_lapic_set_vector(int vec, void *bitmap)
 {
 	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 77c1ecebf677..a7e916891226 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4491,9 +4491,27 @@ static void savic_handle_icr_write(struct kvm_vcpu *kvm_vcpu, u64 icr)
 	}
 }
 
+static int find_highest_isr(struct kvm_lapic *apic)
+{
+	int vec_per_reg = 32;
+	int max_vec = 256;
+	u32 *reg;
+	int vec;
+
+	for (vec = max_vec - 32; vec >= 0; vec -= vec_per_reg) {
+		reg = apic->regs + APIC_ISR + REG_POS(vec);
+		if (*reg)
+			return __fls(*reg) + vec;
+	}
+
+	return -1;
+}
+
 static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 {
+	struct kvm_lapic *apic;
 	u32 msr, reg;
+	int vec;
 
 	msr = kvm_rcx_read(vcpu);
 	reg = (msr - APIC_BASE_MSR) << 4;
@@ -4512,6 +4530,12 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 			return true;
 		}
 		break;
+	case APIC_EOI:
+		apic = vcpu->arch.apic;
+		vec = find_highest_isr(apic);
+		kvm_lapic_clear_vector(vec, apic->regs + APIC_ISR);
+		kvm_apic_set_eoi_accelerated(vcpu, vec);
+		return true;
 	default:
 		break;
 	}
@@ -5294,6 +5318,8 @@ void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
 			vec = (i << 5) + vec_pos;
 			kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
 			val = val & ~BIT(vec_pos);
+			if (kvm_lapic_test_vector(vec, apic->regs + APIC_TMR))
+				kvm_lapic_set_vector(vec, apic->regs + APIC_ISR);
 		} while (val);
 	}
 
-- 
2.34.1


