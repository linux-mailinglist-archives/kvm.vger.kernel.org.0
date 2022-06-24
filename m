Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD156559273
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 07:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiFXFlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 01:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiFXFlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 01:41:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143756802C;
        Thu, 23 Jun 2022 22:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUXBRtlMA3iRrfl2LhS2zqYPXwbKdGR/84MfskHzqd1NciSr8/5xlsE2AklVM6X45yOrzmyTW5HqjbCQLa7U1JaCcTuzfWsI2zV2Ab7Z0Eu0yR+jmqr7v5nBxlU6LqEvuqoaAQnbKRCSJUUZX0tBVqgFYd80Bu9Xs5ksh7uteTf40OCl48OYb/cG16cnvtjTv9pTGY6BuK6QwPpjRO6+y13CWfkAcsfalpiv5+526mu+yy58/efAFxy9D+znoDIyK0d1sq/noM4cnnjhWNUhKMkqr9U9hB+JbNflFLZECI/8flHg82R/4RMTuqgvKiZ2Q5K/KuB2NAUz2GDElVH0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91QSENODTttSKeaP20dv8mkbbQwplBwNvAhOA6Dz73g=;
 b=bQZb3nmHtG6T6pxfi58kP6N2jfaHhui2TdnNRQRmM7klDtl5cRFfqwJjeHO9KsTtmX/qwwrsXPo7Sbi5E2jyWqkB+VT3INLD9JMF6qYixXLVI9IxNpYd0B0SEXSFgJiC7rIx8ZlApmuhRYUS7/lMvzPUNXDLCkkna7OVR3uhqKS90NMV3HcCA680uP0eFRVxM0W4Jv13xuV0J8kBE4vxKsSj4RGp2mJx8iRG0SsuS3zW6bgLIgUGyb5sVJ9yrO+OlyDTJstKLCTnkVZUyZHkR6Hy7cMVmNF347TzKQ5nTP9Har75KexMeTozJz5ObrBa7x1g7CMdqVIQGR88bZZ5mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91QSENODTttSKeaP20dv8mkbbQwplBwNvAhOA6Dz73g=;
 b=eiqVMkAJ+T8GiUMX0iHsvwsWN9kkxzWidvvG10vA26WbHPlc8TxZm0vRiTJzxh6aav5iye7nYs0z/FFUw3b85LIFdCEzTMoMNZ7ELYg3yahlnLbt8x7pFKdjoTvHXbOW0jTMY6tVAC7xXx1FKi59v5qvuo1eYgG70CzDJGKtO95MHYZEMuIS4ykBjTQosa3iH9UYjEZGyWA9oIh9+Em2v6LWgYKJ+IaAL0QMVbGcwpQ8r6B2M+etw/DRvtmQQPH0pMviEgfOmKj09qGwYTq/ysqjExGuuEvk1WpXFruMtdv0XosZvuwduF5eqh/TQqJ5GrAomLCDENZMD+5Rqxqf/A==
Received: from DS7PR05CA0096.namprd05.prod.outlook.com (2603:10b6:8:56::28) by
 MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Fri, 24 Jun 2022 05:41:19 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::35) by DS7PR05CA0096.outlook.office365.com
 (2603:10b6:8:56::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.6 via Frontend
 Transport; Fri, 24 Jun 2022 05:41:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 05:41:19 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 05:41:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 22:41:17 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 22:41:15 -0700
Date:   Thu, 23 Jun 2022 22:41:14 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yong Wu <yong.wu@mediatek.com>
CC:     Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <will@kernel.org>, <marcan@marcan.st>, <sven@svenpeter.dev>,
        <robin.murphy@arm.com>, <robdclark@gmail.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YrVOegRfM1VlepRe@Asurada-Nvidia>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
 <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
 <YrUk8IINqDEZLfIa@Asurada-Nvidia>
 <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38d323e9-57b5-4f33-3f02-08da55a42a04
X-MS-TrafficTypeDiagnostic: MW3PR12MB4396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tu0gr7VF/QUyVQlaIzivHYy7MJeJLzwiA2xuzzQqInTjNgb5LTWBAUnj8mhFQB4xyrfCBH7jQCJe08hrBn4E7qVW24bzefHJn5dmpMJzPrJm7TQmDsLLwFgRps8+hbsj3yE7o9A6qjScOGMewehH6NBpmU29w6Ciw64+Dn1f2LA45uOvg56AF+htBHOuiG5Gstbm6fyHXuOqt7YboLu61IZ95yKs2ynlHL5hioRoMQ7h7qDheJF25t/LWlZQvFTt7yuGqMdhDMLC6mzUBW7WDHGjGr2oWzBWk/6y6tMh7fL9WrS9BXWIoLwBjxQbb6umniuUOroFNjhBYJo8qu5abd51MOsrWkTsR4Go9GS0t5s93YoQekyjhvy4Ow923cojAY95o/lZ6r1/8EYZ2s5CdfJWIvIBa1tHUbfstOoe66x3BJK/ByQy2B3ZGjY4sh2PKtfMFPyFyAC/Up/LbUoinVP1eWBsovtLOxIa4nMDLTrS63kgnv7NCQSM6RCinQrrIHp6KcKEHkJK07jJXotfQixeK7F0mSd/XUVJQLPq/ABGEVnh/cwXcBw2r+CP72pcnLSNSmdhzlXDDxN/YeqYjWNgY6Opa3/6px/kIRh+MQ9YATPB9PkxNV60Mf+yHz0aBvjjD3pJZOwyWtIHLhLsEOF/aHjYPbUmT+ccN0ifQu/xfUMV3e/8B9d81munTP/rvq/wWlACyjEWI4/llXbb/n7VYxaivM3koAMi9y+VfB7AZn6TsE9p0uJWhdmWkF/5RcShR6cBZHYXi897HG3yZOMorV/0ra3XOMaVLfU1Exi2sR+FMYbOCoWR8izRN64DGqAS7yp1hUof2MO0DHeXX9Ty8n48nqKn5/W8Z+/L434qdWY4fiBw0ibU5Fgjlo3Tl53nARZBlH+l4+ah6QXxK5Qwhqjv77kODHLApuTGiaI=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(40470700004)(2906002)(5660300002)(8676002)(70586007)(4326008)(47076005)(55016003)(478600001)(336012)(40460700003)(40480700001)(186003)(966005)(70206006)(7416002)(83380400001)(7406005)(426003)(36860700001)(8936002)(82310400005)(41300700001)(86362001)(81166007)(6916009)(82740400003)(54906003)(33716001)(356005)(26005)(316002)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 05:41:19.3015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d323e9-57b5-4f33-3f02-08da55a42a04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 01:38:58PM +0800, Yong Wu wrote:

> > > > diff --git a/drivers/iommu/mtk_iommu_v1.c
> > > > b/drivers/iommu/mtk_iommu_v1.c
> > > > index e1cb51b9866c..5386d889429d 100644
> > > > --- a/drivers/iommu/mtk_iommu_v1.c
> > > > +++ b/drivers/iommu/mtk_iommu_v1.c
> > > > @@ -304,7 +304,7 @@ static int mtk_iommu_v1_attach_device(struct
> > > > iommu_domain *domain, struct device
> > > >       /* Only allow the domain created internally. */
> > > >       mtk_mapping = data->mapping;
> > > >       if (mtk_mapping->domain != domain)
> > > > -             return 0;
> > > > +             return -EMEDIUMTYPE;
> > > >
> > > >       if (!data->m4u_dom) {
> > > >               data->m4u_dom = dom;
> > >
> > > This change looks odd. It turns the return value from success to
> > > failure. Is it a bug? If so, it should go through a separated fix
> > > patch.
> 
> Thanks for the review:)
> 
> >
> > Makes sense.
> >
> > I read the commit log of the original change:
> >
> https://lore.kernel.org/r/1589530123-30240-1-git-send-email-yong.wu@mediatek.com
> >
> > It doesn't seem to allow devices to get attached to different
> > domains other than the shared mapping->domain, created in the
> > in the mtk_iommu_probe_device(). So it looks like returning 0
> > is intentional. Though I am still very confused by this return
> > value here, I doubt it has ever been used in a VFIO context.
> 
> It's not used in VFIO context. "return 0" just satisfy the iommu
> framework to go ahead. and yes, here we only allow the shared "mapping-
> >domain" (All the devices share a domain created internally).
> 
> thus I think we should still keep "return 0" here.

Thanks for the reply. I will just drop the change of this file.
