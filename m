Return-Path: <kvm+bounces-65975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC71CBEB0E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDE6D30215D4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5667B337B82;
	Mon, 15 Dec 2025 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L2cWQsoR"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012001.outbound.protection.outlook.com [52.101.48.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C01332ED3;
	Mon, 15 Dec 2025 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812930; cv=fail; b=nUamE7jl6Y2BBotxDp9MkzJPlWlM5e9Nj1zJvIw4hfdpCBSwJdIc+cOInpnfQe4Rh6kiqufa6H7YW4O8exzAkNsF836ivP08WhSy4Xvm+skJ4Zxts0rfY9MGPYKDXezBuYxTBg9gB+0a6ICbPzFYRnHWitOKV5lRpX2GzyTrY/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812930; c=relaxed/simple;
	bh=H+TGSqyWM9xrvgnKmEIykKzPH5RES/poeL7WCeWeCqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMA8BzdoDJzt9lqfiLwEXljrdsb814yhkBgLs+B7A9oqM6G+YIto0UH8LvnaRqg4F0chtr3kywgx51qiqQsSIBT8OUIOWgtuwJioVdkFSk2qKBd2TI9RaexRAHIZBpLQrOMpRrSj1SwiopKi+ysUPOBMUXrsUHO+8eRZTSkPF84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L2cWQsoR; arc=fail smtp.client-ip=52.101.48.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VPugYe6k1ifeRpsyZxVx6qMRumfBqNdoTKNspNLhhx5cwpM3HTVBJNpdbFcPnbVIbtFEuT6IcAsmfQe6VpR6ELgc56g3Cb2eTeajjHR69y54p6zNjdPIhg/xpIM1gsPgCuQfYHE3BEHYC/klTx7BXcKUJRXJplKCG/MqrIu0JzDTDTkgWzT7kPTOOwcLbzh0EBakkx1ta9tSwPCULseIttBnh/eZLBWe7FsXe8i2GNdaxpYEvp6vQIAWBOu5U3K/NQIHNVeXxcnCAWs/DKYi4m8XpJv3NGmSY+x6gBOBHTfV0BSYZg5cjieHtf9dl69iw6k+ZJZnp3IWCstUEIlmLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkjH/wdkZTjRLW5OWhycTfPaG5Ow0lvOUTo7LeWk/qc=;
 b=sSbtHdD+GFr7pwT2bsLG6DGYYtCHSwxmwKJElod5AEkEeozcEcOkmNsx1hO+MP1Xn+WLhDmx1xOWQZti3VMzgk3+6udRAeVLqKTM0Y9TOfCHUk88LBmR0nOy4Uwm+ZNMdZEmZU7JDAMz8o1/8wHjkycDiIaG+BtXajkjCjR9s7py7EESBh1tM2C8oPfOgsu1RFl754Nr2iRe0z4fe/mD80UQRCzp+zdPRzK6/Q7N35epiOsKaOyOj/L7NcoflXX12g/zJx5Q8qR+ZcyIi7edCg+aHBoLw5yfcOBI0xlZZSRI79eZLBwA5TfTtY4v0R1qthEvBznccHANZb09g/SvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkjH/wdkZTjRLW5OWhycTfPaG5Ow0lvOUTo7LeWk/qc=;
 b=L2cWQsoR4WYfbmFYT8S+bUnMHtZDsI/74S7Yh8kmAl2V/k5lmZMl3iHQJd0FIL1uxyYxpAsmOZiVpd/qqjglmDZyXthtZapGLfS78sBppB9P26d9Tk8ZUrm75jBuTWkMAQw/vinYICHRc3I6Zm33m397KKzq+aPZtyLAD7uI6wU=
Received: from SA1P222CA0156.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::19)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:35:21 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:3c3:cafe::e5) by SA1P222CA0156.outlook.office365.com
 (2603:10b6:806:3c3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:35:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:35:20 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:35:19 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
Date: Mon, 15 Dec 2025 09:34:08 -0600
Message-ID: <20251215153411.3613928-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: be8a2d57-494f-4f86-f800-08de3bef8e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TENfuf1PsFs2thjEbSmtLxb9WDjQvdw5W2Yzgfy/8jfjQ5gsJLDCuaC8/LV1?=
 =?us-ascii?Q?9TzcAKYYXPFEHfW+zzMCfOpHo4c4jrBeExdSCP9K0+l+qhinpPBwJ+7Q0EE/?=
 =?us-ascii?Q?kQ/M5ftpGV1n1yk81q8dYeVIt9AMsCqzPRkliGvE93DCj9fgecbNPLgWRUma?=
 =?us-ascii?Q?ZF9ojw3Owy70UxSaERID4zuWnfj97n7cDDYel8rSauf47gsvhrOJGdLJSNNi?=
 =?us-ascii?Q?MLVuXMLUM61ANDcQxhD4mFhdQu8mSOFjFsCpxTeiEbvRV+roALf9/XgZ6TbA?=
 =?us-ascii?Q?b4Z7kJt4X4ll/af5nxJMOnvaimVHbtytsrBebpe/wCpPyb6KXgdkuC3YpNEt?=
 =?us-ascii?Q?DehzIKyWJYmT72mDFMcFU6HGsKZEBs2tGjRvcq3e6IIoc8KEPTnmBfaldJve?=
 =?us-ascii?Q?4yZ8mIDbY02BWZsDUHzzo3EpF940YurDhVn4Qdok/BKmE7lzuUuwPMejABLQ?=
 =?us-ascii?Q?+DX95aw99018ROhrWVFiHGQDgHLZM6VHJoz8MUj1/77UV2kY43SOb7qjnHyw?=
 =?us-ascii?Q?2AQYQBV4wSIN2n5Gjq9cl57ZMP9Eg7vM9NWqQi/YHiGlzkLRBzuu4hKJda6/?=
 =?us-ascii?Q?CduEOkeWqp+EaZz5DvM+TsEO90iXxOA2VLGUDhwahha055rbh3xG9WWIDRyJ?=
 =?us-ascii?Q?beJV8wxZITBw9tA1yuFEfL9/snWwKGyHjdKS91GeWP+XuK1ItsvsJpqP1MSJ?=
 =?us-ascii?Q?OtwBlLBzZ/JpruafBY9NS7QoV2OW3FR8x8WQW/kZtlqBOUITu2UFbBHdTJL6?=
 =?us-ascii?Q?rNvSnI3ZY4I34fZL0ZAZxUyopYyODFR6qcMBCrRLFzjom+MdzEr4f/DAsKtp?=
 =?us-ascii?Q?4shUQ8MZWw4ONggLsGEoNmbokPYBw6T7H750P70ZLzdBmv3t1E5m7ARf/0Ps?=
 =?us-ascii?Q?MV0oBZ0znYme7im9lvxbSHGUfLMgdFtja4XuLfr98OiqIf9e2arjnSTYT5fd?=
 =?us-ascii?Q?BBD6kfwchrNZmWf0eK9MI5JcMwMaiosdtGaO8c5PpQDrU5AQVU+3eYKQtrBk?=
 =?us-ascii?Q?8Lv//D2VZ+SBXlCEAChzR0XYsdqbJRfQ9i/6bthxm2v3ueuMsVJv+a+Y0P+H?=
 =?us-ascii?Q?mtxa8opKcOulzZXdJvPfLjQr8zXI6YI7d3FYVysyiWQw5KfIPGZYXMbhHwOq?=
 =?us-ascii?Q?zID4cK4rdaF4R+uqkQ1Px6Jjh2NjeuQ95zeetAfr2zQW9ZceKc8Joj2l2Exn?=
 =?us-ascii?Q?OuSmaEyUMcVGCfX+sTKRtIVr//ZvNGNFEgv5DbWHplZ5/maRiZLrfaTAIbZ7?=
 =?us-ascii?Q?Bwr7ePU7/VmgakudFXr9Dp/4QB9u3bHJckqcuhCwFNjvMbtv7qQyYTd8Xoq1?=
 =?us-ascii?Q?OVsxk5NbM0by6VSuslmRUmny42L070qI7gX75L3krjTMq3XsSIpT+y1HRJe8?=
 =?us-ascii?Q?sJe99I9vQq3LsXiImvimtm0eeP/+ikw4eldulX2EldVei2SgSgfFv6ERMkLH?=
 =?us-ascii?Q?GAeIJKpFeqxeuNsCKrAqErk8dHPf/gELh7i3lUkF/zfuBbkiBqFzzajJebjU?=
 =?us-ascii?Q?NluP04B5J2i8kbxD7brsQPxMYH+hozLbeQd+VvGw7CCXBOl8Ac2C+DsnLMRO?=
 =?us-ascii?Q?pfzVReY0E3pcq1yRuB4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:35:20.2424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be8a2d57-494f-4f86-f800-08de3bef8e40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

guest_memfd currently uses the folio uptodate flag to track:

  1) whether or not a page has been cleared before initial usage
  2) whether or not the architecture hooks have been issued to put the
     page in a private state as defined by the architecture

In practice, 2) is only actually being tracked for SEV-SNP VMs, and
there do not seem to be any plans/reasons that would suggest this will
change in the future, so this additional tracking/complexity is not
really providing any general benefit to guest_memfd users. Future plans
around in-place conversion and hugepage support, where the per-folio
uptodate flag is planned to be used purely to track the initial clearing
of folios, whereas conversion operations could trigger multiple
transitions between 'prepared' and 'unprepared' and thus need separate
tracking, will make the burden of tracking this information within
guest_memfd even more complex, since preparation generally happens
during fault time, on the "read-side" of any global locks that might
protect state tracked by guest_memfd, and so may require more complex
locking schemes to allow for concurrent handling of page faults for
multiple vCPUs where the "preparedness" state tracked by guest_memfd
might need to be updated as part of handling the fault.

Instead of keeping this current/future complexity within guest_memfd for
what is essentially just SEV-SNP, just drop the tracking for 2) and have
the arch-specific preparation hooks get triggered unconditionally on
every fault so the arch-specific hooks can check the preparation state
directly and decide whether or not a folio still needs additional
preparation. In the case of SEV-SNP, the preparation state is already
checked again via the preparation hooks to avoid double-preparation, so
nothing extra needs to be done to update the handling of things there.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 44 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9dafa44838fe..8b1248f42aae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
-{
-	folio_mark_uptodate(folio);
-}
-
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
@@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
-	int r;
-
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
 
 	/*
 	 * Preparing huge folios should always be safe, since it should
@@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
 	index = kvm_gmem_get_index(slot, gfn);
 	index = ALIGN_DOWN(index, folio_nr_pages(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
-	if (!r)
-		kvm_gmem_mark_prepared(folio);
 
-	return r;
+	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
 /*
@@ -429,7 +415,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
-		kvm_gmem_mark_prepared(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -766,7 +752,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_file *f = file->private_data;
@@ -796,7 +782,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -806,19 +791,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		folio_mark_uptodate(folio);
+	}
+
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -861,7 +849,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -869,19 +856,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret = -EEXIST;
-			break;
-		}
-
 		folio_unlock(folio);
 
 		ret = -EINVAL;
@@ -893,7 +873,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, opaque);
 		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+			folio_mark_uptodate(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.25.1


