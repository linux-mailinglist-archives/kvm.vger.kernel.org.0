Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A544067F255
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjA0Xj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjA0Xjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:39:53 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A238386EAF;
        Fri, 27 Jan 2023 15:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXtmFrbPX3Rlhiz3SBLD8PS8kxz4N4LpqF4I75UDDQIakx0dZCtG+bIKoWx2zlRZaQK6xQ+6FwUh1tUQ47r6UQC2GpHoEX7079wb9HteTfF30H56fDckYDiTz3eOrE1v5lxnFSQNCeavT2E5YM5znqcqcEN6ZWKxQCFsMRS2zmsjG8hzDk7eGko9nIk4psKXJhbglDzsksS/8pG9bdT2R+wisTNVTSAYPxp5HewsySyHkdbT+YGu22g2RosoQFORBZTAv2A2mmHtnVvc4Ehl+KDLT0pV+pjBDP26isySo4U8cz1scTdUWshn5DtxRNnukpCVXGIzuor7fXG6l+0bhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MejMPe4SqMXIR5PkO5uOpdNlnYeezfagIFnSND5JyXk=;
 b=X/F/lVcJFZPodQ1E3/3cQpisfntM/tvCOhv9GylI40CIJfNgUVSrnCM4FyCXsgX63gJp4r51LSJhF2JCtV3hhRFwnElBxU5hs42zh/TXhAlryNnssHoZUcVi6tkKzfTuKkX6gtS2EpT1vbPiVobAXNHuDd2VqAxZHyrM/3iq9xh55hzJAJ6oMA3fhfGby/UjDmh+ll7u/wcIQa6IpKhWNkSJWrISUBJ/FR3PZGdnLakK+pKRODMlWt1YtqsSb7SNSMoSp19KxKmIbS/RfaHTsV0QTugRPVYvYMEhQX8zYEEaSFVGuvtwQd1zo1C1Lll6wGJSPSQaEUdoGMMieINDEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MejMPe4SqMXIR5PkO5uOpdNlnYeezfagIFnSND5JyXk=;
 b=XrH1T5B3A2qSMR7hcWB2kVA6RW9VXS3/5OuiT9aX4eDN1dXt3YmGjPU314YHqRRnGAdeiuGa265JTONSZPJt9l5c2pH+KeGbEBgCDy6Ul5tZgjNI1C5P+iYqnfxFtOuusI08eFBRSWs2F4NLDOjU8vE7ULQdHNvwonoaAMDChIAhdEdW2dZ5bJ8zs4C0mbi3VM1UTL0MxPVQc8wItOmsZ0XQ9ucA6qmVqPbxanuIVgBa6UEy/PLVYk4Iiws7PnwByF8FB5SuqC5ywIIWIucaO5+ca9braOqfwva1v9b1AG10W4IUWU+g1SrxvUWC681clMbeljsN5t/mfqU4TOiHWQ==
Received: from BN8PR15CA0031.namprd15.prod.outlook.com (2603:10b6:408:c0::44)
 by DM4PR12MB5937.namprd12.prod.outlook.com (2603:10b6:8:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 23:39:49 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::82) by BN8PR15CA0031.outlook.office365.com
 (2603:10b6:408:c0::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 23:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 23:39:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 15:39:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 27 Jan 2023 15:39:41 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 15:39:40 -0800
Date:   Fri, 27 Jan 2023 15:39:38 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, Robin Murphy <robin.murphy@arm.com>
CC:     <kevin.tian@intel.com>, <joro@8bytes.org>, <will@kernel.org>,
        <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <yong.wu@mediatek.com>,
        <matthias.bgg@gmail.com>, <thierry.reding@gmail.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Message-ID: <Y9RgunVm+Gbec7a2@Asurada-Nvidia>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|DM4PR12MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc398bf-c11a-49f5-09e4-08db00bfc7a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGTbHqIAr3MUlirte2Y5LOEq8T00RMe7f6ViRCYYRBuCFjI+mK+/lZmXbQngeHWpB9vgsMrzaPPVMzIm+cG9tNtIug8GpmXZ2WQKorlp9att19yD96FkLx4cRpUjIX6qoCR+QzS+mNMywhPdYBCNBmKwvYNebhf6Nj2wbkT5qLxNxzgbRx6K1dsOUyLmACBkgow0rrzt/aggINTe8+K4eA5u7hs//uuC2hcMGQqUbuPAewEDy5/hEstTfHQdSec5vaxTVFUWGvf2fGVgkuDg6A5PcSbwhat7G5IQLRabBgUeyPYWui6QFgvGLn2G3/huB6CooYL5DkvoD+yW11l7W68rvZ0wXwI0zMZMYltZA/bVo4bc6GL8eUtCzZJbIbPb3C6Gx0vZ0BwfM84D6hfqDFscPWtuLtsVPhNz6DWoHYXJlYZhB6Hg+BrJ4jib9u6dnx8bmccSid8tm0LPJYNtxE7CczGc1BTre7rGxx8+Cd/JDzjWx50sDkp0lBvAHhMbdT9SNUEAuUBIOvRE+olbVyG7IaSyxZdsFAPZNFcWo1vd0i4Bnox6lNhva6GqF89kEa9sbkXEwxReOzs/bBuCRgwWR9RjzRqKvzKPzM1FIl28UJQfSOZid3Xpbaaou8e0CH8z31PIoV2SijYGmaPqZVSjn4OoVHhwk4chON51kST4KXxm67Rcc7brRHq8e2DjZ10cNoXs8NwpKsFxIR0vAwIJq4zVeJfDRs9qULxBpd0=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(70586007)(82310400005)(26005)(186003)(86362001)(9686003)(478600001)(36860700001)(40460700003)(316002)(110136005)(40480700001)(54906003)(33716001)(8676002)(4326008)(55016003)(70206006)(356005)(336012)(41300700001)(47076005)(426003)(8936002)(53546011)(83380400001)(82740400003)(5660300002)(7416002)(2906002)(7636003)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 23:39:48.0496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc398bf-c11a-49f5-09e4-08db00bfc7a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5937
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin.

On Fri, Jan 27, 2023 at 09:58:46PM +0000, Robin Murphy wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2023-01-27 20:04, Nicolin Chen wrote:
> > Both IOMMU_DOMAIN_UNMANAGED and IOMMU_DOMAIN_DMA require the support
> > of __IOMMU_DOMAIN_PAGING capability, i.e. iommu_map/unmap. However,
> > some older iommu drivers do not fully support that, and these drivers
> > also do not advertise support for dma-iommu.c via IOMMU_DOMAIN_DMA,
> > or use arm_iommu_create_mapping(), so largely their implementations
> > of IOMMU_DOMAIN_UNMANAGED are untested. This means that a user like
> > vfio/iommufd does not likely work with them.
> > 
> > Several of them have obvious problems:
> >    * fsl_pamu_domain.c
> >      Without map/unmap ops in the default_domain_ops, it isn't an
> >      unmanaged domain at all.
> >    * mtk_iommu_v1.c
> >      With a fixed 4M "pagetable", it can only map exactly 4G of
> >      memory, but doesn't set the aperture.
> 
> The aperture is easily fixed (one could argue that what's broken there
> are the ARM DMA ops for assuming every IOMMU has a 32-bit IOVA space and
> not checking).
>
> >    * tegra-gart.c
> >      Its notion of attach/detach and groups has to be a complete lie to
> >      get around all the other API expectations.
> 
> That's true, and the domain is tiny and not isolated from the rest of
> the address space outside the aperture, but the one thing it does do is
> support iommu_map/unmap just fine, which is what this flag is documented
> as saying it doesn't.
> 
> > Some others might work but have never been tested with vfio/iommufd:
> >    * msm_iommu.c
> >    * omap-iommu.c
> >    * tegra-smmu.c
> 
> And yet they all have other in-tree users (GPUs on MSM and Tegra,
> remoteproc on OMAP) that allocate unmanaged domains and use
> iommu_map/unmap just fine, so they're clearly not broken either.
> 
> On the flipside, you're also missing cases like apple-dart, which can
> have broken unmanaged domains by any definition, but only under certain
> conditions (at least it "fails safe" and they will refuse attempts to
> attach anything). I'd also question sprd-iommu, which hardly has a
> generally-useful domain size, and has only just recently gained the
> ability to unmap anything successfully. TBH none of the SoC IOMMUs are
> likely to ever be of interest to VFIO or IOMMUFD, since the only things
> they could assign to userspace are the individual devices - usually
> graphics and media engines - that they're coupled to, whose useful
> functionality tends to depend on clocks, phys, and random other
> low-level stuff that would be somewhere between impractical and
> downright unsafe to attempt to somehow expose as well.

Thanks for all the inputs.

> > Thus, mark all these drivers as having "broken" UNAMANGED domains and
> > add a new device_iommu_unmanaged_supported() API for vfio/iommufd and
> > dma-iommu to refuse to work with these drivers.
> > 
> > Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> [...]
> 
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 46e1347bfa22..919a5dbad75b 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -245,6 +245,10 @@ struct iommu_iotlb_gather {
> >    *                    pasid, so that any DMA transactions with this pasid
> >    *                    will be blocked by the hardware.
> >    * @pgsize_bitmap: bitmap of all possible supported page sizes
> > + * @broken_unmanaged_domain: IOMMU_DOMAIN_UNMANAGED is not fully functional; the
> > + *                           driver does not really support iommu_map/unmap, but
> > + *                           uses UNMANAGED domains for the IOMMU API, called by
> > + *                           other SOC drivers.
> 
> "uses UNMANAGED domains for the IOMMU API" is literally the definition
> of unmanaged domains :/
> 
> Some "other SOC drivers" use more of the IOMMU API than VFIO does :/
> 
> Please just add IOMMU_CAP_IOMMUFD to represent whatever the nebulous
> requirements of IOMMUFD actually are (frankly it's no less informative
> than calling domains "broken"), handle that in the drivers you care
> about and have tested, and use device_iommu_capable(). What you're
> describing in this series is a capability, and we have a perfectly good
> API for drivers to express those already. Plus, as demonstrated above, a
> positive capability based on empirical testing will be infinitely more
> robust than a negative one based on guessing.

OK. I can change to IOMMU_CAP_IOMMUFD, and add to the drivers that
are tested. And an IOMMU driver that wants to use IOMMUFD can add
such a CAP later whenever it's ready.

Yet, "IOMMU_CAP_IOMMUFD" would make the VFIO change suspicious, so
perhaps the next version is just one CAP patch + one IOMMUFD patch.
@Jason, any concern?

Thank you
Nicolin
