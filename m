Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F52559A35
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 15:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiFXNOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 09:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiFXNOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 09:14:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CD75131E;
        Fri, 24 Jun 2022 06:14:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIaH6xibx4UYcq8X4gwX7ICMZxwVrWZqDlv3R0Dmi3dZzgdcHUnc3TkjiiNZFlAhvpmneg+WR4gQDiCdyZCMbQ7K5vupu5uWHgR3S0JuB2C+lJLydIVB//rythShzQ6uGTC6BEynlJa7RMK37WlIwWwUFmDCKBshuD1yqjK2elCtpcjjjEbKntUqrNs0hL1s1CKtdT7TwpJXxIfydMaIbzV4jk3igGRb2ENRHWD8n8mBimYAIHNaN3LaPtGeBnmSJayDq7eKnuNbpDUPRAFkdJPTevwiq0msoND8bUl1d/ZHueHqyQMzlpL04dAIUNo4T/BTy/pKzP0wrGQIBe+XeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bbhVtkGVImcbju/BD8GkVr6Frbp0/LtF629uPqu6h0=;
 b=T1Z8iUNFThce3M8jR3uACUlGDr2Zb9F3rpBGbX9IzoyjlQTUt/7SORngMKkC4wcM1pdOsAeQiLdlKoWCsgipgU5MPcCWAtWWzNgknMB68eCcjo+2E6QML5ahx9q/TGJnvmwfMgZH0okhNMBBeb4YcpxsWJ7IburFriSJYemDXnZIf3hInptwWfqHfRO0OhJt5hyfirOcruJskvFfGo/d1/DNYAj39aaXU+epBtAb+Zoh4AR+WmCador2dyGW4ukFWghdPcz7PJYTS1RZeCvPLtPmJftyQCSYE3ohlRvkbxzmDNYoUqSTtndKpeoRemIt4K0v7/8w6vOnys269BSLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bbhVtkGVImcbju/BD8GkVr6Frbp0/LtF629uPqu6h0=;
 b=NsKq+rOE19h2tb90HEwMpJwLbEN4w/pQSfcdMzibPJZuXI/6Z7a1fO9CbYeFXXjt1PBauF0u/AZDK/xCo4hsK2UzB2uuNnp0tOovSu7KpMvBBkf68TkWZBadj7p5ojb8PjDCyhxZMl4eZF5JC4Jam9gpKSVmri8sS5zu9Y3bHuo+QqCjI58NIvJS3gj5Nz48afwVx0TbfQlB6K+8B7bZGmy0TJTTWH552IDWQNhmT0d9NaCzvcThxbKZSJR6iCPbEqGjkcHmgEDDtGuyD6lIxgpfFOrDqsEENQJPVFUUk8tmXweJvHm6Oz82Ei7ckCJ6S/ReOZyF+degPMZN1fxCcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM6PR12MB2604.namprd12.prod.outlook.com (2603:10b6:5:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 13:14:33 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%8]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 13:14:32 +0000
Message-ID: <34bbf698-cc76-d638-4c6d-c42bd726ec26@nvidia.com>
Date:   Fri, 24 Jun 2022 18:44:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
 <20220623201844.GA48313@nvidia.com>
 <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
 <20220624123344.GL4147@nvidia.com>
 <b158ee0d-d7bf-c827-637b-3cd98c66b193@nvidia.com>
 <20220624130510.GA124353@nvidia.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220624130510.GA124353@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1819d775-918f-471e-550a-08da55e37a35
X-MS-TrafficTypeDiagnostic: DM6PR12MB2604:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgdKqPWQJImw12iWjei/i+HNbe/iv2JWsEB/XjDOxssq1i0FnQ9n3tAKvieVhy/fsNBvDt5Dia6QXTe1/VObtagPaPhDWmkHr7XWFu3L40XjOAl5wE6nMGj3gJDWn4Sa4qgo9yqCxzKy1gOOnaQBRrn5C8CwKR8338NaP8Uc7RC6MthpZDGAagibrHSlNFlGg7jTj5NBmrBsAZTQjibdEtLFnfvQ6W+DpAiQIX0v/LdkGycKeXEc+Gq8MjKESNMbgaR0ZmE4211fcACKwxMN9J9rbIIEO71ZoU6XrFZlVIAncuN/N2DPJYemkqLwlpriFxww7sHEA5varZdDVIJ6Z6oj9ts+pEvHccGF/9bnzWVtuzwqltjhZOH+2ejxx0gOJm4AzEtJKgxVopNc4gt9oNk8MSIU4y9/38Yw5DRpLlonl9Xd32qLBbT8pfidrrlAJPnwD+h7I/YAG7eNth6B/XiEct3IGJWGJ3Ke4A/IMB/IEdx9MutHwYOTPt5u00BO7S0/hEj4tmtnqoT5jRyLMbrP5XeVxpRmG2nXQK8d/zRcNwjonKMTKPUBt940ovVNhK4J2eUevVIjenkao/4q+/4D60Uf1w1r/EIXjmaOhm/U8WOmkYkYH2iTVDle7z80WhTTmn6gDHccE7ibBOoSHomMfxZRwdKRY2j4+JpUE0ihT2CCycCal/wyBRASSoWd38JxdvgzZLR14X2LiUZRT5w8V9EiNwmr5TFoihdG/WSEU7c+IySd6Q2xDEOpwD58nnazonNmhmFsqVHQg2giG5uh/n8THv0V+JDn4jyLCf09359Exzi0VsDWctWGeC/GHUUtWLeOOVyr4Ht+VyADgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(107886003)(38100700002)(36756003)(8676002)(31686004)(186003)(2616005)(66476007)(316002)(86362001)(4326008)(66556008)(54906003)(31696002)(6636002)(41300700001)(37006003)(6486002)(8936002)(6512007)(478600001)(7416002)(53546011)(6666004)(26005)(6506007)(6862004)(55236004)(66946007)(5660300002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnZYTUViWlBNZkV5RExHcS9nbk5PNGxpL2JUYmpMdkFDUFVYYWFSS3VCdm9C?=
 =?utf-8?B?RXdYanJ5c082QlVncVluejl2WkJPRnpMV1Z4TXBqZ05WazhxcWcyS21Wb21L?=
 =?utf-8?B?NlpJTmh5dGRSUzhzRkNmS0VmRVJTbDFTdDkxWEE4UWtGdkVEQjlrYUNvcWFr?=
 =?utf-8?B?ZjNaRGNlWFI1Y3A4elk0c3NTc3B3aitMczU0TmxrTWVHUlNycGRmWWl0YlZ1?=
 =?utf-8?B?ZWxTc0RtOTNoVUhGVWkrNk80NEgxM29SYWxSZ08rdlhmcXhkU013ZWkrQzlJ?=
 =?utf-8?B?VXk5aDBvNTRmMFJmdldSckxGa0xGVll5ZndPYzlVQ1Rqdm9ZQ3B5a3hvWDUz?=
 =?utf-8?B?cm8vNWM4RWViVlNLMVdTWklITUI2VERpcUl6aFNjYkxVbmlVYlBlL3g1NFlK?=
 =?utf-8?B?VzZ5ZG9oL1hicTRseG9EcVhIV2p4aCtPVHg4L1JVVjJSRlN1YkFTSUcxa2tt?=
 =?utf-8?B?Szg0dU41eHk2Q2JsVUdBWDNBQmFmVmM3RUplSHUvNklOQ0NIcE12ejZhc0tx?=
 =?utf-8?B?bllLVFh2UTdHT2N0d3paVk9ENms3Q3AwSkRKNUtwbjYza3N5VGZnWkhnU3Ez?=
 =?utf-8?B?cWFjU05DNHZOT0pCN1c0UitQVGQrMmFDNzFST2hjYnc4SnlXK2gybUw0R2FD?=
 =?utf-8?B?a1VZYzdPclE4bisvUWV4bVFXbkVIMGwrdkEzRG9OVUhOTmVOQnBHNnZKVmhs?=
 =?utf-8?B?eHNiVC8wRHFVK01qQ2JrK2NJeFlmWU1JMTd2ZU9TcG9WWTFYOXIvTi8wa3FN?=
 =?utf-8?B?QnlxU2duWmRPaFRUTjF1VG52NVFlVDNSRWZiYmNDOXhtVFZtZFluK0pNdHNw?=
 =?utf-8?B?Z2Fva0QyVktLVGNZOEp2dldCOGFjVHQ0ZXlHanJyTlZZbitnZ3ZSR1FVaUlx?=
 =?utf-8?B?bktDV3pEeFRaN1lwNTZiVEMxMno4elVoaGJiWDVDaWNmWmxjdFZrRlllUmxS?=
 =?utf-8?B?eGh4QWhpc05MMU5kVnZ0MExHZ2pPbUUvaG9PQTh5SXQ5MkV5cW9oajR0MEMx?=
 =?utf-8?B?S3dranF3L1haaGU3TmNESnJqU3BkYm1rMm5nNGNtNHNMV05FRTVmelovRWoy?=
 =?utf-8?B?VENYM1dlUG1yR1EvSHBHc29BdTRGQ3psc3g5V0hBRmZRaDVzR29yVVlSRE4x?=
 =?utf-8?B?MTc5dnd6SnlVV0VpSHRGU3Yrc0VadllNaUxVZHR3cllNOTdkNW1vVHhBc1FG?=
 =?utf-8?B?ejhxRGk3Q2dYS3RIV0xxU3NvUHExQzdwZ1ROeWRFN3ZRSUdJZ2crWmZyR09F?=
 =?utf-8?B?VU9jcFN5V0NidU93ajlRNTVuSnVRRlVweXZhR0xOYXBBT2pwcXhMeXlVei9B?=
 =?utf-8?B?WWFGYS9YSkhCN3g2QzNxWE1MMkdkc2Y3UE82OFlybktlZ0h1Wis3OTRRa0JP?=
 =?utf-8?B?KzlMcFhQUG1jcHg0bThwcUNsV0U4SEh5TDd0R0ZQZ0VFYnJ6SjhRL3pLZzlk?=
 =?utf-8?B?b1hGYlp1a3loVlBtVnpRZFowMjRYNW1rcHowYUR2VFVHS3orWXZONmNSZXJ3?=
 =?utf-8?B?UTUvU0lQUHpueFVZb2paMzVpQmE5UDNYc0ppT1RaY2tlUFlFVEdEOVRlZmlC?=
 =?utf-8?B?T3p5cG5EMWs5cS9DM2REb1V2SU95OEpyNFd6Q3VoTHFiYlcxQ1QwWm5SSjZY?=
 =?utf-8?B?U3d6cFQrbjZ5T1llSnkzL3dheW1kQ3BFbUMweExuLzNoZUlDNWd3ZjZvcC9n?=
 =?utf-8?B?cklKTjdGdzZDQ2dHNS9iVkdtcjNvY0tEVjM5azAzZjhONFM2R1QwaS9tdmtj?=
 =?utf-8?B?MGovYW5hUTdnai9jblBXMEJoZHdPNk5Na3lhZHFHV1lTQ0xmVEVaSVdqSTR4?=
 =?utf-8?B?c0Nwd20vOTNRa3N1Y2FzWE93Ty9hT3lHdmhHMWswNTRacDRRVnQyaGNubks3?=
 =?utf-8?B?SnRCZTY1YVAzbllnVTdsTUtEamE2TGFkdWY0RDNQVVkrMzI4eUZsL2l0QjdF?=
 =?utf-8?B?R2M5MTN2ZG5sQ0FGdEdSSDVnbmNuc0UvUHh1cVJvM1Z3Z0tabHZ0SkF4MFdo?=
 =?utf-8?B?dStheWhSWnVNcmxDbHdaczhmSWt0SURKSmpValgyNHA1UWc5eU0xbFNGQzVW?=
 =?utf-8?B?aTlSbFgvZGcwd0hYZExILzlFQ1QyanZkMEo4MW56QXRCakI3TXRWREhQcHVr?=
 =?utf-8?Q?FAHzlH1CKPxuj4aJk5GmEs8FH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1819d775-918f-471e-550a-08da55e37a35
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 13:14:32.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kxi7kG75gRJ7cl3ZUV5fgzhXQXnbapQNSqAH92z9W4zl7H9VbkTyXvR1oR/NLa+V8Ku4Hn8zABCixQ1AMGzqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2604
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



On 6/24/2022 6:35 PM, Jason Gunthorpe wrote:
> On Fri, Jun 24, 2022 at 06:23:48PM +0530, Kirti Wankhede wrote:
>>
>>
>> On 6/24/2022 6:03 PM, Jason Gunthorpe wrote:
>>> On Fri, Jun 24, 2022 at 05:59:58PM +0530, Kirti Wankhede wrote:
>>>
>>>>> The reason this is here is because the type->parent is used in a few
>>>>> places and is put back in release:
>>>>>
>>>>> @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
>>>>>
>>>>>            pr_debug("Releasing group %s\n", kobj->name);
>>>>>            /* Pairs with the get in add_mdev_supported_type() */
>>>>> -       mdev_put_parent(type->parent);
>>>>> +       put_device(type->parent->dev);
>>>>>            kfree(type);
>>>>>     }
>>>>>
>>>>> If this was a simple sysfs kobj with only a show/store we wouldn't
>>>>> need to do anything as the natural kobj parentage holds a ref up to
>>>>> the struct device - but this kobj is used internally, ie dependent
>>>>> from mdev_device_create(), independently of the normal sysfs
>>>>> life-cycle so that doesn't protect enough either.
>>>>>
>>>>
>>>>
>>>> Life span of 'type' is from mdev_register_device to mdev_unregister_device.
>>>> If device/parent is being unregistered then only types are removed, so
>>>> referencing 'type' from mdev_device_create() is still safe. Therefore,
>>>> parent device's reference should be held and release from
>>>> register-unregister call.
>>>
>>> No, I've already explained this.
>>
>> Its not correct.
>>
>> kobject_init_and_add(&type->kobj, ...) which called from
>> mdev_register_parent()
>>      -> parent_create_sysfs_files() holds reference for type->kobj
>            -> add_mdev_supported_type_groups()
>                 -> add_mdev_supported_type()
>                     -> kobject_init_and_add(&type->kobj)
> 
>> This is released from
>>   mdev_unregister_parent()
>>       -> parent_remove_sysfs_files()
>>           -> kset_unregister()
> 
> It is not kset_unregister() that puts back.
>             -> remove_mdev_supported_type()
> 	       -> kobject_put(&type->kobj) // pairs with kobject_init_and_add
> 

that's correct, my bad.

> So what is the issue? This is a properly paired usage of the ref.
> 
>> In the next patch [3/13] of this series, these calltraces are changed as
>> mdev_register_parent()
>>      -> mdev_type_add()
>>          -> kobject_init_and_add(&type->kobj, ...) holds reference for
>> type->kobj
>>
>> which is released from
>>
>> mdev_unregister_parent()
>>      -> mdev_type_remove()
>>          -> kobject_put(&type->kobj)
> 
> This is the same logic? What is the problem?
> 

Pasting here your comment:
 >>>>> the struct device - but this kobj is used internally, ie dependent
 >>>>> from mdev_device_create(), independently of the normal sysfs
 >>>>> life-cycle so that doesn't protect enough either.

Since there references are held, its safe.

Thanks,
Kirti

