Return-Path: <kvm+bounces-3772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FC6807A58
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EED382824CE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D04563A8;
	Wed,  6 Dec 2023 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="MsMIVISd"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387C7D5B;
	Wed,  6 Dec 2023 13:27:12 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 48DA910008B;
	Thu,  7 Dec 2023 00:27:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 48DA910008B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701898029;
	bh=1QBoRtPkVihmAw3uPQaZ5DGwjhNYM5MoMQCYNXZzyVs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=MsMIVISdh+X59WVGIiy3ZNEg/isVhPySc93krPO4056HLfgk/rWWi20L8T2H6J4yb
	 v8BUZlfbzPX7FOTvN7txeFZ2cOOM7vYjLlI41KFxg1lZN1qxXH/G0758cpE7Pbf/46
	 0f8lq0KnqsnpGYW1cuO6GhtfZo6jIVXFROmJLccl6sTMeIFmjQMwOC2EQQXg8Tjpo1
	 2NJsj3FVYEMYlGg3uyl598Cz31LtvB9ghzR2fBcWtLVQJqG0ZgFI6ywfcisU340ig3
	 IxX7lQmG/uqkvh/2Mmh5sRljoTHBvDbvmrg2ykaAdPVSXpH/zERWGyw/vvNRfuwyqn
	 Xg170l1qU9YNg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu,  7 Dec 2023 00:27:08 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 7 Dec 2023 00:27:08 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v7 0/4] send credit update during setting SO_RCVLOWAT
Date: Thu, 7 Dec 2023 00:18:45 +0300
Message-ID: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181917 [Dec 06 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1;lore.kernel.org:7.1.1;git.kernel.org:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/12/06 18:31:00
X-KSMG-LinksScanning: Clean, bases: 2023/12/06 18:31:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/06 19:07:00 #22622451
X-KSMG-AntiVirus-Status: Clean, skipped

Hello,

                               DESCRIPTION

This patchset fixes old problem with hungup of both rx/tx sides and adds
test for it. This happens due to non-default SO_RCVLOWAT value and
deferred credit update in virtio/vsock. Link to previous old patchset:
https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/

Here is what happens step by step:

                                  TEST

                            INITIAL CONDITIONS

1) Vsock buffer size is 128KB.
2) Maximum packet size is also 64KB as defined in header (yes it is
   hardcoded, just to remind about that value).
3) SO_RCVLOWAT is default, e.g. 1 byte.


                                 STEPS

            SENDER                              RECEIVER
1) sends 128KB + 1 byte in a
   single buffer. 128KB will
   be sent, but for 1 byte
   sender will wait for free
   space at peer. Sender goes
   to sleep.


2)                                     reads 64KB, credit update not sent
3)                                     sets SO_RCVLOWAT to 64KB + 1
4)                                     poll() -> wait forever, there is
                                       only 64KB available to read.

So in step 4) receiver also goes to sleep, waiting for enough data or
connection shutdown message from the sender. Idea to fix it is that rx
kicks tx side to continue transmission (and may be close connection)
when rx changes number of bytes to be woken up (e.g. SO_RCVLOWAT) and
this value is bigger than number of available bytes to read.

I've added small test for this, but not sure as it uses hardcoded value
for maximum packet length, this value is defined in kernel header and
used to control deferred credit update. And as this is not available to
userspace, I can't control test parameters correctly (if one day this
define will be changed - test may become useless). 

Head for this patchset is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=021b0c952f226236f2edf89c737efb9a28d1422d

Link to v1:
https://lore.kernel.org/netdev/20231108072004.1045669-1-avkrasnov@salutedevices.com/
Link to v2:
https://lore.kernel.org/netdev/20231119204922.2251912-1-avkrasnov@salutedevices.com/
Link to v3:
https://lore.kernel.org/netdev/20231122180510.2297075-1-avkrasnov@salutedevices.com/
Link to v4:
https://lore.kernel.org/netdev/20231129212519.2938875-1-avkrasnov@salutedevices.com/
Link to v5:
https://lore.kernel.org/netdev/20231130130840.253733-1-avkrasnov@salutedevices.com/
Link to v6:
https://lore.kernel.org/netdev/20231205064806.2851305-1-avkrasnov@salutedevices.com/

Changelog:
v1 -> v2:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * New patch is added as 0001 - it removes return from SO_RCVLOWAT set
   callback in 'af_vsock.c' when transport callback is set - with that
   we can set 'sk_rcvlowat' only once in 'af_vsock.c' and in future do
   not copy-paste it to every transport. It was discussed in v1.
 * See per-patch changelog after ---.
v2 -> v3:
 * See changelog after --- in 0003 only (0001 and 0002 still same).
v3 -> v4:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.
v4 -> v5:
 * Change patchset tag 'RFC' -> 'net-next'.
 * See per-patch changelog after ---.
v5 -> v6:
 * New patch 0003 which sends credit update during reading bytes from
   socket.
 * See per-patch changelog after ---.
v6 -> v7:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.

Arseniy Krasnov (4):
  vsock: update SO_RCVLOWAT setting callback
  virtio/vsock: send credit update during setting SO_RCVLOWAT
  virtio/vsock: fix logic which reduces credit update messages
  vsock/test: two tests to check credit update logic

 drivers/vhost/vsock.c                   |   1 +
 include/linux/virtio_vsock.h            |   1 +
 include/net/af_vsock.h                  |   2 +-
 net/vmw_vsock/af_vsock.c                |   9 +-
 net/vmw_vsock/hyperv_transport.c        |   4 +-
 net/vmw_vsock/virtio_transport.c        |   1 +
 net/vmw_vsock/virtio_transport_common.c |  48 ++++++-
 net/vmw_vsock/vsock_loopback.c          |   1 +
 tools/testing/vsock/vsock_test.c        | 175 ++++++++++++++++++++++++
 9 files changed, 234 insertions(+), 8 deletions(-)

-- 
2.25.1


