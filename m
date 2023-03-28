Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9766CB8DA
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjC1H6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 03:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjC1H6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 03:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE891BC
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679990287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zX64wamSvcuBg/+n8EW5C/QE8JCYba2x9NZLoF8LKOI=;
        b=QructXApXTiSuLD9AMSFAiTXvHMzTX7Piz/Io9gUT2Y0O7H0LDUKMKV6LQjk8wHa/LbZZC
        VmSK4Jzq5rOAMv2pnDBHHCtp7ELseboumrDmc6Bwn4K3/OyNH+UVp3yWtcns4yQEw0XjXK
        h5C9BUiNHZM4LWyx/UqeaE2IFCtmQ4g=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-YxZ9bdUgMxeKIPjw6MIV5w-1; Tue, 28 Mar 2023 03:58:06 -0400
X-MC-Unique: YxZ9bdUgMxeKIPjw6MIV5w-1
Received: by mail-qv1-f71.google.com with SMTP id dg8-20020a056214084800b005acc280bf19so4684465qvb.22
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679990285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zX64wamSvcuBg/+n8EW5C/QE8JCYba2x9NZLoF8LKOI=;
        b=DkCV2YCaZk97J0+Zrd0E72nFjArvk8N0v5EJg0ywizXniQpl/x+DUi8rjnH09Y3WML
         r2ShMB7S5w8x+QI8H00ZlHcE6HX4YZbiaPhBO3C0PrjaQEBeL+M75IAt4h7rbKPy9ZlU
         BdHBNsxpHHkcIqAQcQQhZwJ8ddrCOs4TcCoBvEmIpaTZGQam8G196oIrelvVzjmJsw2t
         Wmrzd80duZKDIspJCavNccoQU6rw0jwMLfsZ+/2HU8usIp+hUoyiFM/1OGeL/32yBTVP
         2V/SXYrkRF64lBiaPy7s559IWl2YaHdQUx2lShPH7vLsIskLYT28tBhhTnHwwNE0+fez
         8PnA==
X-Gm-Message-State: AO0yUKVscpxH+jCOzG2YC+SHG4YqkFLvKcQz1C/0hZtP+Nq6zxTLmdba
        p5HpywEPlana7b0Ifay7ptPD3X+oiARzG58xe0jEegL17+IUw79/I3MdjNX2fVXEYSeMAOQjtFz
        bsWCkjKmVJhep
X-Received: by 2002:ac8:584e:0:b0:3d3:95fd:9085 with SMTP id h14-20020ac8584e000000b003d395fd9085mr25956583qth.42.1679990285643;
        Tue, 28 Mar 2023 00:58:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350a8LN3HbXJ4yvKz19Oadd4R8pyBHJFdmxnmtbIae9l3nU8wgRH2HBkaFmqmIFsJT4IA1NyyBw==
X-Received: by 2002:ac8:584e:0:b0:3d3:95fd:9085 with SMTP id h14-20020ac8584e000000b003d395fd9085mr25956565qth.42.1679990285424;
        Tue, 28 Mar 2023 00:58:05 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id h20-20020ac85154000000b003e4e1dbdcc3sm2122686qtn.47.2023.03.28.00.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:58:05 -0700 (PDT)
Date:   Tue, 28 Mar 2023 09:58:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net] virtio/vsock: fix leak due to missing skb owner
Message-ID: <jinx5oduhddyyaxnreey2riem3s7ju5zuszddmoiie6dcnyiiy@fr4cg33vi7aq>
References: <20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 10:01:05PM +0000, Bobby Eshleman wrote:
>This patch sets the owner for the skb when being sent from a socket and
>so solves the leak caused when virtio_transport_purge_skbs() finds
>skb->sk is always NULL and therefore never matches it with the current
>socket. Setting the owner upon allocation fixes this.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
>Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
>---
> net/vmw_vsock/virtio_transport_common.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 957cdc01c8e8..2a2f0c1a9fbd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 					 info->op,
> 					 info->flags);
>
>+	if (info->vsk)
>+		skb_set_owner_w(skb, sk_vsock(info->vsk));
>+

Should we do the same also in virtio_transport_recv_pkt()?

The skb in that cases is allocated in drivers/vhost/vsock.c and
net/vmw_vsock/virtio_transport.c using directly
virtio_vsock_alloc_skb(), because we don't know in advance which socket
it belongs to.

Then in virtio_transport_recv_pkt() we look for the socket and queue it
up. This should also solve the problem in vsock_loopback.c where we move
skb from one socket to another.

Thanks,
Stefano

