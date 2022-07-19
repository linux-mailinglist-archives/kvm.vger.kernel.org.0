Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D6D579FED
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiGSNqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbiGSNqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B1797756C
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GpFb8vkFvojqhTGDZMr57afoE9WFfoScp9OlFzV0WwU=;
        b=KoviKoKgRTiX00hSfAdtlEgVSm0jtU3sWrbWiZ7M1j0PAEntMrNKyrGFjuxdLfJWjMC+yc
        ELJhUEK2fuWm/g9wBFiKVbBoUvu194mKe8ozquSAy99I7dHzuMt3QaVUTmyNMkOeCM6EVX
        Op1Fz9bltwbwSWyfa9AR78u6oa5vrUw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-Ah1_yf99N_GXi_vBH0ey3g-1; Tue, 19 Jul 2022 08:59:06 -0400
X-MC-Unique: Ah1_yf99N_GXi_vBH0ey3g-1
Received: by mail-qk1-f200.google.com with SMTP id de4-20020a05620a370400b006a9711bd9f8so11626082qkb.9
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GpFb8vkFvojqhTGDZMr57afoE9WFfoScp9OlFzV0WwU=;
        b=qyboHNuIY5oirLg4uSeAkbioDB01vpks0PxkRZB/Z85iJUaDOjJFKc85VdRh5Afbd3
         XXdPInwe0JlWrc1+C/mOZAzV+mqYNw+ssuLZhAKfXWgTEkBhKyblH0ay1HzyB9NLBuks
         /MLSl5h1L2YKW1G29D4f/7ArOPhbef3kzoDzE2gFMrYn+8u8cdD1B+vrYoLnO7WT02Yk
         9ZsRs1rVxfc7bxBe9zR4ZFQAVNCzPZlhxs1/2RbJSwUqwO1Qw9SmvX4wZKG7ifEpHcXv
         ALCAzbwnNahchKRuJUJWOl+tyUMvmznJ4TU0bPEgUixRP95HMQNswGP6Exh87iAJjzUn
         zLKA==
X-Gm-Message-State: AJIora9sH7n+z1twX+WPrVV6nuLx8VRo8pWV0/oRpFTGHMLnsBVns/6N
        YnclZ8ciE9hQROQ+4GGe1wNuJv/O54RqGO70Kndpjp5GTmZvrk7HhZ7O5OP4pOVuQkVIG9KAlM9
        BcJ3LvKxu6rku
X-Received: by 2002:a37:bb06:0:b0:6af:1396:733a with SMTP id l6-20020a37bb06000000b006af1396733amr20076304qkf.19.1658235545578;
        Tue, 19 Jul 2022 05:59:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v3rTh6rpiRFqOJRQK0ZLJtgg3flVdhc61hiFQaT3lCYarTqS5U4ciXv6GiDuKhdb9qoBSiNg==
X-Received: by 2002:a37:bb06:0:b0:6af:1396:733a with SMTP id l6-20020a37bb06000000b006af1396733amr20076290qkf.19.1658235545356;
        Tue, 19 Jul 2022 05:59:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id bk8-20020a05620a1a0800b006b5fe4c333fsm1422065qkb.85.2022.07.19.05.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:59:04 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:58:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Message-ID: <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 08:12:52AM +0000, Arseniy Krasnov wrote:
>Hello,
>
>during my experiments with zerocopy receive, i found, that in some
>cases, poll() implementation violates POSIX: when socket has non-
>default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>POLLRDNORM bits in 'revents' even number of bytes available to read
>on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>POLLIN flag and then tries to read data(for example using  'read()'
>call), but read call will be blocked, because  SO_RCVLOWAT logic is
>supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>requires that:
>
>"POLLIN     Data other than high-priority data may be read without
>            blocking.
> POLLRDNORM Normal data may be read without blocking."
>
>See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>
>So, we have, that poll() syscall returns POLLIN, but read call will
>be blocked.
>
>Also in man page socket(7) i found that:
>
>"Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>socket as readable only if at least SO_RCVLOWAT bytes are available."
>
>I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>this case for TCP socket, it works as POSIX required.

I tried to look at the code and it seems that only TCP complies with it 
or am I wrong?

>
>I've added some fixes to af_vsock.c and virtio_transport_common.c,
>test is also implemented.
>
>What do You think guys?

Nice, thanks for fixing this and for the test!

I left some comments, but I think the series is fine if we will support 
it in all transports.

I'd just like to understand if it's just TCP complying with it or I'm 
missing some check included in the socket layer that we could reuse.

@David, @Jakub, @Paolo, any advice?

Thanks,
Stefano

