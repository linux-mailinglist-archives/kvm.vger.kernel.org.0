Return-Path: <kvm+bounces-15684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBA98AF40C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C6461F236C5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2AF13D516;
	Tue, 23 Apr 2024 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3UfvZggH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFE113D53A;
	Tue, 23 Apr 2024 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889561; cv=fail; b=BxXk2sNT+cW+Jt3A/V0ysaWOQtljt2Eet86DIY2DrUzKi7JjP93sJuZCLcNKONPvGPI1+8s+mIQhaO1RSQLoUsadZC0qoGZ0nFpyjRWrUIITplUmNUgMAo9cMYVoNhnWS2v0BTgtdAGRwzObYf9EEtAXCoWOXCbSYqPBmRtcvXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889561; c=relaxed/simple;
	bh=QYsywJEtTFQXgKSkNp0tCWxyJgaUcMEi8U/V68chOjc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCNobDUwuUkKp4mAbVz9OnlKlSv3458QOLtDQfL1xdc+EY2yPRSbuHplFbSPm2qcLPwO47ampNGnBJ5xG5Co8YrHY2OuUu+qjXx/9v9g1Sxg6JqXA4QpEzfbZ+r3P3I3hsMrJw0jyEDlj0Ne/iK7gM4ORtOe/UHCG/XVatC0dFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3UfvZggH; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yfci2WfrZHHz5nlRGHSbC57A4hLpTeFjrkamiRRG6HrlXcp2AYLT1PCHDd3f7tur0KjQN8ybKoEzszeU4heiQzaxP2py1Uob7R8+NPO1ZnBHbY2IHw4PvPksmPlVHfe7tO/jk91dS80+JogCroX99Y+efNyj59cnHL7IvaWftEytGtnIgyZ5GWiuVo/VLvU/7qILfX1+QVp4g+Ke86yXAky7FKL5i7p6cmK3Qtbhfn5zhXIzNDE6TYvvnZkCgpthDAtomwCA1KZ3ZXVnAi4ZMM1fIgwO4acmr8WG5RhU8AC4YOeo7nbfu01PBcdFsTyf3wFWAIRgM/S67UXz/sk+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwkhCL+vr2XzfwAv20MKLDTPT0xknnynFHwZccJ5W20=;
 b=I/LX0CDB8z0wr7DlN2Gzws7N/ZfkcYFi/TfvUFSHU7qGx9SQAq5ehnWXZUoB5rQJaclgyIZgffa57H2ZZR4mA4pjsmlh/eZogVWuzVfzHMx0SxaVUyy9uS3zS4f9AwOASkPa1iko1rECP1O7Ke4hipKb7OvbzzqeaM18BV2jwmbicoxXW0XZXwQPImmHcL3J1RagVuF9YO18Zxvr3v5ICPPH9BazN8vodUQ895K+OflaqLnnBkkBWUCV6HKe8TpktPWJzDxceNvAQl9W8hT0hQBsV4+IaklUdV5uQ6odVSrb7AvvW3Iv+9SQTq1zUo8/mb/x4WH0Hd7eYdmU3I6IHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwkhCL+vr2XzfwAv20MKLDTPT0xknnynFHwZccJ5W20=;
 b=3UfvZggHkPDy+NNrAzZVL1QaINhmd/4wg+UOPZ93iljHnHdYBShLLK3dogH/hBh+9YvJ1tyq2LM3HkiavpY3Lx/qDDq5We0+10mEUBUzDwrl04rPHwFJc8XFf0r3iM7r/72GPgHRcvFHyXoY6vW0HBEW3j1aWzCpOA1nEmN3eEQ=
Received: from CH2PR03CA0026.namprd03.prod.outlook.com (2603:10b6:610:59::36)
 by MW3PR12MB4425.namprd12.prod.outlook.com (2603:10b6:303:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:25:56 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::51) by CH2PR03CA0026.outlook.office365.com
 (2603:10b6:610:59::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.35 via Frontend
 Transport; Tue, 23 Apr 2024 16:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:25:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:25:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 29/22] [SQUASH] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date: Tue, 23 Apr 2024 11:21:44 -0500
Message-ID: <20240423162144.1780159-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423162144.1780159-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240423162144.1780159-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|MW3PR12MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: c96d2bce-f9f7-4b06-87ed-08dc63b20d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yLZdUGzG5KhLqt5/mgdReNk1Bu4q0B2UNRQNa1pKLc2iR5qEUFQQWkmMGYxV?=
 =?us-ascii?Q?BcXFBsYRcf6MthaCA/2rD/FmDZkSqTs2GAXx+1RyVZj4GlFexXM0PbC1bOvH?=
 =?us-ascii?Q?BSIomrXMJTw0XqxdzutXGW9veD17b30uuE+Zbl8RX7paa7cbX1OZtacfv9wt?=
 =?us-ascii?Q?+s06XLhUkKZX6D2n1p8G+ApH4PPlew/mmnFVCje4AoVbYUzy9K7g+22wKRHr?=
 =?us-ascii?Q?1BtLnrBiQcNS2UwCfQ2OSEDcTKriJH2CnmmZEhobTrowHVkJt5yDSuzwaTHM?=
 =?us-ascii?Q?a1CXATtXMDlarhtnWCYSjst4U+/svPhwND+Z1Z4IKKpTjcfD3iIndbqOnDcE?=
 =?us-ascii?Q?8biRl2wAMnVTu6CIQkGASDK4GSN4IWuPHoYWrxXM01dDseQKGQCIWNdhTt1Z?=
 =?us-ascii?Q?crA/dQmJQvdcfunItZrTIyvgMLbO9UqzCcRyreO+bQYGfsVug4UucG2GAXM1?=
 =?us-ascii?Q?/IeFFdhmAVbkMJmVX7YebA+iRHLA7PdahRy5uu5JNN6NKml/xU+HvWy48W08?=
 =?us-ascii?Q?rt/trygewendQJn6W1LWnr6QJIGrcKVyygVo7EPoEfc1zeX/FXVkZZ9RCd/8?=
 =?us-ascii?Q?Gcuc9CtItgBwWDu27kXNE+ROgE1dAdNuePCqddZwPduDt8CKUa8k/exqki50?=
 =?us-ascii?Q?3GPRtWcz/CghPiCHGBoTxbAq/cN1Sa66+r/pC/FLwnfxr9dRvpkaxmhpyfmU?=
 =?us-ascii?Q?IsBElvVE+Hup4SKMl++zI1zuwc46Ni7eHndfBBkNOjKeHbYXb7ucyy7usLSh?=
 =?us-ascii?Q?HQxv/UJM7ugShcdjzyWT9Ru8xqjEI3Dn9x31XQPEeji3yS0FO2zoIFFi6Fm7?=
 =?us-ascii?Q?Eng4VkXcM+LXeB81YtbOLpiTkPd0XicKL3xgnNiNlFmNevbw7IKEKVD7CTAj?=
 =?us-ascii?Q?jG3ubVjZQHwUS9qMp5Yh0aPzGaJRBjxmx/FmKW2R2Z8BzMNxvrD0ni21CFlV?=
 =?us-ascii?Q?mjnTvde4Y/3UycoElzCFNMczvUc2OKIrE84lBzneyOWUs/M6HfeYfgVkdtFK?=
 =?us-ascii?Q?2We87V/P6iJVwztE02P5vCTPwmlwOtYlvh0t7vSnLffZcUeR/V8eotBMK3Bs?=
 =?us-ascii?Q?YEMgHKqO4lpNk62iEA6+/hdzuCSeVvv/9vRvAlIpaJ337OgLmHu1bP94PKI/?=
 =?us-ascii?Q?P2qlymMTtcNRdyzJQWdwMGpAYev+pBa2TQq3tFdaMy8iHibPeIStpF2xfiIz?=
 =?us-ascii?Q?RuoXh+iLmPqPErd9csdJ2IU7KWx2W8f+I131SD/S+bSI9w679GntYXAxbTxm?=
 =?us-ascii?Q?NOed1mQX07vTLSPtm/WQP/0thUVahY5kF4fjhZg/xv2H7rdKWMvtogX5hZiA?=
 =?us-ascii?Q?tG/2jFUoIIBkO9eG7Ky9RTYbo9s75i0Ui0rLRuHJ+rEY3B2MX1ibUdef2Ngk?=
 =?us-ascii?Q?XJVNjFQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:25:56.0055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c96d2bce-f9f7-4b06-87ed-08dc63b20d74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4425

Return an error if non-SNP guest issues AP Creation request.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ff64ed8df301..1137a7f4136b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3280,6 +3280,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_AP_CREATION:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
 		if (lower_32_bits(control->exit_info_1) != SVM_VMGEXIT_AP_DESTROY)
 			if (!kvm_ghcb_rax_is_valid(svm))
 				goto vmgexit_err;
-- 
2.25.1


