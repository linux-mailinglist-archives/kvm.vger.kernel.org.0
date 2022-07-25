Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF2B580674
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbiGYVXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 17:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbiGYVXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 17:23:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80138.outbound.protection.outlook.com [40.107.8.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360D0248D6
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:23:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+T15Db02vZaUj2jb5fgnvSROmc9FeBw99TqLHCysbOLLQL1yVf+64bVfJCPEOWXeL882hD8WXg2pz6tq2hXWjZ9OnXwYmqbL/bE9Kvcxioic6GTRIGL1enIBFSmG7eHDZaMvsq6R0jqaLE/mY9PC5THfyzaMIk5EbuxvDYCxMkjBxedLmzle9Tzbq/jpxjVlWEMBhiGG+oSRcetcVAeCpVQXvteOYoTzVKukxsIYU0x+pvE5H+zk0g0TbrXH51qqEkCEeQSZDex3NOgxfNmDIVwiqDH5qwFs9X8wxlgDZKr7o6gj78dN2zVn23Iy9De4km4bG+9mBryqc8FBjm4CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9yGc4zlk+H0czUB4DJkTrNwcXQTZgYSjVpNXl4Aly0=;
 b=W7YmDGq/OA/boiRp+Zs2Cgh8l+GEbwe7P8p8xs6AuBJtFW6IqvIp7tmT65So6orFU2SkCczI4J9pMQNRxi6G35ffb90/kYsQYW8897CLcMZbxKE/8yT/oCYlbFU17XFreO9TPmLBaOKFkP2Rbz3Fv9+vUtC82jepWQdC99PU39kRLQsD4IwXbMcsBRFs6/vl/qPWHzXFgawqLLqXez8Q9E1eaJzRDXDGaGV0Zj2mSQoKnj7IsNPgL/EkkTL5xUGhXoizdOL3irGGYQBNd/vTK6XZ4f3pZv5H25MI/hSVeSIZkSHKzTqGaUaoq1cY9cEfCtvx7Vjc3JP2XE3h0KYXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9yGc4zlk+H0czUB4DJkTrNwcXQTZgYSjVpNXl4Aly0=;
 b=KQ5aEsIYz6rRLVokJWcGzmNyGb68uWgf7NAk36MX3PpPyQzKnIMRb78zFAoKFt6/po82NbGWXTmg0mRBb29M2RuISCozBLJdGJPQ/adp9DHKAHC+MX6GZiOjbzQxj+5zP2f2f8ZnIwZbmGTvBbFOhpyWJwdv7fhYyVHwePUm675vxViwSc5bMDFmGy/0nREtoCzhSrpjfnrw1vXSXAZIyaW7mEiWm3JVBeNOEbBRUbxw6xnRUqYp7rZBEB9mdn7LVXucfL4ffpG4VvSHhnrw624rz2eMj7/F3encdl7G3Z90mPulo2A4rJOHnlocxVF/vtTIZwXSdmW1ZYWPFb9CMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by DBBPR08MB4475.eurprd08.prod.outlook.com (2603:10a6:10:cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Mon, 25 Jul
 2022 21:23:02 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::b480:6a4d:2d92:f863]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::b480:6a4d:2d92:f863%2]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 21:23:02 +0000
Message-ID: <9c856c85-7bd7-9950-0428-0b2d1e1051fb@virtuozzo.com>
Date:   Tue, 26 Jul 2022 00:22:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/1] vhost-blk: in-kernel accelerator for virtio-blk
 guests
Content-Language: en-US
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        den@virtuozzo.com
References: <20220725202753.298725-1-andrey.zhadchenko@virtuozzo.com>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220725202753.298725-1-andrey.zhadchenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:20b:50e::23) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a54d1313-8de8-4d78-df60-08da6e83db41
X-MS-TrafficTypeDiagnostic: DBBPR08MB4475:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHrijToXGQgF6X/U+/TqtijhKpHf6amth30ngQwsXYXA0BdoRWHphhog4/DBGV8vwaulKsbsp/as2mR9oQXcS/r3ytTSj3tXQ0A06NzIwajyDbrdsbZOsk9SELRhfnCP11Q41WVgxOwfGlNL3QascpOjsvE0yR1PE4XFTVtHh6mKncnLUmrE0w0xsdlLI/+fV1dcPc0FdGJjtBstOtr70KfpMWC4y+Lk8kAN0WMfq+UN/yQ8d14Bl9evZlshXX+PNQBiSSX1KjEmggSm2AAPqrlf0w9wr29i617aBX98xuwARFs8F0iKHTQXTu38MSMWQF5Hl2b4HjuEvE08Dbu5rzQBjBospt1QuamKXDfI72g+N5HEpACyaa0D7R3knL5JG/8f+9DiKWGGXZe7UXW/RyFEa5FjTs9e8Db+LV8zLMYaIJnHwxrCo+TwkIXu/xCP546imbA+iY+yj7hdxFOtOBFmgbYmXLWj2/NkHQQQj3ph7x6I8viDmThMQ/L42qa2aLo8ZM21EEv0D6++WDjFk4b5B/jzBrFowxX11/sJuhab3Ld81FUSCfuzxujDT3LA7Q7eZDTUh1AzVgJptadcpmqjj1hXC5NAM8dxJQWMfLejnc7aJ368DduuOWd3Dz6KHG5bkitMWTMr8VlCvt6PO9AejhzGJQ7dz7K80OEzNgV8+0z7exNUjuJUxdPcXLxj98sRurRIFcCOBDy0G7sY1vDRd5rTQacVmbiK0J1IXKI3uVUHPUlLhKQ/hQldHM/CD30QVfb6Ev6Eqcyc8nFT1tNdKXqFgcffYAuFSBSYeHGDt0ZyQwuIVc1d7lnCaHfg7DDcKc1Ivqa5o9f/z+4dmbW5X+Qs7IQK649AOYof+gM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(346002)(366004)(376002)(316002)(41300700001)(6512007)(6486002)(6666004)(53546011)(26005)(966005)(66556008)(86362001)(478600001)(6916009)(66946007)(6506007)(44832011)(5660300002)(4326008)(8676002)(66476007)(2906002)(38100700002)(8936002)(31696002)(36756003)(31686004)(83380400001)(107886003)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTgrS21kZ1lZSU5UNkF0UnFnOUMyZWpQSzdxdkkybGVjazlEQkxCZWVGbXRh?=
 =?utf-8?B?SUNwTFNkZVBFUGZYcE1Od0ZyaElFSDF6dXZGd2lJRmt2L1pucHp0OTR0MGZK?=
 =?utf-8?B?MlUycEpjcDZoN3JVUS95UENVMy9lbkpnTit2OXM3Sk51VWxlbnY4a1hMYUhs?=
 =?utf-8?B?a2loZUVpRXlPbU5jdkNIU1FaQzkwM2tkVmVPc3FzMFovUGo3SVNYNzhtZ3JJ?=
 =?utf-8?B?N2pxMkRRQUFzSXJaN1RUWnMvY0ZkNFZ2TG9QaWlTTjRwVzdEMXZaU1N5SEpR?=
 =?utf-8?B?c284a3NYSlJzQVlrYW9pS3REN2hST2c4bkxXSHQxdlE4akk2ajNIUUh4cWVN?=
 =?utf-8?B?ak1pWGhEZktYbnRtUjhBVjdpRmt5MEZueURoSHRCd0ZVY2tvR0E5dEhnRnJN?=
 =?utf-8?B?dFJhYWZPaHk2OGMzT3ZFT3FQMEtxOVhHNlZPOWxKWFhNamR4RFdNVXdneW9o?=
 =?utf-8?B?dzZOU2NTU0JmYmF3S0k2by9SWXRlUWs3LzU4WE5GUElpbllkRjVnU1VlRndR?=
 =?utf-8?B?VWQ1VjVlZGtVWldXbmI2V29jelBTcHkwbVRqcGR2YkR1M04xZExSNlNJNENG?=
 =?utf-8?B?dFdPV2FPSk5xQVl3VVdiMlY4SkFUYy9VWkhVWDdTc0prRDJpeWh2T3RSQ1Ar?=
 =?utf-8?B?aDJ3djdUZXFUbHp2aVg0d2ZWSFFhOVZJMXhuSWo1d2ZHaFh2OFpMRkhTNHcx?=
 =?utf-8?B?enVtV0NaT0RUQXZsenZTbVU5eVo2VWcyM1YwUTVuNzNRb2JYVElYM3I5YjJF?=
 =?utf-8?B?NHViUkNvOHR1WE5KcW02czFCZm9BOUpIVzNjTFhjQ2hDSkxKODA3eU52WU9t?=
 =?utf-8?B?SHBlSEM0YnZtUmlSWll2V1FmamlBS3R3cmNWUTNFaWxYODJnT0xBNnRBcmwv?=
 =?utf-8?B?bEV5ZzNnS291NFJJR2w2WWxhZEVrSlp6NVA0bVdRckUvTGxHdFQvbkFPcHlV?=
 =?utf-8?B?N1pKbUJ5TzQxTDNxanpBMWRRN0JQaEZJOCt5NUhWczVJRlFRc2JUNXlpRkxy?=
 =?utf-8?B?MEdLeW1PVUFlTzByZWxROVRuc2I2Y2ZiY3ZNcnJaS05VNW9aYWRWUzBIdnVn?=
 =?utf-8?B?T29jUDNsTHJCWW5YNVhVZ3BrRmgyeWVMWlJ0RmRXRmVuRVhYU2hsdTdEajh0?=
 =?utf-8?B?azlmanhaUHozV2RZWTJib3JQLzlLTnZ1TjlsdzN6N05YZVhUeUwrZ0E0dXFy?=
 =?utf-8?B?aUEzL2JDeU1IRHNmNnNwQ2plNG5pYXVSNFgrRmtkUEl3YzNoTHZ1cFU1d1cv?=
 =?utf-8?B?WHVMeHp2cGkxRE0vWFNGQU9QeTVyRnNjaU9DT1UyKzBuUDMyRDhDWnlIZ0oz?=
 =?utf-8?B?VWhaVzZhMUR0N2ozWlV6bUZXZkJvc1lzS0V6Yi80UlNxemo0a1ZVRzNxaUxz?=
 =?utf-8?B?ZnVwZk1JQkJmQXVUYWF6Sk55ZDIzUmJHR0VvZGdaUkJLc25zc2c3TU5VeFVx?=
 =?utf-8?B?YTVubjJVcndVK0RvRGFmanV3Vkp3cU1Ia1pYWmtHUVhSekJia3lMdE5OR1NR?=
 =?utf-8?B?YitPckowL1NXNzJ0Z09NdndlNVNUY1VTcmwycTVjS1U3NzNSMUE3NWJsNFQ1?=
 =?utf-8?B?V2FFSEQ2eEFEZTV1TkRwdUJld3YwcGxnbXhiSTNXNzB1Y0ZyVzd1ZTZDTWd6?=
 =?utf-8?B?ZDB0UnAySHd4U29ndXBmYUJQQnJNbi9aakpTa1ZkU1JSckJxQmRJTWNWY0FY?=
 =?utf-8?B?eDlyZHpUQnYzRHgzOVpsK2FKQktIaVFiU1hOS0NCL0tpcCtkWERua0I0T1Mx?=
 =?utf-8?B?VDRUb2FVc0FBWm1wNXpLSDlSRFBCbXdOQnZVWElLWm5DdkVhdnBjei84SG5n?=
 =?utf-8?B?ZzdNcU1ndE9QaFMwV01yWWt1ZktGRXdKbUNzbUgvdWk5bHRlbENmTHRYaW8w?=
 =?utf-8?B?dHFQRzdRaFl3VmpVL0JDY1ZOUXRieVIvb1d6UkJVRDJ4TjRiQkdFUUZrckxY?=
 =?utf-8?B?c0ZNdjJ2eHdXaVdWemZONlpJWjVuS2QwWFIyS2JSVTVYVDFFLzFGbHhSYVVr?=
 =?utf-8?B?YjlPd2VVNFNZb2N0L0R3TU5KNzZMb2FSRDZ5WWV1VmljSkZ4cmNnUlVadkpi?=
 =?utf-8?B?d0RHMDdiYUluSDA0Ni9JdUtBdHd5c1NzTGZLL0UyM2s2K0dhNkVWYzlvWjR0?=
 =?utf-8?B?cDZJeXRwV1gzN3p4SzVjR1lGVWIxQlJMZGt1dW5jMURjbHYxN1I2cjZ3dTlJ?=
 =?utf-8?Q?kOSOOCL5YE+6J5zUxJDCVQw=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54d1313-8de8-4d78-df60-08da6e83db41
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 21:23:02.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12snW24xVP225wZib6S5EjXooXjIaS0lBXbRqGbsB96QRB8SaxrtDxCvwbPFP1Di+u4p1InQwi+IsZGj6Xu+RHU4jV6udP2O5VSyO5laKuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4475
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Corresponding userspace qemu vhost-blk code:
https://lists.nongnu.org/archive/html/qemu-block/2022-07/msg00629.html

On 7/25/22 23:27, Andrey Zhadchenko wrote:
> Although QEMU virtio-blk is quite fast, there is still some room for
> improvements. Disk latency can be reduced if we handle virito-blk requests
> in host kernel so we avoid a lot of syscalls and context switches.
> The idea is quite simple - QEMU gives us block device and we translate
> any incoming virtio requests into bio and push them into bdev.
> The biggest disadvantage of this vhost-blk flavor is raw format.
> Luckily Kirill Thai proposed device mapper driver for QCOW2 format to attach
> files as block devices: https://www.spinics.net/lists/kernel/msg4292965.html
> 
> Also by using kernel modules we can bypass iothread limitation and finaly scale
> block requests with cpus for high-performance devices.
> 
> 
> There have already been several attempts to write vhost-blk:
> 
> Asias' version: https://lkml.org/lkml/2012/12/1/174
> Badari's version: https://lwn.net/Articles/379864/
> Vitaly's https://lwn.net/Articles/770965/
> 
> The main difference between them is API to access backend file. The fastest
> one is Asias's version with bio flavor. It is also the most reviewed and
> have the most features. So his module is partially based on it. Multiple
                          "So this module..."
> virtqueue support was addded, some places reworked.
> 
> test setup and results:
> fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
> QEMU drive options: cache=none
> filesystem: xfs
> 
> SSD:
>                 | randread, IOPS  | randwrite, IOPS |
> Host           |      95.8k	 |	85.3k	   |
> QEMU virtio    |      57.5k	 |	79.4k	   |
> QEMU vhost-blk |      95.6k	 |	84.3k	   |
> 
> RAMDISK (vq == vcpu):
>                   | randread, IOPS | randwrite, IOPS |
> virtio, 1vcpu    |	123k	  |	 129k       |
> virtio, 2vcpu    |	253k (??) |	 250k (??)  |
> virtio, 4vcpu    |	158k	  |	 154k       |
> vhost-blk, 1vcpu |	110k	  |	 113k       |
> vhost-blk, 2vcpu |	247k	  |	 252k       |
> vhost-blk, 4vcpu |	576k	  |	 567k       |
> 
> Major features planned for the next versions:
>   - DISCARD\WRITE_ZEROES support
>   - multiple vhost workers
> 
> Andrey Zhadchenko (1):
>    drivers/vhost: vhost-blk accelerator for virtio-blk guests
> 
>   drivers/vhost/Kconfig      |  12 +
>   drivers/vhost/Makefile     |   3 +
>   drivers/vhost/blk.c        | 831 +++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/vhost.h |   5 +
>   4 files changed, 851 insertions(+)
>   create mode 100644 drivers/vhost/blk.c
> 
