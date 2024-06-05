Return-Path: <kvm+bounces-18885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB988FCADC
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E230C1C2145F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EB119007B;
	Wed,  5 Jun 2024 11:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NyztrFS4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2C27459;
	Wed,  5 Jun 2024 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588153; cv=fail; b=NLDbaxvSe9IBdcFut9W0pi0IRhOMf7h5ujtTDUG29veHKOgM+FVuVdpMmbm5wv2f6W58ZdIAFS5ipv9MtT+vTT/Sc4NIs58EBTu09C2r/cuEsIwPPhwSHE6OSAvYef4O8aYwR41bHmOvbEPzg/2aRm9QkHUdk/cMXxPfe3MDQ5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588153; c=relaxed/simple;
	bh=Pl7VrNg6r8jRG6Euk3BO2Gu1aJujI21dQ3wxD2mES9s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVVxbdx3S8xuEtpffZp+xbAvYE0tYAhBWTr4lF/23L/lACk7WM+U/pld7kc2shZ1Zms76cjKb8tIHbdqak638Yw++/9Fa6mKSptr5EIB4d1y8BL/H4c1ZRVkoq7ur/ttPyiAlcwxk22KKJk8kSlFz+a5WPllKdwvjpibZLnH+tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NyztrFS4; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP+K8rCun5C1/BClJCcwE5M98iQ8j2aEP16M216RCycYBVPtF1zob7jdN1NX0YJxp2oDwyl1AjbkC9xOq/xapZX0xSFDf3xGVYSmLsDwj8mqwy6XmlyZFDVJRmVAdSa/PHrwn1BQlJU1XE8BhSs+OTxwhlz82at0ElPirZm4ewnnxBfclfumphjBQpPAGKorjpG12HRUfCXlYbXwz8Vbvn2OAXcPGt1FdZp7fnr2leqT0yju9A3JGA0vUWl8Az1Q3liEIzJAdS/rN3+i/oIXtn5V20yaL0X0t8eJlRnDt9fSD/7kk59OBIvQCtjp8Z608KI2zIQRPFkaDfa3PHpAXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/6aNdu5QBu/Ycn53szS9/KFT6NBIsdQArj1nrSV/Yg=;
 b=jXYqhe6a+cs+89/r63rfCxk4LlmDcFF2FPQC2aDjlCEDfswDB8Zm9bVfdVoiv/4i5zhSoU0MWDz6PyRsjd7GHydVkdLLMqGCR3RzsemkSoz0Yp1fRpGUo+/pGUhw+w+z9X3JVpAuO5l9nYukyhB04DxihJbuWl4jBWhm4s4dPQPsl394CqEYFe+BeL8ajFlFI/iXXR7JoSF3WegyhALO5ylyYtXbfuL9DxG5rPtCb2L/n8cv2pynfiiNP4a4B2RX1YmxGKI7q8bva4+Iy8TVcWDb4wIbm+DVQ/Ugdf5hTRrlIiIfT3Z2ZYPM7fGvSTA5V3o4wRC1gNl+lOc8gXLugA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/6aNdu5QBu/Ycn53szS9/KFT6NBIsdQArj1nrSV/Yg=;
 b=NyztrFS4t86xSX7J8w+dwB2qaaoUFEA3CjVpbcjZlLu3RMLzOipoyg2mvolot0qJPvqtbsQSb7wJH5n3gYkFNts++ejVka6u7eEwArTQQktutFIKJFwwv1FPP5h9GXuqukoqceBzAK/BtUqO9pnVj1Gf/ZOBcNBbYuBrP3vh6bg=
Received: from BLAPR03CA0082.namprd03.prod.outlook.com (2603:10b6:208:329::27)
 by SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.32; Wed, 5 Jun
 2024 11:49:08 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:208:329:cafe::28) by BLAPR03CA0082.outlook.office365.com
 (2603:10b6:208:329::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31 via Frontend
 Transport; Wed, 5 Jun 2024 11:49:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.0 via Frontend Transport; Wed, 5 Jun 2024 11:49:07 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 5 Jun
 2024 06:48:58 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>,
	<sraithal@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH] KVM: SNP: Fix LBR Virtualization for SNP guest
Date: Wed, 5 Jun 2024 11:48:10 +0000
Message-ID: <20240605114810.1304-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531044644.768-4-ravi.bangoria@amd.com>
References: <20240531044644.768-4-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: 4138d9ad-737c-424e-c688-08dc855581b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IKsR7EzsyxHMqOrHWiCNMqqvA6DoUKj7dcJ2H/v6WkUDZsIJBtoBQ/P0qdw1?=
 =?us-ascii?Q?ATMKCiQo05qlHiBO1pAr5yZTDcOp7f0jfReJSuqqY4nVKFzREicqPA3M6pbZ?=
 =?us-ascii?Q?BcNaNA8jjIyLOXVEhznCINtQfzD7ywGM11yrD6oUoDYMU+KoLdkC2YVVEcND?=
 =?us-ascii?Q?pj0o/MgGTQNxlZ2od7RQTPeA4Tq1lc18RKeplYibz5INNloDs28ObdVT6Gkh?=
 =?us-ascii?Q?SbizDUP49ifYuScGSe1z7wN8MFqVnc3imlIYKqdXgrhcHW5O8WmkKc87Lsmo?=
 =?us-ascii?Q?UJPrOGADGL1qsx3pOsBXYSmjkCTaK91gV9NZi3OGc9oLciwsKyus7tlQ+PVJ?=
 =?us-ascii?Q?5J7We+z2hXIEoxlg/orZ4r4T43ihPr3CGHXTD6pbMn4MIri0GzdeSFQPgdn5?=
 =?us-ascii?Q?FDuKZOiNzQPbgIPgSLFpidZUmhfSoR5hQwwCcjej9jw80M2Cn4LijYAQBPL4?=
 =?us-ascii?Q?RMPXUsyT+dHBb5bjwynU/AjJTcLmr6jCh3xdbuYA5CsJKxgHQFnBWI94HgTd?=
 =?us-ascii?Q?1GgIYPTIiiaf9yTqz8epJmQjDsGb/5lp38CHyejbMpm/Mrr3D+4X4EGscfjO?=
 =?us-ascii?Q?Zk8qzTgIjlEW7tTdmNITRTyXo6cZ2GNlBjl2lZwo8Ddl0puLKAOI6BXiiaqC?=
 =?us-ascii?Q?nXDxsR43bX7TmcDeI/YdW7uBL86yl1+LPjIAUVa6XCg+MowdT1Hda/3F9edb?=
 =?us-ascii?Q?C/OgDpJ+bobxuhRRiP7JMfn1PeLtF97R72t9U31pJU+g7BnVPkigNUnVDhpg?=
 =?us-ascii?Q?Sm6zJJWTJWtm0B1xF7V1cOnBs7PIDT8c4MO+kBh1pLcj/Y9cdrsW5goJzJl9?=
 =?us-ascii?Q?2xtBOXo6iAWTtroOeKNpYSa7JtVlvH+6+32XCzDGbeKLJcvCNYo8FpkCxhV0?=
 =?us-ascii?Q?oKh73SJZ6A/SdpmSEcmF4qzCEO882Gw32zXLUlDam2rx/6d/NUPIe57EjWB+?=
 =?us-ascii?Q?ZtyGQ7xDaPnYXtmZtOMtAvXpSX8C7t2wjxPCkFMfqvN9TmMhmtcz4aZDgl1j?=
 =?us-ascii?Q?Q43tt2JJmU3/ibZhnGnUVdTabrOT0pWKhS3ygSZHtxfLNGe/Ag7FjNEUBbDH?=
 =?us-ascii?Q?iB3ZnR94s/4XKD4CdkNjDHIPBtkaxX8BasI6WewxAJRMLG4CHOjdjWpbcf+i?=
 =?us-ascii?Q?HmDvR4hByFm8gpOYTmcc0SA03TCxhfy284AKHIBk4GBr+vIpExXMZYdMD5Ws?=
 =?us-ascii?Q?UaPD8pZM7QGzGfJSyR+/kW4gVgIyXIDF7IRIxlMiUuUX+T5nxJuhHV8fX9I7?=
 =?us-ascii?Q?eyvlV0Y2CgQufZl3Ng3Xu6W6/HOR0DEOvcZPsIa09JR/dCWYUCnNrL7uFblS?=
 =?us-ascii?Q?tV8el5/LPD8FOyE42XvoXaBPh5QZP1jmRsT9rL+NDuP6tYvF6PRLovnXl4s+?=
 =?us-ascii?Q?cZwlE8bKAE17wd3Cg6sYYflx8JC42sL5fQ6VaGv8fZYrqplM8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 11:49:07.4161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4138d9ad-737c-424e-c688-08dc855581b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048

SEV-ES and thus SNP guest mandates LBR Virtualization to be _always_ ON.
Although commit b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization
to the processor") did the correct change for SEV-ES guests, it missed
the SNP. Fix it.

Reported-by: Srikanth Aithal <sraithal@amd.com>
Fixes: b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization to the processor")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
- SNP support was not present while I prepared the original patches and
  that lead to this confusion. Sorry about that.

 arch/x86/kvm/svm/sev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7d401f8a3001..57291525e084 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2395,6 +2395,14 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		svm->vcpu.arch.guest_state_protected = true;
+		/*
+		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
+		 * be _always_ ON. Enable it only after setting
+		 * guest_state_protected because KVM_SET_MSRS allows dynamic
+		 * toggling of LBRV (for performance reason) on write access to
+		 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
+		 */
+		svm_enable_lbrv(vcpu);
 	}
 
 	return 0;
-- 
2.45.1


