Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DBB5E68E6
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIVQ4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 12:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiIVQ4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 12:56:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED3BF2753
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 09:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+3yr5fvtgHf3tDY4b/vVREVn8qA2ZvZrhSA8SX9Thau7rE2yZqeomoEdeVVah8OYN1G+aqehpR+aKfNSb+cKkJL11eVwOOWGzL0NyUsS3fE3y9nH24C1FZlZ42upKQsEJPn7DmNBNAQR9N3yd/ocYaRLwQnErlLiHqjJYT45uNjVoIeMbfzUzHoQcRvITPMp6yNix9SQO4bDw21t21JXQr21krRNQ4edlpAxz7INdvg9FGRGvVLMscn2cZ4/jufxyduEjvedG5pnJRUp45ZuWc7jCwMeSaVvB9xwwpIZBKhO04B02O2SLialj6f73sO8GQFpE9ODZsiE+KiywLamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wISQaduZT9CIHF3lZuUmjVDVKFfSmsyiXhjd37q2cnA=;
 b=A1jy9ZOduFG4QmiVhc297t2Nt9Mev/kI6+nguzzmo3cSpQZz3xL9YeN0MY8k8lYbkph8aHfxKP9zRYTtyVGjBP0c4j5Ub1SWNpTwnhP4VMmcDpNh9O+f0d6sG641lLvKs2h9K+ALNEbvbv/NvrFv3grGVvrxdBi808CmLXSq6R3lQ+Hk1ALHl89O8GbvxtJmxBx7cnMO5f/hUge1v6Mvg6NPlTiz46tYW1Zstto3tOpK9FEsbrVNQLvyXvWrjr9B8poBmH2pkIaOBflBF4+rO4WxfXMAKmCMuQVQmWs9x7DEJllXrwC4ZZyK4aQeCPO4vtbVfv3G+8wCOoU5fzva9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wISQaduZT9CIHF3lZuUmjVDVKFfSmsyiXhjd37q2cnA=;
 b=RgjaXlKBihIvMmCAYRiAMB4xECVj+KsDC6SG+KW7BMoIDaLeu3Thr5z5l3HruBdUwIKueUcvJWoUm/MKtfYZhSRwKRz1OciZ+naqRXoG+Tc9IB6X+B/7E7+upYc0eXdf74yFOzcFF7e9M9k6Hj9qEFCvAJtpziRfozEi23AN9X2Y/MqyK34Okk415T8WxWJpeF77LuEwfyF7w1VwRNI9YoGMnotrocPyiPkjihGCzrduAH4ywM8zFmQvsuC/a59hWcCTyyk63DD1lKRRExKVMx31BErgNJL1oJM0hDmmRbWWgHuelOIgd/nwTfD9UMVg/SnDztV+/Pl7s3X5fp7EVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 16:56:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 16:56:40 +0000
Date:   Thu, 22 Sep 2022 13:56:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Message-ID: <YyyTxx0HnA3maxEk@nvidia.com>
References: <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
 <YxpiBEbGHECGGq5Q@nvidia.com>
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
 <Yxs+1s+MPENLTUpG@nvidia.com>
 <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com>
 <YxuGQDCzDsvKV2W8@nvidia.com>
 <b753aecb-ee2a-2cd0-1df2-0c3e977b4cb9@arm.com>
 <YxvQNTD1U4bs5TZD@nvidia.com>
 <2c66a30e-f96f-f11c-bb05-a5f4a756ab30@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c66a30e-f96f-f11c-bb05-a5f4a756ab30@arm.com>
X-ClientProxiedBy: BL0PR1501CA0022.namprd15.prod.outlook.com
 (2603:10b6:207:17::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ec4334-0851-4fcb-715e-08da9cbb6b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtfOpB15o9jOb+Q3kCImEcYBwDIM6wA6W9ZmoP/hlfaL7jANwXl96J7wsJmE38FHRKfWbEdC2/AKgff/pbgpaxzjlIqw0hqxB/U/pyej+5Nb+zUaQ1VmjyFvrPToBaqtCbqw/ItBt9/4SEtOcOkqxvYw7Eonxgwo3FKEPb8o6sy+E9tsryQwI88eC6is+l747UKiEjqX1AUGPLEHGw8sc6F7TEWu4oQ+2mnfC1rSXe8pcA06ZZL3TAr0S9tmHqZL16fJfjXT6F1Cy3eiHcsqiQdshTRWHxfWceR/kCQ1GvsSidx3Qi/HtbqJ1np6xmuGHE7JL9MDwOPoB31beTcUA1LYOwUqkx/1rGJWy1Ta+sVPHIvWE55WnzjMuH/YhX+yVSP5BSxsTVL/qJFUoCdx5g2ue+r7ZFRlvrAdtGvoMbDbxrUfO6o4XhYuageIOPRdmQLTPTz7yWBPdQM++RXNodCZkYopVV7RmRmcHZf7VWVP8Hr7pfmV4bQaDeL9ll8CYskdy3us7ldcxs9CFOAtbubOs2XHzhMGOIXJ1Rjq8dOn3zithANuX/tuqO5Pqpvi7JImptgwRO3m3vdH+6jcY1U7y5+XubnMVAnJ2tsm6fn5aV/mWlXkt+Yua+9Yf+XN/04s26IYCrMTjVw8vI1t2pUq2KQTMLKVbfFYFv5sxUjG5cehbroYLrhhZ8s65mGa2959z6019PC8pOqCVsCh9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(41300700001)(66946007)(66556008)(66476007)(8936002)(8676002)(4326008)(5660300002)(2906002)(7416002)(30864003)(6486002)(186003)(54906003)(6916009)(38100700002)(36756003)(2616005)(316002)(6512007)(26005)(6506007)(478600001)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xFM5MLGZwYUWbnvzARtnbkTGKS2Vn82vq0PokSMztS11vlbD2rLbkVDN1ipk?=
 =?us-ascii?Q?VIYFEZSHY7q7YwAiO2yAMa4ufAagPUbWuUnvEnjLR37HchdE1ixXDwMtiX9k?=
 =?us-ascii?Q?fjJ4EMAYYZy4y7PaZOVq55Jy2gVfPOVCu9qOE5o8jnnj45qyDtGZ6GGiZjdT?=
 =?us-ascii?Q?YVI5QzYbU2/smyr04kw+OHrGwVbQ8NQesTz7phPcA+IM2rmG/U/j8+rMhu2q?=
 =?us-ascii?Q?UtERtjcsxod2VylWMT2e6BPFAwG4gRYdOxnuBJ+Rv/AOEp0UGRmSgS7KAs2l?=
 =?us-ascii?Q?TzYwsyfcPx4lVLH1g8Uu/tIpw+1A/b7zf7zbTC3nXakUwhsw3XdMKoQd9j6T?=
 =?us-ascii?Q?vZ2AyydrDpOWtdPh4EV1ySDTv4bwC3nkEWK7Mu00sGN/tMEmS9+Cmzt3HhqN?=
 =?us-ascii?Q?r0ODGUp9UOI+FuPU1wfrdmHWk4l1xnP/nz74ppjL8dq827BtY+pjrTSl26/g?=
 =?us-ascii?Q?7CjKLk13H/wViHUZjFb7J5ZvjjMzG8K5qgvJz2m6STO7Y0PFEWVcjBFNDLpB?=
 =?us-ascii?Q?SSewfns/4QTUGctqynUMLfspxI32mjzq0gRD0cC9CPlx9yq/vuKODYdethEI?=
 =?us-ascii?Q?n3kP2u3oAZC7bb+Y6ecS+lnhZ24xJEe6vn94aGqFhJao8RYnMqX+Mwc0B2Dd?=
 =?us-ascii?Q?NWquXVqWzQGjSZ+5+pL4NEGlwwplS/RrUEntD/58S2Rk9DY1HGkfC/wM+h3a?=
 =?us-ascii?Q?a+YgQPmVbV4V1oordYnSzAdt4ReL8bCwpMxeg/TNjwhIVQKsodNJaoxT4rhL?=
 =?us-ascii?Q?pAcuxNL4uA3G0cXFdko0m24oxVj4iHNDk5ePZsqwl6cP0WnR5Wk/XfXfjYpN?=
 =?us-ascii?Q?3wxvFPAIlIPZqdc4hlAUgcRgrRVDBgOUdtFgX5Bp0YBlL0BBXnqtDcKD/HpB?=
 =?us-ascii?Q?BbTKT3zciZOZhUy8wMMz/tN4TQafPHBFlPDNNi5HvBdaQiJYb3Ytx0SoujVI?=
 =?us-ascii?Q?KtHh7Bdt6oKCGygYudd1tAE2Sl+JEJtQoxRehHaQqR7w/gdjtbJ36OoGpzVO?=
 =?us-ascii?Q?gMgC/jzkpBL5m7+v/VqtrxM9a8WJJROOLFROAZd5JHLVMotD/oYeXF4Ruk12?=
 =?us-ascii?Q?oYdwgdtHctKSDi8xjB2P23FPB0ob8tSREcws9i43LUCoaoFvDKE20EB/PPWB?=
 =?us-ascii?Q?oAN61zW2Cx0/sibFLTaPPpfQQW2XZIWkMoAXGqyF7nMEgLOy4RpXBapPfWbK?=
 =?us-ascii?Q?rXqDnqq01evTPLAYIShItZUaRsk7bORL4qsC6Gzu9e+/WugrcQQvXFsAocic?=
 =?us-ascii?Q?OBE3TL+SfF8ojuiS50iin02w1MF6aSZ99ZM1Q4rzWWltsJdoAKzyZOlFYWL3?=
 =?us-ascii?Q?iOw6msf0FhhPIL/j3B8DurAsSXYqN6XOb7e6XEEbqjZVLChB2TfYuAsnsktC?=
 =?us-ascii?Q?UrpoLISrwWoRU1E7T/MhMOCp+pofqs2OjypR2pmOMJtoT0JYzTplHOzzX317?=
 =?us-ascii?Q?XQAk7eiRu20pje1oSI6I3Je5hvRA2SYJD7VhGBkKNpCwAuoz4WSkSQTP4ACS?=
 =?us-ascii?Q?FPqVkPsJfowMJyn3HBKk7hCnJF39PUGyYF1INNDloZZGYpRCUULhj/ApRbYj?=
 =?us-ascii?Q?4jk4Z6I+LWAdr2EHsLsIU/IyQ5gjAHoOmkMGJqi3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ec4334-0851-4fcb-715e-08da9cbb6b89
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:56:40.6145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REl5vZq89wV8gkafVzw3VxwViHJ2Ff8nM7xTI+X6gZjPm5jy6hcNkaEtTeMMoh0s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 12, 2022 at 12:13:25PM +0100, Robin Murphy wrote:

> > > Yes, the ones documented in the code and already discussed here. The current
> > > functional ones aren't particularly *good* reasons, but unless and until
> > > they can all be cleaned up they are what they are.
> > 
> > Uh, I feel like I missed part of the conversation - I don't know what
> > this list is..
> 
> s390 (remember how we got here?) calls iommu_get_domain_for_dev().

iommu_get_domain_for_dev() doesn't take a lock, and the last try I
showed (see below) ordered things so that it would succeed when called
under release(). AFIACT it is already not a problem.

> ipmmu-vmsa calls arm_iommu_detach_device() (mtk_v1 doesn't, but perhaps
> technically should), to undo the corresponding attach from probe_finalize -
> apologies for misremembering which way round the comments were.

This does eventually deadlock on the group->mutex, so yes this is a
problem!

And I agree mtk_v1 does looks like it has a memory leak.

But, this looks easy enough to fix up. See below

> Oh, apparently I managed to misinterpret this as the two *aliasing* devices
> case, sorry. Indeed it is overly conservative for that. I think the robust
> way to detect bad usage is actually not via the group at all, but for
> iommu_device_{un}use_default_domain() to also maintain a per-device
> ownership flag, then we warn if a device is released with that still set.

It seems a bit hard to implement a per-device flag with VFIO?

> > > (It *will* actually work on SMMUv2 because SMMUv2 comprehensively handles
> > > StreamID-level aliasing beyond what pci_device_group() covers, which I
> > > remain rather proud of)
> > 
> > This is why I prefered not to explicitly change the domain, because at
> > least if someone did write a non-buggy driver it doesn't get wrecked -
> > and making a non-buggy driver is at least allowed by the API.
> 
> Detaching back to the default domain still seems like it's *always* the
> right thing to do at this point, 

If the RID is aliased it is the wrong thing to do. Calling attach will
wreck the entire alias set.

release is not supposed to do that, buggy drivers excepted.

> Having looked a bit closer, I think I get what PAMU is doing - kind of
> impedance-matching between pci_device_group() and its own non-ACS form of
> isolation, and possibly also a rather roundabout way of propagating DT data
> from the PCI controller node up into the PCI hierarchy. Both could quite
> likely be done in a more straightforward manner these days (and TBH I'm not
> convinced it works at all since it doesn't appear to match the actual DT
> binding), but either way I'm fairly confident we needn't worry about it.

Yes, this is what I thought too. Arguably it is wrong to try and
rework the groups once created, it should be creating the groups to
cover what it wants from the start, and it shouldn't leave the
controller without a group.

So something like the below is what I'm thinking

Thanks,
Jason

diff --git a/arch/arm/include/asm/dma-iommu.h b/arch/arm/include/asm/dma-iommu.h
index fe9ef6f79e9cfe..ea7198a1786186 100644
--- a/arch/arm/include/asm/dma-iommu.h
+++ b/arch/arm/include/asm/dma-iommu.h
@@ -31,6 +31,7 @@ void arm_iommu_release_mapping(struct dma_iommu_mapping *mapping);
 int arm_iommu_attach_device(struct device *dev,
 					struct dma_iommu_mapping *mapping);
 void arm_iommu_detach_device(struct device *dev);
+void arm_iommu_release_device(struct device *dev);
 
 #endif /* __KERNEL__ */
 #endif
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 089c9c644cce2a..1694bebb3aa4dc 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1697,13 +1697,15 @@ int arm_iommu_attach_device(struct device *dev,
 EXPORT_SYMBOL_GPL(arm_iommu_attach_device);
 
 /**
- * arm_iommu_detach_device
+ * arm_iommu_release_device
  * @dev: valid struct device pointer
  *
- * Detaches the provided device from a previously attached map.
- * This overwrites the dma_ops pointer with appropriate non-IOMMU ops.
+ * This is like arm_iommu_detach_device() except it handles the special
+ * case of being called under an iommu driver's release operation. In this
+ * case the driver must have already detached the device from any attached
+ * domain before calling this function.
  */
-void arm_iommu_detach_device(struct device *dev)
+void arm_iommu_release_device(struct device *dev)
 {
 	struct dma_iommu_mapping *mapping;
 
@@ -1713,13 +1715,34 @@ void arm_iommu_detach_device(struct device *dev)
 		return;
 	}
 
-	iommu_detach_device(mapping->domain, dev);
 	kref_put(&mapping->kref, release_iommu_mapping);
 	to_dma_iommu_mapping(dev) = NULL;
 	set_dma_ops(dev, NULL);
 
 	pr_debug("Detached IOMMU controller from %s device.\n", dev_name(dev));
 }
+EXPORT_SYMBOL_GPL(arm_iommu_release_device);
+
+/**
+ * arm_iommu_detach_device
+ * @dev: valid struct device pointer
+ *
+ * Detaches the provided device from a previously attached map.
+ * This overwrites the dma_ops pointer with appropriate non-IOMMU ops.
+ */
+void arm_iommu_detach_device(struct device *dev)
+{
+	struct dma_iommu_mapping *mapping;
+
+	mapping = to_dma_iommu_mapping(dev);
+	if (!mapping) {
+		dev_warn(dev, "Not attached\n");
+		return;
+	}
+
+	iommu_detach_device(mapping->domain, dev);
+	arm_iommu_release_device(dev);
+}
 EXPORT_SYMBOL_GPL(arm_iommu_detach_device);
 
 static void arm_setup_iommu_dma_ops(struct device *dev, u64 dma_base, u64 size,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 780fb70715770d..61444b2a11e217 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -90,6 +90,10 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 static ssize_t iommu_group_store_type(struct iommu_group *group,
 				      const char *buf, size_t count);
+static struct group_device *
+__iommu_group_remove_device(struct iommu_group *group, struct device *dev);
+static void __iommu_group_remove_device_sysfs(struct iommu_group *group,
+					      struct group_device *device);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -330,18 +334,50 @@ int iommu_probe_device(struct device *dev)
 
 void iommu_release_device(struct device *dev)
 {
+	struct iommu_group *group = dev->iommu_group;
 	const struct iommu_ops *ops;
+	struct group_device *device;
 
 	if (!dev->iommu)
 		return;
 
 	iommu_device_unlink(dev->iommu->iommu_dev, dev);
 
+	mutex_lock(&group->mutex);
+	device = __iommu_group_remove_device(group, dev);
 	ops = dev_iommu_ops(dev);
+
+	/*
+	 * If the group has become empty then ownership must have been released,
+	 * and the current domain must be set back to NULL or the default
+	 * domain.
+	 */
+	if (list_empty(&group->devices))
+		WARN_ON(group->owner_cnt ||
+			group->domain != group->default_domain);
+
+	/*
+	 * release_device() must stop using any attached domain on the device.
+	 * If there are still other devices in the group they are not effected
+	 * by this callback.
+	 *
+	 * The IOMMU driver must set the device to either an identity or
+	 * blocking translation and stop using any domain pointer, as it is
+	 * going to be freed.
+	 */
 	if (ops->release_device)
 		ops->release_device(dev);
+	mutex_unlock(&group->mutex);
+
+	__iommu_group_remove_device_sysfs(group, device);
+
+	/*
+	 * This will eventually call iommu_group_release() which will free the
+	 * iommu_domains.
+	 */
+	dev->iommu_group = NULL;
+	kobject_put(group->devices_kobj);
 
-	iommu_group_remove_device(dev);
 	module_put(ops->owner);
 	dev_iommu_free(dev);
 }
@@ -939,44 +975,71 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_group_add_device);
 
-/**
- * iommu_group_remove_device - remove a device from it's current group
- * @dev: device to be removed
- *
- * This function is called by an iommu driver to remove the device from
- * it's current group.  This decrements the iommu group reference count.
- */
-void iommu_group_remove_device(struct device *dev)
+static struct group_device *
+__iommu_group_remove_device(struct iommu_group *group, struct device *dev)
 {
-	struct iommu_group *group = dev->iommu_group;
-	struct group_device *tmp_device, *device = NULL;
+	struct group_device *device;
+
+	lockdep_assert_held(&group->mutex);
 
 	if (!group)
-		return;
+		return NULL;
 
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
-	mutex_lock(&group->mutex);
-	list_for_each_entry(tmp_device, &group->devices, list) {
-		if (tmp_device->dev == dev) {
-			device = tmp_device;
+	list_for_each_entry(device, &group->devices, list) {
+		if (device->dev == dev) {
 			list_del(&device->list);
-			break;
+			return device;
 		}
 	}
-	mutex_unlock(&group->mutex);
+	return NULL;
+}
 
+static void __iommu_group_remove_device_sysfs(struct iommu_group *group,
+					      struct group_device *device)
+{
 	if (!device)
 		return;
 
 	sysfs_remove_link(group->devices_kobj, device->name);
-	sysfs_remove_link(&dev->kobj, "iommu_group");
+	sysfs_remove_link(&device->dev->kobj, "iommu_group");
 
-	trace_remove_device_from_group(group->id, dev);
+	trace_remove_device_from_group(group->id, device->dev);
 
 	kfree(device->name);
 	kfree(device);
-	dev->iommu_group = NULL;
+}
+
+/**
+ * iommu_group_remove_device - remove a device from it's current group
+ * @dev: device to be removed
+ *
+ * This function is used by non-iommu drivers to create non-iommu subystem
+ * groups (eg VFIO mdev, SPAPR) Using this from inside an iommu driver is an
+ * abuse. Instead the driver should return the correct group from
+ * ops->device_group()
+ */
+void iommu_group_remove_device(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+	struct group_device *device;
+
+	/*
+	 * Since we don't do ops->release_device() there is no way for the
+	 * driver to stop using any attached domain before we free it. If a
+	 * domain is attached while this function is called it will eventually
+	 * UAF.
+	 *
+	 * Thus it is only useful for cases like VFIO/SPAPR that don't use an
+	 * iommu driver, or for cases like FSL that don't use default domains.
+	 */
+	WARN_ON(group->domain);
+
+	mutex_lock(&group->mutex);
+	device = __iommu_group_remove_device(group, dev);
+	mutex_unlock(&group->mutex);
+	__iommu_group_remove_device_sysfs(group, device);
 	kobject_put(group->devices_kobj);
 }
 EXPORT_SYMBOL_GPL(iommu_group_remove_device);
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 1d42084d02767e..f5b9787d22420c 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -302,11 +302,8 @@ static void ipmmu_utlb_enable(struct ipmmu_vmsa_domain *domain,
 /*
  * Disable MMU translation for the microTLB.
  */
-static void ipmmu_utlb_disable(struct ipmmu_vmsa_domain *domain,
-			       unsigned int utlb)
+static void ipmmu_utlb_disable(struct ipmmu_vmsa_device *mmu, unsigned int utlb)
 {
-	struct ipmmu_vmsa_device *mmu = domain->mmu;
-
 	ipmmu_imuctr_write(mmu, utlb, 0);
 	mmu->utlb_ctx[utlb] = IPMMU_CTX_INVALID;
 }
@@ -649,11 +646,11 @@ static void ipmmu_detach_device(struct iommu_domain *io_domain,
 				struct device *dev)
 {
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
-	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
+	struct ipmmu_vmsa_device *mmu = to_ipmmu(dev);
 	unsigned int i;
 
 	for (i = 0; i < fwspec->num_ids; ++i)
-		ipmmu_utlb_disable(domain, fwspec->ids[i]);
+		ipmmu_utlb_disable(mmu, fwspec->ids[i]);
 
 	/*
 	 * TODO: Optimize by disabling the context when no device is attached.
@@ -849,7 +846,8 @@ static void ipmmu_probe_finalize(struct device *dev)
 
 static void ipmmu_release_device(struct device *dev)
 {
-	arm_iommu_detach_device(dev);
+	ipmmu_detach_device(NULL, dev);
+	arm_iommu_release_device(dev);
 }
 
 static struct iommu_group *ipmmu_find_group(struct device *dev)
