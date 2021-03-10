Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF3334828
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 20:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhCJTkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 14:40:22 -0500
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:41184
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233802AbhCJTkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 14:40:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/aRW343hPZXGQzdlMsN5n7FhYkcOcyhPEBqk0wrLWIT1v/lEOFnt12ram8ia0Dx9DNPIkWv98lppdUopqHmicIM7NW3CHz9umk5e1t6VOVPZk7Z9hLxsgGX26DZIw1z5uSAAV+4mkufpGHOHJVK/B36yBSCvl6srGcgUse2uzUqrBHMYXbe0H/zKnHW3hmCpRwGD4nMJ6h20e2Wd47JPxqsJleHFRxRee5CzKl6CZwOXgHzI8zN2CDu0Zc1m4fPkfCr+4d8MFO8p28Je+4zR1SpKuiNELta9/C9JHj16BHoKUOA9TH0TJB66FPYAHqDbF8A/u65JHuiPo2phhekQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhC3PthtaFuWF+jWKx38qtLTQF7iOyb3aeR8f3sdbCE=;
 b=ZURZk+2anhV+Beevy/PWoz4s85zQCL12NdNg9o/YRGf8JFf5TykOXnORHz/Cbo1ufXWIts2bygBMi91xzSFwqJVvL+Sl0NaNTBmtWdvXGfajlLD1d0r0RS9tCO/ZudUT+FmjlC16f4bztE4yNyfiZohFvIsCPPcCca9oVYhwtNW7xINem+oHtYpQiNxJ4mviHttjrWH369JMb6APgCbgDNJXAZ8xYqa0MBbtipBNdV5Q2lVA8PREc2QyxQND92Gj7CHC+j50IF4jAFyMhHYIuvU5T8rr3YASfLGVdfcO00D6MC494ltAgHnzTeqZCZpg2bRgjeDjX8i3pSbmLykCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhC3PthtaFuWF+jWKx38qtLTQF7iOyb3aeR8f3sdbCE=;
 b=sFncAjJeHH5iTXqsON068u4BBO4WUdckz/lz4O5JaVUOJvN8YPqylY2gOKfLMY+ct9BlF9UMea2211uDBf3DJzgpY7OoN/yimKKYQb1IZoZ1uMxR47wIqa6MuJqsK4USL1RTb5fWZWRbWMzdB438kxgcuti8jNweQoO4Xlf0lBRSY85W3KlgbfILdDdiMSSLcS09jh5wMUnA5jbPh9GqQOwgwSrbHw0Yl1hoB79vnTjbO9IoPWUHWboBXsrSg4FB9cp0KmwRFnkstMLx8MLpuWdbVvcK/gJtGpCsCPV0k5siGwPqdjOHsIFT1MdcviGFd5+WixcMqb9qz3eVKwqw3A==
Authentication-Results: ozlabs.ru; dkim=none (message not signed)
 header.d=none;ozlabs.ru; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3516.namprd12.prod.outlook.com (2603:10b6:5:18b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Wed, 10 Mar
 2021 19:40:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 19:40:05 +0000
Date:   Wed, 10 Mar 2021 15:40:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210310194002.GD2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0057.prod.exchangelabs.com (2603:10b6:208:23f::26)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0057.prod.exchangelabs.com (2603:10b6:208:23f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:40:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lK4gc-00AurF-Fk; Wed, 10 Mar 2021 15:40:02 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fb6e0c2-e1d8-4dd6-1077-08d8e3fc4d72
X-MS-TrafficTypeDiagnostic: DM6PR12MB3516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB351629E8D0E577E10B9F63C3C2919@DM6PR12MB3516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0ymPoxCMtHrVGA82vGgYaYz0A8aTIf7JKaF7AWnMKjVC4WpnEHuaWNbqp+mkJJmFT6Ntwtz1zCWv/+AlkxAyrVf8xkdlAXkjYhizG6Aln/16SzirphGVyM3i+jxfv4iXwToSeWP9733mC+beXcMr2s0iTVCTOARiOyxp0HrsujrWULWhf8l5u816athQRe/oFHtxqnlVR9SYMej7g4INwMVDltf6EH60IUDH0pAw+FkkD8KmmtHL3o2Z0ZB8JI09NovE3hy5OpQd1Sd3zGc+pRoN/z7YbbQfYQ7eQ4V/MMHfiF0ERZfEf0hiQ1qw2xO4W0YDTaC+XjWEleaAXUv+pJQtm5S82Or7oq6U5kgEQFML0GRwxrGVIVOX0/str3MYx5KL4soO0p0TcZHs+yLjE6LcLWWp2wkxELqY8z0oQ06TgmhTJdfKSR19hAq5wm7+RAM/gO1NKre5RCVOmVHXWvdfsol1ZWiQm0Qs/zJGD5pnKsu6TjrwIbUw2ZodtiMSZTj0zQuyZeMuuhhWkU6eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(4326008)(9746002)(6916009)(2616005)(53546011)(36756003)(8676002)(8936002)(33656002)(426003)(26005)(478600001)(1076003)(186003)(2906002)(86362001)(5660300002)(66946007)(66556008)(66476007)(316002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFdvNHU4T0JDeXhPVW8rK2orMFYzTUlEVjVwNG4xZ05oTG5iak53UlljYUxO?=
 =?utf-8?B?LzJSZ25lVmt5cWpFRVJEdmxUdjJCOTFlV1l6SWtyOGk0T1VwMWlEUXVjUE40?=
 =?utf-8?B?YXhUYk5hNEVDS0VITFdRQXFqSEFJMVdvTWxRWDNDbkt1bDRNMUs0cWdWOXFl?=
 =?utf-8?B?L0Z4Q21tSmJQek9YZW84OVpZajIyelQvRGVwSndTZ2V3a21QVDdmQTVuZWU3?=
 =?utf-8?B?bzBrYWQ3STlaUFlSSWlkVk85aWs5cDMwY1piWE9QUmhVSzFnamw0NlM5UlNw?=
 =?utf-8?B?MkM3Q2hSM1A1bkJqMnJnaE1peDhTek93NERDcW0xbVlrR3E4RVRjUERoWG5X?=
 =?utf-8?B?ZW0vTXRlT0ErT0RjSjV1L3ZLSDBSQ21JdnppblovODdPWW1mbThrUldDenJl?=
 =?utf-8?B?TmZ1Mi82b3p1ajBzZktqMjJFa2NvdjNNSDBIM3pnTWZSRG80U3VFaFVpV1pt?=
 =?utf-8?B?aHMyUGMrNGYyQ09yWE95b1FBTDVRZXdpdjcrRzNUTGZZQTAxZ0dhT3lwUmlj?=
 =?utf-8?B?czNBK1hGbUQxVjFPemVob1pOWUJWY1RNSzZwUVZJWWhFVmdBUjFBVkhCZmZU?=
 =?utf-8?B?b0krMHdOcUYwQzhMbGFvZ1JDbThQZVhVMXZQNjNoMFZWNE81ZTlhelhMTmpQ?=
 =?utf-8?B?SmkzTTZlYWJtbDJ1ZW5HVnMzdzZPeVpkQ0ZqWGFGTkJtVzVKWGpNQlJ0aXlw?=
 =?utf-8?B?bStZN0U3aFlvWmdxb2hhQW9JTm5rOVE5UTE4WGZMVVorZHBXbkhFL1VtWjlS?=
 =?utf-8?B?ZUNOTCtrcU01eWM1dGMxNTVoRGROcE5KN1gyWlJlV0RTOFFqbWlWdVcvOGxm?=
 =?utf-8?B?YVQ5RU5PWU5uUGZmR3UwbUo4SUowZkJub0l0TUVJMnQ5eUgrY2RlTm5JWkRX?=
 =?utf-8?B?SFZIQW5DNDE0UHZkQlRGTVJDM25wYnc5M3hudzBtZkpVOHdncE0vMnVObDZG?=
 =?utf-8?B?Y2tKTUp6YktxU05jRGljSFl4T2tQTmNEbjVnamFHL3IwQ0hNbS9NMnFVeC9B?=
 =?utf-8?B?Z0plVDJ2SW12S1lvQ2d5Z0ZwMzFnQjE3V3lNYUo3QmZObzF3cmkxTW1XUzlS?=
 =?utf-8?B?WkVsK01NVzdjVXFYSVlLVGMydUhKRm0xS3NkS3V5ZHVCai9OYWRVd09SNXpI?=
 =?utf-8?B?d0NlcWVSemo1ZFIwblMwTnpKQmg5MDFSSVVhQXZBTWRtU1V0OVg5aWlKRTJY?=
 =?utf-8?B?Ni9Eb09HU01JcUIyOHRSS2phdFQ2TERyZER1N3J4cENjeSs0MTVoaGNVMXNT?=
 =?utf-8?B?b1BKYm53Rkl3aWp1QWFJS1QxaHA3azlVdTlFRFBFUkwxbGVQK0ZFWnF0WW9q?=
 =?utf-8?B?TTJFak5SUlEvb1hibXFKUlcwTTd4TU94MklTNDdWZ09ydEZoNXYzZm1GT0lK?=
 =?utf-8?B?UVZxZnRFdG40NW1wTXBORkIvSm15aEpIc29QL0ZsQ2p5VkFIaTB6RHl4eHpB?=
 =?utf-8?B?NlhjQlQyS1ZzZDhzcEFveStDbU1wcWpRUHpRRk84MUhuUG9qU0hGVUl6TEYx?=
 =?utf-8?B?enA2TUUxQWF0WGR5V1FTU0J6RHF3REQ1MkNXK2E5UXRnRFFzMHlXaXlySHl5?=
 =?utf-8?B?VUUwcU5NSTJCUytodWpKb1JZUkRHUVJkSm5PR3FNdjl2ZExaVTZISC9xdGdZ?=
 =?utf-8?B?aXhSaGtXRHMvb3lRajUwb0xIcHd0RllkVm82UkFNMzVjTFN4N3Z5OWdyUllo?=
 =?utf-8?B?ZU5ad3RSZjE1K1NiZUVTcmxVand6ZEtWNFUwYjZlTXl4MkZTdDBRNmQyRndw?=
 =?utf-8?B?blJZMTNIaForY2lMV2grRmwzTStjUkFsdDh6cG1aRkNaRmI3WHpLSUc3ZEtF?=
 =?utf-8?B?bjdCZVZxV3VScUw5YnlLdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb6e0c2-e1d8-4dd6-1077-08d8e3fc4d72
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:40:05.5732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4AosZ7+V266bbDuFd5MAJgqkMvo7eaoM189EJAycIPJYJ18LZx90W7VnKdSaQ0P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3516
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 01:24:47AM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 11/03/2021 00:02, Jason Gunthorpe wrote:
> > On Wed, Mar 10, 2021 at 02:57:57PM +0200, Max Gurtovoy wrote:
> > 
> > > > > +    .err_handler        = &vfio_pci_core_err_handlers,
> > > > > +};
> > > > > +
> > > > > +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
> > > > > +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
> > > > > +{
> > > > > +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
> > > > > +        return &nvlink2gpu_vfio_pci_driver;
> > > > 
> > > > 
> > > > Why do we need matching PCI ids here instead of looking at the FDT which
> > > > will work better?
> > > 
> > > what is FDT ? any is it better to use it instead of match_id ?
> > 
> > This is emulating the device_driver match for the pci_driver.
> 
> No it is not, it is a device tree info which lets to skip the linux PCI
> discovery part (the firmware does it anyway) but it tells nothing about
> which drivers to bind.

I mean get_nvlink2gpu_vfio_pci_driver() is emulating the PCI match.

Max added a pci driver for NPU here:

+static struct pci_driver npu2_vfio_pci_driver = {
+	.name			= "npu2-vfio-pci",
+	.id_table		= npu2_vfio_pci_table,
+	.probe			= npu2_vfio_pci_probe,


new userspace should use driver_override with "npu-vfio-pci" as the
string not "vfio-pci"

The point of the get_npu2_vfio_pci_driver() is only optional
compatibility to redirect old userspace using "vfio-pci" in the
driver_override to the now split driver code so userspace doesn't see
any change in behavior.

If we don't do this then the vfio-pci driver override will disable the
npu2 special stuff, since Max took it all out of vfio-pci's
pci_driver.

It is supposed to match exactly the same match table as the pci_driver
above. We *don't* want different behavior from what the standrd PCI
driver matcher will do.

Since we don't have any way to mix in FDT discovery to the standard
PCI driver match it will still attach the npu driver but not enable
any special support. This seems OK.

Jason
