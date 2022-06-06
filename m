Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7D53EDE6
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiFFS3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiFFS3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:29:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703A52FEB90;
        Mon,  6 Jun 2022 11:28:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkPJZS8D4PxHXGApgPBYiBnNPJfHlPlJi4eWirucM5pqpuvTHfItEHEl2vCMj1na/zIk8IkB5ZSpJHIq5YlxywMKdhISEu+/3/+N4L9sojJcTwbbBg4iUhJRyyeFJQcgfm3oTD7QTIw3M2vu/LyZw9NFgLoh4Gz3DRqSrZpTvyQ673t5yNqnPLlQ2T5DXQXu4UcWclcLw+QjPvzroVlok7w16fhehA+Ndo1hBC+TU3XPQS5X9GMj4dvOxDOxjg7r88J9KAXX5ju4sCRCM/nAZfqXybGxOWAI4/ymU19JpP2Fc2UTdXn/UUOJB+LeXipIO46nUsJ3bn/dAoNZdYXEOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfc/V9PCZHj0Y6mh13cLOXjXZFmclYmZievYTqkDTi8=;
 b=fkv961ryU1+DzxM7UQwTTqEOkqRg0qFK5bknipg1Rq26GYaoojev1un6s+44lhPyBHq2Hr9XMFXkU/xjhgBuqpcjhK7CfaHOsWzy8Yjqeh51zsIOqRPrpByQWPycCq/1vC9ji2Ibl57hfKqCldktyaWc4DRibbSDElojtfokcwazYvTicngxMUogd2DLpwF9ARo747fbWEvPcfObj0X82U/17RBWxwpT2xLST/VDvP5fFg9iHM6YgtMP8p4+yiLmgPqJnymmOfhz7YLvoFe9LqI031YDBHichLrp0UmAoQ+eZPy8jDX+YyGrtLOCzk413kdNVQsJ7FHmqZVLoPqRuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfc/V9PCZHj0Y6mh13cLOXjXZFmclYmZievYTqkDTi8=;
 b=QsY6HQAqcl4ULhNfJbtOvIOMXGValqqCOhdZ4buTAA8HhJUbZq/I/CKL9k4pgdq467qRdovFJkLQfxYtkzAksustKjQsMHVL3zd8pwYZfNxTR6bhaweQPUpO7yP2DViLPanvx53CwtWYeYoRV8sZeyKiBIMJaLtaCiVnxHxdq5K/X/J4uaeAER4ZL0UGkaygbFGSKxXcPCwrPDGJDT+AwKM+OEZVfn1GEBZhZn+0cch8/SmeYAT3m1lxdiIMtKOSisxbXTm4UvQBkDcBRdWsMWbWlpE+avWsfGJBqjUwP2ckSrwwvUrDLbSpbhaFTfU6eWiiXG6s0KKWCcwx2t+jDw==
Received: from MWHPR02CA0004.namprd02.prod.outlook.com (2603:10b6:300:4b::14)
 by BYAPR12MB2934.namprd12.prod.outlook.com (2603:10b6:a03:13b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 18:28:53 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::86) by MWHPR02CA0004.outlook.office365.com
 (2603:10b6:300:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Mon, 6 Jun 2022 18:28:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 18:28:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 6 Jun 2022 18:28:52 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 6 Jun 2022 11:28:52 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 6 Jun 2022 11:28:50 -0700
Date:   Mon, 6 Jun 2022 11:28:49 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
CC:     <jgg@nvidia.com>, <joro@8bytes.org>, <will@kernel.org>,
        <marcan@marcan.st>, <sven@svenpeter.dev>, <robdclark@gmail.com>,
        <m.szyprowski@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <baolu.lu@linux.intel.com>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <matthias.bgg@gmail.com>,
        <heiko@sntech.de>, <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <alim.akhtar@samsung.com>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] iommu: Ensure device has the same iommu_ops as the
 domain
Message-ID: <Yp5HYe51LSQke/GY@Asurada-Nvidia>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-3-nicolinc@nvidia.com>
 <1e0e5403-1e65-db9a-c8e7-34e316bfda8e@arm.com>
 <Yp4wiJZWxoCLY8tm@Asurada-Nvidia>
 <6575de6d-94ba-c427-5b1e-967750ddff23@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6575de6d-94ba-c427-5b1e-967750ddff23@arm.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 980ccc43-e5b0-4533-8799-08da47ea68be
X-MS-TrafficTypeDiagnostic: BYAPR12MB2934:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB29344A89140716ADEAB36765ABA29@BYAPR12MB2934.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoD1K+A+yS9/bmz5k/eYnJXIukLCzXCYgZE44D4NKmf6OlYpVGzxnD8F/f8dXTrrS+7H5CrYQTvxXi0FeRDxdrvMYetHVk3TuF6uhphJxjkkGWDAmijAnTK8sC5g72X0UeRGWoFguLXlZJuCWNoOs8o+VKLCPXWtpM2gjGkG02mNaHnOgJY3IAq0CgplThIR7o07vDC91sujT7KARb9qYN+lt5GeVVJUshmV47tn23aEkK/7vDCO/m/8nMtakZ36jM/FfAHtgYgfWaIFzM+vhhWgER8Rv4uu7HNoqwxv7oKWhHXHeHjH7IkN6znXwSBnAcwCzGLJ09GhpPoISnx8dEbOEat/+pT9naR8ORtpq1qOJfCW5NIJ9tbsQxw6n0XgpHBUIAhAmBmTIGfn92HUWHIkNBUQb4KRvVncSYW/ohkXsA1TZtqnNoxBnbbiH9bHdtzOdfDi0p5IbcNERdcqag59RZeVAbXgOr4pIUengTFHgwpBMGUM4JcjOeecoxFRF6fUtxL50qQDp/YGG11WhQxzacw8qoJBNveKBJE1S8AZBf/Ufp8mQ5ClrYo2sreBipiejyZDC8r/zSYqgMlhakybA1VLZSyQ4pYztspGOT8/tUROYIuplE4WTO4owTs0NMEd+zbU8UGdCAiM9Tt3iXzt+DIYZq2qTw18TDw94lG4UybdzfV4lipc0g5mGBKYzRHpSBMrR3L1uhY5xJbm3Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70206006)(5660300002)(2906002)(55016003)(33716001)(82310400005)(508600001)(8676002)(7416002)(70586007)(40460700003)(8936002)(186003)(26005)(316002)(7406005)(336012)(83380400001)(81166007)(356005)(9686003)(6916009)(426003)(54906003)(53546011)(47076005)(86362001)(4326008)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 18:28:53.0489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 980ccc43-e5b0-4533-8799-08da47ea68be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2934
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 06:50:33PM +0100, Robin Murphy wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2022-06-06 17:51, Nicolin Chen wrote:
> > Hi Robin,
> > 
> > On Mon, Jun 06, 2022 at 03:33:42PM +0100, Robin Murphy wrote:
> > > On 2022-06-06 07:19, Nicolin Chen wrote:
> > > > The core code should not call an iommu driver op with a struct device
> > > > parameter unless it knows that the dev_iommu_priv_get() for that struct
> > > > device was setup by the same driver. Otherwise in a mixed driver system
> > > > the iommu_priv could be casted to the wrong type.
> > > 
> > > We don't have mixed-driver systems, and there are plenty more
> > > significant problems than this one to solve before we can (but thanks
> > > for pointing it out - I hadn't got as far as auditing the public
> > > interfaces yet). Once domains are allocated via a particular device's
> > > IOMMU instance in the first place, there will be ample opportunity for
> > > the core to stash suitable identifying information in the domain for
> > > itself. TBH even the current code could do it without needing the
> > > weirdly invasive changes here.
> > 
> > Do you have an alternative and less invasive solution in mind?
> > 
> > > > Store the iommu_ops pointer in the iommu_domain and use it as a check to
> > > > validate that the struct device is correct before invoking any domain op
> > > > that accepts a struct device.
> > > 
> > > In fact this even describes exactly that - "Store the iommu_ops pointer
> > > in the iommu_domain", vs. the "Store the iommu_ops pointer in the
> > > iommu_domain_ops" which the patch is actually doing :/
> > 
> > Will fix that.
> 
> Well, as before I'd prefer to make the code match the commit message -
> if I really need to spell it out, see below - since I can't imagine that
> we should ever have need to identify a set of iommu_domain_ops in
> isolation, therefore I think it's considerably clearer to use the
> iommu_domain itself. However, either way we really don't need this yet,
> so we may as well just go ahead and remove the redundant test from VFIO
> anyway, and I can add some form of this patch to my dev branch for now.

I see. The version below is much cleaner. Yet, it'd become having a
common pointer per iommu_domain vs. one pointer per driver. Jason
pointed it out to me earlier that by doing so memory waste would be
unnecessary on platforms that have considerable numbers of masters.

Since we know that it'd be safe to exclude this single change from
this series, I can drop it in next version, if you don't like the
change.

Thanks!
Nic

> ----->8-----
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index cde2e1d6ab9b..72990edc9314 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1902,6 +1902,7 @@ static struct iommu_domain
> *__iommu_domain_alloc(struct device *dev,
>        domain->type = type;
>        /* Assume all sizes by default; the driver may override this later */
>        domain->pgsize_bitmap = ops->pgsize_bitmap;
> +       domain->owner = ops;
>        if (!domain->ops)
>                domain->ops = ops->default_domain_ops;
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 6f64cbbc6721..79e557207f53 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -89,6 +89,7 @@ struct iommu_domain_geometry {
> 
>  struct iommu_domain {
>        unsigned type;
> +       const struct iommu_ops *owner; /* Who allocated this domain */
>        const struct iommu_domain_ops *ops;
>        unsigned long pgsize_bitmap;    /* Bitmap of page sizes in use */
>        iommu_fault_handler_t handler;
