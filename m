Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E621179BB02
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjIKUrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244413AbjIKU1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 16:27:32 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816011AB;
        Mon, 11 Sep 2023 13:27:25 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id F238C100008;
        Mon, 11 Sep 2023 23:27:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru F238C100008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694464041;
        bh=SHyvaS7qBOiIPWjV3UCTjmC069NWQH/OhcxthAchlvc=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=oxs9C1AKRMhjpTfJKktmMnkwRtd8xO1fRPlE8kKUe4FPI6gT1G3I8VepJ0R/S3gJW
         14Z4EyYMfG5f9Hx2i2DeuTF0ruL3QoVwD+FTBsqt4uaVzZqTibTBgjt9nGV107Rtjm
         mEmGgs5alSW8LfA8Bbd8Neu4vPmjAa2EH/qy9LfZ2+gms/w+wfhKsEqAGdyKs+vpJb
         +Yx0xy5dFjrwfbqZOEOpRgCS7sEwyUYgiH3mhPD7LLLg7ZY6BFneYC14O2b/X831nn
         CNuVwtR/JcvnvSnWP8rArP2KMMn8cseXlJNICT6q4/biowhPTQYWcQk7BKSTrVWU90
         /sAGP6NpByGFg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 11 Sep 2023 23:27:21 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 11 Sep 2023 23:27:21 +0300
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
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
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v2 0/2] vsock: handle writes to shutdowned socket
Date:   Mon, 11 Sep 2023 23:20:25 +0300
Message-ID: <20230911202027.1928574-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179791 [Sep 11 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;git.kernel.org:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;salutedevices.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/11 13:14:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/11 15:43:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/11 15:53:00 #21884588
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

this small patchset adds POSIX compliant behaviour on writes to the
socket which was shutdowned with 'shutdown()' (both sides - local with
SHUT_WR flag, peer - with SHUT_RD flag). According POSIX we must send
SIGPIPE in such cases (but SIGPIPE is not send when MSG_NOSIGNAL is set).

First patch is implemented in the same way as net/ipv4/tcp.c:tcp_sendmsg_locked().
It uses 'sk_stream_error()' function which handles EPIPE error. Another
way is to use code from net/unix/af_unix.c:unix_stream_sendmsg() where
same logic from 'sk_stream_error()' is implemented "from scratch", but
it doesn't check 'sk_err' field. I think error from this field has more
priority to be returned from syscall. So I guess it is better to reuse
currently implemented 'sk_stream_error()' function.

Test is also added.

Head for this patchset is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=73be7fb14e83d24383f840a22f24d3ed222ca319

Link to v1:
https://lore.kernel.org/netdev/20230801141727.481156-1-AVKrasnov@sberdevices.ru/
Link to v2 (RFC):
https://lore.kernel.org/netdev/20230826175900.3693844-1-avkrasnov@salutedevices.com/

Changelog:
v1 -> v2:
 * 0001 stills the same - SIGPIPE is sent only for SOCK_STREAM as discussed in v1
   with Stefano Garzarella <sgarzare@redhat.com>.
 * 0002 - use 'sig_atomic_t' instead of 'bool' for flag variables updated from
   signal handler.

Arseniy Krasnov (2):
  vsock: send SIGPIPE on write to shutdowned socket
  test/vsock: shutdowned socket test

 net/vmw_vsock/af_vsock.c         |   3 +
 tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

-- 
2.25.1

