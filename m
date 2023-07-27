Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C126B764997
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjG0H5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjG0H4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:56:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF6A6587
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690444311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XGdpEGuVFC1LjQhQ41rFzUdSqbCmVBU7DHNo6fBlyec=;
        b=ATVHCB++qcp2V+/zfDln5AkCugWA9QkBq2+bwBDnXpjubLWzkx6FCjYpngx3uGEfWC32ja
        Nb4y+NTinsldxCBlhyMYjmbjQN2MziR6hXTVksQz/KqgPW+6RUdUCxVPW89xhdWIMEnifF
        fEos6H9sEL7a3SX+0wjkvJdXP6csnKM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-m7K3jSMJNzaK3POzg9ydGg-1; Thu, 27 Jul 2023 03:51:49 -0400
X-MC-Unique: m7K3jSMJNzaK3POzg9ydGg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5226eaba9e9so372616a12.2
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690444308; x=1691049108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGdpEGuVFC1LjQhQ41rFzUdSqbCmVBU7DHNo6fBlyec=;
        b=Smyru+AhEYaePW7vcNgf8QTIl6gSR4VpTSHaegCb7ibFB5vU066++cDRin4scqHJho
         SiTK7rdJp3+2LdrvA2QWuDJs5SffsKqXEFqFDLKbHJFMQlIfrZpovPpVfmONkB6sVgF/
         ZbkUUdVgn+UKDOotM+MoLc4coaHs8Ll1LW3PoxKJUUZK2lRq12x6guRGbCbxzeMMH+gy
         9P2uG+XC4wKOHH7y1R0ifQV5vBkRxSgTfqqYB/nZUO2YZ90UDbXkpMb9wk4F5rszm5J1
         G9GBArBl9Ndg4r2uds7LE1aDqxnsJ2T5HMVPHOyNubrizBN7USgetYrifOTIdNT1AemA
         MspQ==
X-Gm-Message-State: ABy/qLZu878+eeRCeyPYUpUSmxAdTSdNgZJUW2MTl2YHWVFm53YIM+pB
        5rOGVoy2jjXLmERncxMVaxmkRGHXpmnivFSnwDpOYALeAIGTiCbeVHtGBiUQzVMURjWEilq2B6V
        ZOQWiLwxPvLVt
X-Received: by 2002:aa7:c24c:0:b0:51e:1c18:dd99 with SMTP id y12-20020aa7c24c000000b0051e1c18dd99mr1107600edo.38.1690444308769;
        Thu, 27 Jul 2023 00:51:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGKXV0ynY8e7V/b42V/35k2Q/0im3idioITFwhBKCnXqViZp+dS2Co3Ki/5u7d7K9vB+MC7cQ==
X-Received: by 2002:aa7:c24c:0:b0:51e:1c18:dd99 with SMTP id y12-20020aa7c24c000000b0051e1c18dd99mr1107573edo.38.1690444308402;
        Thu, 27 Jul 2023 00:51:48 -0700 (PDT)
Received: from redhat.com ([2.52.14.22])
        by smtp.gmail.com with ESMTPSA id l5-20020aa7d945000000b005223e54d1edsm336234eds.20.2023.07.27.00.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:51:47 -0700 (PDT)
Date:   Thu, 27 Jul 2023 03:51:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v5 00/14] virtio/vsock: support datagrams
Message-ID: <20230727035004-mutt-send-email-mst@kernel.org>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
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

On Wed, Jul 19, 2023 at 12:50:04AM +0000, Bobby Eshleman wrote:
> Hey all!
> 
> This series introduces support for datagrams to virtio/vsock.
> 
> It is a spin-off (and smaller version) of this series from the summer:
>   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> 
> Please note that this is an RFC and should not be merged until
> associated changes are made to the virtio specification, which will
> follow after discussion from this series.
> 
> Another aside, the v4 of the series has only been mildly tested with a
> run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
> up, but I'm hoping to get some of the design choices agreed upon before
> spending too much time making it pretty.
> 
> This series first supports datagrams in a basic form for virtio, and
> then optimizes the sendpath for all datagram transports.
> 
> The result is a very fast datagram communication protocol that
> outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> of multi-threaded workload samples.
> 
> For those that are curious, some summary data comparing UDP and VSOCK
> DGRAM (N=5):
> 
> 	vCPUS: 16
> 	virtio-net queues: 16
> 	payload size: 4KB
> 	Setup: bare metal + vm (non-nested)
> 
> 	UDP: 287.59 MB/s
> 	VSOCK DGRAM: 509.2 MB/s
> 
> Some notes about the implementation...
> 
> This datagram implementation forces datagrams to self-throttle according
> to the threshold set by sk_sndbuf. It behaves similar to the credits
> used by streams in its effect on throughput and memory consumption, but
> it is not influenced by the receiving socket as credits are.
> 
> The device drops packets silently.
> 
> As discussed previously, this series introduces datagrams and defers
> fairness to future work. See discussion in v2 for more context around
> datagrams, fairness, and this implementation.

it's a big thread - can't you summarize here?


> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>


could you give a bit more motivation? which applications do
you have in mind? for example, on localhost loopback datagrams
are actually reliable and a bunch of apps came to depend
on that even if they shouldn't.



> ---
> Changes in v5:
> - teach vhost to drop dgram when a datagram exceeds the receive buffer
>   - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
> 	"vsock: read from socket's error queue"
> - replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
>   callback
> - refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
> - add _fallback/_FALLBACK suffix to dgram transport variables/macros
> - add WARN_ONCE() for table_size / VSOCK_HASH issue
> - add static to vsock_find_bound_socket_common
> - dedupe code in vsock_dgram_sendmsg() using module_got var
> - drop concurrent sendmsg() for dgram and defer to future series
> - Add more tests
>   - test EHOSTUNREACH in errqueue
>   - test stream + dgram address collision
> - improve clarity of dgram msg bounds test code
> - Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com
> 
> Changes in v4:
> - style changes
>   - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
>     &sk->vsk
>   - vsock: fix xmas tree declaration
>   - vsock: fix spacing issues
>   - virtio/vsock: virtio_transport_recv_dgram returns void because err
>     unused
> - sparse analysis warnings/errors
>   - virtio/vsock: fix unitialized skerr on destroy
>   - virtio/vsock: fix uninitialized err var on goto out
>   - vsock: fix declarations that need static
>   - vsock: fix __rcu annotation order
> - bugs
>   - vsock: fix null ptr in remote_info code
>   - vsock/dgram: make transport_dgram a fallback instead of first
>     priority
>   - vsock: remove redundant rcu read lock acquire in getname()
> - tests
>   - add more tests (message bounds and more)
>   - add vsock_dgram_bind() helper
>   - add vsock_dgram_connect() helper
> 
> Changes in v3:
> - Support multi-transport dgram, changing logic in connect/bind
>   to support VMCI case
> - Support per-pkt transport lookup for sendto() case
> - Fix dgram_allow() implementation
> - Fix dgram feature bit number (now it is 3)
> - Fix binding so dgram and connectible (cid,port) spaces are
>   non-overlapping
> - RCU protect transport ptr so connect() calls never leave
>   a lockless read of the transport and remote_addr are always
>   in sync
> - Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com
> 
> ---
> Bobby Eshleman (13):
>       af_vsock: generalize vsock_dgram_recvmsg() to all transports
>       af_vsock: refactor transport lookup code
>       af_vsock: support multi-transport datagrams
>       af_vsock: generalize bind table functions
>       af_vsock: use a separate dgram bind table
>       virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
>       virtio/vsock: add common datagram send path
>       af_vsock: add vsock_find_bound_dgram_socket()
>       virtio/vsock: add common datagram recv path
>       virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>       vhost/vsock: implement datagram support
>       vsock/loopback: implement datagram support
>       virtio/vsock: implement datagram support
> 
> Jiang Wang (1):
>       test/vsock: add vsock dgram tests
> 
>  drivers/vhost/vsock.c                   |  64 ++-
>  include/linux/virtio_vsock.h            |  10 +-
>  include/net/af_vsock.h                  |  14 +-
>  include/uapi/linux/virtio_vsock.h       |   2 +
>  net/vmw_vsock/af_vsock.c                | 281 ++++++++++---
>  net/vmw_vsock/hyperv_transport.c        |  13 -
>  net/vmw_vsock/virtio_transport.c        |  26 +-
>  net/vmw_vsock/virtio_transport_common.c | 190 +++++++--
>  net/vmw_vsock/vmci_transport.c          |  60 +--
>  net/vmw_vsock/vsock_loopback.c          |  10 +-
>  tools/testing/vsock/util.c              | 141 ++++++-
>  tools/testing/vsock/util.h              |   6 +
>  tools/testing/vsock/vsock_test.c        | 680 ++++++++++++++++++++++++++++++++
>  13 files changed, 1320 insertions(+), 177 deletions(-)
> ---
> base-commit: 37cadc266ebdc7e3531111c2b3304fa01b2131e8
> change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5
> 
> Best regards,
> -- 
> Bobby Eshleman <bobby.eshleman@bytedance.com>

