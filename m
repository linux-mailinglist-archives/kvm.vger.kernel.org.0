Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C490354D881
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 04:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbiFPCkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFPCkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 22:40:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782AB4C7BD;
        Wed, 15 Jun 2022 19:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asariG3I1XsbsLdZvlU7JD7bgUWn7ouo8GIp8JJ5HLGnKARBBtsUQ/SfD7VHIb1SPe8YmVt9zofiaCUshvKwkMDxwOWeBhPKVaoiBeiAq+C5tSVebLBTn9yGoh1cHONgtP53mZr0RBoGdutD2jqzyInvD9Abrm6lAI/unFo+dAf6GHQAn7wBVtEGw4tke6u8UK/E2rRQU6bKs6ezfdal/9+3UetzzZyBfKvQ/awW9a2/xv2eSV6VJhTnXnY1QTVs1Wc8aosYZunXU9nqMBVwNRSl7kRjPW/uk8Rg4GMret6jpT0mJWMX4rhkJAslxVlBr9Zj5yK/6WAXOC6sQuF4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhBtibn7C/yz4vKqsDQRURimrz+0niz40Jmk1OUnqgU=;
 b=Bm8SX8RfwpvvCdmFVoRT82gfe8P24noxdJ5T92qIjgTpsVE61SdprlmGhftuEwA8CuwtKLk/Y2tR82N/wEcHi0hxq11dRKGZtxNMImlDpcCuKaq28WgcdDVBopMi+w2ReYgqD4UuKpZDxioaFd+08QvClcGu1Y51UFt8HDavgctfRoEgGjoH5y8uHGhQR/MctTQImKWMckDK9Z8kcuf736wneTbwJGoZflNcOgaLUAMLbul/yR2XwxM3Iu1Nh5VGM9PoaHkLvHSahdOonpepEEaiCSiMkl9t6W9W0f5mgX/fWNhKviKB2Cnnttz7LQ6barBP5yu9vPX19dflC0BiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhBtibn7C/yz4vKqsDQRURimrz+0niz40Jmk1OUnqgU=;
 b=tipximkeSNPWNhyrfTMN9HOlM6t4uiw4MXbXWVCaHeG+h7d8tDudSYkrNzJ/50JWHFpfRsTMYVj5alXvurTkcvxpz7oDkMSFqVGdxsarkF5vtxp5wB+rBbLaM9peZZ1mX0V/Fj15Drosk2s+VVC6t+S7dU2NlNsTq9ZZVkBXjVFIt14Zw10+5J704OX0gIsCjJIRb4POiXGwhDMlVNgKaCUIxCq2arwl7RQkeQKYX5bnBavM1g/xZKBPxqzD/aqoBUJLKlySJT+pwEqSjieXq2wpQekMvY7mTc2CHmCMDUNxuWQIuXmduiXk9BcG7p2G9Pk/umAWLrOcVF7R7il1iQ==
Received: from DM6PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:100::16)
 by MN2PR12MB2990.namprd12.prod.outlook.com (2603:10b6:208:cc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 02:40:13 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::b1) by DM6PR03CA0039.outlook.office365.com
 (2603:10b6:5:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15 via Frontend
 Transport; Thu, 16 Jun 2022 02:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 02:40:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 16 Jun
 2022 02:40:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 19:40:07 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 19:40:04 -0700
Date:   Wed, 15 Jun 2022 19:40:02 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
CC:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <matthias.bgg@gmail.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <suravee.suthikulpanit@amd.com>,
        <alyssa@rosenzweig.io>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YqqYAtfn7PQeCxgW@Asurada-Nvidia>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-2-nicolinc@nvidia.com>
 <0c0e6ec8-725d-93e8-44f1-db6c8a673a97@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0c0e6ec8-725d-93e8-44f1-db6c8a673a97@linux.intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f4b40cf-3b78-4593-41b5-08da4f4189d1
X-MS-TrafficTypeDiagnostic: MN2PR12MB2990:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2990BF315D3E7101FA85B8B3ABAC9@MN2PR12MB2990.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HwdzFIEdlNpfJjfm+z36VuJ0NsCdJyymn+4PuqriQ52llbjQjZKtB67FKv5ZNq43v082E/05qYv1LZTW2l9JnHlWVmTK9Vzo7PbUITUtxRFeKwVaot0/W4L30fASq/Pnw2Zqg7dKa/n2KDTXEV0wh07urfOQNtUrjPPtVCcZpXLP5qew/tGmTSSA3jB1Dxj8Z8ag44OyU8rtPGGPm7MCbSxS/kb+Zq3uFnnajKR+pnTZVHKSshdZnPoiPzzAM6SuLu6Ta1KFQqOFvmC5V7bI8E8/b8AlE81Mbw8glsGK86I3MpwIy8pijZ+YjYNNVmTtI7N6ZmGvm/zHAWSOXmaZfdxTMW0aa28jjrokSC22SGP9O3amKHycFDW76sVYI8Y9JN5P0e6w+2HYqagE7OMo2W7ImW2F7GNTUikt96fwPafAhuLQ1dTnYs2oSD6E/jMezii0MF57mbf76nXplH6LvipiLlzo2q4wIT3Z5W1Q6Xo+MjM4MYltIRVB9Sj011KnPhrQTjth2pXSjTYNP9ExiuosEHVlKVDTL821HVdCRcJwWOio5yQfPnOCa8S4UPzbS/G7/e5h//3VZmL+rpGN+1n47XxpNbD2Fj7wzEC1CGHsqJAmT1/uoyne4TYDCH5L5gNX7/m8ezEqX9njhPzYOCf2WO68qp0BxNkkq7EK3hZGhMavDiCdmXwJU0pgley9mttfIGdG0/D+Lted9HwGIw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(81166007)(86362001)(53546011)(33716001)(82310400005)(54906003)(6916009)(186003)(5660300002)(36860700001)(7406005)(7416002)(40460700003)(508600001)(83380400001)(26005)(55016003)(9686003)(2906002)(356005)(8936002)(316002)(47076005)(336012)(426003)(4326008)(70586007)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 02:40:12.8757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4b40cf-3b78-4593-41b5-08da4f4189d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2990
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 10:09:49AM +0800, Baolu Lu wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2022/6/16 08:03, Nicolin Chen wrote:
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index 44016594831d..0dd13330fe12 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -4323,7 +4323,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
> >               return -ENODEV;
> > 
> >       if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
> > -             return -EOPNOTSUPP;
> > +             return -EMEDIUMTYPE;
> > 
> >       /* check if this iommu agaw is sufficient for max mapped address */
> >       addr_width = agaw_to_width(iommu->agaw);
> > @@ -4331,10 +4331,10 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
> >               addr_width = cap_mgaw(iommu->cap);
> > 
> >       if (dmar_domain->max_addr > (1LL << addr_width)) {
> > -             dev_err(dev, "%s: iommu width (%d) is not "
> > +             dev_dbg(dev, "%s: iommu width (%d) is not "
> >                       "sufficient for the mapped address (%llx)\n",
> >                       __func__, addr_width, dmar_domain->max_addr);
> > -             return -EFAULT;
> > +             return -EMEDIUMTYPE;
> >       }
> >       dmar_domain->gaw = addr_width;
> 
> Can we simply remove the dev_err()? As the return value has explicitly
> explained the failure reason, putting a print statement won't help much.

Yes. As long as no one has objection, I can remove that in the next
version.
