Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52345815F6
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiGZPGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiGZPGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:06:09 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2133.outbound.protection.outlook.com [40.107.22.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47A82BE2
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REU4cE861VmUKL13QwY8AMQxXxyUY5SqUPNoVfho5dws6EyqipihF3gLjldwd7352e66vojhQ24CZ4oDmib4XM5oTrrM2AZO+vsZ/m7b/lfNaJPcZnzqS4TNRfH679HibP5bjJD66xA1tTlRyqdmwzR/Galkll9WNPNoTaT6+Fic31eNABFBqJgadC4kb8cmE9VSr3ozMjYdYX0KI2OuOAFmKNAozX02sXbGTbR7qYjatl0sxaqEs/U3RW7SZiPF7AQ8Q3ydIiTZ1WDwmmT6R2qVZzqB8ICN8ETLNH1/8PY5xF92+3P1tt3Xbv3KXJiGG7pyJ6NDnSxR7Evyi7YoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iUFKjpQMt1qzvlvR7Qmcc+dwM+QaBqyqsfYUP6XGjA=;
 b=irh3V0AY5Z2nXPYYnbL7YNKN5Sh7hDRXHXjfOhJqsYLDNS3t9/1nD5SEHjnaRrlf+OQIzbbgUTgdJouzWP0/YzsV5geNA6AFivt04yIJXyVnAzQIEj++M03+8OL3wlXa15PpHxY5e2vD0xyNmo5OJsIkejPaSz1CaFLeWiFQf04lPk6DwfMQPk5f+Uqe06DIcoLZcl97GlqNcwUURvE6ANbek8EUH+xxIi+ObKlL3OTGDO+KCFeeO+AY2Np66tsm+jY+Ecp4qXKsOUdxJhkn1k0RmZyTBV5sblZbVWMumVzem458mkhW5x+PULPpESx5xNPWg3GwbFwXlCuKjFqf5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iUFKjpQMt1qzvlvR7Qmcc+dwM+QaBqyqsfYUP6XGjA=;
 b=dLEgAIgTY6M6MZ/vZzvmixso5Rnx0Y0jYdO0NMrI3d0BwFqK2/pWS62mxMuK95pXftJMdhDZiLf6J1KG/7WapuIfSpV/McijEIYZBVCrzsNrlmfC9u3Nc3vexMhsQFyT5TYPtRNLRk7jE+9HbqyWUYfS1AavKqmEVAW+4imrwkM9k2HRBILkMLCFggbXz/GhsLDFIf5N6A48Q3bKzQJsL3ts+RsR9tJAccgNI+aNDNY1MmivxOf7IZYO+pCHzN4tY62+ASRjSHX2TMBykP23195db4XuZD5EuDPSoJgwyTEwg4X0dzjecfz8Ap7CIoS5bWFujDejWjVceWwXvCOLJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by DB9PR08MB7129.eurprd08.prod.outlook.com (2603:10a6:10:2c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 15:06:04 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 15:06:04 +0000
Message-ID: <1cc04c01-ab10-8fa7-e2c2-3a835cb0de10@virtuozzo.com>
Date:   Tue, 26 Jul 2022 17:06:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH 1/1] drivers/vhost: vhost-blk accelerator for
 virtio-blk guests
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        jasowang@redhat.com, asias@redhat.com
References: <20220725202753.298725-1-andrey.zhadchenko@virtuozzo.com>
 <20220725202753.298725-2-andrey.zhadchenko@virtuozzo.com>
 <20220726104354-mutt-send-email-mst@kernel.org>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20220726104354-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P194CA0052.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::41) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64063b9b-11b8-4bbb-e185-08da6f185beb
X-MS-TrafficTypeDiagnostic: DB9PR08MB7129:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPptsXcdDW9VPVzyhdKRgePdJNbADPE6DXfTEigqtN/KTUvK/K9cVJbZ0U4lx7o6JOWb2Cmcmqn8QpO8U4kL5ykCKzd5djSjp6gSBHyUqLHpA4aY/G7xwgpX3B59ux7RuW/i6phU3yMw0WspezqZ1xI8rz4a2KNMijk5lEM1ZNzyFpdfFrwcGXwSmEyiXpafqpKGZBXKk0b8JbLQgc3SuEE5TERCj7G5FYG8+Ar/+wyZlJlPMQqMt/TuUCwgRNGKzvRWkLBvYLPX+E5fFPVIottKN9EIkQgXpMOG7fNIwoIDokJ6FveUGpQHlTWaU4iV7GcqAufLYWc3PMV31FqxgxuylVj3v0TPVwiHVgpunRAnO+D/pjaOpkiIrw+wHw+yUhugZ9o9GOMO4IcGbqJeQY83VHj/fzJ7/W4HxX3bgtolJbyB2v6YHU051f+m85lhxi+stJozgNubXrDQOEGl+m8u9cEliRbfOwPDCvjAKQ/+WoeoOkLFQb7EPqpM68DiVVxv5v+18JonA/AWmxKkvQ5Rzb81s4BeDyHY/kOvnfgF37S0gOe1/ElGZW4zymewKYsZ0sYhj+6RCRpvK8HOPehzANHAGrBvUY/JaCZXPqwAQgRJ6tOQ+1vIyG3h5lq44mgK1rtg6k4A7xtKh1YL9mDrMqWBnk/Um2lunrcIt5jyff+DDtyt8GY113U/v5FsOPon4BLSP7B87t2aNHIyHA11DTY4ItUPNtEaN1AaHbsmB1nuRWs+0jbwKg5Jvr90SpA4IEcF5q/Rx5q1e8NELqmOWMaEcAurVKwbTmGB9D7iw3EGUKFtvg8uGLJ+TawqKN/d8yiHl6iIpNRk1YeLtaXuTwInkHfHisx6c2LdHOZtw+VIN76q4Fnxt6ZH6NKS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39850400004)(136003)(4326008)(8676002)(6506007)(66556008)(66476007)(66946007)(2906002)(31696002)(5660300002)(41300700001)(86362001)(8936002)(478600001)(52116002)(26005)(6486002)(53546011)(6512007)(2616005)(83380400001)(31686004)(316002)(36756003)(110136005)(186003)(6636002)(38100700002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1F6OGVEZnN4NW50SkozaFJTU09UNEZ6UWJYM3M0Ry9pbWhBRVR1akJMby94?=
 =?utf-8?B?bXhNdUVkK3c4dVdYcXkwajhUSFZLWEQwTCs4R0t6VzFxN2pzZ2oyV2tVWncx?=
 =?utf-8?B?ZUpNQXEzM1l3T1RVc1BhM0xsZXJBTEJObStybDVaMEdzdS95bFUzcVZ2Sm1n?=
 =?utf-8?B?ZnJuZGdqSUN5Qmw1RWYzQi85Z1djSk5hQUpFNDdudjZiYmxPYTVTalQ0V2d6?=
 =?utf-8?B?YUM2bDlSczZyeVZBYkZFWEhUN0ZCNm5mVXVKeGtMbzFxM3djcmtiOUU0S2Jn?=
 =?utf-8?B?QmwzOVRwSWJDSlJRbFpkait1bkNLMCt6dWcxNFhTRXZPNG01dmFDcm9aRzU2?=
 =?utf-8?B?Q1Q1RTVtbzlOODhmdlRHM2JWeTk1aTlMZS92L2xWQWx1a04vTjdxTVN5WmVV?=
 =?utf-8?B?cWw1T05TQ1dyU3hwdXhNMlJsc25IZ1lSL2VKWHlnaGQrSFhlTGE4RkVXU1RB?=
 =?utf-8?B?QzdFVkh0WDYreXMvUVdXMWxpU1RLQXFvdHBlU2hTM2hua0lEdmJrR1BsaE9l?=
 =?utf-8?B?R1NITXpwOTM0ZE03NU1pb1dkcmV0WkpzQWxIZFJ1ei83Qzd0RmtGR2o3THgy?=
 =?utf-8?B?NDZuaVdxSjVLa3FJMGNERmMyeUpaTzM1OWowS2dhRmVrak42bmovL2FqNHhT?=
 =?utf-8?B?RzVYYXlsRCtDOWZjMzZKbDdIdmFaYzRGaG9OZzg1QU1FalhjUmQ0QXZqaTl0?=
 =?utf-8?B?Rnc0RVBKVkNwS2YwSEtmOUxFcmVzWTBxNThCNkZZRzUvZS9kamhldzZSVHBS?=
 =?utf-8?B?TVI4VlQ2M3ppKzBINmR2eExVbzNmWTRyT3B1UDJCUnZaM25pRnZUSGJzcjVh?=
 =?utf-8?B?bm1HQkdxWitvV1M2dTRUcjBVNzR3WXYrZ2NLRktZMHY1NEhlQ3gxdW1sZ1RB?=
 =?utf-8?B?UHV4SWNFcDJ0VEFVRmsyR0s2WFJLeVpaeEV0VmwxWlc1aHJrSURJdG9qSjBq?=
 =?utf-8?B?OHFlWVNUdkhTTkJjQzJyNHZpbGhybmZoOU5IQUJjZ2tGV0dqQVdVemtEeVIx?=
 =?utf-8?B?R2RKeEZVNGpKRTM5eWpWWnIwM29CYUxmYVlPcE4wc2k5RWZMMjlmNUZnUXMw?=
 =?utf-8?B?REdOODZNSWJ1SGo2K2ZEWmkrbDVzdkdPNDV1YzNzd05mbldxUnNyMjBkV3pY?=
 =?utf-8?B?L0dwZTVCeGNESVd3amJOZEEyOC8yY2FMYVF0Q2k1YlRyTnlHUW42amlsL0pS?=
 =?utf-8?B?NGorczRHTEtIOGgzellpVzJxbEVPVlZyamR1VTVzeEVDVnB2TlFmQWVhVndP?=
 =?utf-8?B?MUVsMVdVZXlzQVVxR3hYclFHV1JqeTJSTjRkWTNJcjl0c0lrMHhpY0xFWmVG?=
 =?utf-8?B?c2xnZUlPZnpvRFRtaUhVZkhxNGRnc0dvZmN4VEtNeDZQcTl6ZmdXVytlL25t?=
 =?utf-8?B?Ti9JMGEvWDRNa3ZSeWNEamYrQjRUdVRXQmF1cFAxZCs4dExIQ2NPbmQ3K1ZW?=
 =?utf-8?B?WnhWanI0T2ZWR1FNSDBRcTRwWXZmSGtyd2loOWJzblhzZzJyb0NKYlc2RFJO?=
 =?utf-8?B?aEVZRm1KdDBTSzhrZzNTS2NLcktPL1B5MDl6eDIvVkpDSGdESm92WEhvU1Bi?=
 =?utf-8?B?QTZwc1h1NkU2ZW9tWnM5bWk1NEhsYmVLYVlsaUQxcGJGNlhHRXExNDJKeDBs?=
 =?utf-8?B?c3VYUnFBdkxQcU56TGY3RDgveXZOclBOSlJGdXR0enNyUjZ2M0FJa1JPNno0?=
 =?utf-8?B?MUh4alpuWHJTSVRLR21RY0NMLzdYRk1MMkZlMzNydk12TFJONWRmcFI5S3ZG?=
 =?utf-8?B?V1czK0Rjc0dxaElyK0FtalpmQWFINXlmTENrNUMyTEh5ajl0Nk9WQ3VSdjJ0?=
 =?utf-8?B?QThQZVJMOUNVRkNuaFFlWFZwb3dkNUFsTzM5Qy82aXYxQTQzUVViSDRvVk80?=
 =?utf-8?B?d1hvNndwa3pMRnRtbisrMzRMV1ZCcFlTYkVwL2taa1AyMENNcEJ6VU9USHVM?=
 =?utf-8?B?M2JoUUlTeWw5blVudC9JL3hIN3Z4Uk5VaTJ0d1Z4NkxKdW84MTFKbC9PZnZB?=
 =?utf-8?B?SFZQUEFCNC9Da1VUem5hT0dkZzhjNG81TU90djl6dTVtdFFKb0dHS2lybjU3?=
 =?utf-8?B?OUQvNWU5ajJJRmIydHN2UVg4eHpONUN1bnQ2RXUyd1pOSW8vWElWbUthMVJ0?=
 =?utf-8?Q?oE7TzxjAsqMvamXlDzDtLtb95?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64063b9b-11b8-4bbb-e185-08da6f185beb
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 15:06:04.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8bLGoamKfaF3diZDAAo1IJmbA75XnvzQhtDPwLfLmFTuPdaA4+ujs1LFxFcUB3sdzaq5poKbarGAbmFB+HTsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.07.2022 16:45, Michael S. Tsirkin wrote:
> On Mon, Jul 25, 2022 at 11:27:53PM +0300, Andrey Zhadchenko wrote:
>> Although QEMU virtio is quite fast, there is still some room for
>> improvements. Disk latency can be reduced if we handle virito-blk requests
>> in host kernel istead of passing them to QEMU. The patch adds vhost-blk
>> kernel module to do so.
>>
>> Some test setups:
>> fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
>> QEMU drive options: cache=none
>> filesystem: xfs
>>
>> SSD:
>>                 | randread, IOPS  | randwrite, IOPS |
>> Host           |      95.8k      |      85.3k      |
>> QEMU virtio    |      57.5k      |      79.4k      |
>> QEMU vhost-blk |      95.6k      |      84.3k      |
>>
>> RAMDISK (vq == vcpu):
>>                   | randread, IOPS | randwrite, IOPS |
>> virtio, 1vcpu    |      123k      |      129k       |
>> virtio, 2vcpu    |      253k (??) |      250k (??)  |
>> virtio, 4vcpu    |      158k      |      154k       |
>> vhost-blk, 1vcpu |      110k      |      113k       |
>> vhost-blk, 2vcpu |      247k      |      252k       |
>> vhost-blk, 4vcpu |      576k      |      567k       |
>>
>> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
>
> Sounds good to me. What this depends on is whether some userspace
> will actually use it. In the past QEMU rejected support for vhost-blk,
> if this time it fares better then I won't have a problem merging
> the kernel bits.

In general, we are going to use this in production for our
next generation product and thus we would be very glad
to see both parts, i.e. in-kernel and in-QEMU to be merged
to reduce our support costs.

I think that numbers are talking on themselves and this
would be quite beneficial for all parties especially keeping
in mind that QCOW2 is also now supported for this kind
of IO engine.

Den
