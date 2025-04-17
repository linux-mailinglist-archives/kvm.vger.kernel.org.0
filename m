Return-Path: <kvm+bounces-43555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB19EA917BB
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DE8619E1C12
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C41C227EB1;
	Thu, 17 Apr 2025 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="24w4GdXq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27885225417;
	Thu, 17 Apr 2025 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881870; cv=fail; b=d5+xGk5C+T8Gd/4NlIyjDLPQrtF6q4cEPwzDZ1we/03cGn1fmE071m4dnToHZZNp0nysblVzKYI6zyZrMV9MZDQYfkNRSrEPRZhtX6DajLQLdqjquZfB60AIg17k7fjl60/cyq9p89zrHhIRPb4R7Pi3h9Jt0C/RoY0uD/Q4Faw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881870; c=relaxed/simple;
	bh=Myw/QAjKQPuiokMdpIDBt4zndsc7tVdrADHr3kU9JsA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYhMGBsApAmq9eWtt6kia8IHtOMRMWKL9xJVKGfGDGCcbPykbIIRO7hTL4DnlBc9gZWYwPh1SODAYk5YS7uF2SBKL+HH+yQ93H5iH0smKJK3YUvgmc5np6xijuu9PtZZKNo410KnUp5XOAxp6Volo9y0AorqyigEKAc9K9I7Tcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=24w4GdXq; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdo4elPb4fS63qtH3IzzYyKN5mXshRd8ocvGbZJGs7B8q7jDIUdfYokt+N2YELghTBsYa6+Pz2Dt5Ss7Q/cl7CiSQZ+LH6koNQlspxfTg0JJpHc7XSpY0Ax8pFCKZ5jxNupCqaIipWFKkBe9y5bwC+Bm6Eu2R/Ir+FHVQyanctcy8q7+xKsdKcSLUfaO3QvNDIdZFOd+h5J5jXWR8x1kurR4hXF5IgA10A8ljAc7IM3VAG8zVAD4e5qfuHfYo89Rc8Mt8U7auSC0tx8wJkOQZm17tDbhCtMtIDOlvSrc8dU4c2SsgnDW8gfVVzzG4qPNmQ4bi3tcD3UdTP0E5cZdBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTvHLVF7/46lzEkeOre6qLgQWgQA91vgIG7FWvBifEs=;
 b=uAm/UvXRLsewtDXRZbFRl/pYTPMg+KgbTT7nKRnSLwmj2KDDObm+R5i6PgKsOX7C2alouUluRrPmCqnfebWwVYxKilggbEsx42vkWcnzkf5uo0MU58SRW9+acevDXpqAAT97vNaIk17gNtlV2IkzzGX1OmGIoyaa5h1HEBSMI/8u0EL1YNLU9psOHbZDPILQW73lnnUQNJqgAp2ZL9/Z+TaxYC6WeZMjNhbbzw0ZhbYH8a6EWnYfhJtvg9QjA4PZ2yLEbSfuidMTVjYzsBYpJRLpcZT+clkWqcX+ifksvbTs5+UUXfP8mMPh+LaUsYr7WFIPpnljZwdQqBya8X708Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTvHLVF7/46lzEkeOre6qLgQWgQA91vgIG7FWvBifEs=;
 b=24w4GdXqVK0JwOvdHUlkR53XtyWz0WFEsf81UvfzFnA+wWYay4BHbzHe8JJXktdKh4tNHPpeDqnTY8LpXetR5EENW3gVOiE7VgnwTsHlDWjCZnLkNUGUS33dsueUxPUZY4H7FRmC90vl+0VI2uSWhxPX8S+VuzKCXDYcQ2EGOhM=
Received: from BN9PR03CA0166.namprd03.prod.outlook.com (2603:10b6:408:f4::21)
 by DM4PR12MB5988.namprd12.prod.outlook.com (2603:10b6:8:6b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 09:24:25 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:408:f4:cafe::5c) by BN9PR03CA0166.outlook.office365.com
 (2603:10b6:408:f4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.21 via Frontend Transport; Thu,
 17 Apr 2025 09:24:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:24:24 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:24:14 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 17/18] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Thu, 17 Apr 2025 14:47:07 +0530
Message-ID: <20250417091708.215826-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|DM4PR12MB5988:EE_
X-MS-Office365-Filtering-Correlation-Id: 521bf3f7-6792-4385-8275-08dd7d91a4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lL4Te/Qt/exnz6SV1RUwsOhIqIS3DCClFlgp4HjR6xNTLt/5BbkUzVWwqSa?=
 =?us-ascii?Q?GdNcs4IMAG7q8FHdOHk+ohfr6dFMdQYJMKNgRpjAsrBbQOOdhtq7OAvA81ae?=
 =?us-ascii?Q?ae4d2kNqFt/UGZwilcZDijCazIy1KYpfEAqH34gYgo4q8oflid7vp++lvw/h?=
 =?us-ascii?Q?r+INeSkrHc5y4t0sFs1LuJ8eU4uJYQU4QAmwpW4JZxzhUtaBd11Y0MnmgUvq?=
 =?us-ascii?Q?0dcOSZcTveUxRZmDiPtYK26VoGrvPY0YR5lcfZRUC3pGdNVavcrtekt5fTrG?=
 =?us-ascii?Q?Tm0zasu/5cL2LbiAbLAE2as5imFblERTH/JAj/oTSib5gCT1ZRIKVFobd7of?=
 =?us-ascii?Q?EuiFsPhf38JRpN2Mr13HxNMHPa5WF7rkOdnIChDqkb9b2VX7kPFO6M/n1yMy?=
 =?us-ascii?Q?cG5Lok7t9JA+fkprXEPUub26Kgbyb3fXqewp1CKG8cZBGCSlVoM7y9lRzLNF?=
 =?us-ascii?Q?Vm6tdEGakmExDB+XEJuaBmEl2cYs1jmJvKr1OippxryFCIs3h8sNCvBtkIhQ?=
 =?us-ascii?Q?kko3yEf4re8pz3zoJaeXTRmm1tOpyRTA0cwRiNSZsG3uY0oSSlf26XcXRF3I?=
 =?us-ascii?Q?jhnyOdAPjtWel2rFY7S2LNDuEyKJrSmq1UlboBMjyKyhtfbiCqEB5XSH3McW?=
 =?us-ascii?Q?hWfNWPUDWl4Y8BiTzBV0oyVOMrx0aAP6pEjWGi6Qz3YMG51ydOvOrqm3rCIp?=
 =?us-ascii?Q?HlYkx9o5qRjixBXzN5/9d05Nse/l0r1P1sPDUxA1f8Wdl/g1d032DOTQcGNx?=
 =?us-ascii?Q?ZkleBEP/dAUmBM4nUWj6z3YdQ+/AVyd7mAQLhRciTbWh2JUNOq3fA+vqW5t3?=
 =?us-ascii?Q?jwmmFoRK7DXzvdFHasnE5ZPoxGJCOhN0Pii0q/dL6twF+ASxwV9jGFsP3Nq9?=
 =?us-ascii?Q?yo3qpzOA2DcbMjX6vTTFQmhzmBdmz2QtFDMyiwAw61DKW1pDnca9TgKnE0zS?=
 =?us-ascii?Q?r4l89MBLb4uAjiB9Y4QQkNtpNjCxzv6z72cROdgxhBE+IMWP9PueFXBdiGwN?=
 =?us-ascii?Q?Z8816hgfiUAr0FQh1/tLqCWSjSG/bt7Alb7UIM1YwM/5Alx5IQcPCdpqiDZ6?=
 =?us-ascii?Q?isZRBYnw63EPflmGWTicysBl8d9LfLm/8CdYsF5wHmZexzx+Ac+69XCpS8+m?=
 =?us-ascii?Q?m6o9+GNGtpQQPoGKOux3DlbdER7cm5GvYCvjyI6FrR/i8Md9BbARLDEEimU3?=
 =?us-ascii?Q?Z66m5r6ZfgwyrR3Yp8KpifZ8Dk6UWdi2Uqxwr8JOvpDqB/c4mKY6Nap7fxTz?=
 =?us-ascii?Q?+cAeOhpIiAXbE3XsqEfiIeXVLRD3boPYdgGIKS0uGSF24kXW8xoFr/r0Z1Ue?=
 =?us-ascii?Q?ZWaeEQMU5+IInMkNTxKvoafmc2kKI45cl9zIZ1r1xwq7vxhonzfUibmdeWRr?=
 =?us-ascii?Q?JWU19NrCUZcaZeit80ecXFNSGXndhGIK1tszTkwnAiVwXUBrpA0MeU2OhC59?=
 =?us-ascii?Q?h9RwKakWboQWu1u6wxGa1GsisoatEQnptQwfbWSFiX53cECDJKPtvfU+EGjJ?=
 =?us-ascii?Q?gZpRd6VpwUBkjz+oZ0v4eiDHJfPOcHEm0f0k?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:24:24.7643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 521bf3f7-6792-4385-8275-08dd7d91a4fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5988

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Changed "fallthrough" to "break" for MSR_AMD64_SECURE_AVIC_CONTROL
   "case" in __vc_handle_msr().

 arch/x86/coco/sev/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 49cf0f97e372..a2d670ceef2f 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1398,6 +1398,15 @@ static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		break;
+	case MSR_AMD64_SECURE_AVIC_CONTROL:
+		/*
+		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		break;
 	default:
 		break;
 	}
-- 
2.34.1


