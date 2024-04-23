Return-Path: <kvm+bounces-15681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 848038AF3FD
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A806A1C23C87
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAD913D271;
	Tue, 23 Apr 2024 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zf0ivwYA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C21713D2AD;
	Tue, 23 Apr 2024 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889499; cv=fail; b=E7Q4WdiygGaDXtIG243li1E9jKzGHb/BA9rTuHTcssQj4MK//5c4fMgu+XqDbWO6b/PnLWB6GImvUxXrIhK1jRvUYHx3WfEnKlkOT9Z+/7b1SFLS2xp6stmau+VNOvOEPdoIg6FqfPboBBw77qa5QF2VJPA2DeBZKbg2MXJs8pE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889499; c=relaxed/simple;
	bh=Hqu8g3lufpzvpZmy911FqVAI+uPF9ZUqAPOn47F8gck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqtFc4gYbE7rPV8xFXic5XGVYN0THoflWL9S9BllDYtnXj0uoarv84ixJAdhn14dky0dm58RkuKbnKfFTRtxqQCHnHUPBV+ah6FkhcF610upjixUc5xYWC08+i9DWbdYJv2USm9u0rckQGYq30PXGR6QL/UF6Si6um8XKOZjZro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zf0ivwYA; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcPvJhDC4DpDvm8BPhHiA3xj7rxj7SxRQk5/+IFNoauCms5JJpbpiZ0PNJ8OVdtyUN9SjuB73OW6I7eq3P/lMyFt5gM5f2HrKbtgIsLLBlMtXOTuWsNlkIHCoKbmYfJHrs61tc/nY3tY6Pst6Vq+I801nG8lUQk1RHLP/ZCQB/DFwgh9o5/lPPKeLuSU24A1Tjus7VIc5j4QADRYr3U/QKKSJXn5GmPcKR9sw4SIqZmmJzhxB9S+uXzfzFPdXBKT85CLfuqxxVBVIm7IgRV4NvqEvU8MBWpvmjJ6x6SKPEzdCjuKn168fCqdMTePKH02Tq3tfY2X9TorDQ9RJGBjdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vG3S0O2gsTtGwJiNSTKKUogiFWvFQ7jZZ4ltgA63IYQ=;
 b=DguE2FHaX2DD5wmF9waZ78meSY2M5LMw7JoZz13CJv0BgJRtnxP4cpvXydUBcXngzxtEjTpWzffSH3O6Xw7tgN8OSD0P5CTPDZg3dotfPNN6f59LgXzkDDKVs2f6XDmeB29zWYj8E39xsRGcd3LX04Lmb9FOxaVI4UEEiC/9fdb1/a8daF23ZnGnb+bG9Exj8rb46w4/PGghh1MxdaLP/jfQezI0yrPgr72Yr5f/Y3WD0aR6/dqJEU7kmvaqmreiQ/Xy5QOvBPlPssDF1WN5FuaKbL4eDoEcawDYPOS/EW7dkklp0mcw3FuPE6Vg6FoPXybgIuXWO4RLCURp18Fsnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG3S0O2gsTtGwJiNSTKKUogiFWvFQ7jZZ4ltgA63IYQ=;
 b=Zf0ivwYAX7fy+wdEF9Qof4MGa15Oop3e78JZSbYLrp+EklV6j+B3NgQPBWu3UkKAheug890adq40bHLaJ6BxCfztPJmFrZsWfgS3PgZtx2KW7yceHVPswqDunuUuOhopNHjyQUTa79CxJPHWJng5dbfOvFDlaDk6j8ghqmbGI14=
Received: from CH2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:610:50::31)
 by SA1PR12MB8723.namprd12.prod.outlook.com (2603:10b6:806:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:24:53 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::22) by CH2PR16CA0021.outlook.office365.com
 (2603:10b6:610:50::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22 via Frontend
 Transport; Tue, 23 Apr 2024 16:24:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:24:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:24:52 -0500
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
Subject: [PATCH v14 26/22] [SQUASH] KVM: SEV: Add support for GHCB-based termination requests
Date: Tue, 23 Apr 2024 11:21:41 -0500
Message-ID: <20240423162144.1780159-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|SA1PR12MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: 8381055b-eb61-4371-7071-08dc63b1e7c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2E/YhoPMALZc/IJA508pKeutHS4hK7cBi5reSnPozTyqJjT6i/iX62LCNxwA?=
 =?us-ascii?Q?LSTOT9n8c21mRjjGvoBnSGHcGaZFaPvEdvFVP1GK/Plu1qBlaHC6gLUm2OcQ?=
 =?us-ascii?Q?9hT6jaW9i9FdO9IlGWuCLlYWP21etOE3daiRurrEmzJOVve6eF9u2GnCPJ6a?=
 =?us-ascii?Q?Ly7d0t1tSDOtyueZP6POJAdxASpomOfWxq/ZhOQasJnYub+p5OYQ6bZrD8aw?=
 =?us-ascii?Q?KZ7EO7oomB5OJ2yp5ssM8hoFBYdnV6e9iT0TjjoFW87BaJorh6uvOby7CpRY?=
 =?us-ascii?Q?xI7cYWGW2kg2p7BL1FJ9qrjGNn/UrMf7A2FOb/uzjYmK6J87yusdlbFv+6x/?=
 =?us-ascii?Q?S3bR7NmlsnRIWgKUmKmxoQAFePWuAduiVnYvVAjk5P85LoqzMcmN2twEm7ig?=
 =?us-ascii?Q?nNY4rbs9knXuHa16faZIHTynz5kS12f7gAIqX7YNGx3pNRbiUTEUScLTOuMu?=
 =?us-ascii?Q?oxwJodkhF0aZ4O91TqcIPpzw2EqXPwDGfYQW9o6+JZ+hN/UCThWj2z78qPnO?=
 =?us-ascii?Q?XQy1TKaoxGOBxcaPp+/nkCc5XSI1R7UMYhJzNcrO3i8C6Ot1UtvvutpVoMrt?=
 =?us-ascii?Q?h5uTRVjaml2dJ2bIKD2GyKyF5JkdudR2z913y9cBj2hDxMYFCtQSevujXKV0?=
 =?us-ascii?Q?d4Y6SsqfG0KSkFCQ+inTZksblOomCozv9zOYpdCq3kNW4889l8LKU9mQYWwZ?=
 =?us-ascii?Q?+P8JwkFdDy9+1OVsU+vsFxmzhQkCStmzzA42JwLZN3F+nnqvpoh04gmfSXYP?=
 =?us-ascii?Q?A1hNcmMqVBI2wodKRyZ0grhjg88/x02Sn1xshiGO6AfgpkT/mzuUESlgEnIZ?=
 =?us-ascii?Q?dKKvcjjl90ZOZM0zhwwPNmz0B86dP9j8Z9PPqqfloUW0mECExsroZ7dUUINd?=
 =?us-ascii?Q?hY0UxeWxjiJc1c919dv73YcYUIAabtKpbA6kVPQ/wR3vbHr2PM1CZHU9jvNP?=
 =?us-ascii?Q?oieszm1H8oU4gfEw/m8hYot68jSHxFgu48yrHuayjH84fFgIdbMJ9e97cvv2?=
 =?us-ascii?Q?3ElN+KBGTKZWzEQT0qKE4FWDputoHkdZkS5o+U7EBcSHzTSKFYRcQ5oKtTD8?=
 =?us-ascii?Q?dztrcX4sySTxaFMaSIghjM4HwlYmu2rDLyVFrtqbQJMQ075czxPbhw32/J3M?=
 =?us-ascii?Q?jMJduI8E6xQ1QIkea+J4zUe9/rOrCxGTU2ZtGiw+6JI3sFLVCRIrX/OsrYkT?=
 =?us-ascii?Q?mS0aM17899fdDSIBSa0UQEjZGUg43KdkvD8HxsoGJQWibuK1k0NnV9O2YReR?=
 =?us-ascii?Q?JmYbSXhVv8iXWhktlkseZPU64sidJIfjQUuT6a/UKqsm4ErbOqUF/mgvlXkg?=
 =?us-ascii?Q?Oxwj6JleMXyeoou8nq5+hJOU3BK316KvIi7v/d35Of4asLDvnht4u57HSKnj?=
 =?us-ascii?Q?13ITxrQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:24:52.7627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8381055b-eb61-4371-7071-08dc63b1e7c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8723

Move the case statement out of the SNP-specific block so it can be
handled the same way other SEV-ES requests are handled.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c00081248ffe..0e22f588dbe4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3289,12 +3289,12 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	case SVM_VMGEXIT_PSC:
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
-	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
-- 
2.25.1


