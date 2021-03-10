Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800A0333D3C
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCJNDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 08:03:04 -0500
Received: from mail-eopbgr750042.outbound.protection.outlook.com ([40.107.75.42]:61826
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231790AbhCJNCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 08:02:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKEUs7n7FTUKniD7T0NLmFs7c55EpmWWRLcM4XBwMIXY3HoqBbQplmJdmaBW0oWVpq1KkkWyZlPRRuf1rK2Gd2YeLcbZ9qnN+agCQzMFXHRxh+tOa/+MM/01METXknjifsH93ykgjSBx1Yhnv6aM7WH6373Gr77D+O8wL5h+oKc6Vk5rKZ+nlShFN3hwJ4WYa1rcHNGEA/mm7asHwQECytPtL36aAyvmqXSmqx3pRF+MdUGH+rzH/T2kq52ts14EXHAcdkjQVVJxYE4HubVzT3UjCfcld9p4ZI8oIvA/dDjsY8xKIsOe+QZzV8LyeJrYlTtislNehuYb65iNnpavPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6pbF/YwamJ7aSx1Z8uPvhGAlDZ9Je69KTLIfzuIUeU=;
 b=njWghj/fy0Xxot6GpYor84EXj9Zb7YMxhjyUsPv5hkYW8U9MaAfA4nUIBndxmc58JYvM+0HiW3cpoE8PlO32txB2a5Ah05xo40XRbG8S5nX8VvGmQPUoAdjjDWXBiFnLLmQC+69XSN9sZAEhRjm9KnOqcArZARhhzs26uFCMbZ/+UA7zH9qUMIRPp6QgkxnUzzJfNzEY3T+bEZvqJZ/jNYzr4gpi8MrxAmIb9DyGu/UsJK43ZsYGJ03VrshB7zf21odSgcBiGgtH/RC0Wn84h1QPlnEOF6LtsQrl+EAczv8UwwR9cytUDVjWWtqHmNU9CXuWLONqozdXc1rkWnFzUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6pbF/YwamJ7aSx1Z8uPvhGAlDZ9Je69KTLIfzuIUeU=;
 b=EjURIgYjB3JiePXmB628hp+Wbbk+Zyr1ij5i5lxJhu6BW/sHHwx8wMnVAvuh6DYX91gT9FA0LhgRusM+3LVg+/2R4tPbj/3O71D2ks/XepOlYt6A1TE1aFc/7T9FhSEM2OIgOE8u7ijYxNtrTv7DS15oo0MCBgcOOeYyh7TCckGYIGDKsRgIco4kIT3yX29N7Nzb4HkZDBUpBiMgyZMl4WVMl0oxQIATzMhboC9kThD56jeTsF+x3S38CpW2d+VpuLpipXzqysyVlAhSJh0Auh6d7kjrgo1iNHP6Mc3WmXqqGC96dLnW5TidK6ZIuB2n8A6ouo27i3Smu8u5JXR9NQ==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Wed, 10 Mar
 2021 13:02:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 13:02:47 +0000
Date:   Wed, 10 Mar 2021 09:02:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210310130246.GW2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:91::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0025.namprd05.prod.outlook.com (2603:10b6:208:91::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.16 via Frontend Transport; Wed, 10 Mar 2021 13:02:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJyUA-00AiLq-5y; Wed, 10 Mar 2021 09:02:46 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0ad4c66-afe4-4f0f-aa02-08d8e3c4cd96
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0201C17A65BBFBAC8FE5D526C2919@DM5PR1201MB0201.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2gOw3mgMI2Cek+tlpeCnvFq9wwrUotJlrCV7nqVtCi377FXIQPA2hzJ3cq0ROxD/zM6GTwTv1K07apkXYPV8toGlUUfwl5Zne/PptqC6MJvDI5Ksda7eeebyxr4zsnJ4lw2Qj1EVNgO/s9t2NGa0oblMIDuQngHhWOFbBLEFqbMuk5JqupqZuEOSWprGRWeSqr3vj4e9DZrBu6NB0Q97BkM/fBR0n0s7L3kJ4zG/T/gdebNPp7KoHHjh4ysOAUi8vWNPu1cI6W43MELwjRvlYwSJUlpaOYqzvWWbdsmuc3+cSwLisOvsBqllg+0OOpA4wBBFcOMClXYBWeJ6jY7mdjSWRyDe9iPTe/6Q82R4Idh0Qw0jqfETsHpMq/4YtTukLe/3yhUklxBI2uHZmrBlPQAqiSFCgfRDE0k1pZwdqBriDDUk3fLEdEeESRuuI+YiNTjIKOKhzKa/S91j2kRmPPKWkl/miNMrl14P2eh969jfUdsRzO90pmt02mhk2sihy9Ngs9+/cNmTzr2PrW3uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(8936002)(4744005)(1076003)(66556008)(478600001)(6636002)(86362001)(5660300002)(6862004)(426003)(36756003)(2616005)(4326008)(8676002)(186003)(9786002)(9746002)(33656002)(2906002)(37006003)(316002)(26005)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVNKU3EycHNxSFNHVkhoTVh2ZVdFU0RIb0NrdHlqKzJ2WmtiMDV5T252d2Ux?=
 =?utf-8?B?aVdVY0t6Mkh2TUd3eUgzOE5Oa2M4eksrSm5CdnpNNjUwNmlrNEJrUU9yV0gz?=
 =?utf-8?B?TzlCV0RhN2pDK012Y3VHQmpHZ0syUWRnZUNqckNubEhuczYwS2o1Q2dzOUJn?=
 =?utf-8?B?ME9GMGdTckd2R21jRzBFQitxMk5melU1cW5iWWwwTmh6SkNidmZ4ek8rd3Rh?=
 =?utf-8?B?WlVxbFNGRWVEcGZoOUUrdDJoOXJDQUhvdkFnYkxud2NGVnBtNWNhTURML1ZE?=
 =?utf-8?B?RjNWUTRsOTBCM3pjTzk1dlg3cmxrSk9QdTd0eFNyRGR1OSs5aDVjTmNITzM2?=
 =?utf-8?B?a0ExcVJiM284QW83S0pRMUQ1ZVEzR1J1UkRmbXgyL2pPU0dudTVFN2krakh1?=
 =?utf-8?B?RHVmaStFT2wxak0vMmgyVk5wTzNTQmpsOWNSOWJnZ1NvMmtBZXN1UEhCdDdw?=
 =?utf-8?B?Y2RIS0tLcWVLVVJIYk0yOHFWQnZFQW9YbGdKamU3OFh5YllMY01wblhURUJT?=
 =?utf-8?B?Uk12K3Fkb2RHalBHYUlZOFUzeWptNmxsQjdxNzNjeHNZSG4xdzVOUVFmTzBv?=
 =?utf-8?B?SUd1Q0RvRStQL3QzY09Salh3cFZSYjNZemFQZU1qUm4ydjdpWXNGaFRvUHpO?=
 =?utf-8?B?ZjZ1eFVmRVQ4bERVdEZmL1E3dFBCMGRGd1YzZlBQVkdIaisyWUNuSTRvU21V?=
 =?utf-8?B?UHN3ejVCQTd3UGxJMDV4NkhyTUtvcllvRkU4dVE3UXpDMlRWSHdIN1pVY2tI?=
 =?utf-8?B?WTV5M3VGcnFjOUhuaUs2c3RIVCt0OXUxaTZEQTR6aVBTUmY5RVNCdnRmeThN?=
 =?utf-8?B?SHNhalFVb05BMy85NkdBUUtXUkhKVkNUdzgrYVp0azUzOG1zTkVncG9tc0JB?=
 =?utf-8?B?bzJDSTdyV3JtWTVZcHE4eHpzNUIyaGpJdmx5YlI4Z3FyNENyS0psbW9JY3Z6?=
 =?utf-8?B?aVNGTmhzbFA2eDZLazFlRkQ3MnVSYjYwOFNjV2JWOGgrL285bnVmNzBHdmd1?=
 =?utf-8?B?ejIrWklpZ1lRdU00TE5wMzN2anpuK0FkenBsbkVEekVLbE9DK0tJaDNGSlR5?=
 =?utf-8?B?TEQyOWhpRG5hRmVqcFIvRkQwTHJlTjdXR1lKTzJuS3Y5WW1CNDAyU09UWXZw?=
 =?utf-8?B?c0ZBTFpWamdzU2QvOUlvdlNoUUtPTDNkRVdhWGtkc3phdWJEb251UU55aW1U?=
 =?utf-8?B?eFBQbk9GVEU1UFpzUnlkL3NuTmdJSUlWdzFBWXlnbUtZWEh0NytUc3NFWDJ4?=
 =?utf-8?B?bkdTQ1RXZURBWkZmM0NISVk3VGRyOHZ0YXkxMmlvNWJndkxkWXVJeUY3eG5u?=
 =?utf-8?B?dXpEMEVQblU5azFpbkZGQTM3d2gxT2tuUmtrZm93dlBGTmlDSGduOXlwWUty?=
 =?utf-8?B?OVdJc0JEZ3ZFZXlsbXNuQ3N2ejRoeUx3akYrbGpRc1Q0MU1wT0orRkRDYThp?=
 =?utf-8?B?aWFZOGZWOEVLYVIvaXp2RmlVeC9OOWo0TW5mSjVXam5MeS9IZGZ2TS9pdUxm?=
 =?utf-8?B?ZlFnaVV2NzlzTkNjV3p6dTRvVk5tL25TUFBzQWJDamI3NmwxVzVOazE5bVQy?=
 =?utf-8?B?Yi9USkxEVHdnQUlsOFE0a1hvYlBYUTZza0daRWY1RmowSHpyY1hXV3JGbFRD?=
 =?utf-8?B?anM5bm95eWsyUldrTkVSYzljTTdvdU1hdllGTGY0Mi8reiswRTh1RTRPMDJW?=
 =?utf-8?B?b3pCZXRDUzZaOGhSVHFmaklRQjdUc283TzFJUmJ3OEhzZG1qMGVyakVuQkNW?=
 =?utf-8?B?OTgzc1BEU0ZtUlhwWElqQU1Db2FCMUh6LzZNQVFSMndHWHBwSlBVWjE5aWdK?=
 =?utf-8?B?NVR5bVdvRWwzaUU2S1AwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ad4c66-afe4-4f0f-aa02-08d8e3c4cd96
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 13:02:47.6992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnG4+2sDU9Ll8whinoO0fr9QBwRJ22hOUI0ncT3Y5bN1immJz5FpgQfFiEE55y+C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0201
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 02:57:57PM +0200, Max Gurtovoy wrote:

> > > +    .err_handler        = &vfio_pci_core_err_handlers,
> > > +};
> > > +
> > > +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
> > > +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
> > > +{
> > > +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
> > > +        return &nvlink2gpu_vfio_pci_driver;
> > 
> > 
> > Why do we need matching PCI ids here instead of looking at the FDT which
> > will work better?
> 
> what is FDT ? any is it better to use it instead of match_id ?

This is emulating the device_driver match for the pci_driver.

I don't think we can combine FDT matching with pci_driver, can we?

Jason
