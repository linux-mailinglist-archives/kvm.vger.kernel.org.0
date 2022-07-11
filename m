Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A5B56FBE8
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 11:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiGKJgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 05:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiGKJgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 05:36:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB9257219;
        Mon, 11 Jul 2022 02:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6znso2E0xgTl5nfe0SCWX+F+4bn/DXUaFMQEQNPHYusGY7NQixDaYH3GYP/qhtFQ84N+D51u4wXQj8Cc+cWwzBvf7xElDnPRSk4xFS02jfO1gF3opfqwnf/d5KKFlbp+BTGDarvhy4NHR4pbPAAPg2YGluhRhd18bqAsvCG7LxO1PB/Mt/yQBD2i8iEaBrD67dgEGyvo7iObSK+VTHoagMUgx4NefVZUKIMvKRoljVpOgROjt4vh5MCx4HQR6IvMlnsqGWbRpsq+TMo1bSnPYVEfZdo0azkZN5N49dZSllV+V3Rc6m8Lb7lfTJQi38pl7IqpVByLZNYMYsYAkIZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZ3b6VLJ+9mXDG850WRLLo3ZHuBmrNXnhzohuZAaSLs=;
 b=MkypM/505pZQz3fvmMokso36mqZi4WdovdLS8h0WR6Dw8hta9tQMURIzY9kQYkcwb8DU9OJ1scS1hNfS7+L9Fmd4rspBxw1tjGaxGlWJiUlHG21HVmZQD4Iqo7Qvjk0NUWVZDARUndphL9QZbjcLhg2pNY+2pORW7sIN/++mqBxbQ+EsIZuLoTKdACB4ci1dUSPKr/ePdRQk7jh+eWiOzA7PyIpNEZchGDrkGpKTN0MBAsp2Yh573NQCvq803BO3xZ3/tEU5yrVQNL3U1hskHxY0o/3Fb3R3fkZ37soAp8kjMC//6ffHutaIE57LqpNXc9G9MVLiPP0ODZOCw5N1BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ3b6VLJ+9mXDG850WRLLo3ZHuBmrNXnhzohuZAaSLs=;
 b=baREHZ289UBosr9+8xwJP+I9Jdjik2MX9RkDiYMLn2wXdOosmAhaowxd80pI5vDFvWmE0KZwcm277kIlkHu5gzrypUTidNmJKliwOalDj6Xf5UqPQ+54573CfpkcG5wDScSe9/leIwFXIw3YNVVY3ZsF+1JttVKmi3+yrESR3EPtUEOW2dZHaBegZA3+ujGgVeZEfaAr/2jOVPJH9Ck+lZUOKoC9jaYFaPqv3NBdP6oyD1Gqk1odmYuZB6N1KGs0y0Mm+VRU7Q5KeJKxcq2gKRNIiiCo+/fEdVtOpj8yaGt5gB/5yY+NpDmEu48D2rsyZHPtR5gI2GN//eLf7to1zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 09:18:48 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 09:18:47 +0000
Message-ID: <31109e06-48f5-0a12-b310-e284a7b517db@nvidia.com>
Date:   Mon, 11 Jul 2022 14:48:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/6] vfio/pci: Mask INTx during runtime suspend
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
 <20220701110814.7310-2-abhsahu@nvidia.com>
 <20220706093945.30d65ce6.alex.williamson@redhat.com>
 <3b143762-d6ce-ac70-59ae-a0c2e66ffc1b@nvidia.com>
 <20220708094508.49ba647f.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220708094508.49ba647f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::19) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 811c3d1d-755d-4654-08be-08da631e5c47
X-MS-TrafficTypeDiagnostic: PH7PR12MB6444:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJNAEGKzlnonSZXp0EpSqflk6PuFDE7YVZ+fZxLJfIaMqLkSiAHMMtWSsDN4d61EkZEnf80kw6ZQa8qYsXlqSeoGhn6wKEhB8QiV9f44zHYO9D3tYf6yMIyOnWozADqZ9YmtgWXgZKxizspvL7A2zUJywlZhMpGRDLjgiPyIF/2E6x3uFTe/NIsbvu9kzYcTX3BTV4r6t1q/9nV9QYy83DXXCFO+Mqk0gvsFKpjG/cxcZIADJG6tV7dtg8iEtFhMULwTv0qC5N0C9Atq3bJMVyKMW29k6IyNe0MRY969xsafgviT/xaSx4AYviip6CqZbqKMPIZxBBbUleJ7srJUsHIx6WPTrJwGeQQ8I2rUHIBjUGraPkXHIfNqhi/yk7YkduYGbnHItjOsK29UoAbwrn6dI1yHIdyVyZcDw24w6QgYu4qhzYs55eL0D7XkCDR/cnEylk9TNVnpsfD9j8ma5wW7AU6lq/3ehghhIeL7XqRxngwgOk4VflvpC88C7C2QoLeivRBT+rz5ZLbKjLUpuJo564a6282plnf/ijWmNNkjtc8R8A/f5zn4DaHrqvItMuk6vmsxnk1eD4j8mcEktYnAK2kajf+zE/VHfGugPaq60maUApENbltY6gtADphpXSmCOHqWoP9GS4SKGjE5UPBDJuKsXEuhnalfeoKzU+aNHIUxf8Tht0Du0IR+9uYpB9S+L2BIyIslt6nyv5jtuf2hE3v19ruyR5Vc5i2ZYpIkZj/jGE3XyL6FbcrXq41vhivusRlMhRHAwxX9tRFxWEBYa0TfGLxrzvMnmmhMtrHFUWQhmxcd1WegOPi4E95gw/EfhlB+Px3j85QRvAJ8bhy8j/0n1Cqfo2UlJLouK1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(6916009)(7416002)(31696002)(54906003)(4326008)(66556008)(66946007)(41300700001)(2616005)(36756003)(66476007)(38100700002)(83380400001)(53546011)(2906002)(55236004)(31686004)(5660300002)(8676002)(6506007)(316002)(26005)(6666004)(6486002)(186003)(86362001)(478600001)(8936002)(6512007)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2tmdE9uR3NCb0ZLakI1TVdYY1JVNndPYVV5TTVKd1RuWFZib2RGMHZpdUs2?=
 =?utf-8?B?cWhWam5VWTNYcVh4ajNZUEZ6NDIwdEYxWHptZG5xSklzdGxvS2hoVzlLMVR3?=
 =?utf-8?B?YlQ1UEo0RkozOHR3VHM0ekdvOVJUK2QyZEdpdm5raUZKS2VRN3NtOEpNWVgx?=
 =?utf-8?B?WnRJdnRMTHpXYUhpREZETDJaZWZsQmdONU1WWXNOSVB0dExkZVhuSG5kQ1Zl?=
 =?utf-8?B?T2huakxKcy9WZ1E1akRiRE9RWTVvb2s1UU53SHRtQU5pcFluS3FIOURROHVN?=
 =?utf-8?B?OVFKM3BWT2ozYjJ0SkhJMG9oK3dnWktwaU0yS0luWnIxWG9lMGtoOE5LS1ha?=
 =?utf-8?B?MGpzaUx5cm52cTRMM3FYa1hYaXBtdVRTTXoyalRsVkJ5UEk4MGFYaCtCVjl0?=
 =?utf-8?B?MlVQTE1jS1NOWGIxOXI3aFV4cEp3YkM5Q01kaVU1d1k1VmF4OS82c0VQN05s?=
 =?utf-8?B?Y2JvUE5hOTF6Qmx2NnAwRDUvZmhiTXV5S1Vvc2pUNitDNDZzUWkwMmZaSDNn?=
 =?utf-8?B?UVQ4WGtLQTlhYnpKYncxR2V4VlNDcWpuY01UbzRlRHJmbXRzbVRHdXRnOG9k?=
 =?utf-8?B?OHhjdk40aDBVenBsQTl6eXl0c25XRVd6TXlhaXo4ZzdyT29sL1lqUVNCYVR1?=
 =?utf-8?B?TE9SWVVFR0ZXYWhnOWdiOS9RNnhmYWV3dm0rMHU5aVpWM2dTNE9sSHZ6dUJZ?=
 =?utf-8?B?V2pHaWpzYko4UVZic2tjQTU1ZE56TC9VVzVPY2VIQk0zSFozMkRaSzlmdkZt?=
 =?utf-8?B?SXI1c3BGRVpDczJjVnNzYitOcmdEN0lZKzV6RGNsMmZDdGhscTdwOTlQbHE4?=
 =?utf-8?B?bWNjWXBBdUFCQnhrdUpjMndRSnlmTzZPbDFDb2NSSzc3bkpGekU3cVpiZlhi?=
 =?utf-8?B?S1FWdWFtMXJKaU5UNXVSUmJka3AybEdsUGMxejdFWXMzdGFKRHhqcksrZEtw?=
 =?utf-8?B?NS82ZGpvM0RHNlNvQVZLa1FGTi91QjhPem1LWmdTK0MvWVRKZk9FY0JJMVQ5?=
 =?utf-8?B?cHNGdVAxMWR2STlmK0tFRnUzWWlhc3dHenZEdjZKTHUzSFo0c2JJTU9lMWFG?=
 =?utf-8?B?WERJYXVGVHFUdXl3c2RPVmRoMVdjVDZCQlZFMklJVDl0RE8vZEYyN0R5Vksy?=
 =?utf-8?B?ek43Q0lKVlFydGZaSHZMQXQvYmhXQ3NZK3ZvalR2Zk50QVdzNXk3N05NeVVK?=
 =?utf-8?B?UXU4WFVYQWN6RUI2cXllUG54YzgvemZDQm55RU94Ync3d1llL3hxNG1yRFF4?=
 =?utf-8?B?VHkwT001SEhQbldKUHdkUzV0ZzJrS0ZyOWtJWUZqZTdyTWd6cUZSOGRHYk5E?=
 =?utf-8?B?SWdKekZnS24zSHJlYmFaVXVkODhjSWRtV20xN3F4aGRyNTlhLzhTTDlnYVMy?=
 =?utf-8?B?SHNDRTJtdktUVEJQSWJ5RmEzcWpoTldPSDF2emJaYzMxWVJSTkhPYlJIMVJt?=
 =?utf-8?B?dzhlVXYzczNJVVNwMEdWT2wxdCt3SXZ1ME1xN0duOFZkUTNQa2FRTmdSS1hi?=
 =?utf-8?B?dGl4VXA3TUtPVVlxVURickt1eE1EbWdacDFtVnZMMHRzNENWYVBneWdORjVV?=
 =?utf-8?B?eDJtVHBNSW56bmlVaitiNnJGMGhCVENGaDlYL1JPRVpRL0EwbkpHVkJReDFi?=
 =?utf-8?B?NlhrQlZMVkdXYWZ0UEhCN1lYeGhubFJZRlozVXRIOEFKamw1c2VyT2dBWCsy?=
 =?utf-8?B?UHNlT1JDbzZsc1lpM0IvTk5ITUZwN21HejkwZXBEWVJGNTl0TCtvOFp5TFdt?=
 =?utf-8?B?WEsraDJYd29idXpYVmVMRENuLzNTOFR3eWxGNVcralIzRzhwVWRyNE9rRmtR?=
 =?utf-8?B?OVJyNkhzU3NoL282RW1xbXBpK3c2NkJYaFRoM2ErM1dvNjNsRjR4eUhtaTlm?=
 =?utf-8?B?a2cycEVNbE9wQVNvRDJJWFFtVktKTVBYbEcyZHBIc3p3SmZBM0grZTA3ZTNV?=
 =?utf-8?B?Qk9qNGJIM2FVSGxCcE5SSEliL2p4Snk0aUk0MmdqbW1vQndwMkQyRWNRSzRo?=
 =?utf-8?B?UU1USWVxbHRwMGo1WFdJLzZxbTFXQXQwWndycW5lQ3M2V1BhNmJseUZwVE1F?=
 =?utf-8?B?R0ZSb2hhc1V3SUttbEdEdHJOUTFDUkVIUGMwMlExSUdlL0puUTdpTXQvRUhV?=
 =?utf-8?Q?BTuD37yUk9Da2p05JGtI00s8P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811c3d1d-755d-4654-08be-08da631e5c47
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:18:47.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/fEJp/7CXigCND0U+hjrZEO6PObYnp5fbtPcpWuAFimybNO5EQ7ujUhFDHIVrX8ooHKaj5Y6UAL06xlF5VvCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/2022 9:15 PM, Alex Williamson wrote:
> On Fri, 8 Jul 2022 14:51:30 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 7/6/2022 9:09 PM, Alex Williamson wrote:
>>> On Fri, 1 Jul 2022 16:38:09 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> This patch adds INTx handling during runtime suspend/resume.
>>>> All the suspend/resume related code for the user to put the device
>>>> into the low power state will be added in subsequent patches.
>>>>
>>>> The INTx are shared among devices. Whenever any INTx interrupt comes  
>>>
>>> "The INTx lines may be shared..."
>>>   
>>>> for the VFIO devices, then vfio_intx_handler() will be called for each
>>>> device. Inside vfio_intx_handler(), it calls pci_check_and_mask_intx()  
>>>
>>> "...device sharing the interrupt."
>>>   
>>>> and checks if the interrupt has been generated for the current device.
>>>> Now, if the device is already in the D3cold state, then the config space
>>>> can not be read. Attempt to read config space in D3cold state can
>>>> cause system unresponsiveness in a few systems. To prevent this, mask
>>>> INTx in runtime suspend callback and unmask the same in runtime resume
>>>> callback. If INTx has been already masked, then no handling is needed
>>>> in runtime suspend/resume callbacks. 'pm_intx_masked' tracks this, and
>>>> vfio_pci_intx_mask() has been updated to return true if INTx has been
>>>> masked inside this function.
>>>>
>>>> For the runtime suspend which is triggered for the no user of VFIO
>>>> device, the is_intx() will return false and these callbacks won't do
>>>> anything.
>>>>
>>>> The MSI/MSI-X are not shared so similar handling should not be
>>>> needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
>>>> without doing any device-specific config access. When the user performs
>>>> any config access or IOCTL after receiving the eventfd notification,
>>>> then the device will be moved to the D0 state first before
>>>> servicing any request.
>>>>
>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>> ---
>>>>  drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++----
>>>>  drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
>>>>  include/linux/vfio_pci_core.h     |  3 ++-
>>>>  3 files changed, 40 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>> index a0d69ddaf90d..5948d930449b 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -259,16 +259,45 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +#ifdef CONFIG_PM
>>>> +static int vfio_pci_core_runtime_suspend(struct device *dev)
>>>> +{
>>>> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>> +
>>>> +	/*
>>>> +	 * If INTx is enabled, then mask INTx before going into the runtime
>>>> +	 * suspended state and unmask the same in the runtime resume.
>>>> +	 * If INTx has already been masked by the user, then
>>>> +	 * vfio_pci_intx_mask() will return false and in that case, INTx
>>>> +	 * should not be unmasked in the runtime resume.
>>>> +	 */
>>>> +	vdev->pm_intx_masked = (is_intx(vdev) && vfio_pci_intx_mask(vdev));
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int vfio_pci_core_runtime_resume(struct device *dev)
>>>> +{
>>>> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>> +
>>>> +	if (vdev->pm_intx_masked)
>>>> +		vfio_pci_intx_unmask(vdev);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +#endif /* CONFIG_PM */
>>>> +
>>>>  /*
>>>> - * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
>>>> - * so use structure without any callbacks.
>>>> - *
>>>>   * The pci-driver core runtime PM routines always save the device state
>>>>   * before going into suspended state. If the device is going into low power
>>>>   * state with only with runtime PM ops, then no explicit handling is needed
>>>>   * for the devices which have NoSoftRst-.
>>>>   */
>>>> -static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
>>>> +static const struct dev_pm_ops vfio_pci_core_pm_ops = {
>>>> +	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
>>>> +			   vfio_pci_core_runtime_resume,
>>>> +			   NULL)
>>>> +};
>>>>  
>>>>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>>>  {
>>>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>>>> index 6069a11fb51a..1a37db99df48 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>>>> @@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
>>>>  		eventfd_signal(vdev->ctx[0].trigger, 1);
>>>>  }
>>>>  
>>>> -void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>>>> +/* Returns true if INTx has been masked by this function. */
>>>> +bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>>>>  {
>>>>  	struct pci_dev *pdev = vdev->pdev;
>>>>  	unsigned long flags;
>>>> +	bool intx_masked = false;
>>>>  
>>>>  	spin_lock_irqsave(&vdev->irqlock, flags);
>>>>  
>>>> @@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>>>>  			disable_irq_nosync(pdev->irq);
>>>>  
>>>>  		vdev->ctx[0].masked = true;
>>>> +		intx_masked = true;
>>>>  	}
>>>>  
>>>>  	spin_unlock_irqrestore(&vdev->irqlock, flags);
>>>> +	return intx_masked;
>>>>  }  
>>>
>>>
>>> There's certainly another path through this function that masks the
>>> interrupt, which makes the definition of this return value a bit
>>> confusing.  
>>
>>  For our case we should not hit that path. But we can return the
>>  intx_masked true from that path as well to align return value.
>>
>>> Wouldn't it be simpler not to overload the masked flag on
>>> the interrupt context like this and instead set a new flag on the vdev
>>> under irqlock to indicate the device is unable to generate interrupts.
>>> The irq handler would add a test of this flag before any tests that
>>> would access the device.  Thanks,
>>>
>>> Alex
>>>    
>>
>>  We will set this flag inside runtime_suspend callback but the
>>  device can be in non-D3cold state (For example, if user has
>>  disabled d3cold explicitly by sysfs, the D3cold is not supported in
>>  the platform, etc.). Also, in D3cold supported case, the device will
>>  be in D0 till the PCI core moves the device into D3cold. In this case,
>>  there is possibility that the device can generate an interrupt.
>>  If we add check in the IRQ handler, then we won’t check and clear
>>  the IRQ status, but the interrupt line will still be asserted
>>  which can cause interrupt flooding.
>>
>>  This was the reason for disabling interrupt itself instead of
>>  checking flag in the IRQ handler.
> 
> Ok, maybe this is largely a clarification of the return value of
> vfio_pci_intx_mask().  I think what you're looking for is whether the
> context mask was changed, rather than whether the interrupt is masked,
> which I think avoids the confusion regarding whether the first branch
> should return true or false.  So the variable should be something like
> "masked_changed" and the comment changed to "Returns true if the INTx
> vfio_pci_irq_ctx.masked value is changed".
> 

 Thanks Alex.
 I will rename the variable and update the comment.

> Testing is_intx() outside of the irqlock is potentially racy, so do we
> need to add the pm-get/put wrappers on ioctls first to avoid the
> possibility that pm-suspend can race a SET_IRQS ioctl?  Thanks,
> 
> Alex
> 
 
 Even after adding this patch, the runtime suspend will not be supported
 for the device with users. It will be supported only after patch 4 in
 this patch series. So with this patch, the pm-suspend can be called only
 for the cases where vfio device has no user and there we should not see
 the race condition.

 But I can move the patch related with pm-get/put wrappers on
 ioctls before this patch since both are independent. 

 Regards,
 Abhishek
