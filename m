Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A2065E4DA
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 05:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjAEEv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 23:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjAEEvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 23:51:25 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6EC41D7B
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 20:51:24 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id n10-20020a6b590a000000b006e03471b3eeso10541684iob.11
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 20:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YZEILdTxalOjZrpjdXjI7ZuleQOS64DZ4zEKFOzr5o=;
        b=Z4/LpoVAQP+0ywBChkFijwb0gG2gnsBwsybogQJ/9RT2Iwha6DmxF5spYPsSEwMbhW
         +73oSsfdcJFKD5zuVQL0l79QwddsdKE0TtMNuX1+zyDuFQXtKi/v9VODmo35U90PV5ec
         HwRSAoZjiKxKM5siy0SZL0qDUcdKIWpuFdXLiicAZprYhy3HVVeVxpHtV6sRMa/zTxAR
         xTnDkCdqDnedjRBBLZtvOZxexeOUgR42iua8mTMhPLpyDoI6jAJC5qIS31TIe+QcEVUr
         HJw+/k3eNkmbquYUEV36y82gedA7yytC/D6gbaIed1K2KWFZwDRA3603ZB0fumEaxwUJ
         th7w==
X-Gm-Message-State: AFqh2kqJNDBoRa/QlBgIXWbxbStR/J9E5KhpO9VikSxcpMZgYVhASEWP
        nWnnImDbJ4GK1BHe/fF9GRVLlN/wz4p5bdojVkNk2xmM0nP9
X-Google-Smtp-Source: AMrXdXsA2/fwxzkS+chSk6tRfeEYR+OaBNLy0ars3ue5dz/qLr9krjaHhy3jiDZPpgMyhZYdMcDoisRGOSiheRStM51vm0f5jLCS
MIME-Version: 1.0
X-Received: by 2002:a5d:9758:0:b0:6e3:b9b:f145 with SMTP id
 c24-20020a5d9758000000b006e30b9bf145mr3841571ioo.117.1672894283916; Wed, 04
 Jan 2023 20:51:23 -0800 (PST)
Date:   Wed, 04 Jan 2023 20:51:23 -0800
In-Reply-To: <0000000000003a68dc05f164fd69@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a2d5305f17d0dbe@google.com>
Subject: Re: [syzbot] kernel BUG in vhost_vsock_handle_tx_kick
From:   syzbot <syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com>
To:     bobby.eshleman@bytedance.com, bobby.eshleman@gmail.com,
        bobbyeshleman@gmail.com, cong.wang@bytedance.com, deshantm@xen.org,
        jasowang@redhat.com, jiang.wang@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit b68396fad17ff7fae3bb5b594d703f7195caebb9
Author: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Thu Dec 15 04:36:44 2022 +0000

    virtio/vsock: replace virtio_vsock_pkt with sk_buff

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132ece3a480000
start commit:   c76083fac3ba Add linux-next specific files for 20221226
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10aece3a480000
console output: https://syzkaller.appspot.com/x/log.txt?x=172ece3a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c217c755f1884ab6
dashboard link: https://syzkaller.appspot.com/bug?extid=30b72abaa17c07fe39dd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fc414c480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1604b20a480000

Reported-by: syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com
Fixes: b68396fad17f ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
