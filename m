Return-Path: <kvm+bounces-36957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 710FBA23884
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0BB53A4098
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C821DFFD;
	Fri, 31 Jan 2025 01:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PwpRzFs7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64058446DD;
	Fri, 31 Jan 2025 01:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285879; cv=fail; b=AkhCUi0ROHUlp2XErnZj1PfNqUNgINHzWAloxhkmwkg7Y62yB/gV5dMr7Fx7P1rmmvoWuEc6SbRqSeQkXIS0a68K896Fn7tec1cnseAPtWZq0RbGORxAhDaO2IC+yvknY5/NdLF1Um1L7NDpMLmlF5B4nuoa2iMR/3MGz/acbig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285879; c=relaxed/simple;
	bh=7WPyINjt4vVECCZnSSPFcwG48U0l2woE59xvg7GyExg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MeDnbLzKS7GreSwzbwzMH/OElnH5EsJKqgh4snV2guOrREZFHEH2W/ASVtCikSbiwk9cDus/bhe+HNQXAmnSEGNpJiHV/Wz/wnbkUB9qHas0ThFe35CjuBybY8kZMYxzH5KbRtvbNREplvNdecN1TIp4Oziyj8KDN99Xkko5hB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PwpRzFs7; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvWUXoku/V8x/GStLh7Vja7aE0LaV5yE3czlV+YVuE/tCiJRTAzrcWBwAbkO0s+JwsN7C2wsHtye6N5WdKrLCDpfGHy+qj65tpTGWYVzODzBMfemxxY14mJoSspyqf6qc8f8AHMyo4eczk3Z0/aKRq2JW56PZFti65Oc/dGKHbmk5fCL7jQJ0Y/43P8jc717nV5gtiBbRvDZRnjRlkKPwdHMy0HSpN5g7YAZH1RUf11scOkvL4ZRhiCEzLZwc99WvsGj7NuJQ6m7xBJa9yEPvg0ihAdBmGmDqR+Gw2Z8n22FsHAnS93BLvq9N+py+eccMei1nZ969K8ZB1HbOihxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hww26veQwhWBHwE2boXJ5gZejKVoBbnRh9idtz6eCJE=;
 b=OkzP164NdFhhyC+prB/74aeX1nlH9EvsHTSJthAILd5tJqwt3IcuSwxBRm0npk5eduQMRkIUC/vyJuC1IZqyQKIWDq8Y1NFV3BMqE+M+uljdFFM0hFMdOvh660dPlElyeD6NoI+DUnbO/yTkcdup59b/lHkAnHFzG1BaoGnmT7yd6K7DItraP/sI6MtXV08CfcIF8cbJd5h2Zs22Mq0E4L0sQ9SJYqpOscaoWU2h+dXmu1PvO+L8UYhwB1D4gJROqi2p/g10Hgs12+KZnqu95QoZ6JT+RnSLE6b0tRwqtTSyA63pdk4+1bRfDuGUPS7QJknchQUOvmqrUvgrr4HpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hww26veQwhWBHwE2boXJ5gZejKVoBbnRh9idtz6eCJE=;
 b=PwpRzFs7a5WGJLeNAVhZVjBXMgTatOe8OT7lUHM/U6Vs7HPIQ/eIG9Oyhx2JOoiEAdfhiZtG8xHkcfNV1hfp3MoaXVLBpMPGgjNpvS2UeH1R9N1bHBuE5UPMsmePTK8XmJUCVGtlzVeZZ5v5HToYdEcepL9HoTQpKa4SmSH8wjw=
Received: from BYAPR01CA0007.prod.exchangelabs.com (2603:10b6:a02:80::20) by
 DS7PR12MB6191.namprd12.prod.outlook.com (2603:10b6:8:98::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.23; Fri, 31 Jan 2025 01:11:12 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::fb) by BYAPR01CA0007.outlook.office365.com
 (2603:10b6:a02:80::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Fri,
 31 Jan 2025 01:11:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 01:11:12 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Jan
 2025 19:11:10 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v2 2/4] KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
Date: Fri, 31 Jan 2025 01:11:01 +0000
Message-ID: <05ab5f574c8cd9f47c5794bec59bf089b793c833.1738274758.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738274758.git.ashish.kalra@amd.com>
References: <cover.1738274758.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|DS7PR12MB6191:EE_
X-MS-Office365-Filtering-Correlation-Id: b089863a-ecdd-4bee-1cbb-08dd41942700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2RYDUCg3SamGHXdY80ImXTMgeJKp9Q5RqkoSCVUTIYP/OO03Jcr1vRp7E1hi?=
 =?us-ascii?Q?JPAyKmXWMPb2xfVsdqskwDLJm4x27vzEOe9MDSrNyw80mlloNaGkO2HARg+z?=
 =?us-ascii?Q?39NuDL7s9H3WqiwK5FAlgcg5vpnVe7cGnjjIQC/fnYYEDzEWS5NNL1NDsGht?=
 =?us-ascii?Q?p+P36S950dDFJEUNyV7rHOHWuPOjU+Ebk4/hDyJa6hXL/xqYV9Sr+Qn7IR6q?=
 =?us-ascii?Q?Q0MbRDJG1kdWehhiJ2hYRj6n7ANFemwDuQ6Um7Ecb+pqsqQix0GP/gAcloL+?=
 =?us-ascii?Q?k80Y2N6U8eBJWtsLSxX24YldXIbfLiEyqNH42b/B/ngJ8W/dxpPfcPxdmkC/?=
 =?us-ascii?Q?jm6L4DEdTpAevqeqspcCanjuCd/aLwrwT0SLlQF/LHCEitV6hR464ZxB3dhF?=
 =?us-ascii?Q?dtOTiJdTqmKTWw3iPj5U8/wKDWIF5U12o7Sn169DyAtJbsaOXagipf8HsbbA?=
 =?us-ascii?Q?Zsdd7Q5D6SH2QyaJgdswMu+Q3XeJoRYR5Jj6OgJEbyW5WYvj1enpxo0W8YLh?=
 =?us-ascii?Q?EMPQSHwLFOcf8O4oZ18juFomrUcyTJsHcdVWTCC9bL7P+nSP0sossjX98rdX?=
 =?us-ascii?Q?BJaTPjlWNha669tptk+JHoxW0oc4TbTH/p9HmGNT2JJsiif8A+rUn+pOKKdj?=
 =?us-ascii?Q?k/O6hITy1rIB6Xbb2A6zSeUyEFogecrNIy6MLYko1jxqDc5YMefce8VNMt5o?=
 =?us-ascii?Q?RK1PPp/q8U5KbseWUDkTcFzx6odx/Nu9hqWWD2IrS6DY2FKS8LtQKtizgfmE?=
 =?us-ascii?Q?xzBLxH/3YKzdcpCCcTtg22HpVrVyvXTmkk5b4XlLj0E38/uIHTPwBwBsXc0X?=
 =?us-ascii?Q?+qA+c6j6vKPm3b9s+yfMrOcjxoybC3MMsrg6i0TabTFGvfJeDtFLCUKTKad+?=
 =?us-ascii?Q?kdCj5sJ8otpDTLpKS6XLhxFCV9AlAydhlfKBUuwgX4UkaQbscdgqaav1/MMk?=
 =?us-ascii?Q?UxfOUHLpftUyzK03eva5vHV9djNa+/7prsUcmaFJ1vCmCmlltfvNgM5a883B?=
 =?us-ascii?Q?FFYnvruzy+Et1EV2qlIowC6wooW5ax7joNy30sO7PYyl1xoitAkGDvvAvLab?=
 =?us-ascii?Q?lZ/vbEWTZMN4ELFWNGGvTDBKva1Maz2zx8bYqASFa6RBSFe/i9KuOMOUP1C7?=
 =?us-ascii?Q?prHDvsITPaZKjSD67XIAcpVEIJzPrnNbgKiBiSoxytzLcRsUSVKIGFMWQAfH?=
 =?us-ascii?Q?2hrsKiHfuoPFJ5IQ/XMoRwyNBXzYqrF/IgcOy3zpnCi8FynCBnOR0v6n+WE8?=
 =?us-ascii?Q?xM0ZtJ+lQUczXqyBqlubGTyXLcZh/eSIVJA7mBV4hq6TTT6pifuKis40+R6+?=
 =?us-ascii?Q?IRbmXhaODc4vjBMqXUzKUlGoTLHz7F/EesZUU4+JTN3SkrvdRRBg3i3pYJep?=
 =?us-ascii?Q?/iqAaEU6OnXyuwYyaEN3PLUZJpFCbWb4qijcpmAwHQs6pGUYQAOxhfpNbFmD?=
 =?us-ascii?Q?CAi+M2SIhXfM2KQVT8jmRxaZvpA0Z7Vj4JI1ZMwpvmnT3uagbZF7AtbIhBk4?=
 =?us-ascii?Q?MBc/9djZlZpAtoQb56AwZvX3zD5Vhf5UKASP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 01:11:12.0199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b089863a-ecdd-4bee-1cbb-08dd41942700
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6191

From: Sean Christopherson <seanjc@google.com>

The kernel's initcall infrastructure lacks the ability to express
dependencies between initcalls, whereas the modules infrastructure
automatically handles dependencies via symbol loading.  Ensure the
PSP SEV driver is initialized before proceeding in sev_hardware_setup()
if KVM is built-in as the dependency isn't handled by the initcall
infrastructure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a2a794c32050..0dbb25442ec1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
 	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
 		goto out;
 
+	/*
+	 * The kernel's initcall infrastructure lacks the ability to express
+	 * dependencies between initcalls, whereas the modules infrastructure
+	 * automatically handles dependencies via symbol loading.  Ensure the
+	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
+	 * as the dependency isn't handled by the initcall infrastructure.
+	 */
+	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
+		goto out;
+
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
-- 
2.34.1


