Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE85B6724
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 07:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiIMFHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 01:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIMFHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 01:07:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3F1181F;
        Mon, 12 Sep 2022 22:07:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ6rk1wDg7GFggyVeAthKsN2CS2TsrNgcqZ0EvaNBink4ZS/kR1GMirFMo/GwVm5+d/5HTkE0jMkm0xHwueHOkNV1FigUfpG1Ejma8ChYzNOEoUSZOgN80oiBkXUuiUfVZA3HIqidq9GajV9RyHtT9HTi8rR8/Opw7bTdj1vIQNI+xnyu+J/pUvUpHcOn8YL+JPJP4I85dtss8FBK9/6NHooydttO1XtwnmQqQ2NdOyuWtA0m+4bDpdPWQ3WqMXJ2yd0gqS1amCruBWLZS69X+xo54gOkqoJjty43QeiTLtfVQRH76TP8klzHOkGCQGaRIWK4y44toMEgA9dW/Ir2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPncQRs+oqUMdvv8X1zP5Q8/+6v6+f5DRQF4Da73tCs=;
 b=C/OYGbQwleB+xkDcKSAEPT2+wNhdE5nM+yBkrU1ZMnQbd6vr2EGIjWLp1IQSPYJUBmDu+0gbGXiZHxroUWrha+PtaZvpxMlAd+fiUt+mm/zoYBQRT+vA9BBwvid+OqaMCu4/QnY44bD3ZiqxoQ3uzCxPrwf8WIBit36KkOeZ2j/jXwUjJbIAqMoTQK9PzZOYbZCJIW14dhgVk8fAUyYeHA9dww8F6OCdd0Xk32V1KGWAU33PrqnBodExWGQEMZsEc4sv3a35LLWEmIR8jh4a96lg572ENtgEhlmtkKx4NoWOh7F7+JnEgGnYYImMZldSqzl6F4p7XGvoYAXDgkSkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=marcan.st smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPncQRs+oqUMdvv8X1zP5Q8/+6v6+f5DRQF4Da73tCs=;
 b=gshcVknPWJ9gmAK3s7QFYOizsJvh25BPo7esEADtT5ZYxJ86bS1AVsOAXnlPcFneq7N/xUTGStfyhIhk2do7RumSaYLkkVlUKBrB65013TUrfjgyVyV9Xr1mLn+jMPcMhW7AoOzu4pDjkiG7jkqKOzoeUCb6Quwy7WsZiNthc9MIy9gXUQhjxt2R/VdzJC+U3k7JIoHjZ7JgPC3vZIGhuKScXaLCNqCUfgTEMLCU3QlaDRuYqhu1j67K2kZK8SoTVERbxcZZSkSh02Y8PCfLrp68eMrn/ROU9eoijEQV3PqlR0bIfKWBy+09asUeaFaWdYiAl4Y9mGuCz6b0+RdRfA==
Received: from DM6PR17CA0002.namprd17.prod.outlook.com (2603:10b6:5:1b3::15)
 by SA1PR12MB6726.namprd12.prod.outlook.com (2603:10b6:806:255::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Tue, 13 Sep
 2022 05:07:43 +0000
Received: from DS1PEPF0000B073.namprd05.prod.outlook.com
 (2603:10b6:5:1b3:cafe::14) by DM6PR17CA0002.outlook.office365.com
 (2603:10b6:5:1b3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22 via Frontend
 Transport; Tue, 13 Sep 2022 05:07:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DS1PEPF0000B073.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.12 via Frontend Transport; Tue, 13 Sep 2022 05:07:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 13 Sep
 2022 05:07:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 22:07:41 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 12 Sep 2022 22:07:38 -0700
Date:   Mon, 12 Sep 2022 22:07:37 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YyAQGbG1NUEMN3jn@Asurada-Nvidia>
References: <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com>
 <Yxnt9uQTmbqul5lf@8bytes.org>
 <YxoU8lw+qIw9woRL@nvidia.com>
 <YxqwQ+3OICPdEtk0@Asurada-Nvidia>
 <BN9PR11MB5276D4CDC551DEA5962F9A178C439@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxsshXKlidq8WgT+@nvidia.com>
 <BN9PR11MB527670BB3EEB81064DC811828C479@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527670BB3EEB81064DC811828C479@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B073:EE_|SA1PR12MB6726:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e76b3ff-0212-4044-392f-08da9545e380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqizB5ozo/odjB1NH7/0SLN3JH2vKgZL8CKGrtbJLwwkiMgZ5Igs1mFl54bcm7syCm5qn3ZJsbH0uwiy2utN68bCp9UtMBM8gTWp2WjrnsWecFdy8tRfkhz6qkzwWL68kVL9F6KKDtNWoxP8gG/Ai8IsOK4sb6GJuHO39VOUEw8+11C3y/ESjrBH3PaEb/RvTXk/BC41NJkSuEckfr/6E8NlydoV74Nfz9FUDo72QBUoHdNISfV7rG48mBarowj9TRxWZtspEoexCmTcPwDKBJfHcOMop5OhqdKY4NLT6aYci+H3gOK7pkXBANJsb1w0rI/TjvxcCycY5OuLMhDsxUwXUsejUUMwP9crK71Z+lYKUlREw8FAqvDOew90KZpKLSTXHGtT5opguv4/77GzqV/iyVIwNYGYP3L81PM6C6r9irX9cU9ZVz7VUo0DDJ8wj31nY0UnoJPv5LIZxepikUIc53DLu/MiWi29oeKIyDgD18ThLcIch4SZNVpzgtNM4RYDufpF0ovM4o/+s7XV5I+JSkIT6f5MGLcJ7gprD+cT6Hsx4H83Kc/DGwgLt6JuaHKxvKIUSao7mf4eUmjDKtXMCiMEP5Z+0kNBqJwm/3ICWoJBcoDFQUn5lTA3mtPBpohRLZfxMKvN/n90dA3h11FugQrYiq27Pk5VHEqmPuSi1BROqFEDo4l9V7YrqpxPB1Y1smvdnZdkFU75eUTEm5Z/dhjZt05iQjfBJtBfNkSBNn8Y6OQ5tPH4TdMuMRfzdIIoXDw49vcHKyrwcxMmFqojBJnzKjDjCTS/GISXniZM2BoIv8qzpt873wd6t3Kz
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(86362001)(336012)(82740400003)(478600001)(8676002)(33716001)(316002)(40460700003)(55016003)(356005)(54906003)(81166007)(70586007)(7406005)(8936002)(70206006)(4326008)(36860700001)(5660300002)(7416002)(82310400005)(26005)(47076005)(426003)(9686003)(41300700001)(40480700001)(6916009)(2906002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 05:07:42.5021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e76b3ff-0212-4044-392f-08da9545e380
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B073.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6726
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022 at 02:22:17AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, September 9, 2022 8:08 PM
> >
> >
> > > As discussed in a side thread a note might be added to exempt calling
> > > kAPI outside of the iommu driver.
> >
> > Sadly, not really.. The driver is responsible to santize this if it is
> > relevant. It is the main downside of this approach.
> >
> 
> Better provide a clarification on what sanitization means.
> 
> e.g. I don't think we should change errno in those kAPIs to match the
> definition in iommu subsystem since e.g. -EINVAL really means different
> things in different context.
> 
> So the sanitization in iommu driver is probably that:
> 
>   - If an external kAPI returns -EINVAL, convert it to -ENODEV given iommu
>     domain is iommu internal object hence unlikely for external kAPIs to
>     capture incompatibility issue between domain/device;
>   - Otherwise just pass whatever returned to the caller, following the definition
>     of "Same behavior as -ENODEV" above

I added something similar. Thanks!

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ea30f00dc145..190647d018f9 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -266,6 +266,17 @@ struct iommu_ops {
 /**
  * struct iommu_domain_ops - domain specific operations
  * @attach_dev: attach an iommu domain to a device
+ *              Rules of its return errno:
+ *               EINVAL  - Exclusively, device and domain are incompatible. Must
+ *                         avoid kernel prints along with this errno. An EINVAL
+ *                         returned from a kAPI must be coverted to ENODEV if it
+ *                         is device specific, or to some other reasonable errno
+ *                         being listed below
+ *               ENOMEM  - Out of memory
+ *               ENOSPC  - No space left on device
+ *               EBUSY   - Device is attached to a domain and cannot be changed
+ *               ENODEV  - Device specific errors, not able to be attached
+ *              <others> - Treated as ENODEV by the caller. Use is discouraged
  * @detach_dev: detach an iommu domain from a device
  * @map: map a physically contiguous memory region to an iommu domain
  * @map_pages: map a physically contiguous set of pages of the same size to
