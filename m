Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9423AA783
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhFPXfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:35:32 -0400
Received: from mail-dm3nam07on2088.outbound.protection.outlook.com ([40.107.95.88]:55585
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234530AbhFPXf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:35:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hR2lQzgfQlAh2G0z++YXwKYKNnkYniR/uu4PgDZ5wDRnHYiNF2Isz7Q6gvwoijGf2oOc2iluLz/YH7RujzdmcYr3LuTQiGn/bSaTc/apXEuNJtBwcqA7Ok9eN6IqxQKE4P4cI+Zfw6C/0ljPcyl10NCWp+ReuLWI9UldrLAYS3DMnY5Kyc9L8BplT/5oii2eAcuE8QX2YFAPe8jfCsgfpAaXaT5lq/+tbHBorQ5X7bv1hnfHnxDnHili+xredKqFQn89u70GB03BJGZFz5VFhFcK5DkW5ANJnfT8rdpQtX+p6zGeujvf8Se64fIDgg3OziDddmTOmSixOwOUB8fTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/uyzV9+SzMs6u5H6pgtoUJ3EKwETB6N1rP4r2JLN64=;
 b=CUXPVRwmL8EL4mLqjRy40AxxZhfqmGi/a7H/mRm9CtrX8jYeH3Jbc/RK0T7uRBX6hzNu7VU+hPB225t5q+9cO2X3bBMPjTWJtjazmfVxCeeVcFlngUbuQuiuGgmxs0xXbQBliji/hUvbOvGuDqDyXAl3p8yBjLMFkwpk32QLK/DtrHdY0YmoK5g7abHpiVfXFHtHBOED5FUByJtkVogATmnNC7h2x38YGUn8WKzLuXzvUt/OuZmW/bwJvM6V95p/6wV5STdoz/p692nC2jLgtsoIb/C4efNiN31Gl8XUpw4GhiwEYtgywygiGPnJncq5gAt6FdTRgjAEcJuev/TimA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/uyzV9+SzMs6u5H6pgtoUJ3EKwETB6N1rP4r2JLN64=;
 b=Gr56P0+ID0+oNaa2fOp57KUWWpGPJAAeUMU7/rz9qtxnOsm5vkSoohGDyrbj083evlDltXJgyQIDfsUdBKCevlzAzKI8eyYQZOPSt9x+iRSMXqRGS/7Xszxa9ekKk9KX/bC+kl27S2J3ol2tkMNkgsNkxtOkqWZcwYeIkJPGI7HmFlA+yK3ZWufw5xgO/4LYfmP2YfAQh+C+2CJJ5WJVCE3oJn0xvtFtYXiXF0UNewkUBbPAMz9CMyueKnh6epGT7kCwa1fSqJy/jUmKUUpDDnp7cJmpBGoBp0iWDiw8T2KeT/V6JXBq/yUnzkjuRxe929/BkgPwBQ+lKks6RgnP8g==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 16 Jun
 2021 23:33:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 23:33:19 +0000
Date:   Wed, 16 Jun 2021 20:33:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210616233317.GR1002214@nvidia.com>
References: <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
 <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:160::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Wed, 16 Jun 2021 23:33:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltf25-007wUo-CH; Wed, 16 Jun 2021 20:33:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d87364c0-4d8e-4f9c-966b-08d9311f1f8d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50328FC0F8EE012DC8C6D86BC20F9@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLIsCrIXLxzqZvoA+G4D+FwrVXuzxFREb+yW2ywmtO7XRa4aP6RlPbD7Tls16r/goZ8BS3ssUxaSgLdq47BFdEvB34GKhpEFHoxO2ByRjup5s3PWuxn7sp6tzsQS/Gt3fkAaRfNms5RzjMx9p6whwG3Qcy/p1BRnpEBkXbqtJTesO46xZe3F5BmTUVwcwnzxlHUUGTDvkYY/b/VS5+yS8v+hjcdYd1QlRRSgnn0ieWni7Szt8xV7DDLU83wo4zLPC5zGByHNMxO8j42g8yJxnE/8O6hGxi9zfyLIomEjdm14pO69JA9NTerhROkPtzTEU3+6KZOVuudR1abmjI6gjpaRJQSHVle6AqnWpuNBB8rf7Ub7GSq5ChevYJBhrXuE3YW/Iuu6pWPtXdH2rj7Bq2XKJaZ9282ADIBv4om3kDipeOdyjYg8fRXpwZw/9NgL0v9avAE+sosOiaPp+xYu/wNc1ysPt1ddmp3HKuNdMBp8niD/p9om8N3pgZqwUf7vtF+f2Gal2XRmZnAnbpvs7zaXRjhka0ELJLA7sXw+uhFcreaxqy+tO/DVAZg9mrVkxoWW1IbxOhT1vI/alVbBBM5GWvtAFdly1Id8nSwxDRo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(4326008)(6862004)(33656002)(9746002)(9786002)(8936002)(8676002)(5660300002)(186003)(2906002)(1076003)(26005)(86362001)(37006003)(2616005)(426003)(6636002)(53546011)(66476007)(38100700002)(36756003)(66946007)(66556008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fF3YdPmykKi4i4h0z8UUuRDQjGe7M7aaLdocevOHLK3ks3dWaUkFRM0XwLlH?=
 =?us-ascii?Q?q5byGGk2I7T1Tqym6zduATHQPNT1FI+K7fCIMpEfwhlMIClDdluZRYrHiz4K?=
 =?us-ascii?Q?2uQVo5I6ndriSVVF+o99iRfVqxVIKsBlDKZk/kjgNs4TMsHe/xb3qgwM30Vc?=
 =?us-ascii?Q?7dcgKm/OxYMNBfXTI3E8MVib217LVwTdhESDu5Cir9q/y7BXvyBhJI4Hh3BU?=
 =?us-ascii?Q?OczqCwbzwJqAbwN5ak0u/L1KHiKAvPBEOE9TqnbbtquR3Iz8nJ9T/3x1DaQw?=
 =?us-ascii?Q?/tI3nAHgIRXa1tBez+1G825gCntEmyI8V/dL5Nr3rF4oQqGJQIb2EpbaAUn2?=
 =?us-ascii?Q?Evz+XcSFgC+LmjqoBoJ+KQMmfU5XUDFyyrNKN+BQ+xx1uuXA3moUXDglgNWq?=
 =?us-ascii?Q?i4O2NKOFuvHCco3/QfugDqObVODpV/XlRuc7stbOMPwv0CTrW2PP+Nn0tpE9?=
 =?us-ascii?Q?ggn0FUa+hxcJOOuIBbuiGPdYTyPKI8hvNr4id/DrVmrWk6NySHM4uXpwVHkj?=
 =?us-ascii?Q?Ts9ONF+KeL5mqiq1NXUElJ2DUSvoGGw9h0OrLczXAFgWIVX8m47WM3yt1Pn1?=
 =?us-ascii?Q?JX3jhB8v6NSx9RpS2ptnrYb29S1AoFikhlVZRR/+MoL14xwnNTFsvLLXDg7I?=
 =?us-ascii?Q?rfu3EVztypk2YS1zamzAhgAGkzaX1tABjfyw1n4on3YW0/jeImux8Dy/5tO+?=
 =?us-ascii?Q?qwn/BFrIn/PFjiQRnSToPX1ogf9OcJpSkkDoLMZgeDjvAYSgqIcAfjjCMtvd?=
 =?us-ascii?Q?t1FUa9ydqngkyIirZQUSRzr92Yyi+Vxu8XKmiauOi2xrXIiLqWN1GVMadrSp?=
 =?us-ascii?Q?MrNvJlvStzSl6ASueq1klMmiK1qpAhqAgvOQwV4WQ+qGJ5ilp+NtkdvMQlwO?=
 =?us-ascii?Q?v3FsL61emINwajGpL3nUSpExzbtI8L9mUb4j5MyaGp5/+3lEqK9YSEhsPnqN?=
 =?us-ascii?Q?sXq7HVovIVzJPUUqS6/RSUyZHsLxktgp1SyRXE/7PqFjtoyjiQlBRasx2EXw?=
 =?us-ascii?Q?o1eHkYSsb3+xPF4bBDWt9DH+8xsUB3uz4rawQ5LDGDQ3FQbqTqBJW11FlZ1M?=
 =?us-ascii?Q?yyItMJ5MtUBOjPN9JJymV5cCbqgZbHVD/n+SCWREg/gy18D/0YwazvMxKSNz?=
 =?us-ascii?Q?6peBWUqgZT3Pv5ofM5z/Y8FgGzMfT30vUS3iAlbm8TyMlEg/Sv2XHqL2dCOC?=
 =?us-ascii?Q?U5U/mrS4OJ0YHm0/yJu5DxqEnLCJ1D9DhvBa3EkHDYUH6fRU0P66V9DvuIzx?=
 =?us-ascii?Q?k0HIZ3NxJALHE33jQUBX8nD/mUjOQt1sUXPXIOXHnnlXgxPuadwl2Q96wNY1?=
 =?us-ascii?Q?FDsp+oAFK0nLhnF53X/rVDZG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87364c0-4d8e-4f9c-966b-08d9311f1f8d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:33:19.4836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcefQdjRAFxZTSu2rZhnj/CFPLuKPD4nSdeE/xHOTzb9BKKXhaFp0TNeqLQ7WR8F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 02:28:36AM +0300, Max Gurtovoy wrote:
> 
> On 6/16/2021 3:34 AM, Jason Gunthorpe wrote:
> > On Tue, Jun 15, 2021 at 06:22:45PM -0600, Alex Williamson wrote:
> > > On Tue, 15 Jun 2021 20:32:57 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > 
> > > > On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:
> > > > 
> > > > > > > b) alone is a functional, runtime difference.
> > > > > > I would state b) differently:
> > > > > > 
> > > > > > b) Ignore the driver-override-only match entries in the ID table.
> > > > > No, pci_match_device() returns NULL if a match is found that is marked
> > > > > driver-override-only and a driver_override is not specified.  That's
> > > > > the same as no match at all.  We don't then go on to search past that
> > > > > match in the table, we fail to bind the driver.  That's effectively an
> > > > > anti-match when there's no driver_override on the device.
> > > > anti-match isn't the intention. The deployment will have match tables
> > > > where all entires are either flags=0 or are driver-override-only.
> > > I'd expect pci-pf-stub to have one of each, an any-id with
> > > override-only flag and the one device ID currently in the table with
> > > no flag.
> > Oh Hum. Actually I think this shows the anti-match behavior is
> > actually a bug.. :(
> > 
> > For something like pci_pf_stub_whitelist, if we add a
> > driver_override-only using the PCI any id then it effectively disables
> > new_id completely because the match search will alway find the
> > driver_override match first and stop searching. There is no chance to
> > see things new_id adds.
> 
> Actually the dynamic table is the first table the driver search. So new_id
> works exactly the same AFAIU.

Oh, even better, so it isn't really an issue

> But you're right for static mixed table (I assumed that this will never
> happen I guess).

Me too, we could organize the driver-overrides to be last
 
> -       found_id = pci_match_id(drv->id_table, dev);
> -       if (found_id) {
> +       ids = drv->id_table;
> +       while ((found_id = pci_match_id(ids, dev))) {

Yeah, keep searching makes logical sense to me

> diff --git a/drivers/pci/pci-pf-stub.c b/drivers/pci/pci-pf-stub.c
> index 45855a5e9fca..49544ba9a7af 100644
> +++ b/drivers/pci/pci-pf-stub.c
> @@ -19,6 +19,7 @@
>   */
>  static const struct pci_device_id pci_pf_stub_whitelist[] = {
>         { PCI_VDEVICE(AMAZON, 0x0053) },
> +       { PCI_DEVICE_FLAGS(PCI_ANY_ID, PCI_ANY_ID,
> PCI_ID_F_STUB_DRIVER_OVERRIDE) }, /* match all by default (override) */
>         /* required last entry */
>         { 0 }

And we don't really want this change any more right? No reason to put
pci_stub in the module.alias file?

Thanks,
Jason
