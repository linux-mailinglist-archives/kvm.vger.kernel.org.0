Return-Path: <kvm+bounces-63076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 09FDEC5A7EB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:15:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8D7ED4EF0E7
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C163254A9;
	Thu, 13 Nov 2025 23:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wiOIrpet"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091332694A;
	Thu, 13 Nov 2025 23:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075324; cv=fail; b=hrtoWU6Rk9tSf5aaj0fR4NgwrlRq+jucuLdNcjxTL6f2A1PLgIaAcooQ0rnaabCy3q//M13wcIOu/d2sLS9dT81c9Pgi+tyvYHpz3Azs+k+ixP+uEAacAdoeNki6zpgG0pYLCHJIA/4B0HLA3nUsV6T+u49VEJ6nH7Xbj216aRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075324; c=relaxed/simple;
	bh=qRxtzPbUE8fi/3t8NGwcsuQvuRA79gK+AmGnPlO5yVM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WozA8iTZIZltp8TiOu5vo/hXmoQbQ80/mDtwvXonah5uobGWK1GlLga3oR1s7jaHmKJlsqQJS/tB7CfhvJvwYSaGPCseCycoVjRiNsyJplZJUwhW75dxtMQYi2e8SSS7QLzRtoBiE7Ss2yI5FoE4CpsgpG5Z+q6AxTR97AOHxJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wiOIrpet; arc=fail smtp.client-ip=40.93.198.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPRzgwWl5LPjVgVH0U39SPDD83JaA9yo/vfC4Yi43nfMwFXy43cvNirVqjJZqZYZgcvOzEc+FK1G+sYWhWzl4RzegFXDTNiqaOeh77vNyG7uaiu3zmEYRLhg2kBW4nVKW68AaZdDBysLHpXJR/hjnsx/MHhFSEWr5vWRGeENnaECpVm+iJxuIPq2NihBYHMKWq2XMPdEBRQuVkDe98mN9dDEB3dpKouBeMBz5K6trxvffBb/quCFRBVKmSu39EPLT24rTg0nz+5CBRVh8AgntBgTkmhVvow74rU53p/kZNKa0xPCK9n4iLeUlJvkNbeBGIMftDiEJ0yCkEH/6E/KMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXkUAxV29gzA9ctRApxVOMCFB0Pe3g1OFlchS32WXr8=;
 b=w0xLuM804qJ2ceR9PK5ypxFkdLJ60S3U7VyKJc1qPCrFJnQWsGXc8bayHOoBokTvP2/a+KYYXyihAAQenjfR//J2DzWphmqMhging58XzCEd2AI/nfRDLxJDB0xRR0Tc1pDpvKkIgBNp2RFbShZTCILvWAY8hLgkj8pc6mjCEwSYXHnEhGtEWEfBFvFxN6EkqtpCcF7k2gvg2CzGdF6UHogCJhjuqVfXlQsCOKZaLAq1op92YVfalefXutWjtDi/CSmQwScsPf+zyvljpsLugLNrHkFKEqEE0T1F73WZ389KCEhiyEpoT9xQCUQr8OaKdwv+PDC1Zx6bnZ89iDMJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXkUAxV29gzA9ctRApxVOMCFB0Pe3g1OFlchS32WXr8=;
 b=wiOIrpetNdm7HdNrjAB8i8ba66f37G+fK2wKg4JsJPwRmzRG6ca514ddhb+L04Quo3oQtjgevqkKjc7nq1NiLROnCF6pmWJ3VpAQOArx9ZcOt5Z4FBmu43bHNeUnqds4KcSl8GUqGmxx/H5fRia1CJPp2n5JkfGdpjgIGTDPMgc=
Received: from SJ0PR03CA0072.namprd03.prod.outlook.com (2603:10b6:a03:331::17)
 by DS4PR12MB9707.namprd12.prod.outlook.com (2603:10b6:8:278::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:08:39 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::71) by SJ0PR03CA0072.outlook.office365.com
 (2603:10b6:a03:331::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Thu,
 13 Nov 2025 23:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 23:08:38 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 15:08:38 -0800
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Date: Thu, 13 Nov 2025 17:07:57 -0600
Message-ID: <20251113230759.1562024-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251113230759.1562024-1-michael.roth@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|DS4PR12MB9707:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b22e47-0448-459b-b702-08de23099499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Zu8iPGAppimqAFbzu5Dn8fZBrLouqZGDx/Vv6BFoInO/sYa5FRBK90ab0Fe?=
 =?us-ascii?Q?/QpTbXXqo4tUMcMVve0IV7BeHa8wW//4pgMHDFFrhaagTrPKBcqbb4/dgeik?=
 =?us-ascii?Q?g6wDhyJur8wRL8Wo3vplu5k+HWgZaL2iSOcpWrCvycdr5BPrCao37icX9sFo?=
 =?us-ascii?Q?Bx2InKcCezNHBoVE2cO50XOYZAvY4/EC5jBhWiturI3/fLXSR8ByGFvO0X9r?=
 =?us-ascii?Q?H8jwsXMML6QspqkOUIU5z/R1gfTBQNOKOQ2kHaRw7i6gj1sEtdp8pFI0i7Bb?=
 =?us-ascii?Q?wDcHrNcbNhtIXuFiG18I5CMWLYJP5TLMdSQJKUfTLovOMVsHVtYB/LZnqeoy?=
 =?us-ascii?Q?NJXdLy76rDIvRW7v1bjkU9P2d7F+YIk0nt2JgOlaMB0LxnYWNulf+XOCoy/G?=
 =?us-ascii?Q?7yt+N7g2VdCpgWKt9ztomiloymeCat7CLksb5WpE/UVNlseT04RktpHpIiTy?=
 =?us-ascii?Q?J85Yp3o0Mi3dM10wkxQhyR7K2UKg88UiD7ilEWt45dPbzBo0WLRASn/4Ernn?=
 =?us-ascii?Q?tU4tbuvBl0QoVv+wkcsv2Gwqgy4mq9ALpEw1ohT3cB8SIMbNGzi88SW+8/Jb?=
 =?us-ascii?Q?pAJBfejANC84HQsjnbYrPeGrmc89uGGP3RYItpfs4CiR9m2X9hBhuYwOhKqa?=
 =?us-ascii?Q?XSfhGyPEQp1qzi1YcrSJ/9U0pjVJXdIg6f88IuLYM6NOyEivJvh5mIOG0qwZ?=
 =?us-ascii?Q?OWf9cJp2TugTC+qtee7eTkGizICALndqfI/jvwa89vS6q3OfXwWmABZqjUoe?=
 =?us-ascii?Q?HHeDhrJNDyT/KUxT41k+RhHQF8VNqVxw7b0whJQQV1nd1KAb+gje45Mp8JTJ?=
 =?us-ascii?Q?cc+TlQhpq7bmebSv+BTFHYVqCDEhbbodDP3XtdXcbUNsQZGNB5qgWyOgpswx?=
 =?us-ascii?Q?TVBpYFwPB0081dgh1PM1Ey0Gb9HhdyKfWLZ1EcGI+7H7SparNsp+LcgMGquL?=
 =?us-ascii?Q?46gOo1WlnL+7S89YTAVxFwrqaYIU/OlkRxctvNB1VcYGO2i1kL6Yn5Dizv4S?=
 =?us-ascii?Q?2NTcDg188zW7hMeRTyrE/WzFxBw3etYCVqbHWuq4Rfo1OEUpZNsMRj9J2aOP?=
 =?us-ascii?Q?6KQvupoBeI0CNxm1MQd0/c4EJ34xSLVXNCk5uhsEi/0d0hHixSb2irvtvccQ?=
 =?us-ascii?Q?KPUWwvdj01V+Vl3aZwsifoqP2QFtlRFc2yab6yd9d5PSFiz9dLRNs9LWfJN6?=
 =?us-ascii?Q?VmgQ2tpd0pTea/DPhPV1WrLkw4XMhcMKjM7mldMtucWMeh5ggtmpFrvGBIKV?=
 =?us-ascii?Q?OMznyqv5L/Ai+QG3+xtQhOEZanh/cp+u56+V+nUVTHAkwSAWejPlCIxN9d/l?=
 =?us-ascii?Q?Zlys5dHnArAOHS8wY9ShFBqoNTL507voxoaH/oEZ7e9do59O2F2SFCaWmgfd?=
 =?us-ascii?Q?hjagPGmAOLQTuTV14YLkKc9IepwYmlbLK/hYPspp4dhb2m4dyxgfvLk0hpu+?=
 =?us-ascii?Q?ZUJTGC2DmZxYRVRoVSsjC6Xjk1n7LJofFGW2PwbbRu+NvwlDKt59zEJisGbo?=
 =?us-ascii?Q?ev71XOJP/wA10iq7lcd5UkN/1Z8FoYHfkVzmkuhKs8wA1l9NzupDGyl97ram?=
 =?us-ascii?Q?Y7TlcTK/N3NlwAVPWlM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:08:38.6622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b22e47-0448-459b-b702-08de23099499
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9707

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
 virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..9160379df378 100644
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
@@ -420,7 +406,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
-		kvm_gmem_mark_prepared(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -757,7 +743,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
 	struct gmem_file *f = file->private_data;
@@ -787,7 +773,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
+		unsigned long i, nr_pages = folio_nr_pages(folio);
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+		folio_mark_uptodate(folio);
+	}
+
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
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
 		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
 			(npages - i) < (1 << max_order));
@@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+			folio_mark_uptodate(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.25.1


