Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75D46ABF31
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 13:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCFMKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 07:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjCFMKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 07:10:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB326853
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 04:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678104544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TIQWpkWpesX3O84a09lrsGwpESW6OyZggcHe4WwruKk=;
        b=BVDD2wDw+ug8OqPhdC4Fp38rFFxz0yugJBWxYCDGIHPT7KqLeq87sRG602WMAP94u+WXiX
        ujAtCP4lcQ4K/we09I6A6RzvLSZApcBc9iWzD4PeG25n2i2kGSod6r1YBAfGVxQ8UOpCsD
        JwURtalcA0y8ccYPPZR05rgdBOpsVfw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-cRJ1ic7JOtGieVMvd3SZkQ-1; Mon, 06 Mar 2023 07:09:01 -0500
X-MC-Unique: cRJ1ic7JOtGieVMvd3SZkQ-1
Received: by mail-wm1-f71.google.com with SMTP id k26-20020a05600c0b5a00b003dfe4bae099so3680943wmr.0
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 04:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIQWpkWpesX3O84a09lrsGwpESW6OyZggcHe4WwruKk=;
        b=JtLTB0hbHCPgu42QsB1y5tmHEYaNuBccflvNg5A1VuqC0Qdqq79C5NAfa/gLWtquN0
         vIIte3u4NsTYjpzmGSU5OllGhaYMGHW0MDgmGtZFZj1YKo8GYixVkjLziCeidd8KP5Nr
         W1JqKDtRs529z8aANa4/D0qArs2eThxgzIw1ypyf9AVEm750hbjafQXoVRxBJce4Dtvs
         lvRG9Einmw5zQmtMEE0KuS0BhpopvORXgTU2ihJm9+pA7mnRoJlMFcrDYlVuKmYXZ70p
         cL0KWn6aefqsMaFdOzPdC/AAL32YT4Ah1Bu3Y0WtqPmFgdLpxOAu4ciWzKEpx2RAHBL/
         FQDQ==
X-Gm-Message-State: AO0yUKW7dlr1XRJerR132vH73V/o69qsgTT2NBNCUpJR3Y/0n/Bqbxdh
        ye8369iLHeghPiLdizTz5XMe9gXj6tK/FR7gX6QJa+n40/6+aZbE/j+vC83Oj55KFVjp6IHv/vp
        qT3b3cjOCCKzO
X-Received: by 2002:a05:6000:10cc:b0:2c7:420:5d52 with SMTP id b12-20020a05600010cc00b002c704205d52mr6551206wrx.62.1678104540677;
        Mon, 06 Mar 2023 04:09:00 -0800 (PST)
X-Google-Smtp-Source: AK7set9mVWEN2OAq/N1LHfsMLygbhdAAUyaT4XAYy96wMKTIdzRA5IDlfgb0poIN+cI9N1MTK/FGlw==
X-Received: by 2002:a05:6000:10cc:b0:2c7:420:5d52 with SMTP id b12-20020a05600010cc00b002c704205d52mr6551188wrx.62.1678104540406;
        Mon, 06 Mar 2023 04:09:00 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id c18-20020a5d4cd2000000b002c551f7d452sm9957713wrt.98.2023.03.06.04.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:08:59 -0800 (PST)
Date:   Mon, 6 Mar 2023 13:08:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
Message-ID: <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
>In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>data from it, it will be removed, so user will never read rest of the
>data. Thus we need to update credit parameters of the socket like whole
>sk_buff is read - so call 'skb_pull()' for the whole buffer.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Maybe we could avoid this patch if we directly use pkt_len as I
suggested in the previous patch.

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 2e2a773df5c1..30b0539990ba 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -466,7 +466,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 					dequeued_len = err;
> 				} else {
> 					user_buf_len -= bytes_to_copy;
>-					skb_pull(skb, bytes_to_copy);
> 				}
>
> 				spin_lock_bh(&vvs->rx_lock);
>@@ -484,6 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				msg->msg_flags |= MSG_EOR;
> 		}
>
>+		skb_pull(skb, skb->len);
> 		virtio_transport_dec_rx_pkt(vvs, skb);
> 		kfree_skb(skb);
> 	}
>-- 
>2.25.1
>

