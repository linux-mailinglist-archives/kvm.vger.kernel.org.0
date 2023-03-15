Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08176BA7B6
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCOGWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCOGV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:21:59 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7AE19B7;
        Tue, 14 Mar 2023 23:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXPpTRwYyRolZChkI54XYyW3ceguINVEQIXQuRPsaNOBcTeXWwDdMixprXU/xN4h7NCjC38D7zoIn8FoZzY9d7tyBjlb3Zo7RPUFjFC+8y+19CNTY61LVz30r6EFucQoqzaodOGuk99XHcZlczpLFRM85fUNyWbbMRXz0z7eyDF+KTib4H0sArlqpXgpiLySMhspeMsbNma+kADsvV87CKNit3qCYlXnaZnGx1H3KYYO3CgwaKRtF3vLv8sCePnbIgPsQnb10dz2X0gcWDG8Iu8hfURdQ2CRvKwuOsAmbXS1/1s0BK8Ggj1U3ocPFW10WavodP3W76w73lH9JDnMDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBH7mFUKZL1GGb35xxc112YaofGVQnSlGwRKv8vRo3Y=;
 b=XLEuV9iCKGfWtGHKHPHFbaxyzJXI2GX5Tdy53ihJDIwdsYTu49sX/J1pXfxn4gV1D8XclLWYAQT9sDXu7ppqsPVkag+gGjhHXDQE2p0vcSAcLcBzEtHyW3A4VjfjulXtvwNRlwDYivGXNYIhk6OaQGVZWNjNQbD+8VTua+SJSkctD17XY8RX26Y8H/RkQ+I2fL4s+NUc0PwAU7myc2EweqQxjkLOIGdiwZ7ZijNl+UYy/xh7cv3yds6UelJd1u7XgqlpnzUahzUketdCFDdzCXNki7tl0qUHHga9Alet8o2gklVd//q46D55gR9RwBgu8y/bqDflcsNY7nRO0S85Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBH7mFUKZL1GGb35xxc112YaofGVQnSlGwRKv8vRo3Y=;
 b=gMQ44nkjKHCIC5dMD50FX05kZLp7EIdFxKjeTDvRsi1SnfXnvYcbvVfLkLPguMLJ5FVvHipCVDtkpW5WBQiE2iXRgd0tZNhuFPpHwyE+DWRsn+ujTsVRk0Fcv87J71efOLPviT5FgUZFLTxYfMgMQJtyt+jAOXjKU6aDuICHys4hmI0xJt/pHO+Y+X2xOmCPWEYWDVlxK9JEwWRHp45vOAVMtckcyQTsO8Vtw+JmfSpwn9eWCjKBErDTDcHepDGAEuFRgKYg/6/hQIGejgIYkhOajQHEbZZ/GMRk2e+3GePEltEwnddK2ch/FgOglcUEoU9urNdGDz3DoPBVdiXNoA==
Received: from BN7PR06CA0048.namprd06.prod.outlook.com (2603:10b6:408:34::25)
 by MN0PR12MB6366.namprd12.prod.outlook.com (2603:10b6:208:3c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 06:21:51 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::16) by BN7PR06CA0048.outlook.office365.com
 (2603:10b6:408:34::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 06:21:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.16 via Frontend Transport; Wed, 15 Mar 2023 06:21:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 23:21:39 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 14 Mar 2023 23:21:38 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 14 Mar 2023 23:21:37 -0700
Date:   Tue, 14 Mar 2023 23:21:36 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
 <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT041:EE_|MN0PR12MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb93a27-61a7-4e53-6d08-08db251d907b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVtQNmvpwrC2dAlz8/WGjC+8fM3Jh/tiFARmejbp03xvMcScDS1y/FPam7g2ERkVV9fCFbvZpkqKrx1NJC8pOy2toCL9fZ25ZdyxFoMYFgDYd5eNC2Kzdupx3YgOPubu4Ar0Mha6cIul2+z/Be7d6k01k2YHj55pbHJlZGy41TDzBveW2dX4bHNt4rACzjk3o+3kj0QxVoMDdEZgS7BJjeP0oRpMu1WjPOmeqLiT9BscaVsiok90sFDpeVNPsrhebKe5zQlgMRtqpsg8Ta4xThl6H0gIbCyFABEbxpBsH3GzQiLo5zWgzC7TjujI8WVHJnSnA11CzqubA8xwr4VEQNAyxpOUiHT2OcqXmMfWTf6t4LtlKhq+5HvERe8U2pMNPku55KOjZeLG4LfgkveT4tcfxf21DlTt4momjMq+Im1G7S0+CezGjRExhEc+hcDRpAbPfKKF2/7qHOoHtZfImGi8VmRMhGKAqgWD6RYQn+LUIN6ad7yfID805ufqlNTTDgR87axy2OfDO2y6BKXUNpHUhDAL4pDu4Km7AGDzgsuI1B+B4U0kFLDX1QWZLbl3UHTp3lOa6zsXgEYSOZVdk7zEvM5lFE4yKJsxDHaTElUTcohyllqXnFJcTgrPGsGaWTOGya/UbLwcYmxp7RtbAwrEbawiXY2uBcqhN7GTr8izzClUtOR0iNAPaTeN92iIK/5d/iY4gofruzmCMtj1N7DsDrBgwH1yF97K/fuwbDxNAgdglsLSwy7xZSDzAzRP
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(36840700001)(46966006)(40470700004)(7416002)(41300700001)(5660300002)(8936002)(2906002)(7636003)(82740400003)(356005)(86362001)(36860700001)(70206006)(70586007)(110136005)(8676002)(336012)(4326008)(55016003)(40480700001)(33716001)(478600001)(40460700003)(82310400005)(426003)(186003)(83380400001)(54906003)(316002)(47076005)(9686003)(53546011)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 06:21:50.9469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb93a27-61a7-4e53-6d08-08db251d907b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6366
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 06:16:37AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen
> > Sent: Wednesday, March 15, 2023 2:51 AM
> >
> > On Fri, Mar 10, 2023 at 02:08:15AM +0000, Tian, Kevin wrote:
> > > External email: Use caution opening links or attachments
> > >
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Wednesday, March 8, 2023 9:14 PM
> > > >
> > > > @@ -449,33 +450,18 @@ iommufd_access_create(struct iommufd_ctx
> > *ictx,
> > > > u32 ioas_id,
> > > >       access->data = data;
> > > >       access->ops = ops;
> > > >
> > > > -     obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> > > > -     if (IS_ERR(obj)) {
> > > > -             rc = PTR_ERR(obj);
> > > > -             goto out_abort;
> > > > -     }
> > > > -     access->ioas = container_of(obj, struct iommufd_ioas, obj);
> > > > -     iommufd_ref_to_users(obj);
> > > > -
> > > >       if (ops->needs_pin_pages)
> > > >               access->iova_alignment = PAGE_SIZE;
> > > >       else
> > > >               access->iova_alignment = 1;
> > > > -     rc = iopt_add_access(&access->ioas->iopt, access);
> > > > -     if (rc)
> > > > -             goto out_put_ioas;
> > > >
> > > >       /* The calling driver is a user until iommufd_access_destroy() */
> > > >       refcount_inc(&access->obj.users);
> > > > +     mutex_init(&access->ioas_lock);
> > > >       access->ictx = ictx;
> > > >       iommufd_ctx_get(ictx);
> > >
> > > this refcnt get should be moved to the start given next patch
> > > removes the reference in the caller side.
> >
> > I don't feel quite convincing to justify for moving it in this
> > patch. Perhaps we should do that in the following patch, where
> > it needs this? Or another individual patch moving this alone?
> >
> 
> Next patch. I just tried to point out the required change caused
> by next patch. 😊

OK. I made a small individual patch. Posting here so Yi can just
squash it into the next patch:

From dbfe7457d35ea9a4da9c8e6daa838b101bc8f621 Mon Sep 17 00:00:00 2001
From: Nicolin Chen <nicolinc@nvidia.com>
Date: Tue, 14 Mar 2023 12:51:07 -0700
Subject: [PATCH] iommufd/device: Do iommufd_ctx_get() at the top of
 iommufd_access_create()

The following patch will remove the iommufd_ctx_get() call prior to the
iommufd_access_create() call in vfio_iommufd_emulated_bind(), expecting
iommufd_access_create() call covers the iommufd_ctx_get(). However, the
iommufd_access_create() only does iommufd_ctx_get() at the end. Thus,
move the iommufd_ctx_get() call to the top of iommufd_access_create().

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 0132803449be..dc1015b02a53 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -649,13 +649,16 @@ iommufd_access_create(struct iommufd_ctx *ictx,
 {
 	struct iommufd_access *access;
 
+	iommufd_ctx_get(ictx);
 	/*
 	 * There is no uAPI for the access object, but to keep things symmetric
 	 * use the object infrastructure anyhow.
 	 */
 	access = iommufd_object_alloc(ictx, access, IOMMUFD_OBJ_ACCESS);
-	if (IS_ERR(access))
+	if (IS_ERR(access)) {
+		iommufd_ctx_put(ictx);
 		return access;
+	}
 
 	access->data = data;
 	access->ops = ops;
@@ -668,7 +671,6 @@ iommufd_access_create(struct iommufd_ctx *ictx,
 	/* The calling driver is a user until iommufd_access_destroy() */
 	refcount_inc(&access->obj.users);
 	access->ictx = ictx;
-	iommufd_ctx_get(ictx);
 	iommufd_object_finalize(ictx, &access->obj);
 	return access;
 }
-- 
2.39.2

