Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7A7CDB30
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 14:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjJRMDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 08:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjJRMDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 08:03:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F131120
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 05:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiiVe8kUHVmMKg+Lmj5EJL0UJDM3VaEkKrQsY2smPF2/zCJwOIl85VzP0kebCgdfN53xkx0yuD+L7oNgy3s8mfWHODVixX1BucbTTNzcIFfD1xQm2dAgucxaoo7qlYkDzCEvoNQjYN5kQ+SMz02virnK/NelWS6Cof2IRyeUlyC92r+2muSFyom+Cpz+l4Lc/mz5+Gr04ZxAi7yye5EgYN5bM65vaew2wUCYuuX3GL3R20/UO7h7JNgJmHEFMK1KDkn17D6Xr2WRjjJlX5qLum9o4rkUSarp92veTZFjuZpfLFLiO+TXyqaneaut5VwwwtGOcUFgOkRHnkq2pXbmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQXrUc0cEfftVIoC669HYWHeQm2QpEFkNePcgI+773o=;
 b=lnUbogESXwi3XGMf5fp66zqfVii0sYujZBQjgf/b8eheK4ob6PZg0JF1u4jadzj33vWtxNfiOyGF21nXq4RLr+QvmwpcwjfNWgvQWTavIP1cPaeRLcpOuqrqgX8DTIaCEt0kfgXR2AHMjTD7OD2SeYn9COmZGVfx+Ba13IXMtP+nSZ0z2rX3k/2KCuGDQswTPaMh05tHPrz4WwFCDcGUMN3MmNxwtrjSwmip4iv76u2ucPxzQsuBRGUg/HoL1MMDMZqfyaFVipscg4L76c6dHDXc0WjknmGE8mEoYdUeqnc8YS1dhpulmhZjYsvVFeRlnn3pmQc3HiDrYg2v+iNzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQXrUc0cEfftVIoC669HYWHeQm2QpEFkNePcgI+773o=;
 b=uVVFdxJ30teI4fq83ACga7VgWvkGUdgeRIq291YP4MzzkdMtJnx5O7tRO2MmGlmSuQ5tRiO3NvTh5Iov2FUdsgzDTx/9rarpdlpwqrJWHUzQSxPqxUjsYZSSkkdEtzkAbirt2lp5vQ6D6MRQyZO28Ikxbk0pJV2U0EihOYAQbJkrUFX1vKsvOnge5cXqeK+Hpap4RXmm28MplAdOhiHGj57eQdVc4NU7XV/oDB+GkQQJSa/HrzgbkCrNcFsYzQx0/7iT0ti6jvPxl2zFh8x0Dhs9CC3Rbaw/OXrY1HVcsT/xvcvjKSVf8iuHR9/xIbbB26b7gS2onzuQuPMabPwCJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9437.namprd12.prod.outlook.com (2603:10b6:408:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 12:03:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 12:03:42 +0000
Date:   Wed, 18 Oct 2023 09:03:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231018120339.GR3952@nvidia.com>
References: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
X-ClientProxiedBy: SJ0PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9437:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d3e30df-5d9b-4fc0-f889-08dbcfd245b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PW1lNjqTB4Ach6ywoG3x4/XgnjuJyq/JXSIh0HOE6F7wJx4f9F8wJmskNxiLEWcfK1I7ZZS0AtSr/+Rc1SYKFazJkx5JR2xP5DlW1OA1r9+3RzKG2P4irtSG5nZlr411H7sCnj0Q1O4wVws7XrsuDydvC2UjdHML+j3yQRZ0rr8knhheabKY5noUCtDkBLDS1N2H4GEv8M91CNkoyyaqohzHFVr8zVuv3hhBNrM16Xd8zbPuxSrlXBH4hmU2qjvW7n7I8NUqqCAzQ4OlCIuazrLIyqXEX7iDxyZSV0nhG+T/Pfp5lSSs8Z39+bfcRi8k2hQ+unJFy6LZ8Y9Bo5H4B8QbbnwmD98Ft+NxMHxre91tMEf0Fk34dkB0lVgbVcWV/eTDrUZ31uT030dugP+WgrQvpDNjL3Cy76XEa8uK2NssHWj9a9jT00P8CqBey7/6k8b/cxNsdVkEml6qGlp2UmLjmKayS22FpU74mbwDWDdcPnKh+Ta/MjNCwvER2qZXNE7PY7BUB/l3U3XmL382pk4jFqGz/Y0M4IaKWl74jsNQ+d1cfsR3oGQD+s++8lkC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(366004)(346002)(396003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(38100700002)(2616005)(36756003)(33656002)(26005)(1076003)(478600001)(4326008)(66556008)(8676002)(6486002)(66476007)(5660300002)(66946007)(6916009)(316002)(54906003)(53546011)(6512007)(41300700001)(6666004)(7416002)(86362001)(2906002)(6506007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fSs1vrKpbUA0/w3ezGFzQb86PCe6Ze/CUFxI93+atPp0ImU9V8G4EgYUfJh5?=
 =?us-ascii?Q?Hz8tDvHBkU9pEn8HSu8zzkqIh0lfDwRz+4WPwhGvU5O2EwYKGIFJi6Tkq6cj?=
 =?us-ascii?Q?ZzzXSd94ejD6TO45nTHEXqcq1kfQO43F0o8eKDHEKa4plSTcfdRkHxQRPe/1?=
 =?us-ascii?Q?W6r4KCV3Ps6bHZVJDraJhFJL2Yv0Hd3T3fZOnmnFFWQtFnCvb9Oy3RaUSt9e?=
 =?us-ascii?Q?8tOVwh1pxTLcdMPbln31q2FuUn3O121hxVF+g9S6V7/EQV6jVfucaKi7uKkM?=
 =?us-ascii?Q?+RUPHjNI5fjl+Fc0zVRpaCQTUhCuYDtq7YWBL4Rkb3q8UPo5lHEUzfBwLrcl?=
 =?us-ascii?Q?c5g2usy47LC27F6QAkowe/WweuMDHjb9jEQRKgesbZdA+Utxz97NH3dhO1ZL?=
 =?us-ascii?Q?sMvoz8zGr8oFUTQES+0nBiZoie10Cw5CESgMNmmreRi+Jqad2E09izBhQpEj?=
 =?us-ascii?Q?kdeJ+nCQ14JMcLs/diYOMgBjBLjHfjgcCoS/CFnCxxJ3uLDmW95hQDsD4Vl1?=
 =?us-ascii?Q?j83ueCSiYE2zdeFyD5ELrIJesd6EH2dcBA1eyh3qi/n/59BIGXIUD2xDIGe7?=
 =?us-ascii?Q?CvWeSeT2sgg/uEtxl2RkQwah6cYkfhN7iJbpIVYDjhtViqjsdxFdE26lEkg6?=
 =?us-ascii?Q?+ODUOv38y8JeaIGCrTBhgx1Gia0zj0R5mT9HqvoY+fgGbXwpUi7Kj/uTRP3k?=
 =?us-ascii?Q?QCsvy7qtpUFsd2F3C+mzvHSwhix5Cde3y2YJ73raQXOo3JUYNwAmAikCsekp?=
 =?us-ascii?Q?s7pokDEjN7bI0GB5MRDjQrsiLRFzGvakzdkSCdx41C4HUqbthZn1WKR4adwU?=
 =?us-ascii?Q?CtEJBLS4HUmxDQKOy6wus17OsNT8/tLvt8tu16DhM130Nma8ARz7uFBMz0Xf?=
 =?us-ascii?Q?gIctsK+Y2In0CFEz94XM1EWMDkOF2s0LSmrYktoLsord+9HT6TWNJFidCpz+?=
 =?us-ascii?Q?8cXdMV7s/qSxoZrPLdV1d0BddN1deJwtPBSL6DncnByeCkKma7tk/OqrBjbW?=
 =?us-ascii?Q?JK7HrawUvdpjDntlHwDWYqypmoYB97yVPZ+YCHGL3BYVMQcbs90hXsJk0PNN?=
 =?us-ascii?Q?FWK5xibECOhBtWSDDNdJ8eT63bO5kxl9QTylDXR4u1qjlqPgVlYZ/6ZdE1Mk?=
 =?us-ascii?Q?kER3lsTT2I3yC/fMvdDQpAZF+kch38hsJVsGFnWJdno0dOod/OAywIFHgNXA?=
 =?us-ascii?Q?hf9D6t8AzvaggPN0saen+G91Bw3QeBWjL20fEGptHM0pd6GEn23Zr809bDQw?=
 =?us-ascii?Q?3QxBkOFUKu4h1BG1ocIsM2+ycZclHuTP2Kr1BB+aTOQAe4qxH/FFFZ6YFvWg?=
 =?us-ascii?Q?DpnNLCA0ltHy7JepKksGhbSODqClob2j6pzbt0xLVTPNGDV2/x5WO9xdUB5r?=
 =?us-ascii?Q?LTbN256dJc3VbzAW88DNq92r0DR/nTNIUNDtY9HURHPP9IsKPashWt+SqtNa?=
 =?us-ascii?Q?hcDag8LPqpCxqib98jmarvUKLQGolzezU/Swr3Aj1ZsKERwsy9j84TQ5a6wY?=
 =?us-ascii?Q?nRgmMUoAzvl1+BqfpXE4u8gXpNJcblqKEajyPRFaDSyEIqGf1KsJVwQovtRt?=
 =?us-ascii?Q?VWWNHsQdlVBiVZy9eYKV0ILsj61azR9UgDsVETY3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3e30df-5d9b-4fc0-f889-08dbcfd245b6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 12:03:42.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyjgpvp9I33fI51AzQm0vxcZCI25QyFOzxK0bNQ1CF13ZJwMjOwS2/uXKvWBBWFi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9437
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 11:19:07AM +0100, Joao Martins wrote:
> On 16/10/2023 19:05, Jason Gunthorpe wrote:
> > On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
> >> On 16/10/2023 17:34, Jason Gunthorpe wrote:
> >>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
> >>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> >>>> index 99d4b075df49..96ec013d1192 100644
> >>>> --- a/drivers/iommu/iommufd/Kconfig
> >>>> +++ b/drivers/iommu/iommufd/Kconfig
> >>>> @@ -11,6 +11,13 @@ config IOMMUFD
> >>>>
> >>>>           If you don't know what to do here, say N.
> >>>>
> >>>> +config IOMMUFD_DRIVER
> >>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
> >>>> +       default IOMMU_API
> >>>> +       help
> >>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
> >>>> +         drivers.
> >>>
> >>> It is not a 'user selectable' kconfig, just make it
> >>>
> >>> config IOMMUFD_DRIVER
> >>>        tristate
> >>>        default n
> >>>
> >> tristate? More like a bool as IOMMU drivers aren't modloadable
> > 
> > tristate, who knows what people will select. If the modular drivers
> > use it then it is forced to a Y not a M. It is the right way to use kconfig..
> > 
> Making it tristate will break build bisection in this module with errors like this:
> 
> [I say bisection, because aftewards when we put IOMMU drivers in the mix, these
> are always builtin, so it ends up selecting IOMMU_DRIVER=y.]
> 
> ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/iommufd/iova_bitmap.o
> 
> iova_bitmap is no module, and making it tristate allows to build it as a module
> as long as one of the selectors of is a module. 'bool' is actually more accurate
> to what it is builtin or not.

It is a module if you make it tristate, add the MODULE_LICENSE

Jason
