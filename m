Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5042E53A13C
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351453AbiFAJt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiFAJt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:49:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2A221819;
        Wed,  1 Jun 2022 02:49:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S28hEqQCYlIFz2N0MA69WYeUs4nuV5IMMNLv+ijUqLCu1+siR7q9kPpZ/wzHM2Ji3DtXnQFmkMW7uaLiO4PyMOhBf7F8/gLDM3NOFMTOOa6fm1f0voWDPfiJgdThxIdsBXazn+YC5HmvVR7F25VRzqp5Fe3Oq0J2Cw6kDBHkWkyaHZ1810aHpT8VNZaDw3b+VhUxW/uRONtogYBurkTUUp8mwM7uhhygsniUvTk8t8oYsGo/e3m3OIUX+s8qjSxiuC8k+CRxLaJiCQnBqx5VrBe9CqwMNqJ/0LJ2ghckD95zz9pcR2MmgVeG/rpLcBEFNm2nTp3ouGDWyk1wJ5X11g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl5+0lazUBTg0sakyJbNPsF9l3GwSXCMctuIX/EqIbU=;
 b=gw3Rc+KIkoQAYTagJHN2ySnylNbEKCwpygi7SZinq0doq+o8yt9+YxodH+4pZeADqNViBDRr8dA44ktgxYQvfq6c//cpykGZGXovYY3bUbAbz7QuEylJGsAqdnq34x4E82Ol/qTMgRHmmZqpUfl9N2h+hLjI6x+sWTy1lxbwIwdXnoVBEUr2vvr7Ktf0kvuSAWpWT+3kd8BDUz0JGZn2h9GfpkLkMT0dvgNoder3CA00BPzEDjj+kumA8Gp7VX/qpYF7P5qEqoCuH6eTI0NyHsszdeycMME0VQHBPoKvveSOSzcFg4dVhKko97v8bE9qAQ5DVfenJL3NdZQS6FecdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl5+0lazUBTg0sakyJbNPsF9l3GwSXCMctuIX/EqIbU=;
 b=px5zxRbP+ZkFPjYsdRmreosP0uw+wWLXiqS6sqwJVeEC5R8r7CfoG97joAQ8FUkWOACLRU7ns/gMu4XmFBnQYiUZ2RFalw3pbAryjkDvxtxel33CPVcU0B4c+DIaZHI/9v3yH2NpBfEowyzJN1a8ScSydRj5bV6cJjD0ottL1D/9mkdRhcduHvkcV48QQUpUvOYtBWxFQ0qhUwiFb7VqC44YDHrarCIG4H0e1q8YzcABr8QP6TgDAYgHSHx8THDgame73KnX6mz/4kbvmFWnA5eRbfPVW3jTe5HO9x2IxT5Fqy9uRpiYJrh/tu2kOdDZJlZw66HFTQaxwPSNPd150g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN2PR12MB4783.namprd12.prod.outlook.com (2603:10b6:208:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 09:49:21 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%4]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 09:49:20 +0000
Message-ID: <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
Date:   Wed, 1 Jun 2022 15:19:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
 <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
 <20220531194304.GN1343366@nvidia.com>
 <20220531165209.1c18854f.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220531165209.1c18854f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::15) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9167450c-8bd9-475a-57cc-08da43b40031
X-MS-TrafficTypeDiagnostic: MN2PR12MB4783:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB478310328CB20BC43016958FCCDF9@MN2PR12MB4783.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pz4AWlIdRkz1oi9VkD+FHt2hF3nfPsDw+abM4f8DUAKUYoeZ7y0zUdVROvFPQoPmk9rxwhfaPKrCRNvtzwFnVXhLMn55kWR46Lm1hjTOA0RFi2LtGFsslOzrcZXqtzZtKmNLELzyI1i1wvqJ9yuGnw6ChrZ/1Cb0HW64flm8pLcBoZtksJQNZYXKvqTCbpUnxGzPQeANCyqscBQwwqkSEQ0fbfLJHJzmuaUGYfl9/JSysktAAC8fNEQQkqGqEfejmFnxBgRzvuK89fk5hO8f870ZrcDpin5wPVB1ljCb7JKt12muyKjSAwTAbPBQGFtTz1AlUUGhmXPnTVnRzQLV2/DtIAzot5ZbVNB2reXzU/G48QQ3brTei+7ItTRD+l6wuW7jvzaf1/RKNtDIOxleKjrwlC/LmWurAnSdAtMtfRshGlWbk0aR6A+3wKrrYF+c9Eqii+UhZcKh+ACNmFYkwaHlH7z2ZTm4ZWblJETjpqoQSdBXNYR1LaBeByj0dj8rXkPoKwE3wsHPl3vaGPRCemkVJQzlJIO2AW/XSbxGlc5iMaGQeir5Ue9Gi8DjJVQZE0sDjGR6mEnhkp5Kx8r6KA/BYoIUi+tR3YLDO32JbBH6f4S6JKVmOiCrt/L3MFE1LMNdjuz36T1BaXOoZfcyarjQ2Xcu+cRZnwiH3TwIXORHww8hMGyFkAbiT426q8QVVNv7sRufM3RFTOfeHE4FCH7eMyvb+PWvZHoMAA1o+4yK3UygacmbIow1PzXRSfIH+fdfO6Oy5TX8JOxPw0XeTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(31696002)(66556008)(66476007)(66946007)(4326008)(8676002)(316002)(38100700002)(6636002)(110136005)(508600001)(54906003)(186003)(2616005)(55236004)(53546011)(6666004)(6506007)(6512007)(2906002)(26005)(36756003)(8936002)(31686004)(83380400001)(7416002)(5660300002)(6486002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlhyNVdNeXhEZmx3OTVTdzhIMTgzT3JXOVR0VjNIRlE1Q1AwVU0rdVNZWkIr?=
 =?utf-8?B?S2Y1d3o2eGg4T3FpMGtvcm9sY1hsN1ZNbm45ZFdkaEs4bUwreWtiaXBPUTBM?=
 =?utf-8?B?bS9USitkSDNhczRpN3ZKL210MEdHS2kvV09hTFlLS2thR1J5c2VDM0l1amRL?=
 =?utf-8?B?bnhYcDlXemZqTkxjejN0VGF3TEpkL0NpcUNpZWhYWDl3bkJTM0JPZnozTVBC?=
 =?utf-8?B?WnJmM2UyVTlWWmxKeTFMOTRYUjJUVmhsbXlJSTB5N2dXdXhML0hDT09Cd0VP?=
 =?utf-8?B?T25GUlR6bXNpY3lvNFkxRitESXlBaVhWQXE0L2hmaHViQWFSSkx6cERzV3g5?=
 =?utf-8?B?QXQxQUt5czNrT3NaUlFGbkVMS1d0M3ZRcnExdmZmU1BpQjRhUmpYUXJoNmU0?=
 =?utf-8?B?VHQ4YjF1WkF0VU1NRExHV3V2cjlEcnVHZ0doSUt4SndqbzFrYzViYmxRU2Uy?=
 =?utf-8?B?bEgxa0JzeXk3SmVINngrT1h6T2ptL1J2Snk4czhTaFd5UnN4UzR4Z0hZSTVi?=
 =?utf-8?B?ZEZoSXFyVjcyT05qdjQ2ZXZhVGJFek1QWm1iQzVScVl2SEMrejRycTltNCt3?=
 =?utf-8?B?TU55RXd2c1VxYzBsZEU1Y3h2T1RJTUJ1L001d1NaNXp4aGFEL29zVno2RlBW?=
 =?utf-8?B?WXRDQ1BUOTIvTSswKzM5VGlHOVEyRldyODRjdWFjZllhRHJVK0N5T1VvS2VW?=
 =?utf-8?B?RjVUS05zdnE3dlc5cHVOcHB6Z2s4d2VGdWN1c25Td1lweE1QTFU2ZkJlY3hz?=
 =?utf-8?B?RER0MUR3MHlsUmRzUEdXWWJQU0lMSlBwNFhRejJyMlV0TFowMFJNbmNKZlFo?=
 =?utf-8?B?TWw1WUc0NzdwZjlDVFhReWdGK1kwWU1qcVgrUHVVN213ZjdhVkVKUkU1V1Zp?=
 =?utf-8?B?SGN1em8vSHYxNTQvaEt6SG12aVFPWTNMblBaRmdja1FaS3BtNENxRklVTTRi?=
 =?utf-8?B?UXFVM1crY25hdkwwNUUyTnU1U2EwNHlsaC9CZklPYno4c0wxa0dUVG9BaUdH?=
 =?utf-8?B?WGRrZncrREk2Y3dmNUR0ampFQTlUUjYxcWttUzFPMWtmZWZpM1dkTzE3dG42?=
 =?utf-8?B?MGIvbUxxU1lmVUNoVjFQKzNvQlF2MXRCS0xBcTUxVytTV2R0YzRnUFpDL3do?=
 =?utf-8?B?aWxNajdIaXQxRDdLYU0zSDNja2Y5cDJCYXhiM0U3S05kMXZvL0FEYXg0NGtB?=
 =?utf-8?B?VTI0WUpXT2FOckx0YUZGQ2lZOElJV2RiRGs4TkN4Vi80aXh4cXYvU0N0RmE2?=
 =?utf-8?B?S05GS2JmL1BvOEF4Vk9KQlVlMEtzS21RcUxhOVVNeDc3eDRhRmxzSXVoMk1B?=
 =?utf-8?B?aFArMW9TWGxrbGhNbitvdDF6YzQ0LzREdW9nRGJmWEJuTUNJQkI3cnpGRjAx?=
 =?utf-8?B?ZGN5NnVoQVNkMnpRWlB3M1lXanZqNUpWdGRpcmZZcDZab0RVekJzcG55ZVc2?=
 =?utf-8?B?TWkycjFRYTh1RG16WHZVSEpFeUpVeFQwS1EzUlpZSXdWVFBjbU8rM3ZWNU1K?=
 =?utf-8?B?cFJKZzc4ZFRKSnFiZjYxSWVxMXlHcHVBVVdKdWE3ZXJuTnR4aDVqRlp3V3Nj?=
 =?utf-8?B?QWJRVXVCUUIrZnNSNFlQY0JYcGZTRGhiaDdobmdqTnhob0dYMmFIYzFOT2hy?=
 =?utf-8?B?MTJ2MWI0MDNGTExXcGRTNkhtWU9teEdHWEU2elBHS2ZtVVhGYXoyRXZaK2F3?=
 =?utf-8?B?enNaMGg2YkxVZzJEWStuQ0RxQXBBdWVXS2tLcWVyczlQUUpnSXIrYU5qanll?=
 =?utf-8?B?V1hyUHVnd2hWQkgzOHdrSWZXU2RnT2ZueUZ4MFQwNkg0R2NLVU1PNm5zQWlN?=
 =?utf-8?B?elMzTk1vR0pmcHRiZWZhWE83VHpzQjBWa0ZVWEl1dDVEMVBrYTJTWHNsZjBo?=
 =?utf-8?B?MDhQMTBpS0s4QTIrWGlvaVJTeENpQnlkODdTZUxUQ3dQN21vbStpZmJYaXJN?=
 =?utf-8?B?M1JiSG11cWNHTzI5TTBQUXlXaitTeDhqVUtYemxJUFFpZk5aQjBzUGwwalZ3?=
 =?utf-8?B?NUpVTDA0T2VxS0N3VW1mYmQ1eHI3aXBvSjN1SGhVaFYveW1LeFUyU2tsUkNk?=
 =?utf-8?B?WVZSQWxNZ0xxaTdNMHEwVXN6cTVRZDJMOXNncmxvbzFqT2VIQ1duYUFRUXE0?=
 =?utf-8?B?RG9iZDhIK1lsVTN6WkhFS1ZVZGRxQXk4S1ZBa01NemtabUNoMUJNUitvQzFJ?=
 =?utf-8?B?WlFueDU5Q2FUWHpNNjlVSWVDNUU2YnFBbVBFOE1lNy9KU3MwUXJBOU42d3I2?=
 =?utf-8?B?OW1VTEYvTU1tczlZMXVrT2RnZ0tLYWxVb0Y4dkVqZDFqMldkMUhiUnhVU3Zy?=
 =?utf-8?B?UDJyaFZZdnJKQW9sQklsNXZZN00yYXMwUTY1Y252cS9oNEJzVVpRUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9167450c-8bd9-475a-57cc-08da43b40031
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 09:49:20.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXDM4FXI9faf1O/6nCQgW27vplk27kBexy/Fvct5OvghjjOf4KR3RVj4VG84KkPGvlsOLeLS9MgoC/MY+vmYVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4783
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/2022 4:22 AM, Alex Williamson wrote:
> On Tue, 31 May 2022 16:43:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:
>>> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:  
>>>> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
>>>>   
>>>>>  1. In real use case, config or any other ioctl should not come along
>>>>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>>>>>  
>>>>>  2. Maintain some 'access_count' which will be incremented when we
>>>>>     do any config space access or ioctl.  
>>>>
>>>> Please don't open code locks - if you need a lock then write a proper
>>>> lock. You can use the 'try' variants to bail out in cases where that
>>>> is appropriate.
>>>>
>>>> Jason  
>>>
>>>  Thanks Jason for providing your inputs.
>>>
>>>  In that case, should I introduce new rw_semaphore (For example
>>>  power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?  
>>
>> Possibly, this is better than an atomic at least
>>
>>>  1. At the beginning of config space access or ioctl, we can take the
>>>     lock
>>>  
>>>      down_read(&vdev->power_lock);  
>>
>> You can also do down_read_trylock() here and bail out as you were
>> suggesting with the atomic.
>>
>> trylock doesn't have lock odering rules because it can't sleep so it
>> gives a bit more flexability when designing the lock ordering.
>>
>> Though userspace has to be able to tolerate the failure, or never make
>> the request.
>>

 Thanks Alex and Jason for providing your inputs.

 Using down_read_trylock() along with Alex suggestion seems fine.
 In real use case, config space access should not happen when the
 device is in low power state so returning error should not
 cause any issue in this case.

>>>          down_write(&vdev->power_lock);
>>>          ...
>>>          switch (vfio_pm.low_power_state) {
>>>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>>>                  ...
>>>                          vfio_pci_zap_and_down_write_memory_lock(vdev);
>>>                          vdev->power_state_d3 = true;
>>>                          up_write(&vdev->memory_lock);
>>>
>>>          ...
>>>          up_write(&vdev->power_lock);  
>>
>> And something checks the power lock before allowing the memor to be
>> re-enabled?
>>
>>>  4.  For ioctl access, as mentioned previously I need to add two
>>>      callbacks functions (one for start and one for end) in the struct
>>>      vfio_device_ops and call the same at start and end of ioctl from
>>>      vfio_device_fops_unl_ioctl().  
>>
>> Not sure I followed this..
> 
> I'm kinda lost here too.


 I have summarized the things below

 1. In the current patch (v3 8/8), if config space access or ioctl was
    being made by the user when the device is already in low power state,
    then it was waking the device. This wake up was happening with
    pm_runtime_resume_and_get() API in vfio_pci_config_rw() and
    vfio_device_fops_unl_ioctl() (with patch v3 7/8 in this patch series).

 2. Now, it has been decided to return error instead of waking the
    device if the device is already in low power state.

 3. Initially I thought to add following code in config space path
    (and similar in ioctl)

        vfio_pci_config_rw() {
            ...
            down_read(&vdev->memory_lock);
            if (vdev->platform_pm_engaged)
            {
                up_read(&vdev->memory_lock);
                return -EIO;
            }
            ...
        }

     And then there was a possibility that the physical config happens
     when the device in D3cold in case of race condition.

 4.  So, I wanted to add some mechanism so that the low power entry
     ioctl will be serialized with other ioctl or config space. With this
     if low power entry gets scheduled first then config/other ioctls will
     get failure, otherwise low power entry will wait.

 5.  For serializing this access, I need to ensure that lock is held
     throughout the operation. For config space I can add the code in
     vfio_pci_config_rw(). But for ioctls, I was not sure what is the best
     way since few ioctls (VFIO_DEVICE_FEATURE_MIGRATION,
     VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE etc.) are being handled in the
     vfio core layer itself.

 The memory_lock and the variables to track low power in specific to
 vfio-pci so I need some mechanism by which I add low power check for
 each ioctl. For serialization, I need to call function implemented in
 vfio-pci before vfio core layer makes the actual ioctl to grab the
 locks. Similarly, I need to release the lock once vfio core layer
 finished the actual ioctl. I have mentioned about this problem in the
 above point (point 4 in my earlier mail).

> A couple replies back there was some concern
> about race scenarios with multiple user threads accessing the device.
> The ones concerning non-deterministic behavior if a user is
> concurrently changing power state and performing other accesses are a
> non-issue, imo.  

 What does non-deterministic behavior here mean.
 Is it for user side that user will see different result
 (failure or success) during race condition or in the kernel side
 (as explained in point 3 above where physical config access
 happens when the device in D3cold) ? My concern here is for later
 part where this config space access in D3cold can cause fatal error
 on the system side as we have seen for memory disablement.

> I think our goal is only to expand the current
> memory_lock to block accesses, including config space, while the device
> is in low power, or some approximation bounded by the entry/exit ioctl.
> 
> I think the remaining issues is how to do that relative to the fact
> that config space access can change the memory enable state and would
> therefore need to upgrade the memory_lock read-lock to a write-lock.
> For that I think we can simply drop the read-lock, acquire the
> write-lock, and re-test the low power state.  If it has changed, that
> suggests the user has again raced changing power state with another
> access and we can simply drop the lock and return -EIO.
> 

 Yes. This looks better option. So, just to confirm, I can take the
 memory_lock read-lock at the starting of vfio_pci_config_rw() and
 release it just before returning from vfio_pci_config_rw() and
 for memory related config access, we will release this lock and
 re-aquiring again write version of this. Once memory write happens,
 then we can downgrade this write lock to read lock ?

 Also, what about IOCTLs. How can I take and release memory_lock for
 ioctl. is it okay to go with Patch 7 where we call
 pm_runtime_resume_and_get() before each ioctl or we need to do the
 same low power check for ioctl also ?
 In Later case, I am not sure how should I do the implementation so
 that all other ioctl are covered from vfio core layer itself.

 Thanks,
 Abhishek

> If I'm still misunderstanding, please let me know.  Thanks,
> 
> Alex
> 

