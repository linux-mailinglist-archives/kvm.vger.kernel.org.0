Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9877D0387
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 23:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346553AbjJSVMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 17:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjJSVMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 17:12:34 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2124.outbound.protection.outlook.com [40.107.6.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC9D7;
        Thu, 19 Oct 2023 14:12:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XThOO+jHkcrohbNXqyR6gSQteX90DrtRemU1Mz/WkzrW4SNq1GqZc76uyzDfDdtC6kNfYx0jG1PtzEmjpe/r6YqLsRAK+HCP0Vq99w9uCSMU8x70mpjmqo2U78t6WjEe29kklDy9Dkmqo8YB7pR5nnfljnwNM0VgLz1xgty9YP8k8P/C4sbFoevrKDWOczmqUaZtWSFG7oQjJiVUYBYoqxVkPh+9RN76yrnAQTF+vIJr9WLCpc6diMKLY4/eP6RpeQ6M0tWN06bR8ja98E7qnlMIXhX4F1jsuYtfnIs3/ScOy7Laj5EYdBSGE/BqTydRyUBCqGAdSyHTbzF1mZ7CNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Woua/Rj9GplGQXQXwb4NyW4Z1ef05S0OcqrYFIdFHW0=;
 b=ZT5h5/tEcUUyEU8IM1mbAKcReOtyrVxujbWSaG+uP6JGQEKfIAN3IhfyC0tux8Pg2e4DGin+XAipd1At2fiyx//Q7OHhppbx4Df7VZA6Nmo2HlPs58AnPEgV7WYUIzyyhYhJfPwzF3HSFqCidRaCBj4nB5CyXHZYdlbLcTyILkjmZ4PLSe/pa3oD7RuMYA+QbpWXFlvdmDp8sN7nLt4G5SCn9FddZqW8N3LaIRehQz8zBfcKLCqXnMuZ1DBYIYLj91zBRmTGRWuC8o1aH2RbmriElnMiY6Uwrym8G32Vrtw9JgHCHJwVnDc0rxqqJ3kdV4jDgTXMD0qsS5p9eLzVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Woua/Rj9GplGQXQXwb4NyW4Z1ef05S0OcqrYFIdFHW0=;
 b=k3lEW01B1ekUyGxK8U74f0XcTx6wXnfUdptDqKsdLc8UdUyzJnLu/9Kp5LOVLNQFO4cWTRCly9bVqBwUQbyrettt4gddHYp/2fQZ8Qa8pgoedQ4AstbxUw58Vww+3HJU8ndnQhuAaBAgbbtN756Xwv3I1Ao7vHOQOV3QphZnrzBzmoXLhMP7neVGXTP8gw6pMjb50mLEcZ84JDs9gUUbBaA85UH7AwjR8mYxqrBCVBjeaia2dPMUD5gUhaFegGGOo1781nz/P/McpqO95TTiltoG2toLp828TdK5shMuUzwgnHu9nUIdqUlTeccUNTbG9ZsHoXbfNjljF2hyUwpSbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DU0PR02MB9467.eurprd02.prod.outlook.com (2603:10a6:10:41b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 21:12:28 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 21:12:27 +0000
Message-ID: <f0112021-c664-41ad-981c-08311286bb43@uipath.com>
Date:   Fri, 20 Oct 2023 00:12:04 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: initialize the_virtio_vsock before using VQs
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
References: <20231018183247.1827-1-alexandru.matei@uipath.com>
 <a5lw3t5uaqoeeu5j3ertyoprgsyxxrsfqawyuqxjkkbsuxjywh@vh7povjz2s2c>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <a5lw3t5uaqoeeu5j3ertyoprgsyxxrsfqawyuqxjkkbsuxjywh@vh7povjz2s2c>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DU0PR02MB9467:EE_
X-MS-Office365-Filtering-Correlation-Id: 20173cd2-cf96-453a-6c4a-08dbd0e818d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4ZTHdHzqm9WL89yMPZuaV6y6KeOoigx5Z+qXKfILWbgnQyMDT6lPvB5GmKOfw/WUi1q9RmsfJstT/MyD5cMiDzDSVZXBUv1OdC9+D6w0fyxr1cLIgRPNBXjkAMYGcPHOlNabIyL/CiVvid7nXdMu1qn2XFLTNNW5tH+ioEff63XZIA5TumSxzUPAOu3LvKNuq4B9vRURWfz8tkBFQlOOOAFF1KNaxoHfF0WbNvunU3en2k+xsZUqZfX32TShvPSUNeDu+Y4dw9ESARbNIcFKHxdAxNnBOlPWMXHMISlZ+a9QyDX3Gb6JMuAZRIV4R4VrpEYXac6UPukVAF2bcH19R6f9unO+4JDWX8Wa3U7PgbukGUZmYftj9/4ujCDajgIw3Ak/05B9EK/WIDjZw/Fnm9SP8N1EO/KrVwpv0F/2vejqaeVwdWfjEBusoGm/EnVJJKm5Uwp6WTZq23h7pvvCsx3+ALgR1X0A8YJlizKWEHQPyD92FUO93EEaqZcjQf9t3uXEFtyZFgU8jqONw8N78Xo++S6Pab2YEC5l4+cZi2ji2K2HsBh5ZHhJnyAwtAFGajbWwB0H5gxbUDes8l4Ya28z+Q4PAR5vUD4iOHC6jYcxhO+HMd4pvckMt0J25odT53VAnxOM8QfmmqL8Us/1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6916009)(31686004)(54906003)(2906002)(7416002)(5660300002)(26005)(8936002)(41300700001)(44832011)(4326008)(8676002)(107886003)(36756003)(31696002)(6512007)(6506007)(66476007)(66556008)(86362001)(38100700002)(2616005)(478600001)(6666004)(316002)(83380400001)(6486002)(66946007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1ZEb1cyOHJwSmw3WDdiYWNMNG5VS2dBL0dGQTgwelRuUjFpdXFFbk5wOGZv?=
 =?utf-8?B?c1h4QjdSZ2gxK3p2VjNkV1dQMDZzcFZMUFpaS2ovTVc3SXFIclNudzVCRnFP?=
 =?utf-8?B?b3BrS2dhb3BIVXVoaXBBYXk2SG1LRzEvNXJHUlptT3FaMDVRenVFc2tBZldP?=
 =?utf-8?B?emt5cHFYakVyRmhzd3ZwbTZtMkJrc09qMmpaMi9MZVJvT1NrVlBEMm01REdY?=
 =?utf-8?B?OVVyUTEvcGNpdGloaVdwcUVEUXpGNDhwTWdIRHAwanF1TkovWk1RQWpEdlBH?=
 =?utf-8?B?RkVJMmZHNGtFNnlDUTRRWFZJTE9qM2JRZDlqcElrdzVYVXhUY1VOcHB4QXhk?=
 =?utf-8?B?YUJSTGh3WFNReFFhNzYvS2N1bGg2dk5GMmk3aEYzOFZjOEZCT3M5Z3dmN2Jq?=
 =?utf-8?B?cjJQUkxuSXJGWitUMC9lZkFBaGoyQVNodllsQ0EzaGh1SkJXYWxmZ1J3d0NO?=
 =?utf-8?B?WVV4c3RmUUxRZmVSUkJyRHQ3cU5kM2I1M3lZTk5vM2QxS0szVkkwbWgzSFgx?=
 =?utf-8?B?Ym5IM0NhcDdicHc5dXRPT1FpbXpNWnRRMkRhQ3dGRWlsaGFLUVJBdTREckZh?=
 =?utf-8?B?R3plYTQ4ZHVId2p4U0JadE1sSUpKdEQxQndQZ3VoSTZtMHgxSmlua0JJT29P?=
 =?utf-8?B?T1I0ZEx6ZVdvVWVVLzRLYTRwY1BpUHR4YTNLZFNSaUhSeEJ4VmhTZVA0dkhG?=
 =?utf-8?B?aEdZSmRGRUhDY3l1UFVINlBGMGV2UnFuelA4Zk5FZ29GZUdDU2FIMXpqYXdk?=
 =?utf-8?B?L1BQR05PdnNLNk9qbDBHVzFuZC8wUXRXZ3l3dlpnOU0yTzdRVVBoVXhNQThM?=
 =?utf-8?B?MlhPUjcyeHRydHJKODhINFFEV0c0VnNLMm9rWkt3Rk54djZlNVBlT24ydmtG?=
 =?utf-8?B?dGxiY01oZFlpeHZUS1RJZGRIR25OYnRjcUtVRll6Z1RFTVg0TU5sc1VMSStE?=
 =?utf-8?B?d2tVdTNRb01ZcTRSNEkwblYrNzF0RkQ3elNJOUIrcnNOT3p6VnJuV0ZLZ1dr?=
 =?utf-8?B?V2hoMFBCRUdRNWJuOUxIbWhRSFFmRkVjQW40NHVONVNYMWFRTnJTdWVJemVF?=
 =?utf-8?B?N1R1U2k3TG5veWV6NDk1b0lkNVZPbWh1UGtGbllSN0J0SmVoWmNKS3haYXgv?=
 =?utf-8?B?ZE5jQmRKOWRwcU5CZVgyUXFJNHdVK0ptc1BDMzBjSEJHQnh1di9NNHRXLzg5?=
 =?utf-8?B?bXdnK3RKZUl2THQyMVY2cE9RTTNheGF5VVVyaGYxdnJtVDhuQ2FobEdFSWt6?=
 =?utf-8?B?Qk9scThwdHpFTEM5bzNFdURjME51NC9Wb1RlNVk3eVNJVjVweTRNVlYySlRJ?=
 =?utf-8?B?dVhHMmhhK0dBcEtYSmlaNG5vY3pRdnlUdTZFRmxiUU1jdnZkb0RSRWxJeXha?=
 =?utf-8?B?aCtuRThzMXhSNk55QWVHU1c0MzlvTURONFBpUmF1MFdudFpSUERsU3ZpN1kx?=
 =?utf-8?B?bHBNUExKeVhMSWZVVVdtYWY3dlB0d1pKZ2VVNnltSkkyK3RpdzJNbFFuS2dH?=
 =?utf-8?B?SEg2UzVmc1lMMFIyMFpvcXBnK0MrNFBwTnR1bjRkMFNmTyt4MTlZWldMeFRv?=
 =?utf-8?B?djlUTko5cHlodHhBYWRRWUxHbXVRcElUcjNHVnVSTTRvL0JNSDZNdUZsaVdl?=
 =?utf-8?B?Sk5wM01NNVpRbE9KeVF1Um9lU00yQkh2MnplTGd6VXd6aDA1UHN6N2xRQlZt?=
 =?utf-8?B?ZUNYcStBdTUrOVdaVkE2eG9leHpJK2VkM0V1RXhwdnpudEUxbStLNEJVanZk?=
 =?utf-8?B?T1FUZjJPMk8vSGg1RVdoNytlV0IxbTZJWmxjZUZBcklxU0xEMS82VlhBVG5p?=
 =?utf-8?B?NEE3NFUrbnVQVTVHd01lS21Yb0RmZEwrb1lLNUltcE5BN1hQQlU2c1JMeXRN?=
 =?utf-8?B?NHhXVXl2M0VaMmVOcjdXL2t6ak5tWjVwaXhVMWZLZWNrbnpQK25tWXNHRnVT?=
 =?utf-8?B?alFqeXkzdkREWnpzeTQrSzh2YnhnRW5OeHAvejA2T1A2ZnI0TXphTnBJdXc5?=
 =?utf-8?B?V1RPQjEyZUl5aFNmMkY5bURIZzZBMUE3YTBEcklWY0lpRnFOSTAxSGVDMzFI?=
 =?utf-8?B?b1ZOUWdVaGVBbFd4SXhxcUtyT0I1WisrRTJVcDJFMUx4R3huZzdpMk1FSC9Q?=
 =?utf-8?B?dm1qQUtJVzhYZnNuVElnVVVMS0dDOTNVbmFaOVM5Sk1KeWI5cmE5a05sZ0lD?=
 =?utf-8?B?blE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20173cd2-cf96-453a-6c4a-08dbd0e818d9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 21:12:27.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhQC0c8AIsqLOZZ0NduWA7OMFNQXssnesCWSladJL88NgFSupKhzc7slQ/D6TzEl0g4r6pB1QRYLg+omNQ83H1E/jYZVuNmNzuIoSykLVV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR02MB9467
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/2023 11:54 AM, Stefano Garzarella wrote:
> On Wed, Oct 18, 2023 at 09:32:47PM +0300, Alexandru Matei wrote:
>> Once VQs are filled with empty buffers and we kick the host, it can send
>> connection requests. If 'the_virtio_vsock' is not initialized before,
>> replies are silently dropped and do not reach the host.
> 
> Are replies really dropped or we just miss the notification?
> 
> Could the reverse now happen, i.e., the guest wants to send a connection request, finds the pointer assigned but can't use virtqueues because they haven't been initialized yet?
> 
> Perhaps to avoid your problem, we could just queue vsock->rx_work at the bottom of the probe to see if anything was queued in the meantime.
> 
> Nit: please use "vsock/virtio" to point out that this problem is of the virtio transport.
> 
> Thanks,
> Stefano

The replies are dropped , the scenario goes like this:

  Once rx_run is set to true and rx queue is filled with empty buffers, the host sends a connection request.
  The request is processed in virtio_transport_recv_pkt(), and since there is no bound socket, it calls virtio_transport_reset_no_sock() which tries to send a reset packet. 
  In virtio_transport_send_pkt() it checks 'the_virtio_vsock' and because it is null it exits with -ENODEV, basically dropping the packet.

I looked on your scenario and there is an issue from the moment we set the_virtio_vsock (in this patch) up until vsock->tx_run is set to TRUE. 
virtio_transport_send_pkt() will queue the packet, but virtio_transport_send_pkt_work() will exit because tx_run is FALSE. This could be fixed by moving rcu_assign_pointer() after tx_run is set to TRUE.
virtio_transport_cancel_pkt() uses the rx virtqueue once the_virtio_vsock is set, so rcu_assign_pointer() should be moved after virtio_find_vqs() is called.

I think the way to go is to split virtio_vsock_vqs_init() in two: virtio_vsock_vqs_init() and virtio_vsock_vqs_fill(), as Vadim suggested. This should fix all the cases:

---
 net/vmw_vsock/virtio_transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ad64f403536a..1f95f98ddd3f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -594,6 +594,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
 
+	return 0;
+}
+
+static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
+{
 	mutex_lock(&vsock->rx_lock);
 	virtio_vsock_rx_fill(vsock);
 	vsock->rx_run = true;
@@ -603,8 +608,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	virtio_vsock_event_fill(vsock);
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
-
-	return 0;
 }
 
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
@@ -707,6 +710,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_fill(vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
@@ -779,6 +783,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
 		goto out;
 
 	rcu_assign_pointer(the_virtio_vsock, vsock);
+	virtio_vsock_vqs_fill(vsock);
 
 out:
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
