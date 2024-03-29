Return-Path: <kvm+bounces-13125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8730089277A
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 129941F267DB
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E807024B21;
	Fri, 29 Mar 2024 23:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H2gFxNoV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2077.outbound.protection.outlook.com [40.107.101.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A9F1E4AF;
	Fri, 29 Mar 2024 23:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753422; cv=fail; b=rMU1NtBwp4Hd6Fxf1U9DDmN5eYb0pU13cFCd8hpAuHVSylf0x/J5MBl/rI7eJmzD0MpwUX8zEMwFrnAIXR2JCPHcu++64mha5isKGpE3UAC2hoSMDIttW4ZWBBdDZ/ZAW3/Aq368Q1cdVXOlygxj8OzoMB4N1lq6tDcRP9/BDJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753422; c=relaxed/simple;
	bh=vIzATd98VzOyuDrm4VbaxOOex0ltOq97UuALYLFKSMg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mDs3C+bhyOUH4sgxC9PTAXnQJchFJS7j/enSqw2gX4plIN6tzosyWuCqxCXihld51McQ7bZPessQwlfiwdlt55jwqy7oJt2Jxn7wrY4XcMkvwZRZi3ZI2VKJ697PZfzEULwqbhY7HtVCmIcNfQA/ONmHyiS+GWz4tJdDvtuSXoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H2gFxNoV; arc=fail smtp.client-ip=40.107.101.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i48fQDEOj/8dRK51Id6S/9o3EAN4xvi9ceeYpAiVnTtH/vr/nfOm6kTSAN98Q3yl/UcQYwbT9kS8GM2Vpz8NbWn7QGR+m3sslwfA9w2subA7mCbYgN0Vp1/euZziurvTcCgMZQWFfMgotzLgMLhgADgnzDy4JMqkuOQ1rrvPpZfJMJR+sUk1ZMEz9kgk0xai5ZTSpaYeefDQqJjg9g3iB/RTnlhyiPJ5gTBaQwUak97KqtSu+T6R4ycWveSlNxZzKvAUf1D8o7KrEVAVGY3/ktbu++jI4QTY+peJ0zU+/KnkOkZl1dI26CZ/xK0v5TqKPIZh93IdzVwnlNXGexVvcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VO3r/bt94cDkKVua2Tq1Z2O2aIdPgDkRUdiMXFLmR0=;
 b=Rq9VbMVRX6DcAXV9TB4jwbQeqLksEIvNX6LBDY9DQiVFKm6zApH/jHR1IaouPxHBBtbh+zTKwoRgH/Y7vLxvdNS3UlxqRKH7ZeG2SCTC1s8/2LPPuZAyVUCk3lTF/u14GLZObWQ67vEf3n6tQ4TnZjTNmerIfMVZXPm6GNHfR2Bi2j7YEUSkutZQTg7DnNEJpNuaZxkp90o++qg2oZvBtWEUkHQPcdEqC6vc3H3ASjexG94uhVXKSgtZSmkZ0TVBxJcsTeo6jEC32b7dbhaFJpnySzpE0CCjPcdx4ocXZhw8PVz9skc0seiPb4qo6OM20eOIc5a/zXfkTobtzS6dnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VO3r/bt94cDkKVua2Tq1Z2O2aIdPgDkRUdiMXFLmR0=;
 b=H2gFxNoVIxwjkJN7sQXk/PK9L966wrvFDltDQniz7yrOpreX3E4ARTCwza7dEH6UXFwyhLzUFhJoE5bKERR7l1g7+e/2+uUQnhB7N6mRNmdpKPlQgxf5WXPhaR9TuR+dUqA69reTu4HOotfQAS+ojwKV4JtIdfiPyMahA1Tf0XE=
Received: from BYAPR01CA0023.prod.exchangelabs.com (2603:10b6:a02:80::36) by
 SJ0PR12MB8166.namprd12.prod.outlook.com (2603:10b6:a03:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:03:35 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::6d) by BYAPR01CA0023.outlook.office365.com
 (2603:10b6:a02:80::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Fri, 29 Mar 2024 23:03:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:03:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:03:33 -0500
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
Subject: [PATCH v12 01/29] [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
Date: Fri, 29 Mar 2024 17:58:07 -0500
Message-ID: <20240329225835.400662-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dd7663f-2221-4834-b1fa-08dc50447622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q1a44oEoclQyLltv0DghRv6UzX4yPmzDJy0E4V5q0enbPY/0LMEmlJN0FmiTXORQywgLi2R1bI9DEBzwuKEXeIeA7bXthjq4XAbeN8Bpi2nlwQLyJT7BfGjqIWUvw47GMggx8J/y2TqEBXkmE8Em4kLr6zR+C3VuZlVkcNThXlFEaP3TxEg8N07Y+ww/1Hvt6piwMdCe9MvOIKcq6THrfoFwpLiat5lFRfiw2DLeQ6vVRSWJyC2pVxFb0OqnP8FOZ/zMl+GEAbLevzVJFdYL90guxKFXj5uDaZs+rw4Ftrbp6PiUXyj0lnW+cwg08yURA2eo/Dyas1CVhJRICBtTcU/1pJXVn7Ons2Eg2ZlmkBlZFqTzB4rj8CZ3JPEd+NCDBXDMt5mIZPqZlNth3rVwgX4GX+7HtXPMqG0P5A5FfTrfcqVhJXTGpLJVjHrVi3J//Nq/oD3LeVGY4blDSKHeDvEpDTqAPtJx+Ms7s8LumsUGXNsDzx+3Qx3/UWZI7IkvdY0f/KNAU8AlvmuIlwcCzWQ+GCjlCxAYGdSsZrzX4WdyGmOFKjBebFKcLPOdofAo4EXxon4eJBdb4AIGVUWRbzeH2/14dBKeEwBBqYSgv4NMmLbYqHH+14bjErKF48aqdg9JYIJtIkvdEAz8bUI1XjcxmgZbHNNBmgDGYWoEudHDU/6n/snU63VWuq3UZ0DPIqm4cG7KLlm4Q9/S/YBzFVZZmkoH9F7zO3KA2fTuSG6PwhpJEG3Z4VRonTQsDD5E
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:34.8657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd7663f-2221-4834-b1fa-08dc50447622
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The functionality to load SEV-SNP guests by the host will soon rely on
cc_platform* helpers because the cpu_feature* API with the early
patching is insufficient when SNP support needs to be disabled late.

Therefore, pull that functionality in.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8c3032a96caf..6a76ba7b6bac 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -122,6 +122,7 @@ config KVM_AMD_SEV
 	bool "AMD Secure Encrypted Virtualization (SEV) support"
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	select ARCH_HAS_CC_PLATFORM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


