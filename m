Return-Path: <kvm+bounces-59841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E6ABD002D
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 09:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 933383B69B8
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 07:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7983721FF47;
	Sun, 12 Oct 2025 07:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iRmnX57i"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2711A5BA2;
	Sun, 12 Oct 2025 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760253389; cv=fail; b=UlvhM8IWH27x3goAydLw+wUpFkRIWO5DVknwnpPJvaSDdiEPAw/LeXUutGUrXrgjd9owv/aZO967iBJ57K6orkCrWxMXhtPUZqUNhZ/68uUGkl7Y+LPVmhssO58ALFC1E+sOeuBlG9h5MatSehksmWbZtpIXrG+o6f20hHqOca8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760253389; c=relaxed/simple;
	bh=yGRXxVcCzwNnu4I0wpWDu+e4VGWbxWx2xxa8wbVHYhA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mLgsYdOLq+0+6IHD1pnGjBUlB8536sCnMwOeLfwFfN5lc6QZUIEM9id19pBFi12FT9UHTFc4tzeVNJZQ7Yc4qMfqPfU7Nw+FjzT0mbbj0Who4wnkRhWdDelsrS4tDROEH8+4dyduhNlZodGEy8OchSGmKqnur5oQlOnj6Qx08ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iRmnX57i; arc=fail smtp.client-ip=40.107.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhGPzrvR+L1hoQJ3hHUYYaHsoD0FjfxLZ8Nu43fHBLx09JK5k3q3tg66nLQUh15/rNZ5pOvokqUj12LGplYDKWZKhCtflNkIult8OFd4WZyMJBe2+lpLXCzrFfBJqhkE1trZVEm6RvRYSjripz2kvAvpduC17i6qsA/tmLh2LdEdR33xR9G/uRVGUTSHaSktAuf0gXfwDAETgtNTJq3x4Kuu/kxxtfvSqmy39yJtZyXhxj0X4pvqTQ/Q3kE4d/DM3pOhJOXYnCpKNjdwaB6jLCAkfLWBJs9tbCwOrxEzo08/uy/47N/Ymj+9aTiv53ztMULDp9h79Ayfwi+XVcGamQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRs3XYJOYEDTeSMCyd7+htsKQ5oP0VOs+Cun73uka2E=;
 b=I7dxl1khXN+iAy57BZGUBtqrqeAdRJJVuqo5wouPUCunCWLsirzJSt4ln6gOFYbiiPh/goHibqITcvvpFP6pKTl1h2UuYueXZT/PbKTvpfOiK4Fp8QE/RnmpXNy2Zf2GGYlr+XqbGmJXg4lGZpIMFsRRljJAAbrE7rV69YJvlk0GGmkv6zUZySEZGgEZrjJbE5GaBOw5h5DO3Jk96/i0PCkcqthronXscv+i59k+d6/QS1xQv6HGIFgbYByNFSphGrdAFlAZ/L0iknvnM7PuJpgEp+aBkdVQbn/f6A5+seO74FnJcqg1YhTUD2QC38lKwOSanUXrtZhGk28hyaVNNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRs3XYJOYEDTeSMCyd7+htsKQ5oP0VOs+Cun73uka2E=;
 b=iRmnX57i5tyZWxr3X5vAW5ICCq0FkNnixyHpOCa/c2JVPEb/oAu3mnNCJVUKLV6dKWmdg2GYiNLKvwOnOklbJOG4mvp3XcmfB10oD88oLt6Nv8bp0sA0q8QvWNuksxRyd5HBFDYIdPgmVrdeQcrsy/t0ZuByDHc+fpLnloskOOQ=
Received: from BN8PR12CA0017.namprd12.prod.outlook.com (2603:10b6:408:60::30)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Sun, 12 Oct
 2025 07:16:23 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::88) by BN8PR12CA0017.outlook.office365.com
 (2603:10b6:408:60::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Sun,
 12 Oct 2025 07:16:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Sun, 12 Oct 2025 07:16:23 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 00:16:20 -0700
From: Shivank Garg <shivankg@amd.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <david@redhat.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
Date: Sun, 12 Oct 2025 07:16:06 +0000
Message-ID: <20251012071607.17646-1-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|SA0PR12MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: e3622320-e0c1-467a-36bf-08de095f3fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kiAfSyqoVBkWhvanJcUeYL/DPXf8IA4FuEprlzRDwH52Y23FguO1Na3jSDuD?=
 =?us-ascii?Q?0XMLHrtdZKtchJffZAsPC7n5CvBaK78viDljgPygVpHbyhUhQ9UCbEVB3ORO?=
 =?us-ascii?Q?jr611+pCGz1NtVrxnSNmUooUw88yDxzeVn1utMQl2sYsvCgDoOcicsgt3Ap4?=
 =?us-ascii?Q?Vh2tjb4HuQaaF71JMyiFEJ2EjGkCuy1EHu/jRQJPw5n7cy9pfsI4J2GiJ7ej?=
 =?us-ascii?Q?OjDuSrpPpMWp76g8tWVYQ7TyYX6RvXJdyBTrSeKfBdM5/Asa05EVlRKE5bkU?=
 =?us-ascii?Q?Q8ZX3gygR9+p/2Pmo7u3pjnc1YpLjl1wdFzTm5TKBzBbSUEtmTSXkUUjNbOR?=
 =?us-ascii?Q?0HebjmdpSLqOs8/i2c2Wyx3bZqJilO5EQMLpjzt7y6OBDXrOKQdv3782TstR?=
 =?us-ascii?Q?9vi5KZfGEx5zKRGBkScGVd+s6vOmPyfgHOFT/xGqD80AaSAFirCOZto220o7?=
 =?us-ascii?Q?S9VXCgPCdhLLqz2fmncr0ArfeFMxylL9iC6yosBTRJUrrhkTJwGNkGhVXgcf?=
 =?us-ascii?Q?3T7ky/+o2yJFzfeegnhgzXDcY6Wbvqv0Omw9a3EwQK8K06IB3Dawi//NQ4q1?=
 =?us-ascii?Q?NILCxEzmiP/QgnULImIm+afCSdfa4PMEZF0ndo+BenkVLgRiP4HGjtOylixd?=
 =?us-ascii?Q?Lbv1wiuLYindysv5cm0wtW+/Yxv3ezWpMn7q45ViuRfdIDQAgq/VHCPtvDXS?=
 =?us-ascii?Q?5p1kBBdsoSsFcsI+GxDmrw4DXic3WifQlM5CLgvO/DJa/Jqs7VbeIw7Qrpu5?=
 =?us-ascii?Q?0/Uw0FX7KwUDLg1I68+SPKSst9plsU5k5UdndUXe7aqahgW0LFUv6wS/HSaq?=
 =?us-ascii?Q?36CedzHabM69x26Y+J8oWmLml5hvAPVxuVp8Gon9d/ASLJmnKW/IWg4oiF/i?=
 =?us-ascii?Q?7Qg6pBS5zi/ptX1K351MzkrG6OzokVwS20EOs9F6IiWRGyotjXU9+4l6exvd?=
 =?us-ascii?Q?SCX2ecAAaivzQsICulpW4dqdfehzj/xQ9ZMLNE/YIw4eoF8H2TlCPBzhlNlc?=
 =?us-ascii?Q?EixkK6E+kIVcxSzuS9QMmhUfw3JybLmzRfWvACzXvNs5w5t3YdpyEhJy/xZ2?=
 =?us-ascii?Q?jlEf7khsTYkXLtfh26EYAv8zZDYrHV5CvKxtSgS7Vw8HNRdXIpEf8u32WLap?=
 =?us-ascii?Q?JGdtbW2EodHMWGVWPsZCELx9gMSyfxqSY9fUoU1BwxPG2I2slwRp8F1ta/Wc?=
 =?us-ascii?Q?wcN1to6UZUFvKdqip5dxzD6K3OubRQRU5rOhng5KA4JqUduSz/w+y9si9uUb?=
 =?us-ascii?Q?W3mSZ3lX3CgRyYpMyKUTtlb9edRKNBPI320IHkluud8XNpdJINaQjskqqUrT?=
 =?us-ascii?Q?zLdwouuEXqTbb3Y5iMYTROq1eOMK7Hd376UfXELZwJk9Dkm7XLiNCEVbZ3dI?=
 =?us-ascii?Q?DJtarZD8xsbLwVfV+tdhD9m7oKIYOMf+ylcvKvR0c0LKiJacZ3Bm5EOEf46J?=
 =?us-ascii?Q?t9z9GgiZU2N2Eo3ThFSsHI9pcV8nnmqer9j1AtbSti0+tz4rTkFhyULG2KIC?=
 =?us-ascii?Q?Zw6hRFzxhBR7gzbws421uXQ5dzv7Ku0AgeJUkiQ0vZhpw9bDG3QYlRt/e2A4?=
 =?us-ascii?Q?PvRdKqVlnIWA7JpCIAsNMHLPFtl62D6SehnZKWmS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2025 07:16:23.0715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3622320-e0c1-467a-36bf-08de095f3fdc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429

Move kvm_gmem_get_index() to the top of the file so that it can be used
in kvm_gmem_prepare_folio() to replace the open-coded calculation.

No functional change intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---

Changelog:
V3:
- Split into distinct patches per Sean's feedback, drop whitespace and
  ULONG_MAX change.
V2:
- https://lore.kernel.org/all/20250902080307.153171-2-shivankg@amd.com
- Incorporate David's suggestions.
V1:
- https://lore.kernel.org/all/20250901051532.207874-3-shivankg@amd.com

 virt/kvm/guest_memfd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fbca8c0972da..22dacf49a04d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -25,6 +25,11 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
+static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn - slot->base_gfn + slot->gmem.pgoff;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -78,7 +83,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * checked when creating memslots.
 	 */
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
-	index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
@@ -335,11 +340,6 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
-static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return gfn - slot->base_gfn + slot->gmem.pgoff;
-}
-
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
 	const u64 flags = (u64)inode->i_private;
-- 
2.43.0


