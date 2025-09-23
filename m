Return-Path: <kvm+bounces-58467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A54B944BB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99DF2174EAE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE7F30E0F9;
	Tue, 23 Sep 2025 05:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EOX/xNuq"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E151C84BC;
	Tue, 23 Sep 2025 05:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604103; cv=fail; b=PODKbUT9/iDmPLd9Px/kLdJz0osvFgW5CpBZIUaIqYQCOQ8NIIhqqov5hZsV3KktkHQNG9VmzY2Y1Jg2N/Ti50noE7Ohh6WyA57GhyqtbkUnrQnI6Fzt75HXP+vvfGei/hNUPu5OYpHg0vi6rHZob0Tt2ZRgZ0fuPRglMD4D/Jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604103; c=relaxed/simple;
	bh=vedP0xXpup0kEfAu7yH088lQyqL0H6nPpct8U+yBnb4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyZ9YxmpZjxIUYwofGOiXaifZu8Tk0xpcgCAWbF26J8dKfZaroxkLkoZcxwNl8mOkrfC6Jxj8SF3+IzI5+M/A7GwxIAUZQ6HuxbaNbOaKlSyWtG0QTxDb7SS+gxHsOSCXLvT1YP8isPBHL5L1/bPQdSzWvWnmuh3mjv2sEiF7z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EOX/xNuq; arc=fail smtp.client-ip=52.101.46.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yKsIxdVOodx2s0mhAqZQT2EX0kNV33ruPLEFEVnoOkUvj0Q8/ZFZZacg0Jr7i8YFJkpPQc04khCveG+gMlCDx81vavy+7gID0To9pgWfSa0pypvOyHqkkVPNNR16JRqz//fAvbUCy6/Y4BrXTaLAzTn6jIAC85UTfnAFZnrGoxxRwBSr8ASOexqvO+GDQ18AoOFLC3NNxgHpGjwA6k2+tEJ60ObO9JeTQ2cpOrqVexy+pC1YQ7wt2cEfr4qKyGQ0WkVcrbp2W//m8wDjE6bgPviFfmKCbUO0qoULk3iUbeZg2FbGcBzl/EF7ozAWnuiXLWN9PMf3VOevZaCJ44Pbkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BZx4YjcSyzuwIqdHaqBWddsFs46rgAwX/iqvUjQAKY=;
 b=hgUC8HtFHuytnU5R/JMQ4SzIL0LFyJX/4u1yEr1S7eSjZCzMRFZiS6lBsdRfy3cE5zMrPEodqFog8Kfb/U0mOYzY+bZc+4up3xtkBhzQmfRTySvgs3rnagUdSk6vteBFQ86K8GwaUJb3qn0mys8WwxXHkfGEiycR2glwj6sZwoW4nANLbeoaZDcCRM3oXH8zL3u4Tb8McLMZwPlajFPJL/18TzUpmKcxRbj9nVTfMp0ASyyGD8eibVNootApHR50tGTvQqKhEUctmotY3lAlVuBGIukG6vOqdgkH1G5amEanNi0evaqNOHPWDI4BqFMdQsRGUgHJg26uN1DJa9QVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BZx4YjcSyzuwIqdHaqBWddsFs46rgAwX/iqvUjQAKY=;
 b=EOX/xNuqMTrbscUE7fLRJwAS++0rkQQzrFQWBHAj7HxZj6yk5GvVlhMzHejUvOQ55qjg7KA7zz4HWCK3i0+rvTwCKzLv2NM1Z4SNykO3hffySbhvXIqC8zjKQI/yUtik5mT2J7G/S1bdQurUNO5rxltFJ/Vtd2H0cEjAo++orsc=
Received: from CH3P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::15)
 by LV2PR12MB5821.namprd12.prod.outlook.com (2603:10b6:408:17a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 05:08:18 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::b6) by CH3P220CA0022.outlook.office365.com
 (2603:10b6:610:1e8::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:08:18 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:08:14 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 17/17] KVM: SVM: Advertise Secure AVIC support for SNP guests
Date: Tue, 23 Sep 2025 10:33:17 +0530
Message-ID: <20250923050317.205482-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|LV2PR12MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: ca090d14-752c-4801-790c-08ddfa5f35be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UjXP3lacgaE+RUZHj42NXWKobXehvjx6p+6CbkpVuNYT55j/xr7rl0jSLIgH?=
 =?us-ascii?Q?AY4TG0VF97SiTtRx30cT7lJQLPHICRhCn5wvu3sXx1YG/ZVWC5/EhLseUCqE?=
 =?us-ascii?Q?oLmyeObCRPvA0gvxSdFa42d0eReSz1TdpzQwQk+9rehz/Le2Km2DRBhlB9S9?=
 =?us-ascii?Q?D1k0pQkM2zYuGC5+/NqbPEekJvDcyzR2ho5F7DHpxLw2HJi800/JbFCAsSha?=
 =?us-ascii?Q?yT5+XeAVdL4y0H1PBFp6MH8cceZwRl8TzMyeCGIdJ/0kCfkta8rLqNWZqvgL?=
 =?us-ascii?Q?zuZX0qmb4kh6Ax3lhs35o6jW3S5cUajeyJ66kw1Ii3qZyO/u7peE384QwnMR?=
 =?us-ascii?Q?jmlHQBVavWRVkiWYY8pAP9o64BxpUlYijD3rgdsDvG7KinTnko/KrM/qCJk+?=
 =?us-ascii?Q?+HT5clwZf/ya7urvivf6OtG/b16KZKtEKvj13/H27KXq8uh5cVtJ1vYoKg67?=
 =?us-ascii?Q?k24PxLxvzoAQSd5yzbbAw30Q7XVF+B0NpNocpmDHBIiczli8GKq04UbXeuNq?=
 =?us-ascii?Q?cprWV/kTJa09f6AjKUqfHK8s4VN9Kr9R0dnZtkeYcNDXZ4t5hTnIAi28hbk8?=
 =?us-ascii?Q?exOYuWy3w3/ERsRqeIN588ScdrSPRfwZh1cZTFvP4YNEsDWrqOjQrdpDVJkL?=
 =?us-ascii?Q?mE40F+nKKxl5YWjUYj3O7Ud0yUf1DooAMfcJ5WpkBNxu48jccEc1h3EPvMtT?=
 =?us-ascii?Q?RqCNV9Vo17N84xkWmp0g9exgxPvbh4ztdvfGMfb9ajpdYpRVeUaZ80/G9bmJ?=
 =?us-ascii?Q?ypoh8zJDjq2qEGFvnheSHFZEo7DpSPoyL0gTlrX2YvJbwF4cTry23Z/bA9Db?=
 =?us-ascii?Q?G2JORx8aWCRQXPTOzTIX4ZenL9ogTIgA/kQZl3IsAr3HP3iMPRnhpj12dBCF?=
 =?us-ascii?Q?ByD7aQWW/4q2/44raFfNrK2Qwtj42uLVTD+4xlZ5Qt7uU8WTjnuj1l59E7QS?=
 =?us-ascii?Q?RqY/zMpQoDhOgnE+X2Fb2uC81bK1KNKpxNgE/u0fN9pOS8eFrpOPq4/LhMhj?=
 =?us-ascii?Q?nAFEcw2qYp1J6RqR5UC/QEhGIKzaplqxZtbS0JdnunwmiBz5OSGjc4WticPL?=
 =?us-ascii?Q?q1zRZ4KhTIk0nAwQ+Rd3tqhwrECPDOCfWnGddJFM9+kGgliU1JXWVxz5PQTm?=
 =?us-ascii?Q?FuxoErs8wJUzjw5JMLWX52WeXY4zxVmny2dRkQtilG3pKdahHaC9rdCP12wH?=
 =?us-ascii?Q?1LQ3RvCwdwogTnT15simxAwUJHAzWYmv6h5RLjtV5x6occ8Tm+QrK+zWSHjD?=
 =?us-ascii?Q?U3S7nXHGK08j3XygzuiW7YHieffUBk1d8yWf98y6XHBlLLvSpIkDuj5hLz3h?=
 =?us-ascii?Q?NemaelPzO8QBiHMFP7Zk7OpYuoQU2eY2cGNCWH9MBArMxOhl7/w+EO8acvgH?=
 =?us-ascii?Q?QPlxcsr/I8BpmR+rxUmV+1W1FSxFojdJEJCtJ1z2vJVArpSVvkVKa2EXcf/y?=
 =?us-ascii?Q?RPBJ/BXlKqj6fV5EOFR8HN9nlAZ+Ar+m481pQyMFzSl1yghAiwFs48qFbzck?=
 =?us-ascii?Q?T1+3hpf04SZwxKWUBxcGDuYHAJ4Z0pzlS5Dp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:08:18.6443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca090d14-752c-4801-790c-08ddfa5f35be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5821

The preceding patches have implemented all the necessary KVM
infrastructure to support the Secure AVIC feature for SEV-SNP guests,
including interrupt/NMI injection, IPI virtualization, and EOI handling.

Despite the backend support being complete, KVM does not yet advertise
this capability. As a result, userspace tools cannot create VMs that
utilize this feature.

To enable the feature, add the SVM_SEV_FEAT_SECURE_AVIC flag to the
sev_supported_vmsa_features bitmask. This bitmask communicates
KVM's supported VMSA features to userspace.

This is the final enabling patch in the series, allowing the creation
of Secure AVIC-enabled virtual machines.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f6cf8d5068a..fe3d65c50afd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3092,6 +3092,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_savic_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_AVIC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.34.1


