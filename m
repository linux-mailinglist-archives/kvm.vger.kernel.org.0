Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B97B5FDF0D
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 19:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiJMReI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 13:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJMReG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 13:34:06 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70124.outbound.protection.outlook.com [40.107.7.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33FE1D66C
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L26ijbRFoCz0tFPkKTZ7Tuvbwe2InwYRMo45dfKpy4OBoUQUGeGTo4IE0G84E6pSpsWeTBda/nHP1RBJ0BrB2TViLsZ14A4cRU6VTN44yFyBPcewMph7kz6sIV+EUpuUSarQqXscoNjwGXHzitD+pBokW7P4LzkrnJYHLFHaOTdFyfnwWQsJiOLFNoMjzK5+hQBVYQ3IMUQOl3r4jsejkGy6f4NQXkf8g6OXCjhIQs5dWU4tYiCcYjbQ3M8JvpPRv2Sp/XCX1a9scbCBxQjXQB5jkWKSVLfNA7mNynVpMeU+fcszR7ubyeKR/0eo42fnp6n9gNMdsPZL292PLO2b5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05MYHwR72MAXlxBFwKNYlxkI5fs+2errC2ZVPeKb9hw=;
 b=gqmxFqfuM3yTb/UNHBcC3o7xgCldHyWaPAkH8iD8EjwMOj+cXsmWJx2VhmUwLUKNRAeeedRvWbhSfz9v3RCmaTYQKnYBqRy05khrlvd9xTSI4nACx/SIepmPkehns4A9xdF9+NNcX7ex9gpG5E2uuWSLt0EkAfK4+OC56kJ4J5Px3heVGH35SuOQ3jRLheA9ghiNYQnjDwAFg2Izqzdox8j7sO8SsSStzU7mwLkjTh92Gsd8X6N/kEX6/AK4Y0nzz9tq92aqJynqrGgrrM78/g1aWBKd+ShWxn0o0U/uNfoKSdBDWxG+7nLg0m6y6/mi0Ezut1BPCWUOB6DdWTMS0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05MYHwR72MAXlxBFwKNYlxkI5fs+2errC2ZVPeKb9hw=;
 b=Uc3J3hb9MMP9RAa844icz9rHybqeZVBWZmO7LkQtuqEbDJ3H+j7UHg7f74LrchZTDAGnfNXOketA88ZqmaLf+NPHPam/RW1KOyutLJw/4327PUv5iLpqzxfMFqyKXRZtu4bszJL0tGwhpXVLyQ1ugAdZDUcu6l4hfbjVhozvb7cbT4Y26x1zedczQu5V58D9JQoTNPK9TB9ZAJoGA6AfNgHW0PazwyDrnM0D4TElYGCfCHBzQ0B4qU6pP5q9kcbOGocFHSHbv1Dxhe/BCGy+7nVNXBCvOl+izpAuWZNDunIXHRqgi5BL6R9S8SLW5725CeN/tL8ylzeUdlQTSe8m6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by PAWPR08MB9613.eurprd08.prod.outlook.com (2603:10a6:102:2e4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 13 Oct
 2022 17:34:01 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::c137:8410:3cb7:e685]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::c137:8410:3cb7:e685%4]) with mapi id 15.20.5723.026; Thu, 13 Oct 2022
 17:34:01 +0000
Message-ID: <5bc57d8a-88c3-2e8a-65d4-670e69d258af@virtuozzo.com>
Date:   Thu, 13 Oct 2022 20:33:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [RFC PATCH v2 00/10] vhost-blk: in-kernel accelerator for
 virtio-blk guests
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
References: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
Content-Language: en-US
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::18) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR08MB5732:EE_|PAWPR08MB9613:EE_
X-MS-Office365-Filtering-Correlation-Id: fdffa388-f370-40ea-fcc7-08daad411db9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wwg83ASbspb6n6i2EsP/w4IVHcbf/V7miltdbegZTrQkqlJEtFeBJACVfnYiTpc1FJhJ8t6/+//9lHzYQJasT8hOrqOZmRLLtdGUNRu10Mf3EiHwuJFiLs8ats/wobEC68vZtR6X2oXMdmFxYZGeWe5HAfzv6QyysufnPIdaMs8TFdhYYKnybNplj7Q/dcrUzH3VVXfnLxFnU9lRe1/bukFfw49DBn/XUwnw7tEQCOBN6WqtASqCz9ogH+3etsLeljiH6FIB7Ja4jS90c35EHpEgGYJy/FCrqdN21vTfwFU1ne9+sUKQ8GdM7gIs4R5ZQdRfNltbZQmACHSXH5A70B0RPtKqWntXPa+YYW6ghFwRwyGeB7hDA3DmjVu2W3tPIPj/zuA7FuUOj/bTZMBh5/M4dsqx7vHhb79ClTC4gAABg6hwx4Ul/asRw0TFreTSrCt2+ZNiZS2Qdyk2KQG8NdXjSvIqP9kg6N/x+ZyKVSShe2qPYu5j0EcoXlUv+R/eGo8jhcai5RK21CphkRG3inXiGFQKVOo9DSqDU2s+szhQDyTwWRkNQ5uaCVax/cIRnPB7zETWg3iQp09XnfCpX3KXuEUaw3vutguj9maYjKlLMkPVybsm1tZsUdJbqLWC2+2IyVhr9sGTw86MC8kPliadbKVI5Y9eDVtl9WTlZGjvdd50H8GswcprGOJ2ejKz/0Cm19qFvvJQy5928/BOplxnSNNbS58OkftGFWKt08rQj9KkazXZB9m5fJglZz9e1g+XHNii+9lq/YsI/uyoc04yH4brwtko5YqN1IGWbnhF54j8befkHphPKSohS2bH3g5/PYbl1RLKqyj1iTQbRsBXK/rWMN5MmopKKyTtVxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39850400004)(136003)(396003)(366004)(451199015)(36756003)(31686004)(86362001)(38100700002)(53546011)(5660300002)(8936002)(83380400001)(31696002)(26005)(2616005)(316002)(6916009)(44832011)(478600001)(6512007)(41300700001)(2906002)(66476007)(6486002)(66946007)(966005)(4326008)(6506007)(186003)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0w4N0pRT0FmOUdhVnVybTVnc2t1cUJRNXIyaXRpb1FvVmNtOHJiK2JucnJD?=
 =?utf-8?B?T1NqUGxjaFlWYjQ4QnZ2MnpMTjhqbGREeUI4L1ExTXVJL2pkZlZoVDRCYjNB?=
 =?utf-8?B?NWc3QkVxR01ienNuazlsOHZzQVQ1bFcwb2RuWXRMblZuK2JVWlBzc1ZSOVp4?=
 =?utf-8?B?ZDVRRmx0RkZBalBxSVRMT2FjSTdFb2szVmNBQ2JpNWwrWXFBMW9jbC9MUE9s?=
 =?utf-8?B?VW50K0ZBTEhVR2JJZjNNM25aSW5DYnB3aFhiV0pFakxPMFJoVkl6NjRYcVVk?=
 =?utf-8?B?c3NaNjFMVTRnL1hIeHRkK0VVL054cVR1QzhtKzF2L1hLSG5Ra21hQUNCbldL?=
 =?utf-8?B?NWNQbHRPcnVVQUpRRDFuNzFOT3lXdThHbVJFWmljU2N1YkJEWmVTSGlwd3pQ?=
 =?utf-8?B?eFFOaTZTVjNLVEp4dURKSUNGMGRtQm5HWlRQdmE0cTI1cm9SWXlHMWEyQ3do?=
 =?utf-8?B?TzhEVnlwcXo2UFRqQyticnpUaHBXUTVhdFlRMHdQQS8vMVlFTTR2Y09PUDE1?=
 =?utf-8?B?SnEweTd4SGdEc2lVTmpJcmd0NXlRY2wxaFJiY2tTYnZmUUppcXZmcWFTbFBD?=
 =?utf-8?B?anVhUCtPUHc1d01NaWFXV2pYa2RiY1lXZ2loRGQrcklUdGtJZ0ZlL1poNk9j?=
 =?utf-8?B?Vnk2T1FHdHlhUEVvRHdDaFc5NWM3dzNpM3VGMDN1K0FZQk5pd1VEaXFPYUxp?=
 =?utf-8?B?Ynoxb2NFeVFZMmVXc0pRalJqc010R21CSzdaYUU2SmNoeEcrNlptTEs5RGZn?=
 =?utf-8?B?SXFpOHVIVytKU0lEZ1hOWFlFNlpOZUhHcHQ4MzJSSUJzOXZ3Z0JOODhoMDRv?=
 =?utf-8?B?WXU5dEx2NXIzQlEzak5MWHNsVXFoVTdFVnpTbTRrSmY0dytRejhZdDgxajJQ?=
 =?utf-8?B?RGJORnFqdnRUS2VydWljeGphR2ZNYTlEd1VSV2kwZGlXRVpUd0gwT3Y5REox?=
 =?utf-8?B?NWpPQTJ1Szlab0crRUdCVXdJL2tpSEFHbVplTXdGVTRXN2dIaytYaFJCL3ps?=
 =?utf-8?B?dWFKdndkaHNwcG1QemIwMHlWWG11dVBUK0ZrbE9HTFlmeUxRd2Z5cjhIU3p3?=
 =?utf-8?B?REd1L2pMbXgxQ2V1RWpqTlFCK2hEZjlOcFhNeDJXcUd3VFhJYVVOYXRvMTk2?=
 =?utf-8?B?a2VXSGZ2MnVvUWtGejNxOGcwZnljcUVjL0VSaWxqdEgrbzZFdEdQeExhaFFY?=
 =?utf-8?B?NWhkWUNOcDd5UFhWTGdiZGN0bkR5bDB5Ni9oU0UyS0w5SzZtT1d0WUlqRWJF?=
 =?utf-8?B?WWpzd2lKbk5sRU80OWtwZ0MyM0lCWFJwNjV2QjR1Y2Q5a1pyNkxITWN5NzM1?=
 =?utf-8?B?L25sNjB1RW1TU09oNnRxc2c5YkJSZnZyQ3ZDY0VYa3g2eUN1ZXhWRjZSQTlJ?=
 =?utf-8?B?Q0JrQythdHpUOHArQ2Z5TEtta1JNc2VLbEswMnN5SGRmY2lyek5WRUxhWVRI?=
 =?utf-8?B?RW5ib1Y3STRreTlUaDM5RHRMOTVIZnNRZUtuVU9GRklGK0FHVlM1M1ROaGNQ?=
 =?utf-8?B?L0FqR0tleFQ5aFBRREpCbmlUckhVRmZMN1JQWkxHK3JEbXhWMGROZUpMUi9H?=
 =?utf-8?B?VDB6MDNUeGZ2WDBCRmxxczBaNHlqTis1ekwyVitRYk9IUUNuV1VmbkFHaFRZ?=
 =?utf-8?B?NHJSTDRUVnF3VWdwYUY0MUozUDJaOWxacG9Vc1EvczQ4TWtoWllYbmlneU9K?=
 =?utf-8?B?YmNLU0hQY3VtdVNwSmJTUHhkeElqYjllS3o4V2RydlA3clVYN01DREJzZ2pX?=
 =?utf-8?B?MEdrLzc5OEtuWk9wNGZTcEtVTm51QnNCK0wyTWFhOTh0Z1RYdVVINE95a0d1?=
 =?utf-8?B?R3pjQkdrbk9WRisvb09BT05DdjVhK2hhSmR5ZWFKcjR5Y1FDRytMaHUvbUM5?=
 =?utf-8?B?a1NBVHkzYjJFck5rYTJlYVRLc2hYUnRzSjlmTnNIaUYzd2V5TWMxZTRnYlFG?=
 =?utf-8?B?STFuS2pXT2kyR2daRy9IU0dGa0d3V1ZrcEVwVUZIT1pYTUhodk5VeXlHMzRx?=
 =?utf-8?B?RWVGY3pRS09tMDJRR0xRbitrR3p6bEpKeW5USi9Samw1VEpjY0JOY3FTU1FV?=
 =?utf-8?B?WTlFWXV2RDZ1VFY4UTcwYmhBcit3V3lDUWJTaVQyZzVrd3lrUnFJN2xrS2cr?=
 =?utf-8?B?eEw1L0VBQTFkSDJFVVRPeE1QM1FIV0F5MXIwLzhEeHFpaU4wcCt5eHUrVWdI?=
 =?utf-8?Q?gxoBajTUy29rtJyj6/oD5tM=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdffa388-f370-40ea-fcc7-08daad411db9
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 17:34:01.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKXhRyJBuR7t5TRJGQsGWXY4bIen/YFRDkeFwAcmSxQPrkJAb5TCcACdcXcQ8Aflw7OXNxzRaRDZx1tUxXtwiuvUapB1bc0HgH6KDrsNf9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9613
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, I misspelled your email while sending the patchset.
Linking you back as was originally intended

Kind regards, Andrey

On 10/13/22 18:18, Andrey Zhadchenko wrote:
> As there is some interest from QEMU userspace, I am sending second version
> of this patchet.
> 
> Main addition is a few patches about vhost multithreading so vhost-blk can
> be scaled. Generally the idea is not a new one - somehow attach workers to
> the virtqueues and do the work on them.
> 
> I have seen several previous attemps like cgroup-aware worker pools or the
> userspace threads, but they seem very complicated and involve a lot of
> subsystems. Probably just spawning a few more vhost threads can do a good
> job.
> 
> As this is RFC, I did not convert any vhost users except vhost_blk. If
> anyone is interested in this regarding other modules, please tell me.
> I can test it to see if it is beneficial and maybe send multithreading
> separately.
> Also multithreading part may eventually be of help with vdpa-blk.
> 
> ---
> 
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
> have the most features. So vhost_blk module is partially based on it. Multiple
> virtqueue support was addded, some places reworked. Added support for several
> vhost workers.
> 
> test setup and results:
> fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
> QEMU drive options: cache=none
> filesystem: xfs
> 
> SSD:
>                 | randread, IOPS  | randwrite, IOPS |
> Host           |      95.8k	 |	85.3k	   |
> QEMU virtio    |      61.5k	 |	79.9k	   |
> QEMU vhost-blk |      95.6k	 |	84.3k	   |
> 
> RAMDISK (vq == vcpu == numjobs):
>                   | randread, IOPS | randwrite, IOPS |
> virtio, 1vcpu    |	133k	  |	 133k       |
> virtio, 2vcpu    |	305k      |	 306k       |
> virtio, 4vcpu    |	310k	  |	 298k       |
> virtio, 8vcpu    |	271k      |	 252k       |
> vhost-blk, 1vcpu |	110k	  |	 113k       |
> vhost-blk, 2vcpu |	247k	  |	 252k       |
> vhost-blk, 4vcpu |	558k	  |	 556k       |
> vhost-blk, 8vcpu |	576k	  |	 575k       | *single kernel thread
> vhost-blk, 8vcpu |      803k      |      779k       | *two kernel threads
> 
> v2:
> Re-measured virtio performance with aio=threads and iothread on latest QEMU
> 
> vhost-blk changes:
>   - removed unused VHOST_BLK_VQ
>   - reworked bio handling a bit: now add all pages from signle iov into
> bio until it is full istead of allocating one bio per page
>   - changed how to calculate sector incrementation
>   - check move_iovec() in vhost_blk_req_handle()
>   - remove snprintf check and better check ret from copy_to_iter for
> VIRTIO_BLK_ID_BYTES requests
>   - discard vq request if vhost_blk_req_handle() returned negative code
>   - forbid to change nonzero backend in vhost_blk_set_backend(). First of
> all, QEMU sets backend only once. Also if we want to change backend when
> we already running requests we need to be much more careful in
> vhost_blk_handle_guest_kick() as it is not taking any references. If
> userspace want to change backend that bad it can always reset device.
>   - removed EXPERIMENTAL from Kconfig
> 
> Andrey Zhadchenko (10):
>    drivers/vhost: vhost-blk accelerator for virtio-blk guests
>    drivers/vhost: use array to store workers
>    drivers/vhost: adjust vhost to flush all workers
>    drivers/vhost: rework cgroups attachment to be worker aware
>    drivers/vhost: rework worker creation
>    drivers/vhost: add ioctl to increase the number of workers
>    drivers/vhost: assign workers to virtqueues
>    drivers/vhost: add API to queue work at virtqueue's worker
>    drivers/vhost: allow polls to be bound to workers via vqs
>    drivers/vhost: queue vhost_blk works at vq workers
> 
>   drivers/vhost/Kconfig      |  12 +
>   drivers/vhost/Makefile     |   3 +
>   drivers/vhost/blk.c        | 819 +++++++++++++++++++++++++++++++++++++
>   drivers/vhost/vhost.c      | 263 +++++++++---
>   drivers/vhost/vhost.h      |  21 +-
>   include/uapi/linux/vhost.h |  13 +
>   6 files changed, 1064 insertions(+), 67 deletions(-)
>   create mode 100644 drivers/vhost/blk.c
> 
