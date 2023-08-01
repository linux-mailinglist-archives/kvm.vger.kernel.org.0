Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E333D76B742
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbjHAOXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjHAOXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:23:33 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E360210FA;
        Tue,  1 Aug 2023 07:23:31 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 75D63120016;
        Tue,  1 Aug 2023 17:23:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 75D63120016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690899810;
        bh=Dhl5VAnaWylNbHoKrXzioSowOtsINKSs8oGEKA4Q7pI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=NcvrA8wpjg/MbNAyQwwpENo8S7bUvvQCVh+GezYVaOoQy2obioQ8d6B/ksIV6Wvn3
         r7EXKDHPEC7ypgbw4y1UVx+YjQycS2uwy2t9DeOuYkmo+djCbWVN0v2iP8ks/fd3Fw
         Al7LFCcTgscdqYAJx6oP8IZMgMa/K3MaLR83gl6pzgLzyxPEVl6+YZBHmCF3hvZKQW
         F6+xstEs+v+gH4BiqSBU9v1WdCE1EqojOP8Jh7Ys9XbCKgbx6d0FD11drTdqj1ZEKJ
         fh1wE26SF7wuT4houzipSd547/+yMTgRFdQt2L9cPMufYt005/AdYDoStSJ606Egnl
         7RoUppofJvR9g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue,  1 Aug 2023 17:23:30 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 1 Aug 2023 17:23:26 +0300
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 0/2] vsock: handle writes to shutdowned socket
Date:   Tue, 1 Aug 2023 17:17:25 +0300
Message-ID: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/07/23 10:45:00
X-KSMG-LinksScanning: Clean, bases: 2023/07/23 10:46:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9d0cd5d25f7d45bce01bbb3193b54ac24b3a60f3

Arseniy Krasnov (2):
  vsock: send SIGPIPE on write to shutdowned socket
  test/vsock: shutdowned socket test

 net/vmw_vsock/af_vsock.c         |   3 +
 tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

-- 
2.25.1

