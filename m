Return-Path: <kvm+bounces-2026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA007F0903
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 21:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0EF9B208B9
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 20:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C794B1A70B;
	Sun, 19 Nov 2023 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="HVcrHT2g"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E7115;
	Sun, 19 Nov 2023 12:57:20 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id EF9D5100008;
	Sun, 19 Nov 2023 23:57:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru EF9D5100008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700427437;
	bh=mRb/bYfuuaUieEXvIZ5BkaqWVB+4bPPbZGGcwyRzJOc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=HVcrHT2gVzVJiiVTc6DH3IbTrt1Y7+FlUWupXjLDiuqyz+FiUejLQ0COx0mm62CmK
	 OuUccqjSQ5hsraEiuxfWus3TQH14C7yD+0ORimzFfaulcqeaUlA4kDB2vLiltBphBG
	 uVSTYCKXmQB64X0SjmEMUIEFss0tgD47N+HlmbWsg3oikHbUxIkNy8jlZXO2HK2wMg
	 ym1u76Lt4ewjtrEwKVXmsSI0P463s+fzSPpg7z27BRmpPMcwsMKYQPP6tvX9rwpvnn
	 TfgYMXvJID/PleHLpVmoJCItEi/oKXS9fywAVMiHLixuT63XDFcONT4PoZPW2N2izc
	 XaqBh4r9aVhfg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sun, 19 Nov 2023 23:57:17 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 19 Nov 2023 23:57:17 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v2 0/3] send credit update during setting SO_RCVLOWAT
Date: Sun, 19 Nov 2023 23:49:19 +0300
Message-ID: <20231119204922.2251912-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181465 [Nov 19 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, git.kernel.org:7.1.1;salutedevices.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/11/19 19:47:00
X-KSMG-LinksScanning: Clean, bases: 2023/11/19 19:47:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/19 19:33:00 #22482963
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
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=18de1e517ed37ebaf33e771e46faf052e966e163

Link to v1:
https://lore.kernel.org/netdev/20231108072004.1045669-1-avkrasnov@salutedevices.com/

Changelog:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * New patch is added as 0001 - it removes return from SO_RCVLOWAT set
   callback in 'af_vsock.c' when transport callback is set - with that
   we can set 'sk_rcvlowat' only once in 'af_vsock.c' and in future do
   not copy-paste it to every transport. It was discussed in v1.
 * See per-patch changelog after ---.

Arseniy Krasnov (3):
  vsock: update SO_RCVLOWAT setting callback
  virtio/vsock: send credit update during setting SO_RCVLOWAT
  vsock/test: SO_RCVLOWAT + deferred credit update test

 drivers/vhost/vsock.c                   |   2 +
 include/linux/virtio_vsock.h            |   1 +
 net/vmw_vsock/af_vsock.c                |   9 +-
 net/vmw_vsock/virtio_transport.c        |   2 +
 net/vmw_vsock/virtio_transport_common.c |  28 +++++
 net/vmw_vsock/vsock_loopback.c          |   2 +
 tools/testing/vsock/vsock_test.c        | 136 ++++++++++++++++++++++++
 7 files changed, 178 insertions(+), 2 deletions(-)

-- 
2.25.1


