Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C373C3C0
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 00:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjFWWFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 18:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjFWWFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 18:05:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0B326AD;
        Fri, 23 Jun 2023 15:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buqA3bDOhSqsubsADTTwS5Cz2a8ahW1SJ3e3A0/ZI9ooMwb06qyAya4BbMCUBIrRD8Lx76qlhzyyMZq6MWP4Hx6BLZ+8OcsrzxOeix8kSBmfhFuOt9ihHJidegv6+Duxn9/uVQLxVUhnOBx5zqCBfjN5TtjNJ4DMllE98CWeWcEZsFQuFiJ4zLmbCllThLrKoRt2gGpXO4FiKwZdoWb4rAS8Q0QKi7BK/+YENE1pmHWzeRzdoPgyT1Ve9h2+J9B7MZ7ExBVzTK65h7z4/SoHTVZ5qIaFlfS7lap4bXOJMYa54Fsp8czppm6z4kuIfpYKwlHVf0dLu5DMHsJ2aaK3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5E1ZD1aMAF3Fbd/kb772q6zeHmKOLEYcD7KT0kXoJto=;
 b=m2LLhQjnTZ14PQAVfQwF6ZTj+TtKOk9NtW4WAqSEN3MEEN8tMF/ECkF9QEEhIKkc24K+tSeD6V14D3vfd1P4MVfvif7pOuUttp/M3Df/7mOmy4IbyR3dUxjZUgcTlKGRHtMqiCqB3VyJih3Z9MKLniREEvVkHCmHJUnhIGr2R8bjx4bTWaWbj9TVLFpDOb3zJ9gf7L6VUsrW07l6k87vVcMW76IL1brpMjVMK+QCp7eNN4+1tIB+ttFuYQKfPvPsKsv7tj/2OJGaVesF2XI2kb6pmyoiXsNKq8b/G9YXuUdz0IBt6RGB3DB7jcUNyYn6ShHFry3Q+OgrR8DVOwG1lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5E1ZD1aMAF3Fbd/kb772q6zeHmKOLEYcD7KT0kXoJto=;
 b=qPKPHyHg7vxLVszwaKCUPxyiM3EGiWoETW2HQkKQNnHUCdzR4xfKZ2Up3YkeRgrBxAVzDGc/S1rG5E0xGa64zllVKKsLc83a4d6ktmZx1Cij2YNZwfggTSj063Po2BV5dRWtFFwwJHstFySYIXMXirkwzNQ8KmMRwoeShG8AjAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BY5PR12MB4872.namprd12.prod.outlook.com (2603:10b6:a03:1c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 22:05:25 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 22:05:25 +0000
Message-ID: <b3c85550-a7f6-a0d9-74a4-f98c8251b80e@amd.com>
Date:   Fri, 23 Jun 2023 15:05:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW accelerated
 vIOMMU w/ nested page table
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com> <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
 <ZJWF3oVvdj4OQmTf@nvidia.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZJWF3oVvdj4OQmTf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|BY5PR12MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f42fa4-83f2-4127-4b3f-08db7435f28e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgCUJiliQ479LA8QSEU/TbpLXLGNmWP45vQyZrgQPv1vGznJzCxKyRMUTehZLacPpBKaadE477sCDgjl0MUk9Z/rTciI9mRIyG6mNTIDsSXdLmvHbSQd9eAev0aG0P7g5jjT+MGx2fdV4A1aH55MDknZAYDaZi4GAuDs5cfE99dRDa5Y0SPFe2Qz9echZlgh1sQliyOp04mVF7o8dYQEUWQf10B3oKB5tfGvouqlYyjwEpNsuKDerfqpNoju2R2j68FD1kvd28qSy8+IV/iL1ZAINto+f/MmKIWiPXUw24Eqm1ZQYxF4IWcyRv+E7Out2d5v+QpgS8yXwhasjensgPKeKS1QxaADJvCO7zPn8KML3nDyLfZB+mu6TovXHyqAsLB9+UG6dQwJVhjqbFyW10McfxXeSQZb3QFKlcXzgMKGy/gU3SvjU0GyTo6lN6QaWsO58ztxoAgC9hAOLwwxuqmTA8hjQUhIq9B3yaEbw9J3ANPSJVl/BVZzrH2fPrXzjY5tI+S1Kx3nhi2nsO+WsMaHQel7mGZWULgnBvIki81GCM37hoeU68xG1unzLJYV8OaP4h4OL3VFpQEX45jCqDxJrWL7phQUtAZFeBdTGfOCAtEVb+5q/eHve0a7fJ3aNoSjZnUVnxCG63n5eSGEcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(31686004)(6666004)(6512007)(6506007)(53546011)(6486002)(186003)(478600001)(2616005)(86362001)(31696002)(6916009)(66476007)(66946007)(66556008)(4326008)(316002)(83380400001)(7416002)(41300700001)(5660300002)(2906002)(38100700002)(26005)(36756003)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFc2OU9aMWdwWVNuMWt3eUhmK0xDamFwci9RWVlVZEt4RUVzaG14UFQzamFl?=
 =?utf-8?B?K3RteXdLMHg3bnNsMmt1cjFabGJpUHJDQkgwYjFOWS9TUWRRdEw2QjI2ZEEz?=
 =?utf-8?B?dUhpZEtwb3c4K2pNZVJ1RUhmNngzK29IZmVvdFBVcmZ5TWZ2OTVpdDQvV1A5?=
 =?utf-8?B?eUhWSXdpOExSeU00YnQ1Nko4SVhoUzNydVAzUUZYVkJHV3dSczdkZXdFMG9j?=
 =?utf-8?B?c2l4Y2dNSXFuR0F1R3pHbmZLVFNsSW5RVUZRUFFaTlVLNWhrVTFwdmhlTXdV?=
 =?utf-8?B?SVg5LzZuelpFcHl0MDJqZkVBcThsM2Jkby9tM0M1c1djeXNlenpzM1hBRlM2?=
 =?utf-8?B?dkU0RWZidWZ0VkhIc01RZE5Pc0dQQitwWUx4dThuYTlCTXJSb0J2UlpwanhZ?=
 =?utf-8?B?SEQ3bDRQVTVVK0ZWWmhUYms2SzZIUFBwYmFOWnBiS3ROZUl0clN6Uy9PMmdL?=
 =?utf-8?B?TzZ6VDh3Z2l6VkNWZXgxTDdEK2w1ZVBZbkFyOTcwT1J3YW9JK3lCZHc0R1JL?=
 =?utf-8?B?RU5aTWNrN1VXUXpIdFk2S1h0UjBDYWg1c2hDOWptM2pqVDRUc3Rlbm9hRmZw?=
 =?utf-8?B?Wit4M3Q0RWRhZWtaMmdVWmpSMnE5OTJINkNNNm41L0JvRHVma1pnZGpmNTlp?=
 =?utf-8?B?aDFIa3JzdnQzbU8vb21VY08rMHhoUnJEUXhqenhuT084Y0xDeVBzbWsxblNx?=
 =?utf-8?B?dmxoeGh6TkExZXZNSEQraTRuUm82b1h1ZHBkYkV5MG9OcDNENy9WeTNsSUhr?=
 =?utf-8?B?djdQa2tJSFJUWnFZNXlCd3piTExmaDhRUWwrVXdkamNGMHhTa0RueFFBL1Zt?=
 =?utf-8?B?ZXA4TEl1TWE4SDNJVEtZNVVEWXgwODlaa1lPc0NiRDRWeDFKRkFBV2s5UXd4?=
 =?utf-8?B?ZTJxMWVRK1g1dEZwZnI5SFJyUmVFMEJ5ZmM4MHg4eHN2UlU1VDh5Z1hkb1Mv?=
 =?utf-8?B?Nkg3Z0xpR2FIbzd5cGJ4YWNseHFjQlNPdHIrNEVXTjgzTXdaZHVZVXVrM1Fs?=
 =?utf-8?B?blZveXcrSHROb0VUaWduNjJ2RDlsZ3hDajlOckMvTTVZeSs0VGZEclNsVDRM?=
 =?utf-8?B?cm5MRk1HaGlmNjQrYVJtUmZxWjg3cFpQS3M5WHFMdFpMMHNHam1NT2ovRWJa?=
 =?utf-8?B?WW82YVdsNTZicEt3c0Rhclcvakl4MmREVE9qUWRNd3I5andDNC9uM1ZKUzFl?=
 =?utf-8?B?MndmekFGOTJnSkZQRDBnMFhjbDJqRS91eHlMVUM3ejlwazRqcHZwbDZ1Wk9W?=
 =?utf-8?B?NTFjMHpwMkVhd2JnVDFtQkpubFB3M3gyV2NEd1Ewck1qR3V6amZNNnJZQnJJ?=
 =?utf-8?B?eEdvVG5wY2NuSkZrclFXMVlFY1gxUkI3L1g2a1J4T3F3ajg5V1pibHEzNENy?=
 =?utf-8?B?aW9jQ0hGN0JFNk9vRG9PQ2Qvd1V1M0FSVk9MTlFyaTVxN2wrVlFTSkFiN0ln?=
 =?utf-8?B?Rnh6N2pTSjRacGZseVFodklCYW9yZUR0UjhlQThDUXNONGFvakFyNkl3RFlE?=
 =?utf-8?B?eFllRFU4d2tZUUQrQUFxNzA1SmV2bkEyc2RpdnNGOFNjbjFSVDBMTkRIUFlh?=
 =?utf-8?B?Ui9LWnZwQU9MV1gySkhLNlU0SHRKdUpzSG5rMzV4TGNrR2p0eXRzS2tIbUs1?=
 =?utf-8?B?UnVkb1VNb21iYXdrTlgvdVNqUzFLMUFXblpYQ2hoZWtSQjROK0IrSDFnMkR3?=
 =?utf-8?B?bTBhZEdKTEQweTJzMmwyZEswUXR2R0xYQVhUTGZZNkRJTXBxWkVaRVJjTXFj?=
 =?utf-8?B?d09EMnV2Tzhtdkw0Qko4TVlBNlFZekdSMFhZU1p1TkMrMDRSeC80Z2xuZkw0?=
 =?utf-8?B?UmM4alAvSzgzcmNwYzA2UkNLRU5iQmNGcTFtbmlNN1VVWXRRNU04N0VJcHFk?=
 =?utf-8?B?WUFRUzNVc082a21DY1FjTmYzYTJCN1BvUVF5eTZINktUaGxNakJDcnlDSmFq?=
 =?utf-8?B?MDM2SFBYRDNkeWcvOXV5QXU5WW5WcXNKRFF1d1ZLRjM2K3dOWHY2KzVQVUM1?=
 =?utf-8?B?cUlXYk5hT0F6K0FTdnhtSnIzSUE0NHhOc0xSMUlWaWs3QlNOYnVhR0xRbHEz?=
 =?utf-8?B?bm02ZC9tUFZTMDFSbnlWNTF1Yi9rQWhrOGxMdDAxK3VXb2lDK2pXbnBSYWl4?=
 =?utf-8?Q?TfVkrBgSbRr8CcxazO9ZwNAKD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f42fa4-83f2-4127-4b3f-08db7435f28e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 22:05:25.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHQTZcF+rFvbKxtJfxKdC1ZA5g2ga3wxFmoZIEJ1JznBANXcCg8DD8nxK+/k9jdwDoBYQH/gRj4KDXonS0DHlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4872
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason,

On 6/23/2023 4:45 AM, Jason Gunthorpe wrote:
> On Thu, Jun 22, 2023 at 06:15:17PM -0700, Suthikulpanit, Suravee wrote:
>> Jason,
>>
>> On 6/22/2023 6:46 AM, Jason Gunthorpe wrote:
>>> On Wed, Jun 21, 2023 at 06:54:47PM -0500, Suravee Suthikulpanit wrote:
>>>
>>>> Since the IOMMU hardware virtualizes the guest command buffer, this allows
>>>> IOMMU operations to be accelerated such as invalidation of guest pages
>>>> (i.e. stage1) when the command is issued by the guest kernel without
>>>> intervention from the hypervisor.
>>>
>>> This is similar to what we are doing on ARM as well.
>>
>> Ok
>>
>>>> This series is implemented on top of the IOMMUFD framework. It leverages
>>>> the exisiting APIs and ioctls for providing guest iommu information
>>>> (i.e. struct iommu_hw_info_amd), and allowing guest to provide guest page
>>>> table information (i.e. struct iommu_hwpt_amd_v2) for setting up user
>>>> domain.
>>>>
>>>> Please see the [4],[5], and [6] for more detail on the AMD HW-vIOMMU.
>>>>
>>>> NOTES
>>>> -----
>>>> This series is organized into two parts:
>>>>     * Part1: Preparing IOMMU driver for HW-vIOMMU support (Patch 1-8).
>>>>
>>>>     * Part2: Introducing HW-vIOMMU support (Patch 9-21).
>>>>
>>>>     * Patch 12 and 21 extends the existing IOMMUFD ioctls to support
>>>>       additional opterations, which can be categorized into:
>>>>       - Ioctls to init/destroy AMD HW-vIOMMU instance
>>>>       - Ioctls to attach/detach guest devices to the AMD HW-vIOMMU instance.
>>>>       - Ioctls to attach/detach guest domains to the AMD HW-vIOMMU instance.

I'm re-looking into these three a bit and will get back.

>>>>       - Ioctls to trap certain AMD HW-vIOMMU MMIO register accesses.
To describe the need for this ioctl, AMD IOMMU has two set of MMIO 
registers:
   1. Control MMIO
   2. Data MMIO

For AMD HW-vIOMMU, the hardware define a private memory address space 
(PAS) containing VF Control MMIO and VF MMIO register for each guest 
IOMMU instance, which represents the guest view of the AMD IOMMU MMIO 
registers. This memory is also accessed by the IOMMU hardware to 
virtualize the guest MMIO register.

When the guest IOMMU driver write to guest control MMIO register of the 
QEMU AMD HW-vIOMMU device model, it traps into QEMU. QEMU reads the 
value call VIOMMU_MMIO_ACCESS to tell the AMD IOMMU driver in the host 
to program VFCtrlMMIO or VFMMIO register for this guest.

Similar for the read on guest control MMIO register, QEMU calls ioctl to 
get the value from AMD iommu driver, which reads the guest VFCtrlMMIO or 
VFMMIO register and provide back to the guest.

>>>>       - Ioctls to trap AMD HW-vIOMMU command buffer initialization.

For this ioctl, the IOMMU hardware define an IOMMU PAS containing a 
command buffer for each guest IOMMU instance. This memory is also 
accessed by IOMMU hardware to virtualize the guest command buffer.

When the guest IOMMU driver write to guest Command Buffer Base Address 
MMIO register of the QEMU AMD HW-vIOMMU device model, it traps into 
QEMU. QEMU reads the value, parse the GPA, and translate to HVA. Then it 
calls VIOMMU_CMDBUF_UPDATE to communicate the HVA to IOMMU driver to map 
it in the IOMMU PAS so that it use this memory to virtualize the guest 
command buffer.

>>>
>>> No one else seems to need this kind of stuff, why is AMD different?
>>>
>>> Emulation and mediation to create the vIOMMU is supposed to be in the
>>> VMM side, not in the kernel. I don't want to see different models by
>>> vendor.
>>
>> These ioctl is not necessary for emulation, which I would agree that it
>> should be done on the VMM side (e.g. QEMU). These ioctls provides necessary
>> information for programming the AMD IOMMU hardware to provide
>> hardware-assisted virtualized IOMMU.
> 
> You have one called 'trap', it shouldn't be like this. It seems like
> this is trying to parse the command buffer in the kernel, it should be
> done in the VMM.

Please see the more detail description above. Basically, all parsing is 
done in the VMM, and it use the ioctl to tell IOMMU driver to program 
the VFCtrlMMIO/VFMMIO registers or IOMMU PAS for the hardware to access.

>> In this series, AMD IOMMU GCR3 table is actually setup when the
>> IOMMUFD_CMD_HWPT_ALLOC is called, which the driver provides a hook to struct
>> iommu_ops.domain_alloc_user().
> 
> That isn't entirely right either, the GCR3 should be programmed into
> HW during iommu_domain attach.
> >> The AMD-specific information is communicated from QEMU via
>> iommu_domain_user_data.iommu_hwpt_amd_v2. This is similar to INTEL
>> and ARM.
> 
> This is only for requesting the iommu_domain and supplying the gcr3 VA
> for later use.

Ah, ok. Lemme look into this again and get back to you.

>.... 
>
>> There are still work to be done in this to fully support PASID. I'll
>> take a look at this next.
> 
> I would expect PASID work is only about invalidation?

Actually, I am referring to supporting non-zero PASID, which requires 
walking the guest IOMMU gCR3 table and communicate this to the hypervisor.

>>> To start focus only on user space page tables and kernel mediated
>>> invalidation and fit into the same model as everyone else. This is
>>> approx the same patches and uAPI you see for ARM and Intel. AFAICT
>>> AMD's HW is very similar to ARM's, so you should be aligning to the
>>> ARM design.
>>
>> I think the user space page table is covered as described above.
> 
> I'm not sure, it doesn't look like it is what I would expect.

Lemme clean up this part and get back in next RFC.

>> It seems that user-space is supposed to call the ioctl
>> IOMMUFD_CMD_HWPT_INVALIDATE for both INTEL and ARM to issue invalidation for
>> stage 1 page table. Please lemme know if I misunderstand the purpose of this
>> ioctl.
> 
> Yes, the VMM traps the invalidation and issues it like this.
>   
>> However, for AMD since the HW-vIOMMU virtualizes the guest command buffer,
>> and when it sees the page table invalidation command in the guest command
>> buffer, it takes care of the invalidation using information in the DomIDMap,
>> which maps guest domain ID (gDomID) of a particular guest to the
>> corresponding host domain ID (hDomID) of the device and invalidate the
>> nested translation according to the specified PASID, DomID, and GVA.
> 
> The VMM should do all of this stuff. The VMM parses the command buffer
> and the VMM converts the commands to invalidation ioctls.
>
> I'm a unclear if AMD supports a mode where the HW can directly operate
> a command/invalidation queue in the VM without virtualization. Eg DMA
> from guest memory and deliver directly to the guest completion
> interrupts.

Correct, VMM does not need to parse the command buffer. The hardware 
takes care of virtualizing the invalidation commands in the guest 
command buffer directly buffer w/o VMM helps to do invalidation from the 
host side.

For AMD IOMMU, the invalidation command is normally followed by the 
COMPLETION_WAIT command on a memory semaphore, in which the hardware 
updates after all the prior commands are completed.

For Linux, we are not using Completion Wait interrupt. The iommu driver 
polls on the memory semphore in a loop.

> If it always needs SW then the SW part should be in the VMM, not the
> kernel. Then you don't need to load all these tables into the kernel.
> 

As described, the IOMMU driver needs to program the IOMMU PAS. IOMMU 
hardware uses its own IOMMU page table to access the PAS.

For example, an AMD IOMMU hardware is normally listed as a PCI device 
(e.g. PCI ID 00:00.2). To setup IOMMU PAS for this IOMMU instance, the 
IOMMU driver allocate an IOMMU v1 page table for this device, which 
contains PAS mapping.

The IOMMU hardware use the PAS for storing Guest IOMMU information such 
as Guest MMIOs, DevID Mapping Table, DomID Mapping Table, and Guest 
Command/Event/PPR logs.

Thanks,
Suravee
