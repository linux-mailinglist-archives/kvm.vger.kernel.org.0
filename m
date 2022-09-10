Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747A65B4AE1
	for <lists+kvm@lfdr.de>; Sun, 11 Sep 2022 01:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiIJXf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 19:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIJXf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 19:35:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2080.outbound.protection.outlook.com [40.107.212.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7903837FBB;
        Sat, 10 Sep 2022 16:35:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDa4rYgLtST0kgXd+0vR3h6n7voYpGSzhfOo7G0xUsiBqRSIOhk2wO6nuBRCZSg0rL/gbaSVwrPF82z4ibI0pw0Koal4r7s708yr9ZY/Oh4i7HU9zYscPtZZSIUxsidWe8igxKLmlNJP43OuivY9HPwd+3m8P+M5doocOGWm7E7YUj3YBVricb+WrHENXoiBgidRrJWDAxyjhYMHxxWNp3ZT14FEGzIrOjH77YYkEBfoJrCXzLHAf1ss/XiN3sSE/WhJ861oreNG51ChUnM4S2Ow7dCfqpDaQFJN2b2yCtPYh4vv4NNMc7Nj90RwZGqnaxzT78ZCzN1RhV+peKnpRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiiQ2fVCwucQ86iut+uJPfw8wrP+r+5D4oGRyrQQYdg=;
 b=D4oTpsruGKjz8AMsv75jebtmOvu/3mVSDWWt31tm1Q1/DqqRvwLXbdHBDAO2cwbybDzEtnwuS6C/I6zkaT4FTq+csVIUdUJoWvJMsfOQwcIBtNPEgL7TrqwPaQ7cuUW5UtoGw8/v/NE2Dxj9F97knGUZXfAkFoFq6G+qfrHuxbuAv1qwFAv9td2Ep8Im8NulGTSU1qV5NUzmHhkVLgYoeYonPpPdY/TorN2uWQSgOrDxI0A2xI6FLC5C/bkdQubf3fUPSRkyyKqSpaeGAEFgwnU+3u5NPPKvIc5UKjxhzRg5iT2Iui/lp9I5etkxkd0tESRnBLtyTVLJevpkTMwiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=marcan.st smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiiQ2fVCwucQ86iut+uJPfw8wrP+r+5D4oGRyrQQYdg=;
 b=ZNcuzyU0ABh6ylZfCjzUHuaYbfVjqC1lk1x4lTSBkfqm9+Yx8va8/HKkCNxaTL3x7HAxE1U+Evk26PRrGimYf85ddxzW/HvKz0Qv3uLOkrvkSNMB/owp+Vrtv/p9dkQk3lMVsKDXyUsjOz7g1VMVdJcV8yiHQysSTCuoUBVhvP9kC8AnoAWATa/Or3NBiwigwMll3MIqFUBymhk0DV+4NphdL4t/zH+9desET29/5al9ASeC4LBsVXmOGBzg4BklYfJ3syJh3aHOicm6ayENGJyfPLt13rO4kuYgb+ahQwts68wsdzpJViNOpKITcLj48PEUqlIMvBXgeEqlwc57dA==
Received: from DS7PR05CA0069.namprd05.prod.outlook.com (2603:10b6:8:57::21) by
 DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.18; Sat, 10 Sep 2022 23:35:53 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::84) by DS7PR05CA0069.outlook.office365.com
 (2603:10b6:8:57::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.6 via Frontend
 Transport; Sat, 10 Sep 2022 23:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Sat, 10 Sep 2022 23:35:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Sat, 10 Sep 2022 23:35:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sat, 10 Sep 2022 16:35:51 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Sat, 10 Sep 2022 16:35:49 -0700
Date:   Sat, 10 Sep 2022 16:35:48 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "will@kernel.org" <will@kernel.org>,
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
Message-ID: <Yx0fVJpaojM5RNR4@Asurada-Nvidia>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com>
 <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com>
 <BN9PR11MB52763FAD3E7545CC26C0DE908C409@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxnbRq5vaP/OL0ra@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YxnbRq5vaP/OL0ra@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT061:EE_|DM4PR12MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 553cbae4-07a3-4aa0-d405-08da93853357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/WahweSY5sdyGQRdT9z37i2UuQadHcBJxLw2LBACoyPIaatKXq8lF4zy2edv5MRddN1NB2n3vrGLLApxsZJMsBmy3kR+H3NSbaxwYB74s+VGDIJ+PD1VJ343we1IaZszEo+NHhefzprIM7w4ZUsx194GALzsmrx7vL2WXN8LKziML6ElIYxRTwsf515Z+QhgJxTKzEENflUz4XJehczg42d0/yzRbWUPXuja83xwVLZit+Iowa8CQA7j3PJWsigUxygQILuZq4emv0BOmef3GsVrETDXxR+ko5FTib4OryY0UJ/TB4bRkyHWSK+xcpXBYphIw56CObbDq9ZnKd8uVrmlVD6C5x82rdvofGKM+I5gz3FAzBUKFWzDflzFiqQKtqu4rOaccQ4JvKwMtLzAZdgKHLW8zuctDbsi3nB2Xphoe/fhGxzT5tMzsABTQid4zH3mlketz6XwgHFmi2WfB5/50XeW4XjR4/kFt9/n6Q8VFjIffDvO/wpnCxH1hzlPCJ7rhMjwOAFEVcpFCBQ6DcEszqgsiwysg54hgsvMUh0tx00DE3XTOJvnOxjBeg2VvXYNTxYPVLMMJdnmu/WoU2MZ4/FNCP4vWkP/aknwdGCOlAqS6+e85snE6PNV63BKG+sSIIZhH2G3nS78tYvIzbhPBn4VdFo1Tz9cUqgTEv8+gCAeVnKwIuB52Roxf7qim4D6ZCCWpxcHbf/DigPgB6aHNw6JuVBEXEWcdNwTm8qQQ9bzBZUMqnZhG/xOL3lS10sU7S2v7uIhzuyEb89BmuOn1/uTFuemLv2QO3Sn0eL/gmW4FP8kYz61EUDPkE/
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(40470700004)(26005)(54906003)(478600001)(33716001)(6636002)(316002)(110136005)(40460700003)(9686003)(55016003)(40480700001)(8936002)(5660300002)(86362001)(7406005)(2906002)(82310400005)(7416002)(4744005)(70586007)(82740400003)(356005)(36860700001)(70206006)(4326008)(8676002)(83380400001)(426003)(81166007)(186003)(41300700001)(336012)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2022 23:35:52.6423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 553cbae4-07a3-4aa0-d405-08da93853357
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 09:08:38AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 08, 2022 at 09:30:57AM +0000, Tian, Kevin wrote:

> > There are also cases where common kAPIs are called in the attach
> > path which may return -EINVAL and random errno, e.g.:
> > 
> > omap_iommu_attach_dev()
> >   omap_iommu_attach()
> >     iommu_enable()
> >       pm_runtime_get_sync()
> >         __pm_runtime_resume()
> >           rpm_resume()
> > 	if (dev->power.runtime_error) {
> > 		retval = -EINVAL;
 
> Yes, this is was also on my mind with choosing an unpopular return
> code, it has a higher chance of not coming out of some other kernel
> API

I wonder if it would be safe to just treat a pm_runtime_get_sync()
failure as -ENODEV, since a PM resume() mostly occurs to the IOMMU
that an IOMMU client/master device is behind, while an iommu_domain
rarely intervenes.
