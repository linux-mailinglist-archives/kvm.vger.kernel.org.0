Return-Path: <kvm+bounces-58463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 709DAB944A6
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 279223AE08B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2328230DEDA;
	Tue, 23 Sep 2025 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="neHdPyhE"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA71274671;
	Tue, 23 Sep 2025 05:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604045; cv=fail; b=PUZ27ffOlbPMmfv09OgGwF/lmNeAv8pn5QmmUYKTs7LGN3mOOAg9wtRjGJcGCVuWrE25wxoPcyLLmjVXv6eb37GVW7LCB+JWnDPPlKX3AzywGRnX3vX1hcsTUOlci7fpTM1RjkpEv/ZSQMKIASRkOw7+kbkJ9CBTLHTINaWvR1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604045; c=relaxed/simple;
	bh=7IKsL1KobhI9qkuQjiA428S6QL2vg20cCr2yh71LFQI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZD/Td1Hd8Km2Sam/vQAzzCXHf1gkYdQ8tS6IHW7G9KrJcjP5QnBfaXM0PzKzKFUX7Z4iiG9ZtPTCmDAUnPttyZIVVAu/OTFzpcoxkRHSGkifQ1nPCT9MFlhAX1LIL5FYFSuopzwbS60uN9mVEISM7NeG7q2GgRZIm3+qv1GUtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=neHdPyhE; arc=fail smtp.client-ip=40.93.194.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVlfrUpAISMVXHvomZKbzatPW8USJOt6470hWnY2jcxjvSFa1h2F+MLV+nfb/HO5xOAu2I4GzVmRUMtCi89WyBmTfkQWTX2AXes9FgLcE8Y6LG10MP6H8lu5EuDCW7MiBvoHDLUdbKFpGHJCXgJda0fppH/MtbZKaEupxed4n69FLfmKMhTd4Mx0gI42uUjpbru+i4QhkOwxyZsb0wfSz3ZJnygJI7170nceFuWxkUmersEF6j9InLhWRgi4I2WdoT6E5XwvxdFLrsZNewFxWA3wWgyzMjYcl7NgRAGN0vwaRNlrt0+r6FlS815v44SBtFVShUQnmGhgyWtOIAK3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RW7tibedqbZLSbfUOG2RXN+VRNgmwCoNIHbQZ64xeYI=;
 b=KT7SrkqhXRs4xheaczEP04dr4Br7AC2kdS0Fz2CwmRV35N17lJpLLy2BFcHG9/TxPRg2ppqzBMStZ5RljPfCN12fwSy4dAUSeAsPiIXFZ8MwzWRMp3YZnjGwKB9H9PzNiLh+TDZYcxcJHDYeqkbymywOnV+L/dGq0RiD7KrPEnDYMkaNtTHiPF2XF3pXwOywmxy2JyjjsVGkxPGJ6bpTI5PHDZ3CMdTvE82UJilv8af3dkF2ngN8ZCjZCZLHi+NYpr1WYcKcSt3cY+XuMbIQH0wiPXBbnkeUcY2rvxNoPNZGRTaXQGIeZxbqnxdF4HPolyjuwDnqUGdL694OapRxPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW7tibedqbZLSbfUOG2RXN+VRNgmwCoNIHbQZ64xeYI=;
 b=neHdPyhEKVNx/WlWERHpYpkw4Glh+x39xByENH9K76H9CnSBXNVQ2E7aW9EYNjGqB2zVHzuX9Sz45UGhvym5F/7llHL6UYN81Z1aOztmqzl2ibGFJN31Ro7T8H5wyBRGvaZBRzwDhqlGU5x14QxghtmFrjmRYtC6DnT5nfsfT9E=
Received: from BY3PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:254::12)
 by IA0PPFDC28CEE69.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Tue, 23 Sep
 2025 05:07:11 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a03:254:cafe::4e) by BY3PR05CA0007.outlook.office365.com
 (2603:10b6:a03:254::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:07:10 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:07:06 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure AVIC guests
Date: Tue, 23 Sep 2025 10:33:13 +0530
Message-ID: <20250923050317.205482-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|IA0PPFDC28CEE69:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cf72620-ff5a-48a2-b721-08ddfa5f0d6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h77f3iSJgv8hgGVxhRm5ct1+vE9YnI78Rm3LS1iVwu4pszcF2K/l1NieAlqo?=
 =?us-ascii?Q?3FVuAjictZkvW8s621oRWoKiSw9Ppo3z9x/4huezm0kVWwKtYV0HbpDABOuC?=
 =?us-ascii?Q?l5CkgabBnCyuYjjAekFX9zJyWZq/cw4uh8OjHixlPUMOeE7nRY7np58QuUbP?=
 =?us-ascii?Q?XS9IBvR+t3xvLwQizuNUeWMPCskZLYhxpMjJ+doMHsfdp/WUCOqS61edToNz?=
 =?us-ascii?Q?2kOjNRoIsx8fumhvoEpTurZdPkswaco1Co9eGpvyjItLmPMxlVj8YZCJi/Aj?=
 =?us-ascii?Q?AZ87A7c4kBhMrbBislRsX09oW59VjcCNlifwpgreyMChOZEuWiyys9meybnG?=
 =?us-ascii?Q?2aTZB9wi/aPYS/jfR3jUZAPAPQ/xRe3AlOLGAaa/eogH+wk8s1hILorQ9SZX?=
 =?us-ascii?Q?IPLHmvX2F+37rh+K3/RdMBcrLyxbr4v71LSEUHRgwyHWxfTpqxjrYAK4wd+i?=
 =?us-ascii?Q?t2hlTDawiPc5/WBxDDMW1ldCHY9ziAFnpZPou0LJubvfNOduOhY85YYAxs6b?=
 =?us-ascii?Q?mLqQtw/J/Zx8nQSDn20ptTCpQ7EqZswQcmQ89+f6hlMJ2N0PlAR+Kpq/BJZC?=
 =?us-ascii?Q?Bv+CTnD7pxLWL0ifxjBb0xQ2KkcdKjAepiCm7edSZ66o/Dnb8kIosDkzADYH?=
 =?us-ascii?Q?7/RsmcSSqEcBaN8YoNgmknCQfr7knRlZs7OHSUDWEJ95t592MH31P1Kpp6Zn?=
 =?us-ascii?Q?+3Er+rX/XVL6zqx4NPsBk0xXV2+QrAYk8mcm/mMXsDFEcVHbOVvdxhDbOX6v?=
 =?us-ascii?Q?1S7//kGqvV09mtwsej13/aU8dUGvCV5Qj0LxSOVJoZ+gsVdczntm3Objytlw?=
 =?us-ascii?Q?ejhWFhuAnnfF6qIa58Go7YnkJwKHT2pLkogPJA0UpHAoIwAhaYOWZuGeF+2b?=
 =?us-ascii?Q?FIeCYCCPVHjl8Zie5WIU7FiAga6PaZGyAKr2gplQ3MZid6S/Y62BcQeAywyw?=
 =?us-ascii?Q?qOqlmRrcNW9P950dmevtp4cYD3MadvT9HmlGS2XGWSUxQscd4sogJaAix+IV?=
 =?us-ascii?Q?rEYWlbvahdyDPkUDKq2wdMMd0BO8owPIXpyUAaOHLUIdd+83oBpsoUdRbH0m?=
 =?us-ascii?Q?MsjTc131XJupzRRmDqzvKXPtHRD2VWP9P9vS1gQfClG8T6KD13VKUa1XLfpa?=
 =?us-ascii?Q?hRA6lnPSNopakigEUcyKg+XsdzMaJnzwBKQvslDmUMNmJuewD7IrxxbrRF32?=
 =?us-ascii?Q?ztRr7+dSnkEx8wUKMEVc2bv6cHh15eLyMHJRsQ7h5RLer84cR/bG8U+UVcPZ?=
 =?us-ascii?Q?XovS0Bp8mBDn0VyuQU3cw4cyHWmRrSKW+kCWR2zh4qPdvOBzXtSf+KkCrSi7?=
 =?us-ascii?Q?IV9KdSKYolukO+KJJF+QuMwt3So9ejY8fXFT5QGhjnZIpUF8yOlhT+e3xp8B?=
 =?us-ascii?Q?hkEw+ZEb2XCCI24ISL0rjMYFgQ7zGFA8yvwPVgTlYruNNAYy3YRbqb8jdQ3x?=
 =?us-ascii?Q?8nuVAVDf7CBlsRKlu8Kff1mhmHyNxHBv0qXLGbgHcYhnzqT+nOuZp89A+M9L?=
 =?us-ascii?Q?iFU815Z3xT94ur3I77XZLjxGIJuOIcr078gF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:07:10.9160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf72620-ff5a-48a2-b721-08ddfa5f0d6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFDC28CEE69

While Secure AVIC hardware accelerates End-of-Interrupt (EOI) processing
for edge-triggered interrupts, it requires hypervisor assistance for
level-triggered interrupts originating from the IOAPIC. For these
interrupts, a guest write to the EOI MSR triggers a VM-Exit.

The primary challenge in handling this exit is that the guest's real
In-Service Register (ISR) is not visible to KVM. When KVM receives an EOI,
it has no direct way of knowing which interrupt vector is being
acknowledged.

To solve this, use KVM's software vAPIC state as a shadow tracking
mechanism for active, level-triggered interrupts.

The implementation follows this flow:

1.  On interrupt injection (sev_savic_set_requested_irr), check KVM's
    software vAPIC Trigger Mode Register (TMR) to identify if the
    interrupt is level-triggered.

2.  If it is, set the corresponding vector in KVM's software shadow ISR.
    This marks the interrupt as "in-service" from KVM's perspective.

3.  When the guest later issues an EOI, the APIC_EOI MSR write exit
    handler finds the highest vector set in this shadow ISR.

4.  The handler then clears the vector from the shadow ISR and calls
    kvm_apic_set_eoi_accelerated() to propagate the EOI to the virtual
    IOAPIC, allowing it to de-assert the interrupt line.

This enables correct EOI handling for level-triggered interrupts in
Secure AVIC guests, despite the hardware-enforced opacity of the guest's
APIC state.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e9cc50f2705..5be2956fb812 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4474,7 +4474,9 @@ static void savic_handle_icr_write(struct kvm_vcpu *kvm_vcpu, u64 icr)
 
 static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 {
+	struct kvm_lapic *apic;
 	u32 msr, reg;
+	int vec;
 
 	msr = kvm_rcx_read(vcpu);
 	reg = (msr - APIC_BASE_MSR) << 4;
@@ -4492,6 +4494,12 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 			return true;
 		}
 		break;
+	case APIC_EOI:
+		apic = vcpu->arch.apic;
+		vec = apic_find_highest_vector(apic->regs + APIC_ISR);
+		apic_clear_vector(vec, apic->regs + APIC_ISR);
+		kvm_apic_set_eoi_accelerated(vcpu, vec);
+		return true;
 	default:
 		break;
 	}
@@ -5379,6 +5387,8 @@ void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
 			vec = vec_start + vec_pos;
 			apic_clear_vector(vec, apic->regs + APIC_IRR);
 			val = val & ~BIT(vec_pos);
+			if (apic_test_vector(vec, apic->regs + APIC_TMR))
+				apic_set_vector(vec, apic->regs + APIC_ISR);
 		} while (val);
 	}
 
-- 
2.34.1


