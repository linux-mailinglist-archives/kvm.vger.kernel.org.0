Return-Path: <kvm+bounces-56945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 920F1B46605
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 856855A7242
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7701D30B515;
	Fri,  5 Sep 2025 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oDj+pVOQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144AA3002C1;
	Fri,  5 Sep 2025 21:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108428; cv=fail; b=OF6TkkVl5VN6IwiW2d7WUsTUFdZlY8xRGroOQjY6R86WPlG21zDtVSr9KaU8osxq/V41O5V48YFWwGEViJ23xC7KlIJDcWQzp8+Kbt70MDWAmCxM6Ptk/e82q9k4/21x4D8w4qe1KgeLtkZXeofths3ceLdmN2NDI5zXhFWT4FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108428; c=relaxed/simple;
	bh=h63NpjdlLeMdxnaWgqNeNYkJ8wUD6l6yPiv9JG9b9ek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvnZhxtgzKghauyYV8tDf+314/6Xjm4g09Gi+7ywhFzJCVk2AW+iGOltHNwKcoIlBcn6MIjuGFUUlf3F+9VYvPbAYZWhgivxmqUekyCqa7nR6eTzKpSXPrRExYEqRMUfm4PMWZ1ckz4YxBfqyaMWt4XqkTjiskGHRAVSGI5XxdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oDj+pVOQ; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8PYnibh/ycKfWA0oo/a1VYgdz8dQZkbvk8wuIb0xS2Ec6u/l81E0v+VZzqU81mKkA+AWTiLHSD9F2wV++OtWLnSAFmdWfdPtuCtf1pm8Kwehmut3IeGvcGIA1sRbe2GvM1c/eI4JbgEH74cEtE5j6nCOdCRSa5Djt4E9U+QMELm99PVCsjhAXexsmDUPU5jeHH3EOXMDYDNjT+1Wx2huL/deRr+WB7Ndt9IkfnHi7fM3ceC8YC0ecTNkZBG5uNdTirB9Tg6AQJY42PizkPbeqEYoa9wzZ+bvCIgkhRF1i0BOzSr5qYl35WIOe0/bfH80F0GXHCLB6vSUgwVSfjnmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBp6X4NkpzTyKP1Lg0EZ4Ga8Ilyni2aAKDyZwhOFBWI=;
 b=DPkbSgioAkxwKoN3osSmcbe8TT5nxXMudK+oM65ICH1pZDFOT+edmj3HH9HAbLKwI42IK3VhIflBsTVw3JTqUxsQnnrmt9jkkkyUsb11ZY5ZAI4M/RiDT/1Ev9zKgu48ntvJkJLpxQkTGOyJyNKaaDA6GSYsW8LzVgbXW9C/vl7DsmV2fgEOoh8HBcKdf2XNsjAV8ZSzSFvCrJNEkoTyy2EugGZUAecbe4h3a/tvlJyCEv+gTgaSxlmcfAGZwRJBl90+cf4fWiQ16kkCGhSgsd+6Yva1/v1Pfl8Isgam6Z6RnaoZwKlSNuryhm8qgyd1Ly2Z/3YjCJh74iOtf1xCnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBp6X4NkpzTyKP1Lg0EZ4Ga8Ilyni2aAKDyZwhOFBWI=;
 b=oDj+pVOQ9xowil98I8zufnLH5gwC5lw/OnBEv7CfZOXpB8DqkSenxGqQIMkOPTEyBEoQAfwVLRfTyEjffcTROE/jC+UbqFv2fnBvBE0NGsxunXkG4dYENoyj8d0KRLOc4iMO5rEZhPLpiRFhr5xSyFEEV/O7FkzZgV4bYxsCp10=
Received: from BN9PR03CA0558.namprd03.prod.outlook.com (2603:10b6:408:138::23)
 by IA1PR12MB6410.namprd12.prod.outlook.com (2603:10b6:208:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:40:23 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:138:cafe::5b) by BN9PR03CA0558.outlook.office365.com
 (2603:10b6:408:138::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Fri,
 5 Sep 2025 21:40:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:40:22 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:40:18 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:40:15 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <babu.moger@amd.com>, <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: [PATCH v18 33/33] MAINTAINERS: resctrl: add myself as reviewer
Date: Fri, 5 Sep 2025 16:34:32 -0500
Message-ID: <be18d59ef5458b22ef65fac59d9c2d06eda01d57.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|IA1PR12MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b24626-8f24-46a5-1175-08ddecc4d14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SqcVg33I5XWHSIj7JZrCXQ13UM2R21c1HOkCd7UStjuq3vzMT64KqMpCM6yB?=
 =?us-ascii?Q?IzCWcgMYYq6k0FKnrT3erndzQh+UltJGEBqfk2oDi7Irn7+AyoKQ2Vl1RunT?=
 =?us-ascii?Q?TgXR8LC9CPyBkOMnHUC3w10FlRPRUx7EsTErRPOW+mZKxQ1+vUmYRE/lJ30e?=
 =?us-ascii?Q?JK5xsMDsg3SxtXhm+HmNQdCdIMvGpQWAd3K7nNi8SGZRfsjv9trnD20QaOES?=
 =?us-ascii?Q?UZYpI9ylzbqI4Hs9WMbK6HrLcsu/lFAgn003PMBfTJZmAgZRQOwWK6pItAa5?=
 =?us-ascii?Q?qMicBVUIzOZ20UeaYpOYw3uNPniYEybZHUD7y9rW4Xe95BVO/soMh4W2nTwk?=
 =?us-ascii?Q?psNLqelLBYzb9Qxx8f4laAQuksg+SP6DPw3BpUqEm+IF/IpcPbFe/KUDEkrx?=
 =?us-ascii?Q?BFZjIuTBq71L3/3rTzi8XH7fInK1KFOKnw2hvUHrQV8ZYAHZIeaV0OGMbnsw?=
 =?us-ascii?Q?Mn7xT45AJTLNS62D5ZJT/3pzZZ4mfsrqTG7av0OQ7XDZW5V+8kLglhdk8ZuI?=
 =?us-ascii?Q?pjoF4cFfYPuHTHnrZ8HRJJzvVaiYPYX9Lc3+Zno4qBBqhf0a/ijWLXQWWfln?=
 =?us-ascii?Q?i0kz3RlbZurv0YviBnZixvY82fLS6Jfj6AO64gZ+D7jSDtnMJSvuDnSDSVIo?=
 =?us-ascii?Q?rV6uCLVQOVnu4eicHha5xX3VtVCeYU5lCm/X9iNDOQZH57tnnSirQHylP2fD?=
 =?us-ascii?Q?86uL3p+s0G/0kkoddz9FEsisSX1pPkip/IZ3xhgg55yMcqr22PjOtb0dzpCQ?=
 =?us-ascii?Q?GveuxSCrvLeWWp9nf5/ld7aaHgIkJNPeB+3OEuro7FBAXuJli8ZbHyTVfVPe?=
 =?us-ascii?Q?+fgVyBUERl35+BXkiw7pxXSq3i8Vf8z3qdaM94RN3Sl27HPiPesj00UFw16r?=
 =?us-ascii?Q?5cvFGiR/CJHoHaxKcF+ZsRwr5qMHeuaD36d9FFbbqsJxjv2GJStw9/WrKhHN?=
 =?us-ascii?Q?0f3oyki5x9EUU9b1iCQIeTDJQVlgjEpqJ8hkO+AnhHZxG06+j1zPfLVO9HqN?=
 =?us-ascii?Q?n+eyYaqlz8+CU9+H2frWRb9IFNJ+gtGZuAn/gZi6UeyrFX/6lNX2JbWYigC5?=
 =?us-ascii?Q?2rbZ9kUXjH5WHHHY6fHQdCpXT+WfK/5/qw5FT73mTQZsf3yWy1wxQj+sZIcc?=
 =?us-ascii?Q?3dWJs5MBN/TGeTS2oO7lRgZmyOmkj6vaz+Qaf/BJL+PAENiiGO7goPVgsYHe?=
 =?us-ascii?Q?t3UctdAXMZQTFrTUsO8NQM079dCil0CJv0efzr16b0oIahIP4nERdhOgs0fo?=
 =?us-ascii?Q?N1j7xuQM6ZyG9pyA+bn5ClosSLi1ntSnqSmNPZ4i7v3EUHZmSBb5eIzlUFK0?=
 =?us-ascii?Q?6dqzlxcbR+D9gBojSPU7EM7NyO1NvxxiowFHzT+TnGtHw/dbOCICmB3zly/8?=
 =?us-ascii?Q?n7wVmE+Fr1jOy1WYmPuwQwa4syUS6DQN0QSeNU0m54FVbADNsH5rSsP8HILF?=
 =?us-ascii?Q?ftT9WNmQgDbhyrSWunbqeKfE3Txbq7cxUxi3B7v0jmXkRTkJ0U8qs+8lYv6X?=
 =?us-ascii?Q?DY0zYTiuMx1PnMjg1WqwNuHwwh8b+waSuV6D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:40:22.5360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b24626-8f24-46a5-1175-08ddecc4d14e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6410

I have been contributing to resctrl for sometime now and I would like to
help with code reviews as well.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: Added Acked-by tag.

v16: Reinette suggested to add me as a reviewer. I am glad to help as a reviewer.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ec2586487c9f..d27b0fce1146 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21171,6 +21171,7 @@ M:	Tony Luck <tony.luck@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
 R:	Dave Martin <Dave.Martin@arm.com>
 R:	James Morse <james.morse@arm.com>
+R:	Babu Moger <babu.moger@amd.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/filesystems/resctrl.rst
-- 
2.34.1


