Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD75800F4
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiGYOsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 10:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiGYOse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 10:48:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B71140AE;
        Mon, 25 Jul 2022 07:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEj1Hg3Px082M40nZhU4ZysSxjlByIX50nNQSCff6El/iWiZYN9MJ3oyZIM706ELcHLN461j0J1SKntXNN4RDsbZez1my3JMG4OoGW/KayJh3mBu0DZ+WTukIFNKTZ1/HHwO1eiqy+vitkWVaA+f7OTIh2QalCicHZtqUszqwSpcHQKrBvXMd8nUG7Pwe4DQnfUylrmUmh4WzoI1J8PaHlNudun1l7tnjmNSUB8xlFXcGGaPB813cUjAs/MKUajz1e8Mx1cdXDWjfVPZhVHCSFd0VmkVbb7g5Y1XDR1lnJzi12WezEj2fLbPJIarvLUu/b+vG6cLJWk53sSO4au9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGR148m2EvsKyuGU3f6+GKq/+Kw+7RILhdvmNfrN3LA=;
 b=RNj75ac+vqXKCyFXDLF+DISB25Nt8to4Ny4BPRnFXHg2zgQiAAYKpqY+OrgGPjxoxv7iP5A1EwS0nsasA/zeLvrLXtFOkNsF8t48PDg7XoQ7euCmdJWMmnRZKQPdPZh1sFDTT+TSi4TgFW5/jZeP1nn4kKqd5/wwtpxSZmyJDIp/e+ZXxEpJc18F0soefX0brnY6aDrc9V5FoN78eKF+Sj21CRRBIDz52s6pRnkizj05qodlZX2Vmygq4cfhl+lshOHN1mDOzUVe5TD1GZTdssgA0eks6umo125VYdh5q/F7qzkIG0l73pqQA8lWt01OcnAY1J+0wjf30UEcKCPiWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGR148m2EvsKyuGU3f6+GKq/+Kw+7RILhdvmNfrN3LA=;
 b=gFrfJgMPJoHCpCG6MU/NXvLiaoDI0UffNuUbV8BMh2/yq1Xdo6EmV2XHoPDsUsMeFgTUCT+1t2MyqSjV3HRTt8gJ4aPWXU0+BPmo38AcZ4ULkvk3IjsA8yq46L6puHAwlDQavQ/CkZIq74xHFLmCJ2sTfs8WGehUjpdIfh8AqKtnh87F/525DbvsurjTfCx+pSgiJ/m74KtbNjwCCNnwoJkFajxqnWgnTHsrUV6sy+BmgGAuefPjsXQsm7HY1AHqiJq15Am8xRpyqFPKABaziEN7RkjZUPH5ibieaZG4ysYwDQjbo3Alyj8gDD0stLWciXqva7W2mDC82JFNtM0ySw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MWHPR1201MB0094.namprd12.prod.outlook.com (2603:10b6:301:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 14:48:30 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:48:30 +0000
Message-ID: <e6bd500e-f250-982f-cda6-2ec8ccb6d592@nvidia.com>
Date:   Mon, 25 Jul 2022 20:18:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 4/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY/EXIT
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
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-5-abhsahu@nvidia.com>
 <20220721163455.5ba133ef.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220721163455.5ba133ef.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::21) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a09f2ad-a6fd-47e4-14b8-08da6e4cbd3d
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0094:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PKAgowhPlUAR5snoTvro1YGQ0xc/4GArJs8kkncqKum3BjhAomfgkkfg2Pxni6/meHZHVCMbMZFUXJSbpXcnAEA8IIFsjEsMfPVijrnGK950HyIyAYqoOf/C3Uj3J+LRHKWvB+ffyPLka8HQxSwzN+GFX9w74vIWrPUqA7F1x40X10ePJ5txqP1adCLQPAtVJ1GzZtFakbZChySpJ6670pHVbIrFce2w6R4B3ZN1CQ4AvvOOoYfRoMKPWe06y7wMtt6KZf42RYc0jyKwM9GJwsjdppYYfe7qv6sqn3csf2tzVLVwoTeIjl/P8Xpndbm8vWhs0sjpNunTID8l0yjqB3mlzlpGWpo4X8q5iqX2/tjINg9eXEPrtf5ukYOGASfzKF32329xJGewyhbT5G6wgqitHV94M2ryPYxRZXo8gZwjVfJEdgEl3Q5xaadXz+CX6H6Ua5W+jfzNmNygBjKJZbrD+jg5d6hBQ8YbuBb/GZd/sg0OvVvR+CcZBfUu6e6MTj3+lvV+p6FsYRsilmOZMyZSmlfeihXsl9QlXmZmnKlQLXQ+z/xqpPdynqk4ODM9Be3V7ycj7PsOOiOlSI6W45rHg3iV3sNDXc24c672oJb8FDqY4g+Ugn8EG04UjhJkFKwE5a7Ijcy0RggQ4SyZ+INg60H7Lm5CY/aWUxjTq7GFFsFYne/dyDBhoKlmunIA9yS3EcmKCqg7k2deaE34xav18amHTs8T+JpUGVM5F+rU4gRvJ6FMqgMuPun4zWGJKJe90OPEOuwhSKDnH+OBAIrkVxPGtJKbx/HEXln41V7SbqoI5U1exZWz11miCuKJG+WciRuEWyi5ZCfcr8Dzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(6916009)(54906003)(478600001)(6486002)(6666004)(2906002)(316002)(41300700001)(5660300002)(30864003)(8676002)(66946007)(4326008)(66476007)(7416002)(66556008)(8936002)(86362001)(83380400001)(31696002)(55236004)(6512007)(2616005)(36756003)(186003)(31686004)(38100700002)(26005)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VldqUitKWFZUWVd2L3F0aUFPc2U4Ny9WVVlTeGdJeVpsdXU5RGU1NkZ0RHB6?=
 =?utf-8?B?dUxyZVBVK3NpZHNQZFR2dHcxS0V1VjE3TnhsT20vOVd4V3pHYmZoQ0d1dHEx?=
 =?utf-8?B?eS80c1VCN3lrL05JQjFJb0EwdVJxcC9oUnE1RHYwaXdmMVJFK2lYOU05d0RT?=
 =?utf-8?B?azRoNUFNekxRdzltallnbXV4RlFOTFJ6d0U5V3lrVkduVEJEdnAwWGxOb2xx?=
 =?utf-8?B?Sm9hWFNyT0tmeTV1eUEyb2NJV1JPRUpaWnFONHdoQWtXU2RHUXJScHlSRzE4?=
 =?utf-8?B?ZmdCVzBNYnQ0QkRXWXUxb0tMRUs0UjlPc21uOHdzRUhqZCtDMGwvY2ttNzVi?=
 =?utf-8?B?RW1vd29JbWs3aWkxWWQ1ZjMyTFhNcTdPUzNFUExJL1p2YWpyYzJTSUQyb2pT?=
 =?utf-8?B?OHNEZTc0ekdDakcvZHNoblJTV2g2eTJxRGFMeWRtSVVLWGw5ZzhGRWpsckkx?=
 =?utf-8?B?NTdQaGxYUGtZL2xZRzFQOFl0Yms5ZlFLWGxjbm12b0kraUdkSG1xaWxBWDJu?=
 =?utf-8?B?ck1xQlBHbW1SN0U0azNuQTdkSEswQmladmdrL3duNEEzcUZ1bGthN1VyQlBF?=
 =?utf-8?B?Y2x3Q3VObk5jRE5rN3pETXhUdHRvbWxaTjdsQWhkL0dTcjJna0N6L2xYcSs5?=
 =?utf-8?B?bkJEc2JpYVhKYm5NWks5VVNnR0lqS3dIai9udkFIdUt2ZlJoc3lEQUVId05l?=
 =?utf-8?B?NXBVdWxBZ3pqeklxZGRHYzQxbFp5Y21UZVBtdVhEUXFMc3dVQnk3N1AvUURx?=
 =?utf-8?B?NCtqRUwzcVpJa01abHgzS3hnOFlBRzhvUzlCM3VSZE9GeUhmQ1JEdG1nMWdo?=
 =?utf-8?B?VGRvU01mTlNsZVRpWUJJUUhlYnIvdUhMUGtxTzZsa3hPT2xoWDljaDNpRXpI?=
 =?utf-8?B?Q1dOL1FZK3dJeC92QUVPdVRNYnF0aHk0UGpCcFQvL0FycytkZTh2KzhGamcx?=
 =?utf-8?B?ZVlIK2h5UHJCRDU2S0lXQTZmajlHb25kUUV1RU1zczNNT1p5bjNVSk0vbFhP?=
 =?utf-8?B?YjdiVFZzNTQxREU3bW5ISlRWbXUzcHdxMGo5cHQzWkI2SWdBWVFQT3JxcDFY?=
 =?utf-8?B?OThwbmx6Z0NMenhyK1JyaXVUNFNLaDJ4bWxaeVdNZmZaeGw3SWFFdWhHaXJS?=
 =?utf-8?B?dXBJZkRDUHF1TnFPOFVnM2w5N2orTnhIc1hiVzI3RERDUGRiMnUreGN1a2Jm?=
 =?utf-8?B?ZC84QllIai8rL0psbzYzWTBtMXNNNm03L2h4YllTbFhZNW0vL1RTMmljTCts?=
 =?utf-8?B?ejlNRjZRRjBiZVNZRGYwV3hZdmxSdXlNOU5aLzlsM01xcmczOTdmeTZlREM5?=
 =?utf-8?B?QTJEU0EwOGxLcEUzYk14RUZuMlRHd3locFlFU1B0Q05tM3QydXhOdmhEdy9r?=
 =?utf-8?B?V1BMU2p6WVVMR2dJN0pLeW44anZzVzVoZHd0d3FYOWV5eG9DTFNIcWFQdCtW?=
 =?utf-8?B?S1RtM2xlY3ByTHpKWmw4UCtrNWxTUWFyY3U4TE9aRVFqQTJSamIrYWpISUVS?=
 =?utf-8?B?aCtXRWhtVUVGZnp4ald5VHR2TkZucElFbjh6VElvaUFMZmFRREVWdUtYZ0xr?=
 =?utf-8?B?Ui9xaG53MklEb2pFTmp1ejNKTXZ6MU1WOHd2aEova1o3K3AzcDMrNDRzZm43?=
 =?utf-8?B?Q0NlczNzenFVVjFGMW00NjdPaDI1VzIxS1U1WVB6RVRtYUl5czJ2U2szZEVs?=
 =?utf-8?B?NWlaVCsyVDM3OVp5dUlIazAzVTExWWlCdWI2RXVJK25qTURFckdHY1dUdnFH?=
 =?utf-8?B?cDlaL3BpRmpyMVVpR0wrd0t4K3VqU0NzVUJUQjUyWVVxK1Q5NVlLQU45Tk1q?=
 =?utf-8?B?Z3IrdjJoZTVrb1FvcFdjZG5HQzZLQ2c1MC9aczhBN1Y0bHNjcEw2aTZxcTc4?=
 =?utf-8?B?cUt5SmN3SXM2NkpuTEdkMlRhQmxQQlpCNkMySVZaRkhjNzE2NXV4WktLenFL?=
 =?utf-8?B?ZGQrT3ZBaHFscnJOSFA4R05sZklUU1VtSGtMeUFKMlhKZ25SOWJpU2IwTkJx?=
 =?utf-8?B?dW5vUkpFWCtRbVNMcElBbzRVbUJzendSSldzTjhadWJ5WXJZUVlmbXN0ZHBi?=
 =?utf-8?B?TWtBNHdiMFZhVDhtN045QTc1SGRyNDNJMk43K2ZyMnlTaUpUamlSRXFzdWN3?=
 =?utf-8?Q?TumMNObruSd3bzeZiyCYMREJD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a09f2ad-a6fd-47e4-14b8-08da6e4cbd3d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 14:48:30.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ma4yl++ytzcE0YfIKpv4xmWKozi2t1R5HoIJBP6qKR5kvJWSs4gdo8MViEZEN+ztnRLKhIKFIGJIAnCbNefS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0094
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/2022 4:04 AM, Alex Williamson wrote:
> On Tue, 19 Jul 2022 17:45:22 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, if the runtime power management is enabled for vfio-pci
>> based devices in the guest OS, then the guest OS will do the register
>> write for PCI_PM_CTRL register. This write request will be handled in
>> vfio_pm_config_write() where it will do the actual register write of
>> PCI_PM_CTRL register. With this, the maximum D3hot state can be
>> achieved for low power. If we can use the runtime PM framework, then
>> we can achieve the D3cold state (on the supported systems) which will
>> help in saving maximum power.
>>
>> 1. D3cold state can't be achieved by writing PCI standard
>>    PM config registers. This patch implements the following
>>    newly added low power related device features:
>>     - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>>     - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
>>
>>    The VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY will move the device into
>>    the low power state, and the VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
>>    will move the device out of the low power state.
> 
> Isn't this really:
> 
> 	The VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY feature will allow the
> 	device to make use of low power platform states on the host
> 	while the VFIO_DEVICE_FEATURE_LOW_POWER_EXIT will prevent
> 	further use of those power states.
> 
> ie. we can't make the device move to low power and every ioctl/access
> will make it exit, it's more about allowing/preventing use of those
> platform provided low power states.
> 

 Thanks Alex.
 Yes. I will update this.

>>
>> 2. The vfio-pci driver uses runtime PM framework for low power entry and
>>    exit. On the platforms where D3cold state is supported, the runtime
>>    PM framework will put the device into D3cold otherwise, D3hot or some
>>    other power state will be used. If the user has explicitly disabled
>>    runtime PM for the device, then the device will be in the power state
>>    configured by the guest OS through PCI_PM_CTRL.
> 
> This is talking about disabling runtime PM support for a device on the
> host precluding this interface from allowing the device to enter
> platform defined low power states, right?
> 
 
 Yes. It is on the host side.
 I will update this to include the host term to make this clear.
 Also, there are more cases where device won't go into runtime
 suspended state which you mentioned in the first patch (the dependent
 devices preventing the runtime suspend or user keeps the device busy).
 I will add that as well. In all these cases, the device will be in
 active state.

>> 3. The hypervisors can implement virtual ACPI methods. For example,
>>    in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
>>    resources with _ON/_OFF method, then guest linux OS invokes
>>    the _OFF method during D3cold transition and then _ON during D0
>>    transition. The hypervisor can tap these virtual ACPI calls and then
>>    call the low power device feature IOCTL.
>>
>> 4. The 'pm_runtime_engaged' flag tracks the entry and exit to
>>    runtime PM. This flag is protected with 'memory_lock' semaphore.
>>
>> 5. All the config and other region access are wrapped under
>>    pm_runtime_resume_and_get() and pm_runtime_put(). So, if any
>>    device access happens while the device is in the runtime suspended
>>    state, then the device will be resumed first before access. Once the
>>    access has been finished, then the device will again go into the
>>    runtime suspended state.
>>
>> 6. The memory region access through mmap will not be allowed in the low
>>    power state. Since __vfio_pci_memory_enabled() is a common function,
>>    so check for 'pm_runtime_engaged' has been added explicitly in
>>    vfio_pci_mmap_fault() to block only mmap'ed access.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 151 +++++++++++++++++++++++++++++--
>>  include/linux/vfio_pci_core.h    |   1 +
>>  2 files changed, 144 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 9517645acfa6..726a6f282496 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -259,11 +259,98 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	return ret;
>>  }
>>  
>> +static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
>> +{
>> +	/*
>> +	 * The vdev power related flags are protected with 'memory_lock'
>> +	 * semaphore.
>> +	 */
>> +	vfio_pci_zap_and_down_write_memory_lock(vdev);
>> +	if (vdev->pm_runtime_engaged) {
>> +		up_write(&vdev->memory_lock);
>> +		return -EINVAL;
>> +	}
> 
> Awkward that we zap memory for the error path here, but optimizing
> performance for a user that can't remember they've already activated
> low power for a device doesn't seem like a priority ;)
> 
>> +
>> +	vdev->pm_runtime_engaged = true;
>> +	pm_runtime_put_noidle(&vdev->pdev->dev);
>> +	up_write(&vdev->memory_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
>> +				  void __user *arg, size_t argsz)
>> +{
>> +	struct vfio_pci_core_device *vdev =
>> +		container_of(device, struct vfio_pci_core_device, vdev);
>> +	int ret;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	/*
>> +	 * Inside vfio_pci_runtime_pm_entry(), only the runtime PM usage count
>> +	 * will be decremented. The pm_runtime_put() will be invoked again
>> +	 * while returning from the ioctl and then the device can go into
>> +	 * runtime suspended state.
>> +	 */
>> +	return vfio_pci_runtime_pm_entry(vdev);
>> +}
>> +
>> +static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>> +{
>> +	/*
>> +	 * The vdev power related flags are protected with 'memory_lock'
>> +	 * semaphore.
>> +	 */
>> +	down_write(&vdev->memory_lock);
>> +	if (vdev->pm_runtime_engaged) {
>> +		vdev->pm_runtime_engaged = false;
>> +		pm_runtime_get_noresume(&vdev->pdev->dev);
>> +	}
>> +
>> +	up_write(&vdev->memory_lock);
>> +}
>> +
>> +static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
>> +				 void __user *arg, size_t argsz)
>> +{
>> +	struct vfio_pci_core_device *vdev =
>> +		container_of(device, struct vfio_pci_core_device, vdev);
>> +	int ret;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	/*
>> +	 * The device should already be resumed by the vfio core layer.
>> +	 * vfio_pci_runtime_pm_exit() will internally increment the usage
>> +	 * count corresponding to pm_runtime_put() called during low power
>> +	 * feature entry.
>> +	 */
>> +	vfio_pci_runtime_pm_exit(vdev);
>> +	return 0;
>> +}
>> +
>>  #ifdef CONFIG_PM
>>  static int vfio_pci_core_runtime_suspend(struct device *dev)
>>  {
>>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>  
>> +	down_write(&vdev->memory_lock);
>> +	/*
>> +	 * The user can move the device into D3hot state before invoking
>> +	 * power management IOCTL. Move the device into D0 state here and then
>> +	 * the pci-driver core runtime PM suspend function will move the device
>> +	 * into the low power state. Also, for the devices which have
>> +	 * NoSoftRst-, it will help in restoring the original state
>> +	 * (saved locally in 'vdev->pm_save').
>> +	 */
>> +	vfio_pci_set_power_state(vdev, PCI_D0);
>> +	up_write(&vdev->memory_lock);
>> +
>>  	/*
>>  	 * If INTx is enabled, then mask INTx before going into the runtime
>>  	 * suspended state and unmask the same in the runtime resume.
>> @@ -393,6 +480,18 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>  
>>  	/*
>>  	 * This function can be invoked while the power state is non-D0.
>> +	 * This non-D0 power state can be with or without runtime PM.
>> +	 * vfio_pci_runtime_pm_exit() will internally increment the usage
>> +	 * count corresponding to pm_runtime_put() called during low power
>> +	 * feature entry and then pm_runtime_resume() will wake up the device,
>> +	 * if the device has already gone into the suspended state. Otherwise,
>> +	 * the vfio_pci_set_power_state() will change the device power state
>> +	 * to D0.
>> +	 */
>> +	vfio_pci_runtime_pm_exit(vdev);
>> +	pm_runtime_resume(&pdev->dev);
>> +
>> +	/*
>>  	 * This function calls __pci_reset_function_locked() which internally
>>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
>>  	 * fail if the power state is non-D0. Also, for the devices which
>> @@ -1224,6 +1323,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>> +	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
>> +		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
>> +	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
>> +		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> @@ -1234,31 +1337,47 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>  			   size_t count, loff_t *ppos, bool iswrite)
>>  {
>>  	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	int ret;
>>  
>>  	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
>>  		return -EINVAL;
>>  
>> +	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
>> +	if (ret < 0) {
> 
> if (ret) {
> 
> Thanks,
> Alex
> 
 
 I will fix this.
 
 Thanks,
 Abhishek

>> +		pci_info_ratelimited(vdev->pdev, "runtime resume failed %d\n",
>> +				     ret);
>> +		return -EIO;
>> +	}
>> +
>>  	switch (index) {
>>  	case VFIO_PCI_CONFIG_REGION_INDEX:
>> -		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
>> +		ret = vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
>> +		break;
>>  
>>  	case VFIO_PCI_ROM_REGION_INDEX:
>>  		if (iswrite)
>> -			return -EINVAL;
>> -		return vfio_pci_bar_rw(vdev, buf, count, ppos, false);
>> +			ret = -EINVAL;
>> +		else
>> +			ret = vfio_pci_bar_rw(vdev, buf, count, ppos, false);
>> +		break;
>>  
>>  	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
>> -		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
>> +		ret = vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
>> +		break;
>>  
>>  	case VFIO_PCI_VGA_REGION_INDEX:
>> -		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
>> +		ret = vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
>> +		break;
>> +
>>  	default:
>>  		index -= VFIO_PCI_NUM_REGIONS;
>> -		return vdev->region[index].ops->rw(vdev, buf,
>> +		ret = vdev->region[index].ops->rw(vdev, buf,
>>  						   count, ppos, iswrite);
>> +		break;
>>  	}
>>  
>> -	return -EINVAL;
>> +	pm_runtime_put(&vdev->pdev->dev);
>> +	return ret;
>>  }
>>  
>>  ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>> @@ -1453,7 +1572,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>>  	mutex_lock(&vdev->vma_lock);
>>  	down_read(&vdev->memory_lock);
>>  
>> -	if (!__vfio_pci_memory_enabled(vdev)) {
>> +	/*
>> +	 * Memory region cannot be accessed if the low power feature is engaged
>> +	 * or memory access is disabled.
>> +	 */
>> +	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
>>  		ret = VM_FAULT_SIGBUS;
>>  		goto up_out;
>>  	}
>> @@ -2164,6 +2287,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
>> @@ -2219,6 +2351,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
>> index e96cc3081236..7ec81271bd05 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -125,6 +125,7 @@ struct vfio_pci_core_device {
>>  	bool			nointx;
>>  	bool			needs_pm_restore;
>>  	bool			pm_intx_masked;
>> +	bool			pm_runtime_engaged;
>>  	struct pci_saved_state	*pci_saved_state;
>>  	struct pci_saved_state	*pm_save;
>>  	int			ioeventfds_nr;
> 

