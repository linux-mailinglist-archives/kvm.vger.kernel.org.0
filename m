Return-Path: <kvm+bounces-13109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88421892617
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DC6C284E21
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 21:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B46A13BC00;
	Fri, 29 Mar 2024 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I0OxUuk5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC3613B2B8
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747820; cv=fail; b=uJHie/BDHTojfwVCUvfbzBZaXj6EO8K+1nLVOEC0S5Se+ck0QvaNHvxyXcRbAixPi8qrK1yDTGDwg5jLj1NCfURqENvWcjbo4F7j6koF+nTOv1ZYrPJ+PeqtNkaDQFL7cOzmhOx4DFs27eU97gmRDM8uSRYy0UcZGhn402+54jI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747820; c=relaxed/simple;
	bh=gK8DGPzYq88zeYTnm4BLo5RO69l2leggmduUCcWn5ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQWjE+eotfUOGt43oJgofy75GlXWxXo4J1FqN4K4HBg1GVxJtNvaSO7omwxgfXDq/HFTk+/1EtSZOra5Rc4lfOAC4AxoGKrsnBZx4Si5E2JYOOxcImtu9Ynik1MHcYbk62ewTZIkdIdFLppaMRQ8DTnTZscmVZaGFfQWJtNRAak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I0OxUuk5; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIzLPiWYYXRS6jZu1/DLGPxxm8GyY8tgfpRT07QYLlG2lcG1NLZ1qPCecdbUWLcNobuoizOzf0s0fzuHrj4DwuXOYZE2Jv3SdMGVOv6DFD0XEeP0Uiv9Zl1zUT+MqYHmot9Vk3Hs49j3b+IFNrjkbC49CzyqhF1K/o3l+OuQRrgFvkD5fb9oUAUDi68hSGbdeDxTVJIbamsY8m2K0WNkFgTWeIYubs+gGWh/j1OLnTHlmi4um1pObKUpn8Df9re/y2rv8tnpsZRJ8o6tsnPXa/HgmMpvA47KXBSxxAbtlNy+Klejmo5Lp3Qh9faipVdabv4ufWOieCIu94tCMX83Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lCLdHSXtJkYud82fzvTsYFf0+WNYAHh8Ljl4KMQ/Uk=;
 b=U6cfLNBe5CnuZH+mpB7z/mf4+cMdcAI3MPEG8HX815I4ZXcaHGXLUh4wQKl7acZ9s8/fO/CymAJ5jkJpOH9/5jdJiDw3X5QsTtA3j3LOBOSjBLhKfyxVaB/YbFDb6X4x+aGGhQMVd00tE2G0XU063+g3mer/+TGgxq7rU65o8w4qFAZmHi/7RlhCzcd+ya9QlnRP9jDdRFxdhWRPlYQJea87XRiWmyA7kEOVBkhXNdNQ9iUE+pPk0NuVzSgRBDLkMVwNhEFcX0PM086xFfKdPhoRs3Fz6a7CTxwmxgIvYeGKWbNXAaBgyxE/EaD0H5ZCXaWaICt7ITzI3c6NLyGtMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lCLdHSXtJkYud82fzvTsYFf0+WNYAHh8Ljl4KMQ/Uk=;
 b=I0OxUuk5bx/pL8E8s0m5wNtPqy8K9sfE73Y/Ocr4sxKzEzGq6+Ech6XZ7pyuaiu7aOYceuuARqi5FU/3vXUPLATfUYKEXH6kdqX0iRIPmHHSPFowfkxxsyXpSYI2CxhO9BYl74QieJlTiN+iB1/XvaV0jRQbNyPEydOR5Jbqam8=
Received: from SJ0PR05CA0003.namprd05.prod.outlook.com (2603:10b6:a03:33b::8)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 21:30:15 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::4) by SJ0PR05CA0003.outlook.office365.com
 (2603:10b6:a03:33b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.16 via Frontend
 Transport; Fri, 29 Mar 2024 21:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 21:30:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 16:30:14 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Matthew
 Wilcox <willy@infradead.org>
Subject: [PATCH gmem 4/6] mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
Date: Fri, 29 Mar 2024 16:24:42 -0500
Message-ID: <20240329212444.395559-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: efbb0557-2739-4477-af96-08dc50376c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v1zGjQ2zkewG9+btQMndrwTMoEiqcqx4husXYADoETD0zdrS3sHPUPBOhZuuBSk26eEsLFPs6wng57p4gnD8s+bwfVScYMWUDNVWOPwmYQ32YRMeBahwRPcD6wo9dbvmVjmqcm5MKSjLiT3NensqbhtTwS2vyPNGBH3PupZBkK8LZdpVoacuCoH589AsDWAuQcVITlpZ5i/B5vlh/iGoTDMmuaG3iKMQfbNGhGDryjZXaLEqX1KTAHnzvT+d7rfeR1OF8F3bHJXWyCE4hDDtezopcf/eu94mkA9LfmmEz8qtf71e9ig+dc8nohXBJ91ASsLAQZrOenSSN+t2Su5UFDK9vdUTNSB9EM/A/O3RyyazHSl3etkPIW5Ge6ooy/GdbIF3toSgFdnuxNKVYHeFRb+DLhWpNdPxhcnLM0I8rEbWbaMjon9paYZqIBG30ezU6hIY5EuLulypQOYGzFPvldm/qLPLwNl3duTXlY/vwFkVaE6Dmbzs93brGA9B9ZZNmgaq67Lta98r9GtD3AjjMOXi0fiLGCzqousXqgS7fz0q6H5VpIoIMcslxz03GHikd3BFqPGYwDbVijynMKYGw2rJ2hBd/MAz/ECnVb7ZDhxiXgxkxj+SA+LkihVPQwbaUAxrhAEsvtX6/uRAtaV769g+vwF8D0EWHDz12VTdmz1s9pwVHoHQkMp9FbFsPGaR/D1UFVUgSX1vhBGbymfSGg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:30:15.3992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efbb0557-2739-4477-af96-08dc50376c9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802

filemap users like guest_memfd may use page cache pages to
allocate/manage memory that is only intended to be accessed by guests
via hardware protections like encryption. Writes to memory of this sort
in common paths like truncation may cause unexpected behavior such
writing garbage instead of zeros when attempting to zero pages, or
worse, triggering hardware protections that are considered fatal as far
as the kernel is concerned.

Introduce a new address_space flag, AS_INACCESSIBLE, and use this
initially to prevent zero'ing of pages during truncation, with the
understanding that it is up to the owner of the mapping to handle this
specially if needed.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Cc: Matthew Wilcox <willy@infradead.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/pagemap.h | 1 +
 mm/truncate.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e8ac0b32f84d..a7c3f43d1d22 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -207,6 +207,7 @@ enum mapping_flags {
 	AS_STABLE_WRITES,	/* must wait for writeback before modifying
 				   folio contents */
 	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
+	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
 };
 
 /**
diff --git a/mm/truncate.c b/mm/truncate.c
index 725b150e47ac..c501338c7ebd 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -233,7 +233,8 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	 * doing a complex calculation here, and then doing the zeroing
 	 * anyway if the page split fails.
 	 */
-	folio_zero_range(folio, offset, length);
+	if (!(folio->mapping->flags & AS_INACCESSIBLE))
+		folio_zero_range(folio, offset, length);
 
 	if (folio_has_private(folio))
 		folio_invalidate(folio, offset, length);
-- 
2.25.1


