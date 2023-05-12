Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD0701006
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 23:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbjELVBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 17:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjELVBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 17:01:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6BB1FEA;
        Fri, 12 May 2023 14:01:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkknudLHyJTJYONBQe8tbgkV9QhKi/92iXXLRQffVJAZuqAJOyM2TJJftj+W9o91lacVF6A3keOwH1VzOG5RJ9J4Ut+UK/wWG3mczme9jVgM/jYChY2N52TyRKPXKWzhwSNTYayXa7bI1tJl3NPydUCyUBzEc+jKVeQEVpf32VHkFjlCVNHVOosBVOEedHRqIbfqb4L9r7cPlBl7O0qm0ksdpiSS4qq4U/h8Bdhh+N0ijhiGMSjPrMaVTwn7QZB+Cpsl/wt8TIguw544Q9s2eNBIcVC+RjLXJGAeIMr68KYU8DJniktT7QO8GT+maUqp5lNUEzwfP1OmmW61J6oX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEpJ+RI4BMrGuDZySQ74Bd/DsKJWAZMaf2vCOyRJLCs=;
 b=e2MqWaFD+9UINXqXESwk8+cP2C3ZrLqW22YiZGPTN2DvYAttVv32w+eGUlQlgzHyr9FkqQFYoLhKXHOH7hqP7fHbZMCRnHuwO3RT9P2Hz3G1vpumppNDlwPRTRY3lx5a3cm7r4RF74OV94oqJfbmVuqAMLZ0MoAl4OwmLAYTEX3zzV7nS06gP2GJPNxU47bHGepS39ObyZASFPp5fTVKlXGNwarBTUgCm0Qnb+pHd2y+1p9xMNdiftwWtmYBM2HrFBokOo3oiGqbaSWu6qxL25vZhnOucmooLiLSPwW5juwu5//FWVsTrAyJ6cXu3KeySpt+rD2y/2ct2YDiFq2vsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEpJ+RI4BMrGuDZySQ74Bd/DsKJWAZMaf2vCOyRJLCs=;
 b=AP9TgtkVuYCyvH8lMlJnGF0Mx/c2KQ+v8rF9GIhuLd+UXucfkLiUS622PXkqhnpE6H5dmFTwk4jqERncSuWeqbFm+3tKc7tIwgnyi+4eJ8KpctVvlx5esoFkJwgrfIy3wJiuJ+ldqSO5d/cUfi42NTTMhPdKQCiRg08mNwTuvCFuqhFiEm5yDYgc9xeBFysL6yGtSBMPjdHrU8ovDECSwLB7oWMzSWuri4tiypDdm+pW8XAydQcd5Rg1oW16pfZtx0wwN6gNbRiGgQLhHpDudQDJjbspFY9SoEIHiTlwZryc4vooCxKJ1BGOzF5L2j5Gbja+9J20yJ7mAmFUZ/DpEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5857.namprd12.prod.outlook.com (2603:10b6:208:378::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 21:01:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6387.021; Fri, 12 May 2023
 21:01:45 +0000
Date:   Fri, 12 May 2023 18:01:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZF6pNjFCBgLt4phV@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
 <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <49063f2e-4ab5-1e20-093d-e1a0b3c15481@linux.intel.com>
 <BL1PR11MB5271F073616B5869E380DD208C759@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5271F073616B5869E380DD208C759@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW2PR16CA0031.namprd16.prod.outlook.com (2603:10b6:907::44)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: bad72617-5317-4ae5-dad2-08db532c17e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: spjb9aRKJ6G0KYcza9GPSuAiO0EjPDxa2TH1XXUuSFkQbO2PPZP8evc13xuZRXkYZ8Vdi5ByiZAtffvdkbJDOECyFHwAZn6Io6dScWOyFm9yk5A1GY2n42RYAXBjhrvsuIvRuWU4MM40fBNG691AfDzTRPSeGjJSn8kZ8uRwzC6YoHQ6jk3JlyqymYyzloE70+w2QYYm8D5Xjtd8BXNGW6ijwJskOClJHK4pKeYWXEikizSw1wiCX030Wi0IqMIXA5BoC6NHWkqRMXZfNdEshoD5qmWPywYxlAu4BM0VPAv9eky/BVKlwPt8qNbiU4YyIX+Y7KmMhXG8zHuzrr/lKKE96HdfGez/YG3UkXde8/waXqicbfQeCHvRdtuM6wiOmwqVBKbuVf85qJTaORzcNAPnoXAGGHBfuX866L5L87TpjtLnlAN1ch47H6n0QqJVfOs7S0tk6XDaLrWRkZu4aPvq0cSDuqLgvrxbpXL3dRMCU6iQatBX3OmrjBVBMWYRum7HPH095q9f0Dl84XTtuKdgLc7OU79JhToBZaSJyCyVV+hhDSxhGJjeb32q0+BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(5660300002)(186003)(8936002)(8676002)(2906002)(36756003)(2616005)(38100700002)(83380400001)(3480700007)(86362001)(66946007)(26005)(6512007)(6506007)(4326008)(316002)(66556008)(54906003)(66476007)(6916009)(6486002)(478600001)(53546011)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ao8jG51LAKIFgDGLguthxoXxDZ+RjFAO/Gx2ecJEvqZ+LzRESIjyXzrCYSPZ?=
 =?us-ascii?Q?/mGi/n+QnIsdqYob3pQseezeUXh1xSKGLro77iJ/g7p+CPcO3XrcmYckN664?=
 =?us-ascii?Q?aDh/o8tAkqOCepgDQnfZZTSV4VKqZNmebT2yk6ZtwIA2mFRdRWyBKKqhSCEq?=
 =?us-ascii?Q?wFmDT68SSCqMyo/3VKtkz3y7hYJZRQAlT5LaeVWZuF4u0WXyMUQL7R4TtHv+?=
 =?us-ascii?Q?xwfopCjI3jg1z3SvTRS67+TJWxJDKrVzY4zGvLW7rtWbJeVQClfY3NdkMekB?=
 =?us-ascii?Q?5B8u2POZ1nfPjfoTXNPhldRvIROuOVQB1+Lowb3IAMbDBGgX/hrUBRgCpdXa?=
 =?us-ascii?Q?aoCxAJD2RinGKCiqSoIFIFvPourDvaaAec6+sYX1XPsgqYGq4Xd/Lun/O7k8?=
 =?us-ascii?Q?vQPKGOSPx7MQXWb6kb0CU2eFlAHn1ySt4lH9aXmKLDZYuTMj7Xu1lAD9TBXC?=
 =?us-ascii?Q?YZMKwpSGvDRMFSsOlYbKJFFOZBcbbnt+mx2Ux2aaKoNjFaHTVsb3gIYdSI4h?=
 =?us-ascii?Q?a1gFilMjSkJeNJbXULcWJ1TKBPIANhfzHkIRciYPm5jXqp2IgrZ8kbjZwHxs?=
 =?us-ascii?Q?tFKnJ0jEGeUHURGxmcVpvdegcHf8hmbTFj2FSBkdUBoUg9N4T3AQWkIh/mTS?=
 =?us-ascii?Q?yGlxpHwA1BrqM6aFr5/whw7GvBT5cgetGuxaLBlCYWY8zhm/YOhrn3bOvLzV?=
 =?us-ascii?Q?Qgc2GwCSKRHK/H2Op+VlmxMPpSqYUBVe12FDxCBJCzOR8OLWJiLd0/GN+aTp?=
 =?us-ascii?Q?q09WmQThnOyJbYAK8zbBpey2DRIMby2HmAmEpL/rApRo/mt9GKHJcGn0qs+d?=
 =?us-ascii?Q?9dRBVrB5oazfntge97ZS3NVMZO26khBuv/zTuOzE4z8okQkr7clvB/XWrxwc?=
 =?us-ascii?Q?yaJvPlSyr58jH1By0R7/zAnCx5NeZzB6FdYKB16OJcizcxwvfgmtKFEVbqZV?=
 =?us-ascii?Q?Mz15Hl0aetLu6DKC7u2LbYZ4XKEKZkZpvCQokeBcaedvYeapA4gCmCaCexE3?=
 =?us-ascii?Q?OXMZPM7R/DEgd1RXxIkcFrmJtreMHVJhu3jHgHyloFKEaSitUKqy0b/l1GBk?=
 =?us-ascii?Q?ImzcCb/GA2wBnhfjcafRdkY9xuJoxrLKoyKIj9d6BYpRrKYXP8qAoA5zgcT8?=
 =?us-ascii?Q?7wWwtrsmOqe4YXm7oqYr8JJzf20d2lzvv9nL1S+5+rHZWWGSycuqOfa90Koh?=
 =?us-ascii?Q?oMAgWQFRzJSKbXgR3gk8maBChNynx2mQrhcTqKG3eWRSCxN22Qj6s0IwPGn7?=
 =?us-ascii?Q?Czcyi8xpU2+DWOU2fM8+hm1eqEoDeeo3uvd431KbCkBhGw5by2OhQKobc8lj?=
 =?us-ascii?Q?e7iS7i+qA0FLeINZRPWucKk0UiYwo7pBYg7UcaBc/PqrBXkyaBf0ab0sNafj?=
 =?us-ascii?Q?CGJdO++7HBso7bbap0yZ5ieQKgX6SXGgs5wCWOUxBc7mnWwS+q/0OY8e+Rrv?=
 =?us-ascii?Q?VKQ6w1AW34HUnHcYDy7uYizizfCmxu9Vn+JXDek0C45cUoloFubOMcxqNN7+?=
 =?us-ascii?Q?gnCwgFIsKNj7+ToUmdEBuxjZRbW2v6ken38v+xFfeu7mEQOqT+ZAiZQyAk9L?=
 =?us-ascii?Q?nPRlVPZ6nCtrl3jz6YY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad72617-5317-4ae5-dad2-08db532c17e2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 21:01:44.9054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IycKh5u8SHlRARKLgnxxOomW8TlBiz0pHtHqh2V0pyZLqGArrWR2E1F1jFdGv8Ya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5857
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 02:59:40AM +0000, Tian, Kevin wrote:
> > From: Baolu Lu <baolu.lu@linux.intel.com>
> > Sent: Thursday, May 11, 2023 7:34 PM
> > 
> > On 5/11/23 3:27 PM, Tian, Kevin wrote:
> > >> From: Alex Williamson<alex.williamson@redhat.com>
> > >> Sent: Thursday, May 11, 2023 1:25 AM
> > >>
> > >> On Tue, 9 May 2023 08:34:53 +0000
> > >> "Tian, Kevin"<kevin.tian@intel.com>  wrote:
> > >>
> > >>> According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> > >>>
> > >>>    The PASID configuration of the single non-VF Function representing
> > >>>    the device is also used by all VFs in the device. A PF is permitted
> > >>>    to implement the PASID capability, but VFs must not implement it.
> > >>>
> > >>> To enable PASID on VF then one open is where to locate the PASID
> > >>> capability in VF's vconfig space. vfio-pci doesn't know which offset
> > >>> may contain VF specific config registers. Finding such offset must
> > >>> come from a device specific knowledge.
> > >> Backup for a moment, VFs are governed by the PASID capability on the
> > >> PF.  The PASID capability exposes control registers that imply the
> > >> ability to manage various feature enable bits.  The VF owner does not
> > >> have privileges to manipulate those bits.  For example, the PASID Enable
> > >> bit should restrict the endpoint from sending TLPs with a PASID prefix,
> > >> but this can only be changed at the PF level for all associated VFs.
> > >>
> > >> The protocol specified in 7.8.9.3 defines this enable bit as RW.  How do
> > >> we virtualize that?  Either it's virtualized to be read-only and we
> > >> violate the spec or we allow it to be read-write and it has no effect,
> > >> which violates the spec.
> > >>
> > > Currently the PASID cap is enabled by default when a device is probed
> > > by iommu driver. Leaving it enabled in PF while guest wants it disabled
> > > in VF is harmless. W/o proper setup in iommu side the VF cannot
> > > do real work with PASID.
> > 
> > [sorry for partial reply]
> > 
> > I am attempting to move PASID enabling/disabling out of the iommu
> > driver and give its control to the device driver. One puzzle thing is
> > that PCI spec requires PASID control bits not changed once the ATS is
> > is enabled. So I also need to add iommu interfaces to enable/disable
> > ATS on devices.
> > 
> > By default, the ATS is enabled by the iommu subsystem to utilize the
> > device TLB, the device driver needs to disable it before change the
> > PASID control bits and re-enable it afterwards.
> > 
> 
> ATS is also relied on by PRS. Not sure how that will be affected when
> ATS is dynamically turned on/off. and PRS is not tied to PASID.
> 
> Jason, is it still a strong requirement to have driver-opt model for
> pasid enabling? iirc it's first raised in a discussion for an AMD GPU
> scenario [1]

It is sounding worse and worse as we go along..

AMD and ARM both have the issue that the iommu settings and domain
types depend on if the driver intends to use PASID or not. There is
some small performance win if PASID is not used and the iommu driver
knows it is not used.

We also get into some trouble with groups, I think, where it will be
hard for the iommu driver to know which mode to use when creating a
domain..

But, if the PASID control for a VF is on the PF then I think it is
hopeless. The iommu or PCI layers need to make these decisions and
drivers have to live with it. No PASID support unless the iommu turned
it on.

This still suggests there would be some driver call to the iommu side
to check that PASID is setup.

Jason
