Return-Path: <kvm+bounces-24280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 276029536BF
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B34C1C21E5E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20261B29C7;
	Thu, 15 Aug 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CrpwBF7A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788DF1AD401
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734712; cv=fail; b=MhuMi0RxoX/BUz9uZuVS1OIsnnlfthG+lJqQkuntIvJFdX34KkcezoiiZWwLZj4yyiunSv9LCgOziYwgNRaF/lUTRlCvZh8gDYFnNLwFmdx7GbnGd9KhVAeTlB0zUshNwEYs6K0PA39RVQK3mmxfF6YWfd7X71ANIIu/qlu0epY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734712; c=relaxed/simple;
	bh=agXxQ/Q64zIyKFaSYsnto1+F0slwFdcbQoNB7ZKb12o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IAukApo27aDqmFZmtfcprNrZ5qH12gMzoo+YoZDxS5qplFLoSeMCXEV9s8T/fg3+yX9j7lpxmi11Xs8GTJfx4sck7Y7r7ne+hXcICvd6XMApwBwxEPvGfJA68+uGq7kAAhqnkyAkV5dDByXhpR7lpqEkgHjT+2SvY002g88bR7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CrpwBF7A; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aA5y2mxsCrOi1FgzicjTVHAHnZXWz6TrDPe4AdzWUrkpFXDBXD63LCWd6MAyeWBYAe7/255XiHg5KAmgWOd2bfisvxU69mHAzuGIB8gojpyX6CuLjhjjZjuOEZHSj9+MouAcy91KIMPZly3UZayNdlIKkBAhXVF0GiYs4JQMG8LmR14c5g/VzhH0VyFkj5Sa07xMp5IN14ggsXVHnvlPVn2oTdbCtpfy0n380nMtMkGUfTGV4U4EHYyGhDIJbe8OYKMP3XnGgh9yAHgRJSbt/JZOaHHc3fnQiaPbOJZBaLkkfMhWV1/6vzkTSYvnkZdfp9m/htvTOFeeoKK6edRAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAdmJh4VgxgkmIhWavLGnmexBBWdbQeGVgAuOdnmCpg=;
 b=x2vMR4LrTPjQKZqROP0pDaB6YXJV3UjUVeXMbVKflzg+7CzDsGABXiTeRf8Q3QFPV4SmyjJsNL5S6B9hK/poYYDgKzk2PI5A0hic26w9MWfowvT2x/vckrkgrtZ11x0B12Qw3KSZb1/BjDUP7xQxElwv3n99lVJGkJJG4/l8VsP6DGFxK7m3NB5Fd7Nb6iE05aC5pMXv5TSNFUx2PwQ3JB5kWuOH7Di1vPa9NbEjWEbeG2w6Q+MzTCJusoN1RsDL/2QEMnAB0Tg1US4owHC6PRKnGbYml1UfPHnGioa8FIeIfjnNW7e2yNwg/XTHz7Qkq4umFrGqYRjnnkoQzogaGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAdmJh4VgxgkmIhWavLGnmexBBWdbQeGVgAuOdnmCpg=;
 b=CrpwBF7AVCc52/RWlTaTKJcEesyCK0HzH0GY/h5/lV5BhF3ZM/We2xaDklKZ9SfKyyYPFrmnC6to70ZZc0IiZ6t0P1llnCvjwd67NXbLL+2TTdpDWmitVHCjg4am4p+Wc1jJ2RT+7wt6gCpfbEvoHOtsmEcsn5UT3VajHuyH7BoZ0Hu38u7G2hanQ6Cw9aGH+gu2VtND3KzzM458xqSSgEfPE7KYvfZAI+dHQzdxGeJUii696HQIH5HiK/OAnNygaH5W27V6/J6Re0mOq5LU2HBdEdw8Vsz8VqZzNtB7IIyt8Dtr3tCON1mVTjNxKt6aUkI5wrXYESzQdVQADwT+HQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW6PR12MB8758.namprd12.prod.outlook.com (2603:10b6:303:23d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 15:11:38 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To:
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 07/16] iommupt: Add cut_mapping op
Date: Thu, 15 Aug 2024 12:11:23 -0300
Message-ID: <7-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:32b::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW6PR12MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: 5161fb87-7b34-4b61-c547-08dcbd3c8d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c9w7wDxGwclhu9pbwi8KRiN2QOtvsrgFXM8W4cBl9Pi2KYIgrIdm58+cHv0l?=
 =?us-ascii?Q?M/D7Aw0ZLjIGbm/S6Bv0QOPP3phkR0EV3Vto/8TDsTwAskSsQ8al9EVSaSbT?=
 =?us-ascii?Q?tiG63l09ny8o4U1muV5m50iflFqfBVv2lf2W3jEuzd6oKSKOtYpH80tAvm5C?=
 =?us-ascii?Q?i5c9Q+YGn0nVVWXENJax1ckDR83R4H3S9QdI81xepdSL8xdR8dHVcthuMvH4?=
 =?us-ascii?Q?6gFGynM1F39iPCRyCCLsaFhFwD8FU1EnMefGDpSPncqEUull8R/PyA63wGFy?=
 =?us-ascii?Q?tDrvOARYurwLiN9dnDQO0BmEJNdoTlYRzNM3ET1xxpqCND9mCoROyby2vw+/?=
 =?us-ascii?Q?MKzBOTmZbNSblyTr/T5aY6ocigeAdlHxrteE8ghX/vxgFwQOdWgR3Ef1klM4?=
 =?us-ascii?Q?veySObIgPDAECGWv68GWsXf3fWen0+R3gzBiwG7hHTl7HDHJ2JqQPZzvJ1OJ?=
 =?us-ascii?Q?evILLZ/y3Se1+XpvpF8fJcN/XSl3t3xi800+8DnHVOvDtTukwK+dDTjdaPar?=
 =?us-ascii?Q?de/Y/WlWlJQDKXGqTObVa4JCw1Vy+Utpz/eLl9yuW28SX7u2mSOzwpvA2v4y?=
 =?us-ascii?Q?XCteyH2bOKNwdS4J+VKZ0MxbKIGJR5TlfD6mu2BYV419hCGjAuj1iPrEYux7?=
 =?us-ascii?Q?SZdt+vjhU4/UkX1zf+LQig+j2u8BnjMC6vc957ojYfTVp4GlsllLAxDDQLZL?=
 =?us-ascii?Q?OkiQGOc0fjTw1iInO7QoSPh/gUTeDQlFm9hIqPR/p68Oc6l0vjwKCoeDknow?=
 =?us-ascii?Q?sZJeKsWP+NrbuwrAW96CTLCbCA1uSPLsRAeBuSfaoO44FGOYKw49EROQkhk7?=
 =?us-ascii?Q?tP6xv0U9sppARgVrfhi0Hw7TwEkSWj9qikGeEMUqmuo2ymFFNfDqIH1hQ1O1?=
 =?us-ascii?Q?Gfz+AwzSOtVme157TpKpCxY1gcylGORDbbVMn4LaHBhJ+xsviXBUkyMThOXu?=
 =?us-ascii?Q?6680KG0vOM/jNeEHl8+Hzt94ZhfQeCOlX/gxI6lfqSKLmIpywecQpNn1J1tr?=
 =?us-ascii?Q?DOS0/wGmmZK1GHc1JxK5Uf/gleCfCkhmL6OY/0OUL2aTCQVZkcBgM1ohvLOT?=
 =?us-ascii?Q?0i8m9c12uEqZZChRqj+4Y5Ubl8VuwVQPQBkCK23T0J7+wn3Vs1KbjxlrKkep?=
 =?us-ascii?Q?s0xlMStaTYG00iX4n2zuSuskTTzAilo9NUxbVCLAyYviqRA/yo4KJgORRJAI?=
 =?us-ascii?Q?MFSAgOWpMRZyK8WtVVuGDkw/GTItvnh/MmSQVtg6PDDiVfS8e1pvEK9fEcDx?=
 =?us-ascii?Q?hwepbj+xKQL06PbPiZJZXsnZL0gINplmpZnHtCZE0uILEafAtqqylohX7yOm?=
 =?us-ascii?Q?GxwLx+qnl8lMbNEtXOwGK9r1QqyhSPQocoNQiA2lXTPa1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4awHrNUXt4cAziVw2eMzfLBcRYetRoKACS3hTDPnjJ9VDGSgZkzJzvIQtUy?=
 =?us-ascii?Q?uEcHS3yQ8OFqzeWKwgBd6npSsyC9pXYna55+zIEjIolwxOgmMmXdpD55IiOH?=
 =?us-ascii?Q?b1B94XeB/FRCf47SmFKC9gyqkxeTcowjxfVOC5xAaIpsD1+gLHRjeRatSwjY?=
 =?us-ascii?Q?NpUe0UGR44ys/eAILIXbxgdX5AaXBAU6xUBniEHJUccC7SFbrHSFojC8ZZfY?=
 =?us-ascii?Q?YrnsDeVVkr7quU0Qcctl9m4KkXeWMGblMA0djpDA/Gy35khomG7ibwjjOYXK?=
 =?us-ascii?Q?W1PJ4T6OHXNrHO6ydWBY6xGl4Fe68U+aiMCsx9sb7DLVgL4DdBoek5QmkQUB?=
 =?us-ascii?Q?ek9WhB1O0+7VsU8Jo4JEqTY1Ya41ewxX6iartWLaBGtXQAgQDgrjAjzfugWf?=
 =?us-ascii?Q?828adtbcmwTLXnKdoZZClNROBoDzNl0FQHlaTRYpX73JL3e02klOCtx90Pjt?=
 =?us-ascii?Q?Kcq5GbNLvHOkCPLmCnshZ+6LqiFMV2RhxH8gZK1dZsy3oklZ3eyA06NqSEjE?=
 =?us-ascii?Q?6jRrKokF+ZURfl1SZDALGqb4G3wXyPV7AF9cHlWIZYRqnu9eawQWvFJLgKpL?=
 =?us-ascii?Q?CNyAZWBCtxGiQXRkT1ebbG1xXZi8rBFNF0ZKDVpAg+bSDMND6p7i6dHG1OU4?=
 =?us-ascii?Q?6gI/2jK/9su7syTHXO115IRNSXnc4ayLr1sAUaE7sQfTYKf32fgf4d17bfH9?=
 =?us-ascii?Q?TOryFW4S+s+yR+QfWkpKid40ijEUrfhgvPmVsSYDQA6TmDCrOLS/uolkoK5L?=
 =?us-ascii?Q?lRbgdKrGDMoUkKw7hREXSH6J7dF/4uChWlgqNc0HBleiOIHiqo1n5UmNWbDp?=
 =?us-ascii?Q?mlsV8FpLdSgSlOkYx+X/biHpXimQTHEuJQTl87aAWkvilcDYBDTpv8/P0aY8?=
 =?us-ascii?Q?HvItoDYyv5w52cP5YgY/NV8F62ybGQLxkYY2/s/SG7D8MmIVJQKfmODc0ODy?=
 =?us-ascii?Q?yLXAteXJdA5qx85Sjny21PlaVDbDq1bLK5UnUkQjyfnJq3+0un8C2Rm49TP3?=
 =?us-ascii?Q?L5ziJkllQxBIg0LrFYgjjg88M3G9t1Cv9Ky7gHPQf6dTK67NTvf9cM7XoqyX?=
 =?us-ascii?Q?xlgEDCkBQffDoTMWQOZ/fZ71oF0zvsTqqWXO8KoNimLvJ6Qf7RNP9rssFWOd?=
 =?us-ascii?Q?DHTKrU4BPuUyhfbXIo8Hz30v9mfINjZrvfoHl3dfYKZE9C54P7mWIsEEg9sK?=
 =?us-ascii?Q?bk+RI2hZsRHiuFq9dK6izbAHIX0BtIaVEZ8I05EddddsA5A8F2ZR7Jhu6FFa?=
 =?us-ascii?Q?KRJ7lYmjWB7cyuhLmUsJ+rD68rEw3pgVAIoaDVb6q0K7IFyFlg2oqm/wBp2W?=
 =?us-ascii?Q?+wxN/OUaIA/sMfm8GfxScsOsm1T1AIY/ZTPXulY9hdquktj+sbVgTIjn+CLo?=
 =?us-ascii?Q?LPy53/Sa2fa984OdQAFTFiF2XIKsItmHF2UERVsZT6zO5tVw74d17TREgiRG?=
 =?us-ascii?Q?3QkBxJN/s6vnTuI037tsmt2FwH+ETGa1frYjl7+CHmOxqtyf0X2ENHiSuDGv?=
 =?us-ascii?Q?2p8LNJrCVqbqNOq5kQcvTUJC4KHAkRB+AdbdwSISS9a/3yRgrSSPx5R/qLaZ?=
 =?us-ascii?Q?dbTwMCKE2qEWygf9qgU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5161fb87-7b34-4b61-c547-08dcbd3c8d85
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:35.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZotXjMyMtROpMZW+J3Si2H3IC/O4aLnGU+UPKeqW9mpoGDMGGBtqHBxeIpEAt8xi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8758

The cut operation allows breaking large pages into smaller pages with
specific purpose of allowing unmapping of a portion of the previously
large page. Specifically it ensures that no large page crosses the cut
point, and thus, we can successfully unmap starting/ending on the cut
point.

This is the operation that VFIO type 1 v1.0 implicitly supported and some
iommu drivers provided internal to their unmap operation.

Implement the cut operation to be hitless, changes to the page table
during cutting must cause zero disruption to any ongoing DMA. This is the
expectation of the VFIO type 1 uAPI. Hitless requires HW support, it is
incompatible with HW requiring break-before-make.

Having it separate from unmap makes it much easier to handle failure
cases. Since cut is fully hitless, even in failure cases, a caller can
simply do nothing if cut fails. Cut during unmap requries dealing with the
potentially nasty case where some of the IOVA range has been unmapped but
some cannot be unmapped.

The operation is generalized into a form that iommufd can use for it's
existing area split operation. By placing cuts on the boundaries of the
split we can subdivide an area and maintain all existing semantics even
with large pages in the page table.

Cut is optimal and generates a page table that is equivalent to calling
map twice, that is the two halves will still use maximal page sizes.

FIXME: requires deeper kunit tests

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 263 ++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    |  29 +++
 2 files changed, 292 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index a886c94a33eb6c..4fccdcd58d4ba6 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -232,6 +232,268 @@ struct pt_iommu_map_args {
 	pt_oaddr_t oa;
 };
 
+/*
+ * Build an entire sub tree of tables separate from the active table. This is
+ * used to build an entire mapping and then once complete atomically place it in
+ * the table. This is a simplified version of map since we know there is no
+ * concurrency and all the tables start zero filled.
+ */
+static int __build_tree(struct pt_range *range, void *arg, unsigned int level,
+			struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_iommu_map_args *build = arg;
+	int ret;
+
+	for_each_pt_level_item(&pts) {
+		unsigned int pgsize_lg2 =
+			pt_compute_best_pgsize(&pts, build->oa);
+
+		if (pgsize_lg2) {
+			/* Private population can not see table entries other than 0. */
+			if (PT_WARN_ON(pts.type != PT_ENTRY_EMPTY))
+				return -EADDRINUSE;
+
+			pt_install_leaf_entry(&pts, build->oa, pgsize_lg2,
+					      &build->attrs);
+			pts.type = PT_ENTRY_OA;
+			build->oa += log2_to_int(pgsize_lg2);
+			continue;
+		}
+
+		if (pts.type == PT_ENTRY_EMPTY) {
+			/* start_incoherent is done after the table is filled */
+			ret = pt_iommu_new_table(&pts, &build->attrs, true);
+			if (ret)
+				return ret;
+			pt_radix_add_list(&build->free_list, pts.table_lower);
+		} else if (PT_WARN_ON(pts.type != PT_ENTRY_TABLE)) {
+			return -EINVAL;
+		}
+
+		ret = pt_descend(&pts, arg, __build_tree);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Replace the OA entry patent_pts points at with a tree of OA entries. The tree
+ * is organized so that parent_pts->va is a cut point. The created mappings will
+ * still have optimized page sizes within the cut point.
+ */
+static int replace_cut_table(struct pt_state *parent_pts,
+			     const struct pt_write_attrs *parent_attrs)
+{
+	struct pt_common *common = parent_pts->range->common;
+	struct pt_iommu_map_args build = {
+		.attrs = *parent_attrs,
+		.oa = pt_entry_oa(parent_pts),
+	};
+	pt_vaddr_t cut_start_va = parent_pts->range->va;
+	pt_vaddr_t entry_start_va =
+		log2_set_mod(cut_start_va, 0, pt_table_item_lg2sz(parent_pts));
+	pt_vaddr_t entry_last_va =
+		log2_set_mod_max(cut_start_va, pt_table_item_lg2sz(parent_pts));
+	struct pt_table_p *table_mem;
+	int ret;
+
+	if (unlikely(!pt_can_have_table(parent_pts)))
+		return -ENXIO;
+
+	if (PT_WARN_ON(entry_start_va == cut_start_va))
+		return -ENXIO;
+
+	if (!pts_feature(parent_pts, PT_FEAT_OA_TABLE_XCHG))
+		return -EOPNOTSUPP;
+
+	table_mem = table_alloc(parent_pts, parent_attrs->gfp, true);
+	if (IS_ERR(table_mem))
+		return PTR_ERR(table_mem);
+	pt_radix_add_list(&build.free_list, table_mem);
+	parent_pts->table_lower = table_mem;
+
+	/* Fill from the start of the table to the cut point */
+	ret = pt_walk_child_range(parent_pts, entry_start_va, cut_start_va - 1,
+				  __build_tree, &build);
+	if (ret)
+		goto err_free;
+
+	/* Fill from the cut point to the end of the table */
+	ret = pt_walk_child_range(parent_pts, cut_start_va, entry_last_va,
+				  __build_tree, &build);
+	if (ret)
+		goto err_free;
+
+	/*
+	 * Avoid double flushing when building a tree privately. All the tree
+	 * memory is initialized now so flush it before installing it. This
+	 * thread is the exclusive owner of the item being split so we don't
+	 * need to worry about still flushing.
+	 */
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		ret = pt_radix_start_incoherent_list(
+			&build.free_list,
+			iommu_from_common(common)->iommu_device);
+		if (ret)
+			goto err_free;
+	}
+
+	if (!pt_install_table(parent_pts, virt_to_phys(table_mem),
+			      parent_attrs)) {
+		/*
+		 * This only fails if the table entry changed while we were
+		 * building the sub tree, which would be a locking violation.
+		 */
+		WARN(true, "Locking violating during cut");
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	return 0;
+
+err_free:
+	/*
+	 * None of the allocated memory was ever reachable outside this function
+	 */
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		pt_radix_stop_incoherent_list(
+			&build.free_list,
+			iommu_from_common(common)->iommu_device);
+	pt_radix_free_list(&build.free_list);
+	parent_pts->table_lower = NULL;
+	return ret;
+}
+
+static void __replace_cut_entry(const struct pt_state *parent_pts,
+				struct pt_iommu_map_args *replace,
+				unsigned int start_index,
+				unsigned int end_index)
+{
+	struct pt_range range =
+		pt_range_slice(parent_pts, start_index, end_index);
+	struct pt_state pts =
+		pt_init(&range, parent_pts->level, parent_pts->table);
+
+	if (start_index == end_index)
+		return;
+
+	for_each_pt_level_item(&pts) {
+		unsigned int pgsize_lg2 =
+			pt_compute_best_pgsize(&pts, replace->oa);
+
+		if (PT_WARN_ON(pts.type != PT_ENTRY_OA) ||
+		    PT_WARN_ON(!pgsize_lg2))
+			continue;
+
+		pt_install_leaf_entry(&pts, replace->oa, pgsize_lg2,
+				      &replace->attrs);
+		pts.type = PT_ENTRY_OA;
+		replace->oa += log2_to_int(pgsize_lg2);
+	}
+}
+
+/*
+ * This is a little more complicated than just clearing a contig bit because
+ * some formats have multi-size contigs and we still want to use best page sizes
+ * for each half of the cut. So we remap over the current values with new
+ * correctly sized entries.
+ */
+static void replace_cut_entry(const struct pt_state *parent_pts,
+			      const struct pt_write_attrs *parent_attrs)
+{
+	struct pt_iommu_map_args replace = {
+		.attrs = *parent_attrs,
+		.oa = pt_entry_oa(parent_pts),
+	};
+	unsigned int start_index = log2_set_mod(
+		parent_pts->index, 0, pt_entry_num_contig_lg2(parent_pts));
+	unsigned int cut_index = parent_pts->index;
+	unsigned int last_index = log2_set_mod(
+		parent_pts->index,
+		log2_to_int(pt_entry_num_contig_lg2(parent_pts)) - 1,
+		pt_entry_num_contig_lg2(parent_pts));
+
+	pt_attr_from_entry(parent_pts, &replace.attrs);
+
+	if (!log2_mod(parent_pts->range->va, pt_table_item_lg2sz(parent_pts))) {
+		/* The cut start at an item boundary */
+		__replace_cut_entry(parent_pts, &replace, start_index,
+				    cut_index);
+		__replace_cut_entry(parent_pts, &replace, cut_index,
+				    last_index + 1);
+	} else {
+		/* cut_index will be replaced by a table */
+		if (start_index != cut_index)
+			__replace_cut_entry(parent_pts, &replace, start_index,
+					    cut_index - 1);
+		__replace_cut_entry(parent_pts, &replace, cut_index,
+				    cut_index + 1);
+		if (cut_index != last_index)
+			__replace_cut_entry(parent_pts, &replace, cut_index + 1,
+					    last_index + 1);
+	}
+}
+
+static int __cut_mapping(struct pt_range *range, void *arg, unsigned int level,
+			 struct pt_table_p *table)
+{
+	struct iommu_write_log wlog __cleanup(done_writes) = { .range = range };
+	struct pt_state pts = pt_init(range, level, table);
+	const struct pt_write_attrs *cut_attrs = arg;
+
+again:
+	switch (pt_load_single_entry(&pts)) {
+	case PT_ENTRY_EMPTY:
+		return -ENOENT;
+	case PT_ENTRY_TABLE:
+		return pt_descend(&pts, arg, __cut_mapping);
+	case PT_ENTRY_OA: {
+		/* This entry's OA starts at the cut point, all done */
+		if (!log2_mod(range->va, pt_entry_oa_lg2sz(&pts)))
+			return 0;
+
+		record_write(&wlog, &pts, pt_entry_num_contig_lg2(&pts));
+
+		/* This is a contiguous entry, split it down */
+		if (pt_entry_num_contig_lg2(&pts) != ilog2(1)) {
+			if (!pts_feature(&pts, PT_FEAT_OA_SIZE_CHANGE))
+				return -EOPNOTSUPP;
+			replace_cut_entry(&pts, cut_attrs);
+			goto again;
+		}
+
+		/*
+		 * Need to replace an OA with a table. The new table will map
+		 * the same OA as the table item, just with smaller granularity.
+		 */
+		return replace_cut_table(&pts, cut_attrs);
+	}
+	}
+	return -ENOENT;
+}
+
+/*
+ * FIXME this is currently incompatible with active dirty tracking as we
+ * don't take care to capture or propagate the dirty bits during the mutation.
+ */
+static int NS(cut_mapping)(struct pt_iommu *iommu_table, dma_addr_t cut_iova,
+			   gfp_t gfp)
+{
+	struct pt_write_attrs cut_attrs = {
+		.gfp = gfp,
+	};
+	struct pt_range range;
+	int ret;
+
+	ret = make_range(common_from_iommu(iommu_table), &range, cut_iova, 1);
+	if (ret)
+		return ret;
+
+	return pt_walk_range(&range, __cut_mapping, &cut_attrs);
+}
+
 /*
  * Check that the items in a contiguous block are all empty. This will
  * recursively check any tables in the block to validate they are empty and
@@ -624,6 +886,7 @@ static const struct pt_iommu_ops NS(ops) = {
 	.map_pages = NS(map_pages),
 	.unmap_pages = NS(unmap_pages),
 	.iova_to_phys = NS(iova_to_phys),
+	.cut_mapping = NS(cut_mapping),
 	.get_info = NS(get_info),
 	.deinit = NS(deinit),
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 88e45d21dd21c4..d83f293209fa77 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -113,6 +113,35 @@ struct pt_iommu_ops {
 			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather);
 
+	/**
+	 * cut_mapping() - Split a mapping
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to cut at
+	 * @gfp: GFP flags for any memory allocations
+	 *
+	 * If map was used on [iova_a, iova_b] then unmap must be used on the
+	 * same interval. When called twice this is useful to unmap a portion of
+	 * a larger mapping.
+	 *
+	 * cut_mapping() changes the page table so that umap of both:
+	 *    [iova_a, iova_c - 1]
+	 *    [iova_c, iova_b]
+	 * will work.
+	 *
+	 * In practice this is done by breaking up large pages into smaller
+	 * pages so that no large page crosses iova_c.
+	 *
+	 * cut_mapping() works to ensure all page sizes that don't cross the cut
+	 * remain at the optimal sizes.
+	 *
+	 * Context: The caller must hold a write range lock that includes the
+	 * entire range used with the map that contains iova.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success.
+	 */
+	int (*cut_mapping)(struct pt_iommu *iommu_table, dma_addr_t cut_iova,
+			   gfp_t gfp);
+
 	/**
 	 * iova_to_phys() - Return the output address for the given IOVA
 	 * @iommu_table: Table to query
-- 
2.46.0


