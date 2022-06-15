Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2A054D4FB
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbiFOXMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbiFOXML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:12:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4374E2BB37;
        Wed, 15 Jun 2022 16:12:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7w8UqLNcDPkaQ2Su50IekXjTBAGLMsb9foC+vtTDKLLWzY9RE3403Caqhhryzyn+BNQrBOhLbNw3rtJvghf4MIZ5S48PR13jaLnK3pJgNS7YwspJyGcI3SZnbcu55dUImC5QDzEF6m1P8LMSR+155xvOJeJkot6Is7BcyW9hqnxhVxJKe9c/rVim2yP6o9AK5AAiV7BEJLn71UJdpt5mLlganCvc9VMJoBqoHoeW0VfQttwyqS7dwxzFVoct8iaNmBSvbJuj90RJWVvZ+6DhRrSC6Y292t/qZ9EeP30v/89raZxniaPvA+klkMFn6um0vtuz0En+R4Clj0g9iQ0dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dv+4zVQ8yma2CGjUc5/QHeUPsUtTcuF3IrwnT53JeW0=;
 b=UG3uCrVWj+/yLmZYpK8PIlVS/OvB9s3vPt0r2UAEA46xOuXIlybKxU5PWzVVs/II7a6dWaedcbRweDw9D4GIT3fn6TkSD+Z59AHmX4uTEMrdp7Hi1PbM8eM1BpyC4SJakTgW2aGTW5xR/hxU6WD5OxWhWVGPlrdFDn2MFOxd0VrfODa7mICMYKY0OsmH2vkljjMQELDg/cnQzkDrDJElA4/tUa9yg3UJ+P+8TMt/JUwwQfNzFOhPDGFeR/2RXkAOevXg6INRqj9ug5wyLBWxIt6i89oibSAS0AzxSymvKFWHkEc/SovyMjRg6g2YPAj9PPujWbD9oVvcrLGwCAEiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv+4zVQ8yma2CGjUc5/QHeUPsUtTcuF3IrwnT53JeW0=;
 b=nsT7NCzMa2c/i7L8h5EXK5ADt8e0fb+vTzgcrGfd3EMZ2kR3vQNb3WhtFVz8uuCyNDHSAAf1F6REUDrG7P6SFfXy6LmLbJQ4qNQcBQTQedQIo8xrvvdtBHWKC0cfgBY+tseEaACzijh6rHX31PV8EFoVQJHZB6b5dvwLEEoRNAPBZsVGulGmUsbhrty8eECliO8SG38Xv/JaK5Mk2l0OU8hppn+HySYTUFIdc0lpV12Cw/FupdzK7fSwEzGaeMNGgXsJWyBpRk190nwW9nYsol/rc+aayjnu5zer56Th21d9FfeVjMaUTOBqC38rJ2GbnsLWNoCK9rRfaHRICyWEtg==
Received: from BN9P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::29)
 by DM6PR12MB4105.namprd12.prod.outlook.com (2603:10b6:5:217::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 23:12:08 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::45) by BN9P222CA0024.outlook.office365.com
 (2603:10b6:408:10c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 23:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 23:12:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 23:12:06 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 16:12:06 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 16:12:04 -0700
Date:   Wed, 15 Jun 2022 16:12:03 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 3/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Message-ID: <YqpnQ63gx/3HUWOA@Asurada-Nvidia>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-4-nicolinc@nvidia.com>
 <BN9PR11MB5276DC98E75B1906A76F7ADC8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220608111724.GL1343366@nvidia.com>
 <DM4PR11MB52781590FB8FB197579DEE848CA49@DM4PR11MB5278.namprd11.prod.outlook.com>
 <YqjzXpzuBa4ATf9o@Asurada-Nvidia>
 <BN9PR11MB527694346588A803F0EDD95E8CAD9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527694346588A803F0EDD95E8CAD9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 589330ed-c0b8-46ee-7f51-08da4f247844
X-MS-TrafficTypeDiagnostic: DM6PR12MB4105:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4105AB8011A048D7553121ADABAD9@DM6PR12MB4105.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiXDI9NvcScFVEI7OCm3l0nGJn6kYhAX4y5QwDkwSstAzqwE0gV32FjlfOCVs0htCBHLnUbvHDlFqWVjeaAATuhRY134npZAfNAyhRKU+6FiXt18woerTIMQGBO4zbUHZH8TPTBrg2qWcOEEnNKoPKh0ULiqKvjRzfrYUrKtAqFFOq6YGtvYHqCAwJa5vE+XMPpv7NB00Hng4nmOv35wSyrZF4MKhlrZNXjWKfbreL09WO6L5nz6Mz1pC+69qYDyu5T/SqcUWFnh5pHLTf24BSrVIZYdj4VMMZyRitKFl+iJu1Zd0BE9Z+KVX+ktBHr0LobO3vA+P9pazy/ToQ7jHKmUS0Cp+KF5D7fseLJf7dEDyhCsZnig/UUryIgUYuf0EC1J94yU64OJ0jZMOc30R1cTeA765mC+H8GknODLWRUuGjvZY3Gtj1NvlIqn6ztR5n1KSMKWumYLBKSM6j4cHJ1a9iH7S015nR1DAmwFmfPIor88XxltP4Bi1xkORpzLaacxMDVohHLwSOWfwWuuF1L/drc3TcpM9GBpMrXhBiKYl6NCXu1kYvG/SwDCuw5hZ48Wvmqf2jWg0mnsKkB05m969uotJ6bmYvVUI2nKnhv7plnDL27l2MN3S8Ibu7ko4yCzsrVb6DPz0LMcgoO9iyCGpLf5PN9v4WboSidDnQrkyNON/LgVEm2ghCQNjiMU/TV1POURv6Bg11NHUvUL3w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(33716001)(426003)(47076005)(336012)(83380400001)(86362001)(316002)(4326008)(2906002)(186003)(8676002)(70206006)(55016003)(36860700001)(54906003)(356005)(8936002)(26005)(6916009)(5660300002)(70586007)(40460700003)(7406005)(81166007)(9686003)(82310400005)(508600001)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 23:12:07.9799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 589330ed-c0b8-46ee-7f51-08da4f247844
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4105
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 07:35:00AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Wednesday, June 15, 2022 4:45 AM
> >
> > Hi Kevin,
> >
> > On Wed, Jun 08, 2022 at 11:48:27PM +0000, Tian, Kevin wrote:
> > > > > > The KVM mechanism for controlling wbinvd is only triggered during
> > > > > > kvm_vfio_group_add(), meaning it is a one-shot test done once the
> > > > devices
> > > > > > are setup.
> > > > >
> > > > > It's not one-shot. kvm_vfio_update_coherency() is called in both
> > > > > group_add() and group_del(). Then the coherency property is
> > > > > checked dynamically in wbinvd emulation:
> > > >
> > > > From the perspective of managing the domains that is still
> > > > one-shot. It doesn't get updated when individual devices are
> > > > added/removed to domains.
> > >
> > > It's unchanged per-domain but dynamic per-vm when multiple
> > > domains are added/removed (i.e. kvm->arch.noncoherent_dma_count).
> > > It's the latter being checked in the kvm.
> >
> > I am going to send a v2, yet not quite getting the point here.
> > Meanwhile, Jason is on leave.
> >
> > What, in your opinion, would be an accurate description here?
> >
> 
> Something like below:
> --
> The KVM mechanism for controlling wbinvd is based on OR of
> the coherency property of all devices attached to a guest, no matter
> those devices  are attached to a single domain or multiple domains.
> 
> So, there is no value in trying to push a device that could do enforced
> cache coherency to a dedicated domain vs re-using an existing domain
> which is non-coherent since KVM won't be able to take advantage of it.
> This just wastes domain memory.
> 
> Simplify this code and eliminate the test. This removes the only logic
> that needed to have a dummy domain attached prior to searching for a
> matching domain and simplifies the next patches.
> 
> It's unclear whether we want to further optimize the Intel driver to
> update the domain coherency after a device is detached from it, at
> least not before KVM can be verified to handle such dynamics in related
> emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
> we don't see an usage requiring such optimization as the only device
> which imposes such non-coherency is Intel GPU which even doesn't
> support hotplug/hot remove.

Thanks! I just updated that and will send v2.
