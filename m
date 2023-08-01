Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7984776B6C6
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjHAOGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbjHAOGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACECB30F7
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690898704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrQZYdlPHfqAXUcA6lbzNx8CU3rrSsjWUivdGMgi/i8=;
        b=bHd1xAaxqMMi2JAJWjwGT7m7YowLoeeAp9GlwasloZmQhK/HDHqltjPRt8gm1ZTJ9P1wZE
        nqQyn5jNwonFQnvqPLNopxBw3sEC7Pyy/veAjArLm5IFpO2Rc4bzc8o4iGZMp8AAYq1SSi
        zYuQ0IRd9O5LNWXS1XJsvwUpXvztdG4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-dpqcY3ZROcmRzMQNsOLIiA-1; Tue, 01 Aug 2023 10:05:01 -0400
X-MC-Unique: dpqcY3ZROcmRzMQNsOLIiA-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-56ce4f82d18so209013eaf.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 07:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690898700; x=1691503500;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wrQZYdlPHfqAXUcA6lbzNx8CU3rrSsjWUivdGMgi/i8=;
        b=FOK/lS3O9R6T9e807rE8U+3+VpiFpRstOaQhFGs7x3DRRp6MiWWnBxxqQq3FP25ZEL
         TkWguXhDRm5Q25BVBRihe8qk/p7gMj6TyWLMmosnswwj76sLg/gBjwoM/BXWDLZp6s08
         AsDqTM5hMFQulLI7F6lrGgCvbSxiXXH+BPqjqBz9C2Lmc5VZcINxzp5V1VECCyvQd2eu
         hoXOlw3A3W+1CdwRxjiwwGe9ILqHLfRUHLQC35EA+akgsGPugS6FkF/0U5HT5Z+djrwT
         WzMtoIvALGD3fRPn680Wj2S9QY64nbTzyGXWjbXxkqpC3GvXfidHq6dGXbaLSos6HZb+
         Qjww==
X-Gm-Message-State: ABy/qLapORHhTBD34AnW+eTaiK5ShJy8ibiGMi5j+4tQiy+HHquxAb/s
        +xkOfOQ3xka246oHfLx5cIL05rcB55GwpHUbFhQMVIfRASa3nRsa3ABMBMV2fIy68csLEkYOhhZ
        Ci/5KNlqwI7DhzaA3/+JJ
X-Received: by 2002:a4a:a585:0:b0:56c:484a:923d with SMTP id d5-20020a4aa585000000b0056c484a923dmr7768037oom.1.1690898700127;
        Tue, 01 Aug 2023 07:05:00 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGkYK567OZvBBNHPM2ndAyrlc5sazvLUju3ozUYOY4HGl86ZO4bap40IQmhQfYLniD5hAHXvA==
X-Received: by 2002:a4a:a585:0:b0:56c:484a:923d with SMTP id d5-20020a4aa585000000b0056c484a923dmr7768012oom.1.1690898699795;
        Tue, 01 Aug 2023 07:04:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-251.dyn.eolo.it. [146.241.225.251])
        by smtp.gmail.com with ESMTPSA id o2-20020a0ce402000000b0063d14bfa5absm4658714qvl.36.2023.08.01.07.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 07:04:59 -0700 (PDT)
Message-ID: <00f2b7bdb18e0eaa42f0cca542a9530564615475.camel@redhat.com>
Subject: Re: [PATCH net-next v5 4/4] vsock/virtio: MSG_ZEROCOPY flag support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Date:   Tue, 01 Aug 2023 16:04:55 +0200
In-Reply-To: <1c9f9851-2228-c92b-ce3d-6a84d44e6628@sberdevices.ru>
References: <20230730085905.3420811-1-AVKrasnov@sberdevices.ru>
         <20230730085905.3420811-5-AVKrasnov@sberdevices.ru>
         <8a7772a50a16fbbcb82fc0c5e09f9e31f3427e3d.camel@redhat.com>
         <1c9f9851-2228-c92b-ce3d-6a84d44e6628@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-08-01 at 16:36 +0300, Arseniy Krasnov wrote:
>=20
> On 01.08.2023 16:34, Paolo Abeni wrote:
> > On Sun, 2023-07-30 at 11:59 +0300, Arseniy Krasnov wrote:
> > > +static int virtio_transport_fill_skb(struct sk_buff *skb,
> > > +				     struct virtio_vsock_pkt_info *info,
> > > +				     size_t len,
> > > +				     bool zcopy)
> > > +{
> > > +	if (zcopy) {
> > > +		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
> > > +					      &info->msg->msg_iter,
> > > +					      len);
> > > +	} else {
> >=20
> >=20
> > No need for an else statement after 'return'
> >=20
> > > +		void *payload;
> > > +		int err;
> > > +
> > > +		payload =3D skb_put(skb, len);
> > > +		err =3D memcpy_from_msg(payload, info->msg, len);
> > > +		if (err)
> > > +			return -1;
> > > +
> > > +		if (msg_data_left(info->msg))
> > > +			return 0;
> > > +
> >=20
> > This path does not update truesize, evem if it increases the skb len...
>=20
> Thanks, I'll fix it.
>=20
> >=20
> > > +		return 0;
> > > +	}
> > > +}
> >=20
> > [...]
> >=20
> > > @@ -214,6 +251,70 @@ static u16 virtio_transport_get_type(struct sock=
 *sk)
> > >  		return VIRTIO_VSOCK_TYPE_SEQPACKET;
> > >  }
> > > =20
> > > +static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock =
*vsk,
> > > +						  struct virtio_vsock_pkt_info *info,
> > > +						  size_t payload_len,
> > > +						  bool zcopy,
> > > +						  u32 src_cid,
> > > +						  u32 src_port,
> > > +						  u32 dst_cid,
> > > +						  u32 dst_port)
> > > +{
> > > +	struct sk_buff *skb;
> > > +	size_t skb_len;
> > > +
> > > +	skb_len =3D VIRTIO_VSOCK_SKB_HEADROOM;
> > > +
> > > +	if (!zcopy)
> > > +		skb_len +=3D payload_len;
> > > +
> > > +	skb =3D virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
> > > +	if (!skb)
> > > +		return NULL;
> > > +
> > > +	virtio_transport_init_hdr(skb, info, src_cid, src_port,
> > > +				  dst_cid, dst_port,
> > > +				  payload_len);
> > > +
> > > +	/* Set owner here, because '__zerocopy_sg_from_iter()' uses
> > > +	 * owner of skb without check to update 'sk_wmem_alloc'.
> > > +	 */
> > > +	if (vsk)
> > > +		skb_set_owner_w(skb, sk_vsock(vsk));
> >=20
> > ... which can lead to bad things(TM) if the skb goes trough some later
> > non trivial processing, due to the above skb_set_owner_w().
> >=20
> > Additionally can be the following condition be true:
> >=20
> > 	vsk =3D=3D NULL && (info->msg && payload_len > 0) && zcopy
> >=20
> > ???
>=20
> No, vsk =3D=3D NULL only when we reset connection, in that case both info=
->msg =3D=3D NULL and payload_len =3D=3D 0,
> as this is control message without any data.

Perhaps a comment with possibly even a WARN_ON_ONCE(!<the above>) could
help ;)

Thanks!

Paolo

