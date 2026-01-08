Return-Path: <kvm+bounces-67487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1F5D06600
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:51:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D896530424A7
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C0433D503;
	Thu,  8 Jan 2026 21:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bLhPHEXH"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1B309F01;
	Thu,  8 Jan 2026 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908959; cv=fail; b=CYcrv2c3NOiwp6BKJ9xfe9NMnecfzkK2LRa7PtV0I3jJRjGOsoO0LMwz9Jb2QxLuX9bdTSbtXXI39CkhjvdzYDq8pwhRima1B4ispago/vq01PrwldkdIfHbzHEaJZs0Ih32bx+hYhN+Wcm+RJCx6Y1YFxzrA3E6ljrdLLlKk08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908959; c=relaxed/simple;
	bh=bywQ/dX7PnhrWBRLxfBoUCe/OEwEgXhZS8RgL/oulvI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4H41Zn/PVu1wqprywcO7UaJDzfx6H4s/a4UPO+tfzQlSFv26crp/iLhqKY3F6j9qV59BRlu6hCoARA4bHZmsRdp2aPNkLnSr3MtshbPzWX2s9xfqAALcbyFwfdGxkbgK05gjzRbMgwC0WznB8q7iVwRp4PwNAW+XP2rJr8KDS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bLhPHEXH; arc=fail smtp.client-ip=40.93.201.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jfp0zrjilAdDAIjErmI76Fh8+wewZ69qbfp05xZVPUco7E8o6O8VFAunTYC67L4qh+i5jbISyowLgkU5z/gqgq3183eXY1yTYDqDHf6r6HM74KWI9SXZvAgD+wvO+axMuYBvRalSNtgtjMvvLrm6QVhjfTeFvRsDCfjiPZh6KADtcsu36bVmahIdjaGIEdOagNUhJisbKFeoZTJ8/uvg6h5+qO2+q8QiXWwlAeVsBPb4Sd1qs3opgB1PO693cfs6LPHkdMFFzVWqGdHU+F290Lb0Kc2YQTKiXk1Xt5zTUiWgZmCR1uuUlwN4Ulj11bt75VTQ19+ZwqOqavW0U1Pg2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Do7blpdofxmBRztyFxHIbaBEcAd5x5mLEZFtrUzNUU=;
 b=UyFZ6701K8ZOOivjFPyNq4XMz9Hjkwukc10ajusAwnM4GN+GsgtuP+Olt2h4pKEwGuFnNfjXZX2kmcYQ3EpKmGVh+yMDxkwR0kupaCD5X1/zI8PJ8wCHzqRJeledDwElCoWjnNw9wLfBWLfK10jUe5Av1tTusi9NoRuCBzqWxfm3ruFre7MGaQ/U2GnwyUIRHDpEaeA6LWw+dghmLhkpdyxXKi1YsUONYa9vQT0lnyA9UXo9xRu5ORIedO40D6AYZr2hD+SOgOCW+6FkNJF7y/GUTCaA+Xo9hf5MRdnr3QQ4FffFkCf6bzUJGeAgQJf8gKyNeX7VgNq9Rn9XI7N2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Do7blpdofxmBRztyFxHIbaBEcAd5x5mLEZFtrUzNUU=;
 b=bLhPHEXHlfks+A/PRo3KtpEYp3YkPTny76oqspUyUr7md8WHoc8zRFswWGYfjSFIYEKDiPFPf7f/0l0Fz94c/ZJ+vPEJb7GfGPTaA4OtE8DZSt2bYVNGf1viMyKvSzSxKCExDVAgmjEwIMYXF07PZd45zyNVBVSGEF8fwVzfvSA=
Received: from BYAPR11CA0049.namprd11.prod.outlook.com (2603:10b6:a03:80::26)
 by CY5PR12MB6527.namprd12.prod.outlook.com (2603:10b6:930:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 21:49:14 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::f8) by BYAPR11CA0049.outlook.office365.com
 (2603:10b6:a03:80::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:49:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:49:13 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:49:13 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
Date: Thu, 8 Jan 2026 15:46:21 -0600
Message-ID: <20260108214622.1084057-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|CY5PR12MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd0a2fc-a0f0-4893-187b-08de4effc39e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8uhymynXgKjpXNtk/jOd+t9ItQfYAvCdyrzw9nmrqRsJTozIxCtEuSV6cTIV?=
 =?us-ascii?Q?/omdwjK4VVwMdOmSB2AnXmKFpq+PbfqTRahBqAyO4BLEaAwSSlrWlAjMGyHN?=
 =?us-ascii?Q?fk9L3leHCWl/59KxOsNIaY+j7OmBi+fzAZlPsTu3jfsjzu+/hdOQmwvPwX/0?=
 =?us-ascii?Q?H/VhcEpGW9nMgxE2IjEyehg+IwMetYPjvX4ZQ9FG8dgGbdEXLIVh7bQoEzAB?=
 =?us-ascii?Q?FIpWEqRimCMfgtPG4ROCMYA9xMi7tERa/alZ1+T79mOOVL9JgE+cSPy652U2?=
 =?us-ascii?Q?9J8elJRocMgV8a0NwnN8iCwYCg7FteLwzGFGESHtFWsrj5tgldQZtVGOBkn7?=
 =?us-ascii?Q?15biad81zCy6KvruRhl+NiZMbJWQAr9ODjeHc1oMlgFvu76qq2eTQWW1oG49?=
 =?us-ascii?Q?clilWOlS8qqIelpMuotcKt7c3fZB5Al+r5+joebmETMskk43pxSb6iHDvNfG?=
 =?us-ascii?Q?kN94S5lnm1AIdTcuPbI889fWfVslPDXgiBNIY4HUwNHfVYPlYYzFP7Nh6fP5?=
 =?us-ascii?Q?D6Hq3LTGHVeHBBSOJE6DWuTRiLiYW/zvFBXVX/Y9OVAVhSosmR0o1pBm9hyW?=
 =?us-ascii?Q?SfAG3V3a9ifyeBkdnVO4eaTdY9V/NzYeEtNR6hl4mspHrQ/0BYOyeJzdWHiL?=
 =?us-ascii?Q?N9juUKiRuWrQptMDyGCYFIDyPdxpEDWjopNsPjuQ9isKoiX0zUl5M0kiczjP?=
 =?us-ascii?Q?X6NP06BeiX6m+48cwqyDkJ3uUshLe8N8ygStQbrx95YfgpKJ7vDjCVZEaTE4?=
 =?us-ascii?Q?t9hiH9ieTl6KbI52s7lB2E/+iNkWLhg/BmYplgUR21q/J9CXCpgoNZl5EGf7?=
 =?us-ascii?Q?S9Rn8H10gAer89LJabgdxIoWAveeiPsTmhj7htx0arGTP0+fauQyXlFOLJEm?=
 =?us-ascii?Q?UjxWOr5RWvnQF6uzjEM/V3Mi8lu8lhJKwlQZTrOF4dMZgjBsCbZZ+GtIrGCw?=
 =?us-ascii?Q?koe4A5KZ/pYZtzSaSzZ6l1uqXTZTfGEC6/lprYJ2wyNuGdKdKD8dctTx7PSu?=
 =?us-ascii?Q?PkpTLg4ISIYu5MiJWhdwwOGQ4+fTcaMmpMrpUpGH02dfrG8U6pDcixRZTYqN?=
 =?us-ascii?Q?23vf86R3cQ1/EsRVSubDKWtCKW9FxEcNo2G8PD9f4gqhjFJFEJ+QT3NzJf1S?=
 =?us-ascii?Q?8L0u69t7RK+DEQFWYZjUXZcA3gzTYw5S8XOsYo7v1bVy6Rw0qsU53mYtvBmY?=
 =?us-ascii?Q?KxUlerf45wyW5RNEnjtNXzdn8WyYY8T4o5RRABvJo4FlZWTw2JU5CkWA0T6Z?=
 =?us-ascii?Q?KeslCnEVTqOZ66pjgBU1yotQxYEvf6RwhZLsUIcVlVhN5wEQ+LcP8GZHdoP1?=
 =?us-ascii?Q?pWRuzmOYrmVdncHIRInpTYCjnlDO3lVrbLOnsRJXRc9x/0tEkvo1SPRi+W2S?=
 =?us-ascii?Q?MkdruL+yHhYQJSoXZJ7/ySWpdiPZ2pvPoVBD5HNSqN7amr09obaCut1VcOKW?=
 =?us-ascii?Q?Z4SOsu0HhHXSmGXvSesO3M/FAmajz2/2PUms4mJ/JcKj8R3fvvlCOh1bbT6i?=
 =?us-ascii?Q?cS0+1rygpuVEgT6h1hyruPUotkS4ltKHeanHE0xz6VUogI7HHw8+TaBD0cz3?=
 =?us-ascii?Q?vVm9k5sSaZ596xByqSk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:49:13.7384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd0a2fc-a0f0-4893-187b-08de4effc39e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6527

Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
go ahead and document this as a requirement. This is in preparation for
enforcing page-aligned @source_addr for all architectures in
guest_memfd.

Reviewed-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..6a222e9d0954 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
 :Returns: 0 on success, <0 on error
 
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
-provided data from @source_addr.
+provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
-- 
2.25.1


