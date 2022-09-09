Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23FE5B36F2
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIIMHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIIMHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:07:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53950F653D;
        Fri,  9 Sep 2022 05:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B00nukpiaouWrESuHMzlTQWIt8LAnlN00myVRFiQ8tqe1MdMWvmym4Hc01v0B0+SUeRas1dusZam+/k4dpeKsSDGYRm3HvL4Q80i55J1ljljJpCSjWBtLfY+NW75xIDUYxs+h7pkzudUCS0KbTHb6mBRfaOtoVvSDjQI1qFTuei1ez1Efl7sb10eVVkw60G5ZT+wdO7igEWaviMFYr19ssXS5Zlg0tz7Eww+t5Qb8bTEP56+u+IDaYwUu4OYAQaatudrOKmXM5JecNcfFafpsbPUuJCtPR+Oyy7GtDUeK+zEjsJB6GAUduWRkB0COu0qk4SKFqikyo/v2RGqI3cTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwZ+ncAsGDvDTUcaffwI8N5fKJsCdk1RcYxGsoIN4Io=;
 b=UBjnTngFuvO7+vy6Z3WB0x+Bt7j4hZ4CkB8pQRJPicp0T/uC7TvkTiT+CxOCINdXrpX6yRhM7v+HqnDoARs6SzvI0QzqUiZe61+s7lKObWx/L0MIaTD3Ipw9hDohiMQaVgwt9afupDG8FnMFjmLCbqQN6IcVZhQQ8t4tRAOzc2doA8/fy03mT7yx0w5SBOA58fi3WjB6VvGz3QgAOExOtx+S0a1R/Va6tq7tR8gzP7BR6hetKuzW6iGVJGvANnmzZXQPEIsLUocZwmt8DOLvMsnXWR8+hzMe4LgBqGrVrMTW4wcdDasjpGVQGNZ1jB7IaJkm/Rk4KDC5Om3GC4CXHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwZ+ncAsGDvDTUcaffwI8N5fKJsCdk1RcYxGsoIN4Io=;
 b=lyTusMJeJJYkY9WkkZBf+T0IyGq299DhhzkYbR31NtOpkO2BLgqYQwQ20cqBF5m1SuVTa4qDTnXUBLcf1DNGmNuwykzvHrQOwUqCkqytJH2E0tgDRLz76ijZJqJVnsON6EwcyoBRf82xapB5iq05fe3vt3T1DHzmZKVHVn9PGli5BrJN5GOAzstzC755yMcf2sG67QdAbOkuc9YkmAYu7h31kYMUU9ewl6zfX9BVNv+TR6q81eudhDXLP7VNsVlFH1ixzvabCB0BVPgoe7/4nWOI1ay9wog9P3sHfrF7px8W0t1dpgYYBcN8OTt/Ybrbe5vkZENd078MmqoZzm8Iug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 9 Sep
 2022 12:07:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 12:07:34 +0000
Date:   Fri, 9 Sep 2022 09:07:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <YxsshXKlidq8WgT+@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com>
 <Yxnt9uQTmbqul5lf@8bytes.org>
 <YxoU8lw+qIw9woRL@nvidia.com>
 <YxqwQ+3OICPdEtk0@Asurada-Nvidia>
 <BN9PR11MB5276D4CDC551DEA5962F9A178C439@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D4CDC551DEA5962F9A178C439@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:208:23d::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce2790d-faf5-4d2b-4687-08da925be108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpGzPH5dsGB1NiFKb/pVoxkD188JQVUUexvePazbBaJAppZCylyIh9BPnTcdemv2Ea2zEfaFkAX6Wy0EH20kN3bvAsGd+PEm04atBgVQHiX7D0mBynvC59WUe8ZPqyPImaEnXEq31DjCjqEQBj/qJYw0CJmcfvNygnxpXXi2o676lmdIJdly6EBlkQ0p3he0RlNd9iadf4fkapTbgtuotj0nne5eTfyxrJ5qM6ke9rsojIUm0JEYrSAXax31wJeKvbqVCslOp/c9LjkLcXPX2i+ciUignKQEiAMkOq/CvRjRKKVBFTJdZbjN80u1E4l3F9/Mlj3P0xFW5GsXIWS1Oq32qY67LsAL/Kesqd1llYU4n44ktcgUMnckaVZiOcR6OhrtN772nLFhkQLeTFp1D+54FKo7t34vHYo1OllRShjjwcGhiZcSmP76xraZh++iZ+9laH9+AfdfDUePgDNAC2PAyOma/jMvc1wt7pdOk58w49Z746WtwDAY/Uo1k/wFoGhI8Nid+75pnDYAdffQcGGLzDTe3E2uPdTQB6TfYBlxzMDjU+RvvxR8xBbsUMrgLNWrRIbbC88QrJY/gh1GcZ8XcxgFoLxICm4+t37Hb5netBUPakFe/kBr+h6ptSyXYgQfA0nAlK/ZL4qukK+BhShQIyBNqsQrzx7GY5CwpnThS5NYWfWdKPGCGawvvc60bCoBVBF4p8zto6Qa0iFdqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(6916009)(54906003)(6506007)(316002)(41300700001)(478600001)(6486002)(38100700002)(26005)(86362001)(6512007)(186003)(36756003)(5660300002)(7416002)(8936002)(4326008)(2906002)(7406005)(66946007)(66476007)(66556008)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wswE3pIfxZbTKsUzF+6sst4J3x3rNGDr8FTpfVb9U/VmHOwNneoqbNxyru4t?=
 =?us-ascii?Q?3RLj4Vbom3kzX5HVGWHPcmV1zHaig/T4beLLfUqupXvO/0TIykYROZuOHBMg?=
 =?us-ascii?Q?GkGBmaG6HuwNGwhApYDf45zBQpUf00ukMHQHpX7XywZ/6gwkLW3/UYUolRp1?=
 =?us-ascii?Q?57bcqWFaAc3N6UpKc9orQ9PtyYuogOOM77aLjI/m1whWdJQr6/h9ANGpQ7gS?=
 =?us-ascii?Q?Ae8zO+7RK6uqZJwkTEHpiUzpvfD6VaXSVWlmBqx7w/dkJHIpDxQL9x6/Jek/?=
 =?us-ascii?Q?D3X3bikisoHhtVBoB9M44AvgZOi+EQO4KiE6QDlpldERqxrM4HXM+PWtoAxR?=
 =?us-ascii?Q?j+GIjfTOAokzjHUOKTIb9ue0m6YtQyoYwd+JcFX1+1jVCP8o+AzhacoOWt0c?=
 =?us-ascii?Q?xZ69iqoQWO7LaiIVwxJKrP5tBFNAd4xVsdw0Ym6UZWX3GliSKAgbV9S92LIT?=
 =?us-ascii?Q?ZKi3NJezfN6X898WCTyLv6+nz8MJWnStkz8m9hi5uM0QDzkx0YArCH61T5PV?=
 =?us-ascii?Q?nlLqMKeQ3s5ab8T+GIKMwHbtike8NNsb34zfeJU1vkJ8LnhxmCM7YU7Camsz?=
 =?us-ascii?Q?QUACud74qtLAkewM2nWXySkgsJR9utPOR6nLxHYn3HVznnr7pxPJQKrUu/CB?=
 =?us-ascii?Q?jLpdk0AmDx0se/0TSXvDyxsmllEAFEqpyr+3rAhgbUQgU/unnmq5do00tbL8?=
 =?us-ascii?Q?9sqLuOVCdnU+snB60z0alY8alKmYTrYU4nv2r+KVHOP7agF0VQMm/7FpmE8A?=
 =?us-ascii?Q?WAz69r6YHU36LTKZ4YfkyguvFmw+XsDHcJ6YWELfDuD/kfrpPN2GrhqOlIre?=
 =?us-ascii?Q?xLYhrpTTO1JS9BNriz1PIkuP1uG7dblzgHAd4EuHMwZzJb7QeRNhVPwHev4L?=
 =?us-ascii?Q?TeTvPnx9b0V1hVt6Zlz1zC8Bb1q5wn2oZLpqdHb1wLa1eblzGA3jrIOaYmZ9?=
 =?us-ascii?Q?tZD9fhJu1IEi4HuOCp+fS+R1fPdwZnsGOu/+XRdAJfMOVlBRC6zixeHf1QFg?=
 =?us-ascii?Q?IXJFolor94PRbws/Yy7bUDfcCbMHO3OEw+WdNcHseCh7xSYkaF/h5FB9+Kv6?=
 =?us-ascii?Q?uZJNQAusRqT+vaa0bdiCiB5LsfE2ILTeT9cZ0+GF5twGs91D8vdUiFcZ6DNx?=
 =?us-ascii?Q?ZhCbpu11Dzps9oUeSaL19LwtJtiHhUDn0lLHN6fq3A9z0OUfAoYxCYVYNMDZ?=
 =?us-ascii?Q?GrKnmQm/yIYKwmgEME5M56jMLK8gBS1sbdl7j1CBULUwJTBu3yztMdBt9/qB?=
 =?us-ascii?Q?wr7PU8wIC8Z//+Do0BnWNm2CmuManhc3aTFzEw8P95XigYws1aqOfhEv9FRs?=
 =?us-ascii?Q?m3WFcbca5DKwPz7cLTEiG4NyOUnEleIeZdrn65Sqr8b6Yo0tDa02p99m9yMF?=
 =?us-ascii?Q?SZCpX83HleE+jfrnfmIpppLuWX6NhrY/CMoP1XTjFv9ALq2Tc68v5RsmPcZh?=
 =?us-ascii?Q?LOfIVPn1N/ev1/rkRFDiLxdUFG+9thr7rzESK26K/KXWuo31iwRKgy7LrYsO?=
 =?us-ascii?Q?8QPyeqDpTlvqbqqIG9oLgU6rAUfXmDiB9CFQjAnAK8eftMNzNuib72e+Qnu+?=
 =?us-ascii?Q?HVyqWO0yzAmnkLnVA49Q6cyz3PFFlMl4c45qR1Ms?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce2790d-faf5-4d2b-4687-08da925be108
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 12:07:34.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejCYihcDn46SxiPdi4juY2L32J5j6+PYHbbkbIWsrp7LTbDa8hyspCKJZk2OgCl2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 05:00:16AM +0000, Tian, Kevin wrote:

> > I have started this effort by combining this list and the one from
> > the side thread:
> > 
> > @@ -266,6 +266,13 @@ struct iommu_ops {
> >  /**
> >   * struct iommu_domain_ops - domain specific operations
> >   * @attach_dev: attach an iommu domain to a device
> > + *              Rules of its return errno:
> > + *               ENOMEM  - Out of memory
> > + *               EINVAL  - Device and domain are incompatible
> > + *               EBUSY   - Device is attached to a domain and cannot be changed
> 
> With this definition then probably @attach_dev should not return -EBUSY
> at all given it's already checked in the start of __iommu_attach_group():

I think the EBUSY would be only for non-conforming drivers. The API
semantic is you can always attach a new domain and replace an existing
domain.

So things like AMD's "can't do anything but idenitity on RID when
PASID enabled" would be -EBUSY.

Seems right that it should be rare though.

> > + *               ENODEV  - Device or domain is messed up: device is not mapped
> > + *                         to an IOMMU, no domain can attach, and etc.
> 
> if domain is messed up then should return -EINVAL given using another domain
> might just work. IMHO here -ENODEV should only cover device specific problems
> preventing this device from being attached to by any domain.

Agree
 
> > + *              <others> - Same behavior as ENODEV, use is discouraged
> 
> didn't get the "Same behavior" part. Does it suggest all other errnos should
> be converted to ENODEV?

It says all other errnos should be treated as ENODEV by the caller but
forwarded to userspace for further detail.

> btw what about -ENOSPC? It's sane to allocate some resource in the attach
> path while the resource might be not available, e.g.:

Seems resaonable that it is similar to ENOMEM

> As discussed in a side thread a note might be added to exempt calling
> kAPI outside of the iommu driver. 

Sadly, not really.. The driver is responsible to santize this if it is
relevant. It is the main downside of this approach.

Jason
