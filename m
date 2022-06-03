Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F4153C885
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbiFCKTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 06:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243635AbiFCKTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 06:19:45 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0D63B3D1;
        Fri,  3 Jun 2022 03:19:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTN8fbRsigS+lpkbgMRwytGRLHh549SS5d73/4xWU6FnLBqf+H7XQb88chE2CS3ROJ+Ln5aIKa5Z9CJGJrJ/SMepaOrMXQmOImqgzV4zQtXW3Q1kWsaD37mU/qptJMi6DTrtTvbXyiZcWSK2lIpItLmuacsF7R6quUH0goK0Lvesm6L92Hk+Y5Dy0i++MQlnc3KfvDasKuM6u3+Dezr+o71GyARpzHvamrTJYFkdhF2tGzSjS1DrlnHmopUntbJpcamka7rL29CxBFNhAPS7aGv9L9S9O4+vo2KYTdpoT+AG0vz99zcvvzJizOK45ubP3WgIBcbm8C6A/XpubD8Jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVon++x5BOLB2Ak8zxy+7hpRJcFNM+/fwHHaaR7lrKQ=;
 b=W4BW2gQfT7q8dWuauWkrxKgQNqBYoA0LMf/WZV0Xy5rmnJTwA6rKsQhGHH+YJNQcz2SJl8A4Csbm+/v5TiI6pDt0KTXOa1cydvuns5UZwRTXZ7ucpSeuVcQLhoMH9mo9IwSVUDqqN3O0N4tgD6pGLxvt7RJE8VMd1PwcELUdZ7hiLu005kXyGxp3FMDJh9GiFu9C1AwDuZ0viaePmM3UNZmjwtlv9cpcwbDif58fzZ19l0pYvpEu3LUSgXpzrvRIFyr97oBvg0igpG/it02C6LHzhqKdhtPDnNq9v++PhtbLHCWrdEziFCMce2JZnaKHzdGhrEILjLHcPeYnKAmx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVon++x5BOLB2Ak8zxy+7hpRJcFNM+/fwHHaaR7lrKQ=;
 b=Rvk0K2ZzlRHwN/QZG43KqY9GiCSURgZQVYtoYVI18S+eacxLVQO2Ypr/9D/2aYhJ7ttOa92GYHR+F7V2aAKakpw3PHgIvGB3l80OSWpXLRx/SLJseftb7R+5OY9ZOzvkBxh55dG5PlkesQckUxhMZVRlKV8FRgrxY0FAsyFv1rxSinB1qd+jusBCTxcpR/SQJAnB0s755EIG2Vw0gKtIH+kT64pVQAOTpKTSRg+Ba1GiAciE0rLDuVQrxn/oNzXVSUAM6rsnqRbyYct7/6YV7r5VpLb4TaE4rOwOJsqLWqDqJWOL/rvINjdikAPL3oelfrJEA8eHcHfA5ylQtuS1jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by SA0PR12MB4541.namprd12.prod.outlook.com (2603:10b6:806:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Fri, 3 Jun
 2022 10:19:40 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%4]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 10:19:39 +0000
Message-ID: <8d2d34f5-8b5d-0b85-4603-d65160427bf1@nvidia.com>
Date:   Fri, 3 Jun 2022 15:49:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
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
 <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
 <20220601102151.75445f6a.alex.williamson@redhat.com>
 <088c7896-d888-556e-59d7-a21c05c6d808@nvidia.com>
 <20220602114412.55d1e2c8.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220602114412.55d1e2c8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::8) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31b5dc4f-6a2a-4fd0-97c2-08da454a9168
X-MS-TrafficTypeDiagnostic: SA0PR12MB4541:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB45411A2C1D1A3B8F2813E494CCA19@SA0PR12MB4541.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D21JmhTw8I1H2Sw5IB6T/enT59iWxPDImRk1Bu0Vu03dgU3ARYiX8fy4Hgwug03/9TVhqn068Sea/I2RGQ11xhbB/eOA1p5RmSbTjV+Q9GEPw4w8hlQsEkAFnhyRyUAXA09JEgpcmt8j2ioDY2yF2RkYxqAeUtNSiArmhMs0OJLn3p7NOfZtlMI6DFXW3I4zCSZcQzQ52VlNC9MB7Bg0cwjdsaZlZd9oS9epfbhsjpm6B5p+9QdxKEZukqukh2kdzsivI0dK/rssthbdwhR5HUNtuB0pmT2cljz+1GhvCDzcAt3vdLth4IkugJW178IPom8MmYI0ljNVqe7wE26REk4/pvgs1hNnPFpX2oVvFPd2H4Ex4OB+Z7sMBBmWtc8j5Mqdcc6g5v8xOp9OwC8fXKhSHQwsNlryYmEodpteLkI7he3qL2oqfNvchwQHlisSkEvEP0ITM/TGWOankogsg6U2UtRVyiKUlvokYsRTZFhkPKN6ftnwKj2oJRGNat2u1LsdOrwia/7PQCbfgL8ghMBxb8ebbIt14Wt4jNUDwb4L07KTA1GEl6G6m5kuTzht1JrYAGz/GB4uM/q7tV9HnthYbMxy5f1UWTRVyYDCFwgur2LKmA1W/hkaJx7TAgMIGQJWZbPpRyzZiGIN4vVuZRSyAbcas0nYd7oFttVv8DXscMQ3GewzbGzjLzBXDENZvbWMf/Gjl25rEbGqYUTn5q/5Xf9amzXbE0DDRjdQp+EqOvhGx0l5H3lsv3KcSNuULrZ/M9j+Vw6l4BNJEHjHvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(54906003)(38100700002)(316002)(36756003)(186003)(6916009)(5660300002)(30864003)(66476007)(2906002)(8676002)(66556008)(4326008)(8936002)(7416002)(2616005)(6506007)(53546011)(55236004)(26005)(6486002)(508600001)(86362001)(31686004)(31696002)(66946007)(83380400001)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWt1ZE5kQ0NpeW90N29vTHFJbGwreHJJTm5xdjJBTjR6RU1BTmxpWlJLaThr?=
 =?utf-8?B?RWJoV1dVY25LK1JCRWpSbW1wTUl2aFdQMzJucU81YisyUTBDZ25FYlJSUUlS?=
 =?utf-8?B?NUpxaEV1ZW1UdlJSbElFT0dzbE0xYnpPZGgyZDBMajVGRlV3eXc0VDZCMnJK?=
 =?utf-8?B?S3lXNDc2ZkZhZ1ZGQ2tCNUgvUWxoaks3RjRjMkw2SmtlMUZENXJlL2tnVkx3?=
 =?utf-8?B?RTBMdE5LMVNYNG5XakMweWl6UytiL05RVG8wK1EyNHloNzVRQnBKNjlBaDZa?=
 =?utf-8?B?eTVUTXFEUkZGaS9OUlU5clZxLzBQWlZiYXRPa2ZqRU1tWm53L2VQUG54Q0Yz?=
 =?utf-8?B?RVlWL2k2YncxVldRcU9wZVFrUzdubEU0WGNSYmhZcVh2eERkZHlXTTJ4Z05p?=
 =?utf-8?B?NDBReTFTMW9YbCtSTDhQY0RQQ1JEckZSMFhUTUF4ZTdlNk5TaEpyMHR6RGZz?=
 =?utf-8?B?STZTUFhBcFJzVEo0cUt6bk5IVmpkRnpCVUU4MVZKS2ttN0JOY201WXc2RDdG?=
 =?utf-8?B?ZndDVW5zWEY4S2ZqM1IrWlJuS1lCNWUyU1NDZURaczdEeHlQcENkUDFHSm5u?=
 =?utf-8?B?NmZZS0pORjRNMFo2Q01ETEN6b3cxYjlZODJvbHV1UjUzbDNocm1QRnFMNmln?=
 =?utf-8?B?NXIwZ2ZpcitBMUo2elhTZnBIY05WTllBMThiNG0zR2t3Z1RSb2Z4V0RpYWlI?=
 =?utf-8?B?YStqaTkwY0cxdWU5Nk80RFNUNmx4RGJvM1c1YzFHcG9EN1AzV21OaVdSVFV6?=
 =?utf-8?B?YXZobzNERUVLbzRHcjdlTzlENXJjTVcyM28vY2JNbFpmSUNIbmpMd05uRGFE?=
 =?utf-8?B?eGliUE42d1grckRYMEVlUWdoMTVRNkN4cmRzZGVEZGpjbWJ1RlZ1WGNQSUFM?=
 =?utf-8?B?R3VHQ1JqL1hCcndrckNHK0R4STZFeWZsc0xHdEpRTlQ4MWNTVlJoRVFLelVp?=
 =?utf-8?B?UnNxajZMYXIzWkJWUlhrTGZMSW95djVMNjh1ZFY5b0JYcWo2cVorYU9RTEdH?=
 =?utf-8?B?WUJxdk8vZVQ4L1RYaGV1c0hyTDZpYTZ3SmFvWE9VSnBtSU9jQk5pWlMwWUE0?=
 =?utf-8?B?QmhGR01OQnZDSDBZemMzOGUxQTF2dnI4dUppM0taMHAzWEp2bUxvaUN4Tjc5?=
 =?utf-8?B?MHFScG0wMGs5bEFlY3p5QmIramdWOTludkJVWUpvbGN0NXdMSzBJQUVMd2s1?=
 =?utf-8?B?Z2o0S25xOUNPRCtGUGdIM25zVU5MKzZKYm5HbGNQR0lldGxTMlNNYVRYN2Nw?=
 =?utf-8?B?ZHFyY2xSK0dHSUorL3dEU0xKQkxJcGJ6UlN1WElYamRPRTJTRU5zN0NxNXJo?=
 =?utf-8?B?Z2NwaHdZejFXaS9vRW03aGlpSWJKKzdKbCtnREdETE03d2l3aERKT1Z4bHZF?=
 =?utf-8?B?bHRVUC9uQjZDWDBrODBoaEhrRktoSkx2NkJDMTJZVHIzOS9NM2pRZXpCcHYy?=
 =?utf-8?B?dGtsTTd6amQxY2NYWkFMeEJveVhrRG0xSVdpelNic01sVnk3S2laR3NlcDU3?=
 =?utf-8?B?ajgxRWdjR3VHT0pqTDVWcGowWUtTR21VWENYZ3NaaTZjVW1BZkE0VFdIZlUy?=
 =?utf-8?B?Q3Z5TE52bkZYaDFGRTh2WVltQ2Zka2swM1JtWktRZ0o5c3Bzck1CK1UzTExM?=
 =?utf-8?B?anRNTGxUNi9GbUFRS0lEbVBHTTVSaThSUU5SQXZQUlBIL3ZwRitoeXhBRldQ?=
 =?utf-8?B?SDhhVG5jbHQyUEJ2bkV2TFN2NzFpVHE5a3lmQ05rTHQwcExuaExaOW1aY0pk?=
 =?utf-8?B?L2VGWTBwcFg4Uks1aW5ZUTYvcEtDNm0zN1JxazBRU1creFc5SjhML1VPcWx3?=
 =?utf-8?B?cWtMcldmbnU3alJXNmpWTENaZHBoOVF4eHhFVTh5WUdadE8vN2FRWVcwd01n?=
 =?utf-8?B?dzRGQjZ4SXppTWZEYnkxL1B4WTJPZjhTNHNHQW9kZVJRR2pFZ3ZpdHZibGN6?=
 =?utf-8?B?ZTc0bzFQSE9lYnh6MVVrd3diRTdzS29GMU92Z2RlR1kzNEtuSE9VRkJjdlFq?=
 =?utf-8?B?b1FqMGtZYXJ6OUJ6a2duaEFXaEc4NGx0aUd3RDg0NFpjdWpKMTN6M0dZeVAy?=
 =?utf-8?B?cEtXRndRSmZ4VFJSdXZ3YUFCR2tsV0hsUjJ0RDh3RVJyYUo4U2RiMTJZVHZB?=
 =?utf-8?B?aWcxZmhBRFZuSTlZKzBXRllIdERoN200YlpPT1puVy9IZUtiaWZ6NjJ3ZHJX?=
 =?utf-8?B?cXdWN0R4RTdUMExKQkhXQTZzcFlyQllCYSt6UzNyeS92UjNsamhwRkUxTEJ0?=
 =?utf-8?B?cTNveUdpVTlFNU10ekdscExvNHRxRUtGS09QQXJsNGNQZE1iYTZCUTVJZWsw?=
 =?utf-8?B?ZzJZblp6NGJucjYvcmN3U0NNMGUyQkd1MkMvRHdNeTRhamF5UGtFUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b5dc4f-6a2a-4fd0-97c2-08da454a9168
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 10:19:39.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgTbLieROyk6tyaa5wHIZrzPl8d0dND8yVbN/hnjjRHSSib8huXmP6OMRMoUVG9vXxMwNQfWx6YKO9HWhQZS5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4541
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2022 11:14 PM, Alex Williamson wrote:
> On Thu, 2 Jun 2022 17:22:03 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 6/1/2022 9:51 PM, Alex Williamson wrote:
>>> On Wed, 1 Jun 2022 15:19:07 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> On 6/1/2022 4:22 AM, Alex Williamson wrote:  
>>>>> On Tue, 31 May 2022 16:43:04 -0300
>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>     
>>>>>> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:    
>>>>>>> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:      
>>>>>>>> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
>>>>>>>>       
>>>>>>>>>  1. In real use case, config or any other ioctl should not come along
>>>>>>>>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>>>>>>>>>  
>>>>>>>>>  2. Maintain some 'access_count' which will be incremented when we
>>>>>>>>>     do any config space access or ioctl.      
>>>>>>>>
>>>>>>>> Please don't open code locks - if you need a lock then write a proper
>>>>>>>> lock. You can use the 'try' variants to bail out in cases where that
>>>>>>>> is appropriate.
>>>>>>>>
>>>>>>>> Jason      
>>>>>>>
>>>>>>>  Thanks Jason for providing your inputs.
>>>>>>>
>>>>>>>  In that case, should I introduce new rw_semaphore (For example
>>>>>>>  power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?      
>>>>>>
>>>>>> Possibly, this is better than an atomic at least
>>>>>>    
>>>>>>>  1. At the beginning of config space access or ioctl, we can take the
>>>>>>>     lock
>>>>>>>  
>>>>>>>      down_read(&vdev->power_lock);      
>>>>>>
>>>>>> You can also do down_read_trylock() here and bail out as you were
>>>>>> suggesting with the atomic.
>>>>>>
>>>>>> trylock doesn't have lock odering rules because it can't sleep so it
>>>>>> gives a bit more flexability when designing the lock ordering.
>>>>>>
>>>>>> Though userspace has to be able to tolerate the failure, or never make
>>>>>> the request.
>>>>>>    
>>>>
>>>>  Thanks Alex and Jason for providing your inputs.
>>>>
>>>>  Using down_read_trylock() along with Alex suggestion seems fine.
>>>>  In real use case, config space access should not happen when the
>>>>  device is in low power state so returning error should not
>>>>  cause any issue in this case.
>>>>  
>>>>>>>          down_write(&vdev->power_lock);
>>>>>>>          ...
>>>>>>>          switch (vfio_pm.low_power_state) {
>>>>>>>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>>>>>>>                  ...
>>>>>>>                          vfio_pci_zap_and_down_write_memory_lock(vdev);
>>>>>>>                          vdev->power_state_d3 = true;
>>>>>>>                          up_write(&vdev->memory_lock);
>>>>>>>
>>>>>>>          ...
>>>>>>>          up_write(&vdev->power_lock);      
>>>>>>
>>>>>> And something checks the power lock before allowing the memor to be
>>>>>> re-enabled?
>>>>>>    
>>>>>>>  4.  For ioctl access, as mentioned previously I need to add two
>>>>>>>      callbacks functions (one for start and one for end) in the struct
>>>>>>>      vfio_device_ops and call the same at start and end of ioctl from
>>>>>>>      vfio_device_fops_unl_ioctl().      
>>>>>>
>>>>>> Not sure I followed this..    
>>>>>
>>>>> I'm kinda lost here too.    
>>>>
>>>>
>>>>  I have summarized the things below
>>>>
>>>>  1. In the current patch (v3 8/8), if config space access or ioctl was
>>>>     being made by the user when the device is already in low power state,
>>>>     then it was waking the device. This wake up was happening with
>>>>     pm_runtime_resume_and_get() API in vfio_pci_config_rw() and
>>>>     vfio_device_fops_unl_ioctl() (with patch v3 7/8 in this patch series).
>>>>
>>>>  2. Now, it has been decided to return error instead of waking the
>>>>     device if the device is already in low power state.
>>>>
>>>>  3. Initially I thought to add following code in config space path
>>>>     (and similar in ioctl)
>>>>
>>>>         vfio_pci_config_rw() {
>>>>             ...
>>>>             down_read(&vdev->memory_lock);
>>>>             if (vdev->platform_pm_engaged)
>>>>             {
>>>>                 up_read(&vdev->memory_lock);
>>>>                 return -EIO;
>>>>             }
>>>>             ...
>>>>         }
>>>>
>>>>      And then there was a possibility that the physical config happens
>>>>      when the device in D3cold in case of race condition.
>>>>
>>>>  4.  So, I wanted to add some mechanism so that the low power entry
>>>>      ioctl will be serialized with other ioctl or config space. With this
>>>>      if low power entry gets scheduled first then config/other ioctls will
>>>>      get failure, otherwise low power entry will wait.
>>>>
>>>>  5.  For serializing this access, I need to ensure that lock is held
>>>>      throughout the operation. For config space I can add the code in
>>>>      vfio_pci_config_rw(). But for ioctls, I was not sure what is the best
>>>>      way since few ioctls (VFIO_DEVICE_FEATURE_MIGRATION,
>>>>      VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE etc.) are being handled in the
>>>>      vfio core layer itself.
>>>>
>>>>  The memory_lock and the variables to track low power in specific to
>>>>  vfio-pci so I need some mechanism by which I add low power check for
>>>>  each ioctl. For serialization, I need to call function implemented in
>>>>  vfio-pci before vfio core layer makes the actual ioctl to grab the
>>>>  locks. Similarly, I need to release the lock once vfio core layer
>>>>  finished the actual ioctl. I have mentioned about this problem in the
>>>>  above point (point 4 in my earlier mail).
>>>>  
>>>>> A couple replies back there was some concern
>>>>> about race scenarios with multiple user threads accessing the device.
>>>>> The ones concerning non-deterministic behavior if a user is
>>>>> concurrently changing power state and performing other accesses are a
>>>>> non-issue, imo.      
>>>>
>>>>  What does non-deterministic behavior here mean.
>>>>  Is it for user side that user will see different result
>>>>  (failure or success) during race condition or in the kernel side
>>>>  (as explained in point 3 above where physical config access
>>>>  happens when the device in D3cold) ? My concern here is for later
>>>>  part where this config space access in D3cold can cause fatal error
>>>>  on the system side as we have seen for memory disablement.  
>>>
>>> Yes, our only concern should be to prevent such an access.  The user
>>> seeing non-deterministic behavior, such as during concurrent power
>>> control and config space access, all combinations of success/failure
>>> are possible, is par for the course when we decide to block accesses
>>> across the life of the low power state.
>>>    
>>>>> I think our goal is only to expand the current
>>>>> memory_lock to block accesses, including config space, while the device
>>>>> is in low power, or some approximation bounded by the entry/exit ioctl.
>>>>>
>>>>> I think the remaining issues is how to do that relative to the fact
>>>>> that config space access can change the memory enable state and would
>>>>> therefore need to upgrade the memory_lock read-lock to a write-lock.
>>>>> For that I think we can simply drop the read-lock, acquire the
>>>>> write-lock, and re-test the low power state.  If it has changed, that
>>>>> suggests the user has again raced changing power state with another
>>>>> access and we can simply drop the lock and return -EIO.
>>>>>     
>>>>
>>>>  Yes. This looks better option. So, just to confirm, I can take the
>>>>  memory_lock read-lock at the starting of vfio_pci_config_rw() and
>>>>  release it just before returning from vfio_pci_config_rw() and
>>>>  for memory related config access, we will release this lock and
>>>>  re-aquiring again write version of this. Once memory write happens,
>>>>  then we can downgrade this write lock to read lock ?  
>>>
>>> We only need to lock for the device access, so if you've finished that
>>> access after acquiring the write-lock, there'd be no point to then
>>> downgrade that to a read-lock.  The access should be finished by that
>>> point.
>>>  
>>
>>  I was planning to take memory_lock read-lock at the beginning of
>>  vfio_pci_config_rw() and release the same just before returning from
>>  this function. If I don't downgrade it back to read-lock, then the
>>  release in the end will be called for the lock which has not taken.
>>  Also, user can specify count to any number of bytes and then the
>>  vfio_config_do_rw() will be invoked multiple times and then in
>>  the second call, it will be without lock.
> 
> Ok, yes, I can imagine how it might result in a cleaner exit path to do
> a downgrade_write().
> 
>>>>  Also, what about IOCTLs. How can I take and release memory_lock for
>>>>  ioctl. is it okay to go with Patch 7 where we call
>>>>  pm_runtime_resume_and_get() before each ioctl or we need to do the
>>>>  same low power check for ioctl also ?
>>>>  In Later case, I am not sure how should I do the implementation so
>>>>  that all other ioctl are covered from vfio core layer itself.  
>>>
>>> Some ioctls clearly cannot occur while the device is in low power, such
>>> as resets and interrupt control, but even less obvious things like
>>> getting region info require device access.  Migration also provides a
>>> channel to device access.  Do we want to manage a list of ioctls that
>>> are allowed in low power, or do we only want to allow the ioctl to exit
>>> low power?
>>>   
>>
>>  In previous version of this patch, you mentioned that maintaining the
>>  safe ioctl list will be tough to maintain. So, currently we wanted to
>>  allow the ioctl for low power exit.
> 
> Yes, I'm still conflicted in how that would work.
>  
>>> I'm also still curious how we're going to handle devices that cannot
>>> return to low power such as the self-refresh mode on the GPU.  We can
>>> potentially prevent any wake-ups from the vfio device interface, but
>>> that doesn't preclude a wake-up via an external lspci.  I think we need
>>> to understand how we're going to handle such devices before we can
>>> really complete the design.  AIUI, we cannot disable the self-refresh
>>> sleep mode without imposing unreasonable latency and memory
>>> requirements on the guest and we cannot retrigger the self-refresh
>>> low-power mode without non-trivial device specific code.  Thanks,
>>>
>>> Alex
>>>   
>>
>>  I am working on adding support to notify guest through virtual PME
>>  whenever there is any wake-up triggered by the host and the guest has
>>  already put the device into runtime suspended state. This virtual PME
>>  will be similar to physical PME. Normally, if PCI device need power
>>  management transition, then it sends PME event which will be
>>  ultimately handled by host OS. In virtual PME case, if host need power
>>  management transition, then it sends event to guest and then guest OS
>>  handles these virtual PME events. Following is summary:
>>
>>  1. Add the support for one more event like VFIO_PCI_ERR_IRQ_INDEX
>>     named VFIO_PCI_PME_IRQ_INDEX and add the required code for this
>>     virtual PME event.
>>
>>  2. From the guest side, when the PME_IRQ is enabled then we will
>>     set event_fd for PME.
>>
>>  3. In the vfio driver, the PME support bits are already
>>     virtualized and currently set to 0. We can set PME capability support
>>     for D3cold so that in guest, it looks like
>>
>>      Capabilities: [60] Power Management version 3
>>      Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>             PME(D0-,D1-,D2-,D3hot-,D3cold+)
>>
>>  4. From the guest side, it can do PME enable (PME_En bit in Power
>>     Management Control/Status Register) which will be again virtualized.
>>
>>  5. When host gets request for resuming the device other than from
>>     low power ioctl, then device pm usage count will be incremented, the
>>     PME status (PME_Status bit in Power Management Control/Status Register)
>>     will be set and then we can do the event_fd signal.
>>
>>  6. In the PCIe, the PME events will be handled by root port. For
>>     using low power D3cold feature, it is required to create virtual root
>>     port in hypervisor side and when hypervisor receives this PME event,
>>     then it can send virtual interrupt to root port.
>>
>>  7. If we take example of Linux kernel, then pcie_pme_irq() will
>>     handle this and then do the runtime resume on the guest side. Also, it
>>     will clear the PME status bit here. Then guest can put the device
>>     again into suspended state.
>>
>>  8. I did prototype changes in QEMU for above logic and was getting wake-up
>>     in the guest whenever I do lspci on the host side.
>>
>>  9. Since currently only nvidia GPU has this limitation to require
>>     driver interaction each time before going into D3cold so we can allow
>>     the reentry for other device. We can have nvidia vendor (along with
>>     VGA/3D controller class code). In future, if any other device also has
>>     similar requirement then we can update this list. For other device
>>     host can put the device into D3cold in case of any wake-up.
>>
>>  10. In the vfio driver, we can put all these restriction for
>>      enabling PME and return error if user tries to make low power entry
>>      ioctl without enabling the PME related things.
>>
>>  11. The virtual PME can help in handling physical PME also for all
>>      the devices. The PME logic is not dependent upon nvidia GPU
>>      restriction. If virtual PME is enabled by hypervisor, then when
>>      physical PME wakes the device, then it will resume on the guest side
>>      also.
> 
> So if host accesses through things like lspci are going to wake the
> device and we can't prevent that, and the solution to that is to notify
> the guest to put the device back to low power, then it seems a lot less
> important to try to prevent the user from waking the device through
> random accesses.  In that context, maybe we do simply wrap all accesses
> with pm_runtime_get/put() put calls, which eliminates the problem of
> maintaining a list of safe ioctls in low power.
> 

 So wrap all access with pm_runtime_get()/put() will only be applicable
 for IOCTLs. Correct ?
 For config space, we can go with the approach discussed earlier in which
 we return error ?
 
> I'd probably argue that whether to allow the kernel to put the device
> back to low power directly is a policy decision and should therefore be
> directed by userspace.  For example the low power entry ioctl would
> have a flag to indicate the desired behavior and QEMU might have an
> on/off/[auto] vfio-pci device option which allows configuration of that
> behavior.  The default auto policy might direct for automatic low-power
> re-entry except for NVIDIA VGA/3D class codes and other devices we
> discover that need it.  This lets us have an immediate workaround for
> devices requiring guest support without a new kernel.
> 

 Yes. That is better option.
 I will do the changes.
 
> This PME notification to the guest is really something that needs to be
> part of the base specification for user managed low power access due to
> these sorts of design decisions.  Thanks,
> 
> Alex
> 

 Yes. I will include this in my next patch series.

 Regards,
 Abhishek
