Return-Path: <kvm+bounces-39675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1243EA49473
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F08141894AEE
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57EE255E3E;
	Fri, 28 Feb 2025 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BJjOCY8E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCF24A06C;
	Fri, 28 Feb 2025 09:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733777; cv=fail; b=tbhxp9aB478GHlD6ny7/fVz/n6zAX0ZQ8mGG69HnD5JwspVwONC2j3YUIlGEbRV/05EPaOp90VdPBMmACGPRGiXFlsHAI2JSpiIXUoiruKco8eD1L8ntAFbXJpBXWNRW0YjEohRIq2IANsFWyETbiAC80dKJjOH6iPmsG+huAeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733777; c=relaxed/simple;
	bh=SOjmWcXofQOcDgqq25ssFmfZG6jOLuURxu6zMHLtnHk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jrR81JEUIBJKODI5V0wKIx9CV5dbYY2xIQg8tMETWglNwLxoofRut4uvelfsnHc5ukGrQJUfW1KKO65MeYKd/pfPKO7yjPScfk10WQ0a/cuDKKIdwYbyr0envhlNI3+wyZXV2uz+2RBPy+ilHP14iC8DOfN0WHhnNab61Drs8Vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BJjOCY8E; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9DrLa+/3Whwat+iJIGhpUR13lcdxgegv/4x95YqXkSYohskVVZm5bXWZF31AYD3dW0k/XsfxyudwRtq+EK8a363kaupkAsMKl29/AJb2dYP5Mim73BFFkmgys6kK6aSQtSkc0D6ukNX9KybbBjy2Qi4YMZQaQXS4wdBf5JP4XOV+3vGGIoSYPy78ZM8BY7iVgb5+FKy0ghR7h3Ys6kA9RGOCeBQkcdJFS48XS6OmmZTwrhilYirBrFyBTdfwl6qLyWCikPUROIK8sqyN34DZetu9m+HGYUuQCojaQI8s2Qhu/ssiPGm1XOeZTdFWU1ImYE+bcTx7cwIZ+a4nbAqSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5U1XQam6vnboZ0ChfmyQYP7hjtdOJg9jaG6xCX7ZrQ=;
 b=CrUej3GBfnVypALHWzXUMEn/rhVAaRlFaDGTdccp/TMnv1xmuMt1lT2Y642FqEiJ34QjvGfGG3RVH6SVnZWfLmJp4T2ZgE+c66f8m6BNYAKagaFmSvoYyS9JPMbY11zB7h6SeZxwoFGwYoQJwqnqcsA/AjrLEG1Db80DJqpInWEvkLqcKd2I5x/l8Mm4PH7yXO8LNhlJjsbPzYoVxBOG0M1WT4aGEFkRDWZdwqECBtvpaW2jFV7bHJyDRenjJ0AXCSQH0K/duv/m1sbDFz9cESAM5byODmXLqylyVCQrLEi+LlggRq01mw9LzKpTnWWy6pgUPjEaH/gic0ahGNLQPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5U1XQam6vnboZ0ChfmyQYP7hjtdOJg9jaG6xCX7ZrQ=;
 b=BJjOCY8EFYdbLu68L/HvuQhmocJlLJE5W/z3pEkrw2vDb9ICwUsDZRdCG37VmV7+TQxn/8wH/QmHYdC4CsxY56hV/Mv17eHUCdh3nUzCoBUok8WRXBsRxDY5Q6di0i5o9v/2xi8xTrxn3FxR/ZeddPvXy6AQ54F2lBt7IEROqeM=
Received: from BY5PR17CA0009.namprd17.prod.outlook.com (2603:10b6:a03:1b8::22)
 by SA1PR12MB8888.namprd12.prod.outlook.com (2603:10b6:806:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Fri, 28 Feb
 2025 09:09:31 +0000
Received: from SJ5PEPF000001ED.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::60) by BY5PR17CA0009.outlook.office365.com
 (2603:10b6:a03:1b8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.22 via Frontend Transport; Fri,
 28 Feb 2025 09:09:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001ED.mail.protection.outlook.com (10.167.242.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:09:31 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:09:08 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 10/19] KVM: SVM: Secure AVIC: Do not inject "Exceptions" for Secure AVIC
Date: Fri, 28 Feb 2025 14:21:06 +0530
Message-ID: <20250228085115.105648-11-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001ED:EE_|SA1PR12MB8888:EE_
X-MS-Office365-Filtering-Correlation-Id: a364d3ae-1750-46f3-d911-08dd57d79ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QhlCK5WZDBAHbCH1u/Q4vuuBD2EBmRfXIS7IF0VK/xGdI8dBirwafknBT5vU?=
 =?us-ascii?Q?JYl1JSbUm0X+pO4IftQ2psGB/1vVxDbBuVaTVtyNkomUJkbQ5zCWpDCkwRpm?=
 =?us-ascii?Q?pDgTJ7HiVE3zSSq2TTCECp+SAzhQW+2Ch0J79STqIKJC8PjMmRXFZvLFArpE?=
 =?us-ascii?Q?RzHTgMGRXJwXe4abkDOmSwWHH/89Zek2Av3/HIpvZXIzfeZM7SOcKbYlDZG7?=
 =?us-ascii?Q?ntRc0m52PkzIQzdPGdb/YKpK/+/PKGiDLpp0tEiN+ugeReUFoGF8P2Gc8/vJ?=
 =?us-ascii?Q?x8FkKgUeSbM3zTHTGyKAmPoXDa1wYNRiyt9GyiGBkh+ch2cOSwpKdBzC+UeU?=
 =?us-ascii?Q?OMVyMSpY+mGUuETG1+7jH9bARkZX/KHYSQ2gJImVOYlRDp9U+FTDZJT3gr/6?=
 =?us-ascii?Q?+ayw5eroUU0s9hONZSr5lBOPoUDgDzXF6cuDM7I1oT6LRdtPidDDlP8LT7MR?=
 =?us-ascii?Q?q+mt3vpJ5xN70He6Tztz+nMQuzZ/nooWZP1/H3JtEnwT5MC5YZOd6VLEcMlo?=
 =?us-ascii?Q?/xtJA3iosvrQsYq9QY1YGtAM3cnw869+THbqzCPVGeFOX+6NTZZkZhkla1jM?=
 =?us-ascii?Q?AyVUubK3haE/+FJFpVfbRtOTsIZLxK2guBHBfLkmHzMB0a2QGUvgXkUultL8?=
 =?us-ascii?Q?sIOFiqqmf/6EeElswKcf51uJ+1DBi30+WLbDKVMHhVkzXL/SRBJeFW5Rny4c?=
 =?us-ascii?Q?oWuDguvGf/TJAg1BKpRnQlFVGGuW1Xg5wbBIJ94Sd1dfWCIDqx/UOU2HEBQO?=
 =?us-ascii?Q?tv7fWfRY0qpFU70QI82IZcqFM9QD1nq3FiBNV9CwAiF6XC+YFbnBXr4ZyW5B?=
 =?us-ascii?Q?MU7Nw2TC4UDQ18fwvb+GTXx6nlQwJ9H+25Pa9uXEgyWiIDAWyX0xSfE9YBCR?=
 =?us-ascii?Q?g7aYjpZoonjTxbyBtQsvHXxB5NxHI37E/IN+jbmET3c079tF5m1D2G++Stfz?=
 =?us-ascii?Q?60U1Zt4bdeQ60GR0g296vBoUWmmsiN1secDqe7ALZTs9VU29OJNghWNtkmaz?=
 =?us-ascii?Q?xtvg0VKjvrxXREvp8tefp95BgELVFcZQqDCK/mKqrU4kMRaft+Jc2Q4/H2bT?=
 =?us-ascii?Q?EZEGerPjlEq2WoCLBdgnN701hTLO12xgjW1RTiL3olctrec4HBRPqQka2tOW?=
 =?us-ascii?Q?M4CGyLNmETVgVdE8vR9rOWwQlUPIRr5DlS35mStH/pIOZ3ZQ//J7rSSK4JB+?=
 =?us-ascii?Q?5ggoW8ZWVoz+7Yia6iH/xzZsFZlmOMLEqMkzyCdE/w9AeO2O8elI32HWurBD?=
 =?us-ascii?Q?QyhkmSveK2woS5FrX7fECjYMnmMsRcSCpt02qvX3Z0+3fzWTlnzhlPtMaWn8?=
 =?us-ascii?Q?Jp4hXQehq4/KkFHmc4zrmPDmPT0KZvlvva6HJLndBlwfXspZDQQ4EHJDS9Ra?=
 =?us-ascii?Q?1EjJEAZgZaLofq9qXOz33M4Rsjc+w4N0pM8NnDh18WNmdgtX8rGmuY2UCcmc?=
 =?us-ascii?Q?FB6DVSNizDWTf4hz/oUrYkZ7GgEEE1/JwGxnoDZHKSaNv/MLKLd78w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:09:31.6028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a364d3ae-1750-46f3-d911-08dd57d79ce5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8888

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC does not support injecting "Exceptions" from hypervisor.
Return from svm_inject_exception() for Secure AVIC.

HW takes care of delivering exceptions initiated by guest as well as
re-injecting exceptions initiated by guest (in case there's an intercept
before delivering the exceptions). However exceptions cannot be
explicitly injected from Hypervisor when Secure AVIC is enabled.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7cfd6e916c74..58733b63bcd7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -463,6 +463,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return;
+
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-- 
2.34.1


