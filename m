Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC387D3A34
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjJWO76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjJWO74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:59:56 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2135.outbound.protection.outlook.com [40.107.8.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10D10D;
        Mon, 23 Oct 2023 07:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLdpVtoLRIk9VdqhhKvPp/AQw+SZmhwJ/n55RsygWuK72pukHduX7Us4+nTLgcXv4Ogk51PPQB0CKz8cfjHVxYItyucNRF/RD+/qfSkbVzTsNNAoM3px3ZqyjmX4B8ONugNNUwRSuF7Cj7ILmKYxE1z5/u7ERXQXuo/VdTG+fqnhPSMjmNUAtyYsBxEZby5InaAAdnb3MLbyUHABbvOE0WpJvtd/Q821PI2jotL92I55NSnqi5ZNaU1aXvsTX9FAcuuFwiwBNvAezY3ow9CyboQcuweIn3WQ1COMZrlPfQO2Me3CWVjKtPxsG60sC5UJomfKWBFF5hAxbbeGxQppow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuQecTHEBBvtVqvgDBHCV+o41i0fKM0Ml5ZLeeE/PM4=;
 b=P4bBgDZAFazoudz/VDLF3+L9LacaMMJM1iWHP4/pSVLMDoNq3SshOFduBTqMUqbQ41JtK5/XLzWnHIRoQ+LnpghwcO5J7oyxTLdQ5r/1lUz8IZ316H1enDTBEudH8SdnEHtNaR2AL2MeUwuK+xKKAmgquBLaUSDaw9UwAWaLPNplXT5Byup6zFM0Le2WCvXcW3ykBJXdkFrYRw2kcomBTUYl/U+1oivkhrZYg79bWjXdK3YDhuSqUKGe1QIXb7fQx7eCVWJZrAyIsBM3nl6TBlvcLz1KdrGDJdJHHUL+GjBS525CaEdgIv/P8Z47uvwXLRMe7JKrA1daFKc1D7M99A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuQecTHEBBvtVqvgDBHCV+o41i0fKM0Ml5ZLeeE/PM4=;
 b=l69AGcsvq4Rb7rUzCZvMGU7tfLxHXBclE0waIcc0y5FeY5+ZiBxTkrWUK+sGBLuem75g9lEkOOMJvm4JZdstTvJKsMI7jOYsTZrAzjGr9hiLQ2mx1+ud/Ey7YBlob2TBVg1aygQMxVv26WnWZtccA9Lg8FwYU5q6PFNlIPPX3GsfvqfIK1IqxZRux2MGB34TdJKJ7CDlioxqhso42M0+SA/sx4Tn1gUHRTu++fBV1W4Xfa6daJrzU8nwejljSHiTZsBZOj9jUxm5oPddDJMDefcmF0LiME0b8BUFZpZ/y/lJsvbrk4wI8ebXsKDMJMC3pH2OjbL1G1Ka7D9jq+VqmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS2PR02MB9606.eurprd02.prod.outlook.com (2603:10a6:20b:596::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 14:59:48 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 14:59:48 +0000
Message-ID: <632465d0-e04c-4e10-abb9-a740d6e3dc30@uipath.com>
Date:   Mon, 23 Oct 2023 17:59:45 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vsock/virtio: initialize the_virtio_vsock before using
 VQs
Content-Language: en-US
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
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <0624137c-85cf-4086-8256-af2b8405f434@uipath.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0235.eurprd07.prod.outlook.com
 (2603:10a6:802:58::38) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS2PR02MB9606:EE_
X-MS-Office365-Filtering-Correlation-Id: a81bcb6f-d26b-4c17-4314-08dbd3d8b387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NoSla6JdMBN+y9vhF6BSVwVaFbkqOSH3UM2dQ6BO+SxK425gG2tRYzfi6MnH4jzmdxw2wiTCwoJ+U4BuzjEoxd30tz4sSA6TH2zOUG4rhxTKcsTwxHV5vYLCrn2POiSC2uwHlDeTL0RZfyv5YoQYk9MNTHKv889V6q6kr3yHgYxD+iuAHb0aq/QYUR04vP/oDpRebLtJpjVMlP2xVEEw38eiLHzes5VLwH+pJbnb6P0aksY1evWG5jexDFoIHZBaHTMoqJv+VIEhU/HImNTa/Sd5Gi7/08//3AARf4a2aWMNrVZ42whsj4Gxk9p/pJ42tMo9R63qJE7iLc+JKiDxr+UXFpE4Y2mMgffaeGZ9+iCpHl4pvzpLnWkfN7xueo7MKTtb+ejHIWyzv/F0P09b8vQPhv1ClzBmr69BHUFYfJurpoGhadoTanSO66Z6vYlYuSb9Dn0Ly7qg9VsMbm4SNXrDD7qkh2GDbaP31lCgU88m+Sp/RtP9XEjFbQ4+M2+4ZKuAdT+zv6pOFX9C6qC8rxkQtJkiv+fDCAE9GjWCNbzOgEB8xtMJxtmDnL2KgsemWI1JpXhLh6qWE8BZk0/4gd1x8htG8O2DKG6t4xPnCzg6A2tH/IzENbI3IMSTPiXZmQ5QqRaGQgtIL33p1x8+mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(376002)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(31686004)(7416002)(2906002)(8936002)(4326008)(36756003)(44832011)(8676002)(53546011)(107886003)(26005)(2616005)(38100700002)(6506007)(6666004)(6916009)(316002)(31696002)(478600001)(6486002)(6512007)(5660300002)(86362001)(41300700001)(66476007)(54906003)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTVxQlVYRkJSRXBuV09yVExJa0h2MVpBcGI5MnAwNEZtdkV4OEt6dzZBT00v?=
 =?utf-8?B?NG1weStBYVcwUkNjK0dPVEZUcStYUXJDZjUraTlobFZwR1FoaTFlTzVsYnk5?=
 =?utf-8?B?NUhPVzhFcTk0WGhMcE1Ra0FRMkZyQzdjcXB5VUl4UkZXZkpMcm5ob0o4UnlU?=
 =?utf-8?B?dHZYU1Z5R1VTbEJrSlNoM1Q5eXJCcGgzSDQ0Ri9Kc0FhcCt2allna3R4MDd1?=
 =?utf-8?B?VGd4ajRsTkNaK2VHbUZFV0FVa2lhVlVoY3NyZk5aVnNyMkE0VjZ6dkxrV2l5?=
 =?utf-8?B?UnNlekNxT1hSQkw4dEZnaGowa1NhV2RwM25UK282UmozUk5TZk5VOFFra3FV?=
 =?utf-8?B?SVJHOU5CcTlyTURZZ1RRd2svQk1vM3FJdnVyRGVCMWlVVTFhUFVqdlR3eURX?=
 =?utf-8?B?R0NTdkxmd0JYM1RBZStUclRnOVJpWW5HWWlzcXJtampoN0hKdE91SGoyZkx3?=
 =?utf-8?B?cGZNVS9tdmFIRVJscHBFSy81N0pUNjg1V0Z1N0RJNGtwYXV1YUQzOFFnSHlH?=
 =?utf-8?B?czhqT1RWVGhLYjduaWNFWlhoWGtCaEh6ZmUxM2JyZGtFSG1nQTZ2UFhMVjRF?=
 =?utf-8?B?bmY1dk81VDhXckFadHp0OGRhaHBTSmtHK212and2K2hYUHpiakJaWUlpT3Ax?=
 =?utf-8?B?dHpvQWVtbUhHVzZnSU9rZlNYdjRLejljdmNSdldhUnlzUmVkRnluV3FKQzVY?=
 =?utf-8?B?Y2Q3MkdKc2dqMG1RUkx6U2ZKYmdNcVJTYmU5cUtndi9EcUNPcTEwYnpneFBt?=
 =?utf-8?B?aHJtQjRxeXlRM1dxQkZlc2k0V2NId1lSTmZjM29aRVVWb0c1aTkycExKdTZs?=
 =?utf-8?B?cG1kbXdmRFhqTVpOSzFPS2lON1VwUTRvVWVUTjIyVHNqaHJabmMvSnpDTmk5?=
 =?utf-8?B?TXdhZWNhVXhYVFljcUZ0UXAxb1puMGpCcHIyMW1SdkQyMmw3Q1U2LzE4cWFM?=
 =?utf-8?B?ZStpOGFia25nR2I3NUdJMDdmS3VLb2tGS2lteU5GVFpZNGRLemZiYzdZNUo4?=
 =?utf-8?B?ZnUvR25qWmgvdzlrZzlYeUxhS1NRUTNJR0lFazZFcWZ3ZEREYWhDRklmOWlY?=
 =?utf-8?B?QTVtbTBFaU45MkFndHhSKzI2ajErYWZIRFVKZStwdld4MEdrQjA5V3VaN25B?=
 =?utf-8?B?M3k3WCtJNmNkaE1qcldnU1Rra2RvcjF6anB0TmpPRHFCUWlBYmlkK3J0YUhu?=
 =?utf-8?B?U29rRHYwdEQ2enhFL2trZ1JKbGxWV1BRc0hUZzVkaEhmckFFUW43RDllVjZ0?=
 =?utf-8?B?ZFBuSktyekxyK3I5enlBSEtZVC9oMy92aFA2SExzZjRXVlN6aTVQMnV6OTJH?=
 =?utf-8?B?Q1BIeHFCRHhpYkZNZ3JqUW9JT3RVVlF2TVBMek9Sb1hkd0IxYVJTc25NMjNv?=
 =?utf-8?B?aW5iSDZyd1AyRmo5azZKejJ2bHZobWpzRUZMWFp6V2tOQkNQZjJZVzM5Q2U3?=
 =?utf-8?B?K1ZsZHUrQkRqMjloY2FncU8xL3UwM0Rrcm9rMS9MQ0w5Z0QzaGwwbXcxU0th?=
 =?utf-8?B?ZlZWdTNJSko1ZzF5bjVTMCtScURTa0puQ0hYR3JUZDJ1ZCtCVUo0R1VhS0ZB?=
 =?utf-8?B?dEhiMDBsRXE5TWVnQ3lXUkZKRjdlenhjRWlvZ3hTc0RYUWwvZ2VDeHJKTU1M?=
 =?utf-8?B?QXF5dyswSmpyWDZzeHR3cU82SWlvd1VkS1VoeEhXT2pjQ290KzRyZVJaUWM0?=
 =?utf-8?B?R3d6bHZiUWI4Wmo5YVltTXczZzROYVdVSWdPbVN4dGYyZUNHblV2R2E4SnNI?=
 =?utf-8?B?Y3RHVHBuQTNrdCtjcUhvUU95NWZBTkJudUl5eUUySmpwNHFzdkZBd2cvaWJI?=
 =?utf-8?B?WHhRTE5UQXplRDQ2OGdJajUzaFNEVks2UzRScVNuR25wa1JWVkRtQkJtbHVI?=
 =?utf-8?B?QVMwcytCOWR3bzk2amFXd0dVMnZnTlR5MXhlYitra1J5ZThhU1NFUCt0MFlL?=
 =?utf-8?B?RnE1OFBFejgwQlQxYUZkSjl4ZElKY0ZzcHFDRDVQV2hyckFQTnBRdkg5Wk5W?=
 =?utf-8?B?QVVpQjY1T3ZpS3VyRUhHbzVocmp5ak5lNXdkSTBZRDJqTm9DM2JKamgzYWpn?=
 =?utf-8?B?Q3FpUFh5V091ZWdHY1p1cmdVTWcra2dQZlZHQmVhdFFLSFRwQUwrN250NFlS?=
 =?utf-8?B?YldhTHlzUGE1MTc5YkVUREFNMHo5Z0NTYzhYYnA3SkJhbVJEdExHS2pYNEhv?=
 =?utf-8?B?dlE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81bcb6f-d26b-4c17-4314-08dbd3d8b387
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 14:59:48.4235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbFMuoGpGbhbtXZwEBxctlOcVYcWarTk5r/kzwQMtMwHaZzgdhE5R73nLRCrIVOXUNwrwDDIEYdgx2sTYA2ozvaviMiCTIJ1oooZzUW3+WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR02MB9606
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/2023 5:52 PM, Alexandru Matei wrote:
> On 10/23/2023 5:29 PM, Stefano Garzarella wrote:
>> On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>>> Once VQs are filled with empty buffers and we kick the host,
>>> it can send connection requests.  If 'the_virtio_vsock' is not
>>> initialized before, replies are silently dropped and do not reach the host.
>>>
>>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>>> ---
>>> v2:
>>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>>  the_virtio_vsock initialization after vqs_init
>>>
>>> net/vmw_vsock/virtio_transport.c | 9 +++++++--
>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index e95df847176b..92738d1697c1 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>     vsock->tx_run = true;
>>>     mutex_unlock(&vsock->tx_lock);
>>>
>>> +    return 0;
>>> +}
>>> +
>>> +static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
>>
>> What about renaming this function in virtio_vsock_vqs_start() and move also the setting of `tx_run` here?
> 
> It works but in this case we also need to move rcu_assign_pointer in virtio_vsock_vqs_start(), 
> the assignment needs to be right after setting tx_run to true and before filling the VQs.
> 

And if we move rcu_assign_pointer then there is no need to split the function in two,
We can move rcu_assign_pointer() directly inside virtio_vsock_vqs_init() after setting tx_run.

>>
>> Thanks,
>> Stefano
>>
>>> +{
>>>     mutex_lock(&vsock->rx_lock);
>>>     virtio_vsock_rx_fill(vsock);
>>>     vsock->rx_run = true;
>>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>     virtio_vsock_event_fill(vsock);
>>>     vsock->event_run = true;
>>>     mutex_unlock(&vsock->event_lock);
>>> -
>>> -    return 0;
>>> }
>>>
>>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>> @@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>         goto out;
>>>
>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>> +    virtio_vsock_vqs_fill(vsock);
>>>
>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>
>>> @@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>>         goto out;
>>>
>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>> +    virtio_vsock_vqs_fill(vsock);
>>>
>>> out:
>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>> -- 
>>> 2.34.1
>>>
>>
