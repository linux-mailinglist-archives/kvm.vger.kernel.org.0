Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61D7AF45E
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbjIZTrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjIZTrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:47:15 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15F992;
        Tue, 26 Sep 2023 12:47:07 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8CD94120002;
        Tue, 26 Sep 2023 22:47:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8CD94120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695757626;
        bh=t3cYz/wIiibTioSLtw2PzNx1RPz2O5jXFit/LK8w1Bk=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=BHYuJYM3tQ/RXKej+Z9jjc+EmiDTc/r1DXrgURe/BcfQliThIKOotKCwwbiWuJtCE
         4udqbKQS6q2ArrGduC4dREvjIHXJV68KOWmDaSIc6sW3PwjGvmv4ruCWQYVXqlrAqy
         /EYdZm0uw91zk+5AGE4x5qJzrMM5Rm5jgxsW1Sww41LHHN2A6vipG8dDrZqgFfFYAX
         j4/1ztwlD/ijfyj24lJP+cNaKRmPEM3vmWWDy+JpoQYP7ANb4TQiPTDTEGPa7BMB/k
         /O0Ub0tXlAerkMryDsaTl6XwZez1a+Zp/OPFHfDi8lyBScRX9LniUOmUKducZtTtEo
         Uq004BpnQGWWA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 26 Sep 2023 22:47:06 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 26 Sep 2023 22:47:05 +0300
Message-ID: <9b467359-4e4d-619f-e71c-172f5614c4b2@salutedevices.com>
Date:   Tue, 26 Sep 2023 22:40:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 00/12] vsock/virtio: continue MSG_ZEROCOPY
 support
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <zurqqucjbdnyxub6u7ya5gzt2nxgrgp4ggvz76smljqzfi6qzb@lr6ojra35bab>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <zurqqucjbdnyxub6u7ya5gzt2nxgrgp4ggvz76smljqzfi6qzb@lr6ojra35bab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180147 [Sep 26 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, git.kernel.org:7.1.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/26 18:37:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/26 18:37:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/26 14:54:00 #21988070
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.09.2023 16:10, Stefano Garzarella wrote:
> Hi Arseniy,
> 
> On Fri, Sep 22, 2023 at 08:24:16AM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this patchset contains second and third parts of another big patchset
>> for MSG_ZEROCOPY flag support:
>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>
>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>> suggested to split it for three parts to simplify review and merging:
>>
>> 1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
>>   link below)
>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>   tx completions) and update for Documentation/. <-- this patchset
>> 3) Updates for tests and utils. <-- this patchset
>>
>> Part 1) was merged:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
>>
>> Head for this patchset is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
> 
> Thanks for the series.
> I did a quick review highlighting some things that need to be changed.
> 
> Overall, the series seems to be in good shape. The tests went well.
> 
> In the next few days I'll see if I can get a better look at the larger patches like the tests, or I'll check in the next version.

Hello Stefano,

Thanks for review, almost all comments are clear to me, I'll fix them.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
