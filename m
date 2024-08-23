Return-Path: <kvm+bounces-24907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C77BC95CDD9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3A01C22C52
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B92417E01E;
	Fri, 23 Aug 2024 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G6fgrBKI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF6187847;
	Fri, 23 Aug 2024 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419811; cv=fail; b=HN39sxkZiLYUvby3L3jIjWpMi34aeiF4ZikUwi7rN1nr5wRAHnSQJVm/u8cr+1Cos7xug2xRPxJmHvUCw6fWEBTdzoxOy+R9a8ngqvSRgIzEo7POgPuw38Qv4h3f3aQi5OHkUropu/rOHFHyG4hY9nXX6cut7/USzmfsWzbuBY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419811; c=relaxed/simple;
	bh=R9ioR8B9BB4/17qbtkx6tm9ky9BaeuRMTsZa68jRNM8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAKB7Zp6AiGM+uX392oWGnrKylL2E4esEIgT6tAlyHTB/zeAF4HF6G10X6v9oJTEGOy8iI51ftgQ1uevq4BdETCFgzJfVwkKqRVGMUkZFrvMifF/ZB/25nZh72woLkY48SpcsPYm/AzTzNZSmRd5gzihJ0DaQ3FEz57vX2Ha+Ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G6fgrBKI; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsQ07gISv6g0br3K/8sW3KgG+cDB/eRwgj1DUwwvIW+MEgnCPYi5BOeasb/mOp1KPT9y17XN89oVLyYPidw/4iDdHSApaN+76NWOHbcS4oog2pn5T3q0xKFo9z9brlxOxE7uCcM8/4ijrs6fuT1kEbwzN8f1F7y12J3T39EE37PXYXmvu2/DcWAt/2D+psji9TqXHdJI6e34T12atk7zlwsvMnHt65CdJeV8sIxJPUbeyHj0Ts5wpsm/izatpwiRNcr6bujPoUEBVu9TMVbTe9M2DOo4bUxoqpPZ8hS/UIuktd9EMq8DEa4oGgokMmKElLekNSR3/j2xunlDXYtKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwePOi7dgaaTP2pqDE08YWPYG7lzNHkBQXyMGa3Pphw=;
 b=b5/GJfEja31ulHnTWte+9HsG6bfSotLbWKU4U1ZpFpCmD8Ajv5xSToFfQgN1ktUGbnbK/tF8AqaaYib6UdRXSOyhQ0UVVUjSHoIq4/BoDOXZKDQu6iZVRT6ild+Up4dIU8ITi7lWzFlFtiuhrTRP/gG0HvBRQYRfCV8IRaOQJPx07GXImM7ZwWSJzGta0/Zzle0/2a14kG0pQuJq09TjTgh3fgH0K6bLrv9A0pN+KsO0G9BytrYMnetpJKyGtC9P4B+C1B9wEXXBD6geDllLLhor6JaQQKHgn9LEgAlstGw3CRZWbp9NN1Qhaubxv21pBr02RyIshXSFx10w/vX4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwePOi7dgaaTP2pqDE08YWPYG7lzNHkBQXyMGa3Pphw=;
 b=G6fgrBKIzCc437ZHydzTfe7XHpK021LAAyBJMr8Piu0n9k2695KDFmTKchEoRZcx6Y6pMSBDvJ0fxo57UWdp/wQ0Z4wFsUsoPzJTb33GnczcZcD74FJe5CJuWJkjeLXzuTnCkXp9yt1I/zeEXxp+RWXK6NC1lnQHmEe5QXMPgrM=
Received: from CH0PR04CA0086.namprd04.prod.outlook.com (2603:10b6:610:74::31)
 by CH3PR12MB8353.namprd12.prod.outlook.com (2603:10b6:610:12c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Fri, 23 Aug
 2024 13:30:01 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::6d) by CH0PR04CA0086.outlook.office365.com
 (2603:10b6:610:74::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:29:58 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:29:53 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 09/21] kvm: Export kvm_vm_set_mem_attributes
Date: Fri, 23 Aug 2024 23:21:23 +1000
Message-ID: <20240823132137.336874-10-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|CH3PR12MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d70f11-ec2b-4cb2-3afe-08dcc377af3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aye2s71+eKKWmX7p1ooVoM2ObEQ4ofjfOFyivT/iyWoABRGpmn62Y+v5xJUX?=
 =?us-ascii?Q?kyfaoynvhR48Uu3nlv+w6sBHJtZhxVkHdZa7ndy0U1qZp4bgUNzd2vsoTO/r?=
 =?us-ascii?Q?w9PMqwt3aToWqMlAc5viyv9wowyEXY7AedfnbH2lR2DDSa6JBRwgmC+LcDU8?=
 =?us-ascii?Q?HN7F94uzaAfW+c7IFalge90YZ8IlYXfXBvzJV54XHNv6rQ7vJe7qgUGVBMYx?=
 =?us-ascii?Q?iS7H3+cFhr53tiXO+3Bqarx4x6V9YpcgaKrJ9qsYXpRQkp9cm+hYq+hwZcF5?=
 =?us-ascii?Q?THqCrrOCMlbc5AcRdOEoy1PtCQmLnVOKhO0drFyFyRTgU/woAdb3y6bajq1a?=
 =?us-ascii?Q?Cuoo4TP7IJlTZYFeQihtTqqxVz8jDk6qSsqYx5iz8LdCHW4YuQCAka+bib+1?=
 =?us-ascii?Q?nH69uBYtU/HdlbCpoKyRpY6Wb21DHWbZpc/ZowcUfutDc6aZWDPl49rIxGHj?=
 =?us-ascii?Q?hdFdNtLWlYyLP9mnwaNhh4GLIVpfScUFIZfgh8Jva/7fu8W1Glw1VyPgG51W?=
 =?us-ascii?Q?QQfAR9sEsLi/pnUTm1HMCOXl40B6Y2INWfruBgw2rFPViw7Sof/AStD2m3C/?=
 =?us-ascii?Q?LctZCTxYTyuXagCF8Tuo1FG/28e5DRTFY0RVu3XazD3PJoXvTS1vZ8ab52D6?=
 =?us-ascii?Q?QawBi28JJQUSDcESh7mvMyAxjUV69aPC9L1qMpzO+/aeP0im0ScdDOsXCi/L?=
 =?us-ascii?Q?yOBXIytfFbX7vCMdjK/g7egkMnNnbW9vqx8uZUsyHwlkWrRt2Mg3B8Sy5AVI?=
 =?us-ascii?Q?7KmouES5HBfexogPRGp9I+puvByORG5IPyfqgF0Jo42y+4YifhAg8bNU+7FQ?=
 =?us-ascii?Q?zO5+IZRU5zUmvaT/HgLUGQr1Yyct6CNScj2hqXszSalNnBnHTZlfbDAmSZYS?=
 =?us-ascii?Q?dcRyrg7As4tibab4QHJ+ujgmpbGOssA1bnmKzxvsvs2BQsKYoB5m+knc2tYr?=
 =?us-ascii?Q?aF0gADvwUYtkWtvm718LYf2faYYJqvpOueHnyMNRE1dN9L4pAAhwgXjaehTD?=
 =?us-ascii?Q?jt0e8MrcEXqLxDDjvSgvJMskH0s60FY5AOy3ijFGJXPwwmawgUAG7p2rw9OD?=
 =?us-ascii?Q?L8Hn6AyMJhjpnNg1TQ71Xyd0yZ4i3kjgvA3VGAhWgWv/IyK7xbIRj4+y/BsD?=
 =?us-ascii?Q?7tuVPdyvjVFWM9mR6K92FraVPF5Hi1yT0Hgx4fktNv+bJaDJo++qwvOqEgMQ?=
 =?us-ascii?Q?JUkI3yxg+A4i0hekaLgsvAaCRQo8lH7THf63TUYaiBeiZTPzCXts2u81aSPW?=
 =?us-ascii?Q?Pmci/TfXVVRsALFnQv9gKSib7G3lHi0HI76hbEdCrC28265NcfKSJHct++rE?=
 =?us-ascii?Q?EPRboM9eDvC7wjK/pwYjnfulqja95wjIvGuycAPXRoXc4Q1Ja4IyYJy/n/lG?=
 =?us-ascii?Q?Qegg/0QTFWUmWJJ8n3e2AJxLsniDAGEBb7zA3fyx64ClSGZQh3Ws+UD6SOo2?=
 =?us-ascii?Q?Mb73TYdPPgSlcvcct1NcH297+BBFj8e9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:29:58.7224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d70f11-ec2b-4cb2-3afe-08dcc377af3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8353

SEV TIO can enable the private flag in an MMIO region in
runtime when validating MMIO upon the guest's request, this
requires updating the KVM memory attributes information.

Export helper to do so.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ca32dbde575..d004d96c2ace 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2429,6 +2429,8 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
+int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+			      unsigned long attributes);
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 975b287474a8..53a993607651 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2508,7 +2508,7 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attributes)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
@@ -2564,6 +2564,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attributes);
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
-- 
2.45.2


