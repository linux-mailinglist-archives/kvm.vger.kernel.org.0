Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F90776448
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 17:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbjHIPpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 11:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjHIPpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 11:45:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3F7210A;
        Wed,  9 Aug 2023 08:45:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBp9G7uy/7lj4SYVn381TUi34P82m/p5ZsVV1lMcCTGf1MOu7SNsoSvyMXzKh3Vf1wWlLbB2DAUXRmbQDj1zO4di7WjT69i85tr6Br+lP5Tjxvg9qFJgoYLgrauX9KBOCyfDt9Ny4GPkOniQsiqRD0AggIK/3LdUqKMobjU6YNYSG8eapgqcY8jbdKDiHwXtwElaeiSABOMs2esfUISLdIje1iYCFUUutWx6z5/1mBSEOaLgjTc6gZk1xCrxfIhcbIFWWhYySaf60VRqo4rWDoZS24rEFKjZAcruEPhUmVa1fdAXGPM5mgLepS9YHMstlqqZfaMhlIKaIh5q0usPag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVnqH5TIUp9rcL1OreKpi7ssoYT9gJqz6jrmab/ryfc=;
 b=apIsL5+P3yLHplrm49luOXsi8ReYi2abvuf39GKwOeXvvNTUUQJw7QOmElhf8oltqZblhGGWIggIxe6oVxZVkFKZcXi2ppExNFOCn+pPGO4shWgSVQ8gGNf6a4viuExTFeQDPu3WTXeyd3Py9cL68OKZWdWZ999Vhlv+JQUyih99wTtBwYN4p08yUufO6Vd38hjIKr0G2V5rRYyKRGteSpnmn7qOiQ+jHb97mp+PuQ7I5GODcPrlFk2XD5Q0ZDGqAEJ05Q8EEQ/QX+rgtq9wpozwBurLhSyyWaDoltepEw/fgLWzCaKxDARt4VNM7UR9ij8af9ejyvuTxfA24Nbw7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVnqH5TIUp9rcL1OreKpi7ssoYT9gJqz6jrmab/ryfc=;
 b=RZVyGl0+9hAYsqyCJ4geXwBUkP43FgEViiT9FYTV3/VgZiHahZexUjJp+FdBaDbq2EGSarjNIaqG+zQ/q31XtgWwuhrOnnB3nMTApVV5/4pdY9igRdhVSucCj4ToeLtww9bVhJJbyM7pxOcLe07vvhLFhYImSffk8hZPO8U+l2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB6613.namprd12.prod.outlook.com (2603:10b6:8:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 15:44:45 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 15:44:45 +0000
Message-ID: <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
Date:   Wed, 9 Aug 2023 08:44:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, horms@kernel.org, shannon.nelson@amd.com
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230808162718.2151e175.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:510:5::25) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d57a043-aa0c-46c0-5830-08db98ef8e49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gINdm0YwNENZKzVw+jizevdca0Es4tQ8v6uQDQ31Ka5dn7m8tPbRX0/msi29ZhiuzLusDbL0w3Y9MLqlmxuefgRhbz0G8TsVNrIhRBuNv6Pw4KjhNHGOu80+Cd01o5GA44sqx3TAIiql3Txfe7UGCUPBD78N0icVkzybL74IpeBbR81RvAgHmFI2FMUeQSe/Gk4wYrwgIMDMvjv1sHteiowaM9FNf09//O2Bm0si98Vn1+HPciRkUlmrrIvgigCQ1MNSDbeysFNGufUi9FJC0JoMfU41+T5VpUinnPOFbByn2z7c6vkniThZTcTJTPNT4c4d5Wl5zsFhtQZoOVYQKMXnnyZYz59lL7yOO3BajzGDtaFUY866hicexEHLD91t3AXg9jvQADf0V+5XJw/mAJcRUpBJqyu1GLOjq1/8EOmZ01GWT7gC0Z8clViKf7xWoaZl+ckY1XA2WNqrgcr5FZIfiWjKWXJr1BcDALyzAbveJ/2du0qQd9LqY3DRU93qFjY8cdbBlDZMgTFfcvN3dVK6qTuqVHK9gkFXEeJhAWUEEPaekbsL6TZbuc4wnNUkIbEc31Y6Iwv61GX2QkArf6c5HhWCnI4sILCsWYFe60GVt+Vl7tBXWZV+912s8ZIqqrCNJi0mgUT8a0948E57kkddm0Tqqjb9U7NsfoyebZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(186006)(451199021)(1800799006)(31686004)(6512007)(26005)(53546011)(6486002)(6506007)(966005)(478600001)(110136005)(38100700002)(2616005)(83380400001)(4326008)(66946007)(66476007)(66556008)(6636002)(8936002)(8676002)(2906002)(41300700001)(316002)(36756003)(31696002)(5660300002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmZiZzNxNlpqdW03bzNpTjdkRXhqMmFrUFRCR0NlSWJGRnJNazJYczF5cHBt?=
 =?utf-8?B?bzVYcWFOSUpDRnhlMEJEUE9yM2JiSHROT3c0V2NrV1pGb2doNHFpOHBtMUFt?=
 =?utf-8?B?ZUxtUHREbGdFRklXWXV0TDlyL1F5SnFteWlLeW9ObGFzM2hBMDdmU0N1SWJB?=
 =?utf-8?B?SzBNMURzNG91YlZwOE1udHZQd0VmbVcxRDMzeSt1cEpSNGRHaHhpUHNyTUU1?=
 =?utf-8?B?SjBvR2xlZktwQmxvRXRoTnc4TnpvdzlrMnVURmY1dEFRMmlNU0dWSnY3VHE2?=
 =?utf-8?B?YW9MTnFBYXRNS1dJOFkvbHNtK3hXRVhNSE5BTndPVmkxdDVwVW5YV0M1TlBp?=
 =?utf-8?B?TkJ4ei9XamlJZXU0SkR6Z3BGK0VkQUYwVFJtWVJJdnpoQjdRMlBKMFQvUyt2?=
 =?utf-8?B?L0VvMnR5a2Y2ckRZRjFJZnk4emIyUTRQOVdKL1R2UXhyRHhWQVBUSXlaY3ds?=
 =?utf-8?B?RFdTVVFXVUZoSVNjKytkellTLzRsY2VqeEZBM3dEaFg2TjIvYmRseE1sbzRL?=
 =?utf-8?B?NE1VT1czV2l6TFA0cWo5Zm96L1A4eFcyVlBhaUlzaFMrbXRkLy9pV0pCTFE5?=
 =?utf-8?B?blhXU3FlQkNuSEdxdE9aRUZpbDhiaHVVTG11eUg4Uk5lWWZFYzIwN3FGQ0h3?=
 =?utf-8?B?b2lwclUxVlRzanUxc1Z2cWN1MUE3ZHh2OXJBTTZyNXRYSEs0UitZc2M2T2xB?=
 =?utf-8?B?MCtuTVB5NVIzemtYNndkVjFiclhJUXFZblE5RFVKYWw2TEhwbDZxK3pHZGFD?=
 =?utf-8?B?MjV3VFBXQml6S25yaG9WVzhEek5paXMrTGNYaHMvNnVmZXBVRWkyTkFzWGhj?=
 =?utf-8?B?UktJc0Focm5yRWNublg5YVZNdUdjdDg2OGhrYXdMcThDNEg4RE1jc3pDOUV3?=
 =?utf-8?B?clpuK240OGl2dkNReWQ2aGFqMEh3YkxFdXRPWEVYbjdXMFdVRGhUeDZmcE5K?=
 =?utf-8?B?R3J0SEFRTXZUdEFoUVRWNXF5QmFGQ2EzbmQyVnZPRm13S1A4blFuL00weTg4?=
 =?utf-8?B?THN6bm8zSHczcVoxY0ZqL1U1Vk5SUmVSSVV4VkQ0UzM2Z2ZLR2dHZTlJaFpk?=
 =?utf-8?B?aWtTaHZCS0NMdGhKTVRRNmx6VmFmRzZvZSt1Q3hMdjArenJqdmkzOXhvZkM4?=
 =?utf-8?B?ZzBDbXhUcVdjT1ZBTmV3MWRCZkluYW1jaU4yWFdrVCtLZTlZQU9GNmYwSWVU?=
 =?utf-8?B?VjdhbzI1Y3RRRzZINkRVT2k0TkpGMWdrc2dKZ25CQ0dneTNRdTZIT0wxUmtu?=
 =?utf-8?B?eWVGRW9icGpML2dKU0x5WjVXQWVpb3FxNzQzUTl4SlNjSkRRN1hrSjlGK21P?=
 =?utf-8?B?d2JlWnk4dWNzejBqK25tTUVwL1Z2NEdYbGFLdjdtRVlGeWR2VVRaZXVNckky?=
 =?utf-8?B?MHl6NzUzN0I5NTVLc2RDMGpRUUNHNi9wUTRHclNnVElEOHZYNHBnV1hPWll4?=
 =?utf-8?B?d29Vc3BkbzdSSHlsd1dTdXpId1JJbmo1dHpwZTBkZHRaRzRjRktHTDk2TlZI?=
 =?utf-8?B?NDEyRS8rS1hxdFJUWXdVWENnVXNMOEZBbElweW9FK2RuaC9idW1LL29HUWtt?=
 =?utf-8?B?anc0aG9IQldlS0g3bmI4UzdPZlptQlRNbTVHS25YdEthUGFjbWdHZGRnbVdF?=
 =?utf-8?B?YkNKaVpmb0pVZ2NnWWZWSC94VjJ4cTV4L0V4dC9qVXZpOFd6Z0owSW54VnVM?=
 =?utf-8?B?bDZHQzErTkhLcllmbFpJaFhyK29lcHBBK01BSDRIWERsdUkxdmV4ZFMxS0w3?=
 =?utf-8?B?TDVRb3JHZUd1WjdBNm9DSkpVaVFGck1ySWZDcCtOU2hNUFpKMUY5bFpwSXFZ?=
 =?utf-8?B?THhSb2cyaEd1WlFZbEdVT3B4eGlDY3ZRV05EYVo4QXdML3MzUzVRcWtwTXB1?=
 =?utf-8?B?WkV0OU1pYUx6UHdTRlE3SS8vMEpMa0k2LzB1TEt3TTJFbG4rUHNYbTlZaE00?=
 =?utf-8?B?NldBSE04dUVKTGFhdWhwa2lhV1AxR01BRWF2ZFdXQ0kvYjE4M0pOYnNKbzRz?=
 =?utf-8?B?dXFTOTduTjZnSjZxaVNjVncyUk56aVpSZnNJWi9KaVhYVXRlNzkrbHRMWGJo?=
 =?utf-8?B?aXQrbjk3bktaczRpR2hFdWVqVVVQNHdsQUJNWVh1VElMYmFkRjQyVWp2S0ho?=
 =?utf-8?Q?+zddt2WpF99BvKH0bAWU2VXKh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d57a043-aa0c-46c0-5830-08db98ef8e49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 15:44:45.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGm5iTuevMLUN8jdEHIbXLSODvw1WZcCPOXYbkjFU+xXc6fmKWm2cAwx6Vg1nVIXzy68SS3vEC7pn1FzJkJ9pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6613
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/8/2023 3:27 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, 7 Aug 2023 13:57:53 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> ...
>> +static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
>> +                              struct rb_root_cached *ranges, u32 nnodes,
>> +                              u64 *page_size)
>> +{
>> +     struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
>> +     struct device *pdsc_dev = &pci_physfn(pdev)->dev;
>> +     struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
>> +     u64 region_start, region_size, region_page_size;
>> +     struct pds_lm_dirty_region_info *region_info;
>> +     struct interval_tree_node *node = NULL;
>> +     u8 max_regions = 0, num_regions;
>> +     dma_addr_t regions_dma = 0;
>> +     u32 num_ranges = nnodes;
>> +     u32 page_count;
>> +     u16 len;
>> +     int err;
>> +
>> +     dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
>> +             pds_vfio->vf_id);
>> +
>> +     if (pds_vfio_dirty_is_enabled(pds_vfio))
>> +             return -EINVAL;
>> +
>> +     /* find if dirty tracking is disabled, i.e. num_regions == 0 */
>> +     err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions,
>> +                                     &num_regions);
>> +     if (err < 0) {
>> +             dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
>> +                     ERR_PTR(err));
>> +             return err;
>> +     } else if (num_regions) {
>> +             dev_err(&pdev->dev,
>> +                     "Dirty tracking already enabled for %d regions\n",
>> +                     num_regions);
>> +             return -EEXIST;
>> +     } else if (!max_regions) {
>> +             dev_err(&pdev->dev,
>> +                     "Device doesn't support dirty tracking, max_regions %d\n",
>> +                     max_regions);
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     /*
>> +      * Only support 1 region for now. If there are any large gaps in the
>> +      * VM's address regions, then this would be a waste of memory as we are
>> +      * generating 2 bitmaps (ack/seq) from the min address to the max
>> +      * address of the VM's address regions. In the future, if we support
>> +      * more than one region in the device/driver we can split the bitmaps
>> +      * on the largest address region gaps. We can do this split up to the
>> +      * max_regions times returned from the dirty_status command.
>> +      */
> 
> Isn't this a pretty unfortunately limitation given QEMU makes a 1TB
> hole on AMD hosts?  Or maybe I misunderstand.
> 
> https://gitlab.com/qemu-project/qemu/-/commit/8504f129450b909c88e199ca44facd35d38ba4de
> 
> Thanks,
> Alex
> 

Yes, this is currently an unfortunate limitation. However, our device is 
flexible enough to support >1 regions. There has been some work in this 
area, but we aren't quite there yet. The goal was to get this initial 
support accepted and submit follow on work to support >1 regions.

Thanks,

Brett
