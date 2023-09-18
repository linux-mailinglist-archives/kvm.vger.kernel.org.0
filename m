Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A187A5053
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjIRRDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjIRRDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:03:17 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D88CCA;
        Mon, 18 Sep 2023 10:02:52 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 391A1120005;
        Mon, 18 Sep 2023 20:02:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 391A1120005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695056569;
        bh=0o7hfC4+F2euSGNP8krkD3xbGeD5dgDDhH9/E/Lq2pU=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=alLQUDbysr3L8dz+yeBvWT/+riB6RuYqj7NgmEpmNffdudRO0n1tnLS3FhR/bUSzj
         7xupnALTsYbWRHcoHWJBLuj/wWLdObKCAXFtGT5Pq+pjt0Sj9X8a3YYcCwftuBhPVZ
         N4GKOnCVOsdacrg3XxJ3rg8Gurb/r5JXe8AHsKv/TmDCFY7dKzJqoyfs79P+cdbkUz
         9y49nVvJ52TdBH/W6r4QZCvBd5V4HH1TZxbxMUOH0kLzrjzqB23b5gIrTh3TLRJXE4
         msqgEqiqmlu3mrokmPsaplWm9+V2JGxws9bCJbYcu/OTHHAiSphOnz/O4/Znwunr0p
         6Nqhqfn27mdKQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 18 Sep 2023 20:02:48 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 18 Sep 2023 20:02:47 +0300
Message-ID: <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
Date:   Mon, 18 Sep 2023 19:56:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179934 [Sep 18 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;git.kernel.org:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/18 14:42:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/18 16:49:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/18 14:09:00 #21917825
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefano,

thanks for review! So when this patchset will be merged to net-next,
I'll start sending next part of MSG_ZEROCOPY patchset, e.g. AF_VSOCK +
Documentation/ patches.

Thanks, Arseniy

On 16.09.2023 16:09, Arseniy Krasnov wrote:
> Hello,
> 
> this patchset is first of three parts of another big patchset for
> MSG_ZEROCOPY flag support:
> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
> 
> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
> suggested to split it for three parts to simplify review and merging:
> 
> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>    tx completions) and update for Documentation/.
> 3) Updates for tests and utils.
> 
> This series enables handling of fragged skbs in virtio and vhost parts.
> Newly logic won't be triggered, because SO_ZEROCOPY options is still
> impossible to enable at this moment (next bunch of patches from big
> set above will enable it).
> 
> I've included changelog to some patches anyway, because there were some
> comments during review of last big patchset from the link above.
> 
> Head for this patchset is:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f2fa1c812c91e99d0317d1fc7d845e1e05f39716
> 
> Link to v1:
> https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
> Link to v2:
> https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
> Link to v3:
> https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/
> Link to v4:
> https://lore.kernel.org/netdev/20230727222627.1895355-1-AVKrasnov@sberdevices.ru/
> Link to v5:
> https://lore.kernel.org/netdev/20230730085905.3420811-1-AVKrasnov@sberdevices.ru/
> Link to v6:
> https://lore.kernel.org/netdev/20230814212720.3679058-1-AVKrasnov@sberdevices.ru/
> Link to v7:
> https://lore.kernel.org/netdev/20230827085436.941183-1-avkrasnov@salutedevices.com/
> Link to v8:
> https://lore.kernel.org/netdev/20230911202234.1932024-1-avkrasnov@salutedevices.com/
> 
> Changelog:
>  v3 -> v4:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  v4 -> v5:
>  * See per-patch changelog after ---.
>  v5 -> v6:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v6 -> v7:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v7 -> v8:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v8 -> v9:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
> 
> Arseniy Krasnov (4):
>   vsock/virtio/vhost: read data from non-linear skb
>   vsock/virtio: support to send non-linear skb
>   vsock/virtio: non-linear skb handling for tap
>   vsock/virtio: MSG_ZEROCOPY flag support
> 
>  drivers/vhost/vsock.c                         |  14 +-
>  include/linux/virtio_vsock.h                  |  10 +
>  .../events/vsock_virtio_transport_common.h    |  12 +-
>  net/vmw_vsock/virtio_transport.c              |  92 +++++-
>  net/vmw_vsock/virtio_transport_common.c       | 307 ++++++++++++++----
>  5 files changed, 348 insertions(+), 87 deletions(-)
> 
