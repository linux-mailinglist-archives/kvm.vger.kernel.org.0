Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BE8342197
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhCSQRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:17:31 -0400
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:64992
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229926AbhCSQR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:17:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRI1lCymGRnd83prHk6xjx0mY2LfdvbAns0JmaLcOSjYnVvDWeGIA/xfVZpaR8bz7p8v/deKb/NgTnpr/Y3R9svNLk4HsjijcTEeRGNgQDmLeX452o3Q62iq6X+mmS4ROUUp8okNHudrUZwXLhYDJ4TCT9sVQFoLtK/4BKsC++SOamcGRCOcQrTxD/RM5lA/gLLFEyYpDGFoNGxGvtFXpc+pa5A5Xt+nMHnYK/aW4viyrbzcBF8xmVFz+4wufwmLS8jXw96xF8ufo9MkInj/tPSQvM19iVPPZyqAZ3+yO6fNEc3sNt4UPkUZewtcgtDqH6xWJP2oV68PqLPNwhGBKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roTPGZxTTaPbkmoKKx8YKFS/UM82Opq+Hy/dvt8wAoo=;
 b=YzL4+jjRhcLUoOEHg65sl2rHYK5X0G4AJlhv9EpeH9EW81QYl2uWmG4SC9PtGMXaVWd+H0PyW1G8U4UAsvWwpVfb//nrTxUAqEkcEuGgVhJ60lCGmyKpeMIpxDFlfgg6qmge7MEump7bN5dtmDHWUa7I2prbBqvh88lSftA7ihk/hSZ7oZIH9iT4oe0FwddCqxRGqRi2LxJU6XXQ3B7inttVmA5ymGdOlO/rX43Y9W95ruyf34boQ3yxViXKyrLoMvoQDwWZvYn9AZp/ZnzEUetfq8rjyP8yWVIFrS0JxsOVEYS1+Mn0A1+hbTAkxPzPfTB8xOIMDnBVVM5upSLY1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roTPGZxTTaPbkmoKKx8YKFS/UM82Opq+Hy/dvt8wAoo=;
 b=QAYiPf9g8R/r1T3CnWsVubcn6OLY7nDKt7k5KRzVpht9RsZBW04jK57GsRTXLnOVcN9KGjnn2s2Y7cOcJGIwj9PmAiYNJ5z0o5/NZN/IoZfGqL835zB5QHIGuutNdYJo4QTIFLIVkb4S+XsdKOX901ozy7R5VQzA8kDiUs6AG7i/3lv+xsYoCUM5rY73TKWtdpHgOWO81dVZ7gY53d4QsSNKM5378iGCjL21on8thjXi3ePWcMuoRO8wAcPlJPunIZgnOiLEWA0+RZxOdwVUy43Ngp7Gs5l2AXD202Y7Ta9w4bKZV/2tgpZXIK7vSiaRJePo/E+4Cz+BJVm8DSX/4A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3114.namprd12.prod.outlook.com (2603:10b6:5:11e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 16:17:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 16:17:24 +0000
Date:   Fri, 19 Mar 2021 13:17:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319161722.GY2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210319092341.14bb179a@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210319092341.14bb179a@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0412.namprd13.prod.outlook.com (2603:10b6:208:2c2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.14 via Frontend Transport; Fri, 19 Mar 2021 16:17:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNHoQ-00HM4X-Oy; Fri, 19 Mar 2021 13:17:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b823e249-31ee-4cc8-b4fc-08d8eaf27b41
X-MS-TrafficTypeDiagnostic: DM6PR12MB3114:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3114F451178F1EA4261A8364C2689@DM6PR12MB3114.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqrFLbU4QXSs5X49srqmBDZE+8TUZPZ/3UyHJfyabYfdE76DLu2brHR38WRl14KF/mnYCOoaPiETvXiVu5LCqgJ97fLMAEp05N9D6E0USCZbvjOw02Yc8NFvho7qVNNYByIygP8c6EHnO4jG0ja7z4QFweKknh7cbxMT95II7ptCWnKcO2I5bpcW+LIYGwC4n6pfLF9XTDXMvCRh35GUWC+8m8AInGu2cGkEUHrmgqLHgTvxwUWEMllO9lAYQlua+wLSwwMNv9cTw5jMWoGvQzlz4TTPU1AVP1Q2YeP1ryVaQUqfoPfP/hxSrqkcAsZR4S3crv05A4sa/B3aEdheldKO1LQt6T9iEobcCsrdt7vT7Vsg9NkeghFF3uCq4+HPdgxEjS2eZK4rOB7vviZn9Ugm2E6XvRAZD0N37mox3xKXfGKcrGPd7SMYn7YQlISSfqDJ5Um958TMQPRb+eQSoDBfiSmNAS40SX5WgpJJjzLVrD8u3oIJeRoAfyW7pq6LDqH7N2rzcDPQGOepHjJ2dawT7LmKtZjgE/cjEZ6DOY3s8smUzzl9GX5zSwYyqy6crI8tDDvga+0Mcw6cral4MkYzMjfhNF+y/lGr6BXDgB3dpM4EBSig860Y1nJiZYdfW78dFto/7RMRvdeQM+gObbpRaDdS21HhAvr6KZlvq30=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(66946007)(2906002)(54906003)(26005)(38100700001)(53546011)(66556008)(4326008)(66476007)(86362001)(8936002)(6916009)(33656002)(83380400001)(2616005)(8676002)(186003)(36756003)(9746002)(5660300002)(426003)(1076003)(478600001)(9786002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bFJVZkJVT1czMUZCQXg3Z0haT2l0bjh2cEVQUUN1RDU1VEpKYjVzbldIdlU1?=
 =?utf-8?B?dVRPY3BQQVFsMUVOSzR1WTZ6blNPRW1icnhvcy80WVVnYTNlY09raTFmOVF5?=
 =?utf-8?B?YTh1akNaemkxdTBrM1pTeko5b2dub1FIUTJ5S09HSTU1VjdFQStQeGJxYjRk?=
 =?utf-8?B?ZmZXR29xcDVDaGp3MllWQVMvMGthYzRzOThJMXhERGFJRVYwSjA1ZVhLekFz?=
 =?utf-8?B?ais5amRBNnNWYUs0czN5cWw5Zlk0cVZkRlhkaEpnQkNjMEY0aVBmc3k0MTF5?=
 =?utf-8?B?Y1hGMXBORDlnWThkWG9xTjRwN2ZvVzNSMWpyN0NhTDVzSk0wYXFIaDdZZzgw?=
 =?utf-8?B?Z1pIelR6YjAxRDAyYUxJN3dTVzFqbDBsdXRWWlU1ODVZbFlhYUY1NFBUT1Zm?=
 =?utf-8?B?ekdveEQ0MkwwT05rKzYzY2FVZ1FEVStYRkhXWW55a0hnbTBtRU5EWitRNmlp?=
 =?utf-8?B?SDdDeHhvamFCUWk2cVhWdUhtODlHTkhDMFlJQ29MS2pXelBLMDgrRFU4Tkpn?=
 =?utf-8?B?dFM2eXNIeVJ1UU0xS0ZWbkRHbDdWMk55ZkhaUHh1ZkJTck5naWlhTXJYTk50?=
 =?utf-8?B?SXpaMDZnUk9iUFVMNFBvT1h1ei9SQ2RFc1FKY3BIZHV3dm4xcHJLVWJieVNN?=
 =?utf-8?B?T3AwdFFNeFcyWWtublc1SmhNVGg2K2lIN0Y4VXY0UnhTalVVekhndjVEcUFF?=
 =?utf-8?B?WjQzMmNLZ3JreUYvUjJzNnBveUE5ei9kcVIxSFVEOExxSkFtSXlCUTNGZit4?=
 =?utf-8?B?THhTdVB2eE1JMjhmcjY3NG1jOTFVNmhqNzdBMGo3K3pwbnU0WnNxaGpEQWg1?=
 =?utf-8?B?djhjV1FuL3BieTJMUk1pcmRPVkk2QWk3SlJIMlEydURZcjdQQnVkNU50bko3?=
 =?utf-8?B?RHpRQzNoRk1YYTNuZWRVUXFxYVRFNnJFTFNJemswTGRLbWdSVUZ5QWk2L1ox?=
 =?utf-8?B?MURCQXBZV1ArTVNHZTF0T0pvakI3SkR1clF4YVNseHRic1RjdTNhYVQzZ1dR?=
 =?utf-8?B?bUErRzVjVmZBSjNQWkJWb0RkeitCSHFyWDQxamhmTEdBb1A3ZXdrNlAxMzYv?=
 =?utf-8?B?eEc1YndRYTN4UkxLRVJzOUtWVVdsaGhoaFIrVG5sTWVLbXJ0azlSWVlxVjFG?=
 =?utf-8?B?RWxMNnpUc2pzd29ad3FKL1k5Vlc5WmNYR1RjK0dCUHpWSXA0KzBwM2VrY1Q1?=
 =?utf-8?B?MTdmczF3M21sdk1KM1kxdTAvSjdkTXJFaGIyVSt4Y0c2bVE1bFB2dnNxTjNw?=
 =?utf-8?B?YXVDTWRaNmQxYmdPV0U5QkQ1THBqZDBtMk9oQ01pZnJIZGx0RVdKZXVJOElv?=
 =?utf-8?B?b0NreXJ4d2JaL09NSjVBcXhKa3lQRDR2WVdhWkhEMi9pNzk1VnNjZnQ3TU9J?=
 =?utf-8?B?V25Eb1BGdEZrQ3NGTmorWnNVaG8xelVKenNZNkNoMDFBd2FHNll5SHQzbjdy?=
 =?utf-8?B?QkY2WXZHTWdJcWdjeHFkRDJXY2xPS1FGaktKOFhQbEpxVE5YNkZBM2hiUFFL?=
 =?utf-8?B?bldyeXlwTGJXaTRMME5ETkR6TEkvVW1jTzYxQU9WZy85bkRBZUgrYXRxNnZO?=
 =?utf-8?B?Mlc1cTA0N1drcS9VaFdMb1ZOU0tSaGlEVnh5NFRuZzRDci9HNE9McHJiZTlX?=
 =?utf-8?B?alBjbkFkdDFaQmdqYm1xKzF6MFRUV0FHekpZS2RzRVJXTG1tdnlRWDAyalUx?=
 =?utf-8?B?VWRSckhqMFIxVkhLTkM1KzJqbWVQeld2RXFMN3VKWjJvZFRLTUREN0dkQTll?=
 =?utf-8?B?Y0NNSERwc2hWdFR2VHU1b05zOW1sMURoM2FSbHZwRysyZlJLaU9hTTExcEJT?=
 =?utf-8?B?b2t3Z0pRMXJ0UklNV2cyZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b823e249-31ee-4cc8-b4fc-08d8eaf27b41
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 16:17:24.6032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHkY/PrsmQz651mQIEytU/3rKxhzmMtqrYnxrw3NVqq0gX5PfGhrVX9i4dCzkNlz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 09:23:41AM -0600, Alex Williamson wrote:
> On Wed, 10 Mar 2021 14:57:57 +0200
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > On 3/10/2021 8:39 AM, Alexey Kardashevskiy wrote:
> > > On 09/03/2021 19:33, Max Gurtovoy wrote:  
> > >> +static const struct pci_device_id nvlink2gpu_vfio_pci_table[] = {
> > >> +    { PCI_VDEVICE(NVIDIA, 0x1DB1) }, /* GV100GL-A NVIDIA Tesla 
> > >> V100-SXM2-16GB */
> > >> +    { PCI_VDEVICE(NVIDIA, 0x1DB5) }, /* GV100GL-A NVIDIA Tesla 
> > >> V100-SXM2-32GB */
> > >> +    { PCI_VDEVICE(NVIDIA, 0x1DB8) }, /* GV100GL-A NVIDIA Tesla 
> > >> V100-SXM3-32GB */
> > >> +    { PCI_VDEVICE(NVIDIA, 0x1DF5) }, /* GV100GL-B NVIDIA Tesla 
> > >> V100-SXM2-16GB */  
> > >
> > >
> > > Where is this list from?
> > >
> > > Also, how is this supposed to work at the boot time? Will the kernel 
> > > try binding let's say this one and nouveau? Which one is going to win?  
> > 
> > At boot time nouveau driver will win since the vfio drivers don't 
> > declare MODULE_DEVICE_TABLE
> 
> This still seems troublesome, AIUI the MODULE_DEVICE_TABLE is
> responsible for creating aliases so that kmod can figure out which
> modules to load, but what happens if all these vfio-pci modules are
> built into the kernel or the modules are already loaded?

I think we talked about this.. We still need a better way to control
binding of VFIO modules - now that we have device-specific modules we
must have these match tables to control what devices they connect
to.

Previously things used the binding of vfio_pci as the "switch" and
hardcoded all the matches inside it.

I'm still keen to try the "driver flavour" idea I outlined earlier,
but it is hard to say what will resonate with Greg.

> In the former case, I think it boils down to link order while the
> latter is generally considered even less deterministic since it depends
> on module load order.  So if one of these vfio modules should get
> loaded before the native driver, I think devices could bind here first.

At this point - "don't link these statically", we could have a kconfig
to prevent it.

> Are there tricks/extensions we could use in driver overrides, for
> example maybe a compatibility alias such that one of these vfio-pci
> variants could match "vfio-pci"?

driver override is not really useful as soon as you have a match table
as its operation is to defeat the match table entirely. :(

Again, this is still more of a outline how things will look as we must
get through this before we can attempt to do something in the driver
core with Greg.

We could revise this series to not register drivers at all and keep
the uAPI view exactly as is today. This would allow enough code to
show Greg how some driver flavour thing would work.

If soemthing can't be done in the driver core, I'd propse to keep the
same basic outline Max has here, but make registering the "compat"
dynamic - it is basically a sub-driver design at that point and we
give up achieving module autoloading.

Jason
