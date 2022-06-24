Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AE65599AF
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 14:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiFXMdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiFXMdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 08:33:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FA51707F;
        Fri, 24 Jun 2022 05:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGsG9X2vO3Y9+lptcHD36cxHaqAKVryJiJMRosLVXSQvYXIkzETOg9IKFs1GYWrrhyT/I1mfJAuwwNfUdqHuv9KaJQ9pFRKj6pWOXVsS8t6VEkKlW5SdQlmtV2ep90kPAqjeXkGQSbrx9AqTtGiNJRy2mH0WZ+BJkoeujbwxmpRe4p+hez+FEUiIOm2jpPPw/Xb7QQqEg/Qg4gLWeH9zvRSLb0y59t1n6W9Feq5P95tdM9TMr1GqZ9o5kqt5o9nWB0NWJ5vsJN8zm0hIsZe+yaccbwjZOZ77YqdFHI4lzs9wE15W1rGbaUdcWBsOQ6t8jHjE4L1u9nOTphz5BvFztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFWld9T3PhBafmzNPSr7qYAXI9OcjHzfDnE2aYDznh0=;
 b=G9JmplrCq/WZCE0UTpTyRy2vzvPd2obeh3FzaMOwjoikLtokMxIpqDPlYzcp0FpSvWKEduZO21wSJgwTE42GBzwtkSjmKEel28Olu8S0E736tUjAB0kEY8XlWFVVmeQkKKV9E22G9JhC78F6k03yowwJsrO8t3hda0j8ETKnnvyQLXxI6FiP/cf1rNbARfuo88I8gaahlKjA0/yS+8riPjUDiHifA0KXj7qdf+gr4JUE1U78tgfi2zeg1fwTbDg0kjWFc3wdiRIhrevWhR+m2CaMZd/ssDZHV8e6J9D2ydCQDglAkMwDxQcirkqqFkzraLPNKRKzTWns8ai3Rj6Kjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFWld9T3PhBafmzNPSr7qYAXI9OcjHzfDnE2aYDznh0=;
 b=SOWWYD1Jp83tsva7QWYl5O+AwQKqtpBpc2FYAI0AkdLS3JUEED0gO0JYiBGsMHA3mdSSwh0nRcHq6ugvbSJEB/Gf+UnhJMEsY4wrdod8e8HJpegbRbq5AtktauBf9ukhFC3++HXBUWVcH3NHxp1Bwc0o4skAmr2YarRC9JqI0MIa7MaTGQdAS5q8mCkP4a914dSFtU0blPAhPY+ap4Aa8goW0mUVA3KTooTpybugZWB3lAukCVG6cPHOpL54tCUqfxMFfvEx7ZmXykE1JucQd3Ve5XEvG3jviIQcBY/N1XHSjSKtjfSlRgq0Sc4eEolEkEP9qsaNmO4zAJh1yx04UQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN6PR12MB2816.namprd12.prod.outlook.com (2603:10b6:805:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 12:33:13 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%8]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 12:33:13 +0000
Message-ID: <dee084fa-80ec-7845-88e6-8c1dc739e7d9@nvidia.com>
Date:   Fri, 24 Jun 2022 18:02:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 3/13] vfio/mdev: simplify mdev_type handling
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-4-hch@lst.de> <20220623212748.GC38911@nvidia.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220623212748.GC38911@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0075.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::15)
 To MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe62261-071f-4c98-bdf5-08da55ddb46e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2816:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9iEdN+5B/COnuvOiDNHv4kZJWCN4asZ2UHViDyfrhTT4XtGvF/ystnz8fOZ3I1bNOKmQhC1elzRYJunh6KBNt7xja6Jh5mA59Td/+WFCr5vExF6sVkLpyb4HlQ6tsN8CCTS1D5nOtgZ9h2H1zHyAjT9WLXdhQj2b8PmK3W2vsuLnMxQMx4EIUDM/Lra5oKtJHILrUkCQrEgW8hazhVdJD6gdY6KpPfV3FpULxLclUy1V6fh/SGrzaoRbNJwcrw2vyddyDv7IYRVO6OUlCFHQmuKTbAY7Nse/8dh58VuwLqQvTyRy2Z+MYcsPacQV7uw3eCnfQIznT07D3yHKSHrALUfLKF5MOF8ur6ndVaLWk1XEG+DYCTq4313E1977Lu5jLgnNEdq3WYTRFuPmbv3Z1FXnA0LPFAVZaRXzThfaAePxKpvrft/K1NvmBiBqSGCGfaCiBjxamGoNCOw+Da8an6Z0hPPC+pC2r/otSFgPOQfn3rEU32C5HAQsSJUe7v6oc9HYoguJZIGyq58m3YGgzpgytcNn/VitFacITSzAzxbl8iI1FiSk6j5S+s0Lq5V59vx6NSxGyLONzXAVS5lnpxsFWYlg/JW6NwkGxn4NpMHZHJXLrGCR33ZSlyUbDzAg/kNvYxE8mucld8SKbEXEdSaKPMlfXQX05f47PAwpMUMIuQ+AydP1odG/orYd35qXy/OQQdaH/f23CGaw+fUNGZs/TCpApzgnDtA6YLoKV0zKKaXcqp8jMoPewxcLSvX9/eKMjeiMRYn51b+rzlwASRgMtr5FX9mYTmS6pm7NW2TAJmqbHLY870e22YzAZQCQoIARN0kEmC+ZqpBMfJEUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(2616005)(186003)(83380400001)(31696002)(86362001)(36756003)(41300700001)(38100700002)(31686004)(316002)(110136005)(54906003)(478600001)(6486002)(5660300002)(4326008)(26005)(66946007)(7416002)(6666004)(66556008)(53546011)(6512007)(55236004)(8676002)(2906002)(66476007)(8936002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEZiYWV3K2c4WnVKWG5ZNU1uN2hQa1lQNzFMUVhSZ1BaVitrRkRMRGVXUWxr?=
 =?utf-8?B?SnJmVndGd3BKdXFDZHNFM2M2R1l4cHhsdmRpRXNsYm4wV3N3bFQ2aFFNNnQy?=
 =?utf-8?B?dFBDQS9ybGpmV0Z5ajhqaHVEZVRXYVQxb2tkMkNmdlVJN2lUSXBFZUhSZE9P?=
 =?utf-8?B?eGU5NEp2QlFjYkVJY2JmVC81ckh3WmFNdnJ6L1FEMWZ2ZzBQVU1BcHRFd1dv?=
 =?utf-8?B?N0ZubW5kYlE5ZXVSMnM3VWRrRWVSR3dHNkNhVGxxNXVGVTlOaEhMZDBFQldU?=
 =?utf-8?B?Sm56OE5rWXZoOWNMZE1sc3V0QTZIWUxzSEI0TWh6WWdXRHY4L0Z3eEErRFJC?=
 =?utf-8?B?b0pWTU9mTXowZWptYkV0aDE2azYvMzJhem9NVjcvT3FEWWNSRVJoSFE1TTR4?=
 =?utf-8?B?alNGMXdWcmFGeTcvbU11WkFBZGpFcXJGTzk5M3RVOEpRUHNEdjFOMzBySnZ6?=
 =?utf-8?B?aktqVjc3ZkhrK0tCeHRZNjNDRjhkbi9pYlIxeHY1TGwvdmJPYXdaeEFvN2tq?=
 =?utf-8?B?ZDB3VllKcmhzUjNESnVKSnpZbzFubWJCN0hyWTJFUlRvY1gxTjJNUzF0UDYz?=
 =?utf-8?B?cWROSmlnWm9qTk5IM0pndm4xcFZyYXpGZDYzSHBuVUZuajcwaVJvTWp0SDRU?=
 =?utf-8?B?cGZCMk5ERHNMWVFqS2djRHN4Y3ZiaFBlMjA1QUplcEVpODNkUVJuMHU3T1hn?=
 =?utf-8?B?VUhBY1ZwUVo5S0xBRlN6cUt4c3JCaHVnN1hvVCtBa2FhOGVhZEdBSEh4QUdt?=
 =?utf-8?B?cTJ6M1NWWk9BSUtkeXZaeFZCbVFlQU1BYlZlWHV4bkJuWVY1cU1COFdxa2NR?=
 =?utf-8?B?YTZkYVFIbjBhRjZZeURNMkMwRDFiNVZZYU1TbDhvaHZKWmN0eWN5MGVhU0ZV?=
 =?utf-8?B?SzhKQktUY3pPbTFNdmd3Wjlvc3JydUlRNXJlZThrRmZsNGpZdWp2eGxCV2lz?=
 =?utf-8?B?bk15dXkwK1Q4UXI4M1ZHVTBlTDZoZUVDa0RJbVByNFVCY1ZBZkhmRms5MTNR?=
 =?utf-8?B?c3JOSHJZbDBIbEw5RDBVYzRCYXNFUmcwbTc0SjI2a1VOeGVuejBqMUw0REht?=
 =?utf-8?B?ekNtYU5IOEZySnBVdVlRWFhUeVEzMmFWTW1vMHp1ZitNLzdVY0QwZDYyL0hM?=
 =?utf-8?B?TG1GVEVRTXByajRzdW1GYzdmMFpVK1YwU04zeVNmVVlxME1IU3Z1RENiSGxy?=
 =?utf-8?B?WG0xT2ZZUTk4WjBRVnUyZ0JtRzVzVHdNUFBNTlZINEovaGROTEtCOW1NeldG?=
 =?utf-8?B?YnJ3djJTMHFUdW1qbnBjdVdFUVdlT0k2UEtRK093aTB5K01xQUpLc0gvTktP?=
 =?utf-8?B?OVpjb1h4WGdrd1RHci9Vclo5NE1UNkwwNmlsTi9zSklaNzI3NjEzS2ltcloy?=
 =?utf-8?B?KzlVN3lhek5za05vbjVYclN6WWFYM0lOWFJaQUpNQmZyMEU1OXMrdklLRlhz?=
 =?utf-8?B?anRibEhWQUxuQzVza0NRMllJSnZBS0d0TEw1a1hKTGFxOUUxQk9YNmRqMmdR?=
 =?utf-8?B?T0lkbituN1J6NndBRW5GcWltYWEyejR4MUhyYlIxOXFrVnFmV1M5N0lEUHpL?=
 =?utf-8?B?d0Z4VEt0ckdhZ2xRS2IvR0RnSnpTVmZKNzBpclJpcjFPYUhkVjRONTBLOVJD?=
 =?utf-8?B?MVpSRzdXVm45SmpBWHBIZjBxTkppUkJGa3JqbndrdlppaG1taUU3SldJaHpS?=
 =?utf-8?B?bFArWUlvVW9zUXhFL2hPSHlXUFNwMUJWS2FMRU9BQnAwR1pjcm56UDA3MVA0?=
 =?utf-8?B?VzZkTFltS3dMdG8wcTBwckJSU0sveXV6MENMYWR4R1h3eDc0Q0dvdHV6K0Fu?=
 =?utf-8?B?TUZyWm5WcXUzYkR0dEsxZm5tOEcxWGN0Qng0emo2bGRzSDBnWUZEclF1ejAy?=
 =?utf-8?B?RnNuSmlBQlFwSHpIajE5bnV0cm10aS9rMmZ2M2Q5OGZucWtjSGZ5WlNkYmZJ?=
 =?utf-8?B?L3hpVWJJUHlrNUxEMU1YeUptOVhicEswNU1PcFFGQlQ2Z1Z1d3JCS1d1UEJS?=
 =?utf-8?B?K1dCUjlNWFgrUXB6VU0vY29HRHByL2FqaHF5alZzUDhOUFlDeEh6UFI1UEJC?=
 =?utf-8?B?dTV3SEg4Y2t2cXpZamFRRFZBa2pHRDhTY2hqUERRQm5jdmd0UmJyVTcxS2Ew?=
 =?utf-8?Q?12JhL4ETKsp0p9H6zV42VYJYM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe62261-071f-4c98-bdf5-08da55ddb46e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 12:33:13.3541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwD5N6yLKbqhCrpF3gvj1PSqKSAWEPJPQuuA5gl1DwL6BKyExagGSL/FHsZGh9dUcd5Qf+P4ZRDh6VAahlfRVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2816
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



On 6/24/2022 2:57 AM, Jason Gunthorpe wrote:
> On Tue, Jun 14, 2022 at 06:54:18AM +0200, Christoph Hellwig wrote:
> 
>> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
>> index b71ffc5594870..09745e8e120f9 100644
>> --- a/drivers/vfio/mdev/mdev_sysfs.c
>> +++ b/drivers/vfio/mdev/mdev_sysfs.c
>> @@ -80,8 +80,6 @@ static void mdev_type_release(struct kobject *kobj)
>>   	struct mdev_type *type = to_mdev_type(kobj);
>>   
>>   	pr_debug("Releasing group %s\n", kobj->name);
>> -	/* Pairs with the get in add_mdev_supported_type() */
>> -	put_device(type->parent->dev);
> 
> I couldn't figure out why is it now OK to delete this?
> 
> It still looks required because mdev_core.c continues to use
> mdev-type->parent in various places and that pointer was being
> protected by the
> 
>     kobject_get(&type->kobj);
> 
> in mdev_device_create() through the above kref..
> 
> eg after the whole series is applied this looks troubled:
> 
> 	/* Pairs with the get in mdev_device_create() */
> 	kobject_put(&mdev->type->kobj);
> 
> 	mutex_lock(&mdev_list_lock);
> 	list_del(&mdev->next);
> 	mdev->type->parent->available_instances++;
>          ^^^^^^^^^^^^^^^^^^^^^
> 
> As there is now nothing keeping parent or type alive?
> 
> I think what would be good here is to directly
> get_device(type->parent->dev) in mdev_device_create() and put in
> mdev_device_release() then it is really clear how parent and
> parent->dev are kept alive.
> 
> It looks like we also have to keep the type around and ref'd too for
> the sysfs manipulation.
> 
> But overall I think this is fine
> 

See my reply on [PATCH 2/13].

Thanks,
Kirti



> Jason
