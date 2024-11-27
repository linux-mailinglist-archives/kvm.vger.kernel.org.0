Return-Path: <kvm+bounces-32611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E70C19DAF62
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4C4E2815D7
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEF4204085;
	Wed, 27 Nov 2024 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qHpYD1g+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F42036F6;
	Wed, 27 Nov 2024 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748191; cv=fail; b=HFDWkvTx5OWGtfr/iVMpdQvp3De7Vdyrlfi8lpfMjU/Yfel37OtLgCdsBtpkmh8PkLA80Jd4AHI7BWHvGR914mOm1uSanCgp4Q6yLasqeIpU5G75rjQFfwWQrgy1a+lHPCJqZyrjf3r9VBORAW/IA6f4hjxm5ikyezmr1mpiiwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748191; c=relaxed/simple;
	bh=O/uDhENTpi2yI4Pfiz8Mw6hgm/uWiWDHHbqWulVsEVY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9Zd7WjqaFsGfHq1a/Oyu2AsL+ESQB0HCvScgzfPbHF8eb+f8bXBpOJbV9NtvRTkAMoZ/IiM8alrM/H4jKJgrC5IcOPZWYHMvfA3XHwmoZEhwJstJl3vMEQ2AIdMPNwy0wkbImYBmmU9bM5XQo01SeQhxAVEL1mHyuma0IPEGx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qHpYD1g+; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYkw4XkPOBzk+knHoi6cj+GIj8hMcskff7PNHZ2xmKYPPquVWrmMGnNxSyiJ49JLpPUTw9f6R7E2ZtRnYukOmVcboWPSNt/X/hyzall3mLvFh3eXF9ICCVUWHbRGsEkCdJC/evtkI12OYHlcJ3Cldps7lSvpO/WBqa/Y7Gl2vYzhm2HsonYDsXo+2FCOv3qGnWFM7AConE/KbOiNMLeC+SFwy7f39KkWRFAbgVyOBhbp9fSB/4UZYXpST1scE39dk25lx/Y9n+bzXV/UYssh7ewsdc18XZX8TUIDkkwUOyL6Y+5Or4rXo1QdITLz/g3Fda+Hf+qRwapXPXD6c3DtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E1RYwEXT4MapY4L7CuHPs3znYJIC+82CrH4S+JkdqA=;
 b=lf46gnU590FesPohAIe2UW3nGzw1TtSOzdb28nMLFtekWQsgFu097DNkIXXa2FBPuBQCpVRxoI2MTsXX9h0Msq2RK4hahV1sdlDZgOSrIUbTsYgMJDlmH1laGxn0FfPNqhNVE1fHKxF3fo9Go3qSkUVX/rvYF4dN9xQ5ULg41NHcVV29iFP+DVXerTfRToEw4hBB8Va78Qyo5lYHGudkCGFeum0FG0GggijIvjl7H4qNNG82lrzScVoJf916gE66D/HUABSkYBjCUYPaqFcIoy2jqd5on0fNKOFtkMx9xvBBhz4Z/7/NS5mviZpQbK0tElbALQk5RdgUHu4/VSHnqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E1RYwEXT4MapY4L7CuHPs3znYJIC+82CrH4S+JkdqA=;
 b=qHpYD1g+2IQ11NnZOGnu6WXUjMy1Dd+aYz2+xiYXyk+1F2EpV+TOo8MFAB9d0OT9XT7aeFnzWamnNiCmc3WD8+PulbhSisy5GLkEMOFB9OMcVGIE27qJvpNQo1G/6SUCM9fOjemkAetV9EeQ5je7rYQo0hCdcyYFro5V7GssCiU=
Received: from BL0PR02CA0115.namprd02.prod.outlook.com (2603:10b6:208:35::20)
 by SJ0PR12MB6685.namprd12.prod.outlook.com (2603:10b6:a03:478::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 22:56:24 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:208:35:cafe::89) by BL0PR02CA0115.outlook.office365.com
 (2603:10b6:208:35::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.21 via Frontend Transport; Wed,
 27 Nov 2024 22:56:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:56:24 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:56:23 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 1/7] x86/sev: Define the #HV doorbell page structure
Date: Wed, 27 Nov 2024 22:55:33 +0000
Message-ID: <20241127225539.5567-2-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127225539.5567-1-huibo.wang@amd.com>
References: <20241127225539.5567-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|SJ0PR12MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: dc4a332c-3b8c-4d26-0400-08dd0f36b801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XwosRrwvqVvjL0EEyu8FqRK3s3oQIDxRakZgimyag+X3/26UswZcbjVphb6d?=
 =?us-ascii?Q?fMutG4DdJ4XfIXcErkEfHioNQudeLl6zpciiHkwDalB/m6t3xiBaTMbsezbF?=
 =?us-ascii?Q?sEO1ZA1NZeqAGkuzst9Wbpnm7BoySrrNPgs9P6XgGrsLVOdTIK0IRIzfeaO5?=
 =?us-ascii?Q?50e9SfoVdEgPXxX/8c3hpparzYwwzDCk9/AezcxhjquOnA7aoTo+/gFBHhYA?=
 =?us-ascii?Q?0wFIyaYrsBKdKPst1iqIVxd5+WOeO3nT3x+cv1fW7uhVbwkWobMz2tsr3/hm?=
 =?us-ascii?Q?1mf7u+2Wp8l6J0bTHbXBDb+MaBN+pSqulkuLour+q0kKqV1CzeaW82JYzOCL?=
 =?us-ascii?Q?HLMyVrmcjtKzbkx8kWFbq255okDqueRzqDELA6wFgG0RlEoq1YD+QMi3UvLl?=
 =?us-ascii?Q?kjRo6vSccctZwf9yrcTf5Kbm+0ebJ8ki1DRf6poMCsPCU4wsuXizcIeO7GSz?=
 =?us-ascii?Q?tjIgrVjL8tlHmi7ERZh90SFv2TU7HnPAsjeKbed4MZNKUL0aAq5pzVM2V2/U?=
 =?us-ascii?Q?U7xWDHyy/vp9CwW8Sx6Gl1cGbWYV3ziwUNC6mUzcQJk4f5q1/wh5VwDGabH8?=
 =?us-ascii?Q?9xiPUVXreoU1lNwNZwJYCOj91umv4rpu4UyleeD2JM6tRo1LyUgKp6YpRF9S?=
 =?us-ascii?Q?IyQZXN1cwzY5DH24+EP25lOSbIBwvlBNdNfdDsxoxrEiggba/hIuC2ec4EFu?=
 =?us-ascii?Q?2RmNSRWYFdJih4yUY/qcbcD1py7ZUlh7iF7BDo2zwjC3GMEYGlWbyO0oGxe4?=
 =?us-ascii?Q?bKKHgXs0JvQkC1bJbUuHkFTv6vjk3on6Ubyu/6N8EP9wOKQlPYC+AK3tit3r?=
 =?us-ascii?Q?dr5FCP3nzqnRE08086ZVCjkoac0JpueLK5BAbnAGB1xs1BkLipJlfF0S6zuh?=
 =?us-ascii?Q?5QAi2WB8/iixrkq3TfIzArSIys02FE82sJJBzPHn0NmWcFq/Z6Y4xBQoxkhc?=
 =?us-ascii?Q?VLavyvh413ucITvxkJSPRCMtVnZ0fBKdfN/zfi4Qd4RA8mUHroQ7f+4LhzX/?=
 =?us-ascii?Q?ml6bewrqZCqRAaBKMxKg+/BjpwPxBt685+vSBsS1vgzju1HJ3sPbw//BvR6J?=
 =?us-ascii?Q?nm/Dgs8kGp9GTa5MrogYR47G/EaDOmI0KGshSpQmiqnwxoFj2mzSiW68osco?=
 =?us-ascii?Q?kH/ct6HiB5riCVmPqFlONmPs/mEdFFUipQydxTu5AATNtUdmgw3QFGEMsero?=
 =?us-ascii?Q?1qtaCS0r0QDLZFmOktB+g20nqUt9Dyv1rLCD5R+0qZgjy0Zsl9y0n4GwMmEL?=
 =?us-ascii?Q?TD38mwiT4uLZHNFXaaQvafJGnHVUJM/sEWIf081xlq20rkAeCyuCddDsXs2a?=
 =?us-ascii?Q?iV8ylFOXfOylzVKpRSrjkSUKkeCgehWfoHx6rToZAUCwX0HvaZHOZaaVyl8G?=
 =?us-ascii?Q?MDmekExmbdezaDw0x0JbS3Qb7rnMAEOTpAEeoiRGsDNoPXTw9UyyHLIa7jGi?=
 =?us-ascii?Q?eSkRHd7ZLyde1bp2WdocsQjPyO6D7y6t?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:56:24.5422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4a332c-3b8c-4d26-0400-08dd0f36b801
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6685

Restricted injection is a feature which enforces additional interrupt and event
injection security protections for a SEV-SNP guest. It disables all
hypervisor-based interrupt queuing and event injection of all vectors except
a new exception vector, #HV (28), which is reserved for SNP guest use, but
never generated by hardware. #HV is only allowed to be injected into VMSAs that
execute with Restricted Injection.

The guests running with the SNP restricted injection feature active limit the
host to ringing a doorbell with a #HV exception.

Define two fields in the #HV doorbell page: a pending event field, and an
EOI assist.

Create the structure definition for the #HV doorbell page as per GHCB
specification.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/asm/svm.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2b59b9951c90..95cb9a62f477 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -239,6 +239,39 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_TSC_RATIO_MAX	0x000000ffffffffffULL
 #define SVM_TSC_RATIO_DEFAULT	0x0100000000ULL
 
+/*
+ * Hypervisor doorbell page:
+ *
+ * Used when restricted injection is enabled for a VM. One page in size that
+ * is shared between the guest and hypervisor to communicate exception and
+ * interrupt events.
+ */
+struct hvdb_events {
+	/* First 64 bytes of HV doorbell page defined in GHCB specification */
+	union {
+		struct {
+			/* Non-maskable event indicators */
+			u16 vector:		8,
+			    nmi:		1,
+			    mce:		1,
+			    reserved2:		5,
+			    no_further_signal:	1;
+		};
+
+		u16 pending_events;
+	};
+
+	u8 no_eoi_required;
+
+	u8 reserved3[61];
+};
+
+struct hvdb {
+	struct hvdb_events events;
+
+	/* Remainder of the page is for software use */
+	u8 reserved[PAGE_SIZE - sizeof(struct hvdb_events)];
+};
 
 /* AVIC */
 #define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFFULL)
-- 
2.34.1


