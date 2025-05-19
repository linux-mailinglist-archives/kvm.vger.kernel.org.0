Return-Path: <kvm+bounces-47053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7E4ABCBCD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 913194A5B0B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B1E23BF9F;
	Mon, 19 May 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bnqwg33t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B323BD04;
	Mon, 19 May 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699007; cv=fail; b=Dz6K06N7trz2ogdhZYUw40srZhzx4h+t/mpSQDKzkUD+N13h5Ptt7efE5rng4QGnVvjkAsdLRlQBam3JHhoZ1fJmssjfUne0UkBspJW0VJCSJMoXvPVr4boNxO7Iel8/kD1xIYQ6QqHdvaotV6x5IAOObH8wfnVaU6FUONksP+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699007; c=relaxed/simple;
	bh=iuvp7QQTCzbzbu2ifNUJ1n7IhP2Pi92rStx7EM4kNoU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODuhGs4T2/ZkhkqdIKbdq0KER8GaPoUA7URG61VxDYGpVI3/sH42g3dG+4FONt3p18JO93RjksSkXZgJeKhFfMGajsRehqFlpv7GIm54Z0I1r5itreho/cp4/4GPF6yFiO9rmqxJ8KrJ8iLaLfJ9O7Eau9A4XDF75jgMR6lcEv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bnqwg33t; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLvqtapEp84PoH4EoKFRRDz9/5dWbXY+gBBU/7VNxx5bJUGdRtVScoGtS5mzkef3OAvmcSgD0owop7ntFZ/mOqGbdOVZiPnHUxkQmOYh4JUU6dEfjBL7KKSX3urP+5YM1pZ7nGS1QrX5b5Qw8W2NBZqBK2ka81FEFro+N4ufKqfMHcJVWv43H9LBiTYNu0MAmss3rZx8Adv6KVvbrFI5DaeCbP1+hF6xAVLQe9spFd7YcSXXIXsfAJBHu3EkoWG/Q52sND6ImyZgVdbCCXTTh0jTAGXAsI4CJ4T5dRQJ8r+20Qaf3gxhIqLsH1ngMNixBTzp/12hgv0yiLKVnjU88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYvwT5PreAuiHG1s1zbDu9qyWoPPUxadVhJp/06e0Vg=;
 b=TEjqOp2ydRX3EzP8B7QITYuc63AKCKWMY1nA85yMoEW6zm/OdkkWsqUSgYykDPlNbsqmE+92xLOsKjl5hQAzD5O+gVJP8WPi3Dxx6g+T1k+egm4LLsDEZkPGVtaoJdwWPgr1A+YljFdiwJOYtSm7wjanwzFXipwd3G2/rnebnuHfe/3LVcwwHFZjcpg4x4YFKcON2s6wQQ5d3W+SuZ8fIGjB36pQjdsIjTbKh7r7mXMu0NW9ShB2w+Eb9v8aMteWiLeor5Qoqbmglzho73uhMnlW5zYzYu0yQszQYJffEiFnV2XtGlTSpw9UjdH44oWyJhmzFJHt/7xIsMFPYSjGIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYvwT5PreAuiHG1s1zbDu9qyWoPPUxadVhJp/06e0Vg=;
 b=bnqwg33tAdx7DXbLwVx3af7dmVBjVDSEydeVgspmc8XoakOOEN00+SIOCKyO3zoIfBiHD4LEs2yMj7/QNFSkIIxGHxw/UOk1Qj6OrTeff162htRZXwe5OvIQExE/1eQJQDIgt9bwPF03er3vIC9nXhp/RhgZbpSVDer68cva5e4=
Received: from BYAPR06CA0018.namprd06.prod.outlook.com (2603:10b6:a03:d4::31)
 by IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 23:56:38 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::f6) by BYAPR06CA0018.outlook.office365.com
 (2603:10b6:a03:d4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.25 via Frontend Transport; Mon,
 19 May 2025 23:56:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Mon, 19 May 2025 23:56:38 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 18:56:36 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v4 1/5] crypto: ccp: New bit-field definitions for SNP_PLATFORM_STATUS command
Date: Mon, 19 May 2025 23:56:27 +0000
Message-ID: <5f4bb8f321c57cddd06f4205ee3cbf6bde0b3915.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1747696092.git.ashish.kalra@amd.com>
References: <cover.1747696092.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c34f7e-76dd-4d96-1912-08dd9730cb4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?psOTe2qaud0GqXPdD2EBA6ZXjNCHV2u3YhD9Apmqxmb5V/SNC2GZ/nJNPtKw?=
 =?us-ascii?Q?H+sWu3mB+rw93+IK/ZM04Li+rR9uWrnfForeKL25ebbPtT1MI5XkWgwJGgBy?=
 =?us-ascii?Q?56uHyJkQMzLikRTgOt6k+nvM5wnMvrQnsNJB3joOMvMy4TjqpdDRYPVCdvyx?=
 =?us-ascii?Q?i8hQWOlEH0h9iWYPcZ5ygwCf5S8gMhQGQdaIs4YllDrejeg8jFH7fwlfXf51?=
 =?us-ascii?Q?cIBnmbly2QhGXbGdGCdr5L8FvGZ0RCrkBHU18OmtsLH0mrMLHJrlYDLltqSF?=
 =?us-ascii?Q?ekVFfdYJXkzieBsuJ0Uk6HSh1Pio/YXO7oUHGBK7Ks50EqY20mhUk2EAnQT3?=
 =?us-ascii?Q?nuGF9mgbXBY9/pqZSjbkiWbkfTdV/o9SuRbTZbbBk94xfVAQtoYpOpssNrvx?=
 =?us-ascii?Q?rQtAVPcoL6OobAKfVaYzn0oPfqmuoIhQF94fwDsqvVdcqfJlRYnjusyMtt1I?=
 =?us-ascii?Q?JTMnfVt+qsdmd/RNbXR1BBVykcTAnLs4gZDyEIcqdl+iP4eXdHrtAnFDAATl?=
 =?us-ascii?Q?QHBJXWQogz0Jw6fvtCVU01XawsNpUPQeB//kPZkjaUaXzVlZanQN5mAftYmM?=
 =?us-ascii?Q?hvFJuB9CuFrXPNb0XMkfwb2kQ2BsFUGnmKL3RNtIB71rZpCQK5XlZnRDeNsr?=
 =?us-ascii?Q?m9TZB5YPnLsC2mNBUhN6hgri6CUSCCY/XxWK72o/bkMO515h4ke2sZa08tSj?=
 =?us-ascii?Q?Bw1GmomBHT8/FCmzh9OHp8vg5MotB3dku2NXkkd8zxtZf54siM0fHExkGpXz?=
 =?us-ascii?Q?Blcnm5FU+wSCYC2eG/ytqY+21TosOtwnJGgXGDlXL8q9JZuWwSrTohWqmhCg?=
 =?us-ascii?Q?mCPhgj2egyr3K8CRS918RqXs0r7ZOzuc23xWh9vjJ826FgFCJdYYLTfVhBn9?=
 =?us-ascii?Q?J4VSCSXadN+BC5iWJ6g/C0ZfMKUsGq2aE+ey7dgyHeZ7uqRIfbDqToqRZrtq?=
 =?us-ascii?Q?liAbQWjcQzyCOYu0y+ji9tPKmN4MGaADDd/KU3qn7/WyCp+AnJDZtkTaiPLY?=
 =?us-ascii?Q?zhhiT1tHWmh2T4gfnbKveMuRKIEIAemGGaC0pTq0ltMVc/sH36739ogTPWkK?=
 =?us-ascii?Q?e/eNLOCe+PYsldsOcfCrnl0HiICkoNnj0g9FrgGD5c/hOdPov4+RysHRjZ8w?=
 =?us-ascii?Q?xPnVmlp4FSOlBgtQvTXXE5rdBAeyansDDsx2K2mFwQQKi77HLackZg28HVQT?=
 =?us-ascii?Q?YbyLt2QvSLtiXVdfhrf4Fh/9W4seq6CxzfNIvQ9OQezIDqP1jNBTUuIxUf61?=
 =?us-ascii?Q?lkvLivu00QBOYV3xk39pFaatc5DmlUIvbPPdPLIfkQACIo0zJYhz7ExbJ9gX?=
 =?us-ascii?Q?eVvWBsbid2Xu0nSOUHkNyoBtJ0NGc439kBfxOGo33ftJcMDhZYW8DWMni1Xs?=
 =?us-ascii?Q?miEzT13f1AQOu/Wqd0vxfKDHntcPRytTLgPCYkTXEkl4Y5n2t0C03mAyXvOR?=
 =?us-ascii?Q?ABtKRcllLDUK3bHkXzKMLwmJNw2IsDz9tb1JGZrDxmPKgcru24a5c3JleOBt?=
 =?us-ascii?Q?cdGmnTPacuUhxj5Jj8Ud4ir5xmi5RzM3m05Y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 23:56:38.0073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c34f7e-76dd-4d96-1912-08dd9730cb4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325

From: Ashish Kalra <ashish.kalra@amd.com>

Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
such as new capabilities like SNP_FEATURE_INFO command availability,
ciphertext hiding enabled and capability.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/uapi/linux/psp-sev.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index eeb20dfb1fda..c2fd324623c4 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -185,6 +185,10 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: whether SNP_FEATURE_INFO command is available
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -200,7 +204,11 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rapl_dis:1;		/* Out */
+	__u32 ciphertext_hiding_cap:1;	/* Out */
+	__u32 ciphertext_hiding_en:1;	/* Out */
+	__u32 rsvd1:25;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
-- 
2.34.1


