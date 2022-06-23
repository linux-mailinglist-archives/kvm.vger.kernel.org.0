Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D606855745C
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiFWHrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 03:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiFWHrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 03:47:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F7546B36;
        Thu, 23 Jun 2022 00:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQDyLETTeRG9Hiuj+wZed+Hb8HkuNuuJZ0ZFWE/jg1oxfiU+XU5ttSjAbZC6JBNw9LV061/9SmgVY1B3xgD3piFCGSud+OUyu81YajN30EqRQmVLl42mqlUWYSNUX681PuIvVSgloqcY50wDnJrLfBDgv9Kz3brUqXdcOnNcq/Y2Tr2KGJMz54eO9IIheveNgdZzkK3jMipjqdorqje3LOfrFRgbQpr/88vUAfcQ9FCZgkYHKmrNkFErtNPSp/kekJSLn+NPHfD2R5BHatvTTgHnpRB5CvYmiDSS3j7ApGHM0SgzAUw8SjAL4uSpWgsJM9uBVe0/VTQ+SE5mAHtYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7eAAzrkzqQvAFIImCEht+etkeZakamJbPX7HA2lJBo=;
 b=Tjk0WS8PB4rx73QuA6QpgLmwOObHbaFPLBJaSMBcIV2i5KByhoqAbZ6JlAoQlNWmhJVVB6AnWXOrDKGylQg+BjASXgebMnUmqF4s78TUhyp45/g4qAn8pFa9uKrpq03ysV7E4N8Ekf3Dzy0wN2wdrvl0IiqklKUpgKJuFJUfhyVHWBT/EAu/ZzzG+8VYatpMqfJW9N/VqpiMHPV8SIrH7J4qsL2gZsOfvvqEgswfQiaoNDXBM5S3o6pBeQ5k+fcDzh1gxXIBrsYck9Lty70KKS4uCcDcqz8bH3Ba8V+JcfqPkfKs/VmZlIkT5WItEPVwAaLdqCBGOgn6npU2Xt/q+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7eAAzrkzqQvAFIImCEht+etkeZakamJbPX7HA2lJBo=;
 b=l2tU7xqLgswYGoKlIgT7oXsametqBrykUjmms9AHuIHwkksFkJ+0QwrvKbnPeghNY2osSauoFgA1Q4mlRO6HVUpBl3uURqtSTNnRCIuguHOqXZqHTfQPk9UdVGp88XNQ6yL6fdAAzIqUAqYbXYBIWP/OZTFjAtaAgqLC09lenwZtRDZcX5rFnykxYOKGS786SstKcedSXOOhlfUrKP4QrfjpYBhwx/SeO7a2oTRt9aTAZ4D/Thj4Qa06ozY52/AelHKHGndLWcbFE+nI6BJJlwD0vGCFMxQZhrtyPPv5kyHCScNypnTW+KL3MEle4FrY6BEgQbnF7tKNEtOHayh4iw==
Received: from BN9PR03CA0371.namprd03.prod.outlook.com (2603:10b6:408:f7::16)
 by MW3PR12MB4554.namprd12.prod.outlook.com (2603:10b6:303:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 07:47:12 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::10) by BN9PR03CA0371.outlook.office365.com
 (2603:10b6:408:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:47:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:47:12 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:47:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:47:04 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 00:47:01 -0700
Date:   Thu, 23 Jun 2022 00:47:00 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Message-ID: <YrQRgaHXi1bscYzj@Asurada-Nvidia>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
 <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YqutYjgtFOTXCF0+@Asurada-Nvidia>
 <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
 <BN9PR11MB52760486306A90A208D7C6768CB59@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52760486306A90A208D7C6768CB59@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26759e5c-e47f-44c0-434d-08da54ec959d
X-MS-TrafficTypeDiagnostic: MW3PR12MB4554:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB455449DD9E829F25F433DD38ABB59@MW3PR12MB4554.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IPSNh0AuummZJiCNFhCcaC2myM6rJtlM5wSVFNZK2Lm6+n92egHHQGJvZXdtHXVSepsN0l8EmLSQOyLK6iWWoefKgbfG6Dshd5TYzbPTL1W+piBBJnLwh1qtnQDQKshfUh8PDL4X8GYbQtFY9Ww+Edt3FYBYF+yqJYcSkDbb3jYjTQ2wnlDZ9XFbKKsQEiIfx6mHnV7BBIZyuOG0O2JeGNfoxvlf5QQOo45N7XY5wjC1zxTELKYCIJMSfyBeMV0f5Ahr7TInl/336rIVdlurHgeEDT5HUXSHFR8vgcUdc8+bCoyKn3GQr9JrLmvtpupYOum7bi2L3solHTTnDhg2+U2Dd9rEBNXwd8E8io19Gvz4Z4sAp0wGOBqTzgPG0psd0v8FxBIhWoHyan1T1Zj7vzqxNmo86/qeYXa1pJ6j4sIFSS7NT/xljZPOWNoQr7ShJJBP8wORiigJskb/QxubqEijA/oLRRdBDncgpHEJFnNqU7QlxMQeUA+nzy1bw4dO4oIDJKEW6wq7sfdFgY9jAIRg5xK3Sr6qO0RCQxUBKScifW985MTv6fL/b/3sDsF0VyDlrNJsoqrJJx1szz+ymsQm+Nkz3N5K6XOyRVJVG1t2ha9/VlL/pu4duHryiE/v+8vdc5GPpixSP3echtzH93xwh7aLyWWOEwusyV3oiIREvGbc75a04Pq6sDVynJ6JgcAYTTO0oakvh9fnN8+tkGcdKGvrKOVEcWCHuRIHa7dBv6ablWSl8VCQxKoupIb7klmb8J7zg1fOzRj6+0jb8O/Mm5X4ioXjSe4T/u4tc0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(40470700004)(36840700001)(46966006)(41300700001)(26005)(40480700001)(83380400001)(47076005)(7416002)(55016003)(2906002)(70586007)(33716001)(40460700003)(82740400003)(82310400005)(8676002)(70206006)(81166007)(9686003)(5660300002)(4326008)(86362001)(336012)(8936002)(54906003)(356005)(53546011)(186003)(110136005)(316002)(478600001)(36860700001)(426003)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:47:12.3754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26759e5c-e47f-44c0-434d-08da54ec959d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4554
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 03:50:22AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Robin Murphy <robin.murphy@arm.com>
> > Sent: Wednesday, June 22, 2022 3:55 PM
> >
> > On 2022-06-16 23:23, Nicolin Chen wrote:
> > > On Thu, Jun 16, 2022 at 06:40:14AM +0000, Tian, Kevin wrote:
> > >
> > >>> The domain->ops validation was added, as a precaution, for mixed-
> > driver
> > >>> systems. However, at this moment only one iommu driver is possible. So
> > >>> remove it.
> > >>
> > >> It's true on a physical platform. But I'm not sure whether a virtual
> > platform
> > >> is allowed to include multiple e.g. one virtio-iommu alongside a virtual VT-
> > d
> > >> or a virtual smmu. It might be clearer to claim that (as Robin pointed out)
> > >> there is plenty more significant problems than this to solve instead of
> > simply
> > >> saying that only one iommu driver is possible if we don't have explicit
> > code
> > >> to reject such configuration. 😊
> > >
> > > Will edit this part. Thanks!
> >
> > Oh, physical platforms with mixed IOMMUs definitely exist already. The
> > main point is that while bus_set_iommu still exists, the core code
> > effectively *does* prevent multiple drivers from registering - even in
> > emulated cases like the example above, virtio-iommu and VT-d would both
> > try to bus_set_iommu(&pci_bus_type), and one of them will lose. The
> > aspect which might warrant clarification is that there's no combination
> > of supported drivers which claim non-overlapping buses *and* could
> > appear in the same system - even if you tried to contrive something by
> > emulating, say, VT-d (PCI) alongside rockchip-iommu (platform), you
> > could still only describe one or the other due to ACPI vs. Devicetree.
> >
> 
> This explanation is much clearer! thanks.

Thanks +1

I've also updated the commit log.
