Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03994D64D6
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347785AbiCKPq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiCKPq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:46:57 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F431B0BDF;
        Fri, 11 Mar 2022 07:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrA63ykizUgGCR6RGbcschPdVGbYFUY9jSPkVDS0Zga5oXcIl9EBtF/7+ypK+OoN/+S29JkQDnH+kvXsqqI1jnGfddNlTQLD7JwbrurzKxdldIF5TfUCm6nC1RUKQCBvtfGe8Q0HVaCzhdteAvC5+v45cKTYdFlGO+qz2ngrS99KAWtEPsQMbJ2zoAoBGxiqtSNC+k4CNfzLBjq0irAdCnc5UjnIf471b7ZPjV0Llo2pFRogI319nAdJzU/9HJZqS7GFbaYvWLP3hayDut8mKwXibfe2k1Bmt+YavUquRXQ9MXS8mKs2HpEfLqoPC0jJyeYDHH50WR7Cw/7AGx1Mrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CC/3mLt9nsm3zkxjB/Rph6xY31jTWuAvHvYHT6Sgy4=;
 b=SRfU3d72r9Lq5dLL1W+9SVhDBdyi0xqdtsQQ4/3y5yaep36XDWuRKxQgU6SdT2yaENs0yxPqOjkYFHlFTBGMrXvYWkRHE26By3l/4ecLHi/eU0yP6TZxFbzeO6hoXpaXTFwUcS86ia6ZAYWLKXnM34axbimZ8V8BvWmqxxniGxtARRHlc62joZUIXngmA0fZG/PjWT5DEQ4J9RYQl5gwyvpY/Cpw9rbMJoGvLdDhFt2MKZraOuU0tfzmVNv/dBvBCXEGj5DbFtUT5V/VAAS98VENuip/rHLjkzdz/Shh97GKKDZgW288z23cPhpmkJeAZNsS5Ynk6pLnDfIrgfxsUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CC/3mLt9nsm3zkxjB/Rph6xY31jTWuAvHvYHT6Sgy4=;
 b=jDJgsyRcvcjjS2Pe7bruRDjUXtwBwY4s8ICjah1LeTfT8f9ZuhorNYRYAFI85E2KBxd9SJuV5tA7Yl5aARcwVpny7htJpDIPkN1bhTzGEeJvSqto1kb+L1AJbiz+LVdb6WSM9mZJQwUst0pf/WDNnnWYGGwpQ2MXDwXgqwT1LOpFPBaUYc6cEnbCMvfxNJPNMwiRZicUBfJiJvsahP6M3X0t06uK13mbvc5+WZM5U68oS6WNmHkz5nq52w79vfgIo37zR61Ymn5xHY5FgQ+7PrPTkEj0iGjFPCIFzjUHYcoNNe5teqjPnWvahY2ERf+I7fANqvO7+WinziCjgcJo/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Fri, 11 Mar
 2022 15:45:50 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b%6]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 15:45:50 +0000
Message-ID: <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
Date:   Fri, 11 Mar 2022 21:15:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-6-abhsahu@nvidia.com>
 <20220309102642.251aff25.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220309102642.251aff25.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::6) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac4db6a-ab5b-4ea2-0612-08da0376373e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5047:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB504746335E96F81F52D67514CC0C9@BL1PR12MB5047.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUM8/ATAZSgqlTsuzT+SmXjRqo1U1pQ2XtZ0yo8FHPK+bL+ZHGxzlFjaqoqtCX4Wzz+mtXWul/RE9iQF8frA/cGNL6+5lEKZflyAxUQ9yOpR9XV8jBaFYChgvlO70jdX6WMyw2/iumOwO29XeBgdDzAS0u1VatskrDUtLM3rMhh2DJJzlNrv47ghP/p0dGFOBd1/ulSHptDEiC0R2RiyD3p6nxAOF6gmcC+nlemELwDv/EeG8jouD8GfrfsdpH85FcAIyJYF9soIu5TfBjvEgLDggphlfx1e+6+ieBbgBKrvgy2VwOObcnOwxbbEYyrir5CAqLGHbOoxjYptc5r5cX7g10QYzNt/ShxfdDt0cQT1dhPojkkMEVF1TQyCx9zmHGKFwzSaXEjEFojxTtwDTCLPfXjAQk3igkvAhenpPFgCTKvReQYD85ZX7kRPqacJf2TTAtagpH+zrlntl7TUwusk8PFYbvTbxgzK/3bLiKoPj5aeNMY58D/VS3UfEQKpj/SlBi4KuK+OpY384kAE4p/GSkNMPWAp+PGGjocX0ML45Wl5TPwI/ujaGP06USmgrcAoJe+9/M4zhGkL3E4j2oEssnlG8WzfJ1YmYFGR6ayrvql3ZQrIM4uxufpzQqpPpAWm/tCasN+dYP6VY1ciZIbYG5C4kYj/ut60atuSgcDlqcwSpkyXIRNmqsr2TNwgmLqJPrR6s38AcWEl+iN9ssG7mGijVSm71zFHXY1CaWxZw9OIPAhSiCkRrzQJENKOtwLvqArDYFWsm7Rc3T4LlOTCB6YErn033bQMmoyTP26sfslJhc5liDsjVCR4SYuaO3lk+k2+2dcgF4NA/0nchDp9Gi937K/4Yy5/7+R5SP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(2906002)(6512007)(508600001)(66946007)(6486002)(966005)(4326008)(8676002)(30864003)(26005)(6506007)(53546011)(83380400001)(186003)(55236004)(5660300002)(6666004)(8936002)(66556008)(66476007)(6916009)(86362001)(31696002)(54906003)(31686004)(38100700002)(36756003)(316002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUh1WTd4dExXUnVwbEIrODRjM1N2MGNrcHBOVGZOUVl2TjJjNDIrQ2JIaVpD?=
 =?utf-8?B?c201ZXIwSHhwTXQ1bzYwaEVDUXR6RWtFeXU2dDM0dVZJVlRnZVYwaUxSL0h0?=
 =?utf-8?B?U04zQWttekZxUWdtYmM1a2ZpRFJvcit5YTg2VitXeEUxck0zZUdqbXNYUS8y?=
 =?utf-8?B?TVFGaTRpTFYyYTZLMk5sbUZzUkFCMFdJMVhBQ05BbnRFUGl2eWRVMWZ1SU83?=
 =?utf-8?B?dUVMcFVOaVA1Z0V2K2JZWkxLNlhhc2srWktmOVJsYkI2c0hBdks4bUlIZkpq?=
 =?utf-8?B?czlKNDdGdVZvdm9Mc3JSdEdhcFVSSzNDZEd5czdnT0N1RnR1TGhMYmdidWxX?=
 =?utf-8?B?KzVQMHludDVYWGp2NXNnZlBTVjJnMGhzUGQ2V0lMbEtsZC96enpPb0JqTzVk?=
 =?utf-8?B?N2k2dUNCRVRHZjg1bW5oK0htb3ZQdjh4UHNkRkd5QTdzenZQNU1lbmk1aHpF?=
 =?utf-8?B?Z1FER1lDUDZmcGpYVFh6eXUrZXRBV0JjZzE2NDc3K2tWcDk5QXBBZU41M1FI?=
 =?utf-8?B?akVuQXNIZmkzcjJHWFJMRGZXMEo2THU2dDBKcjAvUVlwb1FIWVNSQXJneWFo?=
 =?utf-8?B?U29rUk1xRHM1Umd3c0sxMllZUUhiM2dPRldhSVFVNlpneUhjcW1ZckxDL0F6?=
 =?utf-8?B?S2xBbHRtM3I2RFV4Q090eWVyTFlqdUNHb0M4TTRHYWxjWDlHTVZjSHFzUG5D?=
 =?utf-8?B?TXN5Y1Q2MklhaVl0M0tVWXRIRVQ0Wk1yTVlhTTlmWERPM212RlRxQTJwRG4z?=
 =?utf-8?B?a0QyME9FTVJtaklMTUl3SW9VZmNTa3ZPMUR0Y0ZoYXc4UDZFOThuVWZNSHdz?=
 =?utf-8?B?Z241VzRTRFRwKzRzV2UrWmFEQTJZVmk1K0gvUUY1VmJWRHNwckliUzlZS013?=
 =?utf-8?B?RlZ3QU15ODREMW9vVFRET0d5QUVCaXV4N0xsY0Vsd2RXZGluMG5wc3JRaEdi?=
 =?utf-8?B?TzFhazRSQ20xTnRLLzVGOExJbUxDcXNBZmNtMnpWZXJGTUYxRVZEMW1HYXUw?=
 =?utf-8?B?eG1wVUhmSE1yMnkrc24wMWxST1lBai9NWmtjNUE5ZkZHS3p4Y2JNMmJIWk5l?=
 =?utf-8?B?aUsvakFSNUR4Y1VvVG1aTnZIaUtaQUV2QlcvYnRuTENOUkE4WDVlQUVGYXBB?=
 =?utf-8?B?SEhtUW1FVE5USktMYmpPa1hFM3hKS3RKc3NUaW1YYlFXNFlTU1VwS1Z4RjV6?=
 =?utf-8?B?dHFtdkh2cWkweFlFcnR5N2NSNmJaeVRxSTJnbi9teVZ6bXQ4VEdOZW1CbHgw?=
 =?utf-8?B?Y3g5VndFaU45UHJnQmVJSjZCNjA5S2w1cGdqK0Nic3N1Ync4S2RDUjV4dnZk?=
 =?utf-8?B?N1JUN3ZLcjc2d2hvaEhuN01IQWFqS1BTMWtUN2FzZWp2WVVUVHo2dHhia3du?=
 =?utf-8?B?UW5FTU9ybW9aNjl0WEhnM3hVamlFMkhYdU43MzE2alA0OXFCeVhMdEFnZEpL?=
 =?utf-8?B?NEZ3L3RpS3lDZWxXRTBZRFp4L2UwRnRYc3ZocUNkdithSSsyMnFiRWRGQ2w0?=
 =?utf-8?B?OHJQYWtmaExYdjhBT1NKN3lYTmh4RWx4eW81bHVWQ291aWFMSWh1eFZia1ZH?=
 =?utf-8?B?SGsreGRvUVJnUUtFUUc3UEYvZ0hXZVl1V3lLQlVhU09ZL1lvR2F2OEJuUmpG?=
 =?utf-8?B?UFdrK0xaSFkzTTB1ZTQzMFEwOXRkcnhZaWZkUzNrKzFVVG1VS0NpdVJyMitq?=
 =?utf-8?B?V1krTEpFaTkvQXVlaTF0d0JhOXNYUk9IMHpnZVQ4Uzg5dnFYTEdLWjRFY21j?=
 =?utf-8?B?MmlXMW0zOS9GMGlSbXpDSkhNemQzc1lLRWxZbDNxNERPbS9JelFJV3pGS09o?=
 =?utf-8?B?SDNqemFQT3RzYU5uMENwV0xualNEdGsvVmNKbVZlMUJ2VmlqRE1mcTQ5SDVq?=
 =?utf-8?B?aWdOMFQ5Z0JuR1UrZ1hVbDlVWml5RHYvdmFVQ09MNFZkTFNseWovd2I5THFU?=
 =?utf-8?Q?wCjG8iqJOSubIwKDXZqjo5URBKgkWJsg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac4db6a-ab5b-4ea2-0612-08da0376373e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 15:45:49.9962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erci4MdPmwVNOpRBgbMvSPR92z/8kli7iL/nSk0/ImPUamPonmAowbKG5/cOPVF/v/2XD4qTZ5qQ536uPACI3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/2022 10:56 PM, Alex Williamson wrote:
> On Mon, 24 Jan 2022 23:47:26 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, if the runtime power management is enabled for vfio-pci
>> device in the guest OS, then guest OS will do the register write for
>> PCI_PM_CTRL register. This write request will be handled in
>> vfio_pm_config_write() where it will do the actual register write
>> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
>> achieved for low power. If we can use the runtime PM framework,
>> then we can achieve the D3cold state which will help in saving
>> maximum power.
>>
>> 1. Since D3cold state can't be achieved by writing PCI standard
>>    PM config registers, so this patch adds a new IOCTL which change the
>>    PCI device from D3hot to D3cold state and then D3cold to D0 state.
>>
>> 2. The hypervisors can implement virtual ACPI methods. For
>>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>>    power resources with _ON/_OFF method, then guest linux OS makes the
>>    _OFF call during D3cold transition and then _ON during D0 transition.
>>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>>    related IOCTL in the vfio driver.
>>
>> 3. The vfio driver uses runtime PM framework to achieve the
>>    D3cold state. For the D3cold transition, decrement the usage count and
>>    during D0 transition increment the usage count.
>>
>> 4. For D3cold, the device current power state should be D3hot.
>>    Then during runtime suspend, the pci_platform_power_transition() is
>>    required for D3cold state. If the D3cold state is not supported, then
>>    the device will still be in D3hot state. But with the runtime PM, the
>>    root port can now also go into suspended state.
>>
>> 5. For most of the systems, the D3cold is supported at the root
>>    port level. So, when root port will transition to D3cold state, then
>>    the vfio PCI device will go from D3hot to D3cold state during its
>>    runtime suspend. If root port does not support D3cold, then the root
>>    will go into D3hot state.
>>
>> 6. The runtime suspend callback can now happen for 2 cases: there
>>    is no user of vfio device and the case where user has initiated
>>    D3cold. The 'runtime_suspend_pending' flag can help to distinguish
>>    this case.
>>
>> 7. There are cases where guest has put PCI device into D3cold
>>    state and then on the host side, user has run lspci or any other
>>    command which requires access of the PCI config register. In this case,
>>    the kernel runtime PM framework will resume the PCI device internally,
>>    read the config space and put the device into D3cold state again. Some
>>    PCI device needs the SW involvement before going into D3cold state.
>>    For the first D3cold state, the driver running in guest side does the SW
>>    side steps. But the second D3cold transition will be without guest
>>    driver involvement. So, prevent this second d3cold transition by
>>    incrementing the device usage count. This will make the device
>>    unnecessary in D0 but it's better than failure. In future, we can some
>>    mechanism by which we can forward these wake-up request to guest and
>>    then the mentioned case can be handled also.
>>
>> 8. In D3cold, all kind of BAR related access needs to be disabled
>>    like D3hot. Additionally, the config space will also be disabled in
>>    D3cold state. To prevent access of config space in the D3cold state,
>>    increment the runtime PM usage count before doing any config space
>>    access. Also, most of the IOCTLs do the config space access, so
>>    maintain one safe list and skip the resume only for these safe IOCTLs
>>    alone. For other IOCTLs, the runtime PM usage count will be
>>    incremented first.
>>
>> 9. Now, runtime suspend/resume callbacks need to get the vdev
>>    reference which can be obtained by dev_get_drvdata(). Currently, the
>>    dev_set_drvdata() is being set after returning from
>>    vfio_pci_core_register_device(). The runtime callbacks can come
>>    anytime after enabling runtime PM so dev_set_drvdata() must happen
>>    before that. We can move dev_set_drvdata() inside
>>    vfio_pci_core_register_device() itself.
>>
>> 10. The vfio device user can close the device after putting
>>     the device into runtime suspended state so inside
>>     vfio_pci_core_disable(), increment the runtime PM usage count.
>>
>> 11. Runtime PM will be possible only if CONFIG_PM is enabled on
>>     the host. So, the IOCTL related code can be put under CONFIG_PM
>>     Kconfig.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c        |   1 -
>>  drivers/vfio/pci/vfio_pci_config.c |  11 +-
>>  drivers/vfio/pci/vfio_pci_core.c   | 186 +++++++++++++++++++++++++++--
>>  include/linux/vfio_pci_core.h      |   1 +
>>  include/uapi/linux/vfio.h          |  21 ++++
>>  5 files changed, 211 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index c8695baf3b54..4ac3338c8fc7 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>       ret = vfio_pci_core_register_device(vdev);
>>       if (ret)
>>               goto out_free;
>> -     dev_set_drvdata(&pdev->dev, vdev);
> 
> Relocating the setting of drvdata should be proposed separately rather
> than buried in this patch.  The driver owns drvdata, the driver is the
> only consumer of drvdata, so pushing this into the core to impose a
> standard for drvdata across all vfio-pci variants doesn't seem like a
> good idea to me.
> 
 
 I will check regarding this part.
 Mainly drvdata is needed for the runtime PM callbacks which are added
 inside core layer and we need to get vdev from struct device.

>>       return 0;
>>
>>  out_free:
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index dd9ed211ba6f..d20420657959 100644
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
>> @@ -1919,16 +1920,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>                          size_t count, loff_t *ppos, bool iswrite)
>>  {
>> +     struct device *dev = &vdev->pdev->dev;
>>       size_t done = 0;
>>       int ret = 0;
>>       loff_t pos = *ppos;
>>
>>       pos &= VFIO_PCI_OFFSET_MASK;
>>
>> +     ret = pm_runtime_resume_and_get(dev);
>> +     if (ret < 0)
>> +             return ret;
>> +
>>       while (count) {
>>               ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
>> -             if (ret < 0)
>> +             if (ret < 0) {
>> +                     pm_runtime_put(dev);
>>                       return ret;
>> +             }
>>
>>               count -= ret;
>>               done += ret;
>> @@ -1936,6 +1944,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>               pos += ret;
>>       }
>>
>> +     pm_runtime_put(dev);
> 
> What about other config accesses, ex. shared INTx?  We need to
> interact with the device command and status register on an incoming
> interrupt to test if our device sent an interrupt and to mask it.  The
> unmask eventfd can also trigger config space accesses.  Seems
> incomplete relative to config space.
> 

 I will check this path thoroughly.
 But from initial analysis, it seems we have 2 path here:

 Most of the mentioned functions are being called from
 vfio_pci_set_irqs_ioctl() and pm_runtime_resume_and_get()
 should be called for this ioctl also in this patch.

 Second path is when we are inside IRQ handler. For that, we need some
 other mechanism which I explained below.
 
>>       *ppos += done;
>>
>>       return done;
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 38440d48973f..b70bb4fd940d 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -371,12 +371,23 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
>>
>>       /*
>> -      * If disable has been called while the power state is other than D0,
>> -      * then set the power state in vfio driver to D0. It will help
>> -      * in running the logic needed for D0 power state. The subsequent
>> -      * runtime PM API's will put the device into the low power state again.
>> +      * The vfio device user can close the device after putting the device
>> +      * into runtime suspended state so wake up the device first in
>> +      * this case.
>>        */
>> -     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>> +     if (vdev->runtime_suspend_pending) {
>> +             vdev->runtime_suspend_pending = false;
>> +             pm_runtime_resume_and_get(&pdev->dev);
> 
> Doesn't vdev->power_state become unsynchronized from the actual device
> state here and maybe elsewhere in this patch?  (I see below that maybe
> the resume handler accounts for this)
> 

 Yes. Inside runtime resume handler, it is being changed back to D0.

>> +     } else {
>> +             /*
>> +              * If disable has been called while the power state is other
>> +              * than D0, then set the power state in vfio driver to D0. It
>> +              * will help in running the logic needed for D0 power state.
>> +              * The subsequent runtime PM API's will put the device into
>> +              * the low power state again.
>> +              */
>> +             vfio_pci_set_power_state_locked(vdev, PCI_D0);
>> +     }
>>
>>       /* Stop the device from further DMA */
>>       pci_clear_master(pdev);
>> @@ -693,8 +704,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
>>
>> -long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>> -             unsigned long arg)
>> +static long vfio_pci_core_ioctl_internal(struct vfio_device *core_vdev,
>> +                                      unsigned int cmd, unsigned long arg)
>>  {
>>       struct vfio_pci_core_device *vdev =
>>               container_of(core_vdev, struct vfio_pci_core_device, vdev);
>> @@ -1241,10 +1252,119 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>               default:
>>                       return -ENOTTY;
>>               }
>> +#ifdef CONFIG_PM
>> +     } else if (cmd == VFIO_DEVICE_POWER_MANAGEMENT) {
> 
> I'd suggest using a DEVICE_FEATURE ioctl for this.  This ioctl doesn't
> follow the vfio standard of argsz/flags and doesn't seem to do anything
> special that we couldn't achieve with a DEVICE_FEATURE ioctl.
> 

 Sure. DEVICE_FEATURE can help for this.

>> +             struct vfio_power_management vfio_pm;
>> +             struct pci_dev *pdev = vdev->pdev;
>> +             bool request_idle = false, request_resume = false;
>> +             int ret = 0;
>> +
>> +             if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
>> +                     return -EFAULT;
>> +
>> +             /*
>> +              * The vdev power related fields are protected with memory_lock
>> +              * semaphore.
>> +              */
>> +             down_write(&vdev->memory_lock);
>> +             switch (vfio_pm.d3cold_state) {
>> +             case VFIO_DEVICE_D3COLD_STATE_ENTER:
>> +                     /*
>> +                      * For D3cold, the device should already in D3hot
>> +                      * state.
>> +                      */
>> +                     if (vdev->power_state < PCI_D3hot) {
>> +                             ret = EINVAL;
>> +                             break;
>> +                     }
>> +
>> +                     if (!vdev->runtime_suspend_pending) {
>> +                             vdev->runtime_suspend_pending = true;
>> +                             pm_runtime_put_noidle(&pdev->dev);
>> +                             request_idle = true;
>> +                     }
> 
> If I call this multiple times, runtime_suspend_pending prevents it from
> doing anything, but what should the return value be in that case?  Same
> question for exit.
> 

 For entry, the user should not call moving the device to D3cold, if it has
 already requested. So, we can return error in this case. For exit,
 currently, in this patch, I am clearing runtime_suspend_pending if the
 wake-up is triggered from the host side (with lspci or some other command).
 In that case, the exit should not return error. Should we add code to 
 detect multiple calling of these and ensure only one
 VFIO_DEVICE_D3COLD_STATE_ENTER/VFIO_DEVICE_D3COLD_STATE_EXIT can be called.

>> +
>> +                     break;
>> +
>> +             case VFIO_DEVICE_D3COLD_STATE_EXIT:
>> +                     /*
>> +                      * If the runtime resume has already been run, then
>> +                      * the device will be already in D0 state.
>> +                      */
>> +                     if (vdev->runtime_suspend_pending) {
>> +                             vdev->runtime_suspend_pending = false;
>> +                             pm_runtime_get_noresume(&pdev->dev);
>> +                             request_resume = true;
>> +                     }
>> +
>> +                     break;
>> +
>> +             default:
>> +                     ret = EINVAL;
>> +                     break;
>> +             }
>> +
>> +             up_write(&vdev->memory_lock);
>> +
>> +             /*
>> +              * Call the runtime PM API's without any lock. Inside vfio driver
>> +              * runtime suspend/resume, the locks can be acquired again.
>> +              */
>> +             if (request_idle)
>> +                     pm_request_idle(&pdev->dev);
>> +
>> +             if (request_resume)
>> +                     pm_runtime_resume(&pdev->dev);
>> +
>> +             return ret;
>> +#endif
>>       }
>>
>>       return -ENOTTY;
>>  }
>> +
>> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>> +                      unsigned long arg)
>> +{
>> +#ifdef CONFIG_PM
>> +     struct vfio_pci_core_device *vdev =
>> +             container_of(core_vdev, struct vfio_pci_core_device, vdev);
>> +     struct device *dev = &vdev->pdev->dev;
>> +     bool skip_runtime_resume = false;
>> +     long ret;
>> +
>> +     /*
>> +      * The list of commands which are safe to execute when the PCI device
>> +      * is in D3cold state. In D3cold state, the PCI config or any other IO
>> +      * access won't work.
>> +      */
>> +     switch (cmd) {
>> +     case VFIO_DEVICE_POWER_MANAGEMENT:
>> +     case VFIO_DEVICE_GET_INFO:
>> +     case VFIO_DEVICE_FEATURE:
>> +             skip_runtime_resume = true;
>> +             break;
> 
> How can we know that there won't be DEVICE_FEATURE calls that touch the
> device, the recently added migration via DEVICE_FEATURE does already.
> DEVICE_GET_INFO seems equally as prone to breaking via capabilities
> that could touch the device.  It seems easier to maintain and more
> consistent to the user interface if we simply define that any device
> access will resume the device.

 In that case, we can resume the device for all case without
 maintaining the safe list.

> We need to do something about interrupts though. > Maybe we could error the user ioctl to set d3cold
> for devices running in INTx mode, but we also have numerous ways that
> the device could be resumed under the user, which might start
> triggering MSI/X interrupts?
> 

 All the resuming we are mainly to prevent any malicious sequence.
 If we see from normal OS side, then once the guest kernel has moved
 the device into D3cold, then it should not do any config space
 access. Similarly, from hypervisor, it should not invoke any
 ioctl other than moving the device into D0 again when the device
 is in D3cold. But, preventing the device to go into D3cold when
 any other ioctl or config space access is happening is not easy,
 so incrementing usage count before these access will ensure that
 the device won't go into D3cold. 

 For interrupts, can the interrupt happen (Both INTx and MSI/x)
 if the device is in D3cold? In D3cold, the PME events are possible
 and these events will anyway resume the device first. If the
 interrupts are not possible then can we disable all the interrupts
 somehow before going calling runtime PM API's to move the device into D3cold
 and enable it again during runtime resume. We can wait for all existing
 Interrupt to be finished first. I am not sure if this is possible. 
 
 Returning error for user ioctl to set d3cold while interrupts are
 happening needs some synchronization at both interrupt handler and
 ioctl code and using runtime resume inside interrupt handler
 may not be safe.
   
>> +
>> +     default:
>> +             break;
>> +     }
>> +
>> +     if (!skip_runtime_resume) {
>> +             ret = pm_runtime_resume_and_get(dev);
>> +             if (ret < 0)
>> +                     return ret;
>> +     }
>> +
>> +     ret = vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
>> +
> 
> I'm not a fan of wrapping the main ioctl interface for power management
> like this.
> 

 We need to increment the usage count at entry and decrement it
 again at exit. Currently, from lot of places directly, we are
 calling 'return' instead of going at function end. If we need to
 get rid of wrapper function, then I need to replace all return with
 'goto' for going at the function end and return after decrementing
 the usage count. Will this be fine ? 

>> +     if (!skip_runtime_resume)
>> +             pm_runtime_put(dev);
>> +
>> +     return ret;
>> +#else
>> +     return vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
>> +#endif
>> +}
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>>
>>  static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>> @@ -1897,6 +2017,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>               return -EBUSY;
>>       }
>>
>> +     dev_set_drvdata(&pdev->dev, vdev);
>>       if (pci_is_root_bus(pdev->bus)) {
>>               ret = vfio_assign_device_set(&vdev->vdev, vdev);
>>       } else if (!pci_probe_reset_slot(pdev->slot)) {
>> @@ -1966,6 +2087,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>>               pm_runtime_get_noresume(&pdev->dev);
>>
>>       pm_runtime_forbid(&pdev->dev);
>> +     dev_set_drvdata(&pdev->dev, NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>>
>> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>  #ifdef CONFIG_PM
>>  static int vfio_pci_core_runtime_suspend(struct device *dev)
>>  {
>> +     struct pci_dev *pdev = to_pci_dev(dev);
>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>> +
>> +     down_read(&vdev->memory_lock);
>> +
>> +     /*
>> +      * runtime_suspend_pending won't be set if there is no user of vfio pci
>> +      * device. In that case, return early and PCI core will take care of
>> +      * putting the device in the low power state.
>> +      */
>> +     if (!vdev->runtime_suspend_pending) {
>> +             up_read(&vdev->memory_lock);
>> +             return 0;
>> +     }
> 
> Doesn't this also mean that idle, unused devices can at best sit in
> d3hot rather than d3cold?
> 

 Sorry. I didn't get this point.

 For unused devices, the PCI core will move the device into D3cold directly.
 For the used devices, the config space write is happening first before
 this ioctl is called and the config space write is moving the device
 into D3hot so we need to do some manual thing here.

>> +
>> +     /*
>> +      * The runtime suspend will be called only if device is already at
>> +      * D3hot state. Now, change the device state from D3hot to D3cold by
>> +      * using platform power management. If setting of D3cold is not
>> +      * supported for the PCI device, then the device state will still be
>> +      * in D3hot state. The PCI core expects to save the PCI state, if
>> +      * driver runtime routine handles the power state management.
>> +      */
>> +     pci_save_state(pdev);
>> +     pci_platform_power_transition(pdev, PCI_D3cold);
>> +     up_read(&vdev->memory_lock);
>> +
>>       return 0;
>>  }
>>
>>  static int vfio_pci_core_runtime_resume(struct device *dev)
>>  {
>> +     struct pci_dev *pdev = to_pci_dev(dev);
>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>> +
>> +     down_write(&vdev->memory_lock);
>> +
>> +     /*
>> +      * The PCI core will move the device to D0 state before calling the
>> +      * driver runtime resume.
>> +      */
>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);
> 
> Maybe this is where vdev->power_state is kept synchronized?
> 
 
 Yes. vdev->power_state will be changed here.

>> +
>> +     /*
>> +      * Some PCI device needs the SW involvement before going to D3cold
>> +      * state again. So if there is any wake-up which is not triggered
>> +      * by the guest, then increase the usage count to prevent the
>> +      * second runtime suspend.
>> +      */
> 
> Can you give examples of devices that need this and the reason they
> need this?  The interface is not terribly deterministic if a random
> unprivileged lspci on the host can move devices back to d3hot. 

 I am not sure about other device but this is happening for
 the nvidia GPU itself. 
 
 For nvidia GPU, during runtime suspend, we keep the GPU video memory
 in self-refresh mode for high video memory usage. Each video memory
 self refesh entry before D3cold requires nvidia SW involvement.
 Without SW self-refresh sequnece involvement, it won't work. 

 Details regarding runtime suspend with self-refresh can be found in

 https://download.nvidia.com/XFree86/Linux-x86_64/495.46/README/dynamicpowermanagement.html#VidMemThreshold

 But, if GPU video memory usage is low, then we turnoff video memory
 and save all the allocation in system memory. In this case, SW involvement 
 is not required. 

> How useful is this implementation if a notice to the guest of a resumed
> device is TBD?  Thanks,
> 
> Alex
> 

 I have prototyped this earlier by using eventfd_ctx for pme and whenever we get
 a resume triggered by host, then it will forward the same to hypervisor.
 Then in the hypervisor, it can write into virtual root port PME related registers
 and send PME event which will wake-up the PCI device in the guest side.
 It will help in handling PME events related wake-up also which are currently
 disabled in PATCH 2 of this patch series.
 
 Thanks,
 Abhishek

>> +     if (vdev->runtime_suspend_pending) {
>> +             vdev->runtime_suspend_pending = false;
>> +             pm_runtime_get_noresume(&pdev->dev);
>> +     }
>> +
>> +     up_write(&vdev->memory_lock);
>>       return 0;
>>  }
>>
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 05db838e72cc..8bbfd028115a 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -124,6 +124,7 @@ struct vfio_pci_core_device {
>>       bool                    needs_reset;
>>       bool                    nointx;
>>       bool                    needs_pm_restore;
>> +     bool                    runtime_suspend_pending;
>>       pci_power_t             power_state;
>>       struct pci_saved_state  *pci_saved_state;
>>       struct pci_saved_state  *pm_save;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index ef33ea002b0b..7b7dadc6df71 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1002,6 +1002,27 @@ struct vfio_device_feature {
>>   */
>>  #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN     (0)
>>
>> +/**
>> + * VFIO_DEVICE_POWER_MANAGEMENT - _IOW(VFIO_TYPE, VFIO_BASE + 18,
>> + *                          struct vfio_power_management)
>> + *
>> + * Provide the support for device power management.  The native PCI power
>> + * management does not support the D3cold power state.  For moving the device
>> + * into D3cold state, change the PCI state to D3hot with standard
>> + * configuration registers and then call this IOCTL to setting the D3cold
>> + * state.  Similarly, if the device in D3cold state, then call this IOCTL
>> + * to exit from D3cold state.
>> + *
>> + * Return 0 on success, -errno on failure.
>> + */
>> +#define VFIO_DEVICE_POWER_MANAGEMENT         _IO(VFIO_TYPE, VFIO_BASE + 18)
>> +struct vfio_power_management {
>> +     __u32   argsz;
>> +#define VFIO_DEVICE_D3COLD_STATE_EXIT                0x0
>> +#define VFIO_DEVICE_D3COLD_STATE_ENTER               0x1
>> +     __u32   d3cold_state;
>> +};
>> +
>>  /* -------- API for Type1 VFIO IOMMU -------- */
>>
>>  /**
> 

