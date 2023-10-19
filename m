Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93627D038A
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbjJSVM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjJSVMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 17:12:55 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2105.outbound.protection.outlook.com [40.107.6.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE6E182;
        Thu, 19 Oct 2023 14:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSiICQe9+d4ymGX+VaVk0hkEbnZxHDU0mnhtg46So25KnLXs2hXcYyF1wlgdS1xYyCwk3hj59rOga43EqpxkrGxEaEjC/5iVCMhstpXg+DBY2mOPKaKrTeWVdLgodc/+ioDN5agZ1ASGIDrWjNcBM60jtlCyfPMNT4pcwpr+/HBb21uk1/4v6TLbBmpa1eAx4NuiXKvJvU0qQLbljuLWPK/+R5hVrFZGKXtzqviE3aueQUdXpFOq1TNdIaqb3JFQQGz03USM9gnHU5CJ+kcTJIoXUGa9pTy73Ffq9WatFRJC1J651fC3x0ZvnHmdIm9g7IRG6UdTLd3KLfR4/TOQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJFbBKOlle9Yc91IgLmqNSawkv91bp+2ZMasQkci0oA=;
 b=gbozbdAqgVGLrFNzmMb2VnCm1dG/FDW9KWXqOcOBGdkoVa5QIY9gSGUq/NUWiHS9LHr20u+3q095xOgbV4kX4PzeUA+EPNjnUgzjKUu9/vkVF6APPV8iK2ABrDOSRMC7Kys27Zacj2DjURU8NWE886iBRYSvNf9U4fNV8XKQCraiUHoZmUiOBTkf3d2jGirXNtopXe9ZmJEnH1MuJOMf2EfI51ihHxKz7Hp3fVbqHIG618YHjejnTCUY3iGnOkxbEJYNeCBSzRYjULwx/lsl9CWV7CE/sR7yRfjBPOoUpSalLC+rbA9t/dhnHdcyzGw2ZGKjh+ofXq+7vHW1SkiuRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJFbBKOlle9Yc91IgLmqNSawkv91bp+2ZMasQkci0oA=;
 b=q7nJhnw8wVI6s39iCLay5eNXwGjpr+QOJxnNbF5VB+H9UMYDN060by2fJXd+uEkPnLgZxKEkEnZwdN65gD/XqbLIrSkI9ZQakBhF3/3ybNhG9K+/cdexAJ75/QCPfKNw8oOaXvb9chBFmEJ++xwPmM0M4+Pm6l0cig+8dmkhGFL991jkPbPLkfAJb6I0vg50ySACH3qfn9gidvy0DnEAfZXIcCdx8/DzT/N8mpgoGDl5noZ1AWhFoO3Cm+lxhKrH9H3LXJQSA3Jbqi3yHAyMrUgu4etTvILwZ+c3JKUxrTRgw5oaOFtTVLnUDOXIs5iLtSOz+yAPPZFrAWEg2jzHhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DU0PR02MB9467.eurprd02.prod.outlook.com (2603:10a6:10:41b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 21:12:51 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 21:12:51 +0000
Message-ID: <126c3133-2bca-4bb3-9cb2-7ca4fae2eda1@uipath.com>
Date:   Fri, 20 Oct 2023 00:12:48 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: initialize the_virtio_vsock before using VQs
Content-Language: en-US
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
References: <20231018183247.1827-1-alexandru.matei@uipath.com>
 <f2d0aaad-70ca-4417-bf8e-0d7006be6ebc@linux.dev>
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <f2d0aaad-70ca-4417-bf8e-0d7006be6ebc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DU0PR02MB9467:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f60476-e472-47cd-1bed-08dbd0e82696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQp7tcWfLwa9id0jR46HvR0KuWR7krTkrrjjioVpjqTf/emXo6EgNvY8A2Qhdbf1LuGQ/SaWy6Out8R0BwO/CYOVDopq/w5yeUMvjZ9NYHUIK7bM6kdrLXlaaNwNHrtlJhtaN9biCL/ZIOtZmlwx10Po0CQwZ3VKSolyXFFYrxx+H3Dz4H5GvUCBWxC3bks0fDLwEMDZnq6L5S7dDetvNn3kA1BF2ceWafri0LFUE97vUog2YjzM/GpeKC5J/mejHqXRpjQiX6xeNZNDYAvUgb3MsuVLpszjPofR6CXdLyty2NK1Mx77UXABO4XDeHXLEPlEvyiGJgmrDL7IfDjfNIJuxo+7gB/gXZ2J6GofJk7BXzeCN/BuNrFAHyb77C+8aG7oxEBbDxjEEP7iCmbKdx3MwWpaXtUb2H4lkOynaRRYT6TPFilhfXw8eR0q5sWPOl5BOmdUcdBqMAIo8BaPIac0oWC9KZof+fZM1ryLsAandk2VhQDceRCt7kiUBq6YsLd1M460/JK28Ker6v7bZmeSOLKRhrKrO2hTAAoAnVvrIo07uPIAlP4d2BFzWNG8E7TU5f4bbW17NOMXDZuWS4iPRuiiHanHx5S96mD7F/2RkaDrWAycSB/RI8C2N7QXM2snPSm+tCG1+eCFATJQCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31686004)(54906003)(2906002)(7416002)(5660300002)(26005)(8936002)(41300700001)(44832011)(4326008)(8676002)(107886003)(36756003)(31696002)(6512007)(6506007)(66476007)(66556008)(86362001)(110136005)(38100700002)(2616005)(478600001)(6666004)(316002)(83380400001)(6486002)(66946007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEVyUmE4S3Fzd2p5UVZpNitWR1Zhdk1TcXJUSUliQ1hwaUZHUWp0K3lPK3BM?=
 =?utf-8?B?R0cwdzBuU25Wdm5BeWRvRjNsNXo0WlowcXdrTmZBUUpUcDlvSG83MUt3S0ZD?=
 =?utf-8?B?c2NMOXgzbXZwN0dHaHRSVUdIdDdBeVF0MmwwWHpodldXdVNJWnJqSVQ3Q1Rz?=
 =?utf-8?B?WTRINHhsNTVYVWtNOU9oYUliRlZMRVlHR1RNS2NZQlJWQ3NGQXRlRE9HWEtE?=
 =?utf-8?B?citZdUFiSkc2THk1ekZJODZSOW9XbVRoLzA0TWE0aGdsOHVkaHFIS0Q1OE5h?=
 =?utf-8?B?U3dlSXlRU21PSTJCNUM3cDZMelJuTWgwRHVLdnA3L251UmVGd0cwZElYVDJ1?=
 =?utf-8?B?bTV5QlNvNWRCdEV4NzVoRU82ZU12SDNsSjFjTlV5dzd5dHJid2YxWTkrV0Zj?=
 =?utf-8?B?K3RZVVNoMkJFVCtJbWFhVWRoYzJieWRRNW8yR0RnTGhFczNvUWgweWp4MlEz?=
 =?utf-8?B?VnRGdnVuS0FyUGlEaFMwWXZ6OHlvQlowRW5SRHRpdUFUVVNwbjl1TUhxcHdq?=
 =?utf-8?B?VlZNSGpWeG5weWY5bHA4RUNZOUZhcnBBeTFUdUhOSERWVVZ4blh4LzA3cGVV?=
 =?utf-8?B?YWQvNzF5RkkwRllZSkwzejBwdGJUNjZvWHpzbC9Zc1g4YW5YeTJoOXRGT2lV?=
 =?utf-8?B?aGZOdDhQOVlyM25yUXpVOHE1NzJnTXBlZVNVdXUzekRBVGtKU0h3ZElKZlVv?=
 =?utf-8?B?NVprdWNOeEJrZ3hCVTlUZEhQWlZsdVF5SWczeHA5U3kwUTZOMDNVSWk2RUxH?=
 =?utf-8?B?Sy80Q3pXZTNYSGlkYzBINlFRb05nQTdHNUtyU0o5cGhZVzlua09kYU5OeEta?=
 =?utf-8?B?UWM4YzdnczJGTFl0aFVBcXNUWXVROGpsQ3VzSU02RXBrQTdYRndWdjg1Y1J3?=
 =?utf-8?B?ZGNqRXpkSGdtNFJ6aWpKd3lmSGdXNVZWV255OHRWMWVwWVpickg1ZzM5RUsw?=
 =?utf-8?B?WGVTa2VjUTNHQXZTMTc2YTE1K0QzR3llQTY4K3MwQ1hQejlFbm9MV0VvSERE?=
 =?utf-8?B?YU1vNDYrNVpIMW0vNnh6cEU0NCtUc1Z2SjQySjJscTZEWCtCQzFNeXFIMXh3?=
 =?utf-8?B?QS95cXpZNHlnYXdDdlNxUlhVOGJ2UXE1SUF2b0JuamswTkdtRzBIdytpaHZE?=
 =?utf-8?B?Yk9KMWdGdUFEYzJPWTN2Szh2b0VZeUlZK0doVEVDRGZGQ3FRN0M1SDlFZ200?=
 =?utf-8?B?UmtydG1WUDkxSk83UDI5Z2NpSXFRTGJEM01Za0l1dHM3aXhBemwwQnREcVM5?=
 =?utf-8?B?MlNJQ2haa205L2QyeHJUeGlPNlFsME16Z2VpRlVpNFlSMFp4OWt2NHFHK0Va?=
 =?utf-8?B?enJCc2RERjlNWkFVczVCOXZ4U1czNnpZUkFKdGhuWHAxN0IrSnVsUlpHTzRU?=
 =?utf-8?B?aEQrRnpwekxYYWsrcHJaaWZ5MjMyY0orV25DQnk0UEd1WlRic3hiS2ZNb1RR?=
 =?utf-8?B?OE13dkhVZmhudWVZZXFFK1p6eFdraFU0Y2VrV2pXYkd3UHZFTnhJVGRPUnVz?=
 =?utf-8?B?L3VTM28zeXFpNGZndzNDanRYQXlBUUlFL2x0dElRWmp3eU11dnBLdEovU3pS?=
 =?utf-8?B?a3didFcvaDNReVBNL216clA4OEVRSXpicW1KaG8zNFdkbUJCK1lHcnRrbWVn?=
 =?utf-8?B?YlovcC9FQVVQazhWQ2FpeWs5ajFDaTUrYlpQdHZET3JYMmN1bU5lQXpvaWs0?=
 =?utf-8?B?ZHZJaGMzc0ZENmxxbU5CNitlWDlBRTdnVWJLYVFEM3ZxNmk2YVljYjgycG01?=
 =?utf-8?B?cC9nbEVYYUVaWm9yR1NJUGZMU1JCUGhsdnZWRGhPV1U1L25Kb3Jtb01icDV6?=
 =?utf-8?B?S0hjM0FEZE4wZURva3NNUkdFQ3NQd1Q5eitUNytXWndDM1lvMm5QM1VWVTBo?=
 =?utf-8?B?WkZSdytOQ1owaTN6VFZXQ1ptQTBzaVE5RVlwempsSkU1ZzF3KzY1bzdZNFJT?=
 =?utf-8?B?MktmVE0wdnFubDdUb1N0dDAxODlaN25XYzZnRUVodFNHdUVZdC9jOHdFczlR?=
 =?utf-8?B?b1MyVFRUbzdwQjVHWlJtb2JNbFdEYlNaOTZPUEZQOGpzbzMvYXhFNDY0WW00?=
 =?utf-8?B?TStQNHdnQWMyS0k1Y0todklYUnlsVXV2MnR4VjM3a0ZwVWI0L3BncmhZcURz?=
 =?utf-8?B?Q2FOUWJJTWYrbFRJU1cwVlNwdk9JOXIzZ1JGczF3SmszcmZ4Q0tKcDlLVGdp?=
 =?utf-8?B?dEE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f60476-e472-47cd-1bed-08dbd0e82696
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 21:12:50.9266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44neU2rj/uUlFYaRi2x1bzJ/xVYHJqcTDU/GTag+RNJf3zRhS+ss6ie19Fx2BI4Jdqr2DR//3I0UDLgxMqXwL11+y2NNo+I5peDeGZkw+WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR02MB9467
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/2023 3:12 AM, Vadim Fedorenko wrote:
> On 18/10/2023 19:32, Alexandru Matei wrote:
>> Once VQs are filled with empty buffers and we kick the host, it can send
>> connection requests. If 'the_virtio_vsock' is not initialized before,
>> replies are silently dropped and do not reach the host.
>>
>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>> ---
>>   net/vmw_vsock/virtio_transport.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index e95df847176b..eae0867133f8 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -658,12 +658,13 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>           vsock->seqpacket_allow = true;
>>         vdev->priv = vsock;
>> +    rcu_assign_pointer(the_virtio_vsock, vsock);
>>         ret = virtio_vsock_vqs_init(vsock);
>> -    if (ret < 0)
>> +    if (ret < 0) {
>> +        rcu_assign_pointer(the_virtio_vsock, NULL);
>>           goto out;
>> -
>> -    rcu_assign_pointer(the_virtio_vsock, vsock);
>> +    }
>>         mutex_unlock(&the_virtio_vsock_mutex);
>>   
> 
> Looks like virtio_vsock_restore() needs the same changes. But
> virtio_vsock_vqs_init() can fail only in virtio_find_vqs(). Maybe it can be split into 2 functions to avoid second rcu_assign_pointer() in case
> of error?
> 
Thanks, it definitely looks better and it solves a few other issues by splitting the function in two.
