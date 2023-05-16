Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72A704C78
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjEPLhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 07:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjEPLhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 07:37:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B6D30FD;
        Tue, 16 May 2023 04:37:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzzyAIzj5Cff7p6cgPmxQC29O/wVW/gN2DoUn9yX3zVGUFUwrHMBj3ME7ipMu6nuuRQ3Slb8JYD3cGs3kLCiXUIFKjOySYJyccTzVfh/pCjoqtx/vWIeIGmu25IzCIgIC9srUzOhws+A6ks8jIWrYpiAiFGOSQATAnZhGLOxf7rdN0jei3Uq/0pHP2q9lHHRmht6OHjj+G1Alf2RGnKOsM8xIl5dFn6hnq00P3M2g1lXeeGP2PiXoXEMG+DVY4pEbECrICUcHkFa8gxdlB10oAh0+yzpBXwbTcoBIAdwljES3wTEx6eKdgZfPsLlr/CBO6ucFvi2JvmTh4g2qDCjTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoGu9xbSGgMS3I0bpiltpz5+4RYFFFNWlUTN8UIJp4A=;
 b=FGzd7IhvISi/5JiK2x84pAygyJ1AH+EwZHk/8LPewe0TBYjO4H5r/gCHw39k0t4YGb7dOwInmf+JcEVC3Vk5cp3N2Y6GKbFD6tg6k4Waxwk6mnjDOtD00KdJLDExR9WP8aKKbqUdSBmsB//yjg8wZHTsQi6nYTM5prXBtj0p2J9WO7BMIvQ/I4H7NVIB1Ut28Gzq+Lpnx6VSzdmsP3Dsel5yts4VOk3Vqy/PA7LiMCVOVCmfo6OQlO48NuU6ThaK5PtSp/VGfnrIGTDNKtE2H1ubpO3Vbz9gRTlmiPRgmTGkL0Yyga3/OtHDfIz2ATPuTgDiaJ5I/V7KKXTyolRiNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoGu9xbSGgMS3I0bpiltpz5+4RYFFFNWlUTN8UIJp4A=;
 b=dzsd25xK82kC7hB7OfejbnJO+PsAS92e6NacmZBeg3twkKXEj9g6s7FQQmDzbx6iB5XgnIUnIse4EOcXSNnxSnxgKeMp/ElWBewzyI+wjyPF+E6oYFZanF5UK9gX88cLyLO4gwdl8wTs//kFsxCLOtyJCJd9VassVzyh7Mbsuy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8)
 by IA0PR12MB7751.namprd12.prod.outlook.com (2603:10b6:208:430::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 11:37:29 +0000
Received: from CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c]) by CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 11:37:29 +0000
Message-ID: <cdad45b9-fc1e-7202-446b-3995b6d87b35@amd.com>
Date:   Tue, 16 May 2023 17:07:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] vfio/cdx: add support for CDX bus
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     jgg@ziepe.ca, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        nicolas@fjasle.eu, git@amd.com, harpreet.anand@amd.com,
        pieter.jansen-van-vuuren@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com
References: <20230419151730.15176-1-nipun.gupta@amd.com>
 <20230515153942.74da60d1.alex.williamson@redhat.com>
From:   Nipun Gupta <nipun.gupta@amd.com>
In-Reply-To: <20230515153942.74da60d1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0209.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::20) To CH3PR12MB8308.namprd12.prod.outlook.com
 (2603:10b6:610:131::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8308:EE_|IA0PR12MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c96412f-8509-4c9e-4bb0-08db5601ed9d
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tn+/cp///PVe7brv6Zh2JVw9HbwlFnzibvlovpKnoV6oVOJ4rSK5nmKbz9eHWzHLvXsfTvFnmkEHhsN/62EXONe4+rCqyD4eOv0w7EClsPq1pb09casRngAuieaU6JxjUKSLUsWdV9VqndPvAdmKHKMTEpcmACKyYF1HONPFxzfRKPRK3POpl1puM51qiCG39LeMWZVzA3UDtYspuXzbdIzWVsUuUAjDC2956Hd+rIbmUeEDWwA2JpGUm6/LiwUlOL3O/VObB09KCOvjVCS3Emuf/j/UI41e1JjhAUxlsSxVptZsYE4jm3uxvBHP/HKgLdPGW+W//iOpYxR3abxtcpPjHuwPKXQe4sBkS0dp1COjBurYVH/3F4gct7ev4hOPP//dS20tX/LWeeANe3L73bmBIoO31s16WUJzRudFwXQkasgHDoB4Tu2BQdp6+XqXQ7OSStdmoZmK5WDQLcveZsTbmChekmuzFd11xd/RqaSuhhIieKpTlUJUZ/Clg6GItMC4V237Ih9+wKJ4/fPpJzCcQSkcosjTLiZN03EIi3NTS4l03ZrtWFY9Trcql/QfEB1gMOXHM1m8aW6v95z77Jy4sYNfYEJ2j7ToYlj6Ly/MnSwryNlbTbtbIlvC3MVRrYERkXdhgvtp4jTfK8EWDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8308.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(86362001)(186003)(31686004)(6512007)(26005)(53546011)(31696002)(6506007)(966005)(6666004)(2616005)(83380400001)(6486002)(8936002)(8676002)(478600001)(36756003)(2906002)(30864003)(5660300002)(44832011)(66946007)(4326008)(41300700001)(66476007)(6916009)(66556008)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enc2N2o4L3RPdFV0RFEzR1BNWFpmTStQdCtCalg1eWx1NmdTMHFoaWUzNTNw?=
 =?utf-8?B?cFViNGlCTGVmeGpLais3TDV5Z29xcnpsY3phZEplQmhiRU1WalkyMHU1TkVj?=
 =?utf-8?B?UUR5N0pKaDgzNFFVcXl4ZVMxV3h1L3JuTzhUK1E1Mk5sd3VIeWRrUk9Jc05T?=
 =?utf-8?B?WjdXQmhTOUxYR29VSEhRSEpoYk51Qktub2IyZzFka0toN0crOW1tbWxQRisv?=
 =?utf-8?B?OGM4NjZoSVI0TWYxeU5lQTMzRnFpaStYQjFpcVFNOWlnbHZSMEE4b2J6STZ4?=
 =?utf-8?B?Si9qWFZNak5VeXlXeWZOQWJXRTNGTTJwRHRwWnpPQ3RCdy9HNEJXWHV2QlJ3?=
 =?utf-8?B?dkpVY29VRHBhRmM1bk1Bck9oTkhnZi9ldlJVaFJaZTV4YU0xeVZrSDZkMDJR?=
 =?utf-8?B?bGFlZStZcGRrclNXUlV4V1pPejA2akczZzBBSGpuTU1tZm03SklqWVV5OUpS?=
 =?utf-8?B?bDlxbzdUUUF3anJ2V0VObVpCZmUrNndzTWdRVmFzMGVoOTRmaW1ZdlQ0K2I0?=
 =?utf-8?B?U3VUSVBaalR2ZTEyeDR5ZnFnVG13ZHd5UDBsOXFPZkJoYkppVFVFT0R5eUdW?=
 =?utf-8?B?b211ZzdUbzExUjZKTk9EaUQyMWtPSisxS2FmUlJiRWsyMEg3djMzaDU2alIz?=
 =?utf-8?B?L1pRTEk5VFozK0RYb2NXMFp2RFo0Uy9QQTNJdjhEaWljQzJLcllreE9SZ1Z4?=
 =?utf-8?B?ak02TGVSL0Y4MkxSRVZDT3VubTgyQWM3OEc4QzJMdStxSWxXV1ZJYlZIQlFn?=
 =?utf-8?B?anlzUHdVOXFiekFMclFmZVJLNlljWm82cTM1Z0pKT2FmbDJxcG8rMUNhVmJs?=
 =?utf-8?B?S21PRXg2QTU5MUs0dGdVZEtSQ2o1TmlBbFUrU3FaWXVZaDZFa1BROWVHRS9M?=
 =?utf-8?B?MXk2SDVqY3RhZGJsanZ6TGxXMkVleHRHVFJYZFNmMndUZEZhTzhxMnFoK25p?=
 =?utf-8?B?YllJLzlRdE1Hd0R5SlpsVGs5eE9BMjQwYk00dXAvT3VxeldxcWQ4ZzZsamtV?=
 =?utf-8?B?WHUvNjhiTksrTDd3MHN0aXBKNENPb29URmN5RmttekJKN0dBMHpOcnlubWY2?=
 =?utf-8?B?SlJlVmVibEovOEtmUHZCZzgyODdsS0d5ZHE4LzIrd3lvcC9NNnlPRU1WZHN5?=
 =?utf-8?B?YVNaMmxCQWdBdVhuTmE1azdvaUxmcEczZjVML1hOcUZGaTZCVHZEU01aQnpn?=
 =?utf-8?B?Y2pRUG9qZnNTOXdMNmJEa2JaLzNHQTAwcy96VVpORDduUUZ1SCs1QjliZmlt?=
 =?utf-8?B?QjBISmJMU1kvckZpYXU1Q3kyckkrYzdCYno4YmRTdWtlQ1l0VXNHUTV6MEFu?=
 =?utf-8?B?VUhtYzlNUkJHNWtNTkhCMlN4T3Y2SGFPMGs2V0dqbUp1b1podHNsYzg4dHlJ?=
 =?utf-8?B?Y1p2SEg1QVN2VFRzN00zNkk1QnlxWG4rQjRHd25NZkxvR2FyK29ETlF0UnVF?=
 =?utf-8?B?bEtqTTF0REphWktxb2diQnFsTVp6Ym1YK0JQYXFOWUlZa0oyZm16WEwxblln?=
 =?utf-8?B?ekd6Z1BpZHdUWGI4L3lNRkdjTFcwUGlPbXdxaC9GMWQwb0lGa2F2VjBncm43?=
 =?utf-8?B?V2UxRjZ3Ny9BZXlvTTBxQTVPS3MzTXorbXdJRUgzRjlkU1pkUGM4VHk5N1BK?=
 =?utf-8?B?dXdOaEFvdEVpZ1ZhR0FQZUZIdTZ3Vmk4bmNkTGRTcnFlcUxXMkZ1TFdZZXpm?=
 =?utf-8?B?aFkyOTYyZXdUZHo1YWxDOVB4MGM1ZlhoaEZxdlYrVGhrR1JCUnMxWjlTRzdF?=
 =?utf-8?B?NTgxOTVCNzNHMEg3WWNRMDMwd0xrWDk2VHMvdzdWTG1nWWN2T3ArcE5JTnNl?=
 =?utf-8?B?ak84bjJDdmlvNHpzcE04UnY0eG9lbkF6S01aU0ZpU3VrTHJhN254dkJ6ZXNw?=
 =?utf-8?B?NTZzYklsWkV3Q01Rb0NNdys0THU4ZDZJSlE4bUpQL0lmUmRVMElnbG10M1dF?=
 =?utf-8?B?Y3NyRzZGYWhYQ0p2QjdFcmZKM09hdUZoaks1N1hyaURVMkx0TEZ5OU45M29y?=
 =?utf-8?B?Q3FZNHZtejhjRjgzdnlSRkRpVXVSYVNLSm1WTmhTSU1mM0p1U0NWdWhpR0F4?=
 =?utf-8?B?YlpnWGJoc0FrOVNUM0ZBL2JueUdZTE93aDh6U1ZRQkVjckQ1bzMyZ0luUVJY?=
 =?utf-8?Q?btrLTm4XWrm6rwwaaJAZG6U40?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c96412f-8509-4c9e-4bb0-08db5601ed9d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8308.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 11:37:28.8559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HknsAbEso8OHiYdJpzHxm02V3Z3OIwSt6OAeBk2sFsDidFEhxnkDxbBSshpK/HyK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7751
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/16/2023 3:09 AM, Alex Williamson wrote:
> On Wed, 19 Apr 2023 20:47:30 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
> 
>> vfio-cdx driver enables IOCTLs for user space to query
>> MMIO regions for CDX devices and mmap them. This change
>> also adds support for reset of CDX devices.
>>
>> This change adds the VFIO CDX driver and enables the following
>> ioctls for CDX devices:
>>   - VFIO_DEVICE_GET_INFO:
>>   - VFIO_DEVICE_GET_REGION_INFO
>>   - VFIO_DEVICE_RESET
> 
> Since there's no public specification for these devices and I'm not at
> all familiar with them, what's the primary motivation for exposing
> these devices for userspace drivers?
> 
> If it were only to query MMIO regions and mmap them as described above,
> wouldn't something equivalent to pci-sysfs be sufficient, ie. mmap
> access via sysfs?
> 
> To require a vfio driver suggest that we want to give exclusive
> userspace ownership to a device capable of DMA.  Are we doing that to
> support a specific use cases that require a userspace driver or are we
> doing that to build driver support for devices on this bus out-of-tree
> from the kernel?  I don't see anything else on lkml proposing a
> cdx_driver.

Devices on CDX bus are capable of doing DMA. The motivation is to secure 
the access from the CDX devices (DMA) w.r.t. user-space applications 
and enable these applications to exercise MMIO, DMA and MSI on these 
devices. CDX bus is being upstreamed in DPDK as well using this VFIO 
interface.

Brief Arch overview is at top of file cdx.c:
https://github.com/torvalds/linux/blob/master/drivers/cdx/cdx.c

> 
> Further comments/questions below...
> 
>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
>> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
>> Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
>> ---
>>
>> Changes v4->v5:
>> - renamed vfio_cdx.c to main.c and vfio_cdx_private.h
>>    to private.h
>> - have separate functions for get_info and get_region_info
>>
>> Changes v3->v4:
>> - fix vfio info flags
>>
>> Changes v2->v3:
>> - removed redundant init and release functions
>> - removed redundant dev and cdx_dev from vfio_cdx_device
>> - added support for iommufd
>> - added VFIO_DEVICE_FLAGS_CDX
>> - removed unrequried WARN_ON
>> - removed unused ioaddr
>>
>> Changes v1->v2:
>> - Updated file2alias to support vfio_cdx
>> - removed some un-necessary checks in mmap
>> - removed vfio reset wrapper API
>> - converted complex macros to static APIs
>> - used pgprot_device and io_remap_pfn_range
>>
>>   MAINTAINERS                       |   7 +
>>   drivers/vfio/Kconfig              |   1 +
>>   drivers/vfio/Makefile             |   1 +
>>   drivers/vfio/cdx/Kconfig          |  17 ++
>>   drivers/vfio/cdx/Makefile         |   8 +
>>   drivers/vfio/cdx/main.c           | 275 ++++++++++++++++++++++++++++++
>>   drivers/vfio/cdx/private.h        |  28 +++
>>   include/linux/cdx/cdx_bus.h       |   1 -
>>   include/linux/mod_devicetable.h   |   6 +
>>   include/uapi/linux/vfio.h         |   1 +
>>   scripts/mod/devicetable-offsets.c |   1 +
>>   scripts/mod/file2alias.c          |  17 +-
>>   12 files changed, 361 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/vfio/cdx/Kconfig
>>   create mode 100644 drivers/vfio/cdx/Makefile
>>   create mode 100644 drivers/vfio/cdx/main.c
>>   create mode 100644 drivers/vfio/cdx/private.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7f74d8571ac9..c4fd42ba8f46 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22064,6 +22064,13 @@ F:   Documentation/filesystems/vfat.rst
>>   F:   fs/fat/
>>   F:   tools/testing/selftests/filesystems/fat/
>>
>> +VFIO CDX DRIVER
>> +M:   Nipun Gupta <nipun.gupta@amd.com>
>> +M:   Nikhil Agarwal <nikhil.agarwal@amd.com>
>> +L:   kvm@vger.kernel.org
>> +S:   Maintained
>> +F:   drivers/vfio/cdx/*
>> +
>>   VFIO DRIVER
>>   M:   Alex Williamson <alex.williamson@redhat.com>
>>   L:   kvm@vger.kernel.org
>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>> index 89e06c981e43..aba36f5be4ec 100644
>> --- a/drivers/vfio/Kconfig
>> +++ b/drivers/vfio/Kconfig
>> @@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
>>   source "drivers/vfio/platform/Kconfig"
>>   source "drivers/vfio/mdev/Kconfig"
>>   source "drivers/vfio/fsl-mc/Kconfig"
>> +source "drivers/vfio/cdx/Kconfig"
>>   endif
>>
>>   source "virt/lib/Kconfig"
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index 70e7dcb302ef..1a27b2516612 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
>>   obj-$(CONFIG_VFIO_PLATFORM) += platform/
>>   obj-$(CONFIG_VFIO_MDEV) += mdev/
>>   obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
>> +obj-$(CONFIG_VFIO_CDX) += cdx/
>> diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
>> new file mode 100644
>> index 000000000000..e6de0a0caa32
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/Kconfig
>> @@ -0,0 +1,17 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# VFIO CDX configuration
>> +#
>> +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
>> +#
>> +
>> +config VFIO_CDX
>> +     tristate "VFIO support for CDX bus devices"
>> +     depends on CDX_BUS
>> +     select EVENTFD
>> +     help
>> +       Driver to enable VFIO support for the devices on CDX bus.
>> +       This is required to make use of CDX devices present in
>> +       the system using the VFIO framework.
>> +
>> +       If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
>> new file mode 100644
>> index 000000000000..cd4a2e6fe609
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/Makefile
>> @@ -0,0 +1,8 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
>> +#
>> +
>> +obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
>> +
>> +vfio-cdx-objs := main.o
>> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
>> new file mode 100644
>> index 000000000000..d5af6913658d
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/main.c
>> @@ -0,0 +1,275 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
>> + */
>> +
>> +#include <linux/vfio.h>
>> +#include <linux/cdx/cdx_bus.h>
>> +
>> +#include "private.h"
>> +
>> +static struct cdx_driver vfio_cdx_driver;
> 
> I didn't spot a reason for this forward declaration.

Sure.. Will check and remove.

> 
>> +
>> +/**
>> + * CDX_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
>> + *                                   "driver_override" CDX device.
>> + * @vend: the 16 bit CDX Vendor ID
>> + * @dev: the 16 bit CDX Device ID
> 
> Lacking a public spec, is CDX_ANY_ID (0xffff) specifically reserved in
> this address space?  For example this is why PCI uses a u32 for vendor
> and device ID in struct pci_device_id and PCI_ANY_ID is defined as ~0,
> even though the vendor and device IDs on hardware are only 16bits.

CDX_ANY_ID is actually reserved and FW ensures that CDX_ANY_ID is not 
used by any CDX device as vendor or device ID.

> 
>> + *
>> + * This macro is used to create a struct cdx_device_id that matches a
>> + * specific device. driver_override will be set to
>> + * CDX_ID_F_VFIO_DRIVER_OVERRIDE.
>> + */
>> +#define CDX_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
>> +     CDX_DEVICE_DRIVER_OVERRIDE(vend, dev, CDX_ID_F_VFIO_DRIVER_OVERRIDE)
> 
> This macro really makes more sense if it's in a shared bus header,
> otherwise we could open code it in the device table below.  Why isn't
> this in include/linux/cdx/cdx_bus.h?

Agree, we will remove the macro CDX_DRIVER_OVERRIDE_DEVICE_VFIO and use 
CDX_DEVICE_DRIVER_OVERRIDE directly.

> 
>> +
>> +static int vfio_cdx_open_device(struct vfio_device *core_vdev)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
>> +     int count = cdx_dev->res_count;
>> +     int i;
>> +
>> +     vdev->regions = kcalloc(count, sizeof(struct vfio_cdx_region),
>> +                             GFP_KERNEL);
>> +     if (!vdev->regions)
>> +             return -ENOMEM;
>> +
>> +     for (i = 0; i < count; i++) {
>> +             struct resource *res = &cdx_dev->res[i];
>> +
>> +             vdev->regions[i].addr = res->start;
>> +             vdev->regions[i].size = resource_size(res);
>> +             vdev->regions[i].type = res->flags;
>> +             /*
>> +              * Only regions addressed with PAGE granularity may be
>> +              * MMAP'ed securely.
>> +              */
>> +             if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
>> +                 !(vdev->regions[i].size & ~PAGE_MASK))
>> +                     vdev->regions[i].flags |=
>> +                                     VFIO_REGION_INFO_FLAG_MMAP;
>> +             vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
>> +             if (!(cdx_dev->res[i].flags & IORESOURCE_READONLY))
>> +                     vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
>> +{
>> +     kfree(vdev->regions);
>> +}
> 
> There's one caller of this one-line function.  Why do we have it?

Agree, will remove.

> 
>> +
>> +static void vfio_cdx_close_device(struct vfio_device *core_vdev)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     int ret;
>> +
>> +     vfio_cdx_regions_cleanup(vdev);
>> +
>> +     /* reset the device before cleaning up the interrupts */
>> +     ret = cdx_dev_reset(core_vdev->dev);
>> +     if (ret)
>> +             dev_warn(core_vdev->dev,
>> +                      "VFIO_CDX: reset device has failed (%d)\n", ret);
> 
> cdex_dev_reset() will dev_err() on failure, what value is this follow-on
> dev_warn() adding?

Yes, this is not required. Will remove dev_warn from here.

> 
>> +}
>> +
>> +static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
>> +                                struct vfio_device_info __user *arg)
>> +{
>> +     unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
>> +     struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
>> +     struct vfio_device_info info;
>> +
>> +     if (copy_from_user(&info, arg, minsz))
>> +             return -EFAULT;
>> +
>> +     if (info.argsz < minsz)
>> +             return -EINVAL;
>> +
>> +     info.flags = VFIO_DEVICE_FLAGS_CDX;
>> +     info.flags |= VFIO_DEVICE_FLAGS_RESET;
>> +
>> +     info.num_regions = cdx_dev->res_count;
>> +     info.num_irqs = 0;
>> +
>> +     return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>> +}
>> +
>> +static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
>> +                                       struct vfio_region_info __user *arg)
>> +{
>> +     unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>> +     struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
>> +     struct vfio_region_info info;
>> +
>> +     if (copy_from_user(&info, arg, minsz))
>> +             return -EFAULT;
>> +
>> +     if (info.argsz < minsz)
>> +             return -EINVAL;
>> +
>> +     if (info.index >= cdx_dev->res_count)
>> +             return -EINVAL;
>> +
>> +     /* map offset to the physical address  */
> 
> Extra space...................................^

Will update.

> 
>> +     info.offset = vfio_cdx_index_to_offset(info.index);
>> +     info.size = vdev->regions[info.index].size;
>> +     info.flags = vdev->regions[info.index].flags;
>> +
>> +     if (copy_to_user(arg, &info, minsz))
>> +             return -EFAULT;
>> +     return 0;
> 
> Any reason not to be consistent with the ternary return of the previous
> function?

Will use ternary here.

> 
>> +}
>> +
>> +static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
>> +                        unsigned int cmd, unsigned long arg)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     void __user *uarg = (void __user *)arg;
>> +
>> +     switch (cmd) {
>> +     case VFIO_DEVICE_GET_INFO:
>> +             return vfio_cdx_ioctl_get_info(vdev, uarg);
>> +     case VFIO_DEVICE_GET_REGION_INFO:
>> +             return vfio_cdx_ioctl_get_region_info(vdev, uarg);
>> +     case VFIO_DEVICE_RESET:
>> +             return cdx_dev_reset(core_vdev->dev);
>> +     default:
>> +             return -ENOTTY;
>> +     }
>> +}
>> +
>> +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
>> +                           struct vm_area_struct *vma)
>> +{
>> +     u64 size = vma->vm_end - vma->vm_start;
>> +     u64 pgoff, base;
>> +
>> +     pgoff = vma->vm_pgoff &
>> +             ((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +     base = pgoff << PAGE_SHIFT;
>> +
>> +     if (region.size < PAGE_SIZE || base + size > region.size)
>> +             return -EINVAL;
>> +
>> +     vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +     vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
>> +
>> +     return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +                               size, vma->vm_page_prot);
>> +}
>> +
>> +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
>> +                      struct vm_area_struct *vma)
>> +{
>> +     struct vfio_cdx_device *vdev =
>> +             container_of(core_vdev, struct vfio_cdx_device, vdev);
>> +     struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
>> +     unsigned int index;
>> +
>> +     index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
>> +
>> +     if (index >= cdx_dev->res_count)
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
>> +         (vma->vm_flags & VM_READ))
>> +             return -EINVAL;
>> +
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
>> +         (vma->vm_flags & VM_WRITE))
>> +             return -EINVAL;
>> +
>> +     return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
>> +}
>> +
>> +static const struct vfio_device_ops vfio_cdx_ops = {
>> +     .name           = "vfio-cdx",
>> +     .open_device    = vfio_cdx_open_device,
>> +     .close_device   = vfio_cdx_close_device,
>> +     .ioctl          = vfio_cdx_ioctl,
>> +     .mmap           = vfio_cdx_mmap,
>> +     .bind_iommufd   = vfio_iommufd_physical_bind,
>> +     .unbind_iommufd = vfio_iommufd_physical_unbind,
>> +     .attach_ioas    = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +static int vfio_cdx_probe(struct cdx_device *cdx_dev)
>> +{
>> +     struct vfio_cdx_device *vdev = NULL;
>> +     struct device *dev = &cdx_dev->dev;
>> +     int ret;
>> +
>> +     vdev = vfio_alloc_device(vfio_cdx_device, vdev, dev,
>> +                              &vfio_cdx_ops);
>> +     if (IS_ERR(vdev))
>> +             return PTR_ERR(vdev);
>> +
>> +     ret = vfio_register_group_dev(&vdev->vdev);
>> +     if (ret) {
>> +             dev_err(dev, "VFIO_CDX: Failed to add to vfio group\n");
> 
> Looks like this was copied from vfio-fsl-mc where I probably should
> have asked the same, dev_err() seems excessive for a probe failure and
> inconsistent with a failure in the vfio_alloc_device() path above.
> What does dev_err() add here?

Agree, this is not required. Will remove dev_err from here as well.

> 
>> +             goto out_uninit;
>> +     }
>> +
>> +     dev_set_drvdata(dev, vdev);
>> +     return 0;
>> +
>> +out_uninit:
>> +     vfio_put_device(&vdev->vdev);
>> +     return ret;
>> +}
>> +
>> +static int vfio_cdx_remove(struct cdx_device *cdx_dev)
>> +{
>> +     struct device *dev = &cdx_dev->dev;
>> +     struct vfio_cdx_device *vdev;
>> +
>> +     vdev = dev_get_drvdata(dev);
> 
> We don't seem to be approach a line wrap simplifying to:
> 
>          struct vfio_cdx_device *vdev = dev_get_drvdata(&cdx_dev->dev);

Sure, will use this.

> 
>> +     vfio_unregister_group_dev(&vdev->vdev);
>> +     vfio_put_device(&vdev->vdev);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct cdx_device_id vfio_cdx_table[] = {
>> +     { CDX_DRIVER_OVERRIDE_DEVICE_VFIO(CDX_ANY_ID, CDX_ANY_ID) }, /* match all by default */
>> +     {}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
>> +
>> +static struct cdx_driver vfio_cdx_driver = {
>> +     .probe          = vfio_cdx_probe,
>> +     .remove         = vfio_cdx_remove,
>> +     .match_id_table = vfio_cdx_table,
>> +     .driver = {
>> +             .name   = "vfio-cdx",
>> +             .owner  = THIS_MODULE,
>> +     },
>> +     .driver_managed_dma = true,
>> +};
>> +
>> +static int __init vfio_cdx_driver_init(void)
>> +{
>> +     return cdx_driver_register(&vfio_cdx_driver);
>> +}
>> +
>> +static void __exit vfio_cdx_driver_exit(void)
>> +{
>> +     cdx_driver_unregister(&vfio_cdx_driver);
>> +}
>> +
>> +module_init(vfio_cdx_driver_init);
>> +module_exit(vfio_cdx_driver_exit);
> 
> Look at module_driver() rather than declaring init/exit functions and
> registering them separately.  Thanks,

Sure will use module_driver.

Thanks,
Nipun

> 
> Alex
> 
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
>> diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
>> new file mode 100644
>> index 000000000000..8bdc117ea88e
>> --- /dev/null
>> +++ b/drivers/vfio/cdx/private.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
>> + */
>> +
>> +#ifndef VFIO_CDX_PRIVATE_H
>> +#define VFIO_CDX_PRIVATE_H
>> +
>> +#define VFIO_CDX_OFFSET_SHIFT    40
>> +
>> +static inline u64 vfio_cdx_index_to_offset(u32 index)
>> +{
>> +     return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
>> +}
>> +
>> +struct vfio_cdx_region {
>> +     u32                     flags;
>> +     u32                     type;
>> +     u64                     addr;
>> +     resource_size_t         size;
>> +};
>> +
>> +struct vfio_cdx_device {
>> +     struct vfio_device      vdev;
>> +     struct vfio_cdx_region  *regions;
>> +};
>> +
>> +#endif /* VFIO_CDX_PRIVATE_H */
>> diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
>> index 35ef41d8a61a..bead71b7bc73 100644
>> --- a/include/linux/cdx/cdx_bus.h
>> +++ b/include/linux/cdx/cdx_bus.h
>> @@ -14,7 +14,6 @@
>>   #include <linux/mod_devicetable.h>
>>
>>   #define MAX_CDX_DEV_RESOURCES        4
>> -#define CDX_ANY_ID (0xFFFF)
>>   #define CDX_CONTROLLER_ID_SHIFT 4
>>   #define CDX_BUS_NUM_MASK 0xF
>>
>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
>> index ccaaeda792c0..ccf017353bb6 100644
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -912,6 +912,12 @@ struct ishtp_device_id {
>>        kernel_ulong_t driver_data;
>>   };
>>
>> +#define CDX_ANY_ID (0xFFFF)
>> +
>> +enum {
>> +     CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
>> +};
>> +
>>   /**
>>    * struct cdx_device_id - CDX device identifier
>>    * @vendor: Vendor ID
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 0552e8dcf0cb..8e91aaf973e7 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -213,6 +213,7 @@ struct vfio_device_info {
>>   #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
>>   #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device */
>>   #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info supports caps */
>> +#define VFIO_DEVICE_FLAGS_CDX        (1 << 8)        /* vfio-cdx device */
>>        __u32   num_regions;    /* Max region index + 1 */
>>        __u32   num_irqs;       /* Max IRQ index + 1 */
>>        __u32   cap_offset;     /* Offset within info struct of first cap */
>> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
>> index 62dc988df84d..abe65f8968dd 100644
>> --- a/scripts/mod/devicetable-offsets.c
>> +++ b/scripts/mod/devicetable-offsets.c
>> @@ -265,6 +265,7 @@ int main(void)
>>        DEVID(cdx_device_id);
>>        DEVID_FIELD(cdx_device_id, vendor);
>>        DEVID_FIELD(cdx_device_id, device);
>> +     DEVID_FIELD(cdx_device_id, override_only);
>>
>>        return 0;
>>   }
>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>> index 28da34ba4359..38120f932b0d 100644
>> --- a/scripts/mod/file2alias.c
>> +++ b/scripts/mod/file2alias.c
>> @@ -1458,8 +1458,23 @@ static int do_cdx_entry(const char *filename, void *symval,
>>   {
>>        DEF_FIELD(symval, cdx_device_id, vendor);
>>        DEF_FIELD(symval, cdx_device_id, device);
>> +     DEF_FIELD(symval, cdx_device_id, override_only);
>>
>> -     sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
>> +     switch (override_only) {
>> +     case 0:
>> +             strcpy(alias, "cdx:");
>> +             break;
>> +     case CDX_ID_F_VFIO_DRIVER_OVERRIDE:
>> +             strcpy(alias, "vfio_cdx:");
>> +             break;
>> +     default:
>> +             warn("Unknown CDX driver_override alias %08X\n",
>> +                  override_only);
>> +             return 0;
>> +     }
>> +
>> +     ADD(alias, "v", vendor != CDX_ANY_ID, vendor);
>> +     ADD(alias, "d", device != CDX_ANY_ID, device);
>>        return 1;
>>   }
>>
> 
