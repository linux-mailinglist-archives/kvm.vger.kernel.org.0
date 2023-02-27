Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ECE6A3A75
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 06:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjB0FeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 00:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0FeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 00:34:02 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836F4E389
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 21:34:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVghBPbBt6APTDwG/IJJAJE3GowsSNh+h3FCJGqTws/V+bFI4xPJWo7D6BE/Bp0wq4AzZWHD1aEIvVXMs+X//bAV2D2uFVLRYS5CrU21CPVKybBGb59hLrdTCoJTpfD5VdvegKbtGKNy59UwOYPFXLvRzcILDgCoXh2z7qkriNJBWINGXYoXiVNR37bX1pc5lyOGBH/Ix+QBcff8MxzE2DMUiUSLXj7IJFcRw6ikhzankSfTekuZC5eoPQCYlBMgV5Taia6qJawcaBckCS1xfblLTvVYs4pxrQ+Y/PI75Tb6+iAnYG6dFNiDjoCjqk3A1IaB4pBKUW+4/YcM+ajZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfqnSOWc+IZmtLW0wotAzFPV8jHMnCqwfd+H4f32RtE=;
 b=Rt1RU8exW4K9mn8Q6cl9SlUgFU3y1RiXL5+ZbPOCNhKiqPAfLVr5FzmYBTteMQrikOET5IkcT0JAfYFLn8OSzDh9aFYjo3FACa/J7A2Ssaqfp6yroYbqTtqeWH0DysyROTc0RnNHqCkG7Rew02sVg7SZDwKfMrUvPeFGONaaXFdpTHbMoQ0u50Sj8ssNvPbODBXA9D0YijwMCnx8Nkq0E7viXxIWxiqa9fATl1jBxR/vlDU8Gf265a34agC6t988sPT8Gzb16G7YFk5wSdI/SvBMnAoeurv0kwyikeYwX4OpA9V1dcPzp/Yx9u09BKajU089zQyUPlXv8S2r02xhTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfqnSOWc+IZmtLW0wotAzFPV8jHMnCqwfd+H4f32RtE=;
 b=Y4vrvsQ1P/GBZko1tjRmC8Pb10hUh/tl7jx5pUbaO+XoIUxDwFFfnxz50qJ0PyD9JzrnTC9QxqkeEUsOhiyIxs1NJiBhMJmRQj+wtIvZGXMoIUHAa/jMIsaSY0hYA7kcX7JEqJ3jKTb5MByryoWu8YzzuQk9nS9nfQ7InFWpFVeKM4Byf7bSd8LeXwU768wCap8LA/vjfk0clm72A3ZQuMR9FRZdLu/ugKHkz9bIKyDl4EJ3lIJeBxf34hOurSX/Nb++VL7wo+7Wz4T6H9frALbNTLvUAWOlYoUrqxRZyGKit8iO89WvOwZe6hhD+ZHH352MjMADMdTF8BA7eSpeXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by CH2PR12MB4215.namprd12.prod.outlook.com (2603:10b6:610:ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28; Mon, 27 Feb
 2023 05:33:58 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f%9]) with mapi id 15.20.6134.028; Mon, 27 Feb 2023
 05:33:57 +0000
Message-ID: <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
Date:   Mon, 27 Feb 2023 11:03:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Bug: Completion-Wait loop timed out with vfio
To:     Tasos Sahanidis <tasos@tasossah.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
Content-Language: en-US
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0019.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::28) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:EE_|CH2PR12MB4215:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ddb9be-51c8-4914-2eb4-08db188438af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtKrE/qQiFrVYx2p7lnCFp+YSWexbSfJpvMt2oNQUUkPM0ak9pSTmTEwjCca62sE6Ofok6mhY/sA3mqN/EXVMeINR1/seJu3w6nzCM/LV6YUQ01A+GVcPGcbifwy+Bglrb80pgcL9shJdgYKZpEcnhb/4w154C2J8znuL0ieKMhKrK4M6pKPyk91NUDey+fg7xKOZvLawmMbbTw4Ar/RTyGH9t7zoqIIxAjyRGAVn5bM3trTA3PVmfZpauKygN2MfYwim2+RW05ZzNVr802+Z7VeIE2OiIC1EtxzQB9HOz9ECBEpCChHs6/lTotkcRO6oM/JiXxrfpZMVJ3/iAOFAofBFIinnB5pVcVMZAlPOhYogeT+HuAEHOGFLEJ18d45wWSKWVXEAqFYprI0aZVUS8OKq2DgGDP+FXElc9zS+8zyTCmUOZ05o+VgeFlutaR+Db8cf8Cu9XaGABXCy9RAgO+coFQdXWMB2L7DymzITie8J/v36KiQkiSdopKfaeUtV5Rs8K7rSCuxTIb342iBjV9QLvlbbAmq6WIrWQFYXo3nEU7NTNrCUo8H41THtrlorAdXMF2GW3rgjetUwtj+14vkRRjZh2dexwPwjMHlRxNzmpdasjKd+qgcNvg+AMz2UNVkBqdTFjlMJaLNjbEDIf01b+xijGmfCocUfsie6DZljYKRgebKGqmsoGYaPqPaXP5e4mfPZKhChuQUjUZnMRI33u1SOcUwx7LuKaUBCGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199018)(41300700001)(83380400001)(66476007)(66946007)(66556008)(4326008)(8676002)(38100700002)(36756003)(2906002)(31696002)(86362001)(5660300002)(8936002)(2616005)(6486002)(478600001)(6506007)(31686004)(6512007)(316002)(6666004)(186003)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZYbFJ4NGdOaEVidjZzSHNGZHBFcHVjM2NlaGFRQjY3THdVMU10aVd3QkVS?=
 =?utf-8?B?bVdUck9HdzYyanZXcWZlTFROOGVHbUFmUGxJZGFCSUtXMjRtNUFsV2JUdTdy?=
 =?utf-8?B?ZWE5WGhTWi9acXM1WE1KclAvM084MVhvWE5ucTJPUlROT3pqU2hGWjFHeGlO?=
 =?utf-8?B?SGtLQVY3S2d2M3JTaDg4NXR4SFpRcWs4SmVXVXFhL20xT3hHRmJRK01BNFQ0?=
 =?utf-8?B?TWFtbjRDdXI1RTJGc1NJSUQrbk5Wc2E3SU0zN1BJNStUU0dBSTFoRGVxUk9s?=
 =?utf-8?B?bHI3am5ITGphbTg0RVM4bWtRWGd4cUl1UWZOeStTWWxEaVNWSW1NWmxuaVM1?=
 =?utf-8?B?WTdSb0NuV3Jsck5kdFo3M2FzUDI0UkNFMDVwTHUvUkhRZDhPRldWcEdTRThV?=
 =?utf-8?B?R1o4N091dE0xaldaSVRTUytFT25RRk81ZjF6VGhIU0QrUVFXQWw5QXRoVHVV?=
 =?utf-8?B?bGtpLzNKUEo3S1NOdEVEZjQzblZlNXJGOWFjUDM0U0dySHFBT29oMGI3OTFs?=
 =?utf-8?B?bVQ4ZndJV1REa3hEak5tN0VMOTk4VHFndkVXY2ZVRUkyTWZGVVV5bU1vVUw4?=
 =?utf-8?B?amdTQkY1UjRvSXNmSEpkWm9IczJEanZ6KzBtS0FpdS9yVjlEcnpXWElNM01S?=
 =?utf-8?B?MmdGVFdlek1FU2IzL2hmSjB0ejdXd1lONUNJMTRQN3F6b1BRcmRpUmlkVGht?=
 =?utf-8?B?UFFZb2FlcHB6WXppVjJRSVZKTS9nN0tyemNRWkNxcHR2NjdIWVFVVHVEVGhI?=
 =?utf-8?B?VytURzRsbHplQkxQZi9zVGZ1RXNDakp0M2JqM3UrdWQwY2plVi91cExVaTFD?=
 =?utf-8?B?aWN4cDB4bm54cG9ONEFrUlBYdkZzN0NOMWxRVUpZS2JNV04wYlFRR3Y5dkFZ?=
 =?utf-8?B?aGsrRDgvN2FvWXVLc0xaZXpGRi9PL1M1SFRqK1kzOEc0WTZ0bGtteHZGc2VP?=
 =?utf-8?B?T3FENndDNmQ0ZWtLRE9nSU54WGgycmRKa2ZRdG9jYzFUT293c1hsQlBBUy9Q?=
 =?utf-8?B?ZmdOOXZtL2pjYVBoS1lNSlVPaDh1RE9CMFhvVGN1OWwvTVRWYzBTWHpmb2gx?=
 =?utf-8?B?djlUUGc0TFFiY2hlbjRReU9XUmRZOTNSKy9TUEZhZzJIZzEybXphZVlFYUVu?=
 =?utf-8?B?V2VmakVJMHNuMDFFME9keUpXZFlOL05hWktIcmVsd1g5K1MvNE1VcHRwTjRm?=
 =?utf-8?B?eTZiSlFNTTAxSjM2RmNiM01qRG5renhIVFFJSjJ2WG9mYXRyUXlsMS8xVFo5?=
 =?utf-8?B?OGdpaG94VGkrSHdVRnozQmRiaEQxK3haK1FibmphVDYyeXhMd1l5UGdScnRx?=
 =?utf-8?B?bjVqZUdtNER3bVB3L2s4L1loL25tNTRTZ0NPRjJkdUZPVUhNVThxeDJnWENX?=
 =?utf-8?B?SVE3TmticjllMnVxaW5kMGVEMDRPbkF2ay9BQ293K3FraTBMRk5qQzZnbmx5?=
 =?utf-8?B?Y3E0TnhrQU9KL1diVWJIS1pFVWlLNjBoUUppZFludEJMSUwvS3dGZ1QvVURG?=
 =?utf-8?B?TCtoNWp1TlBYNWd3djdQc05haFhlQkp1WnJxMDc2SEhrVDNTemxDUjVCaDRm?=
 =?utf-8?B?TGEwbUxRcThtL01sLy9NNGx6eU5RUHpoZklaSHJJK1NtTiswalZHZEt6T0I4?=
 =?utf-8?B?TE5yUThWNy9lckZoTUIyQURVOFRvTk5nZEYyRGgvbEdhbVQ3aEVZVXVNdGUr?=
 =?utf-8?B?Tk9GUnpmK0llSVU0Wktob2hZQ3lOVGxWZHJYVDM0ViswZS9yazdyb2FIZ1pU?=
 =?utf-8?B?Y3NkeC9lRTNxaDI4ZU9pU1FBbGZpWE52SGhYamp1aHBlKzhDN2kxY3Jxcnp3?=
 =?utf-8?B?L3JEMDByeGNQTkp1RkJlaW9HbnhicGJBTU1adWF1bzNQaWFxb28xVHc2TVdN?=
 =?utf-8?B?cHNIb0lzM1FvNCs4aEFvbXlBZzJUUURyTGJtTFdOVTRaejkvRGhnYStMdHhs?=
 =?utf-8?B?cTRpbWpYdm42K3dSRTBwVFJkZk5YUldDcEdDS3ZWbUZMTmVhQVRSUWRjc1l0?=
 =?utf-8?B?NGcvSTd2NjI4SVp5VVhoR0VrMXpEbGdwOXNHeklKTnRUek9SN2M0eFdvZFVW?=
 =?utf-8?B?aWZHQVdpUTN5Wi8zTFlYWXR3Sjl5UzBIOGVNNmdyek1xako1Q3l2MDg2ZmFt?=
 =?utf-8?Q?nLgNUxl8rcnB/tXzSGQmnkAKz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ddb9be-51c8-4914-2eb4-08db188438af
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 05:33:57.2560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1APQkscLto0sFKL2CT9Ko2nHeeCpHxBd11MHPLzeDcfjQezf2T2I3UijgPv5PRenh3X6p7f8dh7KgVmcRL76Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2023 11:55 AM, Tasos Sahanidis wrote:
> Hello everyone,
> 
> Attempting to pass through my graphics card to a VM with kernel 
>> = 5.19.results in the following (host):
> 
> [   72.645091] AMD-Vi: Completion-Wait loop timed out
> [   72.791448] AMD-Vi: Completion-Wait loop timed out
> [   72.937768] AMD-Vi: Completion-Wait loop timed out
> [   73.084388] AMD-Vi: Completion-Wait loop timed out
> [   73.231661] AMD-Vi: Completion-Wait loop timed out
> [   73.231711] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f000 flags=0x0050]
> [   73.231724] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f040 flags=0x0050]
> [   73.231734] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f080 flags=0x0050]
> [   73.231743] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f0c0 flags=0x0050]
> [   73.231752] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f100 flags=0x0050]
> [   73.231761] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f140 flags=0x0050]
> [   73.231770] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f180 flags=0x0050]
> [   73.231779] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f1c0 flags=0x0050]
> [   73.231788] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f200 flags=0x0050]
> [   73.231797] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f240 flags=0x0050]
> [   73.377900] AMD-Vi: Completion-Wait loop timed out
> [   73.500538] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4600]
> [   73.546431] AMD-Vi: Completion-Wait loop timed out
> [   73.693772] AMD-Vi: Completion-Wait loop timed out
> [   73.847385] AMD-Vi: Completion-Wait loop timed out
> [   74.001796] AMD-Vi: Completion-Wait loop timed out
> [   74.148077] AMD-Vi: Completion-Wait loop timed out
> [   74.168380] virbr0: port 2(vnet0) entered learning state
> [   74.294937] AMD-Vi: Completion-Wait loop timed out
> [   74.296484] ata2.00: exception Emask 0x20 SAct 0x7e703fff SErr 0x0 action 0x6 frozen
> [   74.296492] ata2.00: irq_stat 0x20000000, host bus error
> [   74.296496] ata2.00: failed command: WRITE FPDMA QUEUED
> [   74.296498] ata2.00: cmd 61/08:00:c0:ec:91/00:00:01:00:00/40 tag 0 ncq dma 4096 out
>                         res 40/00:34:20:eb:91/00:00:01:00:00/40 Emask 0x20 (host bus error)
> [   74.296507] ata2.00: status: { DRDY }
> [more ATA errors]
> [   74.296724] ata2: hard resetting link
> [   74.430739] AMD-Vi: Completion-Wait loop timed out
> [   74.502557] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4660]
> [   74.502563] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4680]
> [   74.680713] vfio-pci 0000:06:00.0: enabling device (0000 -> 0003)
> [   74.681219] vfio-pci 0000:06:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
> [   74.681235] vfio-pci 0000:06:00.0: vfio_ecap_init: hiding ecap 0x1b@0x2d0
> [   74.700687] vfio-pci 0000:06:00.1: enabling device (0000 -> 0002)
> [   74.772816] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   74.775906] ata2.00: configured for UDMA/133
> [   74.775957] ata2: EH complete
> [   74.935315] AMD-Vi: Completion-Wait loop timed out
> [   75.073590] AMD-Vi: Completion-Wait loop timed out
> [   75.212946] AMD-Vi: Completion-Wait loop timed out
> [   75.379316] AMD-Vi: Completion-Wait loop timed out
> [   75.504512] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e46f0]
> 
> Stopping the VM results in similar messages.
> 
> The card is an AMD Radeon HD 7790 (1002:665c) and shows up at 06:00.0 on
> the host. This is a Ryzen system with an ASUS "TUF GAMING X570-PLUS".
> Userspace virt-related packages are all stock from Ubuntu 20.04.
> 
> While these messages are printed, sometimes the cursor and audio
> stutter. These temporary freezes have also caused file system
> corruption. The graphics card is non functional in this state.
> 
> Bisecting this shows that the issue was introduced by:
> 7ab5e10eda02d ("vfio/pci: Move the unused device into low power state with runtime PM").
> 
> Reverting that commit in 5.19 results in GPU passthrough working as
> expected. The patch doesn't cleanly revert on kernels newer than 5.19.
> 
> --
> Tasos

 Thanks Tasos.

 The patch enables the runtime power management. Previously, when the device is unused
 state, then it will be put in D3hot state. Now, it will be put into D3cold.
 In D3cold, the device power will be removed completely.

 If the issue is happening after this patch that means somehow the runtime power
 management is not working as expected with this device or platform.

 Is it possible to try following things at your end to get more information,

 1. Set disable_idle_d3 module parameter set and check if this issue happens.
    It can be done by adding following entry in command line

               vfio_pci.disable_idle_d3=1

 2. Without starting the VM, check the status of following sysfs entries.

    # cat /sys/bus/pci/devices/<B:D:F>/power/runtime_status
    # cat /sys/bus/pci/devices/<B:D:F>/power/power_state

 3. After issue happens, run the above command again.
 4. Do lspci -s <B:D:F> -vvv without starting the VM and see if it is printing the correct
    results and there is no new prints in the dmesg.
 5. Enable the ftrace events related with runtime power management before starting the VM

    # echo 1 > /sys/kernel/debug/tracing/events/rpm/enable
               
    and collect the trace logs after this issue happens

    # cat /sys/kernel/debug/tracing/trace
           
 6. Do you have any NVIDIA graphics card with you. If you have, then
    could you please check if issue happens with that.

  Thanks,
  Abhishek
