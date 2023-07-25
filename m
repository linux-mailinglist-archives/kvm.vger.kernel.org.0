Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6624F7620BB
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjGYR62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjGYR60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:58:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55210BB;
        Tue, 25 Jul 2023 10:58:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/TGjoUgOSBM1t+01pnFjVSA/seYc4gqh48pKaRyhYGNF8WJKLNDXpJSbjV+rC69gQsKVPMGsPYJ/6XiPn9ebZmZaCatwg+ElU7/EJgsRNUFnkzI27UJnpwZU5nU4qvn2+mWl335zpYSmK2nr7Izxt64tddyyIs6baCiby+dfmEBwY55g+Nizdfg/FTQbwUcYnNefd07MGfCw7VMRWscQpCVcVGYw/aaudsLxF0haTh9qZZ64dXc77A1XuzndVbpamXYoysJpxkAKfjYS+PHSVaTxIU1Cr3sG2LQkfiuM0JTCrGGDSXBvAVjnHKVUr9/O56wN97Z+uQsQZpIMllEfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meRP2K0smH/DP9Od0Zk/9waK66Py2ElJdG7sKwsVBb0=;
 b=QypZY8NKQtSstavFni5/Zpv0+HCql0PQZtou/M+ittrw7EFpFcaX4uQYFvRy2/jQeUu/suOcAIRKLrWZRc1+/8mKyI/O8Alk+74ywvWYqboHCwDMjJjw0ym9Wy6Jga5q9MmwFfsEeHidPHoxqFi7kqYjyhZTflWKDzoxI9zFvCEF0jRnq9oRX+4CDQYbh19fEuTPznLH5OH6+PS6qXaU3aypLrHOLtnaPIwDeNPEW/x6+ufS5jo13NjJ90O2uFNPauyGEOQj4acbodfJqo3ILYf2BALJUHK+rIYlT44YWkXXeNM7eiwKUHUrP3GT9u92Aq4mMkdYqg/Pw6LZroyZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meRP2K0smH/DP9Od0Zk/9waK66Py2ElJdG7sKwsVBb0=;
 b=bglGT75u6Z+RWMZcIRrUj+eu4Yg+BCZ/NNDDghbPUdQD4b8vRtLS5E1gUTNjDMRUJSWri+VvSCEr9r0Cg1yh7Kv+e+zLRGNCeWPU6HKKcCCgfImlZ6rSG67x0ytFpnCFC8Xrp68J+YVyxx3dUsUyjTDzN6giSC7BHb8DjHC1uoQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS7PR12MB6333.namprd12.prod.outlook.com (2603:10b6:8:96::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 17:58:23 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Tue, 25 Jul 2023
 17:58:22 +0000
Message-ID: <91d550a7-0759-664d-c31a-4d2b88a4741b@amd.com>
Date:   Tue, 25 Jul 2023 10:58:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
 <ZMAHAE9dnMzKzFgW@corigine.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZMAHAE9dnMzKzFgW@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::34) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS7PR12MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d89620d-6257-424f-efa2-08db8d38bc87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQxm3lFQsoZA3QZHgTtoiNlIAqn2hdD6CXpX0FI8dwWGV2ePIzArkiQeKz6c/+UXFN5VWZOFHRbUuWXDmEtJLPxHGfA2E4H0UplsBh0Iwbll9CU6knKNIODC2o8tcKkVCxWOcPCuXETEj7iY7KF2iGPY+nPZPchxsXV6lxb8Unz4+rTZYOm6t+XgjBRJQWxWHd0aOXxRRwx+wvx86bFbZtmr5ompsPFsakHiWdq+Doyy7Q5S6CRNhnOGZFLBemiBulr48dIYcQ0SMeJL7mo96injNuWww2QhkklnKQGgRcmVryCnnlGzpWmuvl4zL3aP66ypyywm7vwndgh/xX3qgko/X/GyEa3TvFT6r46gLnw7GftxE4+8eDAPxaYu2zVdguXCvx+76WdIRjhSTorTSgifjgglkO6T1uD4MEHci6mIK4E5SWm39lHRFESh9HaeKkTZpqgF9ChDbaHQRKOyIVwkQukvkS+wxlta5truAFLCE5QO46Mg6TwpeX5OgMTYvSGlaUNdJ2hu5StBFB0NNOUn0cF5/oGe2XH1V3P4q0uR2sJ7Ywwiz/L1sJQomLby4CbucNnphxyK0eOn5PDWAd2f7ODX/iJuNjs6UAUToQlT6Lh9DlXZJRMZdxc5z7cVYuVH9Cz2GBYbqopaEboXhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199021)(4744005)(66946007)(66556008)(66476007)(2616005)(36756003)(83380400001)(31696002)(38100700002)(6512007)(478600001)(110136005)(966005)(6486002)(186003)(53546011)(26005)(6506007)(6666004)(6636002)(31686004)(41300700001)(5660300002)(316002)(2906002)(4326008)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE1PS25YM216dGhHSmhzc0tLc3g1ZkgyNjhRVE5TYXBZb3V6VXdnWTFXWkM0?=
 =?utf-8?B?SVlMVUlYNWkwVldjdDFmMjBQSXRMNEFFbW5hZlpkakhDWnZ5N2RWK0E1WDZT?=
 =?utf-8?B?OGFSb0xhYkdMY0xWemVncEE2OEl2bmNmaTZrOFlUL3dFT3BPOTluSnZtMXpU?=
 =?utf-8?B?blRKTFRJUXJzMnRQdjJrWVkrZldSc1NaVU5zcFJUUGJubkdPU3dIbVNaaFk4?=
 =?utf-8?B?amgwRHdRTUJ0c0Mrck1HUXRTWENTVFp3L1FURzlCUkZ6eU1UaGl3ampxbXpF?=
 =?utf-8?B?a1lnOUFudEFUR01YWXpnVVBRb0hFYXhjcnRJUjRMeUw5NWtmdzNGeVdHZjVC?=
 =?utf-8?B?OGlldVZ5dnVGZmhrY0dwRkllNEY2c2E1cEVKVG90VW1mK1NjVzN3V29Rd2Zi?=
 =?utf-8?B?dXB2YTducEZiVUF5UEVmZkoxNUlYaE1Ob1lzMHpBWkQyTU9SSjFrdU8rODI0?=
 =?utf-8?B?ZGVrVmUvdVA5L1RhUGtTb0VJYzRicURmU1k1aE01a3QvUDdsM0VMZzNrMHNF?=
 =?utf-8?B?OTA5NktwT2Vwb0pPd3RGY3VyQmJGOEp2ZEdieUZqR0ZrWENrNUlicktGV2pW?=
 =?utf-8?B?clR5QktZTkZLVTFEbGtkWTRLQ2JmZnJCbys0S1o1ZXdiWVhFdFJSUHkxMnNa?=
 =?utf-8?B?Q1RRckZSRDVGNUV5SHlZa2JQc3hBRGhEUXE5TmNiaFc4d0dQNlJ6QVQyNEtJ?=
 =?utf-8?B?dDdHbFJHM0JVcVZEZTFMK3QxNVBPKzJtSTFYcld0VXFqQWhrdE1zemxEa3h5?=
 =?utf-8?B?WG9DczByL0xrczVITmc5U0J1WlZ2QWhBcjVxcVVra0llRFVVbjdpN0t6Y05t?=
 =?utf-8?B?S3pqN0h2TGtQdHUyOXJjbnB6RGF3SlIyd2NENmpnTmlzOFo0Q01lOEtpYmdV?=
 =?utf-8?B?MDhSeVJ5TnJUaExVa1lxQm8wa0xpd0NsYUl6NjRQVWhyZTl2N25EZmF0eXcy?=
 =?utf-8?B?N3lVUlF2Vm9JdzdGVkpaK0ZrOEZUOFZrSnkxRUFFQmFnRnp2NkQ1WlloazA5?=
 =?utf-8?B?c3NuWFVQQmRHRzBLL0d6NzJMOXF0ZFBtWVRzci9lWHVOcjhCVVlHQkhLRExE?=
 =?utf-8?B?VGhNUHZuVUNjYW5zdjNJVHNvejk2cWRGeUFyYnZWVCtOMk1lS3RWcjNYWmdl?=
 =?utf-8?B?VkxGeTh0NjNmNW1lcTZ1RUVMTmwyRGthSkcvWjVxZmovYzRGSW9PYzgyd2dO?=
 =?utf-8?B?bXNMdVpuSlh5TUE5QStVdjlKOUhaeDBxTEczRmxjcXlmbWRoM3c2YTNFcDJN?=
 =?utf-8?B?Zlo0SER1TEFhanZ3Ti93TFNSTkNGTWpDaVVPWTRITHcvYkNqOEhBRURLcG1X?=
 =?utf-8?B?K1haK1N2UWNBc3hYcHhsUC80T2hvc1A5WFdwQ0NnVHN0V2xXUXI5ZUxtWDdL?=
 =?utf-8?B?Tk4zRFBscFZUbVhOcWxWUFhoVGlXTTNlUW1YOUM4djRKVks1RkRzTldDQlNv?=
 =?utf-8?B?czJQMkdlcUl2SjdYbGx1T0h6aXU0QzV3K2QySjlPblZyK2VXSk5YcUhLbktl?=
 =?utf-8?B?OG0rU2VSY1dacTE5OEtCQnVqR2g3Tlp1Z0s1VkZHaXFiQ0diaTlOM3JFa2tr?=
 =?utf-8?B?SnhWcGkzZncxRjRvK0ZSQm1oWTNrZjZwL0EyMkpsTkorZ2hrSFdsUVVoaFdm?=
 =?utf-8?B?YU9lQlhZWXl2d0t1NFBRcExSQkl0UjdGdjhqSTBjM3dXMkdzWkNZeWx4ZXMw?=
 =?utf-8?B?SkNRbkNQaGVoZGV4N1lEb2FRRDRGSEZ0WjFDMGsvR09EemlNZmJiZFBETjRl?=
 =?utf-8?B?cnoxOEpQLzZmMys4ZGJhUkt1MGhTdFlnTHl4cjNjTWl3cnh4R2MxY0lNMVZv?=
 =?utf-8?B?SmRWdkp2Rk4zTnFRQmc5K1QveHpGa3MzdG4xazBhRllsTWlqaERualdvN25U?=
 =?utf-8?B?WXJBM1UwVjRyL1dUa25vRG4yQ292UHhaelJCbWMwank0bEJ3aGNHdmkzTDZi?=
 =?utf-8?B?anJFN0IvYWd4aXNuVWtxR0lNSG1BNkRnL3ZjS2ZvQUJyS0k0ZDNoUHArbDZK?=
 =?utf-8?B?Y294ekE3b0RYVDBzWGg5aC9aRDJ5RFdBQ1VPS2V2bnllR2JEVytuNVlGekpo?=
 =?utf-8?B?U29zWkhMOWNUc2llLzdNa3RwRTFQMVAwUlJPY2VJbzhGQ0ZVNXhocHk0Ym9G?=
 =?utf-8?Q?axIIB6iHQeY5C0kNHICLnBhUc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d89620d-6257-424f-efa2-08db8d38bc87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 17:58:22.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7MnBbgPisGyyPBOD9cUbrXKjXO5+P++DzAwXXIxVNy0ny/926V9gOlFqYoHZ9H9xeRIvrDS1EVSK5ZA13obfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6333
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/25/2023 10:31 AM, Simon Horman wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Jul 19, 2023 at 03:35:24PM -0700, Brett Creeley wrote:
> 
> ...
> 
>> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> 
> ...
> 
>> +static int pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
>> +     struct pds_vfio_lm_file *lm_file;
>> +     int err;
>> +     u64 size;
> 
> Hi Brett,
> 
> please use reverse xmas tree - longest line to shortest -
> for these local variable declarations.
> 
> https://github.com/ecree-solarflare/xmastree is your friend here.

Ah, good catch and thanks for the reference. Will fix on v13.
