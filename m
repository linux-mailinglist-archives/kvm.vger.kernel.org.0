Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7945A783B9B
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjHVIRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjHVIRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0863919B
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692692212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zckv6oFww2IAYABuKXRpSyWhyYXXDqhNviwTg2vLyFU=;
        b=LAdDYHbCSyJumHz74n6lmcXUHewrY3jdQRYVCOibCTR1eAIMux1+7mB0QnQCmQ2cERqFXL
        JUu6rQX481vA+q3xyyh3h+2p/cc/MD0BCEpu8ws84XAOaCCSzHjowglo8UxB9g/p4q4nix
        yg2QpEuFzmZAuEnrmMqYjnLc4mroqUg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-GphkhIyrOBuobWVJ2UyCAg-1; Tue, 22 Aug 2023 04:16:50 -0400
X-MC-Unique: GphkhIyrOBuobWVJ2UyCAg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5219df4e8c4so402943a12.1
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692692209; x=1693297009;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zckv6oFww2IAYABuKXRpSyWhyYXXDqhNviwTg2vLyFU=;
        b=XqK5+21OgH4cnEb/q8ux9ewioD4WoSevM+3daXQ2Mq4vEewnt3SjQUSL2mAJNOACF6
         mX8v9rq4wmUifNVYodtBM9Q5oGoOipeL5tddsmfIyz2OxXVjBrklmjsVmfqY33sjgBSH
         dU1fQfpj8OmYOUNGKwqIep9Cs8Md0A4LFfW0KLeD64YfaNprc8bicKx130YKft8LA4xi
         h5ivQ84/BUrOrjuoVhnVzb+wARsAOVsvLI9FfASHz4BtMMPsIwQt7xNtxXGAQGuc/vnH
         ilFXhEHAkxcoCLc/11buT02ekJ9oVUH4bWVpx3hTV4lB1XoLXyA6l5fkDmdvRR6LTb/O
         qajQ==
X-Gm-Message-State: AOJu0YxkbRISJP609D64nkxRKdudwl5xUnHx7VIYIivYE6lslx6Lhfff
        WIbXk4X58ExiIM2okBNQDncWYzljF3lGpAODLyETOGvOj31xVlrZQFfOhCebUWT9uShMcBXNhlk
        63gOGFtQznVry
X-Received: by 2002:a05:6402:268e:b0:523:2e64:122b with SMTP id w14-20020a056402268e00b005232e64122bmr6755156edd.3.1692692209654;
        Tue, 22 Aug 2023 01:16:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLSFMBKhUwaZNzwUhuDk7yvXSZjSgwouQMRlutTKOK/6Gw8nbnhQGL5h8TQ+NkO3C5To+oqw==
X-Received: by 2002:a05:6402:268e:b0:523:2e64:122b with SMTP id w14-20020a056402268e00b005232e64122bmr6755152edd.3.1692692209318;
        Tue, 22 Aug 2023 01:16:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-241-4.dyn.eolo.it. [146.241.241.4])
        by smtp.gmail.com with ESMTPSA id m4-20020aa7c484000000b0052328d4268asm7109439edq.81.2023.08.22.01.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 01:16:48 -0700 (PDT)
Message-ID: <85ff931ea180e19ae3df83367cf1e7cac99fa0d8.camel@redhat.com>
Subject: Re: [PATCH net-next v6 2/4] vsock/virtio: support to send
 non-linear skb
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
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
Date:   Tue, 22 Aug 2023 10:16:47 +0200
In-Reply-To: <20230814212720.3679058-3-AVKrasnov@sberdevices.ru>
References: <20230814212720.3679058-1-AVKrasnov@sberdevices.ru>
         <20230814212720.3679058-3-AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm sorry for the long delay here. I was OoO in the past few weeks.

On Tue, 2023-08-15 at 00:27 +0300, Arseniy Krasnov wrote:
> For non-linear skb use its pages from fragment array as buffers in
> virtio tx queue. These pages are already pinned by 'get_user_pages()'
> during such skb creation.
>=20
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  Changelog:
>  v2 -> v3:
>   * Comment about 'page_to_virt()' is updated. I don't remove R-b,
>     as this change is quiet small I guess.
>=20
>  net/vmw_vsock/virtio_transport.c | 41 +++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index e95df847176b..7bbcc8093e51 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
>  	vq =3D vsock->vqs[VSOCK_VQ_TX];
> =20
>  	for (;;) {
> -		struct scatterlist hdr, buf, *sgs[2];
> +		/* +1 is for packet header. */
> +		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
> +		struct scatterlist bufs[MAX_SKB_FRAGS + 1];

Note that MAX_SKB_FRAGS depends on a config knob (CONFIG_MAX_SKB_FRAGS)
and valid/reasonable values are up to 45. The total stack usage can be
pretty large (~700 bytes).

As this is under the vsk tx lock, have you considered moving such data
in the virtio_vsock struct?

>  		int ret, in_sg =3D 0, out_sg =3D 0;
>  		struct sk_buff *skb;
>  		bool reply;
> @@ -111,12 +113,39 @@ virtio_transport_send_pkt_work(struct work_struct *=
work)
> =20
>  		virtio_transport_deliver_tap_pkt(skb);
>  		reply =3D virtio_vsock_skb_reply(skb);
> +		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
> +			    sizeof(*virtio_vsock_hdr(skb)));
> +		sgs[out_sg] =3D &bufs[out_sg];
> +		out_sg++;
> +
> +		if (!skb_is_nonlinear(skb)) {
> +			if (skb->len > 0) {
> +				sg_init_one(&bufs[out_sg], skb->data, skb->len);
> +				sgs[out_sg] =3D &bufs[out_sg];
> +				out_sg++;
> +			}
> +		} else {
> +			struct skb_shared_info *si;
> +			int i;
> +
> +			si =3D skb_shinfo(skb);

This assumes that the paged skb does not carry any actual data in the
head buffer (only the header). Is that constraint enforced somewhere
else? Otherwise a

	WARN_ON_ONCE(skb_headlen(skb) > sizeof(*virtio_vsock_hdr(skb))

could be helpful to catch early possible bugs.

Thanks!

Paolo

> +
> +			for (i =3D 0; i < si->nr_frags; i++) {
> +				skb_frag_t *skb_frag =3D &si->frags[i];
> +				void *va;
> =20
> -		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)=
));
> -		sgs[out_sg++] =3D &hdr;
> -		if (skb->len > 0) {
> -			sg_init_one(&buf, skb->data, skb->len);
> -			sgs[out_sg++] =3D &buf;
> +				/* We will use 'page_to_virt()' for the userspace page
> +				 * here, because virtio or dma-mapping layers will call
> +				 * 'virt_to_phys()' later to fill the buffer descriptor.
> +				 * We don't touch memory at "virtual" address of this page.
> +				 */
> +				va =3D page_to_virt(skb_frag->bv_page);
> +				sg_init_one(&bufs[out_sg],
> +					    va + skb_frag->bv_offset,
> +					    skb_frag->bv_len);
> +				sgs[out_sg] =3D &bufs[out_sg];
> +				out_sg++;
> +			}
>  		}
> =20
>  		ret =3D virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);

