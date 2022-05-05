Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9162D51BF12
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 14:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376403AbiEEMUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiEEMUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 08:20:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8A04579F;
        Thu,  5 May 2022 05:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBC4HJTs9kOMihVucSKZYryblc3YxQutGJqdmdKZDZ+IhSpn8phVxmkdLmML9kSQTl2vTZE0pQeQ65iev0EpEHT8etnofOQ0fIwIDLHfMcBVZ5sHMj29PBAlh8eyb41ERyqpKoyRe9Tajvu9CGe21CQdbfuGHoUVjTheX8SZW458d9tvYewvfIZvxdyfGl5UoaF9sVBgFN4soymSnsLGGDwJp6jl1CvK+kFbaJvLcY78DpuaCxkS1Id8r11M7i4nUe1FyG3Er1ksFyXVNjxlKszML5H6Xhx6Oz1nlVctNbaD88WxftMLQRtixs0m2TJB2zqbzM1Ow8z2Q9UhVHlWiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0vZRbK0EMsuHnHwfULIc11UI7cFJ1hXPbPiX57eCbE=;
 b=cEEtAl4UX1jBOqffsl4hIi3lqi/lz43yI3Dav4/gCZfckIelDdSNm/q03CQNfy+EzEFrdCzB8+1AzymPMsKyHvkpWXup6pSwPki7PKm91So1UpI+g7Whz/ommuA+1FwvN4kDu4GiDXFG14XEwKvvhzdpMEcYvFZkxQx2pCXFAs1rwO3AV12ZTUIoNapNjw7hPdO7ZmCov0ZesPmXZHOUBN1L4ZQRMSg3S6M188JTni+URr6Lzm6zttgciVpjQfrObiY1hhu4qWVZ3E8sM4ILebG/0WK7IUxpy2tVw5A7yv+pN2Gxu6ExdOnKf0qp2VHfkjljGhdSV4ugfhFpI+Bn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0vZRbK0EMsuHnHwfULIc11UI7cFJ1hXPbPiX57eCbE=;
 b=FweaPmc1s9NrfKAAnI8synz6Q7Py0lDKfh2pTamBHqe8NUykOKAcBGgmXs2goL2+ZkyGLf6+jYEaU1mXsLxT8XGRIpOboShct9tQpSIDEtO1eFaZR79gNN0pErYfvzGiYj7ZLX1KWdMvkQ79t7y9DAoCHLcqd2iS4eFhdrPmGjel1hOR4hS126Pw9coXGPETkICIkBz7igLoMfAJ3l5FI9w83JyYZ30dYu/7RifDE6UrcSdowuWVgKG5Ua3ySU0LaE35v2veZgY6XoTJznDhT40KBW1QsverQHwQ0hXU61lZzJVv/onndkxtV0F+d/RMCGZcES9VQr6kkh9PTr4qSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5305.namprd12.prod.outlook.com (2603:10b6:408:102::5)
 by CY4PR12MB1925.namprd12.prod.outlook.com (2603:10b6:903:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 5 May
 2022 12:16:33 +0000
Received: from BN9PR12MB5305.namprd12.prod.outlook.com
 ([fe80::2c65:e1c8:bffc:3bd]) by BN9PR12MB5305.namprd12.prod.outlook.com
 ([fe80::2c65:e1c8:bffc:3bd%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 12:16:33 +0000
Message-ID: <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
Date:   Thu, 5 May 2022 17:46:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220504134551.70d71bf0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR0101CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::28) To BN9PR12MB5305.namprd12.prod.outlook.com
 (2603:10b6:408:102::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68789a9d-f6f8-4a3a-17e9-08da2e91179e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1925:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1925F6DC5AB200D3629C097CCCC29@CY4PR12MB1925.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwyeTGsBzfJS4O2DE0sGLGKAetZJnZOq9f9TRqYyEFBabDRM4lLsQweIYmBVl21tcBpVlXP3O6rq9AUxvx3p/cNnfRAu+g9wAvIgjx7Q7Zf8//dCcPPvJlAPhSkJDqlu/e5cSbPlrT4d0JjuqE53fpDUsjPcrc4IwOwno+hB/VnBlGLbL9wdj0gzItFilWFpUqVS7kNvoKAjwkOy9/JXiO+jUg/3KPNKLSudzCfORnQ69Td5RBAoekLf3o7ZrMZPaWX+AusFRc99Vo2FDmAXduHSVReCc2j7nXyrmlA6A8Vzdt/Nwnc5xVU5NkTR7uFBHAnMH0qyCTeG10UstMQfv9wKpwh5ED1dBM9Jn1JfR4+H/o0PbOoEsejU1SDnWD4A3K0+El2iEJkNXWd8eX9MRwIUt8n6U1bGYmWcnYyA8K4lvcy10J85USXILa/oy93LbpD7FG9OFLuFs8P0PVU2PWSkmsryXx5yNyJSMJSxsyKTotHhcso8seKuQe5OcFH9hScgJ/apVKGe6DKPcpcurBXJJ3r+Ix/O1bJzw9AHbvm0x8G8/Hae67Wu8urT4bJz7mj2mpK9IODOJ9sTZoRs/Mk+bpF/gLrCMh6qr88w2zShB+lEOakkFa5wG2LCPtqCY/QX6HS4GierXBcoX6hROzCkSS6eAyNxLTVHekadcOSCbB3jIiG1YP7+lmhWwc1g1y4QGlDM7tBclH3oa2xEy6LbeyGbaZLAFBP4lVtaKaF5V7LpQH6KAaP+W60qrIzROqn7Scyroc6nKV7/unrFoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(36756003)(6916009)(186003)(54906003)(2616005)(7416002)(38100700002)(30864003)(8936002)(86362001)(31696002)(31686004)(5660300002)(66556008)(66946007)(83380400001)(4326008)(66476007)(8676002)(508600001)(55236004)(6506007)(53546011)(316002)(6512007)(6486002)(26005)(6666004)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3RTT2FhYitVNTVLZWl4cFExeGw0b1h4S3VxNHlZdlRrVi8reWpSdnorUzhp?=
 =?utf-8?B?eEZlQ1NYWmcrajdrRTlvbFd4UnlMTVB4RktuQ0NSTzR5d0tDY3RhZmZhYzRx?=
 =?utf-8?B?cFhITytHaGtZOG12TWNUUTg0RFllcnE3SURNcE16dG5pNDVPMXEzWnkyTFpa?=
 =?utf-8?B?TXUxZVFqVVp1ZmNveEdCbzVyK0I0ZUlsK1JZbzRvQlUvcTloRjd3eUFrUmdJ?=
 =?utf-8?B?TEpjcHc1T2xzSUcwQ2x1d0l5VkN2bWpPSUZQY2RKczNlTzYybUdFc3Z2RFpF?=
 =?utf-8?B?enk4Zk9uTTg1YlZqK2E1ZXlhRVpvUml4SUsvR1NPOGRCT2pjRmpXdVFEN2hk?=
 =?utf-8?B?VjJuSERrcVBtMU1ibXlyRDQxYXE1WmEzTlp0UzVHOEFVeFJUMWlnMll0WUpL?=
 =?utf-8?B?VUJHcmVkcjlkL2V1QmgvYzd3RitNa2NCVzhNdUREUnpLZXduMENnTFJ4YTY1?=
 =?utf-8?B?Ui9lOTJrU1NVS2dsRVZkeW1uRUN6Rm1QOHZrR3BjaEF1bGM4aWptYSs0M2NW?=
 =?utf-8?B?L05XaWk3QXQvcHYxeUp5RmVlK25rdENzam9NQkh5NjZ6d20xNGkvK1B4UVUw?=
 =?utf-8?B?VmNSVEd6UFhyN1VkWWEyNkJmTXlwdFU5WGpIK2NuZHI0MGFSWE1TN3VLYWwx?=
 =?utf-8?B?UStFN2JXNVlQZDM5VWtpS1dVVE1GM3NUV1pWRStXNmN2ZkZwVDFWZHJvejJz?=
 =?utf-8?B?SXVRT2FlT29sTno0ZjJxamtBYms0Zm5pUi9ZSzV6cyt1MElJRjRPMVJCeTRC?=
 =?utf-8?B?d3VPUjhDd2pHbU1SUDg0bzlDZGY0SForMk9naXdJbU12VG1XYUVjU2Jja3pw?=
 =?utf-8?B?MUN5RlVsQkFlN3piaks3TzVNRVpVODMxOHg1dzQxazZlaWJMWmVrTllxVWFQ?=
 =?utf-8?B?NFA3MlNlSjFQQ1pKZEdJM29pdGRCc2ZzckRZOXFrMmU2SG5BbXBpbEw4ck5l?=
 =?utf-8?B?bmFKM3pDVURzUTV4SW1McnlyRTNsTy85YlJXWEY3TFBxME4va2VDQ0U0ZEhC?=
 =?utf-8?B?WFNIQm1uclFMZHJqOWtKb1RIQ3lFQ0ZRQUg3MUdoVkpaQkorV0Z2M2VIU0lv?=
 =?utf-8?B?dUdPak5NV2l4SUNWcDhJQjlsN2RYY2tZN0Nhci9yd2ZCTHcvZXFnTXhtQXQr?=
 =?utf-8?B?Z2xlaWg1a1oySndiK0l5WGdWRnlHV3l1bWdDcWpWekRkK0lXMlZKMHdrcGZr?=
 =?utf-8?B?NXFET2NzSml2bzVBT2lJRVRES211cG1IelNiL2QrbEhMTDFBaTcwcnJ2YUpz?=
 =?utf-8?B?dDFCeHZzNXlLMkYwZEVSSGdqY2RLNld1ZEJFVjhZM1lBQWRVYWtsbnRTaWZF?=
 =?utf-8?B?U2tnV21xNWxKcTVQQ0JzTGVxdDlhUzVRbDZTbDVsQnhkL24zUTJmakFUS0dm?=
 =?utf-8?B?blZqZm5XcVJjSHNoWmlRSCtLanNwb2RCVllFTGtvTDRNWnBWa1dhbWJ6L0sz?=
 =?utf-8?B?SEJPalBudTNSV2NCTGxmczNrS2Z0dWp3SVY1SkhRbWRPS282V0ErNlFKQTF0?=
 =?utf-8?B?Z1RhaXBpMEtMWUE0MmFqN2gxOGlZbjNsV3liRk9Tbkp6c3U5dVFUdkQxbXhX?=
 =?utf-8?B?QWJpY2FjS1JjQ1BJOFY4WlNuMlRJay9Ba3lZT1FyS3M5dEMyUG4wVExnSmZL?=
 =?utf-8?B?ZmpXQVJGem95SlhBODZORXBoNjQ4cUpWOVJGeTFOQncyZzNFcEpiSHMvWHhj?=
 =?utf-8?B?ZEpIbUFuWEZ2dUFqS2t5MFZPWEtPdzNudzVRUERoZ2V1K2lQZGU4SFo3L3A0?=
 =?utf-8?B?RnhhREp6cStKbnhXOW1WNmo1blZDN25qMDlQNTZiTWlsSFJpYWZVQlNTL0tK?=
 =?utf-8?B?b1pXVVh1U0gyOTZtSlAxK3RwdUdTV20xWXV6NmtYK09mU3htUHVUV2xpZmdC?=
 =?utf-8?B?RDNnRlNBK01LeWtwSElXaGIrVG5Xd1VPRHE2SERVYVUyNC80dnhRV001NURm?=
 =?utf-8?B?UFA2OTRRYzhMYzlMQkJpN0tFZy9PdURoLzVaR3NrYUIxWFN3V2FkeXNNUVI4?=
 =?utf-8?B?b01jaStXSGtuUXNmb0RyQlNIbVB0UEE4a1NIc2hSQ1JnSGlRZVJ0NUplYTRa?=
 =?utf-8?B?RW12Q3B1YmlGMGhnQ3Z0SEF6ZXVOTmszVFIya3JuNVUwZ2lGNWoyODdMc0Vx?=
 =?utf-8?B?N0ZvamlqcGc5ZGlHNEJYQlJPNGYwN0JxNlhkS0lGdm96TnVrWEZXTTFWOTdH?=
 =?utf-8?B?TFFVL3BzT0R1SEtQTnRtK3pRRDlmRU5XTForeDZ1M2VGRzJoVEUyMjhzOWZS?=
 =?utf-8?B?WSt2TmhBcWhsUXgzQnNkRlBRR3AyTjNROUEreDBQcDBSSlo2enA4WWFyMC9n?=
 =?utf-8?B?aEN6Z1VEUHhGWWZrUVBSdC9OUnhFUUdkVnI4VTFzdlFoR1hRajd0UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68789a9d-f6f8-4a3a-17e9-08da2e91179e
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 12:16:33.0843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ievqui+3BmyyzUbcO45l8stkIGCMpi3g3C8iYbBjHgJfHKZ42xhAgwGFr9Q78ZgPwTGZL4CbpxEfsKFweBaZFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1925
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/2022 1:15 AM, Alex Williamson wrote:
> On Mon, 25 Apr 2022 14:56:15 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, if the runtime power management is enabled for vfio pci
>> based device in the guest OS, then guest OS will do the register
>> write for PCI_PM_CTRL register. This write request will be handled in
>> vfio_pm_config_write() where it will do the actual register write
>> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
>> achieved for low power. If we can use the runtime PM framework,
>> then we can achieve the D3cold state which will help in saving
>> maximum power.
>>
>> 1. Since D3cold state can't be achieved by writing PCI standard
>>    PM config registers, so this patch adds a new feature in the
>>    existing VFIO_DEVICE_FEATURE IOCTL. This IOCTL can be used
>>    to change the PCI device from D3hot to D3cold state and
>>    then D3cold to D0 state. The device feature uses low power term
>>    instead of D3cold so that if other vfio driver wants to implement
>>    low power support, then the same IOCTL can be used.
> 
> How does this enable you to handle the full-off vs memory-refresh modes
> for NVIDIA GPUs?
> 
 
 Thanks Alex.

 This patch series will just enable the full-off for nvidia GPU.
 The self-refresh mode won't work.

 The self-refresh case is nvidia specific and needs driver
 involvement each time before going into d3cold. We are evaluating
 internally if we have enough use case for self-refresh mode and then
 I will plan separate patch series to support self-refresh mode use
 case, if required. But that will be independent of this patch series.

 At the high level, we need some way to disable the PCI device access
 from the host side or forward the event to VM for every access on the
 host side if we want to support NVIDIA self-refresh use case inside VM.
 Otherwise, from the driver side, we can disable self-refresh mode if
 driver is running inside VM. In that case, if memory usage is higher than
 threshold then we don’t engage RTD3 itself. 

> The feature ioctl supports a probe, but here the probe only indicates
> that the ioctl is available, not what degree of low power support
> available.  Even if the host doesn't support d3cold for the device, we
> can still achieve root port d3hot, but can we provide further
> capability info to the user?
>

 I wanted to add more information here but was not sure which
 information will be helpful for user. There is no certain way to
 predict that the runtime suspend will use D3cold state only even
 on the supported systems. User can disable runtime power management from 

 /sys/bus/pci/devices/…/power/control

 Or disable d3cold itself 

 /sys/bus/pci/devices/…/d3cold_allowed


 Even if all these are allowed, then platform_pci_choose_state()
 is the main function where the target low power state is selected
 in runtime.

 Probably we can add pci_pr3_present() status to user which gives
 hint to user that required ACPI methods for d3cold is present in
 the platform. 
  
>> 2. The hypervisors can implement virtual ACPI methods. For
>>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>>    power resources with _ON/_OFF method, then guest linux OS makes the
>>    _OFF call during D3cold transition and then _ON during D0 transition.
>>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>>    related IOCTL in the vfio driver.
>>
>> 3. The vfio driver uses runtime PM framework to achieve the
>>    D3cold state. For the D3cold transition, decrement the usage count and
>>    for the D0 transition, increment the usage count.
>>
>> 4. For D3cold, the device current power state should be D3hot.
>>    Then during runtime suspend, the pci_platform_power_transition() is
>>    required for D3cold state. If the D3cold state is not supported, then
>>    the device will still be in D3hot state. But with the runtime PM, the
>>    root port can now also go into suspended state.
> 
> Why do we create this requirement for the device to be in d3hot prior
> to entering low power 

 This is mainly to make integration in the hypervisor with
 the PCI power management code flow.

 If we see the power management steps, then following 2 steps
 are involved 

 1. First move the device from D0 to D3hot state by writing
    into config register.
 2. Then invoke ACPI routines (mainly _PR3 OFF method) to
    move from D3hot to D3cold.

 So, in the guest side, we can follow the same steps. The guest can
 do the config register write and then for step 2, the hypervisor
 can implement the virtual ACPI with _PR3/_PR0 power resources.
 Inside this virtual ACPI implementation, the hypervisor can invoke
 the power management IOCTL.

 Also, if runtime PM has been disabled from the host side,
 then also the device will be in d3hot state. 

> when our pm ops suspend function wakes the device do d0?

 The changing to D0 here is happening due to 2 reasons here,

 1. First to preserve device state for the NoSoftRst-.
 2. To make use of PCI core layer generic code for runtime suspend,
    otherwise we need to do all handling here which is present in
    pci_pm_runtime_suspend().

>> 5. For most of the systems, the D3cold is supported at the root
>>    port level. So, when root port will transition to D3cold state, then
>>    the vfio PCI device will go from D3hot to D3cold state during its
>>    runtime suspend. If root port does not support D3cold, then the root
>>    will go into D3hot state.
>>
>> 6. The runtime suspend callback can now happen for 2 cases: there
>>    are no users of vfio device and the case where user has initiated
>>    D3cold. The 'platform_pm_engaged' flag can help to distinguish
>>    between these 2 cases.
> 
> If this were the only use case we could rely on vfio_device.open_count
> instead.  I don't think it is though.  

 platform_pm_engaged is mainly to track the user initiated
 low power entry with the IOCTL. So even if we use vfio_device.open_count
 here, we will still require platform_pm_engaged.

>> 7. In D3cold, all kind of BAR related access needs to be disabled
>>    like D3hot. Additionally, the config space will also be disabled in
>>    D3cold state. To prevent access of config space in D3cold state, do
>>    increment the runtime PM usage count before doing any config space
>>    access.
> 
> Or we could actually prevent access to config space rather than waking
> the device for the access.  Addressed in further comment below.
>  
>> 8. If user has engaged low power entry through IOCTL, then user should
>>    do low power exit first. The user can issue config access or IOCTL
>>    after low power entry. We can add an explicit error check but since
>>    we are already waking-up device, so IOCTL and config access can be
>>    fulfilled. But 'power_state_d3' won't be cleared without issuing
>>    low power exit so all BAR related access will still return error till
>>    user do low power exit.
> 
> The fact that power_state_d3 no longer tracks the device power state
> when platform_pm_engaged is set is a confusing discontinuity.
> 

 If we refer the power management steps (as mentioned in the above),
 then these 2 variable tracks different things.

 1. power_state_d3 tracks the config space write.  
 2. platform_pm_engaged tracks the IOCTL call. In the IOCTL, we decrement
    the runtime usage count so we need to track that we have decremented
    it. 

>> 9. Since multiple layers are involved, so following is the high level
>>    code flow for D3cold entry and exit.
>>
>> D3cold entry:
>>
>> a. User put the PCI device into D3hot by writing into standard config
>>    register (vfio_pm_config_write() -> vfio_lock_and_set_power_state() ->
>>    vfio_pci_set_power_state()). The device power state will be D3hot and
>>    power_state_d3 will be true.
>> b. Set vfio_device_feature_power_management::low_power_state =
>>    VFIO_DEVICE_LOW_POWER_STATE_ENTER and call VFIO_DEVICE_FEATURE IOCTL.
>> c. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>>    will be called first which will make the usage count as 2 and then
>>    vfio_pci_core_ioctl_feature() will be invoked.
>> d. vfio_pci_core_feature_pm() will be called and it will go inside
>>    VFIO_DEVICE_LOW_POWER_STATE_ENTER switch case. platform_pm_engaged will
>>    be true and pm_runtime_put_noidle() will decrement the usage count
>>    to 1.
>> e. Inside vfio_device_fops_unl_ioctl() while returning the
>>    pm_runtime_put() will make the usage count to 0 and the runtime PM
>>    framework will engage the runtime suspend entry.
>> f. pci_pm_runtime_suspend() will be called and invokes driver runtime
>>    suspend callback.
>> g. vfio_pci_core_runtime_suspend() will change the power state to D0
>>    and do the INTx mask related handling.
>> h. pci_pm_runtime_suspend() will take care of saving the PCI state and
>>    all power management handling for D3cold.
>>
>> D3cold exit:
>>
>> a. Set vfio_device_feature_power_management::low_power_state =
>>    VFIO_DEVICE_LOW_POWER_STATE_EXIT and call VFIO_DEVICE_FEATURE IOCTL.
>> b. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>>    will be called first which will make the usage count as 1.
>> c. pci_pm_runtime_resume() will take care of moving the device into D0
>>    state again and then vfio_pci_core_runtime_resume() will be called.
>> d. vfio_pci_core_runtime_resume() will do the INTx unmask related
>>    handling.
>> e. vfio_pci_core_ioctl_feature() will be invoked.
>> f. vfio_pci_core_feature_pm() will be called and it will go inside
>>    VFIO_DEVICE_LOW_POWER_STATE_EXIT switch case. platform_pm_engaged and
>>    power_state_d3 will be cleared and pm_runtime_get_noresume() will make
>>    the usage count as 2.
>> g. Inside vfio_device_fops_unl_ioctl() while returning the
>>    pm_runtime_put() will make the usage count to 1 and the device will
>>    be in D0 state only.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_config.c |  11 ++-
>>  drivers/vfio/pci/vfio_pci_core.c   | 131 ++++++++++++++++++++++++++++-
>>  include/linux/vfio_pci_core.h      |   1 +
>>  include/uapi/linux/vfio.h          |  18 ++++
>>  4 files changed, 159 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index af0ae80ef324..65b1bc9586ab 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/vfio.h>
>>  #include <linux/slab.h>
>> +#include <linux/pm_runtime.h>
>>  
>>  #include <linux/vfio_pci_core.h>
>>  
>> @@ -1936,16 +1937,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>  			   size_t count, loff_t *ppos, bool iswrite)
>>  {
>> +	struct device *dev = &vdev->pdev->dev;
>>  	size_t done = 0;
>>  	int ret = 0;
>>  	loff_t pos = *ppos;
>>  
>>  	pos &= VFIO_PCI_OFFSET_MASK;
>>  
>> +	ret = pm_runtime_resume_and_get(dev);
>> +	if (ret < 0)
>> +		return ret;
> 
> Alternatively we could just check platform_pm_engaged here and return
> -EINVAL, right?  Why is waking the device the better option?
> 

 This is mainly to prevent race condition where config space access
 happens parallelly with IOCTL access. So, lets consider the following case.

 1. Config space access happens and vfio_pci_config_rw() will be called.
 2. The IOCTL to move into low power state is called.
 3. The IOCTL will move the device into d3cold.
 4. Exit from vfio_pci_config_rw() happened.

 Now, if we just check platform_pm_engaged, then in the above
 sequence it won’t work. I checked this parallel access by writing
 a small program where I opened the 2 instances and then
 created 2 threads for config space and IOCTL.
 In my case, I got the above sequence.

 The pm_runtime_resume_and_get() will make sure that device
 usage count keep incremented throughout the config space
 access (or IOCTL access in the previous patch) and the
 runtime PM framework will not move the device into suspended
 state.

>> +
>>  	while (count) {
>>  		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
>> -		if (ret < 0)
>> +		if (ret < 0) {
>> +			pm_runtime_put(dev);
>>  			return ret;
>> +		}
>>  
>>  		count -= ret;
>>  		done += ret;
>> @@ -1953,6 +1961,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>  		pos += ret;
>>  	}
>>  
>> +	pm_runtime_put(dev);
>>  	*ppos += done;
>>  
>>  	return done;
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 05a68ca9d9e7..beac6e05f97f 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -234,7 +234,14 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	ret = pci_set_power_state(pdev, state);
>>  
>>  	if (!ret) {
>> -		vdev->power_state_d3 = (pdev->current_state >= PCI_D3hot);
>> +		/*
>> +		 * If 'platform_pm_engaged' is true then 'power_state_d3' can
>> +		 * be cleared only when user makes the explicit request to
>> +		 * move out of low power state by using power management ioctl.
>> +		 */
>> +		if (!vdev->platform_pm_engaged)
>> +			vdev->power_state_d3 =
>> +				(pdev->current_state >= PCI_D3hot);
> 
> power_state_d3 is essentially only used as a secondary test to
> __vfio_pci_memory_enabled() to block r/w access to device regions and
> generate a fault on mmap access.  Its existence already seems a little
> questionable when we could just look at vdev->pdev->current_state, and
> we could incorporate that into __vfio_pci_memory_enabled().  So rather
> than creating this inconsistency, couldn't we just make that function
> return:
> 
> !vdev->platform_pm_enagaged && pdev->current_state < PCI_D3hot &&
> (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY))
> 

 The main reason for power_state_d3 is to get it under
 memory_lock semaphore. But pdev->current_state is not
 protected with any lock. So, will use of pdev->current_state
 here be safe?
 
> 
>>  
>>  		/* D3 might be unsupported via quirk, skip unless in D3 */
>>  		if (needs_save && pdev->current_state >= PCI_D3hot) {
>> @@ -266,6 +273,25 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
>>  {
>>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>  
>> +	down_read(&vdev->memory_lock);
>> +
>> +	/* 'platform_pm_engaged' will be false if there are no users. */
>> +	if (!vdev->platform_pm_engaged) {
>> +		up_read(&vdev->memory_lock);
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * The user will move the device into D3hot state first before invoking
>> +	 * power management ioctl. Move the device into D0 state here and then
>> +	 * the pci-driver core runtime PM suspend will move the device into
>> +	 * low power state. Also, for the devices which have NoSoftRst-,
>> +	 * it will help in restoring the original state (saved locally in
>> +	 * 'vdev->pm_save').
>> +	 */
>> +	vfio_pci_set_power_state(vdev, PCI_D0);
>> +	up_read(&vdev->memory_lock);
>> +
>>  	/*
>>  	 * If INTx is enabled, then mask INTx before going into runtime
>>  	 * suspended state and unmask the same in the runtime resume.
>> @@ -395,6 +421,19 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>  
>>  	/*
>>  	 * This function can be invoked while the power state is non-D0.
>> +	 * This non-D0 power state can be with or without runtime PM.
>> +	 * Increment the usage count corresponding to pm_runtime_put()
>> +	 * called during setting of 'platform_pm_engaged'. The device will
>> +	 * wake up if it has already went into suspended state. Otherwise,
>> +	 * the next vfio_pci_set_power_state() will change the
>> +	 * device power state to D0.
>> +	 */
>> +	if (vdev->platform_pm_engaged) {
>> +		pm_runtime_resume_and_get(&pdev->dev);
>> +		vdev->platform_pm_engaged = false;
>> +	}
>> +
>> +	/*
>>  	 * This function calls __pci_reset_function_locked() which internally
>>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
>>  	 * fail if the power state is non-D0. Also, for the devices which
>> @@ -1192,6 +1231,80 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>>  
>> +#ifdef CONFIG_PM
>> +static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
>> +				    void __user *arg, size_t argsz)
>> +{
>> +	struct vfio_pci_core_device *vdev =
>> +		container_of(device, struct vfio_pci_core_device, vdev);
>> +	struct pci_dev *pdev = vdev->pdev;
>> +	struct vfio_device_feature_power_management vfio_pm = { 0 };
>> +	int ret = 0;
>> +
>> +	ret = vfio_check_feature(flags, argsz,
>> +				 VFIO_DEVICE_FEATURE_SET |
>> +				 VFIO_DEVICE_FEATURE_GET,
>> +				 sizeof(vfio_pm));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
>> +		down_read(&vdev->memory_lock);
>> +		vfio_pm.low_power_state = vdev->platform_pm_engaged ?
>> +				VFIO_DEVICE_LOW_POWER_STATE_ENTER :
>> +				VFIO_DEVICE_LOW_POWER_STATE_EXIT;
>> +		up_read(&vdev->memory_lock);
>> +		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
>> +			return -EFAULT;
>> +		return 0;
>> +	}
>> +
>> +	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * The vdev power related fields are protected with memory_lock
>> +	 * semaphore.
>> +	 */
>> +	down_write(&vdev->memory_lock);
>> +	switch (vfio_pm.low_power_state) {
>> +	case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>> +		if (!vdev->power_state_d3 || vdev->platform_pm_engaged) {
>> +			ret = EINVAL;
>> +			break;
>> +		}
>> +
>> +		vdev->platform_pm_engaged = true;
>> +
>> +		/*
>> +		 * The pm_runtime_put() will be called again while returning
>> +		 * from ioctl after which the device can go into runtime
>> +		 * suspended.
>> +		 */
>> +		pm_runtime_put_noidle(&pdev->dev);
>> +		break;
>> +
>> +	case VFIO_DEVICE_LOW_POWER_STATE_EXIT:
>> +		if (!vdev->platform_pm_engaged) {
>> +			ret = EINVAL;
>> +			break;
>> +		}
>> +
>> +		vdev->platform_pm_engaged = false;
>> +		vdev->power_state_d3 = false;
>> +		pm_runtime_get_noresume(&pdev->dev);
>> +		break;
>> +
>> +	default:
>> +		ret = EINVAL;
>> +		break;
>> +	}
>> +
>> +	up_write(&vdev->memory_lock);
>> +	return ret;
>> +}
>> +#endif
>> +
>>  static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>>  				       void __user *arg, size_t argsz)
>>  {
>> @@ -1226,6 +1339,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>> +#ifdef CONFIG_PM
>> +	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
>> +		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
>> +#endif
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> @@ -2189,6 +2306,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  		goto err_unlock;
>>  	}
>>  
>> +	/*
>> +	 * Some of the devices in the dev_set can be in the runtime suspended
>> +	 * state. Increment the usage count for all the devices in the dev_set
>> +	 * before reset and decrement the same after reset.
>> +	 */
>> +	ret = vfio_pci_dev_set_pm_runtime_get(dev_set);
>> +	if (ret)
>> +		goto err_unlock;
>> +
>>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
>>  		/*
>>  		 * Test whether all the affected devices are contained by the
>> @@ -2244,6 +2370,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  		else
>>  			mutex_unlock(&cur->vma_lock);
>>  	}
>> +
>> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>> +		pm_runtime_put(&cur->pdev->dev);
>>  err_unlock:
>>  	mutex_unlock(&dev_set->lock);
>>  	return ret;
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index e84f31e44238..337983a877d6 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -126,6 +126,7 @@ struct vfio_pci_core_device {
>>  	bool			needs_pm_restore;
>>  	bool			power_state_d3;
>>  	bool			pm_intx_masked;
>> +	bool			platform_pm_engaged;
>>  	struct pci_saved_state	*pci_saved_state;
>>  	struct pci_saved_state	*pm_save;
>>  	int			ioeventfds_nr;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index fea86061b44e..53ff890dbd27 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -986,6 +986,24 @@ enum vfio_device_mig_state {
>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>  };
>>  
>> +/*
>> + * Use platform-based power management for moving the device into low power
>> + * state.  This low power state is device specific.
>> + *
>> + * For PCI, this low power state is D3cold.  The native PCI power management
>> + * does not support the D3cold power state.  For moving the device into D3cold
>> + * state, change the PCI state to D3hot with standard configuration registers
>> + * and then call this IOCTL to setting the D3cold state.  Similarly, if the
>> + * device in D3cold state, then call this IOCTL to exit from D3cold state.
>> + */
>> +struct vfio_device_feature_power_management {
>> +#define VFIO_DEVICE_LOW_POWER_STATE_EXIT	0x0
>> +#define VFIO_DEVICE_LOW_POWER_STATE_ENTER	0x1
>> +	__u64	low_power_state;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3
> 
> __u8 seems more than sufficient here.  Thanks,
> 
> Alex
>

 I have used __u64 mainly to get this structure 64 bit aligned.
 I was impression that the ioctl structure should be 64 bit aligned
 but in this case since we will have just have __u8 member so
 alignment should not be required?
 
 Regards,
 Abhishek
