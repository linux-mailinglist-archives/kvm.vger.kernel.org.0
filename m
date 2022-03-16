Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304BC4DAA00
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 06:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353656AbiCPFmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 01:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiCPFmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 01:42:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FAE5FF33;
        Tue, 15 Mar 2022 22:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJkjsMRLCu1sIOwwhYkqQxrWCMdfrJXT1Lbdq8SNNR8XxkZQp7lLg099itPIjaSB3Td2Hnrpf1lfQa+95IrZeFijNeqmPOSUUNVD5iM3kb6Cr7ftZWIPQOgTz62L9/NNf0NdPFPD0sDD4CmGJ9GxPf9TZb5l0brQR9JrBkxGyiVa2oOMgxRDVmM8SCpTv9qzL8HvpZF8nBW+caixRqWjFmB7pxOR2xCXOC4Sm+hSKCtgtGYI0Ubsmh90eyB6DpxyY6vzXov0gqO1bdyEgoFIiaXjbvcIhwQgly9NFUpOUW+uOXbQ7TjJC+4//a+thUEtNcTiR2quxG37FFcpErG/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlgwpQXwZA2Q+oRfzH3iL5C1qH228W3p65iTL+5fdh0=;
 b=JVydd3ZreAT9sY/FPJTxlTuXTuTyPI215UNKjU0ieFjze9b3tKpsqqfvMaqWAhmLL3GgzkiYsMjV10z17qC9Rs+jXwVvQswNhU7CoxVeTncFtUfROZMVJtJln60dQBk7gheVpSmRAo3pTNmUyg0H0HmWmFLqNjPkPhbr6PUlwLHigYED7Ij5CR/AKJzm5AUN7qXb7cQlTqIw2I51sIunZtN/XMP3VO383H3EmfFq5XzT9xEQNqnUfYdf2cfYRI9QFlq3fC1q5kma429N/6xI3J5FRONtR9xCj1rmITtFgHnvMlah8nfwmn9Hz9DSQLSdkKUR014/PmHrQKrwZ9dSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlgwpQXwZA2Q+oRfzH3iL5C1qH228W3p65iTL+5fdh0=;
 b=eVmOgUWHoKNu2KeougbysNTpFec5naIPlrBwseuEqdvZ6WuUIeAt/Wz+a34aIJl68diSRnixTWEN4TjEQ3un5LKoPRGHLj2ktwFl4/78kiW6/VTuuv0dj6LP1H/tFw2wI9Rh096YG9Gn958OLPwBJPEzpM9g5i3gOQ4sEJPAiFM+j+4pdO9iKy9/neRnqV6dqF946KJz6TpxqCJiZYRHrANeq+GYW80YLKfpwpuM0d0WXB7Fn2bh96CWS/b/AmcFCCmpQ28JwBS0nJGUB4nKWFcJICPtCOzv3ybbYD4hhS5M/kectUTa7HQZF2lyK//axofKpejFDwi1PHw7IEISZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL0PR12MB2563.namprd12.prod.outlook.com (2603:10b6:207:4b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 05:41:15 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b%7]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 05:41:15 +0000
Message-ID: <02691b8d-1aa7-e6a3-f179-8793410e7263@nvidia.com>
Date:   Wed, 16 Mar 2022 11:11:04 +0530
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
 <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
 <20220311160627.6ec569a9.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220311160627.6ec569a9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::15) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bd2941d-7778-447e-9bf9-08da070f9644
X-MS-TrafficTypeDiagnostic: BL0PR12MB2563:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2563F25315622BB4E648C5DACC119@BL0PR12MB2563.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3EPdaET7fGfrGqLfUJoH05GE6V1HyE253y/LR+JixE9vCjLrq2pgQxcO/aPYa3SKCOBLTKUyjnatRzplrFOO7gVIAcP+uy4ChSA2JU3rRNKG8Z/sET4ggcw6ALO2LkEd12gqXQ4tRLauc8czCCgiD3+6++U3so4U4Op/5oITbQgwQddc+5YC17nXe02T1TyO6EAzHvi1saJzq8BhRHo/7jTind80AjT596oh+rcFv39xaGAfZV6wlDvWxwlJUyCo8ucepzYZo+TuPPoMoDD8m5qNJR3EA0m3JI+NGPVeGvSle47mPRpn5tO31ENRodGRlhjmqUZA9cbNDgTN19vJx+lM8t4GvHT2YtYlyCNEjUn53njDpELXGxN3nN8qtCMBd20qwmo08NQ/1nKufowrpmaIP1g2w5sCEtVk1SYUjm9R94WCBddozs8zO9OKle1ZTM+P8lQQzjYw7y9o5vOEjaDxGmx1C33XubuDcUOUc711YxceHYryVpqoTtwhbZ4FOWGvoY/m53tNjxbQQracmcI4geBxxaJ660lnGA55zU3eNAYkPOXwpjqDQu+3RNwUh/JBgYxBS/vPRg+mqNf4t7ZbLTplSb87P+2ZQgAdUrfDBvVEUgAqTc1c63H9IoZ/rPI8JJ8BMUj1LOKdVHScKVNa1/eM8uaZwDnmr9E74hjJ9SNUGrEN9knCKV7J1ob8XYaMeQPJxlzNbgVf8imoGoR0APjgP5gl8IrtvuUrf2A/hWLkeyU3BmVznZoObvOo1HnBPYWFP/UweTCJ4yJdlGpOYmpkW7N12aiL5VNHKknkEHX6S0LfqlMDWbv7mx00mzw/FYlb01cVJsvlzFgYQwVQz/WTGzSgWhWvB6P9tRUvkBnmTxnYfGP/iDieWWd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(26005)(2616005)(31696002)(86362001)(2906002)(6666004)(83380400001)(8936002)(55236004)(6506007)(53546011)(30864003)(54906003)(6486002)(186003)(66556008)(966005)(508600001)(36756003)(66476007)(38100700002)(66946007)(8676002)(4326008)(6916009)(316002)(31686004)(6512007)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzZsTFNHSlg1K3pGVUd5eER0R3RXeWMzckNjakNyWXNtU0p6WkRpdVV6amE0?=
 =?utf-8?B?M3hJZGltc0p2UnduSTRzWktZYkVCTGJ5aGtqcHQwS2R3VTdlOUQxMGo4cjRq?=
 =?utf-8?B?M1BlUEpNVGRYWTNiaHJSd2V1Rk5zSndaQVh4b1BUWXpJU0laSkJodEhvQ09M?=
 =?utf-8?B?L0loQ0k4aCtyK3lad1JqblNBTmtBZm9oTUpHbVpOR2VjYnlYK2dzdmpmandB?=
 =?utf-8?B?TGVvZ0ZOdU5kSVpvU0JlMVRKeW1lTnprOTJIK2tuTjRtOEE2ZXNxbWpoaG8w?=
 =?utf-8?B?UDJWWmNpWXNLbVBsbXRVd1htdFRuZ0JFbVpOazZSV09HWVRDK3lUWG02V0Q1?=
 =?utf-8?B?SDJEbnRyT0U1L0NWNTdrLzlpL3F0enl2WXl3aFJMKzdnR0lTckJHeW0wdnVr?=
 =?utf-8?B?dkpmQzJiQWkrWTdmd3Fkc3RuU1hHTCtNcEx3VVI1cmNiNU5RN3FoRUlaK2xI?=
 =?utf-8?B?eHA5Y2ZRczQrLzVjU0QrTVFzbkNTYkh6UVdNU2tYUXpvZnVySjhTMnhRSmkw?=
 =?utf-8?B?Q1lhZlpWd2hseXRPQVJIa29ZOHRxNXJsYUQzbWFQUVBYV25pU0FnU05vK0hI?=
 =?utf-8?B?V3l6TDkyUzRTUENTZXVwZ0dIUWwzeUd6RENrdWZkampZN21nTEM1RHZZUTlq?=
 =?utf-8?B?S1d2ejlYUTBlQ0VmUHR5YUw3TVVqd2tjNFBTYWp2WkFtQkFXczZWY3kxbFAv?=
 =?utf-8?B?WmFRS3RNY01nMWVNSTFLRGYzcnd2ZW5LSlZ4TmpQT2phNFJrdXhnaU5Od3k5?=
 =?utf-8?B?QW1TbnVzZmRoSzhieGc0YTNMa09IUWRvclpseUNnVjBOZkxDTzFiVHVvdXJ3?=
 =?utf-8?B?WGJ3RTB4d3l2Q1B6MnlSamFwYk8ycFpZenpqY3pIbUxMNEh3Z3RnVTc1elZv?=
 =?utf-8?B?M3VXbklJN3dtVVFpeTA5QXhYcFJpNkVFVFlkRHR6YzE0TUQxcUVrZ2lkUE5I?=
 =?utf-8?B?UjZSeFQ4ZDdvNWNERWJQVUNoZHI1ejNqV2JsOHZsb2VCdENYWHVNYkRsOWtE?=
 =?utf-8?B?MG55Tm4yQjRxV1pPWlZkSG4zSmRXRnJPVzkreUVrT3NvbUZ0M21xMEpMNU5l?=
 =?utf-8?B?Nm5YMFVUN3hsU1puZWRpT2k0cHZlcldKWllRS3N1Q1R3MVNnck9EeFJKa0Fq?=
 =?utf-8?B?UjdRWUx6dzQ1U1hBVHVEaWJtcGhaQTZHbDNqT3FFWXN4TzB2cEl5d0paVklV?=
 =?utf-8?B?ZGNZWDYwOXRUUm4ybi8xWnJCK3pCVmRNSk1VTFZUZkRXMGFCVUNQYUJEUW9w?=
 =?utf-8?B?MVROZnlhSEZ2VXczZVZKbk1UZDduNnBoTVB1WUozSTlmWHppQ0dzTmRjbU56?=
 =?utf-8?B?ODhTdjFwSjdtR3BBTStuSWhrN0RBdDJxSFk5NU04MlRWZ3ZsUnVnbmJIeUtl?=
 =?utf-8?B?VFB1bnVYOTFHVjhCT1MzUi9WTmJ1L01iRDNpL1A3ZnhPbDFnWlVXSXFWVHpM?=
 =?utf-8?B?UmlOMkJuRjJIejBrYUFTSmNEb0JNU3cxNnIwSUVxY0cvV3M2YmhiSXZZSkdM?=
 =?utf-8?B?aFhYV3NwNnlFaEQ0b0NoZkF3SWtPU1VzcURiYXpnZyszeEdmdFArNWNzZkl4?=
 =?utf-8?B?YitkejFabGpxU3BLYitXWUEwUitzd0N4U1BzT2R2NCtRYldkNk9pT2JLNGpX?=
 =?utf-8?B?aUhFbFBjYWRMVW1yT1Vac2ZhS2djSXBrVnFkMUhLYjlIckVrbGF2Q0lUQVNS?=
 =?utf-8?B?dVZTeGRQSHJ2SlRrejI4WHM0RG1mNk4wcm9FSThWdFlMQlFIUGVXdk5QZWdv?=
 =?utf-8?B?N0ViQ3phOEZLdHB4MTlXaWM4eTVJam0wNDF3YSs5NGdsUUNvd3J5SC9HZjI1?=
 =?utf-8?B?aGJaWGp4YUM5VVA3ZUJSUzRubk9YcDhOeXIrNmo4TUV6L2R4Z2dlN1ErWXZ6?=
 =?utf-8?B?UnJVWkRBUVlTWHdQa2FOUDZRWHhud29pSWFRNUgxT2tzZmVhN3Y4Yldyb3VM?=
 =?utf-8?Q?vyIOdKdtQPfKThL+wAVE66qPvlxXr6u5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd2941d-7778-447e-9bf9-08da070f9644
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 05:41:15.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfKKJLUpUqcDgI1Dz8WMLv/7bYcEZrRFGQhB22gmpyM5JFeh+idnhz8v8IxwsziTaLYfZEZ0IuBY8gFnc2zY6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2563
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/2022 4:36 AM, Alex Williamson wrote:
> On Fri, 11 Mar 2022 21:15:38 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 3/9/2022 10:56 PM, Alex Williamson wrote:
>>> On Mon, 24 Jan 2022 23:47:26 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>
>>>> Currently, if the runtime power management is enabled for vfio-pci
>>>> device in the guest OS, then guest OS will do the register write for
>>>> PCI_PM_CTRL register. This write request will be handled in
>>>> vfio_pm_config_write() where it will do the actual register write
>>>> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
>>>> achieved for low power. If we can use the runtime PM framework,
>>>> then we can achieve the D3cold state which will help in saving
>>>> maximum power.
>>>>
>>>> 1. Since D3cold state can't be achieved by writing PCI standard
>>>>    PM config registers, so this patch adds a new IOCTL which change the
>>>>    PCI device from D3hot to D3cold state and then D3cold to D0 state.
>>>>
>>>> 2. The hypervisors can implement virtual ACPI methods. For
>>>>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>>>>    power resources with _ON/_OFF method, then guest linux OS makes the
>>>>    _OFF call during D3cold transition and then _ON during D0 transition.
>>>>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>>>>    related IOCTL in the vfio driver.
>>>>
>>>> 3. The vfio driver uses runtime PM framework to achieve the
>>>>    D3cold state. For the D3cold transition, decrement the usage count and
>>>>    during D0 transition increment the usage count.
>>>>
>>>> 4. For D3cold, the device current power state should be D3hot.
>>>>    Then during runtime suspend, the pci_platform_power_transition() is
>>>>    required for D3cold state. If the D3cold state is not supported, then
>>>>    the device will still be in D3hot state. But with the runtime PM, the
>>>>    root port can now also go into suspended state.
>>>>
>>>> 5. For most of the systems, the D3cold is supported at the root
>>>>    port level. So, when root port will transition to D3cold state, then
>>>>    the vfio PCI device will go from D3hot to D3cold state during its
>>>>    runtime suspend. If root port does not support D3cold, then the root
>>>>    will go into D3hot state.
>>>>
>>>> 6. The runtime suspend callback can now happen for 2 cases: there
>>>>    is no user of vfio device and the case where user has initiated
>>>>    D3cold. The 'runtime_suspend_pending' flag can help to distinguish
>>>>    this case.
>>>>
>>>> 7. There are cases where guest has put PCI device into D3cold
>>>>    state and then on the host side, user has run lspci or any other
>>>>    command which requires access of the PCI config register. In this case,
>>>>    the kernel runtime PM framework will resume the PCI device internally,
>>>>    read the config space and put the device into D3cold state again. Some
>>>>    PCI device needs the SW involvement before going into D3cold state.
>>>>    For the first D3cold state, the driver running in guest side does the SW
>>>>    side steps. But the second D3cold transition will be without guest
>>>>    driver involvement. So, prevent this second d3cold transition by
>>>>    incrementing the device usage count. This will make the device
>>>>    unnecessary in D0 but it's better than failure. In future, we can some
>>>>    mechanism by which we can forward these wake-up request to guest and
>>>>    then the mentioned case can be handled also.
>>>>
>>>> 8. In D3cold, all kind of BAR related access needs to be disabled
>>>>    like D3hot. Additionally, the config space will also be disabled in
>>>>    D3cold state. To prevent access of config space in the D3cold state,
>>>>    increment the runtime PM usage count before doing any config space
>>>>    access. Also, most of the IOCTLs do the config space access, so
>>>>    maintain one safe list and skip the resume only for these safe IOCTLs
>>>>    alone. For other IOCTLs, the runtime PM usage count will be
>>>>    incremented first.
>>>>
>>>> 9. Now, runtime suspend/resume callbacks need to get the vdev
>>>>    reference which can be obtained by dev_get_drvdata(). Currently, the
>>>>    dev_set_drvdata() is being set after returning from
>>>>    vfio_pci_core_register_device(). The runtime callbacks can come
>>>>    anytime after enabling runtime PM so dev_set_drvdata() must happen
>>>>    before that. We can move dev_set_drvdata() inside
>>>>    vfio_pci_core_register_device() itself.
>>>>
>>>> 10. The vfio device user can close the device after putting
>>>>     the device into runtime suspended state so inside
>>>>     vfio_pci_core_disable(), increment the runtime PM usage count.
>>>>
>>>> 11. Runtime PM will be possible only if CONFIG_PM is enabled on
>>>>     the host. So, the IOCTL related code can be put under CONFIG_PM
>>>>     Kconfig.
>>>>
>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>> ---
>>>>  drivers/vfio/pci/vfio_pci.c        |   1 -
>>>>  drivers/vfio/pci/vfio_pci_config.c |  11 +-
>>>>  drivers/vfio/pci/vfio_pci_core.c   | 186 +++++++++++++++++++++++++++--
>>>>  include/linux/vfio_pci_core.h      |   1 +
>>>>  include/uapi/linux/vfio.h          |  21 ++++
>>>>  5 files changed, 211 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>>>> index c8695baf3b54..4ac3338c8fc7 100644
>>>> --- a/drivers/vfio/pci/vfio_pci.c
>>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>>> @@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>       ret = vfio_pci_core_register_device(vdev);
>>>>       if (ret)
>>>>               goto out_free;
>>>> -     dev_set_drvdata(&pdev->dev, vdev);
>>>
>>> Relocating the setting of drvdata should be proposed separately rather
>>> than buried in this patch.  The driver owns drvdata, the driver is the
>>> only consumer of drvdata, so pushing this into the core to impose a
>>> standard for drvdata across all vfio-pci variants doesn't seem like a
>>> good idea to me.
>>>
>>
>>  I will check regarding this part.
>>  Mainly drvdata is needed for the runtime PM callbacks which are added
>>  inside core layer and we need to get vdev from struct device.
>>
>>>>       return 0;
>>>>
>>>>  out_free:
>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>>> index dd9ed211ba6f..d20420657959 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>> @@ -25,6 +25,7 @@
>>>>  #include <linux/uaccess.h>
>>>>  #include <linux/vfio.h>
>>>>  #include <linux/slab.h>
>>>> +#include <linux/pm_runtime.h>
>>>>
>>>>  #include <linux/vfio_pci_core.h>
>>>>
>>>> @@ -1919,16 +1920,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>>>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>>                          size_t count, loff_t *ppos, bool iswrite)
>>>>  {
>>>> +     struct device *dev = &vdev->pdev->dev;
>>>>       size_t done = 0;
>>>>       int ret = 0;
>>>>       loff_t pos = *ppos;
>>>>
>>>>       pos &= VFIO_PCI_OFFSET_MASK;
>>>>
>>>> +     ret = pm_runtime_resume_and_get(dev);
>>>> +     if (ret < 0)
>>>> +             return ret;
>>>> +
>>>>       while (count) {
>>>>               ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
>>>> -             if (ret < 0)
>>>> +             if (ret < 0) {
>>>> +                     pm_runtime_put(dev);
>>>>                       return ret;
>>>> +             }
>>>>
>>>>               count -= ret;
>>>>               done += ret;
>>>> @@ -1936,6 +1944,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>>               pos += ret;
>>>>       }
>>>>
>>>> +     pm_runtime_put(dev);
>>>
>>> What about other config accesses, ex. shared INTx?  We need to
>>> interact with the device command and status register on an incoming
>>> interrupt to test if our device sent an interrupt and to mask it.  The
>>> unmask eventfd can also trigger config space accesses.  Seems
>>> incomplete relative to config space.
>>>
>>
>>  I will check this path thoroughly.
>>  But from initial analysis, it seems we have 2 path here:
>>
>>  Most of the mentioned functions are being called from
>>  vfio_pci_set_irqs_ioctl() and pm_runtime_resume_and_get()
>>  should be called for this ioctl also in this patch.
>>
>>  Second path is when we are inside IRQ handler. For that, we need some
>>  other mechanism which I explained below.
>>
>>>>       *ppos += done;
>>>>
>>>>       return done;
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>> index 38440d48973f..b70bb4fd940d 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -371,12 +371,23 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
>>>>
>>>>       /*
>>>> -      * If disable has been called while the power state is other than D0,
>>>> -      * then set the power state in vfio driver to D0. It will help
>>>> -      * in running the logic needed for D0 power state. The subsequent
>>>> -      * runtime PM API's will put the device into the low power state again.
>>>> +      * The vfio device user can close the device after putting the device
>>>> +      * into runtime suspended state so wake up the device first in
>>>> +      * this case.
>>>>        */
>>>> -     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>>> +     if (vdev->runtime_suspend_pending) {
>>>> +             vdev->runtime_suspend_pending = false;
>>>> +             pm_runtime_resume_and_get(&pdev->dev);
>>>
>>> Doesn't vdev->power_state become unsynchronized from the actual device
>>> state here and maybe elsewhere in this patch?  (I see below that maybe
>>> the resume handler accounts for this)
>>>
>>
>>  Yes. Inside runtime resume handler, it is being changed back to D0.
>>
>>>> +     } else {
>>>> +             /*
>>>> +              * If disable has been called while the power state is other
>>>> +              * than D0, then set the power state in vfio driver to D0. It
>>>> +              * will help in running the logic needed for D0 power state.
>>>> +              * The subsequent runtime PM API's will put the device into
>>>> +              * the low power state again.
>>>> +              */
>>>> +             vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>>> +     }
>>>>
>>>>       /* Stop the device from further DMA */
>>>>       pci_clear_master(pdev);
>>>> @@ -693,8 +704,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
>>>>
>>>> -long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>> -             unsigned long arg)
>>>> +static long vfio_pci_core_ioctl_internal(struct vfio_device *core_vdev,
>>>> +                                      unsigned int cmd, unsigned long arg)
>>>>  {
>>>>       struct vfio_pci_core_device *vdev =
>>>>               container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>>> @@ -1241,10 +1252,119 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>>               default:
>>>>                       return -ENOTTY;
>>>>               }
>>>> +#ifdef CONFIG_PM
>>>> +     } else if (cmd == VFIO_DEVICE_POWER_MANAGEMENT) {
>>>
>>> I'd suggest using a DEVICE_FEATURE ioctl for this.  This ioctl doesn't
>>> follow the vfio standard of argsz/flags and doesn't seem to do anything
>>> special that we couldn't achieve with a DEVICE_FEATURE ioctl.
>>>
>>
>>  Sure. DEVICE_FEATURE can help for this.
>>
>>>> +             struct vfio_power_management vfio_pm;
>>>> +             struct pci_dev *pdev = vdev->pdev;
>>>> +             bool request_idle = false, request_resume = false;
>>>> +             int ret = 0;
>>>> +
>>>> +             if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
>>>> +                     return -EFAULT;
>>>> +
>>>> +             /*
>>>> +              * The vdev power related fields are protected with memory_lock
>>>> +              * semaphore.
>>>> +              */
>>>> +             down_write(&vdev->memory_lock);
>>>> +             switch (vfio_pm.d3cold_state) {
>>>> +             case VFIO_DEVICE_D3COLD_STATE_ENTER:
>>>> +                     /*
>>>> +                      * For D3cold, the device should already in D3hot
>>>> +                      * state.
>>>> +                      */
>>>> +                     if (vdev->power_state < PCI_D3hot) {
>>>> +                             ret = EINVAL;
>>>> +                             break;
>>>> +                     }
>>>> +
>>>> +                     if (!vdev->runtime_suspend_pending) {
>>>> +                             vdev->runtime_suspend_pending = true;
>>>> +                             pm_runtime_put_noidle(&pdev->dev);
>>>> +                             request_idle = true;
>>>> +                     }
>>>
>>> If I call this multiple times, runtime_suspend_pending prevents it from
>>> doing anything, but what should the return value be in that case?  Same
>>> question for exit.
>>>
>>
>>  For entry, the user should not call moving the device to D3cold, if it has
>>  already requested. So, we can return error in this case. For exit,
>>  currently, in this patch, I am clearing runtime_suspend_pending if the
>>  wake-up is triggered from the host side (with lspci or some other command).
>>  In that case, the exit should not return error. Should we add code to
>>  detect multiple calling of these and ensure only one
>>  VFIO_DEVICE_D3COLD_STATE_ENTER/VFIO_DEVICE_D3COLD_STATE_EXIT can be called.
> 
> AIUI, the argument is that we can't re-enter d3cold w/o guest driver
> support, so if an lspci which was unknown to have occurred by the
> device user were to wake the device, it seems the user would see
> arbitrarily different results attempting to put the device to sleep
> again.
> 

 Sorry. I still didn't get this point.

 For guest to go into D3cold, it will follow 2 steps

 1. Move the device from D0 to D3hot state by using config register.
 2. Then use this IOCTL to move D3hot state to D3cold state.

Now, on the guest side if we run lspci, then following will be behavior:

 1. If we call it before step 2, then the config space register
    can still be read in D3hot.
 2. If we call it after step 2, then the guest os should move the
    device into D0 first, read the config space and then again,
    the guest os should move the device to D3cold with the
    above steps. In this process, the guest OS driver will be involved.
    This is current behavior with Linux guest OS. 

 Now, on the host side, if we run lspci,

 1. If we call it before step 2, then the config space register can
    still be read in D3hot.
 2. If we call after step 2, then the D3cold to D0 will happen in
    the runtime resume and then it will be in D0 state. But if we
    add support to allow re-entering into D3cold again as I mentioned
    below. then it will again go into D3cold state. 

>>>> +
>>>> +                     break;
>>>> +
>>>> +             case VFIO_DEVICE_D3COLD_STATE_EXIT:
>>>> +                     /*
>>>> +                      * If the runtime resume has already been run, then
>>>> +                      * the device will be already in D0 state.
>>>> +                      */
>>>> +                     if (vdev->runtime_suspend_pending) {
>>>> +                             vdev->runtime_suspend_pending = false;
>>>> +                             pm_runtime_get_noresume(&pdev->dev);
>>>> +                             request_resume = true;
>>>> +                     }
>>>> +
>>>> +                     break;
>>>> +
>>>> +             default:
>>>> +                     ret = EINVAL;
>>>> +                     break;
>>>> +             }
>>>> +
>>>> +             up_write(&vdev->memory_lock);
>>>> +
>>>> +             /*
>>>> +              * Call the runtime PM API's without any lock. Inside vfio driver
>>>> +              * runtime suspend/resume, the locks can be acquired again.
>>>> +              */
>>>> +             if (request_idle)
>>>> +                     pm_request_idle(&pdev->dev);
>>>> +
>>>> +             if (request_resume)
>>>> +                     pm_runtime_resume(&pdev->dev);
>>>> +
>>>> +             return ret;
>>>> +#endif
>>>>       }
>>>>
>>>>       return -ENOTTY;
>>>>  }
>>>> +
>>>> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>> +                      unsigned long arg)
>>>> +{
>>>> +#ifdef CONFIG_PM
>>>> +     struct vfio_pci_core_device *vdev =
>>>> +             container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>>> +     struct device *dev = &vdev->pdev->dev;
>>>> +     bool skip_runtime_resume = false;
>>>> +     long ret;
>>>> +
>>>> +     /*
>>>> +      * The list of commands which are safe to execute when the PCI device
>>>> +      * is in D3cold state. In D3cold state, the PCI config or any other IO
>>>> +      * access won't work.
>>>> +      */
>>>> +     switch (cmd) {
>>>> +     case VFIO_DEVICE_POWER_MANAGEMENT:
>>>> +     case VFIO_DEVICE_GET_INFO:
>>>> +     case VFIO_DEVICE_FEATURE:
>>>> +             skip_runtime_resume = true;
>>>> +             break;
>>>
>>> How can we know that there won't be DEVICE_FEATURE calls that touch the
>>> device, the recently added migration via DEVICE_FEATURE does already.
>>> DEVICE_GET_INFO seems equally as prone to breaking via capabilities
>>> that could touch the device.  It seems easier to maintain and more
>>> consistent to the user interface if we simply define that any device
>>> access will resume the device.
>>
>>  In that case, we can resume the device for all case without
>>  maintaining the safe list.
>>
>>> We need to do something about interrupts though. > Maybe we could error the user ioctl to set d3cold
>>> for devices running in INTx mode, but we also have numerous ways that
>>> the device could be resumed under the user, which might start
>>> triggering MSI/X interrupts?
>>>
>>
>>  All the resuming we are mainly to prevent any malicious sequence.
>>  If we see from normal OS side, then once the guest kernel has moved
>>  the device into D3cold, then it should not do any config space
>>  access. Similarly, from hypervisor, it should not invoke any
>>  ioctl other than moving the device into D0 again when the device
>>  is in D3cold. But, preventing the device to go into D3cold when
>>  any other ioctl or config space access is happening is not easy,
>>  so incrementing usage count before these access will ensure that
>>  the device won't go into D3cold.
>>
>>  For interrupts, can the interrupt happen (Both INTx and MSI/x)
>>  if the device is in D3cold?
> 
> The device itself shouldn't be generating interrupts and we don't share
> MSI interrupts between devices (afaik), but we do share INTx interrupts.
> 
>>  In D3cold, the PME events are possible
>>  and these events will anyway resume the device first. If the
>>  interrupts are not possible then can we disable all the interrupts
>>  somehow before going calling runtime PM API's to move the device into D3cold
>>  and enable it again during runtime resume. We can wait for all existing
>>  Interrupt to be finished first. I am not sure if this is possible.
> 
> In the case of shared INTx, it's not just inflight interrupts.
> Personally I wouldn't have an issue if we increment the usage counter
> when INTx is in use to simply avoid the issue, but does that invalidate
> the use case you're trying to enable?

 It should not invalidate the use case which I am trying to support.

 But incrementing the usage count for device already in D3cold
 state will cause it to wake-up. Wake-up from D3cold may take
 somewhere around 500 ms – 1500 ms (or sometimes more than that since
 it depends upon root port wake-up time). So, it will make the
 ISR time high. For the root port wake-up time, please refer

 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ad9001f2f41198784b0423646450ba2cb24793a3

 where it can take 1100ms alone for the port port on
 older platforms. 
 
 
> Otherwise I think we'd need to
> remove and re-add the handler around d3cold.
> 
>>  Returning error for user ioctl to set d3cold while interrupts are
>>  happening needs some synchronization at both interrupt handler and
>>  ioctl code and using runtime resume inside interrupt handler
>>  may not be safe.
> 
> It's not a race condition to synchronize, it's simply that a shared
> INTX interrupt can occur any time and we need to make sure we don't
> touch the device when that occurs, either by preventing d3cold and INTx
> in combination, removing the handler, or maybe adding a test in the
> handler to not touch the device - either of the latter we need to be
> sure we're not risking introducing interrupts storms by being out of
> sync with the device state.
> 

 Adding a test to detect the D3cold seems to be better option in
 this case but not sure about interrupts storms.

>>>> +
>>>> +     default:
>>>> +             break;
>>>> +     }
>>>> +
>>>> +     if (!skip_runtime_resume) {
>>>> +             ret = pm_runtime_resume_and_get(dev);
>>>> +             if (ret < 0)
>>>> +                     return ret;
>>>> +     }
>>>> +
>>>> +     ret = vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
>>>> +
>>>
>>> I'm not a fan of wrapping the main ioctl interface for power management
>>> like this.
>>>
>>
>>  We need to increment the usage count at entry and decrement it
>>  again at exit. Currently, from lot of places directly, we are
>>  calling 'return' instead of going at function end. If we need to
>>  get rid of wrapper function, then I need to replace all return with
>>  'goto' for going at the function end and return after decrementing
>>  the usage count. Will this be fine ?
> 
> 
> Yes, I think that would be preferable.
> 
> 
>>>> +     if (!skip_runtime_resume)
>>>> +             pm_runtime_put(dev);
>>>> +
>>>> +     return ret;
>>>> +#else
>>>> +     return vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
>>>> +#endif
>>>> +}
>>>>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>>>>
>>>>  static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>> @@ -1897,6 +2017,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>>>               return -EBUSY;
>>>>       }
>>>>
>>>> +     dev_set_drvdata(&pdev->dev, vdev);
>>>>       if (pci_is_root_bus(pdev->bus)) {
>>>>               ret = vfio_assign_device_set(&vdev->vdev, vdev);
>>>>       } else if (!pci_probe_reset_slot(pdev->slot)) {
>>>> @@ -1966,6 +2087,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>>>>               pm_runtime_get_noresume(&pdev->dev);
>>>>
>>>>       pm_runtime_forbid(&pdev->dev);
>>>> +     dev_set_drvdata(&pdev->dev, NULL);
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>>>>
>>>> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>>>  #ifdef CONFIG_PM
>>>>  static int vfio_pci_core_runtime_suspend(struct device *dev)
>>>>  {
>>>> +     struct pci_dev *pdev = to_pci_dev(dev);
>>>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>> +
>>>> +     down_read(&vdev->memory_lock);
>>>> +
>>>> +     /*
>>>> +      * runtime_suspend_pending won't be set if there is no user of vfio pci
>>>> +      * device. In that case, return early and PCI core will take care of
>>>> +      * putting the device in the low power state.
>>>> +      */
>>>> +     if (!vdev->runtime_suspend_pending) {
>>>> +             up_read(&vdev->memory_lock);
>>>> +             return 0;
>>>> +     }
>>>
>>> Doesn't this also mean that idle, unused devices can at best sit in
>>> d3hot rather than d3cold?
>>>
>>
>>  Sorry. I didn't get this point.
>>
>>  For unused devices, the PCI core will move the device into D3cold directly.
> 
> Could you point out what path triggers that?  I inferred that this
> function would be called any time the usage count allows transition to
> d3cold and the above test would prevent the device entering d3cold
> unless the user requested it.
> 

 For PCI runtime suspend, there are 2 options:

 1. Don’t change the device power state from D0 in the driver
    runtime suspend callback. In this case, pci_pm_runtime_suspend()
    will handle all the things.

    https://elixir.bootlin.com/linux/v5.17-rc8/source/drivers/pci/pci-driver.c#L1285
    
    For unused device, runtime_suspend_pending will be false since
    it can be set by d3cold ioctl.

 2. With the used device, the device state will be changed to D3hot first
    with vfio_pm_config_write(). In this case, the pci_pm_runtime_suspend()
    expects that all the handling has already been done by driver,
    otherwise it will print the warning and return early.

    “PCI PM: State of device not saved by %pS”

    https://elixir.bootlin.com/linux/v5.17-rc8/source/drivers/pci/pci-driver.c#L1280

>>  For the used devices, the config space write is happening first before
>>  this ioctl is called and the config space write is moving the device
>>  into D3hot so we need to do some manual thing here.
> 
> Why is it that a user owned device cannot re-enter d3cold without
> driver support, but and idle device does?  Simply because we expect to
> reset the device before returning it back to the host or exposing it to
> a user?  I'd expect that after d3cold->d0 we're essentially at a
> power-on state, which ideally would be similar to a post-reset state,
> so I don't follow how driver support factors in to re-entering d3cold.
> 

 In terms of nvidia GPU, the idle unused device is equivalent to
 uninitialized PCI device. In this case, no internal HW modules
 will be initialized like video memory. So, it does not matter
 what we do with the device before that. It is fine to re-enter
 d3cold since the HW itself is not initialized. Once the device
 is owned by user, then in the guest OS side the nvidia driver will run
 and initialize all the HW modules including video memory. Now,
 before removing the power, we need to make sure that video
 memory should come in the same state after resume as before
 suspending. 

 If we don’t keep the video memory in self refresh state, then it is
 equivalent to power on state. But if we keep the video memory
 in self refresh state, then it is different from power-on state.

>>>> +
>>>> +     /*
>>>> +      * The runtime suspend will be called only if device is already at
>>>> +      * D3hot state. Now, change the device state from D3hot to D3cold by
>>>> +      * using platform power management. If setting of D3cold is not
>>>> +      * supported for the PCI device, then the device state will still be
>>>> +      * in D3hot state. The PCI core expects to save the PCI state, if
>>>> +      * driver runtime routine handles the power state management.
>>>> +      */
>>>> +     pci_save_state(pdev);
>>>> +     pci_platform_power_transition(pdev, PCI_D3cold);
>>>> +     up_read(&vdev->memory_lock);
>>>> +
>>>>       return 0;
>>>>  }
>>>>
>>>>  static int vfio_pci_core_runtime_resume(struct device *dev)
>>>>  {
>>>> +     struct pci_dev *pdev = to_pci_dev(dev);
>>>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>> +
>>>> +     down_write(&vdev->memory_lock);
>>>> +
>>>> +     /*
>>>> +      * The PCI core will move the device to D0 state before calling the
>>>> +      * driver runtime resume.
>>>> +      */
>>>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>>
>>> Maybe this is where vdev->power_state is kept synchronized?
>>>
>>
>>  Yes. vdev->power_state will be changed here.
>>
>>>> +
>>>> +     /*
>>>> +      * Some PCI device needs the SW involvement before going to D3cold
>>>> +      * state again. So if there is any wake-up which is not triggered
>>>> +      * by the guest, then increase the usage count to prevent the
>>>> +      * second runtime suspend.
>>>> +      */
>>>
>>> Can you give examples of devices that need this and the reason they
>>> need this?  The interface is not terribly deterministic if a random
>>> unprivileged lspci on the host can move devices back to d3hot.
>>
>>  I am not sure about other device but this is happening for
>>  the nvidia GPU itself.
>>
>>  For nvidia GPU, during runtime suspend, we keep the GPU video memory
>>  in self-refresh mode for high video memory usage. Each video memory
>>  self refesh entry before D3cold requires nvidia SW involvement.
>>  Without SW self-refresh sequnece involvement, it won't work.
> 
> 
> So we're exposing acpi power interfaces to turn a device off, which
> don't really turn the device off, but leaves it in some sort of
> low-power memory refresh state, rather than a fully off state as I had
> assumed above.  Does this suggest the host firmware ACPI has knowledge
> of the device and does different things?
> 

 I was trying to find the public document regarding this part and
 it seems following Windows document can help in providing some
 information related with this

 https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/firmware-requirements-for-d3cold

 “Putting a device in D3cold does not necessarily mean that all
  sources of power to the device have been removed—it means only
  that the main power source, Vcc, is removed. The auxiliary power
  source, Vaux, might also be removed if it is not required for
  the wake logic”.
 
 So, for generic self-refresh D3cold (means in Desktop), it is mainly
 relying on auxiliary power. For notebooks, we ask to do some
 customization in acpi power interfaces side to support
 video memory self-refresh. 

>>  Details regarding runtime suspend with self-refresh can be found in
>>
>>  https://download.nvidia.com/XFree86/Linux-x86_64/495.46/README/dynamicpowermanagement.html#VidMemThreshold
>>
>>  But, if GPU video memory usage is low, then we turnoff video memory
>>  and save all the allocation in system memory. In this case, SW involvement
>>  is not required.
> 
> Ok, so there's some heuristically determined vram usage where the
> driver favors suspend latency versus power savings and somehow keeps
> the device in this low-power, refresh state versus a fully off state.
> How unique is this behavior to NVIDIA devices?  It seems like we're
> trying to add d3cold, but special case it based on a device that might
> have a rather quirky d3cold behavior.  Is there something we can test
> about the state of the device to know which mode it's using? 

 Since vfio is generic driver so testing the device mode here
 seems to be challenging.
 
> Is there something we can virtualize on the device to force the driver to use
> the higher latency, lower power d3cold mode that results in fewer
> restrictions?  Or maybe this is just common practice?
> 

 Yes. We can enforce this. But this option won’t be useful for modern
 use cases. Let’s assume if we have 16GB video memory usage, in that
 case, it will take lot of time in entry and exit and make the feature
 unusable. Also, the system memory will be limited in the guest
 side so enough system memory is again challenge. 

>>> How useful is this implementation if a notice to the guest of a resumed
>>> device is TBD?  Thanks,
>>>
>>> Alex
>>>
>>
>>  I have prototyped this earlier by using eventfd_ctx for pme and whenever we get
>>  a resume triggered by host, then it will forward the same to hypervisor.
>>  Then in the hypervisor, it can write into virtual root port PME related registers
>>  and send PME event which will wake-up the PCI device in the guest side.
>>  It will help in handling PME events related wake-up also which are currently
>>  disabled in PATCH 2 of this patch series.
> 
> But then what does the guest do with the device?  For example, if we
> have a VM with an assigned GPU running an idle desktop where the
> monitor has gone into power save, does running lspci on the host
> randomly wake the desktop and monitor?

 For Linux OS + NVIDIA driver, it seems it will just wake-up the
 GPU up and not the monitor. With the bare-metal setup, I waited
 for monitor to go off with DPMS and then the GPU went into
 suspended state. After that, If I run lspci command,
 then the GPU moved to active state but monitor was
 still in the off state and after lspci, the GPU went
 into suspended state again. 

 The monitor is waking up only if I do keyborad or mouse
 movement.

> I'd like to understand how
> unique the return to d3cold behavior is to this device and whether we
> can restrict that in some way.  An option that's now at our disposal
> would be to create an NVIDIA GPU variant of vfio-pci that has
> sufficient device knowledge to perhaps retrigger the vram refresh
> d3cold state rather than lose vram data going into a standard d3cold
> state.  Thanks,
> 
> Alex
> 

 Adding vram refresh d3cold state with vfio-pci variant is not straight
 forward without involvement of nvidia driver itself. 

 One option is to add one flag in D3cold IOCTL itself to differentiate
 between 2 variants of D3cold entry (One which allows re-entering to
 D3cold and another one which won’t allow re-entering to D3cold) and
 set it default for re-entering to D3cold. For nvidia or similar use
 case, the hypervisor can set this flag to prevent re-entering to D3cold.

 Otherwise, we can add NVIDIA vendor ID check and restrict this
 to nvidia alone. 

 Thanks,
 Abhishek
