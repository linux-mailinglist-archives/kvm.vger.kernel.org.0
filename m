Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50956FF50
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiGKKnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiGKKnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:43:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4866A3245D;
        Mon, 11 Jul 2022 02:51:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGw07YBptcAfWhF7DxXL3Qb9OHL9LRvoDsxPizP2FantDVHogS8FSJ0xjm+kHLArsi11IBY0Pvp0GlxlgYZhnuL7nlKQ2OeZARMMZ6tWl9xRWjIOjyrIeShmBDCXoFwaYnelAJne4bAZybxVdjSIR0UQsgADc9rqjaCUy7rSBxSTOaXxo52Cej2/w2rX+ILzQwD7wNBt8MSJsBQaJUX1ed0A6B+sSniXP0li1auGH0+MQ1y7HAxw7S6Gk3MQx8cBmcnB/1o7+PbtUo4inNNWx3wYGztg2HajeYh7k+qHzbEbkyf76Qk1/MwoWk9wsbql9yMK6cmFb3809Z5ddfPvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ts3jWLhID2SF2SsTTbu4OY4BIqN2iaadxyh9LwLq4O8=;
 b=klwNQ2sZbJ4R0mh9lResZJhYJ3xtDsCqWSXifwWpjYVmtLB8somgRnoPRj/9hqXA143XNHWiCq7durvyBOxPwb9lbVGnvfGcr5TMNS6l4EntiqnZXSw/tpoJ6KlgF2KrANury+azO7eUTWBvW19tYWJAfOmSDIEf/Kk2wbpdzvUsdIRo3gBwtHkjhKn8pP9ScRzvmZ7x/MZQSXvpPnf5mPiT+oWDT3JmHoXxK1uYTMC/7vgdFFpFh+Nnp67S5VRaY77Q3NkN1R814Cin6kVco6ZNahcBhm5F1m7eGWCZu3GUi8MsEcNG0JZdqhnHLwbykOKoS5UBL0QVeYnkTZuUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ts3jWLhID2SF2SsTTbu4OY4BIqN2iaadxyh9LwLq4O8=;
 b=grBGGrAvpj/ET8GKJ6a0cG1l9m0+f4fMGwMjlrLsgLitMubHglcE3RQexhOt4U4RBN8xTtKY9AeenHLhDJG7NST81k5Tqhol9y4IVky+QqbYJ0XNk6SKGpLgWWMgKtPn0EdBaC70Eqd7HpUN53Z1D8yl0gBxZ2Uwd+Q1Q8d/rj/oOi3OE31iY3XPXZ/NVIxYUs9nXcqOEmBexyZAC/X0AGuIgXd0QUTDXWetStPmwwJepiJsYg3+CW8/n1CbauIFSa6HzOOOU6NMRGh3s+jbrL1txWelVeO09j/s1SNhgi+/nEOfG+QTqc2MYuETgR8Z9yxK0eF4/ZC/cjI6B6CdJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MWHPR1201MB0112.namprd12.prod.outlook.com (2603:10b6:301:5a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 09:50:58 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 09:50:57 +0000
Message-ID: <5dc17961-584a-1ac5-5742-6f7709876eb4@nvidia.com>
Date:   Mon, 11 Jul 2022 15:20:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 3/6] vfio: Increment the runtime PM usage count during
 IOCTL call
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
 <20220701110814.7310-4-abhsahu@nvidia.com>
 <20220706094007.12c33d63.alex.williamson@redhat.com>
 <47aa6b7d-e529-b79a-54eb-5f5a7fe639d6@nvidia.com>
 <20220708104900.1780b8d7.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220708104900.1780b8d7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::9) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 785f3ae9-eb08-44ed-165c-08da6322daae
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0112:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wsa5KiL8qfg9tjak6EGN9obAuhccgE+oQCLEVWQW8LeS9GGTaYvImm39zuJpuXDcoa8uQ6s8CPpX0ExxoncvGyqbsdMCvXTKWy0v5Rcxk8zJsruGPfbIy+/Bp3h0plOhKsN+zK9csUPaVl39YVLclwT5QXaNg6ZE2zZqiD7T/YC41LAq//OEjdDTicccmrHO4oSK+kgykoGXd1cc9a0WqopK0f/KULUndrb8hwofmKcUmMr3uIMDa91+KoV0IaZOXwy9vpzJhQMC0Fcp4tZ511Xj1Gxmb1LRYAlXI6ZAcGwHCqG+7tXjGBam+toSmI25fybeQ98nWNZXWeDYqAc95gSkrepF3x9NKv8yjVkHRgRmojfS3t04dtYPESbgrEbHiFZmsBt3QkMIs1g1kNNGrXUaDXkVXx5unDF6HUD+xvQy5tK/mVZ6VYQaJ688d8tkMwbZ5dW2nMTK2icKU/nmQbpV2ZvPQ8VeNbCQNhFn8cPDtiV59ncRyYKmUkrafKNdyOqBGUjV9FlL+y0QdGN9eeAGQgSke5bT4+guURK7GS6vxexikH+3BV/2lQpeh8+1ql6qnlYO8WQjyhcX1+tnCnLr25MAVfG3CNvaaEH3IPkgLk4y8G5gcWFhwjUKR+AUEEL8GPVmhQO+LVlJUu4xS0b73UebJurR+ZgtGHnaVeBYjHrnQQTrkmCcH9DF+ABX5jxZlx/rXl70iB+pU+qE1sJHGym8aOqA+DSXJK39Se3H7QyBbbD0ce4pXh4MlA4140nSPqqSZq4GvksZ8fhPY755Ckh873D0nTMBSYDA06jKiENEjhA3oX/99BFG+Xf2ZJDYGTyU3mH+HMr1XIJ8MxGtnmjagDQHTj0NlroIH68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(2906002)(36756003)(8936002)(31686004)(5660300002)(7416002)(6486002)(66476007)(4326008)(66556008)(54906003)(86362001)(316002)(6916009)(6512007)(8676002)(66946007)(478600001)(55236004)(186003)(6506007)(6666004)(41300700001)(53546011)(26005)(2616005)(38100700002)(31696002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0YvZkFKdDl3NkdxSWJmcis2VVovVGZoQWdVQzV0SXM2ZnR1N3hIdVFVdzE2?=
 =?utf-8?B?VHlVQVZSSWZveHR0Vy80aUI1N1pFNWQya2hYSDNVbXplV0V2V0ZxMmJJY1FQ?=
 =?utf-8?B?amhaS0xuL2gzOW5ER3AzVjJacUVtbTZWeHpwTEg0eUdwazlFRW05aFVxbTFt?=
 =?utf-8?B?S3ZaWk9PNmlDd1ZIaGxsTFhvbExyTmp2LzhhMTlLWmJnSnNxYTJYcmhCTzV6?=
 =?utf-8?B?SkhzeHZMaXpvWmhQQ2ZudG8vVlBBYlFTMERZMW42a2RCamVLbUxkUnhlK2tK?=
 =?utf-8?B?MDFEVkZrbUNzNTNVclpCTE9iRmpaaG1yZ1lRZzBxdkpVMkJzYVlWV08zcytr?=
 =?utf-8?B?Z2JVNkp6QlJ3dzdtVGNwbFd4cEhMU29lTUg5V0t3NWpoSFJiNkxrVUJCZWN0?=
 =?utf-8?B?dkdiUCticEt0WXNZVlZ5ZzBqQ1ZhTTJaTU51djk3VEdncjNIbXRkSytQeDJH?=
 =?utf-8?B?VkQzc1dDcVFtWWVSN3owbnpaWW1iKzVITXFad1ZVdkFOUCtXT3EybXJFMWxu?=
 =?utf-8?B?NDF4YTc1Q3pUamludWw5Rk5obGt5TkU0dnNsVlJPd243a1ZwSnRmaVhUKy9N?=
 =?utf-8?B?Q0dCRm5tOWlxZ2Yzc0h0VFlMVGVqQTFvUWtRMitraS9BeTZpQzA2djhOTFV4?=
 =?utf-8?B?T2pMZkFCRmxweUI2K0ZkaUlqQkJMcWNHQ2grbnhYS1RCM2JaREdVKy90NWdu?=
 =?utf-8?B?dzhVcHlLTVlaaXJwcVVxQWxWTEFyT0E1eExzQ0plejFaSVAvUjFyZUJDaUd5?=
 =?utf-8?B?YjRkU2dlZkFTN29TdkZZb2NkS01VakRTQmUxVk0xZWFzVTNEMFMyZ3d3dHAv?=
 =?utf-8?B?aFBYMG9iVENOVzgxei9rSTZaU3pMZzFSd0ZGSGwvMjA0ajZMTEZpY2tJclMr?=
 =?utf-8?B?TU1GdFpFSUpoc1ExbmxnVnlvSitGQ0JkdDZJdjBFUEhDdlR6cUMxTGljTW5H?=
 =?utf-8?B?dTRJc2VKVStHcVA1SW5qQ0pxYy9RT3Fqdmk2a0hZWnJLNEpqSS9TR2Z0NFpk?=
 =?utf-8?B?SGRLU2VHR2FqVU9oc1huMlM4cExhbmVwTmJ6K1lLd3N6bXVMb3h1YlFyekZj?=
 =?utf-8?B?SitmWlZLaFk2a0Y2SzBsVzNENkFJeWtrdkFwZ01rMnFSZytydThleEFzYThS?=
 =?utf-8?B?c2k2YjBVZmZXaHFUSkF6TjFwbVlXSGgyQU5HcVJMR2JvalgxRVhibnhTSGRV?=
 =?utf-8?B?MitidU9UdXB0MTF3YXg0ZUIzWVd4NXdUUktrS01lMUNkbWhSWGxkRVRNeXJi?=
 =?utf-8?B?VzdYeG9RQVZETkdOOWowN1RvbTdxODlTMy8rQ2JvaW03NGd3cjhEMkV5cEY1?=
 =?utf-8?B?cGJWQnlVSjJ3S29HbkduZk9YeElhRy95bzM4ZEtkUFBTVi9rNC9ETUg2TjZC?=
 =?utf-8?B?djJSSXJFYVhPQzUyZjdqQkoxUEdQcGlTcDlIbWZPWGU2Y2xVUFZ1SE53Qjk2?=
 =?utf-8?B?SFNNTG4rV05vWSt3amROVTlLWDk0Qm9BTjljOHp4Sy96QTZSUDA5dlNxdXQ1?=
 =?utf-8?B?ZDJiNmdTZ3M3UlZQYXdTNTl3RkJpZFJqZG9sTVVkbXYxUFZCTGpxVlEyZ1dF?=
 =?utf-8?B?aHE3ZjVsWUw1MEdkcENwL1J1T3hxcnVSc21zYU40aGRPekRLZXA3Y3pJQTFW?=
 =?utf-8?B?OE5BdW8wdm0xdG5NeEpPWDV5YlV2STkzWXhmSHJyTWFKeVZOdmhFV1lOemRa?=
 =?utf-8?B?cVNmNFB6cXV5ZmlNb1BxS0VUakhSdC9kRHFscitld2JuSE5VUDYvc2RCME8r?=
 =?utf-8?B?em9lczc2bG53RHl1TVhNOWFjOXppbkNlSXV2QVhuSXpvbWRKM0l1Mzh5VVBJ?=
 =?utf-8?B?WjF3Tmt5RkFKaDNRNTErb2t4bk4wOEJROUwxVG11UW50RGhjeG1zMnRVV3la?=
 =?utf-8?B?bTFsMzdwNXM0NGNWZWxJYjIzbVFmdEM4allpSS9vd3VnOTBZVWZLQmdHM0Fz?=
 =?utf-8?B?RTRVSGdRUFNTd3NPUjRiZ1VWby9iYkdPcC9NQW9PaE10WGxhUFVQS0c0a0Rj?=
 =?utf-8?B?N3d0dEdmUU9kOGJWQk03WHdkVHdTNStKbURQcHRSQ0wxVXBoVmlOZndtV0xP?=
 =?utf-8?B?bjRIUStqVyt0RENYQk1UM3lvOCsySmFkSHErRGRoN1FlNmg4L25HbFB5VXoy?=
 =?utf-8?Q?tVmMYgF5wvWKHyAi/c1ZjO9Hh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785f3ae9-eb08-44ed-165c-08da6322daae
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:50:57.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErGqB6OS7Cnj5ZnsgmtCZugThNfrd/MjARoWiCKxhc7EyLY5jnuNaL0Q0wGLZuIr/V5ILMt+YmvkwJ/tApArHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0112
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/2022 10:19 PM, Alex Williamson wrote:
> On Fri, 8 Jul 2022 15:13:16 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 7/6/2022 9:10 PM, Alex Williamson wrote:
>>> On Fri, 1 Jul 2022 16:38:11 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> The vfio-pci based driver will have runtime power management
>>>> support where the user can put the device into the low power state
>>>> and then PCI devices can go into the D3cold state. If the device is
>>>> in the low power state and the user issues any IOCTL, then the
>>>> device should be moved out of the low power state first. Once
>>>> the IOCTL is serviced, then it can go into the low power state again.
>>>> The runtime PM framework manages this with help of usage count.
>>>>
>>>> One option was to add the runtime PM related API's inside vfio-pci
>>>> driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
>>>> different path and more IOCTL can be added in the future. Also, the
>>>> runtime PM will be added for vfio-pci based drivers variant currently,
>>>> but the other VFIO based drivers can use the same in the
>>>> future. So, this patch adds the runtime calls runtime-related API in
>>>> the top-level IOCTL function itself.
>>>>
>>>> For the VFIO drivers which do not have runtime power management
>>>> support currently, the runtime PM API's won't be invoked. Only for
>>>> vfio-pci based drivers currently, the runtime PM API's will be invoked
>>>> to increment and decrement the usage count.  
>>>
>>> Variant drivers can easily opt-out of runtime pm support by performing
>>> a gratuitous pm-get in their device-open function.
>>>    
>>
>>  Do I need to add this line in the commit message?
> 
> Maybe I misinterpreted, but my initial read was that there was some
> sort of opt-in, which there is by providing pm-runtime support in the
> driver, which vfio-pci-core does for all vfio-pci variant drivers.  But
> there's also an opt-out, where a vfio-pci variant driver might not want
> to support pm-runtime support and could accomplish that by bumping the
> pm reference count on device-open such that the user cannot trigger a
> pm-suspend.
> 
>>>> Taking this usage count incremented while servicing IOCTL will make
>>>> sure that the user won't put the device into low power state when any
>>>> other IOCTL is being serviced in parallel. Let's consider the
>>>> following scenario:
>>>>
>>>>  1. Some other IOCTL is called.
>>>>  2. The user has opened another device instance and called the power
>>>>     management IOCTL for the low power entry.
>>>>  3. The power management IOCTL moves the device into the low power state.
>>>>  4. The other IOCTL finishes.
>>>>
>>>> If we don't keep the usage count incremented then the device
>>>> access will happen between step 3 and 4 while the device has already
>>>> gone into the low power state.
>>>>
>>>> The runtime PM API's should not be invoked for
>>>> VFIO_DEVICE_FEATURE_POWER_MANAGEMENT since this IOCTL itself performs
>>>> the runtime power management entry and exit for the VFIO device.  
>>>
>>> I think the one-shot interface I proposed in the previous patch avoids
>>> the need for special handling for these feature ioctls.  Thanks,
>>>   
>>
>>  Okay. So, for low power exit case (means feature GET ioctl in the
>>  updated case) also, we will trigger eventfd. Correct?
> 
> If all ioctls are wrapped in pm-get/put, then the pm feature exit ioctl
> would wakeup and signal the eventfd via the pm-get.  I'm not sure if
> it's worthwhile to try to surprise this eventfd.  Do you foresee any
> issues?  Thanks,
> 
> Alex
> 

 I think it should be fine. It requires some extra handling in the
 hypervisor or QEMU side where it needs to skip the virtual PME or
 similar notification handling for the cases when the guest has
 actually triggered the low power exit but that can be easily done.
 
 Regards,
 Abhishek
