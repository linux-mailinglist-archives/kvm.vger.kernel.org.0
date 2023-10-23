Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A347D3AEC
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjJWPgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjJWPgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:36:40 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2099.outbound.protection.outlook.com [40.107.14.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A519D6E;
        Mon, 23 Oct 2023 08:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=creml0JKlWuyCaTGUZqJfhVIsZIJby80keC9VknvmJHT+BRUJNUduYVP3I9BEP7wdXjIs90mDvGm5njPtsSyWryDu9hos1ElqOJ75UlOL3PfuZDNtEOwlD4Gw5mzwyVe/aeaUx4+yP71q4vBPiyXwRHx97GGrWw/Qz3tbnBYdhJ6ROA9pmV5/keL1phCRgiAQOgrnMYmgveHx4Y/yB3R/H38Tm5KfwT2+ye09cnFEkXOoXbebPdMGoBiZl+EeugD4DRySoZg+4I9mOIgi7p6JKOTfTQOglbBJC9hSys4QdxKMZa7uboF71FcwKk5oOP/IwyZwEcuTQtZKInMAHQ6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7Ux63l5Snv78cY/SS8EUlU0b7gStGDqIbcA/gNx1XM=;
 b=OrmRIImtHtjU3eSvvGq8CRL/BAJkGhz6WRUxkfH3K5nE3H7txvfkTWTF4nHdE0EyIsfgDWWD133gQ7C8w9omvJ/zRTvHGdMxYt/YqDNWnjVNBB5TSYeFHwk/Y0SVr5h0H38tAnuibKnO4ZFpoD38GnggIes+lSnkuWacLGL1oWP0uUdXIRtw2Hl9a2o5ViYJNUkOsrKUVQlAWZ6+kkLsnoY9hPrio7r4H4dZopXxle1XOYnuGKb3owZiiwm7E+ISObPCsiSgWI3EkNCT2dutmAPO5mez0ZTT7szq+QsXHA15J1mdDMXWH5fXk9PN0EMiSBd6zlT55kmt+Dklt9/n6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7Ux63l5Snv78cY/SS8EUlU0b7gStGDqIbcA/gNx1XM=;
 b=DTark9haZxL3rYYkKbZJGsZVIsSWqReD9Q4xn0I3avnguan5L2F4xrbzrx80OzgFoQ3J0kegVAH6euPWIFOPpaVCeNLoGpxdPiYEhQ9/GOBlLjayo6j8DxKLX8Gjl+h8qBpiar+ec2zeQLa9s39S4FI0XXQe1yeKNnQJJTrVX9QN2jD+YHN6x/yBlcssWUKuDIyQQcMEId+guXWNHqAIKCXXxfABXvnd0OC5fLDJih+8qzNzV92gLuaTDYMxDE78c0d8a71mC6A8U0bmipAfurMVRBxNpC+ADQugyO2fVPJZARC1PCd+xjwMEnN6lH7OiTNFmt8qMzJ15BomQZZP3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PR3PR02MB6427.eurprd02.prod.outlook.com (2603:10a6:102:77::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 15:36:33 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 15:36:33 +0000
Message-ID: <01ad7d00-9a53-445b-8916-3342047112a0@uipath.com>
Date:   Mon, 23 Oct 2023 18:36:21 +0300
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
 <0624137c-85cf-4086-8256-af2b8405f434@uipath.com>
 <632465d0-e04c-4e10-abb9-a740d6e3dc30@uipath.com>
 <dynlbzmgtr35byn5etbar33ufhweii6gk2pct5wpqxpqubchce@cltop4aar7r6>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <dynlbzmgtr35byn5etbar33ufhweii6gk2pct5wpqxpqubchce@cltop4aar7r6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0202CA0001.eurprd02.prod.outlook.com
 (2603:10a6:803:14::14) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PR3PR02MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf37684-1fa0-498a-a07e-08dbd3ddd607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ni9SySYE9ZOCiX79L5PPXtYn0DNOial75rQw7Sh3qpWKH4MwM4JwXjVn/fFfFqtzej/DHaRPUjE1q065WwMADYsnsI6uHCi5cY9Ryt6MtpJaqdHzTtdA7XlC9mc26hADyV4F6GPwQ/H7CbDmTNgqd9/qop1vZvccSBqbD0jc/59TxZTzHu6ksRe6kRCqFAXfuXPPw8yVYpX4D64R/KlE/jhLymss5yA+j4AfWE13plzx8lKsecu+35vjUgXVOO3ZIuApRDiPLifvR3GXJylY2b2DwXeY90fqwY6nfirOGtN28vz+HSEP4QD+xKC2OM3YP00WFqNo8tp/zujkSmPzTLmz4MbAh/BkMbcls8UnzaFo9KiJRcSX8R6vdMlKYrCczvuUBPnMkZjIUglEDbM7/K80Bw0YGwVJQwQSDspvYak+la+4kjELfiJNv5pPZ3hglpEM4HYxQfvEkmi1AoFQabsrrEQVTzRvQyJ0TuIH1jr9cymUhobvgGtS6gsAWHmp170JKFXktKCR2+EL0Y59eEc2abn0oeFfYa25Pdpogb3juWvFC2g/xI5uZ6fRmOOdj4wypn7zryRK1DB/DYE1blaQOKTB8OVbF8Q0byS1lkZoEgmkifO+X5rwIouEFFTMYOffe6OYV5jfAmYOJYAJWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(376002)(396003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(31686004)(107886003)(38100700002)(2906002)(41300700001)(44832011)(86362001)(5660300002)(36756003)(7416002)(31696002)(4326008)(8676002)(8936002)(6916009)(2616005)(6666004)(478600001)(6506007)(316002)(66476007)(54906003)(66556008)(66946007)(6512007)(83380400001)(6486002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3JIemt0KzdUUVVkK29rWGpKV1BMT1BROHJhcWNsMDRVUHVrQ1AycDI0aGNi?=
 =?utf-8?B?YlNtbmI3eEFJMEpTNjRVM2lxc05rS1BmWXN6SG5sMXJpNDNLVTVJNXhKY1ZH?=
 =?utf-8?B?MCt5dHJlTDh5N0E5QXJjMFpUeFhQMWFad0tFV1Z1Z2psYXBkV21kVlR6eHlK?=
 =?utf-8?B?MTNwNEt1Q044RXAraEZBUDM1c0hEaGZ1cy92UlhBVENFNld1bHFRUGNqRXRo?=
 =?utf-8?B?aXkxNFFrUU5yb080RFVVRTNLZWl0cmVXMk5DaWVpbVhCcERKM3k4Sjk1N2Jr?=
 =?utf-8?B?cGdrY0tJYjgyekNqOGNucmtrcEhjYTBMeGNRL2JZM0NTSEJXQzN2cnNMYUdJ?=
 =?utf-8?B?dFpyNkZsRnpPK1VTVTFyRDVNQ1ZpaWZlK3lMQlJmR3FERGZPTDlDdFJDcnJN?=
 =?utf-8?B?ZHVPR3ExRWxFYVFxOENjM0p0bHptRE52WHZ6bGgycjlnWno1QUd0R3VKZXB6?=
 =?utf-8?B?N2MyWXFHK1h3YytpVk5Zd1NxVmNlam5IdnJyZUhyaGw2Wkc2L0pET0U5V3Ji?=
 =?utf-8?B?K1I1V25FTjNPVGJzWU5udWdQMFYwWmZIUUxrS3psS1JiNW5nb1QwbXpXdHE5?=
 =?utf-8?B?bWFaWUdzVzhNMWRpeit5N3hyWlhvT3B5RXBDZy9GTTlsQnV0NkVRY3NzUXNK?=
 =?utf-8?B?R3B0WGVsL3NjOE0xektXc05qeUhMeGNqR1dBUTIrYk1Cdy9vTjFsd2ZvU3dF?=
 =?utf-8?B?TldrSGtqUXZpVkdLY3cxWXE3eFVkZXl1aHVOb3FxRU9JREdkamliL0ZqNEgz?=
 =?utf-8?B?NWh2QkRPeTJ6Q3JDa0pDbWREaWg3Wk9uVkhCMENlQTNSN3Z5QnNMNFNhMGt3?=
 =?utf-8?B?RGVGekM4LzQ2UHlnbnpJNzg3SlNnWGxtT3BabDZ4Sk9iei95ZnAyTm9aSC80?=
 =?utf-8?B?WDErUmgxSzdNbzRadWlDaHQ1ampWNHZ0MlV4ZjZRdE1NM0FrUnA1SEJsREg3?=
 =?utf-8?B?MVJOZlB5RlgwUDIvVzFGaWlZSHhEakhKUE1KelY4MVRMK0RQUzRZb3JjTGZB?=
 =?utf-8?B?dEV4Wmx1dkFzR1QvTXRMRHNPQjFvc0QycUhLNzF0VmR0Qk5hRTVuTjhVa3R2?=
 =?utf-8?B?OXVDVDdndTZFdzZlckhhdXBXNlczemF1amlPNjhHRlVzcVZCcWU4dTZweXNm?=
 =?utf-8?B?TGNtbHZXalIzWFpxVGxLWkEwZk1Fak41Wng4S2RwN2RlYnE3aVZVTVA0KzVE?=
 =?utf-8?B?NmJoMTFQeFpibkZiVzdkb0dxbVN2aEVGaUNzRkU2NGVac0g0Tmo5WVZzTlVQ?=
 =?utf-8?B?Y0VuSlNaMDNEaGlNRVA0OEVWaWlmbENUalF2cVhSK2FEL2hXRTRTbkF3eFkw?=
 =?utf-8?B?U0l6elFSS3lXd0hvamJhMk5iKzdUNEFGOEgrTnNCUnVWVVhEZGM2Z3hNWUY1?=
 =?utf-8?B?UDAwdVZZbXJpY2RvSnpPMU1ycjY5UThTZTNzRmtPYWpVWFhoTW1XU3FjT2xS?=
 =?utf-8?B?V1BWODc5My85YXJ4aDYwdWFuTG15d1pJd3V2THhhQ2ljQU5mNUQyc3AzR2or?=
 =?utf-8?B?SWxxaTNaSW5CdzJESERnZG5TcFl3Q1luZ2NsTTU1SlVtdHgyNFc0dEhWWVNt?=
 =?utf-8?B?ZGtobXdhdFZsbUE1RDBLd1lFeFdOVUJpZ3hUWkc0MklVU2l4UXNoODJEdWtH?=
 =?utf-8?B?d3plRkVZcTZSaDdlSlFBRzJjYWJCZHAzanE0YmprL21vZkplejhjNnZNUmFR?=
 =?utf-8?B?bFlITnJrcEpNbVFjT1I0Uk5SNXZEQzFGckRxWGZUSHR1UUxzUmxCaUhMNUY5?=
 =?utf-8?B?NU9FSmd0dXB6MEUyWUJPNHpnR3pELzNNN1ZmblFJUUkxbk90TUh6K1laTWZM?=
 =?utf-8?B?dUhpY1ovelJhdG1hUlNuVVlKZWRFRVFrNkNGdko5MmM1Z0xvZndBT3FCdDhT?=
 =?utf-8?B?QUFpdHRmQ0hGZUc5b1lkN2p4czdDTXJqa1RVQlVJWW02LzIyNjIybDI1K3lZ?=
 =?utf-8?B?cnhBdUVCS1hUclRxV2hwbGxGSjUyVEloc3pTN3VqZUxCbkl1bVFoeEEzQkpi?=
 =?utf-8?B?VUtFZU43ODlmcWdYVnJ3aFY2TWg0MWFmajVRSFlkWE9URUpGZ3RnTWNSRGt3?=
 =?utf-8?B?ZWl3ZTRMTFkzSmRTaUFRVmtPTHRzcXV3ODFsdWxoODcweVRpQVgreUc1V2xO?=
 =?utf-8?B?dnhzbktNcWNkNmhHWk05N1ZUbk9pMEZhYiszUjlaVnJ1cUJaRXlkMkxGZVFX?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf37684-1fa0-498a-a07e-08dbd3ddd607
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 15:36:33.6746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnQFj2ZzGE4+EAvHRlAsX6DVrVqL80MCizZAvlPR2+GnJS2fPJkYEWqiwVlt41dVgNEwk/uVS1Hsr4WyPpYUmgmwQuqUyodyWOS5ghHsuQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6427
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/2023 6:13 PM, Stefano Garzarella wrote:
> On Mon, Oct 23, 2023 at 05:59:45PM +0300, Alexandru Matei wrote:
>> On 10/23/2023 5:52 PM, Alexandru Matei wrote:
>>> On 10/23/2023 5:29 PM, Stefano Garzarella wrote:
>>>> On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>>>>> Once VQs are filled with empty buffers and we kick the host,
>>>>> it can send connection requests.  If 'the_virtio_vsock' is not
>>>>> initialized before, replies are silently dropped and do not reach the host.
>>>>>
>>>>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>>>>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>>>>> ---
>>>>> v2:
>>>>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>>>>  the_virtio_vsock initialization after vqs_init
>>>>>
>>>>> net/vmw_vsock/virtio_transport.c | 9 +++++++--
>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>>> index e95df847176b..92738d1697c1 100644
>>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>>> @@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>>     vsock->tx_run = true;
>>>>>     mutex_unlock(&vsock->tx_lock);
>>>>>
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
>>>>
>>>> What about renaming this function in virtio_vsock_vqs_start() and move also the setting of `tx_run` here?
>>>
>>> It works but in this case we also need to move rcu_assign_pointer in virtio_vsock_vqs_start(),
>>> the assignment needs to be right after setting tx_run to true and before filling the VQs.
> 
> Why?
> 
> If `rx_run` is false, we shouldn't need to send replies to the host IIUC.
> 
> If we need this instead, please add a comment in the code, but also in the commit, because it's not clear why.
> 

We need rcu_assign_pointer after setting tx_run to true for connections that are initiated from the guest -> host. 
virtio_transport_connect() calls virtio_transport_send_pkt(). Once 'the_virtio_vsock' is initialized, virtio_transport_send_pkt() will queue the packet,
but virtio_transport_send_pkt_work() will exit if tx_run is false. 

>>>
>>
>> And if we move rcu_assign_pointer then there is no need to split the function in two,
>> We can move rcu_assign_pointer() directly inside virtio_vsock_vqs_init() after setting tx_run.
> 
> Yep, this could be another option, but we need to change the name of that function in this case.
> 

OK, how does virtio_vsock_vqs_setup() sound?

> Stefano
> 
>>
>>>>
>>>> Thanks,
>>>> Stefano
>>>>
>>>>> +{
>>>>>     mutex_lock(&vsock->rx_lock);
>>>>>     virtio_vsock_rx_fill(vsock);
>>>>>     vsock->rx_run = true;
>>>>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>>     virtio_vsock_event_fill(vsock);
>>>>>     vsock->event_run = true;
>>>>>     mutex_unlock(&vsock->event_lock);
>>>>> -
>>>>> -    return 0;
>>>>> }
>>>>>
>>>>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>>>> @@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>>>         goto out;
>>>>>
>>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>>
>>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>>>
>>>>> @@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>>>>         goto out;
>>>>>
>>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>>
>>>>> out:
>>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>>> -- 
>>>>> 2.34.1
>>>>>
>>>>
>>
> 
