Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1040956B5DB
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 11:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbiGHJpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 05:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiGHJpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 05:45:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC265796A6;
        Fri,  8 Jul 2022 02:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClOdeEvqDNSRPyBB+r6qGhtKuIPoMVE/LXAreNSNm3DwFrRTmjttleJh6h8/cVZv9Gr5sYmvNxVbqOFAe8NRvsFBHdN3hA0pxbfwkG1Wdi4vTRIoD+iKn2GokC8UDX7yPA9OL+ot8NDCbNbLlG+5xOgqP9bq+FLwLEH5AUb4elR8PLJts4FnuzVe5i67+fSHxKJW7fbT9Kr5Yp1F3nHZRc2F9FgDmVgitEE7qkfIw/lsn6oPW0Us+M1gHujKAfVZkNIZ24s+jV3nACtGv39GivdmWCpILUnBg+eYf1XdJz5hzPQM69QGdA4+8+VAW4c/oeM0sK4MkjGIitJ9QSLaSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5Gx+lJf6ll0KJScg937GPqmKbtvc4QZOGyuyeP4UH0=;
 b=hr7CrmTufO3JfVU9361Kvttv3WRakL3wEWOnxv3mZkZgPJahrRS0ksjQxDFRGSjIPKBW0S9BIM66dXTi4Xr6p3aLLfS4dZwCIdXWpepCjnZhF6zL/UhLwOGHwmeYoesLSkJXWfNw4br5qEfzZI2v/4kcys109WNNyB0+2SISJxghy4FPfylYi6Mlxq/w3oIRH9nnBT4FynhAouNA7rOC+N7revMrk1omkpmv5i+px31SEKiArRbHPUSY9XSRXVpN+5qH2pU98de2BeNJHGwtoI/fZfrOUIxbdWNk//un06rnJtXbQiquKMuPAAQW3WHW6MBmpce71X/gFoTmWwZ2Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5Gx+lJf6ll0KJScg937GPqmKbtvc4QZOGyuyeP4UH0=;
 b=KeE8ub0RwnvIN71Vl9zQg6s9x6jfPociqCVsPlY6XMh2eZVS8k7w0xpbewFS1DuA4O6EXXRxrVUzbWZpxLTft0SyFFBjhUwMnRmL+t2geHUN3Dcixr127LQ7QbukUw3sd5r0XNBMEDcXrLcc3YzR8B/TVurxmFLjHnJ89Imdhrxqxjr4YIpQNI/aqz0k2hjwsd2Virckcf3KxoimNYvxibXMFzvWmKBEdd/pIo+Mwk1S4vN/1wQvw2IC5M1Y2XpepGMU0NTlYlr3brsD6PVlL8zO4irIbYZ3xN3/t+IL5DsS0HBPvYU/K3x7ofE+ZB1I77Bx5EeM/Amk5yNyNBKrIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BN8PR12MB4625.namprd12.prod.outlook.com (2603:10b6:408:71::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 8 Jul
 2022 09:45:45 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 09:45:45 +0000
Message-ID: <81f1ec94-bdb2-a49a-3903-33939ab88196@nvidia.com>
Date:   Fri, 8 Jul 2022 15:15:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 6/6] vfio/pci: Add support for virtual PME
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
References: <20220701110814.7310-1-abhsahu@nvidia.com>
 <20220701110814.7310-7-abhsahu@nvidia.com>
 <20220706094009.6726cf6a.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220706094009.6726cf6a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::22) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c51e3a01-aad5-441e-6d72-08da60c6a16d
X-MS-TrafficTypeDiagnostic: BN8PR12MB4625:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJo6TimzRZrF8yHL/zb3fULvCmCqQ6x0fWrjUuEUDgk+R6dvUNy5lK5tAj3dmPpJW+0XO3G0ArqWhaidC24iqp47YYMpHmuZTm6sEzVhNAQimbqXuJ7nn8tF6oGy4rBvh5B4OMkWv3orhZWzJbYffM/8rj0J18iNSx0x7keN1zlhqQTt4DNZsfPzy91dLpxUiyFcYwc8HRb/roUAZEIKF1uCuT2wwCO1tSzcDAcM/XHd1jjLOoZyn8ZzvedDYh6RVIUrv1KKA0041gFroSyx8knThsvrGSjHNtwarPcilwkVPDtj126zibu4Qg0FyysvuxG+5fTkMlbYISRIL4+oKetUWrXII+qlkIrBpq8upooOZM38JOkw3W9RG1cx8y9Njyt5GuxF+tomDIDgyeD1yYTmOQIJM6Klu6IGPRoez09iwk806yiY/9KSDrchNuinxwdYpkLHIl9/tPLKV8z+CO76CdXUqTJRa+LZL4I4/II9JuxqqCEIgOwSlrQZP05g2fHkDsnGI22XnqLaqtQ9NmTtxsKHBGDm1uXXKONIPCanQVMFkYu1JKn/yUR+2FFP4ENRgFu9sTI+HQ1y6SMXB/zhTp/YjUOcIPToUZOK7pndK1XkTtUaPwXewn8KdRL8yXn04WBqi4dwADrTMZiJiJx7SHPNMg/ixEwPww+t3TDX8UKol45Tr28ZKK3FaxsnSVrWOTtyq9ErRwAiUzKKoPut5F+s6pselFmBU4H8S6ompX+f355UvDTiv/fcGJythhvBYGTSvIyDxWXHGvRA8RtVG1CaCX0UP+NnKPkORsWsOQkockMyooQ+SOayXBv+CsQ3e32Fg8Srd4PkkC/wQmK0sLcemnRn2i3zblchyJY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(6666004)(38100700002)(86362001)(30864003)(31696002)(7416002)(5660300002)(8936002)(2906002)(41300700001)(316002)(6486002)(54906003)(66476007)(66556008)(4326008)(66946007)(478600001)(186003)(55236004)(83380400001)(53546011)(6512007)(26005)(6506007)(6916009)(31686004)(2616005)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zzlnd0xld0dHbVZpLzV2TkplUVVSZnFaQ3pEUnd5L2ZwbHVyTitudVF1NFF3?=
 =?utf-8?B?RDg4ZVd1UmtwTmowWmJteUcxRlJtdVRtRjBWb3A4bXZsWFJ0d0xUQ0xOcTJ1?=
 =?utf-8?B?OGhOUEZLajZxR2x4MFJ6eCs1dG4wQjdlMVlqeDhaaDQ4Q050c3ZsUkdRVkdk?=
 =?utf-8?B?SUJWL3FDcjZwZVBuZTJQNExuQ2l0TWhrWE9yZFhORXJ0VHlBS1EzK2kyYUVk?=
 =?utf-8?B?bWovUDQyWFFySU1hNmF1WGZDeHVPaVlqVjJWcVU5alNsOVJiZ0dpREFqRjlk?=
 =?utf-8?B?aHEwbG1FOEZ4c2J6TTJYWEdOek9panBLNUxvTzFiM2VxU1ZCUmwxTlY3bjEz?=
 =?utf-8?B?U3AzLzZ4WG9qcFV5S2Qra1FPalI4UTVFNlhPVUdGODFBdnNaSXJrZDB6VlNM?=
 =?utf-8?B?V1JpRFhGWGlpTEQyQnU5YjhZYUlJcUIrZzJEaG9kdTlYRzNqQVFjRHRBdmxo?=
 =?utf-8?B?czM2OFRZd1lrQkQwZzdFSXZURGFHdVl6dDhmVWpJTW9WOHNvcm9oaFUxSG9B?=
 =?utf-8?B?WnhuaUs5eGZsc0FCY28zRzdqZVpaTDRmNUZ4RGJjdzNnR29OV2doT0oyL3Zx?=
 =?utf-8?B?SmdGeUNlUFpydmZmN2huejlkNk5BZDA5SDZBM3hHWVBSVXFhNUlPbC8zM3Fy?=
 =?utf-8?B?dEt4aStsSXg4WWYveVNYdnRMVFNmK2hORUJzNnRWQkV2NFFVWTJ2UHdrNU1W?=
 =?utf-8?B?WFFHd282Q3BjZlcvaWlrTlBGTWphbGxtSFFXdnQ1bkcxRis4cHI0dmtvcHcr?=
 =?utf-8?B?UXRCWmtaVjM3aFVpeER0T2srOCtoWEEyQmtwNm1DRjBidkh1bUxacFZPMy9M?=
 =?utf-8?B?WDJCZEtaZUxFa2syWUlCN2RLRXRxenNyRWd6WTB0TVZWVVU5ekYrTXhFZ1hj?=
 =?utf-8?B?ZXM3dnVHUkJsc0tqUk9lVHBvQ3QvcFZrZ1JJUkg0aWNpWllrMnBsQXIvaGV3?=
 =?utf-8?B?dS9QQWFOUFY1ME1KaDg5U01DemhSVWFFcFZsYVVpRjFFRlk0OFBJOFo1RGlj?=
 =?utf-8?B?WjRlbXZhOGdwTmhIcHJFNWJET09iQWt1RWN4RHZmN3JSdVlIUWN4N3FVMHIr?=
 =?utf-8?B?TFFCcmVValcyTmJwN0RrQ2tIYlpoRWVZZ3IxcGR6MFJuMkU2eGsyOVNiazd1?=
 =?utf-8?B?L2FoYTZ3aU5VUG9Pc0YwNzU3eWhmOTVwUDREckc3VlFRUktNeHVZc3RyTjdy?=
 =?utf-8?B?QVR3YjhPam9NMmtIdVViaG95eXorRHJkZzA1TFRTT1k4c0RNajdHTmRqQ094?=
 =?utf-8?B?MjhlaXErbnNoQ0k1ZkZ5Y28rZkVDMGtpcEJTejAwTlpuRHNFNnVJR3BZOXZq?=
 =?utf-8?B?cm16Yk5pQ1U1WFA0a3lMZ0k3YkZHVm95NFhuNnZadThIR29rbTJ2Vm9GS0Zs?=
 =?utf-8?B?a0t6Z0w1aUhROGRwUk8rS25aUmNOeTF5MGJOT3ZVVWlJTGNjT3RNcWU2TFFp?=
 =?utf-8?B?TmZzSzUyUkIrZGNvM0tKSnRkWTRzVStRSFR4Qyt2dU52QnVvTmg0MVYwYnRt?=
 =?utf-8?B?Z1VUOUdoVlI5MUdLcXc3WWsrRld2UkluSDRHcndPaXByN0NKajhtZVZzbm9U?=
 =?utf-8?B?cHBNS2RKclF3MkhKU0E2R3lxVXV0MDhGdkZ6N044TFFEcU5PL0t3UUw5dERM?=
 =?utf-8?B?cEV0QUZ0QmJraVM4cWdVemEwczUxSFd5NVU1UWFXV1JPVnF3OUpENjdwSER6?=
 =?utf-8?B?Zml6K1Y3YXVxMmhuYVVjaGppODVTaTVLVHRrbXJIUklKVFpXVkt0RDVYWmxx?=
 =?utf-8?B?VW9PbURZQVF0ak4wZkgxVEpUSU9VQ2tUWDM5eVNDNVgxaWp3Ris3QVFGSUhZ?=
 =?utf-8?B?UkNrZ2xIUVJvc0Jabkg5aG9LamhtSExCYm9LdlI1LytuOEJiT2UxY1d6MG00?=
 =?utf-8?B?T2o0QzlrNjdjYTZ5L2IwUEt4SnZmOXJWRzFtNjc5Qlo2amo3cS9JMkRZbGlk?=
 =?utf-8?B?aWQrN0poOWU3VHRYQkdERmZ4ZUFlZ3pNRVNvWU1xNWxUa0VHOWJxZzY0bkV0?=
 =?utf-8?B?WERSTEpDM3ZEek9FOFNQSmJ1d2UrN2hxZFNraUI1WEpRTmYzc01CVUc1dmpM?=
 =?utf-8?B?OEIxMUN1ZmJGZFFVVVZvRTJ6WUdoUjV6YmlnL21nQU5VbmVkc2FmVGJrNHU2?=
 =?utf-8?Q?XlIhV3AiovLc8b9t8kVSqKyiV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51e3a01-aad5-441e-6d72-08da60c6a16d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 09:45:45.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZhskjs2qYPG5ILLxNhpGqt5aByA+LiksWyLSR/9n6ASi0JWkfW1zLVfkWZAEmiEs63isq5EjID/eMBPCGf8MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4625
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/2022 9:10 PM, Alex Williamson wrote:
> On Fri, 1 Jul 2022 16:38:14 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> If the PCI device is in low power state and the device requires
>> wake-up, then it can generate PME (Power Management Events). Mostly
>> these PME events will be propagated to the root port and then the
>> root port will generate the system interrupt. Then the OS should
>> identify the device which generated the PME and should resume
>> the device.
>>
>> We can implement a similar virtual PME framework where if the device
>> already went into the runtime suspended state and then there is any
>> wake-up on the host side, then it will send the virtual PME
>> notification to the guest. This virtual PME will be helpful for the cases
>> where the device will not be suspended again if there is any wake-up
>> triggered by the host. Following is the overall approach regarding
>> the virtual PME.
>>
>> 1. Add one more event like VFIO_PCI_ERR_IRQ_INDEX named
>>    VFIO_PCI_PME_IRQ_INDEX and do the required code changes to get/set
>>    this new IRQ.
>>
>> 2. From the guest side, the guest needs to enable eventfd for the
>>    virtual PME notification.
>>
>> 3. In the vfio-pci driver, the PME support bits are currently
>>    virtualized and set to 0. We can set PME capability support for all
>>    the power states. This PME capability support is independent of the
>>    physical PME support.
>>
>> 4. The PME enable (PME_En bit in Power Management Control/Status
>>    Register) and PME status (PME_Status bit in Power Management
>>    Control/Status Register) are also virtualized currently.
>>    The write support for PME_En bit can be enabled.
>>
>> 5. The PME_Status bit is a write-1-clear bit where the write with
>>    zero value will have no effect and write with 1 value will clear the
>>    bit. The write for this bit will be trapped inside
>>    vfio_pm_config_write() similar to PCI_PM_CTRL write for PM_STATES.
>>
>> 6. When the host gets a request for resuming the device other than from
>>    low power exit feature IOCTL, then PME_Status bit will be set.
>>    According to [PCIe v5 7.5.2.2],
>>      "PME_Status - This bit is Set when the Function would normally
>>       generate a PME signal. The value of this bit is not affected by
>>       the value of the PME_En bit."
>>
>>    So even if PME_En bit is not set, we can set PME_Status bit.
>>
>> 7. If the guest has enabled PME_En and registered for PME events
>>    through eventfd, then the usage count will be incremented to prevent
>>    the device to go into the suspended state and notify the guest through
>>    eventfd trigger.
>>
>> The virtual PME can help in handling physical PME also. When
>> physical PME comes, then also the runtime resume will be called. If
>> the guest has registered for virtual PME, then it will be sent in this
>> case also.
>>
>> * Implementation for handling the virtual PME on the hypervisor:
>>
>> If we take the implementation in Linux OS, then during runtime suspend
>> time, then it calls __pci_enable_wake(). It internally enables PME
>> through pci_pme_active() and also enables the ACPI side wake-up
>> through platform_pci_set_wakeup(). To handle the PME, the hypervisor has
>> the following two options:
>>
>> 1. Create a virtual root port for the VFIO device and trigger
>>    interrupt when the PME comes. It will call pcie_pme_irq() which will
>>    resume the device.
>>
>> 2. Create a virtual ACPI _PRW resource and associate it with the device
>>    itself. In _PRW, any GPE (General Purpose Event) can be assigned for
>>    the wake-up. When PME comes, then GPE can be triggered by the
>>    hypervisor. GPE interrupt will call pci_acpi_wake_dev() function
>>    internally and it will resume the device.
> 
> Do we really need to implement PME emulation in the kernel or is it
> sufficient for userspace to simply register a one-shot eventfd when
> SET'ing the low power feature and QEMU can provide the PME emulation
> based on that signaling?  Thanks,
> 
> Alex
> 

 It seems it can be implemented in QEMU instead of kernel.
 I will drop this patch.

 Thanks,
 Abhishek
 
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_config.c | 39 +++++++++++++++++++++------
>>  drivers/vfio/pci/vfio_pci_core.c   | 43 ++++++++++++++++++++++++------
>>  drivers/vfio/pci/vfio_pci_intrs.c  | 18 +++++++++++++
>>  include/linux/vfio_pci_core.h      |  2 ++
>>  include/uapi/linux/vfio.h          |  1 +
>>  5 files changed, 87 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index 21a4743d011f..a06375a03758 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -719,6 +719,20 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
>>  	if (count < 0)
>>  		return count;
>>  
>> +	/*
>> +	 * PME_STATUS is write-1-clear bit. If PME_STATUS is 1, then clear the
>> +	 * bit in vconfig. The PME_STATUS is in the upper byte of the control
>> +	 * register and user can do single byte write also.
>> +	 */
>> +	if (offset <= PCI_PM_CTRL + 1 && offset + count > PCI_PM_CTRL + 1) {
>> +		if (le32_to_cpu(val) &
>> +		    (PCI_PM_CTRL_PME_STATUS >> (offset - PCI_PM_CTRL) * 8)) {
>> +			__le16 *ctrl = (__le16 *)&vdev->vconfig
>> +					[vdev->pm_cap_offset + PCI_PM_CTRL];
>> +			*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
>> +		}
>> +	}
>> +
>>  	if (offset == PCI_PM_CTRL) {
>>  		pci_power_t state;
>>  
>> @@ -771,14 +785,16 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
>>  	 * the user change power state, but we trap and initiate the
>>  	 * change ourselves, so the state bits are read-only.
>>  	 *
>> -	 * The guest can't process PME from D3cold so virtualize PME_Status
>> -	 * and PME_En bits. The vconfig bits will be cleared during device
>> -	 * capability initialization.
>> +	 * The guest can't process physical PME from D3cold so virtualize
>> +	 * PME_Status and PME_En bits. These bits will be used for the
>> +	 * virtual PME between host and guest. The vconfig bits will be
>> +	 * updated during device capability initialization. PME_Status is
>> +	 * write-1-clear bit, so it is read-only. We trap and update the
>> +	 * vconfig bit manually during write.
>>  	 */
>>  	p_setd(perm, PCI_PM_CTRL,
>>  	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
>> -	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
>> -		 PCI_PM_CTRL_STATE_MASK));
>> +	       ~(PCI_PM_CTRL_STATE_MASK | PCI_PM_CTRL_PME_STATUS));
>>  
>>  	return 0;
>>  }
>> @@ -1454,8 +1470,13 @@ static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
>>  	__le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
>>  	__le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
>>  
>> -	/* Clear vconfig PME_Support, PME_Status, and PME_En bits */
>> -	*pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
>> +	/*
>> +	 * Set the vconfig PME_Support bits. The PME_Status is being used for
>> +	 * virtual PME support and is not dependent upon the physical
>> +	 * PME support.
>> +	 */
>> +	*pmc |= cpu_to_le16(PCI_PM_CAP_PME_MASK);
>> +	/* Clear vconfig PME_Support and PME_En bits */
>>  	*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
>>  }
>>  
>> @@ -1582,8 +1603,10 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>>  		if (ret)
>>  			return ret;
>>  
>> -		if (cap == PCI_CAP_ID_PM)
>> +		if (cap == PCI_CAP_ID_PM) {
>> +			vdev->pm_cap_offset = pos;
>>  			vfio_update_pm_vconfig_bytes(vdev, pos);
>> +		}
>>  
>>  		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
>>  		pos = next;
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 1ddaaa6ccef5..6c1225bc2aeb 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -319,14 +319,35 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
>>  	 *   the low power state or closed the device.
>>  	 * - If there is device access on the host side.
>>  	 *
>> -	 * For the second case, check if re-entry to the low power state is
>> -	 * allowed. If not, then increment the usage count so that runtime PM
>> -	 * framework won't suspend the device and set the 'pm_runtime_resumed'
>> -	 * flag.
>> +	 * For the second case:
>> +	 * - The virtual PME_STATUS bit will be set. If PME_ENABLE bit is set
>> +	 *   and user has registered for virtual PME events, then send the PME
>> +	 *   virtual PME event.
>> +	 * - Check if re-entry to the low power state is not allowed.
>> +	 *
>> +	 * For the above conditions, increment the usage count so that
>> +	 * runtime PM framework won't suspend the device and set the
>> +	 * 'pm_runtime_resumed' flag.
>>  	 */
>> -	if (vdev->pm_runtime_engaged && !vdev->pm_runtime_reentry_allowed) {
>> -		pm_runtime_get_noresume(dev);
>> -		vdev->pm_runtime_resumed = true;
>> +	if (vdev->pm_runtime_engaged) {
>> +		bool pme_triggered = false;
>> +		__le16 *ctrl = (__le16 *)&vdev->vconfig
>> +				[vdev->pm_cap_offset + PCI_PM_CTRL];
>> +
>> +		*ctrl |= cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
>> +		if (le16_to_cpu(*ctrl) & PCI_PM_CTRL_PME_ENABLE) {
>> +			mutex_lock(&vdev->igate);
>> +			if (vdev->pme_trigger) {
>> +				pme_triggered = true;
>> +				eventfd_signal(vdev->pme_trigger, 1);
>> +			}
>> +			mutex_unlock(&vdev->igate);
>> +		}
>> +
>> +		if (!vdev->pm_runtime_reentry_allowed || pme_triggered) {
>> +			pm_runtime_get_noresume(dev);
>> +			vdev->pm_runtime_resumed = true;
>> +		}
>>  	}
>>  	up_write(&vdev->memory_lock);
>>  
>> @@ -586,6 +607,10 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>>  		eventfd_ctx_put(vdev->req_trigger);
>>  		vdev->req_trigger = NULL;
>>  	}
>> +	if (vdev->pme_trigger) {
>> +		eventfd_ctx_put(vdev->pme_trigger);
>> +		vdev->pme_trigger = NULL;
>> +	}
>>  	mutex_unlock(&vdev->igate);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
>> @@ -639,7 +664,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>>  	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
>>  		if (pci_is_pcie(vdev->pdev))
>>  			return 1;
>> -	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>> +	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX ||
>> +		   irq_type == VFIO_PCI_PME_IRQ_INDEX) {
>>  		return 1;
>>  	}
>>  
>> @@ -985,6 +1011,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>  		switch (info.index) {
>>  		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
>>  		case VFIO_PCI_REQ_IRQ_INDEX:
>> +		case VFIO_PCI_PME_IRQ_INDEX:
>>  			break;
>>  		case VFIO_PCI_ERR_IRQ_INDEX:
>>  			if (pci_is_pcie(vdev->pdev))
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 1a37db99df48..db4180687a74 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -639,6 +639,17 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
>>  					       count, flags, data);
>>  }
>>  
>> +static int vfio_pci_set_pme_trigger(struct vfio_pci_core_device *vdev,
>> +				    unsigned index, unsigned start,
>> +				    unsigned count, uint32_t flags, void *data)
>> +{
>> +	if (index != VFIO_PCI_PME_IRQ_INDEX || start != 0 || count > 1)
>> +		return -EINVAL;
>> +
>> +	return vfio_pci_set_ctx_trigger_single(&vdev->pme_trigger,
>> +					       count, flags, data);
>> +}
>> +
>>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>>  			    unsigned index, unsigned start, unsigned count,
>>  			    void *data)
>> @@ -688,6 +699,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>>  			break;
>>  		}
>>  		break;
>> +	case VFIO_PCI_PME_IRQ_INDEX:
>> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
>> +			func = vfio_pci_set_pme_trigger;
>> +			break;
>> +		}
>> +		break;
>>  	}
>>  
>>  	if (!func)
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 18cc83b767b8..ee2646d820c2 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -102,6 +102,7 @@ struct vfio_pci_core_device {
>>  	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
>>  	u8			*pci_config_map;
>>  	u8			*vconfig;
>> +	u8			pm_cap_offset;
>>  	struct perm_bits	*msi_perm;
>>  	spinlock_t		irqlock;
>>  	struct mutex		igate;
>> @@ -133,6 +134,7 @@ struct vfio_pci_core_device {
>>  	int			ioeventfds_nr;
>>  	struct eventfd_ctx	*err_trigger;
>>  	struct eventfd_ctx	*req_trigger;
>> +	struct eventfd_ctx	*pme_trigger;
>>  	struct list_head	dummy_resources_list;
>>  	struct mutex		ioeventfds_lock;
>>  	struct list_head	ioeventfds_list;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 7e00de5c21ea..08170950d655 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -621,6 +621,7 @@ enum {
>>  	VFIO_PCI_MSIX_IRQ_INDEX,
>>  	VFIO_PCI_ERR_IRQ_INDEX,
>>  	VFIO_PCI_REQ_IRQ_INDEX,
>> +	VFIO_PCI_PME_IRQ_INDEX,
>>  	VFIO_PCI_NUM_IRQS
>>  };
>>  
> 

