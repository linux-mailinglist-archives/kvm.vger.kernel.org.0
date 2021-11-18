Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A76E455DA2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhKRONr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:13:47 -0500
Received: from mail-mw2nam08on2050.outbound.protection.outlook.com ([40.107.101.50]:2209
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232755AbhKRONq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 09:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gboQ7zEH4Y9/of8hi4qTOD3gjgH421JHIPRE4m2eOx4C3aXH9/utqOdmQ3+kIkDavfKmYHZInFViSw8cGGWnBFNhYg4ZHM4foZKDIzebtyE6qdw6MmSIDxb3gyBdcZL4lCi/zN3ZS2iLpOyYXeSa5Uk5tn18hTJ4PauzT23o22HFzM/4YiuoyLelvQtMYMFobHa5urPeYrGaXcc2YjZ9ZFWBWM8zDKh9l+APdMokRlJuxIAJ0CBroj2LvHzD7wtT2+CoCKnA7eTKesFJ0N57YyaZnsE3eiLZ4peG3LUmEYprjhN8WIJZglIohDtiRf2SU5P9ZrfPFnCF2Om6u4YZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wyvl5VrB9EF5QNM5r2cu110++BKPmiyNL6ktv8ajluk=;
 b=izC+j5ELpsloDkD5pLadWsvj73GCHZo1LOsAmBYKfe38IFFh2BiVJlva6wZeitsYeDHlrWpz6AvXn9hkknDN6mflOtY+Q/k+Ndyu50OdLHyi0TOpftpBr82kPAS0ojQyJQqWK8XmIJ7l9xIFXemuDLKONBH4scT3FR6PCOPMTz+iXiEaJbFEknvD+LMY65nYrUz4ORvfcJgk6baMVmXmSzwwCwKE0Jjn2XEs5VSIfRY3spyBO8ZwAAEIHtMHWFbiUuXOsWbdxtmsMLtCK4IMsO6HucgoHUN3Y4/raMOjQyU46KZVoivhkkM4RHzLjLb/xDjPnNrxP6B38wrRcmf6tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyvl5VrB9EF5QNM5r2cu110++BKPmiyNL6ktv8ajluk=;
 b=HvbfLGTTIRuZBWt0Nyw6TXt/Bj+ll0XbvTrQjG363DaqnJhTrdmll1OwXf1c0oL62bIZJg7SfhP64nZqNBSGyHzvfPQqDpqBtHv+8F5vGbWMELXpEN3KIEmDxP/QqRrlF7TuWEyLhWVMM1iFo45HO/QV6mI+E1VRX4daPgkr5h25g319RGRuDmd06/UrYQSuVpK3CCHBINnCGa1qKPZfAd/dx+gAnPGOBfmoEKTYXv5OEuXllb7x35X1G/LRq9GexodX+KvBUPiH69DnfYtZ8C2izaN0NaLzllYwJx8Yd50p8Fj8ADrtutCv3VQi3nxrEsu4UeQZ6bROmO1gBkso9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5335.namprd12.prod.outlook.com (2603:10b6:208:317::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 14:10:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 14:10:44 +0000
Date:   Thu, 18 Nov 2021 10:10:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211118141043.GQ2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <d79acc01-eeaf-e6ac-0415-af498c355a00@linux.intel.com>
 <20211117133517.GJ2105516@nvidia.com>
 <5901c54b-a6eb-b060-aa52-15de7708d703@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5901c54b-a6eb-b060-aa52-15de7708d703@linux.intel.com>
X-ClientProxiedBy: MN2PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:208:23d::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR06CA0028.namprd06.prod.outlook.com (2603:10b6:208:23d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 14:10:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mni7f-00Bnpw-3z; Thu, 18 Nov 2021 10:10:43 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2cdf780-0f16-4cad-6a2b-08d9aa9d35ef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5335:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53355D0D937358614F1A2971C29B9@BL1PR12MB5335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xt/WOd12QUyRM3/OHMzvobfyqTVTv6UvOEwHRAGhOCGSnxnUS5noMi8PzYJo8l7W8B8tSLubfdRLZhiPigEXUpAlmcYBFdcXKYdI2I8YznZf/nd4ksT3O/VHFYbW9B+dMh9lbx5T/hePsVacAxtk7JzxKjhXtAuz8ZHtaovUe1JGUScmQFxPciz2rZqkDTvIZnIg3nCPZtddAb38OdbC2MkpnmbaJerjqd4KtV+DW00gEa/6vqfwgcbq3UKUIHCjKiVKjd3gJhhv2vS5lh5euORI1FtpzTLISM9hCM3y2PRvD81HftNDLY1ilR9exzKhktQLIj8rqSoPltFmlvMDGYp9rFOUMPniBznw9jexshBhqsh2j0vxZFK/A+JPKGWwcWsaDg9h+4HEFNtwcrhzgwWDZtb1UVu/60L0zRHXEOuOg/GVRwL7Rqc2Rs6fSwAK4d8G1Cz7j+N392phfP+vHgRruP2MjyKi0bc8F0zi7C8pD3w8P4gprzurASaL6an28zk6enWQD2Tvfn/MrbcssIm5klaMGAPN5aUQimBO9HJ3wlDPADd94zYRsvG8s9Z0d3XQUdvNSnzr+mtYR8JlwwhllGLhF2BVGR9Gz7fhsJHLTZiAblvX59uvejv5P8dP3mf+YRI3iRHhFv0PTgEPHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(26005)(66946007)(66556008)(9746002)(7416002)(1076003)(86362001)(8936002)(66476007)(33656002)(4326008)(9786002)(2906002)(8676002)(6916009)(508600001)(54906003)(316002)(426003)(38100700002)(5660300002)(36756003)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m16/FK2Tf9cXUfWn+4IIh4AQSD3uR8VaJDftjfcHTnc8xxFW12DAXnQAVW4R?=
 =?us-ascii?Q?FJXjB/HVTzGPlVApThJWGIBR1Ivynn593LS5QBVt84tqVnRr/k6aw/yGed2x?=
 =?us-ascii?Q?MuMZZtxjrhLmYg8kbPoLIFdKKbPVZbg1++zol0Lh9HmH1O4mQLdVsDlIj1GD?=
 =?us-ascii?Q?XILBkrtKd/SSnoe2cm4Mn6IlPy4h3nXtCJ3eyIZ3yvMHBei+mq8sk32gj+G2?=
 =?us-ascii?Q?vCrOu1xZ4OKj57CRdj79g9Q+lft3LEf/4fXgb8xdSGAthc0TN8O+9x79WZp+?=
 =?us-ascii?Q?BWXVhUgnHeixIZw/w4ySmk0lKoPVxyuLGkCxqJ51j6mXpaBQidwSUlkLN2Vc?=
 =?us-ascii?Q?AbyIbkQgo6G7+bPsRp8kBmsejVM4oBRljq6i7hqHUfXo+l6KMsFn/1C2WyE2?=
 =?us-ascii?Q?uejAcDNmKXrNhLFP9baHwGfDnjTN5owQbz3/T3lid1fUZ3QjLWINt+Qfuqg7?=
 =?us-ascii?Q?3CiG45ujI3pnom7Ojy6QrUmaC1cmU5VISGWjl6UE+8C0P5P4ZhRtgNZoDYAP?=
 =?us-ascii?Q?Qy3lFALw0zIhKOC9Js1B/czwq5CpkRiXiC5ui96jqatyNDvQai3pH6DTwCHu?=
 =?us-ascii?Q?r7K/pJw1UAj8rK11BD5M4+jSRPx1sK/iMdfedYmov0Ye3RMF3ivazY7yZOsG?=
 =?us-ascii?Q?oUDBzr7DDn+046DN7OMct8rsGFKwfxCtItPkMgxnynNkw2e234o7Tc2pQLHs?=
 =?us-ascii?Q?dw/GTn1WIh9Hg3woWi1RMMN6iylz2bMurTd+CZzL+UjT6xuu2BLCVybfWRO9?=
 =?us-ascii?Q?mi3zk2M84RVSaq3+ALn9j9KOkwMxUBHRWL6KH7qP5+rYQ18I7VfSel2dkCqY?=
 =?us-ascii?Q?duQndD78a7Iq5W0TfURWBPk5Q2m13vjbNCq2JtFJ0jRGEAvdlyCP2Iwx2EpX?=
 =?us-ascii?Q?oDDpReABvZUNcqqgSjM0dhSUNdMRaN7vWADAo7pZ0fwosnnoDBWMdiTZ0vcA?=
 =?us-ascii?Q?P12CkCVvFZdStzGB3UK8FBIyzlb+J2eTExw7yOGa7LXBIawhLHwZltWEzdEi?=
 =?us-ascii?Q?cxxmn1KN6zNCbB5u074Zh4K2pQvM91ZPe5anp+/4vQZsHT9pp7FvQiEfrqqp?=
 =?us-ascii?Q?sB+UmpIXi4E+rUzFzskG0UQUhD/wjJG5w1eJGBbSjATM5JXVxPJgS8apQvUg?=
 =?us-ascii?Q?ZNc4UcKdl8ij8K/kwjfvqI2lqkhODJb/mBQwLWcE5C8pDCtSGctwMz0dJnd9?=
 =?us-ascii?Q?mZNYy7aK1AqSAeIHEO/s6ZUQWSHDQnw5MJIFemCEWdK5H0fr7IYyetkaptPl?=
 =?us-ascii?Q?mC9e/bJYkDo4QjN7zSeBi5iXo44uyGrb3GqXqH63tIXHDQvVYXVyJrjbC/R+?=
 =?us-ascii?Q?wkn/NecsBe/iL9wgX6cm6lKLtIng09k2H00SGlvEzuMxAzgYiZ6rsjp0fF5s?=
 =?us-ascii?Q?+1Eu8SIWA34LOSgmJzwWvkKaG9bN1Cq/HHIBF0GO73pKcO+K/4Now5vH1/UD?=
 =?us-ascii?Q?LegYJpJ+2X4fswBPsMyTgqAreBgtdD7WH3vObCNZG1GAjm7xbOx31kkGbAXI?=
 =?us-ascii?Q?X1fLA4ZwjiOJa5SMbzTxege1J5o4jSIptYFS/N7DMsO1kYo7IRL+BL3coWuy?=
 =?us-ascii?Q?LnQthP2BBNlrsU3MfLQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cdf780-0f16-4cad-6a2b-08d9aa9d35ef
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 14:10:44.3545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCw3Th6oM1WFmyApqD/q5kQf4195ft8eN6oaVzhAmjImGEGLAm5y7HuTwLLH2VHW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5335
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 09:12:41AM +0800, Lu Baolu wrote:
> The existing iommu_attach_device() allows only for singleton group. As
> we have added group ownership attribute, we can enforce this interface
> only for kernel domain usage.

Below is what I came up with.
 - Replace the file * with a simple void *

 - Use owner_count == 0 <-> dma_owner == DMA_OWNER to simplify
    the logic and remove levels of indent

 - Add a kernel state DMA_OWNER_PRIVATE_DOMAIN

 - Rename the user state to DMA_OWNER_PRIVATE_DOMAIN_USER

   It differs from the above because it does extra work to keep the
   group isolated that kernel users do no need to do.
 
 - Rename the kernel state to DMA_OWNER_DMA_API to better reflect
   its purpose. Inspired by Robin's point that alot of this is
   indirectly coupled to the domain pointer.

 - Have iommu_attach_device() atomically swap from DMA_OWNER_DMA_API
   to DMA_OWNER_PRIVATE_DOMAIN - replaces the group size check.

When we figure out tegra we can add an WARN_ON to iommu_attach_group()
that dma_owner != DMA_OWNER_NONE || DMA_OWNER_DMA_API

Then the whole thing makes some general sense..

Jason

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 064d0679906afd..4cafe074775e30 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -49,7 +49,7 @@ struct iommu_group {
 	struct list_head entry;
 	enum iommu_dma_owner dma_owner;
 	refcount_t owner_cnt;
-	struct file *owner_user_file;
+	void *owner_cookie;
 };
 
 struct group_device {
@@ -1937,12 +1937,18 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 	 * change while we are attaching
 	 */
 	mutex_lock(&group->mutex);
-	ret = -EINVAL;
-	if (iommu_group_device_count(group) != 1)
+	if (group->dma_owner != DMA_OWNER_DMA_API ||
+	    refcount_read(&group->owner_cnt) != 1) {
+		ret = -EBUSY;
 		goto out_unlock;
+	}
 
 	ret = __iommu_attach_group(domain, group);
+	if (ret)
+		goto out_unlock;
 
+	group->dma_owner = DMA_OWNER_PRIVATE_DOMAIN;
+	group->owner_cookie = domain;
 out_unlock:
 	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
@@ -2193,14 +2199,11 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 		return;
 
 	mutex_lock(&group->mutex);
-	if (iommu_group_device_count(group) != 1) {
-		WARN_ON(1);
-		goto out_unlock;
-	}
-
+	WARN_ON(group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN ||
+		refcount_read(&group->owner_cnt) != 1 ||
+		group->owner_cookie != domain);
+	group->dma_owner = DMA_OWNER_DMA_API;
 	__iommu_detach_group(domain, group);
-
-out_unlock:
 	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
 }
@@ -3292,44 +3295,33 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 static int __iommu_group_set_dma_owner(struct iommu_group *group,
 				       enum iommu_dma_owner owner,
-				       struct file *user_file)
+				       void *owner_cookie)
 {
-	if (group->dma_owner != DMA_OWNER_NONE && group->dma_owner != owner)
-		return -EBUSY;
-
-	if (owner == DMA_OWNER_USER) {
-		if (!user_file)
-			return -EINVAL;
-
-		if (group->owner_user_file && group->owner_user_file != user_file)
-			return -EPERM;
+	if (refcount_inc_not_zero(&group->owner_cnt)) {
+		if (group->dma_owner != owner ||
+		    group->owner_cookie != owner_cookie) {
+			refcount_dec(&group->owner_cnt);
+			return -EBUSY;
+		}
+		return 0;
 	}
 
-	if (!refcount_inc_not_zero(&group->owner_cnt)) {
-		group->dma_owner = owner;
-		refcount_set(&group->owner_cnt, 1);
-
-		if (owner == DMA_OWNER_USER) {
-			/*
-			 * The UNMANAGED domain shouldn't be attached before
-			 * claiming the USER ownership for the first time.
-			 */
-			if (group->domain) {
-				if (group->domain != group->default_domain) {
-					group->dma_owner = DMA_OWNER_NONE;
-					refcount_set(&group->owner_cnt, 0);
-
-					return -EBUSY;
-				}
-
-				__iommu_detach_group(group->domain, group);
-			}
-
-			get_file(user_file);
-			group->owner_user_file = user_file;
+	/*
+	 * We must ensure that any device DMAs issued after this call
+	 * are discarded. DMAs can only reach real memory once someone
+	 * has attached a real domain.
+	 */
+	if (owner == DMA_OWNER_PRIVATE_DOMAIN_USER) {
+		if (group->domain) {
+			if (group->domain != group->default_domain)
+				return -EBUSY;
+			__iommu_detach_group(group->domain, group);
 		}
 	}
 
+	group->dma_owner = owner;
+	group->owner_cookie = owner_cookie;
+	refcount_set(&group->owner_cnt, 1);
 	return 0;
 }
 
@@ -3339,20 +3331,18 @@ static void __iommu_group_release_dma_owner(struct iommu_group *group,
 	if (WARN_ON(group->dma_owner != owner))
 		return;
 
-	if (refcount_dec_and_test(&group->owner_cnt)) {
-		group->dma_owner = DMA_OWNER_NONE;
+	if (!refcount_dec_and_test(&group->owner_cnt))
+		return;
 
-		if (owner == DMA_OWNER_USER) {
-			fput(group->owner_user_file);
-			group->owner_user_file = NULL;
+	group->dma_owner = DMA_OWNER_NONE;
 
-			/*
-			 * The UNMANAGED domain should be detached before all USER
-			 * owners have been released.
-			 */
-			if (!WARN_ON(group->domain) && group->default_domain)
-				__iommu_attach_group(group->default_domain, group);
-		}
+	/*
+	 * The UNMANAGED domain should be detached before all USER
+	 * owners have been released.
+	 */
+	if (owner == DMA_OWNER_PRIVATE_DOMAIN_USER) {
+		if (!WARN_ON(group->domain) && group->default_domain)
+			__iommu_attach_group(group->default_domain, group);
 	}
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d8946f22edd5df..7f50dfa7207e9c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -164,14 +164,21 @@ enum iommu_dev_features {
 
 /**
  * enum iommu_dma_owner - IOMMU DMA ownership
- * @DMA_OWNER_NONE: No DMA ownership
- * @DMA_OWNER_KERNEL: Device DMAs are initiated by a kernel driver
- * @DMA_OWNER_USER: Device DMAs are initiated by a userspace driver
+ * @DMA_OWNER_NONE:
+ *  No DMA ownership
+ * @DMA_OWNER_DMA_API:
+ *  Device DMAs are initiated by a kernel driver through the DMA API
+ * @DMA_OWNER_PRIVATE_DOMAIN:
+ *  Device DMAs are initiated by a kernel driver
+ * @DMA_OWNER_PRIVATE_DOMAIN_USER:
+ *  Device DMAs are initiated by userspace, kernel ensures that DMAs
+ *  never go to kernel memory.
  */
 enum iommu_dma_owner {
 	DMA_OWNER_NONE,
-	DMA_OWNER_KERNEL,
-	DMA_OWNER_USER,
+	DMA_OWNER_DMA_API,
+	DMA_OWNER_PRIVATE_DOMAIN,
+	DMA_OWNER_PRIVATE_DOMAIN_USER,
 };
 
 #define IOMMU_PASID_INVALID	(-1U)
