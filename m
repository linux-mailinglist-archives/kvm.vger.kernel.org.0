Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C04E7D3C72
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjJWQ2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJWQ2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:28:38 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2108.outbound.protection.outlook.com [40.107.21.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD6EE4;
        Mon, 23 Oct 2023 09:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzjHgOkSEpQTlApuNsoxFHXgDMePdm8+l9sg4To4+NERyAYB/t37cIbOW9Sxdoc4Tjc4QslhLa2PEnqSExl4T8p8qa6oI6INfxYLqHm/IWZraZ0sviDEnp/KIWhtr2Hu5Th3D2Ri55uvQsTCsC5v+0IfaBw3W7UqOjKDn52pB67ah9XVEfuBKaIZRfpp6IxYfUO23ECBRpswzVZBJ0mTzkayuXcokYnrzMkTPsqXPfmWBtusYl3m9GDHH/jMKh2RngzbUqoDnYyRN/Xwa/Ft6WsBQR7yHYBrS4baFenHoOZovF8KrzinalBtxs03bW/xn6S+GQ2fqd9/4JuTjnj3LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuC0gfeZoJR1ouzsswHHO33NEkbG1stSD+ry7VWOaM0=;
 b=jaNfJT/k081ZK0Vz2d4o7J+FUGyboL75E+h594mKeJTG+IJs8CvhIZdKDFN2p8YSmRIAwC46tpgOSW7b5xY/+L9kZ/lBH5EfJgvuofbdbpzdg1miDIOsrVUkNzNFQ3VfSSvS0SRtNLxdhyqJ4+IMf09tuhOnToDzFzHF9y7+faSxCdSIY1vJO+S4XonPoQMdQfBboQQnzo3jS/rImmiUnnT/uXSlLlXwXevsjBfkHr/BnEO7Gk4mUz2/ahmL0lC1oZ5x+KGb8x7+xNuEB/se2RLHFh2tyiZ2XOWSDN36GmRsmGBO+TM6pr2NGB7VgwMNlDNELpfbGvoAI3gaUkogyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuC0gfeZoJR1ouzsswHHO33NEkbG1stSD+ry7VWOaM0=;
 b=uknbGrSzVeaR77pMvM9PdjfFJ+EL6Z5WcCWssYgidaY1fpcb42NSSoohtYDQwP8ZlLgN+OSaJxgwaKs7UIc0of8q1QJMn5SWnZmM4wN9VTwfeImFdmf2HCfAzNnG1dx4Ek5dJZRf/Ml9VA6mzj0WltB8OOqEwud7hgMVJMoD0b6hfS3LnPuM7d2QFID+9z16rwZZqHBunZ/pPlSyr8JF0qzEvOewqCjBuhT2hw1ehZmnDyPc3WOAe+lhFxYiUbVs3CyJhmQN0ZO5cd3SywAYgttUpLRDaVwEi9CaWaRLOA9WmQAHnXQ7tYCUVIyT65m2pV3y0/TV8JCZeLiIGXxpGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6669.eurprd02.prod.outlook.com (2603:10a6:102:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 16:28:33 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::717d:6e0d:ec4b:7668%6]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 16:28:33 +0000
Message-ID: <e7929cb0-ccb1-46c9-99bf-2c6035eb7c01@uipath.com>
Date:   Mon, 23 Oct 2023 19:28:30 +0300
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
 <632465d0-e04c-4e10-abb9-a740d6e3dc30@uipath.com>
 <dynlbzmgtr35byn5etbar33ufhweii6gk2pct5wpqxpqubchce@cltop4aar7r6>
 <01ad7d00-9a53-445b-8916-3342047112a0@uipath.com>
 <jyjfsjvfmmr7ucf53v6p57scdxah64bgvd2lj7l4hbjwiyd2ct@lj3ejlseqvog>
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <jyjfsjvfmmr7ucf53v6p57scdxah64bgvd2lj7l4hbjwiyd2ct@lj3ejlseqvog>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0199.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::20) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6669:EE_
X-MS-Office365-Filtering-Correlation-Id: 039ca1dc-65b0-4484-519b-08dbd3e51922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXCla3P//jSRzoKPQW+rA3RYfqwQqvtlf/2VxNi/gMo27McW7lprpL9Iz7pkIEA7KGo/8lSdzDqpOf7BfQUz5NZcNpmnxE/FYxd7BFVlLy+niDsyMyj7uvZtw2O8Gxk36WciTrDwLBnh6h5EF8qoH+h2aRmELX7JiOSjnJBMQIgRZMBQ+flFs2eoSje3GGoSR7oT+ATUEC6Sz2zmavsUWJ4iLeLvFXs2gkbmJbflsdYn2w0NhVPLLdafLKll6MWYA29UDnxUrSueVHls73pg4keEyHnNZnJAboTNF4QHcxYA1N7904jcZW7ZXcoQ9HR05RnOFHIXjmRgVhRmo4/6DOhY/aZ7o9jNe1WcbOM4V7a3Ayc6Fs/e2EPRT7TzpexFWiHKJdcoecWB2CXkP8RANXg2cS5IVr+FuKCdr7sJSurv622uVhToWZTatV/w0h1bbSoTTkTlJMPzguD6RBdniu/7fORqhjsJWq4AddweY5rSBW0873IgqRY454drBFCWTJOm+Uh9rCZQq7S4v6tTnWPmu0r3vA8BDBHdTFGc8O4TrYf33KMNDNs4OAkGQpO399apm1evdBAAMrk8orFU5GgbJRkdIAxVW8MX+fse+VpszxCgadnQf753Mx+KipmDw2a40KujbR+h6aaJOUNY6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(39860400002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(31686004)(41300700001)(38100700002)(2906002)(44832011)(86362001)(31696002)(5660300002)(36756003)(7416002)(8676002)(8936002)(4326008)(6506007)(478600001)(107886003)(2616005)(66946007)(6916009)(54906003)(66476007)(316002)(66556008)(83380400001)(6486002)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3NIWFdyTFlmd05JaSsxSFoyYmxLdG9LUCt6a014RGVBZE13QStPTlpWNzRY?=
 =?utf-8?B?SVlHakVCeWdYSk5jUGtCZ0ZlYllHdjU3NlkzL0dHZVg5eWQyWVJnVjNxTUVZ?=
 =?utf-8?B?VklEYXNROTQxQ2dlR1B6amhVNTZyZEZMRjNWdlRuU24rRDdZdW53L2szTFNi?=
 =?utf-8?B?MW9EOHI3amIzVEZxTHY0K2tlOUU5U0oyRXI3M01QNWVWWWlGUm94czRJajRG?=
 =?utf-8?B?MXpCODZaaTV0OWc3VGlmVkJXRldTVmFUVnhrNit2c1BGYXV3UHA5dFJsL0ty?=
 =?utf-8?B?U0ZSdUREa2t4cDJNS0dUMGNjQmZZdWZ0VjlLTDlQRTlhb1BkeFYvc0ViYVE3?=
 =?utf-8?B?OXFWdWJJWXVvWDJjemowck5MclQ3SlllSThrenpWdVNVK2EwWXhlVW9wTzhH?=
 =?utf-8?B?a0Y4eWZPTkFLZ2o2MWVhVXB0TWw2QzByY3QrdnZMWWVWZnM3dkhjSDRteExF?=
 =?utf-8?B?S2JYK2tMMWp3YVdsMFFTODY0Vm5sU1Q2VDdXK000Zi9jVXZQWmdtVVkreS9y?=
 =?utf-8?B?Y3hQTGxPejUxMmo4MVdINkpTZEl0YzczeEZQbjRULytISnYxNXFoZnNwVVBk?=
 =?utf-8?B?aDNZYUZWbVpSVnhpVkpxb2lrLzlHaHlwVTlEcXBBWE5tRENUYXd2Qlk4TjNC?=
 =?utf-8?B?WGlwbFI3UmRWcDBhWVNjTmhsdHJvbEVDc01HVHc2MWlab09Yc2dudnBjSG9o?=
 =?utf-8?B?WGNBeVY3Q29mZVYyY2F6RUoyUjlyOGJUMHBkTEQxRWo5ZHJxdE1iVU01a1N6?=
 =?utf-8?B?M0dUb0Fiem5IQm9Zb1p4UXMvRmNsRE1tUXQ1VzNSZTBFWmJ1N3Vja3FndFpp?=
 =?utf-8?B?dmdhb3ZTYURCTk1NdlZMUVdrY2ZBaEgxSE50WUdKL3Y5MkNRaHVSckk3Tmtv?=
 =?utf-8?B?V3g1M1RPTFA5SldmYzVnUTQ2UHFvaU81L1JFeDRjRWxSSFUzUXcrdEE5TWVC?=
 =?utf-8?B?VEdGYTFSdjhYSWRqVVZmMjNaZDBsejd3ZnRyOFFBbFl3SlVRREdBY3V3VzFp?=
 =?utf-8?B?RjdMc1c2Ujc5SFRVTXF6bngveVFKZHJzNmJXRFJINmczcEMwUlNIYmVuWUJN?=
 =?utf-8?B?R0N5TnVrTmRUN1NBQlp3cVp3TnBiRUJ0ZEpCVmIxTHA2UXBtVVU3QTREUFdh?=
 =?utf-8?B?WFM4VDNyL21wZEVvRTQweklNYW03OUtzVU9NdTZ3T3Y2WmVnTUxkdUpuQjdT?=
 =?utf-8?B?cHdPSkpZOWU0UTgxUmNMZW1hKy95dmMyS1hmTndNR1B0aWl0ZTB5RFZYMFI5?=
 =?utf-8?B?MDB6U0p2MVlqTytHT25YT29XVTI4VEJmQkFLbXQzTmhJdjl2OGI1RVlvWWl2?=
 =?utf-8?B?MUlYWDA3cFdaYnBpQ3RkQkhSZDRPaHlxbTVHUTZvUGROcWx0QzVwVkFHUlNQ?=
 =?utf-8?B?WmMzTS9zOTdyM2RuelRlQ1RCMnBNYjFVMEVVTVF3UnVHRXc2TWxndERWUmFQ?=
 =?utf-8?B?QkI2SnU4bEhTS0pLcTVsR1ZDK2VkdnFzWkNibFI1WFRwUThOdVNCMXlpUzRm?=
 =?utf-8?B?ME5pdWdIT0FTVGhXdDZXUWJ6SmY4eHBDL0xTd25MUnFUektVTTIrRFRmV0M2?=
 =?utf-8?B?UFlteFVndFlydHdFUXJRQkdiNExLNk5kSGN1MWdwemZtcG5XMTdyeG1Yb0dr?=
 =?utf-8?B?MElKZGRtNENSbEIxUExBQk9adjlGK3V3VnlUZ2dSSjhGeWxOSktRS21rL3dm?=
 =?utf-8?B?UzlHWU5PcDRTZWZ1RUs0ZnhvVWErSEtFT2dqYjVtMm9nR1pwT0VsRUw3UEgw?=
 =?utf-8?B?WG5sbXM5Z2FKT0xGSHZ6ZmV3ZWt2SkQ5eCtlV0xmbUhMOXFqUHpmdk5sYzZJ?=
 =?utf-8?B?VWM3eDZPSzdnMTJwYjc4UkJsWUhxNkpmWFNGT1hKM1JCaXFka2F5aDc0ZUlt?=
 =?utf-8?B?R2hDVVk0T1NsOVAvYXBNbk5ReHdKZ1RkbEE4RDNjYnQrcmdzVEY0Y3QyZTZS?=
 =?utf-8?B?YUt5RmZCdStaa0pod1RBZERHa2d1bzBEc2ZPZmhMVktMamJSNUtzVDhEb3Q5?=
 =?utf-8?B?dHkxVVM2VzU3TDltMlZJdGZlRk0rQk5tbm91YmFYdXIvR3lLTkoxSDFtOVVS?=
 =?utf-8?B?WXZyUDAvWGx1Skx1SzJsSjBXbmxwYW5rTlQrcnJQV3pWRkhsWHkxTVJPUnNE?=
 =?utf-8?B?MUkvZDNiQWZ6T1Bkb0lNUmFDbWNjT1JPeFZieDJxRDA2TkFQZEV2NGdnbGRN?=
 =?utf-8?B?NVE9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039ca1dc-65b0-4484-519b-08dbd3e51922
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 16:28:32.7868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoPk4wt6xZLiKdpWJz/NJ0GVmMbMHdJi1BbvmIOV4LKgdlZCrNc1f+k9RpvcXYmyFSxIG+sn/bclvjbl4In5k5nqw9VdSL4q36L4d/5iG2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6669
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/2023 7:10 PM, Stefano Garzarella wrote:
> On Mon, Oct 23, 2023 at 06:36:21PM +0300, Alexandru Matei wrote:
>> On 10/23/2023 6:13 PM, Stefano Garzarella wrote:
>>> On Mon, Oct 23, 2023 at 05:59:45PM +0300, Alexandru Matei wrote:
>>>> On 10/23/2023 5:52 PM, Alexandru Matei wrote:
>>>>> On 10/23/2023 5:29 PM, Stefano Garzarella wrote:
>>>>>> On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>>>>>>> Once VQs are filled with empty buffers and we kick the host,
>>>>>>> it can send connection requests.  If 'the_virtio_vsock' is not
>>>>>>> initialized before, replies are silently dropped and do not reach the host.
>>>>>>>
>>>>>>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>>>>>>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>>>>>>> ---
>>>>>>> v2:
>>>>>>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>>>>>>  the_virtio_vsock initialization after vqs_init
>>>>>>>
>>>>>>> net/vmw_vsock/virtio_transport.c | 9 +++++++--
>>>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>>>>> index e95df847176b..92738d1697c1 100644
>>>>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>>>>> @@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>>>>     vsock->tx_run = true;
>>>>>>>     mutex_unlock(&vsock->tx_lock);
>>>>>>>
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
>>>>>>
>>>>>> What about renaming this function in virtio_vsock_vqs_start() and move also the setting of `tx_run` here?
>>>>>
>>>>> It works but in this case we also need to move rcu_assign_pointer in virtio_vsock_vqs_start(),
>>>>> the assignment needs to be right after setting tx_run to true and before filling the VQs.
>>>
>>> Why?
>>>
>>> If `rx_run` is false, we shouldn't need to send replies to the host IIUC.
>>>
>>> If we need this instead, please add a comment in the code, but also in the commit, because it's not clear why.
>>>
>>
>> We need rcu_assign_pointer after setting tx_run to true for connections that are initiated from the guest -> host.
>> virtio_transport_connect() calls virtio_transport_send_pkt().  Once 'the_virtio_vsock' is initialized, virtio_transport_send_pkt() will queue the packet,
>> but virtio_transport_send_pkt_work() will exit if tx_run is false.
> 
> Okay, but in this case we could safely queue &vsock->send_pkt_work after finishing initialization to send those packets queued earlier.
> 
> In the meantime I'll try to see if we can leave the initialization of `the_virtio_vsock` as the ulitmate step and maybe go out first in the workers if it's not set.
> 
> That way just queue all the workers after everything is done and we should be fine.
> 

Yep, Thanks for input, I'll send another patch with this approach.
I'll keep virtio_vsock_vqs_init() split in virtio_vsock_vqs_init() and virtio_vsock_vqs_start(), 
move tx_run setting in virtio_vsock_vqs_start() and queue &vsock->send_pkt_work after virtio_vsock_vqs_start() is called. 

>>
>>>>>
>>>>
>>>> And if we move rcu_assign_pointer then there is no need to split the function in two,
>>>> We can move rcu_assign_pointer() directly inside virtio_vsock_vqs_init() after setting tx_run.
>>>
>>> Yep, this could be another option, but we need to change the name of that function in this case.
>>>
>>
>> OK, how does virtio_vsock_vqs_setup() sound?
> 
> Or virtio_vsock_start() (without vqs)
> 
> Stefano
> 
>>
>>> Stefano
>>>
>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Stefano
>>>>>>
>>>>>>> +{
>>>>>>>     mutex_lock(&vsock->rx_lock);
>>>>>>>     virtio_vsock_rx_fill(vsock);
>>>>>>>     vsock->rx_run = true;
>>>>>>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>>>>     virtio_vsock_event_fill(vsock);
>>>>>>>     vsock->event_run = true;
>>>>>>>     mutex_unlock(&vsock->event_lock);
>>>>>>> -
>>>>>>> -    return 0;
>>>>>>> }
>>>>>>>
>>>>>>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>>>>>> @@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>>>>>         goto out;
>>>>>>>
>>>>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>>>>
>>>>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>>>>>
>>>>>>> @@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>>>>>>         goto out;
>>>>>>>
>>>>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>>>>
>>>>>>> out:
>>>>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>>>>> -- 
>>>>>>> 2.34.1
>>>>>>>
>>>>>>
>>>>
>>>
>>
> 
