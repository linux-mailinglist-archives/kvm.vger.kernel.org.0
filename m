Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE954ED6D
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 00:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378645AbiFPWlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 18:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiFPWlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 18:41:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CA862115;
        Thu, 16 Jun 2022 15:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bX5pcTEnZf7FpWsIzHhZ/wbpBi9Oqu65uibwOdkV/GnMCSGHQl5j71h/XppYyaatv07WFX0yG0PCTwnIMKjtBSX6vZgq75SGD2hY/ORxAbgNDPjAsMWXSoFBXWKr62dc4wm7kTqsDqOA5T6Kst+nXUnbA3N9qjqogO0q2KD4vZe2SapkkX9QhcXRwglQWa0UhD2H+acf6rxWXyT84TT++8t31kLQduqrGhoM9GY0z2faVkxqn8kdflWtiwBaKWCYqXOY3AYmEoqrxdxr5JVNuFPx3dpiRrEQWx46/FtmpUOgOwzprRjM9ljlp6pFNr0glZK/KJc4DE4I7BvFxMoGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgp5iE3AW7LRxZF1GBubRntHzqsJyyTgzfgQIAASVYE=;
 b=M+iS+omVOFrJUiesFR1Wj3sl4sRyVQsviqe+4qKmh8Bt8+RGAAl/GqFcp1NkmBdPSjxyfW2rLmKjxSMgSqv6XEwEWHBxJim0bbCDYEH8uH3n9DluthG2+4QawF2VoU7n4ZgaXlZMBq8471bVjjEhkDlqaDy0p1c+3NoReweVKLG2h91hwC6kLHlUntTPlrUHDFeDWn3bZNSNrKwBFJB2FfI1cm2xmTXsYpREq5u9gpuABBZUIRkVJsiFtpn0SXeMlfq6j93qxL9Yg45+S/eOdGGdybMqQREqBwI3oGw7ipxCfpSbVPD4Umx+mi/6zjC5rGCsnnPDMo7Ehq3+y1HlQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgp5iE3AW7LRxZF1GBubRntHzqsJyyTgzfgQIAASVYE=;
 b=ZD6sY9Cl7bF1DpTysd0hQ5kJ/DR1ouZg1JkQXGyMy1beydmPCh4/IMysxTzzXCUX8/KIZn1ToZwcE7ULNKNuhslj1Gh5in1Zgq2Yma1NYD2QOSuDZ0F6aHegTTBsrBYtF5SZFWa2EuyE8tNijPQJ5aGB7dV4wpUtKImT6vwzwI9vsFZea14LQwM0I3nHYp4ReRnOIAOThJat/WtTEpxoX50zLFQ6Zki9DwhF1GY5pBffRhVUonEc04aIzM7mpivqrYAZ2XxTF7ziy3rvsMmMAwY2QBk/0drQ0vz1ukIIlSy0UxGoqNyQl35CmH0vP0huDpaZNUnK9iE+q5g18caYWQ==
Received: from DM5PR1101CA0016.namprd11.prod.outlook.com (2603:10b6:4:4c::26)
 by BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 22:41:15 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::58) by DM5PR1101CA0016.outlook.office365.com
 (2603:10b6:4:4c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19 via Frontend
 Transport; Thu, 16 Jun 2022 22:41:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Thu, 16 Jun 2022 22:41:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 16 Jun
 2022 22:40:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 16 Jun
 2022 15:40:52 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 16 Jun 2022 15:40:50 -0700
Date:   Thu, 16 Jun 2022 15:40:48 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Message-ID: <YquxcH2S1fM+llOf@Asurada-Nvidia>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-6-nicolinc@nvidia.com>
 <BL1PR11MB52710E360B50DDA99C9A65D18CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BL1PR11MB52710E360B50DDA99C9A65D18CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1201343-8352-4791-4bbd-08da4fe95278
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5732774011E1F4C5A01380C3ABAC9@BL1PR12MB5732.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nk74016v9mt1rCmjH5UOQIlrAhVCquvXKRo493JksbtTiOr1sWHplxlVewAZV0M9N5GQBDi9prjABasx04aHk5dOrYmqqHoT5kj5n/tpkScS2qGWb7FkB5iQvAPpXB6NC3Lvdxlbyhbaxi2svf5DmuUbvS9AsNAr62Kqzk+bUI6z3W2Uu097QeM4vgs9WiTDzbcxzPFmP9cWfr7xvMDgAAp9V2JKDTOYylCOCYj9OHHZ9f0ZC999Dwn1pvzbZcMMfsEJc8Bbd5ee/nJchRBrRb/pV2K//UpWsrUcIYcx+N0XCJeJq3ORiAyttTETfiPcjzerVTBMjsc9Hb/ZYGPzOHRT5PODKWxHSH3uUpCRLYjHtSzxxxSRLG8hyBTNrsu/sEo5lArGNgdQT/4papj310Hue7TaSfYb+/zQNNHgt1DcppeiOnBZ6tAVusW9GTadpVJXQ0B3KJpCccAomtiLX2vus7bSv8poPNbOke/OLv31/TXqRs5ZLcY2hWWf5ALuQlD8AvxlNT9UtsYADwABI+6yTeDHcT2lJu/V0maug5mIgvixXnyzOMzead8RLCfHaBRQAIwA4V+PPYD32dPx748g7JBXk3cGwSjmtGwDKZIfvrYiCV6C8DEZpmgI7mC8nqpv4uV5goLptF2OWNi+RxtonGswus7UKJvQnc2UZ2wa4OKpre8+5u0JzzQr/aoDC42g734N6roMb6U/vX1Br51W2MrvKaOP8sozLn+xfWw=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(8936002)(26005)(9686003)(7416002)(508600001)(7406005)(356005)(70586007)(70206006)(2906002)(5660300002)(55016003)(83380400001)(36860700001)(186003)(81166007)(47076005)(426003)(336012)(40460700003)(8676002)(86362001)(82310400005)(33716001)(4326008)(54906003)(6916009)(316002)(67856001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:41:15.4530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1201343-8352-4791-4bbd-08da4fe95278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 07:08:10AM +0000, Tian, Kevin wrote:
> ...
> > +static struct vfio_domain *
> > +vfio_iommu_alloc_attach_domain(struct bus_type *bus, struct vfio_iommu
> > *iommu,
> > +                            struct vfio_iommu_group *group)
> > +{
> > +     struct iommu_domain *new_domain;
> > +     struct vfio_domain *domain;
> > +     int ret = 0;
> > +
> > +     /* Try to match an existing compatible domain */
> > +     list_for_each_entry (domain, &iommu->domain_list, next) {
> > +             ret = iommu_attach_group(domain->domain, group-
> > >iommu_group);
> > +             if (ret == -EMEDIUMTYPE)
> > +                     continue;
> 
> Probably good to add one line comment here for what EMEDIUMTYPE
> represents. It's not a widely-used retry type like EAGAIN. A comment
> can save the time of digging out the fact by jumping to iommu file.

Sure. I can add that.

> ...
> > -     if (resv_msi) {
> > +     if (resv_msi && !domain->msi_cookie) {
> >               ret = iommu_get_msi_cookie(domain->domain,
> > resv_msi_base);
> >               if (ret && ret != -ENODEV)
> >                       goto out_detach;
> > +             domain->msi_cookie = true;
> >       }
> 
> why not moving to alloc_attach_domain() then no need for the new
> domain field? It's required only when a new domain is allocated.

When reusing an existing domain that doesn't have an msi_cookie,
we can do iommu_get_msi_cookie() if resv_msi is found. So it is
not limited to a new domain.

> ...
> > -             if (list_empty(&domain->group_list)) {
> > -                     if (list_is_singular(&iommu->domain_list)) {
> > -                             if (list_empty(&iommu-
> > >emulated_iommu_groups)) {
> > -                                     WARN_ON(iommu->notifier.head);
> > -
> >       vfio_iommu_unmap_unpin_all(iommu);
> > -                             } else {
> > -
> >       vfio_iommu_unmap_unpin_reaccount(iommu);
> > -                             }
> > -                     }
> > -                     iommu_domain_free(domain->domain);
> > -                     list_del(&domain->next);
> > -                     kfree(domain);
> > -                     vfio_iommu_aper_expand(iommu, &iova_copy);
> 
> Previously the aperture is adjusted when a domain is freed...
> 
> > -                     vfio_update_pgsize_bitmap(iommu);
> > -             }
> > -             /*
> > -              * Removal of a group without dirty tracking may allow
> > -              * the iommu scope to be promoted.
> > -              */
> > -             if (!group->pinned_page_dirty_scope) {
> > -                     iommu->num_non_pinned_groups--;
> > -                     if (iommu->dirty_page_tracking)
> > -                             vfio_iommu_populate_bitmap_full(iommu);
> > -             }
> > +             vfio_iommu_detach_destroy_domain(domain, iommu,
> > group);
> >               kfree(group);
> >               break;
> >       }
> >
> > +     vfio_iommu_aper_expand(iommu, &iova_copy);
> 
> but now it's done for every group detach. The aperture is decided
> by domain geometry which is not affected by attached groups.

Yea, I've noticed this part. Actually Jason did this change for
simplicity, and I think it'd be safe to do so?
