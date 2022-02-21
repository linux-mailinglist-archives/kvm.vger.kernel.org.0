Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708F74BD63D
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 07:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiBUGgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 01:36:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345240AbiBUGgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 01:36:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06E205E1;
        Sun, 20 Feb 2022 22:35:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbnpMAj91tFoF0v0ru7zT2aQrsbRNpQdoWWNPla7RjTQE4QvONrZcWgzq+GFJ4XfsgqFWhjRXoD/+imPOa17tzfnpoUzGVrQO970OPxGUk8hembMkjoqKI5gvqtymZeRi1tITTm1bPVFwC/trL6g1EN3sSCqYmA3NsuNDXV0dGNwxNLxUalBtsvJM5DAVNtqXki4O/l2bX5VqJCVZMuBZK823Os8zFYCjHpTDt9949XO3By42RGTYJBd/en/N61qezLfLQe/0fND4f0kfGC4PBjuYUC1KDX2kgPEPG1D4rFQhvOaWHa6hsUY3w9T3Ya1wgU5cAjaLxabhc6prkujVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ithRMvSwkSZ5UcL0sHvy+AHfhhj/4nZKDOP13Z5IiEE=;
 b=Ap5VhLgbpTsYsOKIZq3kIliq8J1i94nwzx9QpQfl6P8VvflUwH4YmafYeKQvFZJyCjAS4rtxh1C8r/4q33Wu1rXPkU2uEVF9iftjDNv/NACJh5jy49/iQ2V7ZZjFuoiLQY89v/EusMe70ykAZyqYK5aC83naPbtZKMajiySRxHTRxfTIDH6rDB4uR5N2OsPRKaFgIlIEGvAw8xOricojvj0hmAPmLf1r6q/kZDv2A837bpS63jkKga6B/rOPBT0Fccxh3uqNvilHNA2n9dPFEp2u7Jf/Q5ETHH6/fwLFEJC1eTdu80cxCUJuvXarZxi9JYt2j8iVcP6MtqupVL+OdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ithRMvSwkSZ5UcL0sHvy+AHfhhj/4nZKDOP13Z5IiEE=;
 b=fvwCigfDASMn58qQNowpYifZ+RWuyQado9Vrm8dER11I9DLBrz8TC+NdL5X2YKy0jf089gZh8QPSUBP12sDG+KruLbRWx+k9q1mCrEdKdoLL1B52TxmuvaZ2FJ2oQNV444PiqnjzKCgbK3CeZiD9k8aATKMNmPd/HS9+UM2JuaL1P6BaBzyXkmFSliMXYNnxOtN1XRVqaW4fltnoz8fGZQrZEEBMia7ShVwH9Ee7eG7Gv05HRdLqXBUAtmWRdW6InVfpCCQWf1xYl2dXf1mGHo+QRptvYBlTsUNtFHbcyCpcf65ELwasyzZg0zDSh+sctorsnO1S5FFTq949vOh4tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM5PR12MB2519.namprd12.prod.outlook.com (2603:10b6:4:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 06:35:37 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588%8]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 06:35:37 +0000
Message-ID: <b1609cc7-7f80-ee0e-aca4-1a7b0149e5af@nvidia.com>
Date:   Mon, 21 Feb 2022 12:05:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v2 1/5] vfio/pci: register vfio-pci driver with
 runtime PM framework
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-2-abhsahu@nvidia.com>
 <20220216164806.0d391821.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220216164806.0d391821.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::19) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59e168d2-7651-4ff8-a7e2-08d9f5045eef
X-MS-TrafficTypeDiagnostic: DM5PR12MB2519:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB25196B75AD2EF4F19D4C1EA8CC3A9@DM5PR12MB2519.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+RBedeF0x15p2eW+gzFG/0IUoA6jvpeEC6E22q1FB3JKmHn6aqiHeAy8W8Vrhi5MPH0RLfTX5SDMZGJQryji2WoyIdSrUYw6zq/BP+gMKBHxjpPIL3WaDmcXaQHVtnzlDUUUiAheZgxrA3bIqkIVliKSzysTCHjzlBhJvyvY1dPg8qlQAT+MN6yYFYDQLEKqelyXGEIDvWScw9IuOqPUoKUFxfeXeg/a2U9iV53u5ZhqJNweGbdDXR/aws5BrtM6oY5k+PSFdahPOOOwRuZIuJy7scbM9sasEo9sK4XaZKZPDWHDlZSDKIzmfYiOjlOr2RaRzgh7M2PF8iAAxNmfTYNSCZqRR62fTjuxtQBZm1eKqf/9BbHeQ5ZJzpZSinm1XZ9W4qOxsB3FGnx9dhhniPy/EgwbIF/0UMLpw50u4pkHgSLT4XnFvXRK7/zOVVeqD7nh1unzOa+k3weMWlVIfyNtYk89TXOjjWrcPfOeGwol2hv1O32erdgbPUmIgNwLZCjATkRcObAoHmoD5Kv9HTmW+FAO17EamQWscZxv7TB3BpPPtAmiaFc4wh5nsGRZwclH9nFja6ShWVTWsRU/AAUbfYL16jiRxVqrqCaRU+8qDokpaOekif9R04V3t75dTd4CVZx3hjy/jnN4YjPQUulyMBSHXUCsNRJviDNRtAq5o9nBegIcIhUcAY1TsA1WX3h/KQixR3GylAmkSI+SoY8K0w7qpRF/nlz8dcmfcVuCemgrJmUzK2wXkXsaAn/nP89ul3Ts6Sa5U+gYzj+TPz5hJ26EDznLIAdokV/4c6PpTXFLqMWvn1GLqjNowLzrlEy8INluQC1D8edyvTGWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(38100700002)(83380400001)(30864003)(36756003)(5660300002)(31686004)(2906002)(8936002)(66476007)(2616005)(6916009)(54906003)(8676002)(6486002)(6506007)(26005)(53546011)(55236004)(186003)(66946007)(66556008)(6512007)(6666004)(86362001)(508600001)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkZ1Wm5pM2EvSkZwK3V1QWp0elVTTlUrWFlaNjZ4WjNiQmlYSVJuRitvZGJ3?=
 =?utf-8?B?VGw5MDkzc0xoWVpJOWt0VXpLSUo5ZzJnZmZ6akluNjFPaHNQQ1JYamdyTm5v?=
 =?utf-8?B?elhOVC92c3lJS2NVOEM4Rm1DQjY3Mk1mUC9sZlhWalFsRytQRUtML09jRmtt?=
 =?utf-8?B?Skl3M2RablBMaGtudENqektaVjVrSFdkZVJ4SDhQamMzSmM1cFphOGlDbWRB?=
 =?utf-8?B?TXFWQnJjTnd0d05yZ1hIbk1yVjFNMklKWWcwWTQrekVYTXRnM2tzakVPUG0y?=
 =?utf-8?B?Y3NsMUl0OUMzZmNFOHo0b0dOTE5mZUtaMVY3ZkJJaGZITy9PbW50MW1qOGlq?=
 =?utf-8?B?VlNla2hScFU4NHZpdmc3MVE2UmtFV29VYzFxQTFQUTR4SFdzRkNUcEtSNzQx?=
 =?utf-8?B?c1FKNWJ2Y01nYTN0dDBRTGtpVGJIQnJabHRCS0l3RC9IblVhSHdkSGUzNlpr?=
 =?utf-8?B?ZTRWc0JMaU1LOFdjamQ3Vjh0aWg5ZTRMTG9aMkZnUGE5SzJubWdWRThmbWZa?=
 =?utf-8?B?Sm1NRThGUDNWWnNrSDFTRkRMQ1lQQTVrQVhuSFZncjErTXZ4V0JlRENDZnMx?=
 =?utf-8?B?NFZNSFZiSmtNakJmOXNmZTB1WC9scmtVcU9uWXhwRlZEdzNkaW5kd3g3MW1R?=
 =?utf-8?B?ZCsvMVI0aU96N3FhZjRFOGZyamZ1elZVSStMZDhwd2F2MGp4Tml3SDVGdy8y?=
 =?utf-8?B?WGhFVHZXakdFZFFPUU9sOTJXZ055dDVNZnBVZmRyMkpqVkpHZ3EwL2w4R05O?=
 =?utf-8?B?RWNnUUpNcTBPS3JJN2dSc0V6eUNWM3NObXdNaytRbmN0bVJtTWljOUFmY1ds?=
 =?utf-8?B?S2ZwOGRLMWNjbVp5VE1HbmJFdDRZYUpxQzBUMGxsRTFzL3JneWlDcU5SR2hk?=
 =?utf-8?B?cUlPd3lVVTFmWlF0c3BqREwyVG03RklXWTR6NkpPOTdGdStZWXV3dlJPM01j?=
 =?utf-8?B?SjdDYkltalhSbUFDRmRUQVFvMWplMDNqcEJ2RHo0QVRUK0Rveml3TEJ2endr?=
 =?utf-8?B?RW91RjcrY1l1R1NXSWNQS0NhU0NrelpGZjBRNUhyek8vdlZQazdWZnc3NXF4?=
 =?utf-8?B?K1lBc3ovcUxkY3UxL25pS1hOUk9jTEhxTXJQU2tnSGVVWTY0R3J3WGw5TGc2?=
 =?utf-8?B?ODcyS3M2dDAwTlQ4NnMxVy8rbFQ4UHV5MXFkUER1MTYxQThuNHloT0laOGk5?=
 =?utf-8?B?NDZma0pPUkF4QU10S3hFeWpXSXdrRS9FM1VUK2xWaHJhM2EvRkI3VlVMRkhs?=
 =?utf-8?B?THJBQWljdmhSZHQrVGpNenpXSkloYjBhWGZvTWFET2ZKZW1VRERMK0Z4TUU2?=
 =?utf-8?B?M1BlZysvQ3pLaG93eWhTZmltVUgwVXI5YlJWOFY5YjFqaG8vNWRBQ2h1bGZN?=
 =?utf-8?B?ZmFncGU4L0grSkNJSCswV1FyczAyZkVJZjRoUVJYU3dlVjE1bytuYU8xU3pn?=
 =?utf-8?B?ZVFrcHprQ1RCYnptc3F1VjVQaHI0cFJTTGRZUEJBTkVldmxZdVFEcG9NeENo?=
 =?utf-8?B?eFR4RmxEYWs0cUVIbzExaVp4ZVQzTEcrOFVvdWJSQTVtRVA5YmxSUEpkTFVR?=
 =?utf-8?B?MWFzV0owWkttdGsyd0FVaHZnV1l1L0hYdmJrMkl3dmp6dDF1MXVES05WWnlX?=
 =?utf-8?B?UHZTL2hrWWtMS3Z2T2VTSVZSSE1NYlFiOUhlZlZiY3BXQkh0cXh6UmNoR2dh?=
 =?utf-8?B?TnVNMWpnVzdQelJwK1hHTVFka29DbHI2TUdRUGhSUXRwUnAxZE4xYTJQRWV6?=
 =?utf-8?B?V1ZLaDZJZStXUUNyZzRhZHRiRkN0L0RUWWVmSG0wTEY0RmtaY21tTUIzQWdp?=
 =?utf-8?B?c2hFSmRMdnd5a1YwYkpnMG9laHdXcVR5UlE4a3lRWllJVFhHNjJRdTBxekJq?=
 =?utf-8?B?QWRNSDVTdzZIdmI5alQvblR4MGRDRjVWZWxUZXpDY3hZaDRXbWhRdjFGL251?=
 =?utf-8?B?ckZtWmF0QUZNeW9DemJpWmtRaXNFcVgrT3BuODc4dnI5djRoQkIxbkdLME51?=
 =?utf-8?B?WnlMaHdLM0JpVzdqZGV6bWlVZGZrOGljZDhzOGlGeDdVTWcveTFhSVNIa3Fo?=
 =?utf-8?B?VGtTYWRsVjlYUVZHQWphcmhNbE44eS9KUHBjRENaWjBpdExoc1dPVTNHV2xC?=
 =?utf-8?B?cWV1MzBqNkJ6VVhWbGdhWStCSTRrOWdRbzlidUpsSjRMNjZDWFpTczlmbldU?=
 =?utf-8?Q?2JbaSieph3cdYMsW3wWG0Cw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e168d2-7651-4ff8-a7e2-08d9f5045eef
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 06:35:37.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ilr5SOTs5TiXOtGbfLHmrV60s3XmLxQEym9uh5XXe8OeO5T4bPrglKlq1Lb1BSDA/Medent2QJ15Aa/YOjfP3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2519
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/2022 5:18 AM, Alex Williamson wrote:
> On Mon, 24 Jan 2022 23:47:22 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, there is very limited power management support
>> available in the upstream vfio-pci driver. If there is no user of vfio-pci
>> device, then the PCI device will be moved into D3Hot state by writing
>> directly into PCI PM registers. This D3Hot state help in saving power
>> but we can achieve zero power consumption if we go into the D3cold state.
>> The D3cold state cannot be possible with native PCI PM. It requires
>> interaction with platform firmware which is system-specific.
>> To go into low power states (including D3cold), the runtime PM framework
>> can be used which internally interacts with PCI and platform firmware and
>> puts the device into the lowest possible D-States.
>>
>> This patch registers vfio-pci driver with the runtime PM framework.
>>
>> 1. The PCI core framework takes care of most of the runtime PM
>>    related things. For enabling the runtime PM, the PCI driver needs to
>>    decrement the usage count and needs to register the runtime
>>    suspend/resume callbacks. For vfio-pci based driver, these callback
>>    routines can be stubbed in this patch since the vfio-pci driver
>>    is not doing the PCI device initialization. All the config state
>>    saving, and PCI power management related things will be done by
>>    PCI core framework itself inside its runtime suspend/resume callbacks.
>>
>> 2. Inside pci_reset_bus(), all the devices in bus/slot will be moved
>>    out of D0 state. This state change to D0 can happen directly without
>>    going through the runtime PM framework. So if runtime PM is enabled,
>>    then pm_runtime_resume() makes the runtime state active. Since the PCI
>>    device power state is already D0, so it should return early when it
>>    tries to change the state with pci_set_power_state(). Then
>>    pm_request_idle() can be used which will internally check for
>>    device usage count and will move the device again into the low power
>>    state.
>>
>> 3. Inside vfio_pci_core_disable(), the device usage count always needs
>>    to be decremented which was incremented in vfio_pci_core_enable().
>>
>> 4. Since the runtime PM framework will provide the same functionality,
>>    so directly writing into PCI PM config register can be replaced with
>>    the use of runtime PM routines. Also, the use of runtime PM can help
>>    us in more power saving.
>>
>>    In the systems which do not support D3Cold,
>>
>>    With the existing implementation:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3hot
>>
>>    So, with runtime PM, the upstream bridge or root port will also go
>>    into lower power state which is not possible with existing
>>    implementation.
>>
>>    In the systems which support D3Cold,
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3cold
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3cold
>>
>>    So, with runtime PM, both the PCI device and upstream bridge will
>>    go into D3cold state.
>>
>> 5. If 'disable_idle_d3' module parameter is set, then also the runtime
>>    PM will be enabled, but in this case, the usage count should not be
>>    decremented.
>>
>> 6. vfio_pci_dev_set_try_reset() return value is unused now, so this
>>    function return type can be changed to void.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c      |  3 +
>>  drivers/vfio/pci/vfio_pci_core.c | 95 +++++++++++++++++++++++---------
>>  include/linux/vfio_pci_core.h    |  4 ++
>>  3 files changed, 75 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index a5ce92beb655..c8695baf3b54 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -193,6 +193,9 @@ static struct pci_driver vfio_pci_driver = {
>>       .remove                 = vfio_pci_remove,
>>       .sriov_configure        = vfio_pci_sriov_configure,
>>       .err_handler            = &vfio_pci_core_err_handlers,
>> +#if defined(CONFIG_PM)
>> +     .driver.pm              = &vfio_pci_core_pm_ops,
>> +#endif
>>  };
>>
>>  static void __init vfio_pci_fill_ids(void)
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index f948e6cd2993..c6e4fe9088c3 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -152,7 +152,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>>  }
>>
>>  struct vfio_pci_group_info;
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                     struct vfio_pci_group_info *groups);
>>
>> @@ -245,7 +245,11 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>       u16 cmd;
>>       u8 msix_pos;
>>
>> -     vfio_pci_set_power_state(vdev, PCI_D0);
>> +     if (!disable_idle_d3) {
>> +             ret = pm_runtime_resume_and_get(&pdev->dev);
>> +             if (ret < 0)
>> +                     return ret;
>> +     }
> 
> Sorry for the delay in review, I'm a novice in pm runtime, but I
> haven't forgotten about the remainder of this series.
> 

 Thanks Alex.
 Should I include linux-pm@vger.kernel.org while sending the updated
 version. I got following comment in my different patch related
 with PCI PM
 (https://lore.kernel.org/lkml/20220204233219.GA228585@bhelgaas/T/#me17cb6e1aa3848cfd4ea577a3c93ebbbfdbf7c73)

 "generally PM patches should be CCed to linux-pm anyway"


> I think we're removing the unconditional wake here because we now wake
> the device in the core registration function below, but I think there
> might be a subtle dependency here on the fix to always wake devices in
> the disable function as well, otherwise I'm afraid the power state of a
> device released in D3hot could leak to the next user here.
> 

 Yes. We need to consider the fix. 
 Either we can add the state restore handling logic inside
 vfio_pci_core_runtime_resume() or we can keep restore the state
 alone here explictly. For runtime PM, we need to call
 pm_runtime_resume_and_get() first since root port should be moved
 to D0 first. 

>>
>>       /* Don't allow our initial saved state to include busmaster */
>>       pci_clear_master(pdev);
>> @@ -405,8 +409,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>  out:
>>       pci_disable_device(pdev);
>>
>> -     if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D3hot);
>> +     vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
>> +
>> +     /* Put the pm-runtime usage counter acquired during enable */
>> +     if (!disable_idle_d3)
>> +             pm_runtime_put(&pdev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>>
>> @@ -1847,19 +1854,20 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>
>>       vfio_pci_probe_power_state(vdev);
>>
>> -     if (!disable_idle_d3) {
>> -             /*
>> -              * pci-core sets the device power state to an unknown value at
>> -              * bootup and after being removed from a driver.  The only
>> -              * transition it allows from this unknown state is to D0, which
>> -              * typically happens when a driver calls pci_enable_device().
>> -              * We're not ready to enable the device yet, but we do want to
>> -              * be able to get to D3.  Therefore first do a D0 transition
>> -              * before going to D3.
>> -              */
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> -             vfio_pci_set_power_state(vdev, PCI_D3hot);
>> -     }
>> +     /*
>> +      * pci-core sets the device power state to an unknown value at
>> +      * bootup and after being removed from a driver.  The only
>> +      * transition it allows from this unknown state is to D0, which
>> +      * typically happens when a driver calls pci_enable_device().
>> +      * We're not ready to enable the device yet, but we do want to
>> +      * be able to get to D3.  Therefore first do a D0 transition
>> +      * before enabling runtime PM.
>> +      */
>> +     vfio_pci_set_power_state(vdev, PCI_D0);
>> +     pm_runtime_allow(&pdev->dev);
>> +
>> +     if (!disable_idle_d3)
>> +             pm_runtime_put(&pdev->dev);
> 
> I could use some enlightenment here.  pm_runtime_allow() only does
> something if power.runtime_allow is false, in which case it sets that
> value to true and decrements power.usage_count.  runtime_allow is
> enabled by default in pm_runtime_init(), but pci_pm_init() calls
> pm_runtime_forbid() which does the reverse of pm_runtime_allow().  So
> do I understand correctly that PCI devices are probed with
> runtime_allow = false and a usage_count of 2?
> 

 Following is the flow w.r.t. usage_count and runtime_allow.

 In pci_pm_init(), the default usage_count=0 and runtime_allow=true initially.
 pm_runtime_forbid() in pci_pm_init() makes usage_count=1 and runtime_allow=false

 Then, inside local_pci_probe(), pm_runtime_get_sync() is called,
 After this, the usage_count=2 and runtime_allow=false

 So, you are correct that the PCI devices are probed with
 runtime_allow=false and usage_count=2.

 In the driver, 

 pm_runtime_allow() is for doing the reverse of pm_runtime_forbid().
 and pm_runtime_put() is for doing the reverse of pm_runtime_get_sync().
 
>>
>>       ret = vfio_register_group_dev(&vdev->vdev);
>>       if (ret)
>> @@ -1868,7 +1876,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>
>>  out_power:
>>       if (!disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> +             pm_runtime_get_noresume(&pdev->dev);
>> +
>> +     pm_runtime_forbid(&pdev->dev);
>>  out_vf:
>>       vfio_pci_vf_uninit(vdev);
>>       return ret;
>> @@ -1887,7 +1897,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>>       vfio_pci_vga_uninit(vdev);
>>
>>       if (!disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> +             pm_runtime_get_noresume(&pdev->dev);
>> +
>> +     pm_runtime_forbid(&pdev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>>
>> @@ -2093,33 +2105,62 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
>>   *  - At least one of the affected devices is marked dirty via
>>   *    needs_reset (such as by lack of FLR support)
>>   * Then attempt to perform that bus or slot reset.
>> - * Returns true if the dev_set was reset.
>>   */
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>  {
>>       struct vfio_pci_core_device *cur;
>>       struct pci_dev *pdev;
>>       int ret;
>>
>>       if (!vfio_pci_dev_set_needs_reset(dev_set))
>> -             return false;
>> +             return;
>>
>>       pdev = vfio_pci_dev_set_resettable(dev_set);
>>       if (!pdev)
>> -             return false;
>> +             return;
>>
>>       ret = pci_reset_bus(pdev);
>>       if (ret)
>> -             return false;
>> +             return;
>>
>>       list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>>               cur->needs_reset = false;
>> -             if (!disable_idle_d3)
>> -                     vfio_pci_set_power_state(cur, PCI_D3hot);
>> +             if (!disable_idle_d3) {
>> +                     /*
>> +                      * Inside pci_reset_bus(), all the devices in bus/slot
>> +                      * will be moved out of D0 state. This state change to
> 
> s/out of/into/?
> 

 Yes. I will fix this. 

>> +                      * D0 can happen directly without going through the
>> +                      * runtime PM framework. pm_runtime_resume() will
>> +                      * help make the runtime state as active and then
>> +                      * pm_request_idle() can be used which will
>> +                      * internally check for device usage count and will
>> +                      * move the device again into the low power state.
>> +                      */
>> +                     pm_runtime_resume(&pdev->dev);
>> +                     pm_request_idle(&pdev->dev);
>> +             }
>>       }
>> -     return true;
>>  }
>>
>> +#ifdef CONFIG_PM
>> +static int vfio_pci_core_runtime_suspend(struct device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int vfio_pci_core_runtime_resume(struct device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +const struct dev_pm_ops vfio_pci_core_pm_ops = {
>> +     SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
>> +                        vfio_pci_core_runtime_resume,
>> +                        NULL)
>> +};
>> +EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);
>> +#endif
> 
> It looks like the vfio_pci_core_pm_ops implementation should all be
> moved to where we implement D3cold support, it's not necessary to
> implement stubs for any of the functionality of this patch.  Thanks,
> 

 We need to provide dev_pm_ops atleast to make runtime PM working.
 In pci_pm_runtime_idle() generic function:

 const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 if (!pm)
    return -ENOSYS;

 Without dev_pm_ops, the idle routine will return ENOSYS error.

 vfio_pci_core_runtime_{suspend/resume}() stub implementation can be removed
 but we need to provide stub vfio_pci_core_pm_ops atleast.

 const struct dev_pm_ops vfio_pci_core_pm_ops = { };
 EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);

 Thanks,
 Abhishek 
 
> Alex
> 
>> +
>>  void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
>>                             bool is_disable_idle_d3)
>>  {
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index ef9a44b6cf5d..aafe09c9fa64 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -231,6 +231,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
>>
>> +#ifdef CONFIG_PM
>> +extern const struct dev_pm_ops vfio_pci_core_pm_ops;
>> +#endif
>> +
>>  static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>>  {
>>       return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
> 

