Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF07D5A65
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbjJXS1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343859AbjJXS1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:27:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2118.outbound.protection.outlook.com [40.107.6.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFD9123;
        Tue, 24 Oct 2023 11:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMuVryeTXL7EWpgtmwmFxMzz+vWYWmxy4c3yN7E1Q9uMxqhN0lEvJWw58g67oRv5+JaeeolN3KV0e/gEGoFiqoLoj7U128Opz5DtYi/A2nPAOMaNUGDxU9RyGaSZwe1S1EEPqiQm6+OYIc6Kv9XH/vTahi2M+P1/8kdLOmfMwjtqwkAcG6iwk7/K8cLRVq9qq1knrMLRSX2kbDBmqpdaH8Z2c0/l9Ge2mzh6qz2V+evvvtV3iVKdfjkKELkraDPrqIJhBhrctgrSaXcF5BxW1v4YiApSxJx5v04uHoY30JviGyN2FFOsO6sw0hsz6sGArkP0xjPxlzwlcnoRq9g8fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGuELi3XUY50mzSuATuWLj85HnwWO3fV7VGuJbAm+IU=;
 b=IrFEn6uwU60pMtpa/izvWbT/SEYCUr1fY3L/aGtAAH2vDx9J1Vp7KpWnhwdRR9bX/ld7BScMCwHAn82uLeLoRIhCrNdJGu9hIWb5GM1lS+yuLRKOarxUn8OcZQT0gxm48qmBA9mfFFyTmjBoTnGVOsmYawO6ByPTkoksL+oyYmURXsSYJkIusLFzybrgubZVkREUuN40D+mOX71LWi86euoWIkUhKDXrKhySjriNHar21fqdjoN96MF5W5ZbtOQdunrcUQTDchPHeF9Hbhbbh2FCRiFHsYxWuy2RzwFKjNqV2qVjs6tCFW9fN4Q/001vHB9XgLHdEb8PLl1v+ccxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGuELi3XUY50mzSuATuWLj85HnwWO3fV7VGuJbAm+IU=;
 b=U5IHB+RjZO7PL4otOE5Km/Gwruj+7lg7lGB2rExRoJMXD7efHaC/mBCsl46rmkaCq10/Uoa3BIkZ3dkSTCAs4HgBOyOTJmp2PabHE7ZSUEhTDgFefgEUpXYgqKTq37y8eUhUy69NJVRi/lMQjinjDbrZi2ykZ3dXhoG81QTE1HoCvh590Ehw0NgRX391BSLRNbVW5vV1wOYVeNTodnl3CnrP3x3PnbfJvxfVz4vWFMPPRJN9zYfBSWMlvU9Qh721HWqg8PSRGtCJ09DTdSLfrYfJsXG1TtSDdfGGL9/D8fzflT53n7jQFv3iuAsyMNV61DZqzR+phlo5Kp9oxXgzvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS2PR02MB9488.eurprd02.prod.outlook.com (2603:10a6:20b:598::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 18:27:07 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Tue, 24 Oct 2023
 18:27:07 +0000
Message-ID: <674f7593-5421-4ecf-a0e0-2c46ab42a051@uipath.com>
Date:   Tue, 24 Oct 2023 21:27:00 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vsock/virtio: initialize the_virtio_vsock before using
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
References: <20231023192207.1804-1-alexandru.matei@uipath.com>
 <iqjmblf2n42w7afw42udxvju3znupmwrixfsbwcn247u7bayoc@zrbken7ls6m7>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <iqjmblf2n42w7afw42udxvju3znupmwrixfsbwcn247u7bayoc@zrbken7ls6m7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR10CA0101.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::30) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS2PR02MB9488:EE_
X-MS-Office365-Filtering-Correlation-Id: c1131d7f-a67c-4a9c-0a19-08dbd4bed40a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0i6waNBqPxf3tKqLyx9VO9ZcAV1lP4ojABy426TLXftGN0etgEpdFzmdu2+wsrkJPAG2d8vIhypsnWVlXmoyjKrtwId00zLXDsTMbT7FEvPbtBEeWO7kxhm9979hKeZjvDg3fYbDBuapiJB99XEz3q44v0+IBngRHBIHE9ItTo8DOPYpxcaMgRX0ZGqnGtDTmfLnAmI9qaxASusnvLeHO6oakQnrwIRUcMopq4sKnMbmfJ9Bzi+YgwtVmZjplbEOZ0LB747HE2230xlv62SIli1FRj3JCbwOMt3G/FYYGWU/Dw33UzmZ6yAJvavUD3WsfWg0ePcUDeVgsOJ2q6SV6YdZaNi4cDbaKDWqal4gpjHiavSXIcpmJ3rMmXL0dxBwqUtE2+en3ncVOUjRa79GlFFFr9+CKoDFPOJgXLlKVCGfgSQ4yOGg7vtgNO2GKajO+SdRrx9NDX/GULDuSc2Dbih8i4x23sxESl/Fu6F9kS+IN00Lga20eSkXD0rvM1T5lO6Nxb0GDpkxiImXds8Z9npWMSKahzOpt1jcQ3GklrwNoSgDq9ZNUtq+aaAj60q2+PlDH5r0VY/YbLpDyVk7wjcidi/bYCS//YXq2leSOid0JsJAq9GD8XqmgDo+GB0X0ROhKmEuUN/6kseeXxU0RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(396003)(366004)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6512007)(107886003)(26005)(7416002)(6666004)(2616005)(6506007)(8936002)(53546011)(83380400001)(5660300002)(8676002)(4326008)(478600001)(44832011)(6486002)(2906002)(41300700001)(316002)(6916009)(66476007)(54906003)(66556008)(66946007)(31696002)(38100700002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SU1TMm5ZSlRWRjVSdHNtcmR3MkRCbU9tZ0tXSmtlS0s1VzBFaDUvVlZPRDJq?=
 =?utf-8?B?cDVmbnNZQzU5aGhxcHdnSDdRNDk4MTJrL0k3c1ZXOWtMa3dVT2xjYUpLbnBp?=
 =?utf-8?B?STlLNVAybVhqRlNvTmlTblpGU0VIMEJyOTZLSWVBbUhyaW1WMEZTMUgvNFFH?=
 =?utf-8?B?eWZBQUY5amhHcHBya214MTFIbkU2SzU5QWw3SGhSZThqb3VvQjhuS2R3ZGJM?=
 =?utf-8?B?TVJwWUZ4VWJCSU9iWFJTbFN6L3Rjdys1VUtBSWw1S1BoOHhqc3lVVUJhbE1x?=
 =?utf-8?B?TDA5OHRvb1pCREMvNG11RU5lWW1sRktkR3RiellnazZHWWlOeGpIanBEdkhJ?=
 =?utf-8?B?bk5pTllzN0R4Wk0weEs1TWU2VldFUEQrc1R2eCtXNnozMmRZL3N4OEJHQlJG?=
 =?utf-8?B?TzlYeHJaMjI5NlVkTWw5RmJuQ25qNXVNS2VHOVZObnZiaXJCTVZKSEt5NXVH?=
 =?utf-8?B?QjJRRHRPdkZPUFowRVpQTDNyTEhuWENELzVqK3RWcEs5OTZRTm5EZE1LT1R5?=
 =?utf-8?B?ak9vMmN1SmE3TUFtUzhsRkFTNnBNQXBsRE5JN2x6R1Ura0dmbWZ4RDVCb0s0?=
 =?utf-8?B?aFY4ZGpBNUVBdEpQemtaTStFbVA4SVZ5eXptUzQweUxCLy9WMFdac0FsQk1M?=
 =?utf-8?B?UkFCWXcrWFduSDl3YkJEMWxpQ2ZOK29YbGV0TmgxSHJuYmo5QUNsMnZpN0lz?=
 =?utf-8?B?R0FmeFpBaURqbnV6V0F1bTlucUZtdFBlQmxTNHBkRm9IZk5SWXF3RjNaNDc0?=
 =?utf-8?B?ZEo1VG82NHBUaXdXcDBmRUpPSkNUNzVBUzlhamRucjdmNDh1MUJROWtyNGFH?=
 =?utf-8?B?NGpxWkprZmM4Z2c5d2UvZzFRMGZLaVZwUjFvQ1dKSloxNzRHODFicUx2Wk5C?=
 =?utf-8?B?aElCNDBndjZ4SUphNjlwM2pCWkl6MGZQVVpaeGdteG9xU1pRMlpwR2dFRWly?=
 =?utf-8?B?QjFRdGxURkNKdSs3elJyUWtSYjV4QXJyU2pweWxtQUtiT3k2UzRadFo1cXBT?=
 =?utf-8?B?ZWV0WHlLa0pKTGw2RGtkVTlkWnNxUGpBdnlEckR0SHNJczZiWU9OM053VndB?=
 =?utf-8?B?VXpaUmxzQTNzS1M3N2pFdlU1cU1Tcy9MQWorWmNUbkNUR2JVUzFpcjlDaGZ0?=
 =?utf-8?B?cjBUY3hCb25kbmhCdm4rRHJQWVVmcXZ2YUFvMENNeXd0a1BiUWJoRDlkU1lN?=
 =?utf-8?B?eGZOSjVXOFNOMmZnUFo0S21sYXk4Q3FkSDZBUUlxbEE4SzdmODFQTUFDaHBy?=
 =?utf-8?B?c2xhbGxib2s5aHJZOFYvbGtpb2hSTDhtZ0hBVUdjK0YrUGV1N2tKSzVRRG5w?=
 =?utf-8?B?SWFzanA4dVJoVE0zTnkvS3V0cXBFcHRGWkJsUTJMUHNyY2ZuUFB1c3I2dml5?=
 =?utf-8?B?aEJTTU9TUFhLa2ZuMnJOd20zYTh3VmlacTQ2ZkJWY3ZqZi85V0JxaC82bkVO?=
 =?utf-8?B?YVFaK2NhSjlSNHlYZTh3WkQ2U2VGaGg2aTlkb1BKbm9hQS8vY056NndNT01w?=
 =?utf-8?B?cmVQZ3A3UWd0TGtvbmxOdkRZTC8xNlNWbHFyL3l1LzE2aGNSU0NiVFhMcjFz?=
 =?utf-8?B?SlF4OWRtNHAvdmw3aEFWdnpaOHRnVDBxbTljWHlRbTF3b25mQ3ZOT1FmSE9B?=
 =?utf-8?B?cFVKSW9yaW12cjlUNkkzRHF3TVBLZjRWQXpoaThjRHVYWnRQUEZSYUFER2dW?=
 =?utf-8?B?c3grcDNGSlc5dXhGRWFIcllWMEdIa0s4bzNjZ3Y3K0VXZVhWTUdweVhJVHBU?=
 =?utf-8?B?cXBlUUxwUStqUGtLQXE4M2RxUUtTSkdXak4wZWNDNTlsdnNLU3Y0TFY1VmlW?=
 =?utf-8?B?K3duWThEbU5yaVhjSk16MWNLV2ZMOEpkNmFJTVhsZ3ZJVm4wbEt0TmFOSzFO?=
 =?utf-8?B?cE9xUUcxaWZjWG11OGZLbjJiRml1a3ZCbmVuS3VYR3BvVy9IZGdsajJmdHc4?=
 =?utf-8?B?MUpxVEUvSVgvS3ZFVmJncUxPRkc3M2t6NC9CcUdLbklNK3Z4NDk0UU5iaHpm?=
 =?utf-8?B?NXBmVWQzS2p5aXZQZTZWTzZZeDl2Y3lGa1dRNURJR1h3VG04M0FzdExYVlVp?=
 =?utf-8?B?ZG85bVJ6aWJpZm83anBRTnN3aVB4ZTkrbWQ4TDF1MlJTMmhvVHVOYlEyRUIz?=
 =?utf-8?B?Q3AwTG0zQTlaYzlQR0x3bXgweGNuMml6cEV4VWdHRHNpcDgwVUl3Ym5mMGRL?=
 =?utf-8?B?ZEE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1131d7f-a67c-4a9c-0a19-08dbd4bed40a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 18:27:07.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJxRuZJXhOAxQXZHI2eFetMt3PRPEnREK+uZKhffYlqRHyiIPVMatBDRxpOeizo6QhefGoMxb1XeHVbkGWaA5J6PJte16q7B32OYh0Hb/KA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR02MB9488
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/24/2023 10:22 AM, Stefano Garzarella wrote:
> On Mon, Oct 23, 2023 at 10:22:07PM +0300, Alexandru Matei wrote:
>> Once VQs are filled with empty buffers and we kick the host, it can send
>> connection requests. If the_virtio_vsock is not initialized before,
>> replies are silently dropped and do not reach the host.
>>
>> virtio_transport_send_pkt() can queue packets once the_virtio_vsock is
>> set, but they won't be processed until vsock->tx_run is set to true. We
>> queue vsock->send_pkt_work when initialization finishes to send those
>> packets queued earlier.
>>
>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>> ---
>> v3:
>> - renamed vqs_fill to vqs_start and moved tx_run initialization to it
>> - queued send_pkt_work at the end of initialization to send packets queued earlier
>> v2:
>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>  the_virtio_vsock initialization after vqs_init
>>
>> net/vmw_vsock/virtio_transport.c | 13 +++++++++++--
>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index e95df847176b..c0333f9a8002 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -555,6 +555,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>
>>     virtio_device_ready(vdev);
>>
>> +    return 0;
>> +}
>> +
>> +static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
>> +{
>>     mutex_lock(&vsock->tx_lock);
>>     vsock->tx_run = true;
>>     mutex_unlock(&vsock->tx_lock);
>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>     virtio_vsock_event_fill(vsock);
>>     vsock->event_run = true;
>>     mutex_unlock(&vsock->event_lock);
>> -
>> -    return 0;
>> }
>>
>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>> @@ -664,6 +667,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>         goto out;
>>
>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>> +    virtio_vsock_vqs_start(vsock);
>> +
>> +    queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> 
> I would move this call in virtio_vsock_vqs_start() adding also a comment on top, bringing back what you wrote in the commit. Something like this:
> 
>         /* virtio_transport_send_pkt() can queue packets once
>          * the_virtio_vsock is set, but they won't be processed until
>          * vsock->tx_run is set to true. We queue vsock->send_pkt_work
>          * when initialization finishes to send those packets queued
>          * earlier.
>          */
> 
> Just as a consideration, we don't need to queue the other workers (rx, event) because as long as we don't fill the queues with empty buffers, the host can't send us any notification. (We could add it in the comment if you want).
> 

Thanks. Sure, I added it in the comment.

> The rest LGTM!
> 
> Thanks,
> Stefano
> 
>>
>>     mutex_unlock(&the_virtio_vsock_mutex);
>>
>> @@ -736,6 +742,9 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>         goto out;
>>
>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>> +    virtio_vsock_vqs_start(vsock);
>> +
>> +    queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>>
>> out:
>>     mutex_unlock(&the_virtio_vsock_mutex);
>> -- 
>> 2.25.1
>>
> 
