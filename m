Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EABE559A43
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 15:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiFXNQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiFXNQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 09:16:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE42451E4F;
        Fri, 24 Jun 2022 06:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Afdwoy3Dv8z32Itpg67fkvsaiIqub3Ngmgy6Oq2/TIaBaUedqJmGYlWaqX4w9oBgLNhIT/dVz5OSGpKzLAzCRn3GrWn1SnQR7M41776fK6nPE+/2/qxVMD3+x0u//geYDkNhHdjEsZD31OdFBhqu8er10JvD8DwdGJXHFlu8E6oUIlWgBJsP3duljtaCkxgUfOmvni+SG1OtbDlRTXg02R3GNT6X6idx81oye5uVBYTbC48gvee/3xOe0uNpVMfZoJV9L+2syaLJ6stUBGnUQOLZuJvF7mocWBhn7ka5iGpk4k3CuscbBoN8V8OSeMhB4xqELYZd+/78beF8ArfqAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c27UzObqDWTbSWIvOHWgj5Oj+0yv/K/TxsB332yb2Zs=;
 b=JPLF3kA4D6lK/n1O7d3ODBeSQmML+rjH1KPqt4S+4B8QCZCTzsIRZppZq0lyxXujikEUimzsHcLW7pfw78ZnkF6Qeyqo2DL3U1nVdFhvXWFD49DtJkXGIpDoitR51CCxHavLb72Dq0CCfBnA3NUHr7mEvIDRJuAEQsRLtkMLBIICF819V/tEE3z1Efzg/vWsuJ4WWR4V+5++LRv1Jdsetm87KkgcKCPrJmfsx7bBb38cPJtTopHbH3mAyt45ZESO8jloxrdqnOKwyWPDZFlXKT6x7qKslSUcSWWhsrYf+DRAV5/+qkss7voQ18UMFhsNgMtX17E+pyiROkM6sDeozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c27UzObqDWTbSWIvOHWgj5Oj+0yv/K/TxsB332yb2Zs=;
 b=t5vL10xRDTxbNLLFGOkPXFA5me9K5akVhl/b1tLO0re5We8Ek62nSErZFmEo2AaQ/Lvqlj4UnodQChpriBdMDd92sKFAL2qP+9kEt6V7S4XiXCmP3OXKq3OsZrKOr+Uky7Ure9kIOqHPpKaZSzxlLFP1/2shCGLIDcq3PNCFPr34fIUF/1pm3+ZPqsSJGZLR7PJFJBEU1PKRXa7CcneVx4Sj4P65oW8Xg4ApbUYLrCsdot3kHpBVQ5+qeJyHrK15g2PCmS5S82hX+aPP91KV6tnvlFpIqCrE1n/d8qeWNlIq2vfCgnRtoaWA/zDO92sFECmskTNePvLjSZA9M4eshQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5367.namprd12.prod.outlook.com (2603:10b6:408:104::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 13:16:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 13:16:13 +0000
Date:   Fri, 24 Jun 2022 10:16:11 -0300
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
Message-ID: <20220624131611.GM4147@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
 <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YqutYjgtFOTXCF0+@Asurada-Nvidia>
 <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
X-ClientProxiedBy: BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ad22d0a-4b79-42e7-8304-08da55e3b5f8
X-MS-TrafficTypeDiagnostic: BN9PR12MB5367:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/1dZFsXJxd4Cp18TvkRctN3C4qD05Liz20MTClISjopZ7IILLZHHNr5CgWAo/005tbLjLyPWVnBTKi2kscERoNRE7OQwaofVKkuTeoDcpsS9b/iVwqF/iFJqhehWnRvCUvJF2cvx+ipr6RXLcfaLZzgqnUNqOWyLlvmjpDQ54NoNDjPQMPKGysDzrZETMF8uhL6yKg26DioGpuifLN0UnUW8+zKG/XtAM2NL1Dag/mlNvXd4FIJqvg20i3hbVTmkEwgLzS6ck/9M7e16DGxpypoZyf/G59HXu/aH8rKvmZ9huJ77f+UShANia1yLpT2EAHtAiFaTpvJan72YaNJ1WCSQ4GqXuvvdXColIRz++++lun/IbQtJrcakSW5UWvemUtTs8wXu+bbK6xCANVOU2IAmZkYo1hyWg6Bel9qYhJ+NnDN3auWlt0Xo7ZavpyUm3o8oFp/9r+w45XaYuwy8rXZqMNLNf69BWoaivcqaxn9Idsrh/l7j7ZT6L2V15o2vyf3/HJF88B2KELxFrsP6+nwIBrjrH2pOrhZDS3nKrv4tX6i31M4AyDO7cPSNmAkWGWdkP6uVt2IsO0l7h0Wivh0s2nMDfJfKmJ5XBmp3HQwS70I49nGiX0Yl+a3UOVH0HPU2e2a4XdW69kVyrRfpgZx62ni+1tovQ1tBLDbvt0O3QLNzaY6jD8ltj/r9lERtrY3p1qYg/UaQbd9s92LjJ4DztGuNtS1tsp4Dsb9LEk9IBVqF3ga7wCCpM3R4p5w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(186003)(478600001)(6916009)(2616005)(54906003)(7406005)(5660300002)(36756003)(41300700001)(6486002)(8936002)(1076003)(316002)(2906002)(38100700002)(7416002)(6506007)(66556008)(33656002)(86362001)(66946007)(53546011)(4326008)(66476007)(26005)(8676002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEZRc3ZIUi93Vi9wZFZibUEwWHdQUHVuWUlZMlJXVzFUQkFVNENGSzJkN1J5?=
 =?utf-8?B?YjNycksrQk9hdVJFUkNGK3lLa205S3ZCSDg3THpWcXFlYlFRTnp5bGlWd2Uy?=
 =?utf-8?B?bkNkK3F3cUNqczFTTmJjSHAwSmlmZ2UxRnovSGFUZkVmVmEzazhXbGRHQ1pS?=
 =?utf-8?B?ZDM1aFlrbTJ0TFJZSmJXcll6dGljYmlSc29jbVdNdUpkSFhMd09rZGpnVkEw?=
 =?utf-8?B?bTI5MG8vQ0taclM1K2JsSlJDMzdnQzI4TVdVNTNSaXlhVW1IVVJOUXVlMXpV?=
 =?utf-8?B?cDVyempaYjhxMGR3WjFwTTlJMzhNc05GQUlRdTh5NU5CQlhUczlvNHNHazBj?=
 =?utf-8?B?V3krdy84T1NWWjFTZFMzRVo3MmtiN1YySWR5U1poVTN4d0VyUW5ZdXhhNFV0?=
 =?utf-8?B?T0Y1cWxUK0ZhdkFsS0VZcFFYaEJpMUFhc0Q0amRrRkdLTk5qdGxSRFZaM1Qx?=
 =?utf-8?B?VThTRVBmTGg2OVpVb2VFZmF5cWZSaDF6SmhMbThTOEc4N0hralBHZUhJR2pn?=
 =?utf-8?B?a3FJd1lEaHQ4YUpQRnExWnZQaUx4eGNoZXFjbWNZMEFxUWR0bnE2amdOTkRw?=
 =?utf-8?B?ZFFxWDFkak5rMGJUSzlLQ2NCSmJtQnhyOEIxWDVaQW1LU0cvYXVmUi9hb1l0?=
 =?utf-8?B?My9mQ20zTkJYWHhXMm1ZcUdHZmU0RFQ5cnVQNDhxNHlVT3V1WEp0UjREcFFG?=
 =?utf-8?B?REpFcHk2emtrNlczVWVuN3dxbEFsNU5heGVsd2wvTXg3ZHdPcGNiL1ZkdW9D?=
 =?utf-8?B?dVpYUFh5YlVsSTVzK2tZS3ZOa21rRWxnd3F2YlhJbVVmdzc4aWZWWXpGWHBD?=
 =?utf-8?B?VVRnMVFqLzJibUNEU3h0SjNleVUvUFFCbDZqVE83MDNYaWJ2U00xbytDd1Rq?=
 =?utf-8?B?TlFPeGhqTWdoR00rQXh2UTMyeTJrRlhTRmJ3SnRhVUhSR05POGQ3bUFXcW5l?=
 =?utf-8?B?VXJ2a2N2enBrK3ViQjhkbDBnRURXZ0pPQSs1a3A1MThUb2czOEM2VlNwdnBL?=
 =?utf-8?B?ODEzdGZkS3ZYTGFhVVhpSFM2d3p6Q1kyajdOTjM1ZlRydjNHUnpPaFBwQ2V6?=
 =?utf-8?B?ak5PZERuWjdlT0tNN0hVc2RQWUFFZVhTam5RV2lnN0JEd3hWWVU0aENKT3Qr?=
 =?utf-8?B?S0N3OEFUbzRHYWFiaFFjcDVuRlVGMy8xWityWGJ3Z09ZcHRaRnMveEFyRlJs?=
 =?utf-8?B?ZjRoZ29SUlFrL0V6YnRhc2Rxd0twSFMxZiszOEk3MkZjMjgvNUROdVFNZlhs?=
 =?utf-8?B?NDZmUmg5SE5CTTc4eFJQNXQxTDBPRVE0akZIZXRZQ25rNTRkK29adWxDSHl5?=
 =?utf-8?B?U1llTVJNeVFTdFZvVFZaV3JBejA5REdHenUzZVdBT0ZyeTJ1QkJuYXIxanA5?=
 =?utf-8?B?TUtqeC9RSzBNNjVNa0FVUWhnOGQ4MTl4THUyR2ZvRnAwRks2TDN0bDJISmpy?=
 =?utf-8?B?eFkyK0pwMXprKzhhVFBqMkVLZjBDcEhrenh6Y3dRR3hTaWUxRHNzaXRNZXpB?=
 =?utf-8?B?c0lnTWtMODY2cjBNSW1aeGJEWC9jeCtIUjgxOTdabXA5UEZ3U0VrMEpmMUty?=
 =?utf-8?B?S0hWMmNadi90ZzJPMlFGeEZ0QmxJclFwMmI2ZDUrTUE2Vk85aSt2TmE0cWQz?=
 =?utf-8?B?YzNnREc4T3pBNGJ6U0YyNklXM0Z2dC8wa2RwbjFaUTdPcTJNN1VxODkxZkNC?=
 =?utf-8?B?Tmp1MVl6Y2gxaEhTUnBEOTNQU2U4NHMzUTB5MFNWTWU3alZiUzl3OVFObXhv?=
 =?utf-8?B?aTBCQTJkL2Y0WXVOVmpJTzNmQWNMTnpXSW9TY1pHZktUbXE4WG1Eek9YWENU?=
 =?utf-8?B?NGplYTdwdlNZMUdPQjF5alVjVU5iMXVtcDVuNlFlQ1JVUC8zemlQdXU0NHdS?=
 =?utf-8?B?RlVQMHFyWkUwSWNSeCtIYm4xcWNUbTJoRWEwZXdDV1MreWR2QXRreXA3OXlR?=
 =?utf-8?B?eGtSZnVZczVCRmNpV0k3UXphS2luc1pDazJkbFdJQWtBOGo2aFFXLy9lWFYx?=
 =?utf-8?B?aDN1bjF3Z2F1blBadmQ5ZW9VdlF0Y2lreEJBYmVFZWY3N0JSOEhTaXY2MFZ4?=
 =?utf-8?B?SUpsU0JTRFNycHNlN0cybFliWDBPK25kQmNSODh5TTJWUncxbUNGMDlkd0Rw?=
 =?utf-8?Q?gYKiWo+10HdHN3SXMIqFWzl/S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad22d0a-4b79-42e7-8304-08da55e3b5f8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 13:16:12.8996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnHhdaxNeLFI6IWXnhQLhzikTp+6GnxdJLINL7Mm2a8zeBvwXcMZ+vLxZQn7iKFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5367
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 08:54:45AM +0100, Robin Murphy wrote:
> On 2022-06-16 23:23, Nicolin Chen wrote:
> > On Thu, Jun 16, 2022 at 06:40:14AM +0000, Tian, Kevin wrote:
> > 
> > > > The domain->ops validation was added, as a precaution, for mixed-driver
> > > > systems. However, at this moment only one iommu driver is possible. So
> > > > remove it.
> > > 
> > > It's true on a physical platform. But I'm not sure whether a virtual platform
> > > is allowed to include multiple e.g. one virtio-iommu alongside a virtual VT-d
> > > or a virtual smmu. It might be clearer to claim that (as Robin pointed out)
> > > there is plenty more significant problems than this to solve instead of simply
> > > saying that only one iommu driver is possible if we don't have explicit code
> > > to reject such configuration. 😊
> > 
> > Will edit this part. Thanks!
> 
> Oh, physical platforms with mixed IOMMUs definitely exist already. The main
> point is that while bus_set_iommu still exists, the core code effectively
> *does* prevent multiple drivers from registering - even in emulated cases
> like the example above, virtio-iommu and VT-d would both try to
> bus_set_iommu(&pci_bus_type), and one of them will lose. The aspect which
> might warrant clarification is that there's no combination of supported
> drivers which claim non-overlapping buses *and* could appear in the same
> system - even if you tried to contrive something by emulating, say, VT-d
> (PCI) alongside rockchip-iommu (platform), you could still only describe one
> or the other due to ACPI vs. Devicetree.

Right, and that is still something we need to protect against with
this ops check. VFIO is not checking that the bus's are the same
before attempting to re-use a domain.

So it is actually functional and does protect against systems with
multiple iommu drivers on different busses.

Jason
