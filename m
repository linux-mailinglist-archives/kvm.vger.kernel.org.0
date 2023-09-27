Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3907B0BA9
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 20:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjI0SMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 14:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjI0SMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 14:12:31 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C27BB4
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 11:12:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM/vlE8jp+ao/BldbBp11iIK1oHmc+ycH1WrBEsRD/g2TVRWa1lyCPLGMHb2mIDtsjwLD1/Cer43vKeK7oXqk0et4MgQTHUzeCFjWb+AZaEksByuf6Y54eakFnP24nzk2Wb/rKxIFZUswdCRhNpMc4SmFbDJWDjlZRlI7rn2clJlJBC/EdX5FbALDxtB6xegkl4cYK6yiOIT9LUbln0CszGM7N3b5gl+W/+Lva/j8s42s3HhEngnk6G6LocLF3TEvCRBHmqrVjI7KJ2tUMVrlqweHwCSPlytexfsjnf8FIfdBZCmmUGcdQ9FvdE825nk7yNsBnWSQ+xlOqlo/eDxyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDKYWKZFHbfxylclgwijl6iUn2/Lh5JlU4gNAniw+ac=;
 b=cVq489leIyqZLJ7WsJXyuH757/gRRGuktA8Byj5XxfwrTBbrt4HPz8x9B1NyZGJjyTH5CrmJ8ouf55xxSvwwmxsxmzRi1wZaUE0HJXFyI9F9mWvu6PbalgR4rifSD3WeoztILp2KGVKi0pG5KZlol7bj1vJ/KY3HzRwSNx7hPWJDoijg8qPSQOkiFFaNKtvE44wkrz6IpucRqpHVy4GB8FVAwRn6+5qL4Gzjasd1WRZrDJU6WfernKnqIAUZxaH974kTwcWIx8Lj+dYSW6y3/yKmVJwtd/CcYtPM8EMZ0tjVibLXbag7daBLyK47vjvMOZnHTkcdGz70zOECeblg6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDKYWKZFHbfxylclgwijl6iUn2/Lh5JlU4gNAniw+ac=;
 b=GE16ZVc/+ds1U4WFVoS3b2emABqUytJDsNF6QJvRNJuPhbItLdrWc6lBXym7qylo5mFwuFQd0KyEmx9oS0R2Ctb6XzT9BG10feDxPDD36Y7RM1To3AV4ndBohpWDbhMF1yMzL6JGauz2U1PLP5UHmO/aaknz2J+4B5C4bC6A2coZB1YntOyD/5Zym3WH6t3U0e9tXZuBisW9e/6hL8XqZ5RnVkxZtVUjh+Ztxt1tQxJpGwgqfFPb0jDJ9M2Q+ccw5acJqataUkIFP6kChblCVVMhKHl/fR9xd8PQBUVZw8IKYY9VekhDLgYBRqOV2dK03kK7DqghTE4U6JKSXxeY1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by PH0PR12MB5402.namprd12.prod.outlook.com (2603:10b6:510:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 27 Sep
 2023 18:12:28 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082%4]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 18:12:28 +0000
Message-ID: <40f53b6f-f220-af35-0797-e3c60c8c1294@nvidia.com>
Date:   Wed, 27 Sep 2023 14:12:24 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     kvm@vger.kernel.org, maorg@nvidia.com,
        virtualization@lists.linux-foundation.org, jgg@nvidia.com,
        jiri@nvidia.com, leonro@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-4-yishaih@nvidia.com>
 <20230921095216-mutt-send-email-mst@kernel.org>
 <62df07ea-ddb6-f4ee-f7c3-1400dbe3f0a9@nvidia.com>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <62df07ea-ddb6-f4ee-f7c3-1400dbe3f0a9@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0176.namprd04.prod.outlook.com
 (2603:10b6:806:125::31) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|PH0PR12MB5402:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a2100a-7efc-4b54-5b53-08dbbf854eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgHtkj6Zc6xCnynziNeOsJQwQ8wznfcXHlvRnJS8DYjZMzhNL6Zj9tz/ULQHU81vyZVL0TxzEOqbRB09l0MKzBtWtUGzCUdO5i0apYCJtZOfr2/0hbof/2B4JLuHCXV/i27DSoC8iZZPmgEaMn38SE9TDvefZRVSwnclXJHqd+W5SWKdbXBB7rf1t+UTdBj70Ib/8Nx2SaAmtTvUcvkAGlLHihzt2qg9G36NuXvdf3RWh7oua07/xUIWBiY+XRsyEil3IMjYS1BQC7q7zDM2gMwG543zFBSueveBkLrvigDqqJEvv+39xcb/Zykh11c5+1ZSCcH+tj3dNpq2qJpTjoE346hB4LrFQZDIV0DxLHB4xFeggHOh6lUMODz+An8ouSVp/cO4lWZgyqlDwAjOgTd42f+sSAdiUGCgQ+UGxgeQD2sTBvTPg70e4a99cI0Dcl6+UDSV7UwiSy4ntnye8xuyN4y4ZUsFX1O6DM8e4XpgviENWfYDhVt53zan4jGZYiWr2ten+Ou3PPn7I5AqBF1ZQXZxJO2NXM79O4prEMf7An7kH7rA+1bkhkMQN3Y4fRyn8/FkVZah6NYgmhI6V07sNI7d1eXdA/eObTyQ1QyYpf170duZfTMmSUxZiAueKOnfR/RZp7euSX+JYpxeaEDp+AHmGwyBuCzrsgsNNPUkc+tsR/drQbYw1FsnLDRJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(396003)(366004)(230922051799003)(186009)(1800799009)(451199024)(31686004)(83380400001)(8676002)(6506007)(6512007)(110136005)(2906002)(5660300002)(4326008)(316002)(36756003)(8936002)(966005)(6636002)(41300700001)(6486002)(2616005)(66946007)(478600001)(38100700002)(6666004)(86362001)(26005)(66556008)(107886003)(31696002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmJidDdsbU1md2NWTDR2dUF4b2dDeTJRYzcxKzhMWUtzbExITEc3WUsydUw2?=
 =?utf-8?B?Z2YxaDJpd29uTTFvTk9VRmlvVGx3WEhBOC9MQ0cyRjM0NFdBbXllQ1hoVy9Z?=
 =?utf-8?B?ZjRaOGM4SFRNWjN4bCtpa2Eyd1hqems5cU1EZm1DMVhQR0UyYlBxRy9WYnBa?=
 =?utf-8?B?SVhVNmxCWWFhN1VzSGdiVEFGWklsaS9SdlVCV3JReHJBMEVpODN0RXdaNHVQ?=
 =?utf-8?B?R2hxODF6ZDNFN3haZGtKQnVIdXkvQ2VDditDZitDWTJNN0N2dlRvNXZmZXEy?=
 =?utf-8?B?U2hydkdpSkd3eUlPWnJNQS9jdVdYM0J5WmRoMklLMWdiemdTQ1Z4Z0lMbmdJ?=
 =?utf-8?B?TFUxejlmR1JsNVZXSEt2UnJISDJ2U1psQ2lTSDhnVVdESjRtUmJGOUMwZm5M?=
 =?utf-8?B?OVhERGlLVzc4ZVg3NDdMbExoTGZXVEJlc1pzc0ExeUpIWUpvQXVLalBGa1lC?=
 =?utf-8?B?YzYzSm80bElaSnFwZWZwSEFvTndaOE52NzBrdjFyendMbmtYK2ErNE5RbmdR?=
 =?utf-8?B?VThTem9XajQwV09yRmI4S2pOVEtEZkNQTThPdE95MThyQmhONkN5WjVoUHMz?=
 =?utf-8?B?d0x3eGFJTXpYck1HK3ZRcmFHTFdrOHkyUzQyQVgvWTRmQXJ5bHFFU0pvdW5B?=
 =?utf-8?B?aDZ6TjgyR3QrQmVOaXIxQkUvQzVoUFIvNk9ha2ZRekVxK1FuWGRMZTg5NGZ5?=
 =?utf-8?B?ZDNENWNWVUV2eEFJVldYVXhKaFNzRDRKK0Z6ZGZZUkxHL2VjWlZ6TmEyTDVO?=
 =?utf-8?B?VmRhY0o0cmhEajdKNmRQOVVwYlZzbFk3TDdBdklqdmtRaDZnM3JtQm11UHZx?=
 =?utf-8?B?aFhaRm9hM3U4UnRHbFE1aGZBc0pMWnEzWHpuQmpZVG1KYnA2OFd5S2VBRDVq?=
 =?utf-8?B?RjN1VXJmSDhuS2pKMm1hU2pzNjZ0YkRPUUU1REhQaFlOR0xkZmZXZG8rNzNh?=
 =?utf-8?B?MkZTdVBhaktTK1pENXZ5U0wzaXJYWGpQOFdueE05ajVwQ0wzK2lPWk4wY3NV?=
 =?utf-8?B?SXBHdjREOERNZ054UDA0OEhxSjRFc0pxZFZjOUFMVnhVdWM2VmRIY0JrOUdk?=
 =?utf-8?B?MUY4ZkZmeDhBVk10REM2YW1aaTd2bU1mVGRrQjdKL2pqZ2QrNmdVNlRKaG92?=
 =?utf-8?B?V1BBUXhndUI4ckdnaGJnMFdMdUFES2tmZXAxUTJEd2F4WkxOY0x3SjN2S0Q0?=
 =?utf-8?B?MkNYSjA1cmUvcVdTc2dYb2tTNFNVVTkzTW00aUVxaUNTMUFpMkpwSVdiNmJr?=
 =?utf-8?B?QUF0OElIOG0zN2tKcFM2cnl6UlQ5YUZrazRnOFFZWHdlWVB1QXpUNW5RU2Fj?=
 =?utf-8?B?djIwMkU5cmd2SkVCWjhFUmFaQ1pYZ2Qxbm1PNTV4OG4zQVBWSU5jbTlWVTZR?=
 =?utf-8?B?ajV1cHk3OE5ZT1ludkxIcDZoeEZaSHVnVVJQeG1CTm9pZFdCQlBGYmJrdmE0?=
 =?utf-8?B?VW9kc1puRkVMTDIvSnFjYlhlRS9LTkdxekxkT3FQZ0F2WVVneFpqZzAvYjMz?=
 =?utf-8?B?bnh4eW04cHlmTlcrNVhXcTcwRFB4ZWIrMnVrUUt2WVVyR21wb1hveW8zZEpV?=
 =?utf-8?B?NXFaaUJ3NGdQYlhPTjMreC9reXNCb0tRMjdwSVE3OXNrYnhWNWFFUjVNSnRt?=
 =?utf-8?B?VnNRamQ3QWFocTR4dVg1ek9pQ1krQm9VR1RQQnBoQm1ROWNFcmFRbC9rb2Nz?=
 =?utf-8?B?WUJ0SDJwRGFDb3NGUGFsalJVdzVUQTJvQ2hpaDNmR2tpbGdpOHJ3dFdRMVBn?=
 =?utf-8?B?Mk9VYTFHZkhLSE5jSlZwYVNsQWMrMmRCbFhEaGJLMGdmcmg0Y3hqSW12WXpI?=
 =?utf-8?B?cFlsNnRGYkQvRzE4K1BpRjFtSkloMWVzOWlYQWxSM0Vici9oK0VrVnQ4TzJY?=
 =?utf-8?B?NkpFeGtLcU1tVmNqa2RkV1pOMVZmWmNsRXRPeEFteCtvSEY1cE5ERWg1a1Z4?=
 =?utf-8?B?YlBxZWFVaTU1dEUwUEFRR2FKZ2xpMStMcGhJU2h1bTBFOUt1VGhjVzZhTldC?=
 =?utf-8?B?QlFlMVFBdUpKdkVOZVJXNmNKSUtSMTA0bXpkMGsvQ2d5NVVwV2E5amR1T2VL?=
 =?utf-8?B?aUhXWTNIbDZMcjZWZXYrZm92M3JvOU93K1N3RlYrVVBRQ2xmbTc0TndZYVJw?=
 =?utf-8?Q?g7/v5RcxIpUq3nMNyBUHO1UdL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a2100a-7efc-4b54-5b53-08dbbf854eb4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 18:12:27.6542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OFTUJTu7QWaCtNRqVV2rfmWdB0mcQyZ8K3F4r7hx4pIFJbnAaekLSaWehuLIZj7gBvBmyumpDoP2dobjvOiXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5402
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-09-26 p.m.3:23, Feng Liu via Virtualization wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2023-09-21 a.m.9:57, Michael S. Tsirkin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Thu, Sep 21, 2023 at 03:40:32PM +0300, Yishai Hadas wrote:
>>> From: Feng Liu <feliu@nvidia.com>


>>>   drivers/virtio/virtio_pci_modern_avq.c | 65 ++++++++++++++++++++++++++
>>
>> if you have a .c file without a .h file you know there's something
>> fishy. Just add this inside drivers/virtio/virtio_pci_modern.c ?
>>
> Will do.
> 

>>> +struct virtio_avq {
>>
>> admin_vq would be better. and this is pci specific yes? so virtio_pci_
>>
> 
> Will do.
> 

>>>
>>> +     struct virtio_avq *admin;
>>
>> and this could be thinkably admin_vq.
>>
> Will do.
> 

>>>
>>>   /* If driver didn't advertise the feature, it will never appear. */
>>> diff --git a/include/linux/virtio_pci_modern.h 
>>> b/include/linux/virtio_pci_modern.h
>>> index 067ac1d789bc..f6cb13d858fd 100644
>>> --- a/include/linux/virtio_pci_modern.h
>>> +++ b/include/linux/virtio_pci_modern.h
>>> @@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
>>>
>>>        __le16 queue_notify_data;       /* read-write */
>>>        __le16 queue_reset;             /* read-write */
>>> +
>>> +     __le16 admin_queue_index;       /* read-only */
>>> +     __le16 admin_queue_num;         /* read-only */
>>>   };
>>
>>
>> ouch.
>> actually there's a problem
>>
>>          mdev->common = vp_modern_map_capability(mdev, common,
>>                                        sizeof(struct 
>> virtio_pci_common_cfg), 4,
>>                                        0, sizeof(struct 
>> virtio_pci_common_cfg),
>>                                        NULL, NULL);
>>
>> extending this structure means some calls will start failing on
>> existing devices.
>>
>> even more of an ouch, when we added queue_notify_data and queue_reset we
>> also possibly broke some devices. well hopefully not since no one
>> reported failures but we really need to fix that.
>>
>>
> Hi Michael
> 
> I didn’t see the fail in vp_modern_map_capability(), and
> vp_modern_map_capability() only read and map pci memory. The length of
> the memory mapping will increase as the struct virtio_pci_common_cfg
> increases. No errors are seen.
> 
> And according to the existing code, new pci configuration space members
> can only be added in struct virtio_pci_modern_common_cfg.
> 
> Every single entry added here is protected by feature bit, there is no
> bug AFAIK.
> 
> Could you help to explain it more detail?  Where and why it will fall if
> we add new member in struct virtio_pci_modern_common_cfg.
> 
> 
Hi, Michael
	Any comments about this?
Thanks
Feng

>>>
>>>   struct virtio_pci_modern_device {
>>> -- 
>>> 2.27.0
>>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
