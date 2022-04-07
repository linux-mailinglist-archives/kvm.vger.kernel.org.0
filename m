Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B304F82D0
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiDGP0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344603AbiDGPZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:25:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACD621798D
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDZmkIZl2USMUrerl/+yHxj5PPSxinfIyieKecaw+AVLmB+yNYgDtFfIdl0cdN9VhYhklCKxbJidta7cH3ZNzIiV/CCbZZEg0LSVFa42Mvl6NDKgZVuwZSOp5JVmwjJIh0aeFBtYaNc4QOH1NOSFTPM4QLVE/gM5pu2Kyk5cOvkpcdoXFwo96DTqSrs8ywjc84nJzsxGkcz9C7r2nt8o4KkTlp/wWpAm0JKL46oXRKBDWc1VqR4tbVkLW2QQl6J8PqMJWxjTLyc364oT/sbntilEFmAr1J2sj2ktQIIUFs4FHPkkEvBJnNEqAaI6BHBP68KW6JdpM1GrrF/vdkFS7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5nFN1+SconG4MBJis9L36RYrSREFNs6QvyM6I1b3kM=;
 b=Rudkqub5BylVXAEjHwmpWFLCyceUGlkOh9Jpycq8hh0o9Z3hxRsn68jNXCF6u4zUPvGSqVQksfahcLiIxgv5ATEGyPQOeTQRAq/YkQLjGBuJ4zWe6s16b1upc1nCorJ48Iav12ELKoLyw7p3JiDM/JbOjr2xZZzmeCThiI9cW2mSC2G4LkosfQ3RFVUUNc31ZGlwrVMcstYYaHgYXi8Vj0G+xwqZ7PqIMuphtTVjzSetzNbFmFGZs5tCcxMEiC9kS6csvIDEeOirqdtXyzUtS9+unSun7Q+O2Fxu7s10gbK8LUHPY7caKJr/VgXgsT4Ofytr8G/wIWeAYgCE0XT6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5nFN1+SconG4MBJis9L36RYrSREFNs6QvyM6I1b3kM=;
 b=Fddk51THbQqoLqYM0VdsHPMjI0qvyCD5p4vaMgotIZSEPQAyl9CuyBwSB8ymxh3qG+XVCD4v6kDXtHJd0IppmBLeQItn8ZHz321lCZAdHVzkwi0b3FIiwsSQzhNSs/xb/4wiS9kRuMLA36uST3dv0PQvUMBBoYkhox4L40ZcbiVVp+JyZcLec4s9HR1oDre3l/q49Dros4ZMibngAF1HXRYRO666Alq+8/8U7Hgc2HB//+L/8jXIw+Kmu22jSOcH3gFYBoBLtiz9WJ6wN6V+csLdy+9DMJbpJ4ap4Sxpk6X+XNMszS0dqFFZOR8OgEJ11op4eVTtwN41dxe0NTKaAw==
Received: from MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10)
 by BYAPR12MB2742.namprd12.prod.outlook.com (2603:10b6:a03:6a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 15:23:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:23:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of IOMMU_CACHE
Date:   Thu,  7 Apr 2022 12:23:45 -0300
Message-Id: <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:610:cc::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b256706a-713a-4933-fc3d-08da18aa9d70
X-MS-TrafficTypeDiagnostic: MN0PR12MB5740:EE_|BYAPR12MB2742:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB574031DE6050298B1E954A74C2E69@MN0PR12MB5740.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1CKFm8SALBZA1OQGli24OrU8eCBjsEK2dsEWzHz+/v0BRA2F1hxS5Mp4F3YFHK7LcQCGaXP8cGlHSiZFVOjtBDEfSl5LO8fbKiomvbpvX4NyqF92kqrZ65FxctKts0MZtwQMJrISG4YjBRGbcF2upPek3M/UqeAcJ5oof+4GKAf1aKtHpUgttDGcUaTxxlMf4mTWnji1Pr1Ved7Sd1sXNyJxkgX9jMIj1RCBGMAQ9913P8KwW14s2i1KvejKElVJcvDFd9THoe8LediF+P6JO3l/k15RtHo7igprdKRR/xSRYpFVlW313w5IY9TL9stonWZaKsuiZ+RqkFp6X5mel9SLc/nMGlPi5InRdfcjrA5NwJG3ldwUdWpi1wTH9GOsLIcBzLMRIGEKAHGQSQGHvDtqelfAtJNl+z2aL38O9HUMNzIRAJm4kr+u6AZI0V+bQ5cewx3yo0+GzfMgXHZYyYmdqDpy+JgvTF6YdMy5ETdLTJJQEco5/wMo+3suD0ASGghx1c8W0ASrToN37hGPj1EDpwvRemFq0RZZX3yi2hlXnIlELLXgal2xPnRwHmBbNojcZPIxO1cFnNKkYdqzabOq19Ny4zJD7SE/I0XBi6fJPy8RMPicDZeeSTx0hzrSHYXNVVSXkWWkLUWBenACwrhBxry4zjpDUxdZZ0V/pd1SsDJYKLewNT5cfb/6fYu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5740.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(7416002)(6486002)(5660300002)(508600001)(8936002)(2616005)(6512007)(186003)(26005)(4326008)(2906002)(110136005)(6666004)(6506007)(38100700002)(66946007)(66556008)(8676002)(316002)(66476007)(54906003)(36756003)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eQHgF/QcvxzJkxY/GpeHMgJl8xg/gUYKN+K+OjkoX1JRmkziA/BM8eRH2XeZ?=
 =?us-ascii?Q?HwYbXNlpLYoGLJVUYDbtZivsEKM6/q/8ivUxIBJFjN4fIvb5qXHF9zVi9cog?=
 =?us-ascii?Q?0uHmpWCTJ4NuZJksxzu2sYINW3PLFeWgLfm9PSA2K+WQ2ZiZezjW/KECUc+g?=
 =?us-ascii?Q?52I9beNNwz/T3hv90EbyJq8BgGR1zzCjh6lwbdXOIqRTxCk9v7/YCKTu9oIp?=
 =?us-ascii?Q?NHEH/+Ft6FkYqSSQ+yQdyPQtp1OyzLw8J/GLqGpoYfOAcrg6TIJ66MA7C1cA?=
 =?us-ascii?Q?N4Ox/ir7dTJi9pc2s5Q3BW9vUJQKRIiKzkXl7rOZd6ar4qx9eopDRfcLGrto?=
 =?us-ascii?Q?4eNjfIduC0TQSUNPi+QrJ1NYwTwA1b/Nlt6IF4whI9AmeCvNb8o6+/0Oem2x?=
 =?us-ascii?Q?RY+UjTxy+lTmH90F4+VQriXsQvHWbp4UfuHbgnbKxffzBhxf8bvOxASObc6r?=
 =?us-ascii?Q?QEQlM9rHJwU+RZSbL9OSdYnmfqNhcdAIuVhFJVHjs5TF+KVQxa2BNNhW9g4G?=
 =?us-ascii?Q?0/sb7brG6poceRCTUv2xUBqi20uQUwx9rHyLYkuB5S7XQ6JY2kk06y//4ak3?=
 =?us-ascii?Q?/ZZ0CgiPeTggVE+YIs8kfhxqK5hnb/1+oZoWNJy4m6Or4NEIl3ybRATM5fO4?=
 =?us-ascii?Q?+YjAv8jDABd0WMciR5QOtpwfYvCrUmHWYu3/e+hN3nAQm61Tvld/gByFl1jj?=
 =?us-ascii?Q?wDz+dadjoK033XTWfZiJkNvTktYV8AyBG2lQIrNV3+uOtBPb2FL1CR9auoel?=
 =?us-ascii?Q?N6n/j+husKLp3eBKpecxFolkzhtxvUfGWg/cJGf//DaHoBKFVEiVuHSwUKUJ?=
 =?us-ascii?Q?39ehjwYJb5CNfk8GsEpnvRb4QehzKRrXqw0LuOCXZqN/C+B4FmIj5fP6ROLt?=
 =?us-ascii?Q?yKNLsH5JPDlxPislHH2kmSZTJVG4UlCQ9a8m3dP5NkcJe5kJiZUIMEhDkoJ0?=
 =?us-ascii?Q?uGWPD6dhlklItf7mmmzy9ijVOoEhHVFjoWsE8shmhgTu03P7pR6RyP8V27Yh?=
 =?us-ascii?Q?DcZLlbKRyLf7gr1e6xhEM/3v2VWO8AnP48qbQ8nsi1En7WIpctpvIrzi+Mml?=
 =?us-ascii?Q?L1gf5n2Levu40NKc1SdBaf0QKCabfux7ujyIRh53/wc1V9gS7qxJ//8hgMML?=
 =?us-ascii?Q?Nh5do4+JApPlDWY6idVxS3YsAbMxrNgTCjzA+hXhkxNbz8CPWF3SkBdmntrF?=
 =?us-ascii?Q?RR7A2Hk21j+yVJ8lUecH/9yjeqY0iOj3YMgjuSw+IAdRWBxGB+0YIX7ZeMBZ?=
 =?us-ascii?Q?wpD7GCOaBwWzRxeyVbGvcmq5VD2oDWc3u8gkMenN6xu4+FYum4nSrekSRrNm?=
 =?us-ascii?Q?WneSQshO4781JZ2Nn4swhn+BNBc4dWJoQltgp13M9u5l6vni+6ldpFv4iWVQ?=
 =?us-ascii?Q?WZTevD8bIngWJlqh7hvzmO5yPxYK2ZwYPkDYt6BT68m+V2usNJq0AG4RZaF6?=
 =?us-ascii?Q?NztzTstIbJ0EdJvAXvgeG93i55KV/Vg3LBBnfvH5k2J6feHQcg1UvPnP2MxR?=
 =?us-ascii?Q?gW9yQcTMdMbQp4jQ9nG8w3bAFNdqmuPnrgiSjE4Z6SGH6nQcu3Z1WLvJ0z/Z?=
 =?us-ascii?Q?bjF2nuQOus0LdDjDvdblf7exrl9femE9biGy13FYrIh41qRsRA5kI1JB/6nw?=
 =?us-ascii?Q?ptNcIHKAlCq9UoUNyF9OhLJ1Ww81/rCVjSggh3RYXkB+LlRCuxrSdJemwXUL?=
 =?us-ascii?Q?xKUpa8RPGKLAe7PkTJPlT3HVilfXgMLaNn6D9i+jTynqpCZy8KkbemVnnGEL?=
 =?us-ascii?Q?h+c0Z5x91w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b256706a-713a-4933-fc3d-08da18aa9d70
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:23:49.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5bu7fNWUMdXbd6u7j6Hu6K7+I2Y8Km7LSKY39iHVkVyjXK//QFyiIAXRQnaqsVB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2742
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU_CACHE means "normal DMA to this iommu_domain's IOVA should be cache
coherent" and is used by the DMA API. The definition allows for special
non-coherent DMA to exist - ie processing of the no-snoop flag in PCIe
TLPs - so long as this behavior is opt-in by the device driver.

The flag is mainly used by the DMA API to synchronize the IOMMU setting
with the expected cache behavior of the DMA master. eg based on
dev_is_dma_coherent() in some case.

For Intel IOMMU IOMMU_CACHE was redefined to mean 'force all DMA to be
cache coherent' which has the practical effect of causing the IOMMU to
ignore the no-snoop bit in a PCIe TLP.

x86 platforms are always IOMMU_CACHE, so Intel should ignore this flag.

Instead use the new domain op enforce_cache_coherency() which causes every
IOPTE created in the domain to have the no-snoop blocking behavior.

Reconfigure VFIO to always use IOMMU_CACHE and call
enforce_cache_coherency() to operate the special Intel behavior.

Remove the IOMMU_CACHE test from Intel IOMMU.

Ultimately VFIO plumbs the result of enforce_cache_coherency() back into
the x86 platform code through kvm_arch_register_noncoherent_dma() which
controls if the WBINVD instruction is available in the guest. No other
arch implements kvm_arch_register_noncoherent_dma().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c     |  7 ++-----
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 include/linux/intel-iommu.h     |  1 -
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f08611a6cc4799..8f3674e997df06 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -641,7 +641,6 @@ static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
 	domain_update_iommu_coherency(domain);
-	domain->iommu_snooping = domain_update_iommu_snooping(NULL);
 	domain->iommu_superpage = domain_update_iommu_superpage(domain, NULL);
 
 	/*
@@ -4283,7 +4282,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	domain->agaw = width_to_agaw(adjust_width);
 
 	domain->iommu_coherency = false;
-	domain->iommu_snooping = false;
 	domain->iommu_superpage = 0;
 	domain->max_addr = 0;
 
@@ -4422,8 +4420,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
-	    dmar_domain->enforce_no_snoop)
+	if (dmar_domain->enforce_no_snoop)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
@@ -4550,7 +4547,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
-	if (!dmar_domain->iommu_snooping)
+	if (!domain_update_iommu_snooping(NULL))
 		return false;
 	dmar_domain->enforce_no_snoop = true;
 	return true;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa9444c10c..c13b9290e35759 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -84,8 +84,8 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	int			prot;		/* IOMMU_CACHE */
-	bool			fgsp;		/* Fine-grained super pages */
+	bool			fgsp : 1;	/* Fine-grained super pages */
+	bool			enforce_cache_coherency : 1;
 };
 
 struct vfio_dma {
@@ -1461,7 +1461,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | d->prot);
+				npage << PAGE_SHIFT, prot | IOMMU_CACHE);
 		if (ret)
 			goto unwind;
 
@@ -1771,7 +1771,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			}
 
 			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | domain->prot);
+					size, dma->prot | IOMMU_CACHE);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1859,7 +1859,7 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | domain->prot);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
@@ -2267,8 +2267,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
-		domain->prot |= IOMMU_CACHE;
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then VFIO always turns this feature on because on Intel
+	 * platforms it optimizes KVM to disable wbinvd emulation.
+	 */
+	if (domain->domain->ops->enforce_cache_coherency)
+		domain->enforce_cache_coherency =
+			domain->domain->ops->enforce_cache_coherency(
+				domain->domain);
 
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
@@ -2279,7 +2286,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
-		    d->prot == domain->prot) {
+		    d->enforce_cache_coherency ==
+			    domain->enforce_cache_coherency) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
@@ -2611,14 +2619,14 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	kfree(iommu);
 }
 
-static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
+static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
 	int ret = 1;
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->prot & IOMMU_CACHE)) {
+		if (!(domain->enforce_cache_coherency)) {
 			ret = 0;
 			break;
 		}
@@ -2641,7 +2649,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
-		return vfio_domains_have_iommu_cache(iommu);
+		return vfio_domains_have_enforce_cache_coherency(iommu);
 	default:
 		return 0;
 	}
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 1f930c0c225d94..bc39f633efdf03 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -539,7 +539,6 @@ struct dmar_domain {
 
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
-	u8 iommu_snooping: 1;		/* indicate snooping control feature */
 	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
-- 
2.35.1

