Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18E36CBB5D
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjC1Jn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjC1Jnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:43:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DC25FCB
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679996569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UiP0xWp+0ly7XQn9tc22k14IwNm7IEcKiG/dCrMFCU0=;
        b=K8iX69XI7t5DR8a3H9PvLCzQQgR90XslFaXF6yV37lVZXCJIBKgW+/NU10Rp6OhCKRSoNY
        Ln30ydIxjoSAbOxV6ZWF6pPulH3vrrMGuOEQgK+lJLLtnw3oLoK3x6gvir9yAsqjiZ+Vsk
        FSRGeiwgXV+06cmaI/MdmAoKPrMvI+A=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-UuC0WxvfOYaOm8pMr6z1zg-1; Tue, 28 Mar 2023 05:42:47 -0400
X-MC-Unique: UuC0WxvfOYaOm8pMr6z1zg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5419fb7d6c7so113605127b3.11
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiP0xWp+0ly7XQn9tc22k14IwNm7IEcKiG/dCrMFCU0=;
        b=0Qcv4quFckAS46kLNyvetbyCqgIwSi3iptaoZl3PeIQ97ItfzPgZ+Cd6zuWBwF5Yzt
         ZDfpl8Da1gB/58nkwi9ieaUDlRRq9tZvk7Wa9A08KJ/u73OtG3klg0NgjJ2hIt4KsGkt
         GIae0YBhFuIE/2gYwMJvVRUKmtZQQpEV1I2uv+VA7iJqNnsQd5eGOxNMf+If12ll+elr
         NLRU+z0dIMUkiWb6uW4CkbM8uQfISsEG5KYZaIm4w00GtWaKUAGXsIjiZngQ6nXraHVB
         OvSbk8Sx7WDVoVxHpKwuaKCW+e6BgOaWjY4VEDfNEUa8ORSJQWFMVjcJzn2pVwCQhoqo
         caLw==
X-Gm-Message-State: AAQBX9cEpad89CWq+zgU+3pyQmcRd/KP1sGpd70je/aPnCKAAaF4nMIq
        /j9PZk0lvv7l02PPXjUPsR3HkUVWLkfZn+s933KclT+SVGDELe1A83rrI1oJWLYY5MhDbQpQNKH
        +p/k3MNbFTienv/uaNPX6DJyxw4Ai
X-Received: by 2002:a81:b620:0:b0:541:8995:5334 with SMTP id u32-20020a81b620000000b0054189955334mr6757329ywh.3.1679996566936;
        Tue, 28 Mar 2023 02:42:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zeh8QW1ALX/iyqmCjH97T20NkLc6M0pceeD5Mqt8dWP2CV889xu4EIMZ3VRQI/JNEAdxXJQ35UqcDiY6IhSR4=
X-Received: by 2002:a81:b620:0:b0:541:8995:5334 with SMTP id
 u32-20020a81b620000000b0054189955334mr6757315ywh.3.1679996566699; Tue, 28 Mar
 2023 02:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru> <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
In-Reply-To: <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Tue, 28 Mar 2023 11:42:35 +0200
Message-ID: <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to socket
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I pressed send too early...

CCing Bryan, Vishnu, and pv-drivers@vmware.com

On Tue, Mar 28, 2023 at 11:39=E2=80=AFAM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
> >This removes behaviour, where error code returned from any transport
> >was always switched to ENOMEM. This works in the same way as:
> >commit
> >c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
> >but for receive calls.
> >
> >Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> >---
> > net/vmw_vsock/af_vsock.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 19aea7cba26e..9262e0b77d47 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk,=
 struct msghdr *msg,
> >
> >               read =3D transport->stream_dequeue(vsk, msg, len - copied=
, flags);
>
> In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
> vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.
>
> Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
> those functions fail to keep the same behavior.
>
> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>
> The other transports seem okay to me.
>
> Thanks,
> Stefano
>
> >               if (read < 0) {
> >-                      err =3D -ENOMEM;
> >+                      err =3D read;
> >                       break;
> >               }
> >
> >@@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *=
sk, struct msghdr *msg,
> >       msg_len =3D transport->seqpacket_dequeue(vsk, msg, flags);
> >
> >       if (msg_len < 0) {
> >-              err =3D -ENOMEM;
> >+              err =3D msg_len;
> >               goto out;
> >       }
> >
> >--
> >2.25.1
> >

