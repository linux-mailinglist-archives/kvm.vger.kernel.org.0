Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B529558C66A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 12:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiHHKab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 06:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242201AbiHHKa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 06:30:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EB46F5
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 03:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659954625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GcMiTNAh1hTDrL+vg0EvQccfaH3LEJ6CT3JlnBgaxfg=;
        b=BLkUmwaKYmG8yJH6FylkjKL1AMXJnmQNmnJcmKbaAz0Q9s5PNIOn3iZ4ysDtG3c/qoaQnf
        yrHL4hAMwBCGRCqRHGHjz47DjtRodX8Jcz8wUS1A3MLOC5FpnFJWvXt5KJqxJdtrHdBbai
        0k3gRzSOUnKWH9u59cM1F9zavS40r6Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-shmXtGQhOo2vRnA1i-GvrA-1; Mon, 08 Aug 2022 06:30:22 -0400
X-MC-Unique: shmXtGQhOo2vRnA1i-GvrA-1
Received: by mail-qk1-f199.google.com with SMTP id q20-20020a05620a0d9400b006b6540e8d79so7597875qkl.14
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 03:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GcMiTNAh1hTDrL+vg0EvQccfaH3LEJ6CT3JlnBgaxfg=;
        b=v/aK4EWZ3j5hvrJLQI/YKOXrea/vwkvdZMJtquw2iGRCj/DrRU+3yGL8gBfTQATcvq
         1ZiFB+z0w3luiJldI7hIqyBH5YvlnCJUsYZJfQe1dLO/I9CTVfiifV2AKfKZKc/KJIpK
         r5enKc/UDlsnkHSERwlkfVomcuv3qC4OMCZt43/rE+/Nae9SK8bXLvP8zS9YCd+VhWaH
         rbuv2ua3DM93MakPZevhKMPfPEbtsTIOuhfxwXg0Xf+tpYW2AIjZBTRIgVbrkrOtBoR1
         MrZZ+06Ub+OCBCII+ViqD1aGFmoiJoGZpkFNUbwqcKep9K0L5MQInPndJTNB/t5/f06a
         qudg==
X-Gm-Message-State: ACgBeo30Sx8aFuq0Vjt4P/iQrJ+1ImuU/Tk5sZssXHDr6SnOR315gR6e
        dUhdkGmCT6ZCxJBMdV1eVNZURFZBu+j6uILwV+9TtH4slwXefCt7jYhuCnmU3+RTNnun5oMBuU0
        y7APRFUrl2QBW
X-Received: by 2002:a37:2f03:0:b0:6b5:f8d9:7eab with SMTP id v3-20020a372f03000000b006b5f8d97eabmr13681292qkh.79.1659954622003;
        Mon, 08 Aug 2022 03:30:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4XGLj1VfcJFS+ebiNnab2ZLX5E3Tf208Zo5b4se2GNkoL41B1DWrzqhZGDT4lGv++JCSXVQA==
X-Received: by 2002:a37:2f03:0:b0:6b5:f8d9:7eab with SMTP id v3-20020a372f03000000b006b5f8d97eabmr13681272qkh.79.1659954621774;
        Mon, 08 Aug 2022 03:30:21 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id g6-20020ac80706000000b0034068f9d8fcsm7431142qth.20.2022.08.08.03.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:30:21 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:30:11 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Message-ID: <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
 <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 8, 2022 at 12:23 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Aug 03, 2022 at 01:51:05PM +0000, Arseniy Krasnov wrote:
> >This adds transport specific callback for SO_RCVLOWAT, because in some
> >transports it may be difficult to know current available number of bytes
> >ready to read. Thus, when SO_RCVLOWAT is set, transport may reject it.
> >
> >Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> >---
> > include/net/af_vsock.h   |  1 +
> > net/vmw_vsock/af_vsock.c | 25 +++++++++++++++++++++++++
> > 2 files changed, 26 insertions(+)
> >
> >diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >index f742e50207fb..eae5874bae35 100644
> >--- a/include/net/af_vsock.h
> >+++ b/include/net/af_vsock.h
> >@@ -134,6 +134,7 @@ struct vsock_transport {
> >       u64 (*stream_rcvhiwat)(struct vsock_sock *);
> >       bool (*stream_is_active)(struct vsock_sock *);
> >       bool (*stream_allow)(u32 cid, u32 port);
> >+      int (*set_rcvlowat)(struct vsock_sock *, int);
>
> checkpatch suggests to add identifier names. For some we put them in,
> for others we didn't, but I suggest putting them in for the new ones
> because I think it's clearer too.
>
> WARNING: function definition argument 'struct vsock_sock *' should also
> have an identifier name
> #25: FILE: include/net/af_vsock.h:137:
> +       int (*set_rcvlowat)(struct vsock_sock *, int);
>
> WARNING: function definition argument 'int' should also have an identifier name
> #25: FILE: include/net/af_vsock.h:137:
> +       int (*set_rcvlowat)(struct vsock_sock *, int);
>
> total: 0 errors, 2 warnings, 0 checks, 44 lines checked
>
> >
> >       /* SEQ_PACKET. */
> >       ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index f04abf662ec6..016ad5ff78b7 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -2129,6 +2129,30 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> >       return err;
> > }
> >
> >+static int vsock_set_rcvlowat(struct sock *sk, int val)
> >+{
> >+      const struct vsock_transport *transport;
> >+      struct vsock_sock *vsk;
> >+      int err = 0;
> >+
> >+      vsk = vsock_sk(sk);
> >+
> >+      if (val > vsk->buffer_size)
> >+              return -EINVAL;
> >+
> >+      transport = vsk->transport;
> >+
> >+      if (!transport)
> >+              return -EOPNOTSUPP;
>
> I don't know whether it is better in this case to write it in
> sk->sk_rcvlowat, maybe we can return EOPNOTSUPP only when the trasport
> is assigned and set_rcvlowat is not defined. This is because usually the
> options are set just after creation, when the transport is practically
> unassigned.
>
> I mean something like this:
>
>          if (transport) {
>                  if (transport->set_rcvlowat)
>                          return transport->set_rcvlowat(vsk, val);
>                  else
>                          return -EOPNOTSUPP;
>          }
>
>          WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>
>          return 0;

Since hv_sock implements `set_rcvlowat` to return EOPNOTSUPP. maybe we 
can just do the following:

        if (transport && transport->set_rcvlowat)
                return transport->set_rcvlowat(vsk, val);

        WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
        return 0;

That is, the default behavior is to set sk->sk_rcvlowat, but for 
transports that want a different behavior, they need to define 
set_rcvlowat() (like hv_sock).

Thanks,
Stefano

