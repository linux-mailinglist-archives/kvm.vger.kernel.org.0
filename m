Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0607873A5B9
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjFVQKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjFVQKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957C01FDC
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687450183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a4ZeA3fCzpsP/weTyEHljBjdeImnc1sztgg04Zvr3Iw=;
        b=I6x68a/2NsOrxF71F7lmOJoC7tQKUhbiu1sxsmGYl8QZAtjQkOofGQwa1HICAUzCSeTZR9
        5PCK6S2g7gKems03o/ESylTPNP7lWfChnCpVh+XIL5+PeZpzCXp1uSpJXSEknetwlsbeAl
        85awOw7H5qP4gfHKWKNASfOUDzlEMHc=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-vKLOraQTOXmQCaLx-xzgXg-1; Thu, 22 Jun 2023 12:09:30 -0400
X-MC-Unique: vKLOraQTOXmQCaLx-xzgXg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b46bfa6710so48136711fa.1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450156; x=1690042156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4ZeA3fCzpsP/weTyEHljBjdeImnc1sztgg04Zvr3Iw=;
        b=hfC2IXJfNV8BJFy1LTU6SQVRnzZKFPS9PvXt/X7pz8z3dKaM/naXmQ45rWquK3JE1A
         A+ASUco53tvoXo14Vd96kPxuJGSsUGlnp1NRgf2eFB3G13MkDP76wUMJ1cWCuu5WiOZP
         0MirNnRYFypoxODKV+qO8mB0OgDKthzBPMheQTzOuNnso9HCcjrTTb2W2BECSqUt5yg9
         I7oyESwe8dJ8zxP4z6VSZD1eI9aEPHuoNDlnsSiQa+9QY/1PxZU3/gsVx2KAkEQrAN/G
         Y9VXlQ3dLhqxKv10Ish5x2zy4BaJbdcLaWssLSzoa7kGzrGGCVVFV26xO37oaIXzZVS7
         V5aA==
X-Gm-Message-State: AC+VfDy+JgjP9vq67BtC1E+k4rt9Xlgj/VvG74qBsK1m9mfKygDWG4O7
        EJlT0AEyX9S/xa07iGrgloeG1YvI7Pc2oEIZ7BWFyvsEU0ZRUnjkvHj4yU6LDkSWPjSokZK9KwV
        1nn3yqa0ZobEA
X-Received: by 2002:a2e:9a8e:0:b0:2b5:8cfd:5236 with SMTP id p14-20020a2e9a8e000000b002b58cfd5236mr2267170lji.17.1687450155865;
        Thu, 22 Jun 2023 09:09:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6PUI9RE8kTcJcsGtpi7DjRk/Abacp0W+tVcBZjDh9XPq5tuQJut8wknojrAHXz03XIsMl3gQ==
X-Received: by 2002:a2e:9a8e:0:b0:2b5:8cfd:5236 with SMTP id p14-20020a2e9a8e000000b002b58cfd5236mr2267154lji.17.1687450155518;
        Thu, 22 Jun 2023 09:09:15 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id f13-20020a1709067f8d00b0098d2f91c850sm1026234ejr.89.2023.06.22.09.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 09:09:14 -0700 (PDT)
Date:   Thu, 22 Jun 2023 18:09:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 6/8] virtio/vsock: support dgrams
Message-ID: <ppx75eomyyb354knfkwbwin3il2ot7hf5cefwrt6ztpcbc3pps@q736cq5v4bdh>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-6-0cebbb2ae899@bytedance.com>
 <92b3a6df-ded3-6470-39d1-fe0939441abc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <92b3a6df-ded3-6470-39d1-fe0939441abc@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:49:02PM +0300, Arseniy Krasnov wrote:
>Hello Bobby!
>
>On 10.06.2023 03:58, Bobby Eshleman wrote:
>> This commit adds support for datagrams over virtio/vsock.
>>
>> Message boundaries are preserved on a per-skb and per-vq entry basis.
>
>I'm a little bit confused about the following case: let vhost sends 4097 bytes
>datagram to the guest. Guest uses 4096 RX buffers in it's virtio queue, each
>buffer has attached empty skb to it. Vhost places first 4096 bytes to the first
>buffer of guests RX queue, and 1 last byte to the second buffer. Now IIUC guest
>has two skb in it rx queue, and user in guest wants to read data - does it read
>4097 bytes, while guest has two skb - 4096 bytes and 1 bytes? In seqpacket there is
>special marker in header which shows where message ends, and how it works here?

I think the main difference is that DGRAM is not connection-oriented, so
we don't have a stream and we can't split the packet into 2 (maybe we
could, but we have no guarantee that the second one for example will be
not discarded because there is no space).

So I think it is acceptable as a restriction to keep it simple.

My only doubt is, should we make the RX buffer size configurable,
instead of always using 4k?

Thanks,
Stefano

