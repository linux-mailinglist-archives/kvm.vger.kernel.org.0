Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC87D3A0F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjJWOwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJWOwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:52:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2134.outbound.protection.outlook.com [40.107.21.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A381A4;
        Mon, 23 Oct 2023 07:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bG03PNRkmeHy7Rz/fn9UmTudhuMfqstMJLTlV9p1UhyL025IGXF0UEjyYoAwy3drB4vxNs7FJgxwA6rKU+ZQx49KcVVWvMFeZf4tClPlqHDWAduxpQqxxz2tClaSlYRj+z8FRjh0ScgkP1+0Eq3ZZIWNRWehH3f78x546qBJQ2ZZhkBNSRSVz1dzEx4cwET3+tqG+r9cyoVePpCjMz29oLQcO2ELqr0aewrxrQWmTREE+EIPNMSjdNvqGFBuVOINk3GBgQNUavV3OfT+YQJ/9BvSvWiLFTzi1pWMXsVwfEUsWCRUMD1aKA9lm95PJe6stm8BeeaUfa2ry5cEjE0Cgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUquwOTVALOaStmQjLfBaupOJ/IMlrj/jhRXHn/6QdY=;
 b=Ij02u0DWM6USExhku4pipSts4hq0QAcLNHCLxvAagkN+adRpul2gqPWguvsPwwRODdp4MApCif4yhVA2Ba8WyAExYtP+5H4gRoL1hot50xiqhqbDpss93f0/gaKndGUFXaWFbFVx9MSLXS/fSU6hBioExXlzMKfpl79LAowsF6Jb5YJY/RL3YrzRfNmBrvCrSFPyBcywouipVzGHB48b2SxbBBd9tYprVrLjl3vK6LpM1tYeqMB7R+ltXxIO3o/7LPNuFoVHbaBdMXEJB19eaQpEkdNXYqoO3vm3Pt0k275EbjEDfzgqz05b6wpbKfo0lReW6jbAVdj/Awf+r92f5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUquwOTVALOaStmQjLfBaupOJ/IMlrj/jhRXHn/6QdY=;
 b=VHarjz+FRZwsQwVthjjqs7otg0dlI8j4KgpbDWyEGsuboAOkjBMpTzjrrYIei18eA9ROo7jXDfZjIar3njfAFxwzlne1gEvl13V5CgvUACvOhuOApFPF2Wq6KePYakqT0QRRG9ssIBid1Zlto+7jaJmReb6M/wzzszIi3HA3jvON7cRwG1Of6SIpyN+H7vH968xU47PqG7shx7bjGCOWuYZXwgHrBlh0CMNCDc6o5Dbd4JTYHEiQMJaydTR4WfENdzN+eqdcsbwtu8f+HcGilyDm/R05I0ykONoLoFjaayLPtxWLWnze2xQZjimNblezL1Jo5wOU/MWQhMLZAjgkRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS4PR02MB7855.eurprd02.prod.outlook.com (2603:10a6:20b:4c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 23 Oct
 2023 14:52:15 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 14:52:15 +0000
Message-ID: <0624137c-85cf-4086-8256-af2b8405f434@uipath.com>
Date:   Mon, 23 Oct 2023 17:52:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vsock/virtio: initialize the_virtio_vsock before using
 VQs
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
References: <20231023140833.11206-1-alexandru.matei@uipath.com>
 <2tc56vwgs5xwqzfqbv5vud346uzagwtygdhkngdt3wjqaslbmh@zauky5czyfkg>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <2tc56vwgs5xwqzfqbv5vud346uzagwtygdhkngdt3wjqaslbmh@zauky5czyfkg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::36) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS4PR02MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 53aa348a-3a0f-4b3e-39f4-08dbd3d7a57b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDTDE9b7kJKI9rk6KcqcpVZRVsXMg58PZv3VNoG/BVhODHb2rAJAYC2mOax7M1c12JGOTXvfKP0M+PI/Xi9b7by2WkGYgogUgltJx1IldjIaWbrLytK2Y1Pk+6GruemkKmnXbMv7wJiP4QU08IS8uED6zA2zNSRbvj6FH1uA+uXgD/FRKAQIJg3oUMRQEf7bBKTWvQCu+DV0/4ZlfkhYt88hKXXB+hqFgSsG4Ld5jHwOWLtOO9p0gGSd5srSW8wkwtP7ijHoht+BdFi+6TVCw51ebMy9c1qh1ZU0GQbb8c4xD1b2R0wkrRBOPKX6UHVcYq0eoDXUjhigSIK/cWxp3pTBxgbSPkqsz4uc6xZnkExIPOEz0OhAcihiEOr6XTq4u3PngoJyCXO/uiRRV/Qr/l79ehPHCFvLJTUPDc1Sfof9F3p3BWWrPkedFrJ5eVwnLj3eeFsN73nSYDQvvYsRT69PoSg33/O8y3F61TPwQmlcfiD4Rbgt2iWvVRms0sxD1bNJyQadRIG6dcXw2/d/1o1y8FmyhgoGAFP0lb1fxcDMqOaNfkgxmIKrn2hqAw7O/bqpIdrtBwu0+ulqX4FlbF+hZmLkcXhQchalmd4q6VHiviXJ+8mNe3tddLFLfEoz6T2sj5NwLqF+6RlVSWDSIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(366004)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6486002)(316002)(38100700002)(54906003)(6512007)(66556008)(66476007)(66946007)(26005)(2616005)(6506007)(478600001)(8676002)(107886003)(53546011)(8936002)(6916009)(7416002)(83380400001)(86362001)(31696002)(4326008)(5660300002)(41300700001)(36756003)(2906002)(44832011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZCtXZnc0T29veTNib0lxbXExQkFZRzN1eExKczEwdGdyeEN6a09XWllXbTI1?=
 =?utf-8?B?RUpqWk55bXVMejFaejg4KytSWk5EeHBUTklWZWZnQzhyeVFiUmFRc3NEcXhM?=
 =?utf-8?B?RUtvV0NYQko0b2I3T3hlTkdMS2dSMGZKcnRjZ210UWxFckNFRmlwTmFuVGt2?=
 =?utf-8?B?emJlbWdFQXovQ2oySWVMNmo2S2ErZnA5ZGhUN2RsYlZxejh4MnpxSXo0V0Mx?=
 =?utf-8?B?OE8yYUQ5SjVIaXZRUndWUEFuKzg5OVBVUGRkb1FNTWVrekJFdm41M042bm43?=
 =?utf-8?B?MHd1ODlnY2lsWjR6eEdxR1lCelhKZXQ4c3NEL3pncFpEWTYvWjU5UGdKUjEx?=
 =?utf-8?B?NmNvemxlZzJjUC9LNnB0d0xSTVdvQzlHWE42NUpSbzFBWmZOalNmcHpTY0Zh?=
 =?utf-8?B?eEdDZUxQMk1PUDU4MkI1ZExrRlFhUyttS0tsZ1VlUysvNFptNzJ5anRaWksz?=
 =?utf-8?B?dHgrTDJNbXUzWU4wU3NIVlB6M0U2ZXl5ZTdDcEJoUlE1cXlmQmVxSG5xTWtz?=
 =?utf-8?B?Um44TUNabTlzN0c3bzl2WmJjR2FuSSs5VGVPZDlFNVZkN092WUVqUEpkcnRl?=
 =?utf-8?B?eG5mTklEZG5ZKzlOOWdZQXFwbnE4TXQwV2NvbFVsdUhkZ1pTUmsrVWFHcDNE?=
 =?utf-8?B?aDZpZHZzcmZqZFFCUDU5anZCdVFtMEFBaDJxUmFSNmsyN1hzMHB5Yi9hRUdy?=
 =?utf-8?B?SzNmQTA5TUJLdE04RDFpem1aYjB1dDcySWdMa09Jc2VBRTVISXJsUGlvS1Ry?=
 =?utf-8?B?SzJxWTkvc1dJU2NEckFzNUpzMjR4Wk5sSG0zN1VWc3JXZjJ6VlM0Qmp4TXp2?=
 =?utf-8?B?SU5qbzV0SUZoUlZNY2oyeUl2bmg3VnQ4WDZzMUhybVl3czNHRC9nN3Z3SHRq?=
 =?utf-8?B?bWYwdmkxTVVwbUhLZTNkaXNYd2N6bVFBVFJROHlMRG03eCtVNWpFNU9FelhU?=
 =?utf-8?B?LzV0VVQxQnpDQ3ZRaGxOL1ZEMFYwVW9yRjZVaUZvNFJvblMvNElJcldKU3gy?=
 =?utf-8?B?VHR4OUMrRk5nSEQ4Y1gvN0duQlZPZUUra0RMTGNXL0pSZ2ZTYXV5ZHJiL3BE?=
 =?utf-8?B?Q1FURy83KzhPc1FySE8ydmJVNDBCVExsYlp6em13NEZNak96UmpJdkxjdGd1?=
 =?utf-8?B?d1AxS2ZkQ0RXRWFtYW1ON2JBdThERlBqNjF0RmlGTXkzdUcvL1ZuelZOZjdw?=
 =?utf-8?B?MWZQWmlxMXJPV3g1YW0rSGo0NGVLZmRIREszb0ZDMExidXo5SWt3N3AyWkhj?=
 =?utf-8?B?ZzVTaVlPS0o4SmZac0VaalljeHhjSVMvNkpxWjZqbE51SVlqbE9iMmEwMm9Q?=
 =?utf-8?B?ZlZOVU9ST3FLVnZ4TDEyalNqUitqbUZ0cGVyUkNyMGtDdzFNczViWkR3N2k1?=
 =?utf-8?B?c3lYZVRUUlJBTVlyZjZSQi93ckN0TTFCK1lOczM1NVpSTTNpeDl2bU5rN0lY?=
 =?utf-8?B?ZXNNdUQyOThxbE1HbWtvc3dMU3ljK2NlVzRkMFdabG02QXlGRjB3ZmhtK09j?=
 =?utf-8?B?WlloNzlPM3RUa1M5Q3JDUVV1V2dUQmhPbVByZDN4K010NWxmR0dqb29UOXRq?=
 =?utf-8?B?ZlJtZUhIS3RGNjlhSFd4RnFLZ1hONGtHa2d1Q1NvZlFGNklkdnRpeElITWVz?=
 =?utf-8?B?dFlUVlhNV29nTU1OYkJPR01Na1YwaDR6NFhlS0ZuZG1HVUMycDZqNTZYR1ZJ?=
 =?utf-8?B?eWNjYlRSSG5sdkZ3c0NLblZKaVh2YUtxSExaR3k5bVJUbUdJQ0JrQjN1d2Ja?=
 =?utf-8?B?M1FzNDhEVkpaNVJ5TXlaRGRtbHBCSGJrMldqU2M3eXp0Y2YrL0dDUTJob24v?=
 =?utf-8?B?TGRZa1Z5M2ZCZnVMNHFnaThnOUliVTA2cU5kK2JCVDNVYUVhOWpsSlNOTlIz?=
 =?utf-8?B?TlE3QjZYKzdaQU1NQi9ScXVnbnFnSC9ZS2h0U3RGbUJucGxIUXRCeEEwcXFa?=
 =?utf-8?B?alpPc2Rzc3BUbDByR05SeHQrMU50SzVFQndhNE1RSXZ3YTNGeFYxZitqMm5T?=
 =?utf-8?B?RGREdDRvcmhPRGVZbHBnZHRCTUlwUDlTRUhYMjRHem1qaVc1dVpUTEhoQnQy?=
 =?utf-8?B?YXRsOXRBaTFEQ1AyOTJkaitybUY2VDdNR0RmeVFoZ2tKSXpDQWV1M1F3YzVj?=
 =?utf-8?B?WGEzcjZuSGZWYnpqdW0yYjRoWDU4VmxLbm1admJOcWpyR2Zvbk9LSHFkTG1Y?=
 =?utf-8?B?ZFE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53aa348a-3a0f-4b3e-39f4-08dbd3d7a57b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 14:52:15.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJK2gSKTizDsxd9w/84Wb/cKLCJ1rHmrcsoe5Aj7ySlHmyMl61P3vb0r/bEP3MXSYA3v8pwd4SimQIutNh2undbj1mSqFBJsDXdq6F4k898=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR02MB7855
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/2023 5:29 PM, Stefano Garzarella wrote:
> On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>> Once VQs are filled with empty buffers and we kick the host,
>> it can send connection requests.  If 'the_virtio_vsock' is not
>> initialized before, replies are silently dropped and do not reach the host.
>>
>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>> ---
>> v2:
>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>  the_virtio_vsock initialization after vqs_init
>>
>> net/vmw_vsock/virtio_transport.c | 9 +++++++--
>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index e95df847176b..92738d1697c1 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>     vsock->tx_run = true;
>>     mutex_unlock(&vsock->tx_lock);
>>
>> +    return 0;
>> +}
>> +
>> +static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
> 
> What about renaming this function in virtio_vsock_vqs_start() and move also the setting of `tx_run` here?

It works but in this case we also need to move rcu_assign_pointer in virtio_vsock_vqs_start(), 
the assignment needs to be right after setting tx_run to true and before filling the VQs.

> 
> Thanks,
> Stefano
> 
>> +{
>>     mutex_lock(&vsock->rx_lock);
>>     virtio_vsock_rx_fill(vsock);
>>     vsock->rx_run = true;
>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>     virtio_vsock_event_fill(vsock);
>>     vsock->event_run = true;
>>     mutex_unlock(&vsock->event_lock);
>> -
>> -    return 0;
>> }
>>
>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>> @@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>         goto out;
>>
>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>> +    virtio_vsock_vqs_fill(vsock);
>>
>>     mutex_unlock(&the_virtio_vsock_mutex);
>>
>> @@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>         goto out;
>>
>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>> +    virtio_vsock_vqs_fill(vsock);
>>
>> out:
>>     mutex_unlock(&the_virtio_vsock_mutex);
>> -- 
>> 2.34.1
>>
> 
