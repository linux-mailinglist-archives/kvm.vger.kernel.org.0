Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1019255A11D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiFXSqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFXSqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:46:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4181881264;
        Fri, 24 Jun 2022 11:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EchjWnnT77Xm6DWf0380ZJzF+14dXyH63D6HAfdiLX+1W8r6GDrQThR9N06zSpA/jZV1mPfPKl1coHRIBEKwSLCfCu+0cZCEx1xP49pDmy5hG2kDiNjg3/ejSrx6OEzd7OFRUbQK64zD/Gn2FjSJXFD2sd1d9vS9hm3iu+yZxez25pu6iVaCyjsO+MXsHG+Vn6p48SMxByPMGcx+sggaf5zjuHZfWeJixUZ+IlXkhvAudIYgWrvOeZxdj7ZchIqAohvbevVQzaA8BXTKObydndEqpjCPJEJV9+LRRh4sGy4jiT5C5lQXnG+WQ1IaYd4ke1lrOOYH7MJGOU1qGilZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSZzvPV6iaZAbi16zYQI65Bu7ISOVdZ2SPQfnk1uxGY=;
 b=FdatiJZlxwiyzfGNI01Wgnl1SWo+j/NBmtNMf5GKvJbtYjM/7Q9Hb/xa4elyr+LSBYyIs4sVz1e9y288c1wB/FA0Wjpse+rFe6RxiXiq3EQuSnn+HksRwxac4bmmToGABd8pc29n23cN1SKlsKGwaNqYK7Nm4A8AlZtbaLKZXRCGuFqSLt84DK5hvQfYebWsmeJwMeSjoLCcUs+MohERvEduq0hz5iGbjghnNutTgcoGQOTsnxiRQ6zr93R50htrfN6x7Ttbjb/szfdBijXat+YEh2ZDUt0wC9azqBH6ZpGmF/e/rOUy6wND5+Pll6atRy6RBqV80l5Mm2e/hIlg2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSZzvPV6iaZAbi16zYQI65Bu7ISOVdZ2SPQfnk1uxGY=;
 b=i0zvBaOt3gm+IiRly9ebuE0z67u6x2XhMq0S1P8CyxXgo2QsbnXePK9jchLkP3vVEQXLrJJ4SaubEtbBd9DHGMQZFsK9/ojEgV+fFIegfn7kjIv+/RCNtegUT1/FRxBy2ntFjC2hoyQtK2QWQyTISbSBSt0v9yDQAXiy1aFvRRRMKNzs/MHWfvYWRxhOid6oflIIOEyGADynpQuThB7SJxLeofKDC/ojY2PcLXCGgaqnLXH8/y+ghgaAYF+GeW5nmnChf9McvVSlS7JtXYisOXwhZwSsTmblDUF3eD6Iy0KJKCI/p4D29/jJPk6wPYM0zh4mwQv98s71p3AEpk0oFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 18:46:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 18:46:11 +0000
Date:   Fri, 24 Jun 2022 15:46:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Message-ID: <20220624184609.GX4147@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
 <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YqutYjgtFOTXCF0+@Asurada-Nvidia>
 <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
 <20220624131611.GM4147@nvidia.com>
 <c9dee5e3-4525-b9bf-3775-30995d59af9e@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9dee5e3-4525-b9bf-3775-30995d59af9e@arm.com>
X-ClientProxiedBy: BL1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47e049fc-fa31-4747-c506-08da5611ceda
X-MS-TrafficTypeDiagnostic: CH2PR12MB4232:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+UbGabsh6n/qandmYg2gMW/qTzy0dfeyjAPBbPrISucYYPYJ0HoT/09J3elJGGsar38LCpnHPydsVUbT9bVIQEC+TGq8qgvjTAez6Na5Jbv/mSMsm2i93akEBM+MiUkxzJGeWGVi8rRXvocoBNi/JqpX/um2uMEGoiH9eHCi+VgG1zsTvwVNVORiTYObk0lllcRpRw84TRiJ00rfipALu2l3Q4CgJc0fzk/+YhKLWxpuxSftmnFwGeciyDPDpNv28xKlapGhxiWI/O4b8btGO10UGO9Rlw8mI5j1QhCNAsgXpRYr97zqtLA4Yk753An6k2h8BBu+mPPozeGq6KDk0flPMItRGYO7GhxKM50+2kCg0kDLjGirE0EiA8KoYxsw84b/gDIL+I72trdS1xcJOb1vFv/MviNYpzxyPd/QOMOiUdDLvmnAWvWo8YqlZPOquy3bAHXAwklWzYgi906wShyVoAVUH4YsUJd7T6F2JG+10VyNXLKYpCkPWUe4HCjfWeEk9jBWk08x+1sZZcMchSbOa426ptnwPrPYny9Ea/2bdVUnVV6i3YwydTz+o9uiYT2UaOw2n6i+XSndmp7BgL0RqWk7pmgnKGNB43RvtnemIv/R302v5XJejStNVH2YudVelJcB7PK1qfUR0EtPMjoZmZ2G4nvA92E8Y9Sq5ZbJ5EKV9DLR2cNW/ioFscSzePfTMJoL5FPyOZ1qvgXVR1mTV2Q9ZSzLGaGXasD2wk9sKG8Wv2DbXNminKmHutv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(6512007)(6506007)(5660300002)(33656002)(6486002)(316002)(2906002)(36756003)(26005)(41300700001)(38100700002)(478600001)(66946007)(2616005)(66556008)(8676002)(66476007)(4326008)(54906003)(86362001)(7416002)(186003)(8936002)(6916009)(1076003)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CDzARChBtb4DsZpFKWqzJw8w+TTcJG5Bn+s12ZV+7IHOmFLEgei+XtTQqJBu?=
 =?us-ascii?Q?7ddmJJHn00mYx9kiqlka7PUbBgasvq5mMxAvo7lzI9VgMqqGckUIhQ1XIcnC?=
 =?us-ascii?Q?m+AWAi1OrqXvsiPB3jP9F0cUAFTxeKmW312iB02FGPJUqSX9IuQGbtMXoyfF?=
 =?us-ascii?Q?9OmkDCdOCgTAVoBlecBQSi9zMs8Fl2bMge92THL6Yhi/N2K+u+crUgYv84zq?=
 =?us-ascii?Q?s4cLDJtT2uy6ygApTOjoyDLW52Ntzf4uG0O47nMltDYHK0LkqKg+m12WXpW1?=
 =?us-ascii?Q?NhSNo+pQAoHBbMiw42Ruuh5+vvJR9hJHrHh3la7ojmy9z3v1lr0yyJ/muM/j?=
 =?us-ascii?Q?3lqVyvLXIqwCLVgB7SdMwxU9J6EtOlpgTWfozXVqq3rK3rUAQE50mzLDn8k2?=
 =?us-ascii?Q?it4E4WGXcAAD8/2aEDtEf2aAeMbRtk7EJ8j9no6Hnx91rklC8ATsg4IL3vvn?=
 =?us-ascii?Q?nrJVFCr1cDo1i3XnH1eUWyKLAOgjc5bW7DjosbQQuLU/NGOmHEzCBtPBqGV7?=
 =?us-ascii?Q?apaMulFUwUNWJYUZFLGPSRlx84aLxvwUo5WluKrJNr2VlRXZc176XVnL25mF?=
 =?us-ascii?Q?IGI7VePrSCfOututwQrWMDOK2WnmhLa8XB0dVspYHA9+TvLmbSHZWK+sdM8k?=
 =?us-ascii?Q?ZrtOqNQz/AkKYPFNy6+vU06BbWplt7yR9GsXNP05islB9AoWsX1zoU8t5TuZ?=
 =?us-ascii?Q?xyApmwpXS9WQvGVFCACQDcDEZwsyIdWd0RLcU31OM8y1ZeqBA2D5FT2UXW4U?=
 =?us-ascii?Q?9cmFRYUxeEVa2HiPXHsnl2wVgXh6MmagCnB5vBBJRcRjozDWi+f0ooNFx3qs?=
 =?us-ascii?Q?WmYue8AtQ49VW1YGSQuUg3upQyPU6rnTZotCo87swg8pTy2VA90IxceF0DEQ?=
 =?us-ascii?Q?XuAuM/2kSj1K3/OhuY0RNeRVMkcATeDw6yetnkCf2Wdh+PuI3Y9h3rz0im8P?=
 =?us-ascii?Q?ZuYcuwA1M8qzvXdTPZ/5CAMQhZ0tsbvBylQIux0O1Di+3TfxhwsUQ8TVE6LS?=
 =?us-ascii?Q?6gIyZRvAV+1uU3vpiYG+yuJTfOuT/DfHhXknV58xTFQTSTahVox0jQDcXq70?=
 =?us-ascii?Q?LA4xUJpifb6KJDkx469kIc8XS52hni1CxVlJe/UzayL0NxpXKgcxHwEZxq73?=
 =?us-ascii?Q?vPqCqkNOxaLCxRCG6jbyUd3s+nKei918Hsub8HhPl9YQgaTjCu7lXam9NWEp?=
 =?us-ascii?Q?YPaBpZEeqyEoGAzokRaLGLaKhNuueB/Fdt9faL7oRzsfqOtoutZRw4CYMBeZ?=
 =?us-ascii?Q?h+rJqjiKmoSnwl+SzazvLJgM85VbJbAzMLpXPsIQyEEFECXTha1N76SQ57aR?=
 =?us-ascii?Q?wuXjHHDkMAWVrAOAdWZO1nDWoR+2F6g9Y7e9RMc6/SfuIhMCo9xAlzL2G4p0?=
 =?us-ascii?Q?Zws5dCCeKmpkrK2LMT6iLiq6OAXgGCr1pd1OK0iC+VxbWvZ/udaLrrxCcivg?=
 =?us-ascii?Q?g9AQLcV+85WzN/RHwVK+tK3MjJGQq/lmGfkuZoXMjjZgwIgvzgUMJ492taSA?=
 =?us-ascii?Q?j1R/ngk9Yo3DPJdtXidhoGcDjZ6JspSWlujOvWG85Bg2tfMCUHNMN2qxgnXu?=
 =?us-ascii?Q?L7BxI4iLHHEppOl3z52pwDY8rl4vXdv5nTl2EaHr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e049fc-fa31-4747-c506-08da5611ceda
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 18:46:11.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbaDrGTtc3w0r4jgKFCsk/V410TJZFDwCXiogPLDeGyPjsoCr7B/Bioxqlz3Ox07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 07:31:47PM +0100, Robin Murphy wrote:

> > > Oh, physical platforms with mixed IOMMUs definitely exist already. The main
> > > point is that while bus_set_iommu still exists, the core code effectively
> > > *does* prevent multiple drivers from registering - even in emulated cases
> > > like the example above, virtio-iommu and VT-d would both try to
> > > bus_set_iommu(&pci_bus_type), and one of them will lose. The aspect which
> > > might warrant clarification is that there's no combination of supported
> > > drivers which claim non-overlapping buses *and* could appear in the same
> > > system - even if you tried to contrive something by emulating, say, VT-d
> > > (PCI) alongside rockchip-iommu (platform), you could still only describe one
> > > or the other due to ACPI vs. Devicetree.
> > 
> > Right, and that is still something we need to protect against with
> > this ops check. VFIO is not checking that the bus's are the same
> > before attempting to re-use a domain.
> > 
> > So it is actually functional and does protect against systems with
> > multiple iommu drivers on different busses.
> 
> But as above, which systems *are* those? 

IDK it seems wrong that the system today will allow different buses to
have different IOMMU drivers and not provide a trivial protection
check.

> FWIW my iommu/bus dev branch has got as far as the final bus ops removal and
> allowing multiple driver registrations, and before it allows that, it does
> now have the common attach check that I sketched out in the previous
> discussion of this.

If you want to put the check in your series that seems fine too, as
long as we get it in the end.

> It's probably also noteworthy that domain->ops is no longer the same
> domain->ops that this code was written to check, and may now be different
> between domains from the same driver.

Yes, the vfio check is not good anymore.

Jason
