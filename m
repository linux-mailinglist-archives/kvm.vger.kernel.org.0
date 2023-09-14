Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E0B7A06FA
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 16:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbjINOMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 10:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbjINOMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 10:12:07 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8A1BF9;
        Thu, 14 Sep 2023 07:12:01 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 0D1CE100006;
        Thu, 14 Sep 2023 17:11:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0D1CE100006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694700719;
        bh=2Sn5v2IP39dIXPaQUcY6Rx1KATowf+vHArILTGeExRg=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=EXo9SW1260pWO5Q+lg2E7ys1XB+qwE7RBTM83czOFyrEpRJgnfiw12L1Db6YK4aEK
         b52wvkIFSDf4q2jTUwKKoWuWhDhb96oXXZcNwnjBYD631fPlNrOOmkUVT7Z8PFc4f6
         gu28DlZ1IbgiPauR0CEbMQkUi4h9rDtjBOv5//4qnhsxycvhax4knZS771rM+eJxNr
         KmNUSTlRx1afirK7TIncF7PJcXlKvjCYDlZrb4Xq2rZmo2PhRyzRCfYds6dNASbGD3
         oxyRUQfb4ipel4TMT5vIbNWlj+JIsPG7pXT2f4gOdXDhz2D5eTXeaZWY4bZrwiUgcc
         k0qQ+bnXOoFbg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Thu, 14 Sep 2023 17:11:58 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 14 Sep 2023 17:11:58 +0300
Message-ID: <7bf35d28-893b-5bea-beb7-9a25bc2f0a0e@salutedevices.com>
Date:   Thu, 14 Sep 2023 17:05:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v8 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
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
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
 <554ugdobcmxraek662xkxjdehcu5ri6awxvhvlvnygyru5zlsx@e7cyloz6so7u>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <554ugdobcmxraek662xkxjdehcu5ri6awxvhvlvnygyru5zlsx@e7cyloz6so7u>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179868 [Sep 14 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/14 12:07:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/14 12:07:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/14 11:07:00 #21890594
X-KSMG-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Stefano,

On 14.09.2023 17:07, Stefano Garzarella wrote:
> Hi Arseniy,
> 
> On Mon, Sep 11, 2023 at 11:22:30PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this patchset is first of three parts of another big patchset for
>> MSG_ZEROCOPY flag support:
>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>
>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>> suggested to split it for three parts to simplify review and merging:
>>
>> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>   tx completions) and update for Documentation/.
>> 3) Updates for tests and utils.
>>
>> This series enables handling of fragged skbs in virtio and vhost parts.
>> Newly logic won't be triggered, because SO_ZEROCOPY options is still
>> impossible to enable at this moment (next bunch of patches from big
>> set above will enable it).
>>
>> I've included changelog to some patches anyway, because there were some
>> comments during review of last big patchset from the link above.
> 
> Thanks, I left some comments on patch 4, the others LGTM.
> Sorry to not having spotted them before, but moving
> virtio_transport_alloc_skb() around the file, made the patch a little
> confusing and difficult to review.

Sure, no problem, I'll fix them! Thanks for review.

> 
> In addition, I started having failures of test 14 (server: host,
> client: guest), so I looked better to see if there was anything wrong,
> but it fails me even without this series applied.
> 
> It happens to me intermittently (~30%), does it happen to you?
> Can you take a look at it?

Yes! sometime ago I also started to get fails of this test, not ~30%,
significantly rare, but it depends on environment I guess, anyway I'm going to
look at this on the next few days

Thanks, Arseniy

> 
> host$ ./vsock_test --mode=server --control-port=12345 --peer-cid=4
> ...
> 14 - SOCK_STREAM virtio skb merge...expected recv(2) returns 8 bytes, got 3
> 
> guest$ ./vsock_test --mode=client --control-host=192.168.133.2 --control-port=12345 --peer-cid=2
> 
> Thanks,
> Stefano
> 
