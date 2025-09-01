Return-Path: <kvm+bounces-56402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 169DEB3D893
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72398188E0CC
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843BD21D3E6;
	Mon,  1 Sep 2025 05:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E03KTlsQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A842C2EA;
	Mon,  1 Sep 2025 05:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704020; cv=fail; b=mUEuLVP/CAy3rLa1ut+EVgCZD+JhVaqAMmkXBerNK96u76phJEI0ULmR3zktSz45sLbrB+obL6fQhnZbKFNOqYOfO/TAK10b5/DM3sWMxESh3W+5N6xaKU6ln1HAB3EJAjorboohYPnFj5P0Q4U7h1k+Kb6bh5H/RyVzBbQiyvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704020; c=relaxed/simple;
	bh=qhyrwze2+ehOdro/y3T5e04wPmiLmVuxaebv3HZFsvk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQOOUUus68YOhvapQKtCGDMEQSkuBMCIdh1YNf5UJQ9RtYOQrXrW8BvkZbRR3vHKTMGjWghLZS6fpme/MIjOipYFbbbTmwB7RzXTRUoozBqxIG+G9IvdVXi9CJV2CnCa0XMNnG30HAlfDOD+ZQ8qy5xKcnkeygjOpECTZIKPh9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E03KTlsQ; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cE2V3Jjl9jQpEgvPM+SGCloXMXvljahybCtkcFlmm0z24Qxjbj0VlScIxHQQzzU/lLKT8n8fJpD05GrUu/hoXBhDiUcdqWBtX3HUl52r34lodylUN0Xm4e8Vj4R5d7MOwbW048QahFGKQfb+BDPHcpuHxo9MF58wWDNuo/RBXol/U45P7uL7l00D08laf09AHX3vBVH6/z3ecLXx/v7K2dGd1INLEGw9gjZsIqiK0X6Ouv2k8vWR1yzo3WSCb7+SCvBqnefrM8nuQu8TBrGIbRNKWDfb4cTD7wvQLkYWzYLEvAn/acGXAwGixVfLhXQoQ8sjS1FYWuLMzEHpdENvFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nrcsjjZlxpW48Fxr9WJ66rZ+HMuqY7ViCRpkmOfXYI=;
 b=VLXa4R7Z2jdv9focz05/Z4/t15urt+G6E85n37GzrlSVpxSM2mwWnksbIRUifQR3Ieu1raU58TuQbF+bx4k1R5IJRDPcl3g1FwsflMEE2tF/WgmgHBhIz9ABSCwbnW69wPmWrYI0PpBZAzfVuBRAJNMTtBayecrIVELGO9+ZBI8tUYg1iEhexs+7SxFaU9NnENK+c4qbf6mEeuk1FetlmCKxPQ069nAfWvZQQjaBIH+8VmLJ0FFIrqQKoxbGcacQlY41dkjkQj8/AkXkwb30SvzU2INTQRPyBIvKwXYrSW+ND60L4D/JeaJ/W6rCy+kWGUVSmI0FnPWge3RSuWsMkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nrcsjjZlxpW48Fxr9WJ66rZ+HMuqY7ViCRpkmOfXYI=;
 b=E03KTlsQQXD2w0XYNA9EO1UQQRSWcZl8y1lTviPwidUQs7FqJukMT4g0zP3pm7pY3GRH2x5+3noZaXL81/DLMRfU9maGRvf6nJx0svGvpvx9OklKxjdBOwZcqm7sXvgL7+IC8mwMn2VxEUFBY4bew8DvxKEiF9s2vGdupNSDARE=
Received: from DM6PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:40::15) by
 SJ0PR12MB7083.namprd12.prod.outlook.com (2603:10b6:a03:4ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 05:20:14 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:40:cafe::60) by DM6PR03CA0002.outlook.office365.com
 (2603:10b6:5:40::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:20:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:20:14 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:20:11 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:20:07 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 01/12] perf/amd/ibs: Fix race condition in IBS
Date: Mon, 1 Sep 2025 10:49:53 +0530
Message-ID: <20250901051953.209110-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|SJ0PR12MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fcc3289-cb31-4afb-e358-08dde9173b5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eYHszPIxXm6Rxp67GlbMbzvjkSS+7u+KbItb78MqUv5yDX59ROo3oeUa+kF8?=
 =?us-ascii?Q?vAao9T7TnV0YfVOglL064bH32qXYOaogNzF12551UDZ9+l4gn+Ji7FZeTHfM?=
 =?us-ascii?Q?nKonFCGyjqKORnag+yxeGVU7+a+hMX6Ism4MDgaks6La7PIc34/WhBEDAm18?=
 =?us-ascii?Q?LiWfb4TuwuiwQUrCn8NnvkeAK2Mqizc4jYb33XxsXrbverDL03KlAMhsTdTD?=
 =?us-ascii?Q?4J4wXfPhLtPZeOIAoY9Eu2l5S/M6GkafXCWSeTNL/Yq7B854VC3Vf6WL3Vot?=
 =?us-ascii?Q?ZTphBKglgkqE7c3S9qtpGCdmoT6k5/s3qSGo3QnTHy4rBCLILJg2OuKDofpn?=
 =?us-ascii?Q?syzsUUFuxf0gmqaKB+p6xBnnUeKLUpx37Iqj6TDNOCW6n1G8LBvpZ9/DcrmE?=
 =?us-ascii?Q?XS/1TUjbn83N46Xfa7OroS/0OHCWn+4JwwNOJaFrf5i0Tu3GQHfo4lSzBo5r?=
 =?us-ascii?Q?ME95D0kcOAA1nYQAhrmQEYVTCrX1idtg1z8o7cfvflZ9noNqQkSkc+fktc+5?=
 =?us-ascii?Q?KAur7qW13r/qVs5C+I5Wkd41xX2i50E8OTpm1rvEFfg/xOAbW8JwAQ+N+Zgx?=
 =?us-ascii?Q?RKb6Ut0Tp/Dlk16SVXORo3MFTXcsongMufywDVvSbqGuHWoI0ol9/rcRXPu3?=
 =?us-ascii?Q?dG4CXh08ac+2N5hFL3bkyeIQ4SJjC9cn1FNQ8VKzg3WU2H5VTxXAC/u07BrW?=
 =?us-ascii?Q?4MpEqjnEtV8GA0N7T3btmtOq34GhRYjFXO6PCbud9kYSkahbymUNYOJWnyFs?=
 =?us-ascii?Q?eNnVwheDX1RswQiflEpekRaO2r71QaQGFMvrwmqGuc7klyq4uMWUfIChnONb?=
 =?us-ascii?Q?k6vu34Rsi9qWfTGsvOM0ezPu6yvSXQx7T3c3cpTL5fOzIfr6HTP0RGuuEhS0?=
 =?us-ascii?Q?lsLOUN4wysufz/TrnvL1wT8LObc4zICWvZ8of8NYeFFYg1eIrbqUCuYg4Uau?=
 =?us-ascii?Q?ZgBKtAEFNlBW9Qz2klQS2iQXAuNkN8f6YZHaUEWSeaCUNN2o5ZLLpbqqnm4D?=
 =?us-ascii?Q?JKGA/zdowwM45o40jKoWnycHnNGzNy0YiFz7q6Z6VrR8jQf6DJ+7B+4Hpq4a?=
 =?us-ascii?Q?JKCyhRXrpJjREtSnpHWkLs1GFWcrEmT9RiPTZmeTnYddWdN7AZpB8b/TPwnR?=
 =?us-ascii?Q?NF0HR8UjouRFSSRHyN7nCFDjFJj/cveZJR+JUvAQND/pDBIjCkgB0DEZ+GxH?=
 =?us-ascii?Q?Z8SuaaC08myAoAL+S2oMk9io/0GJncCHg0b/oYCBZMYuw9QIrY1Evm+snZUe?=
 =?us-ascii?Q?F7ME0EEWzipBlKRENPfgesVeadGszjltP1uo1hXDjIEdCeqsgVjuO5Sd3km3?=
 =?us-ascii?Q?pETKJMQiwAuqf4GbsyYTTqipIKrVunc+49DBobJ1PuRkSzG2xjWhv8CExIfi?=
 =?us-ascii?Q?V31K/5p90Sk6jkOVimfBO0H4gV8pbJkTs4F3P2AGs9QDyyHmA91+ZDSbsMP/?=
 =?us-ascii?Q?iZEZXQ60XkAKeShEeGdTONjgtEphf23+SS1y7eeun90MnzFn5gLZ7qdXvOP7?=
 =?us-ascii?Q?0Zovf9QCHXFfKmrP97tfOTs91sVBwhF5cmri?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:20:14.5471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcc3289-cb31-4afb-e358-08dde9173b5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7083

Consider the following scenario,

While scheduling out an IBS event from perf's core scheduling path,
event_sched_out() disables the IBS event by clearing the IBS enable
bit in perf_ibs_disable_event(). However, if a delayed IBS NMI is
delivered after the IBS enable bit is cleared, the IBS NMI handler
may still observe the valid bit set and incorrectly treat the sample
as valid. As a result, it re-enables IBS by setting the enable bit,
even though the event has already been scheduled out.

This leads to a situation where IBS is re-enabled after being
explicitly disabled, which is incorrect. Although this race does not
have visible side effects, it violates the expected behavior of the
perf subsystem.

The race is particularly noticeable when userspace repeatedly disables
and re-enables IBS using PERF_EVENT_IOC_DISABLE and
PERF_EVENT_IOC_ENABLE ioctls in a loop.

Fix this by checking the IBS_STOPPED bit in the IBS NMI handler before
re-enabling the IBS event. If the IBS_STOPPED bit is set, it indicates
that the event is either disabled or in the process of being disabled,
and the NMI handler should not re-enable it.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..67ed9673f1ac 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1385,7 +1385,8 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		}
 		new_config |= period >> 4;
 
-		perf_ibs_enable_event(perf_ibs, hwc, new_config);
+		if (!test_bit(IBS_STOPPING, pcpu->state))
+			perf_ibs_enable_event(perf_ibs, hwc, new_config);
 	}
 
 	perf_event_update_userpage(event);
-- 
2.43.0


