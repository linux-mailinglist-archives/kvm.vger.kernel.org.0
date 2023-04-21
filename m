Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623EB6EA9EE
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjDUMEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 08:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjDUMEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 08:04:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FAF4C0E
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:04:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcRoM1nPVIiKv5573wAxVoJ68keEHVAHPA9btTnt1MTyk2rYr+pSCY/9HTNGqOjHhbygUJGp17hgbCb18ewk1Dt9vHmlr2klEjNyErO5zsUOmj1Yn8gavyn4VEkSNmje3lHWElk27JR6B5QeGeKBZQu/qZoowijIEyGcaouKU3sExqK7j68h6UeUMu4FyDktyoX0g80huzNixaD/yPuyq26Qr+n4N2M9xmJTnCLOKVZIlIzHtQbYq7POcpaWOwupG//je+aYOr/n80chzr4QM7aTjnijlneGeU34yxDEBC6NULcGMiNxPLOkmR/xWC6SqynO8yvd4XB1/j7o7YVAmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BN1mAeVG99qv56c3ucjCfOjWqXLWhIXNO89RHcaxaOc=;
 b=ZEz59jvnN5aOQy4QijSdl+X+U/oUmeS2ADcVZD/i+X7ERR4S4TecE0TFgtsT8hbNzG0i4i4lx/n/yOQ/b9m8hYVslWG+6178gnmTsjsVhqfgjQ/QRFRquV2OaF+NveNF4fNoCuOHsyZiMlRMBRUssVV2SKwF8WW+XhJF/kswers9nvc2AsGW29cFBPL+oVfSE7THR7fejuO/xao0SUmwfsd/FKOuoSKnHMV08Fo271BnTBOAXro8KjBm8BDL0lh6AyLaXzjc+ZNRSS8zndeTJYvn60E1GZ0JsQysahzFnWgCoY8NnTRim0ECWN3QhxVYuovYdz27lj5IfL5ny5xmvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BN1mAeVG99qv56c3ucjCfOjWqXLWhIXNO89RHcaxaOc=;
 b=JgV2eov6meyZZqHxvNPfEu8D1FHcW+JdDPtz0C3MatuiXQyXk08k9rxfK1402V5Odzv3xT2VG7GOWZLYMdPO3IVPRiucSTZDPcwKBIrQ+Kd2NkhBNUmCsIoum0lsZ/F5UMeE+5IHhPEYosP2/IUVA3I+lL9JaUn7CKED1n5RGLhWv/t8k656QcOeUnfZxJjRCbIDz+iZGnwH7on4frynlezatLUK3m4nPhUnbn+DMaqd7LTskcLNkY9ogL9n/WQwyERm3QQHlDruyKcGWwvgVv5MDtzZEn3+9ncGaNH7qSbgXaR4SyAtZpAu+rqrG3OdJA7YXL98TKBY+q2mUaH5ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8825.namprd12.prod.outlook.com (2603:10b6:510:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 12:04:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 12:04:48 +0000
Date:   Fri, 21 Apr 2023 09:04:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEJ73s/2M4Rd5r/X@nvidia.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420154933.1a79de4e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:208:d4::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8825:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2d9226-f635-41b1-f0ae-08db42609aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpQVBEYPb8bGmQhHbI2MgDBrREInKZBZTgcNXW3WKZ4HiG+4Ia8Jp/vQWjGYVM3R+o0+Xchob9poXOZKYvXoNXxMsX1Sg6Q0FfJByvYFfJ6JRv4AjlQ8yLgkkkdf+p5SOosG86y2Kkf9mv8/Hs4f9ury9klaSZykKpGFUFL2vMdQa5nlpiVGeTkWvgys+Avg5/fcuMsO42pEWqWUbzCM9ODFiJYzoHOQvUn+/eCIUgsopWdIbwJ5FxZQjet1hmLl54A2V3Ex6GVSg08KUTl0IAW1rd5sVBxIQYNy7AgNlyKk+Qhj2g6WmX6U/jR6FvM63OBtQvV3Wy5LaLAlChOS2LVrlQg9z5Xqx5zNHsFkIb7HxUXPtW2gGA4fxy9/OZXjW7ziXlz574Oks7kBUc0gF7EMoMFqh3owaJZgDOIEtxaZzHkl4Xn1JEJ8wZB5C+LDyzwnya2fQd0YOrSR062DjjdHh/2QhsqRF2P+WLSS/8BKpocrG4kia3EzhnLeT8YOFYFpvbBvCt+0tn65xhF5r6hWzOlAWWS2iVzOtKz49XHBFQziAlecZLNzJJkqSGl1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(66899021)(6916009)(316002)(66476007)(54906003)(66946007)(66556008)(4326008)(6512007)(6506007)(26005)(186003)(38100700002)(2616005)(83380400001)(41300700001)(8676002)(5660300002)(8936002)(478600001)(6486002)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9KUzU48C31TAz1hh+DDXhRrRBW7ap3eHwfLkVwwDmb/jw29G1uKNiFVD6ZRZ?=
 =?us-ascii?Q?sLvtWKdtFY1Jptjxd3aCfyu84mT06HnFpC+yByTfZaxrHg/YIDBRTd5e2tA0?=
 =?us-ascii?Q?feGXyknBWl4txT7sWCfoyP0WUYj0uw0joL8TimrrU82jZFkdgMzqOzk15AN5?=
 =?us-ascii?Q?H+3nwVgs4wyJC3ya2nRIGf/6RDGZ2LJjW3JB162bO0cRdZA0SzIXjlUwLmhv?=
 =?us-ascii?Q?8o7rtQJNRRen6vU9IsIM1vJ+cA0SdZmOsi0WCWiKpPaQccTD26mhkOZtMX/+?=
 =?us-ascii?Q?JWHUlykJOQzjB1RnS1aviqxfBd1YckXBxi4u3NwcPwCDY2Ex4V77OFbF398u?=
 =?us-ascii?Q?AuBFXFUiU0+0aRhcEM5sWIKod0YS4vA31unc0Dxw/FIvPc4N4qZM2foiaTD/?=
 =?us-ascii?Q?NjvURdxnDchXvz1+enk0aFzRpqm7MuOSy+NFs94fiPFIH4q5WgL2tgN4pkJT?=
 =?us-ascii?Q?gyeKAJAS1CtK4fLOAmhJuIuJKO2HQFWIoAU8jXp9E/nIQ6ERppsx6NAcQgwU?=
 =?us-ascii?Q?esJCswBalyWDoE4UY9C+/Wv1RblFUqnOLj/UiLQpvd8X0h+NefWGAspgJzeI?=
 =?us-ascii?Q?VByqjJrAmRbtgJkvmpeUtoRYdAODWoGqqBMiEUqGQi8ywoK5b4scEGtOFG3a?=
 =?us-ascii?Q?Pf/4UCR0Rw5AnDAmoRoFmgS5RvJnqU6p3Xd6KCe7NYafHLt55G1nFfAVzrlZ?=
 =?us-ascii?Q?EVtOwUM5msBBzIi3Is/N8SiJxlVndP6cD51N/S+d4xPwmHOlKNP1Z5xbFCsa?=
 =?us-ascii?Q?5zJ0BYi2sxF37OHWtJIRTFj6L+laalgcHoV08+VU87z/E8gHwzob/8xdDTSe?=
 =?us-ascii?Q?YPIuKazjahYcpE1usarGdTYPVAgcN2QOgr7QC5O8O2lymdHolyamzYFg2vUe?=
 =?us-ascii?Q?m90rGnKFxVWhuwcVS8o3iyDuCJwYq3RtwkGbxHSz2Q99CBGXskJDUvuDOY6O?=
 =?us-ascii?Q?19LhytZ1GamLLuO83K94Sy/Ld4bC8kCPQeBOUH1QMsSpcIfsWpNbeRPz8hUH?=
 =?us-ascii?Q?FF57w5u7eh72yNaxQRx3xXgNZt/lLtN/ys1SgstkpK2INKmCTJQMn/xdrSNU?=
 =?us-ascii?Q?PL0jQURc6eHkcFsq9EoSF+OgimVYqfWclZKo/4G4RBKNi2ip9Ejcn1GlZ+DL?=
 =?us-ascii?Q?rvAW7TfVXsQtB9xN+6Y4rwmeIN9aEobMWfu/piUB4FI28RB05CdOJ6vTBP3l?=
 =?us-ascii?Q?WxqjNBpzGB2vSsBX8mcet3pWS8YuYc5f0thZyqCxvpQNh2zhZA2Bd4av7xdG?=
 =?us-ascii?Q?ox9/W/UbEznoKrUTAeQxkUX8QoqtASeTj4ZFL4YFgwf9I/iRIfOmitfqo73V?=
 =?us-ascii?Q?FM0cYhn5PjMpO2ct+3gXi/tgeH4SgqkppxAjkSGzCymD8Y5m1AiyS31p05IU?=
 =?us-ascii?Q?5wuJYEJTNTNA7v2H5D3d67TVlv2n3e/xcoGk5jgsxLDUtyfFpvV/XFLLmCgr?=
 =?us-ascii?Q?cWKkXZLIPAHMpTP0IoIA+sEkmJfqBy4Qb3w7jFQnSbBUNPLfOapd0NR6V8Zf?=
 =?us-ascii?Q?bFZUdph5qz9PNMD/3iJSzik7kXMvYeA+9Uh/PWqaJFaJWKl2fDnEkjE9IDWb?=
 =?us-ascii?Q?sLQKcyWNe50zZUPR1rD+/0mAGEsNBpsLlqZnja1p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2d9226-f635-41b1-f0ae-08db42609aab
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:04:48.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Hs7sG6o1gpu7SN+QZ7ESlBbRcUCucCvo30Y3dyiyYG9XabcHgh1RDmrCHCHRW5n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8825
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

On Thu, Apr 20, 2023 at 03:49:33PM -0600, Alex Williamson wrote:
> > If we think this policy deserves to go beyond VFIO and userspace, and 
> > it's reasonable that such devices should never be allowed to attach to 
> > any other kind of kernel-owned unmanaged domain either, then we can 
> > still trivially enforce that in core IOMMU code. I really see no need 
> > for it to be in drivers at all.
> 
> It seems like a reasonable choice to me that any mixing of unmanaged
> domains with IOMMU_RESV_DIRECT could be restricted globally.  Do we
> even have infrastructure for a driver to honor the necessary mapping
> requirements?

What we discussed about the definition of IOMMU_RESV_DIRECT was that
an identity map needs to be present at all times. This is what is
documented at least:

	/* Memory regions which must be mapped 1:1 at all times */
	IOMMU_RESV_DIRECT,

Notably, this also means the device can never be attached to a
blocking domain. I would also think that drivers asking for this
should ideally implement the "atomic replace" we discussed already to
change between identity and unmanaged without disturbing the FW doing
DMA to these addresses..

I was looking at this when we talked about it earlier and we don't
follow that guideline today for vfio/iommufd.

Since taking ownership immediately switches to a blocking domain
restricting the use of blocking also restricts ownership thus vfio and
iommufd will be prevented.

Other places using unmanaged domains must follow the
iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we should not
restrict them in the core code.

It also slightly changes my prior remarks to Robin about error domain
attach handling, since blocking domains are not available for these
devices the "error state" for such a device should be the identity
domain to preserve FW access.

Also, we have a functional gap, ARM would really like a
IOMMU_RESV_DIRECT_RELAXABLE_SAFE which would have iommufd/vfio install
the 1:1 map and allow the device to be used. This is necessary for the
GIC ITS page hack to support MSI since we should enable VFIO inside a
VM. It is always safe for hostile VFIO userspace to DMA to the ITS
page.

So, after my domain error handling series, the core fix is pretty
simple and universal. We should also remove all the redundant code in
drivers - drivers should report the regions each devices needs
properly and leave enforcement to the core code.. Lu/Kevin do you want
to take this?

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 19f8d28ff1323c..c15eb5e0ba761d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1059,6 +1059,9 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
 			continue;
 
+		if (entry->type == IOMMU_RESV_DIRECT)
+			dev->iommu->requires_direct = 1;
+
 		for (addr = start; addr <= end; addr += pg_size) {
 			phys_addr_t phys_addr;
 
@@ -2210,6 +2213,22 @@ static int __iommu_device_set_domain(struct iommu_group *group,
 {
 	int ret;
 
+	/*
+	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
+	 * the blocking domain to be attached as it does not contain the
+	 * required 1:1 mapping. This test effectively exclusive the device from
+	 * being used with iommu_group_claim_dma_owner() which will block vfio
+	 * and iommufd as well.
+	 */
+	if (dev->iommu->requires_direct &&
+	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
+	     new_domain == group->blocking_domain)) {
+		dev_warn(
+			dev,
+			"Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.");
+		return -EINVAL;
+	}
+
 	if (dev->iommu->attach_deferred) {
 		if (new_domain == group->default_domain)
 			return 0;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3ad14437487638..7729a07923faa6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -407,6 +407,7 @@ struct iommu_fault_param {
  * @priv:	 IOMMU Driver private data
  * @max_pasids:  number of PASIDs this device can consume
  * @attach_deferred: the dma domain attachment is deferred
+ * @requires_direct: The driver requested IOMMU_RESV_DIRECT
  *
  * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
  *	struct iommu_group	*iommu_group;
@@ -420,6 +421,7 @@ struct dev_iommu {
 	void				*priv;
 	u32				max_pasids;
 	u32				attach_deferred:1;
+	u32				requires_direct:1;
 };
 
 int iommu_device_register(struct iommu_device *iommu,
