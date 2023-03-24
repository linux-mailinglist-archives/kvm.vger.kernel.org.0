Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65E16C7AC2
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjCXJHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCXJHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E831421B
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 02:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679648787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVH2oh9fpzLQkJXdwpUJ4533V1wJBPoDSclzcYbqRDs=;
        b=JcfmRJa7JAl5IOGs2Fi9/qCxnQQ19wBLpDhTmjjKU5JTespDVA6uTxkURoa2+8HWbmc+4x
        UhnF91etkOQqfB9UFp0awr9/BIlosexl1ChfIAqR1nAL/x594wG0KkgL8CtulEb0SIoifp
        MusLvpxQAtKIVpDurxRRwy5vE4ucgQY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-V1bdkfPVOjaybbaTRk6XjQ-1; Fri, 24 Mar 2023 05:06:25 -0400
X-MC-Unique: V1bdkfPVOjaybbaTRk6XjQ-1
Received: by mail-ed1-f69.google.com with SMTP id p36-20020a056402502400b004bb926a3d54so2277785eda.2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 02:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679648784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QVH2oh9fpzLQkJXdwpUJ4533V1wJBPoDSclzcYbqRDs=;
        b=fkI130vuJgaOviCIJznjbgBsN6AdFFsYWIbhxVNKPWRbO0Uu21VvXlYYI1Atik9fNJ
         jauOk1ZucYqXxN9qgbh/fatdlRoGc3HKMdoS1jP+AzyPVOlQKf5KCJFyM3Pydmzzovx0
         C0YQ0i8W8ZZ7efPzcwDP4Mbg1EQa8mppM15YCGDNkfTdMHX8s9nCNoOygw0QhvleKZRy
         jhykyz8ru6hDyztgpUEQa/QLYRTCT8tPN2uYaflICEkY6eMz8x6G4u/mcCuFYnxz5Px7
         VnQTan40PdrT83KqojEUdXPj3rXqVHiGBbg7UNWd04nGMecUaj3NQQn+IIKwGrQgYnMx
         kS/w==
X-Gm-Message-State: AAQBX9cGqVJgc2V+MxSeBSlkqNVJ2F376WempTmAVWsYvAoZiHiL0Gu6
        +SaWMyZxLzrnGzGM5ew6gIAH0rH7eTE1XUHCBHY96hn1+KsZRsGiiuvjoC1h7JNYsnT6aEhXyPa
        E/OU1j7AcAMYB
X-Received: by 2002:a17:906:fb08:b0:8b1:2d0e:281 with SMTP id lz8-20020a170906fb0800b008b12d0e0281mr2290896ejb.18.1679648784738;
        Fri, 24 Mar 2023 02:06:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bQ/0qtXsSzTfWFpJpLAd1O/C8EC/FjGUKHYcG4gtT7IHcXKxrUdWfr7rE+d1abTlAFPGEy4w==
X-Received: by 2002:a17:906:fb08:b0:8b1:2d0e:281 with SMTP id lz8-20020a170906fb0800b008b12d0e0281mr2290873ejb.18.1679648784448;
        Fri, 24 Mar 2023 02:06:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id g8-20020a1709061e0800b0093bd173baa6sm3300977ejj.202.2023.03.24.02.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 02:06:23 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:06:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 virtio_transport_purge_skbs
Message-ID: <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
References: <000000000000708b1005f79acf5c@google.com>
 <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
 <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 9:55 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Fri, Mar 24, 2023 at 9:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Hi Bobby,
> > can you take a look at this report?
> >
> > It seems related to the changes we made to support skbuff.
>
> Could it be a problem of concurrent access to pkt_queue ?
>
> IIUC we should hold pkt_queue.lock when we call skb_queue_splice_init()
> and remove pkt_list_lock. (or hold pkt_list_lock when calling
> virtio_transport_purge_skbs, but pkt_list_lock seems useless now that
> we use skbuff)
>

In the previous patch was missing a hunk, new one attached:

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git fff5a5e7f528

--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -15,7 +15,6 @@
 struct vsock_loopback {
        struct workqueue_struct *workqueue;

-       spinlock_t pkt_list_lock; /* protects pkt_list */
        struct sk_buff_head pkt_queue;
        struct work_struct pkt_work;
 };
@@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
        struct vsock_loopback *vsock = &the_vsock_loopback;
        int len = skb->len;

-       spin_lock_bh(&vsock->pkt_list_lock);
        skb_queue_tail(&vsock->pkt_queue, skb);
-       spin_unlock_bh(&vsock->pkt_list_lock);

        queue_work(vsock->workqueue, &vsock->pkt_work);

@@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)

        skb_queue_head_init(&pkts);

-       spin_lock_bh(&vsock->pkt_list_lock);
+       spin_lock_bh(&vsock->pkt_queue.lock);
        skb_queue_splice_init(&vsock->pkt_queue, &pkts);
-       spin_unlock_bh(&vsock->pkt_list_lock);
+       spin_unlock_bh(&vsock->pkt_queue.lock);

        while ((skb = __skb_dequeue(&pkts))) {
                virtio_transport_deliver_tap_pkt(skb);
@@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
        if (!vsock->workqueue)
                return -ENOMEM;

-       spin_lock_init(&vsock->pkt_list_lock);
        skb_queue_head_init(&vsock->pkt_queue);
        INIT_WORK(&vsock->pkt_work, vsock_loopback_work);

@@ -156,9 +152,7 @@ static void __exit vsock_loopback_exit(void)

        flush_work(&vsock->pkt_work);

-       spin_lock_bh(&vsock->pkt_list_lock);
        virtio_vsock_skb_queue_purge(&vsock->pkt_queue);
-       spin_unlock_bh(&vsock->pkt_list_lock);

        destroy_workqueue(vsock->workqueue);
 }

