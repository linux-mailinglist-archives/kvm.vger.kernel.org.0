Return-Path: <kvm+bounces-21841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B03934D78
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AD83281186
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E12C13C80F;
	Thu, 18 Jul 2024 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SNgYq7WT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3356E54645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307109; cv=fail; b=nXZCuPAJRMeaMl2pzYJltkOQfObPezug+3RQFzyzDPBJq40q/zzMe4FBX6DMBDCp4bB1yLSYbDXDBbjHHmYxlignce0BtKI8lSme7zWQVmU6hJTaE5zIYL1Le67XbFOk2yrjq8324yBytsbDDaja83HwQVdV7otArH3Asd2y8LA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307109; c=relaxed/simple;
	bh=6e9e0dqWEWHP7XjcwNN8NTLZBaVDnZT4XvwI26JhOto=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izqnMHoUJHhaT21UAbn5/rvG3EbGKrdlHcMHllTQVJkaa4C5c0E88jZUITJqxeGqQoRd5tUFAYByJNuJlkAWyHxI/jCJbJBq+rI7pbR6bXPZNvAmLyyermxZAJhC9StSlGxHODpAmZBa1XXUXYgHTVktkDsUKz1yHdvS19q3Ga0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SNgYq7WT; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gn/v77gJL97BO547Evx08ofIGOzY8iBp2BImImvfAoGNgcUZHyoWSK7pyw8Hu7ETctl/DEuAISiuFjgKv4xnQKqjf3F2InyKvB4iUMYN3LEaUh+hbSRJPZyIMLdRQjgl9PL84kJkJb97qve2+FougqsEiF/buIFFhNkBYaHGNSqv2Y5mL2UjX1x3HvSATcblng4vRy6Gwpsy0xul5LEn3NZaudB/r6GdebpFtIJlZBN7CQlwRVVQhlYmHaPe3bd2gB1zOOIzan82C1ZdD1uKs2894pWRptX+kR4NCOvAJ7UiIJp+1F/awtKdV81jvuod+Qeyke86ek/DuDGFolxgxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHK4UsGq5IjuINic5Ek19syTfHbLpKOs2EpVa/GhsSo=;
 b=aVfzhJb07GwUMNn5DgdYcbXTNkwsW4QvHv11M8Am89rTgZePPlWVbCcJOL5lruNlQIU8dhOpMzmyuuMnsXbT2q/+7DTGGt/sqHI5o5Ig/x5bdpPvbWILIjtmjeR43EZvIweKP/9/KKpwOK4bj/rmIBXbi2+g8n++Q2ZY/8veMG47CDS1ooMojINuOKsHWID1yr73e3v2FK0iQJnOiQN2lfMEAQEcs/C9EQ/8eZkO5EGI0gd8LGgD6LD/L4asmJB0v30gh4R1VzOMssGeL4ba72F+ZYoREerbB9NKCqwNEDRNIEJblvS+UdFR6N+P7c+vRuqg/819i3EhfyLORaxA1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHK4UsGq5IjuINic5Ek19syTfHbLpKOs2EpVa/GhsSo=;
 b=SNgYq7WTfy2Dg6SiEWOwbXgNlQr261ENBlX/O3nHXEGw4WN/C50IV7Oep/6eFGZRQxCteuYtWlnfVAlLQ7CTWPKkUic9RGp94Eo9vKJ3qvms1a//6jIedMUMU0CyrMAGoNvfbmIMtVjmInStCecinAyC1vjTQGwlxJNvN8sIOZ4=
Received: from CH2PR18CA0047.namprd18.prod.outlook.com (2603:10b6:610:55::27)
 by CY5PR12MB6552.namprd12.prod.outlook.com (2603:10b6:930:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.15; Thu, 18 Jul
 2024 12:51:44 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:610:55:cafe::96) by CH2PR18CA0047.outlook.office365.com
 (2603:10b6:610:55::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:44 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:51:43 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 10/16] x86: Add support for installing large pages
Date: Thu, 18 Jul 2024 07:49:26 -0500
Message-ID: <20240718124932.114121-11-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|CY5PR12MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: b87e2693-4d76-41df-c39a-08dca72860ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XUpJu9h2lV5CCV4Hmu1M300VZfYVwW6TTvxjQEMnzuzpF2e9RX95poBkPvJ8?=
 =?us-ascii?Q?XoU4JP2NECSbS8CVZwbQVZ6AOF9h/6oqpbra7mOmkrCda1rWFbEtFRBARrU/?=
 =?us-ascii?Q?SK7xzdp73w7CjAfaclWjMiH2MbP83vpleX3jzreMVpxMJod+7wiGQlfuYmAb?=
 =?us-ascii?Q?LNeL5SZfQSi9eTH9QExsYLJGX8y2ulOpCscp37qNBGmz1/IDaDvtGdvfKIxC?=
 =?us-ascii?Q?EFyX/vuIMS+d5cleKT/whNM08pX0p680ze58SzeKo4Dx6oaEr9z/UGhCpQVX?=
 =?us-ascii?Q?jMZd1eAAEOmDpc9XWHplNOPQ0YcWmIcltYN+ziWbboUb4ZxSZNyPyF5JGKMo?=
 =?us-ascii?Q?twECWACHz15CCkC5cAsk9OOE1YQ4mUQByg+Gzfpo8YMbFiK/L1KefQNQz1bw?=
 =?us-ascii?Q?u35O5uD22dhp289PToURY6NPSFitKXePT2VYw4deV+8EncsFcsY+QFZFTzz2?=
 =?us-ascii?Q?i0t3O/pkR7idhY254F14tn7unNzMLQPmI4K6aSGqngM2b4Dp+Djl9SwTumiR?=
 =?us-ascii?Q?2WzJ+ZQ/bpRA2tuo1i8d+q8EB7Ucqs1j+PY6t6sNIFuYl9F0S5IxrznIvw6C?=
 =?us-ascii?Q?OI96cs0XDzs9yGlhKgXtVDMu1WWaIRRBSW/UZjSzEUTAKtE2bjBwessgQ1hf?=
 =?us-ascii?Q?mXIkfFoaIxnkDBimh7xo97JuZvc7FWgozBHQixHr+pwK9sQarKc0RQ5kJJ6E?=
 =?us-ascii?Q?VfKuWIywfCQ43Ai1ylGytSWpALR0Gl0BtwJv0rYCokLxR0x5DSjFMXreBIl3?=
 =?us-ascii?Q?tpelhOfZrAXZPJ1P8BZ5RtsHL94i0/r6o0q8u9ruTVlfKixpOgD/7AJkg6ja?=
 =?us-ascii?Q?HBVtZpq1zw7JBCN3r9Uu0jgC7rVHhiDo4Ue4dOIu4rTXD7O5PebCzz3CyCxZ?=
 =?us-ascii?Q?Yj00jwInS0oROHuB+nPuMja8MVjFKWYZ4NpbFHuzCQFSKjBU6g+OJukLyuHQ?=
 =?us-ascii?Q?zoWyktXoAr+elR5IXtHUE3hdAUFxYG0sbxJip5qb8wwSFEox/JNgTyn3i7Qx?=
 =?us-ascii?Q?iRrFpVXeC0oXQOm2XRX6jvyfGEYTE4j6NyjwohLQBQB2l/tL2WzcAOFdAxsz?=
 =?us-ascii?Q?OPHmzJJlmGaiJCPkELZ25eM7kJq+6wNoSiKTrgY5h8V/i4Gax9tJiTTZrqPh?=
 =?us-ascii?Q?ly+MJfh8W6lRJWrJ+QhAxEPuDiTeSXQKIQO2PfHHUUePenzARC3JY/f9rFmv?=
 =?us-ascii?Q?Y8qVnApLN7bAR+ZAtoPvpHoEYeIkGxcdSPzHRZvgoV5Ye1TQbb0nKOADGYWU?=
 =?us-ascii?Q?qzkyrGA72Prl7Pms986LjLLpZ5UU1EwBXd8pRcaZldmKuj6vsSegqwNT04QW?=
 =?us-ascii?Q?TZMLX6EInEMqQqHHAkOequZBeNfv1ZvNdQXnOyf8unGcFnt7rSoYlkz51Lub?=
 =?us-ascii?Q?x0tcnnjuT0cBCkF3xeD63hkAcG0TlDf2Ub12/2AFmILZxJuQSYy8RsTM/qGw?=
 =?us-ascii?Q?wERKfTYYlhs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:44.1517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b87e2693-4d76-41df-c39a-08dca72860ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6552

Introduce install_large_pages() helper similar to install_pages(), that
is helpful while dealing with more than 1 2M large page mappings. This
helper is useful when running SEV-SNP VMGEXIT PSC tests that deal with
a bunch of 2M pages.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c | 14 ++++++++++++++
 lib/x86/vm.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 078665b2faf4..cfca452bb110 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -128,6 +128,20 @@ void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt)
 	}
 }
 
+void install_large_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt)
+{
+	phys_addr_t max = (u64)len + (u64)phys;
+	assert(phys % LARGE_PAGE_SIZE == 0);
+	assert((uintptr_t)virt % LARGE_PAGE_SIZE == 0);
+	assert(len % LARGE_PAGE_SIZE == 0);
+
+	while (phys + LARGE_PAGE_SIZE <= max) {
+		install_large_page(cr3, phys, virt);
+		phys += LARGE_PAGE_SIZE;
+		virt = (char *)virt + LARGE_PAGE_SIZE;
+	}
+}
+
 bool any_present_pages(pgd_t *cr3, void *virt, size_t len)
 {
 	uintptr_t max = (uintptr_t) virt + len;
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 9f72c267086d..0216ea1f37f9 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -41,6 +41,7 @@ pteval_t *install_pte(pgd_t *cr3,
 
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt);
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt);
+void install_large_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt);
 bool any_present_pages(pgd_t *cr3, void *virt, size_t len);
 void set_pte_opt_mask(void);
 void reset_pte_opt_mask(void);
-- 
2.34.1


