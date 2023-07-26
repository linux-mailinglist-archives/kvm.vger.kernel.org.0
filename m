Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9BD763E14
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjGZSCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjGZSCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:02:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F2A212F;
        Wed, 26 Jul 2023 11:02:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-666e97fcc60so103007b3a.3;
        Wed, 26 Jul 2023 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690394524; x=1690999324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aIbhbsFub5sfXuEeIKeiPG1VxDkvSU/NB7uNJB/xYPg=;
        b=DrV6694IMBwt1WrK1pQy1hgm+HWPPe96fKb/GfUFGcPRJH/c0H+Ta0qADBUQ1+VKr6
         N3CoJnhi/XDBPkLIj7Elv3xDtnbimzEqeNIHqrNe7SShVQ8gdoFORhuW4QU5yoWlohWG
         vc7+I3kQxGQ94eDe2W21QnURvDTYdagj/5NSkOBG7vmCNvkYbQ758cHkypKJwB4hZON+
         BlEUHXvz5nZq8wPinNs3hM6naxG3pfd8mDiDQUUCKwTrYslsjuED6Ad481jngfpx4fiZ
         1Yw71B+Ag58hITsHqzEMntMhuZVn1tqhm2EfGO2OkWvVbfx9MTi1p6l0hLJzx0FL03yY
         rs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690394524; x=1690999324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aIbhbsFub5sfXuEeIKeiPG1VxDkvSU/NB7uNJB/xYPg=;
        b=LkDtKwpH6TgSQFkAapz34p4UKKrT2gXSxGsV0hM+pb5r2nHchJejCz65t3h0GBYnAL
         ZdRQ3jeoyFh8PPx3YIX7z8jkarekrNqvGu8lbI7V/M6cz6rSfEmPJONfGgbPAR+O5ROP
         ANTRrFCjOHDkcFN9oXZ1oC8lqoRWKDK2ID7QWnkkNwx1sUTYidvHrEbVrocMkSz283ad
         Uq+FwQ9zqOqQ7htRWriyew1fzjWGU3OMeKv6NtO98GXgWZV0xJYTEu7ZOF9p+G0oVvAm
         qVnqSlOf1aUA/SqM7aZsnxaFrrrQQI+HYgOqyYJ+28rOVgF7VXtEqbQUyi2rr3D1bB4U
         /LoQ==
X-Gm-Message-State: ABy/qLY+X2tvBoxhdLb+zrnEwrcXefzIgxVRijaAT4fkNrGqwktrhNDg
        frMEvG2adZ/1IZOSNxgAJ9g=
X-Google-Smtp-Source: APBJJlEnwxO09eC1Sfit93AkJ1w5RlG81bOuS4b5whcmhpCdGcCBCSNeZtMp7vbrbsje/GxxH6RnGA==
X-Received: by 2002:a05:6a20:4b1b:b0:137:2f8c:fab0 with SMTP id fp27-20020a056a204b1b00b001372f8cfab0mr2408024pzb.49.1690394522585;
        Wed, 26 Jul 2023 11:02:02 -0700 (PDT)
Received: from localhost (c-73-190-126-111.hsd1.wa.comcast.net. [73.190.126.111])
        by smtp.gmail.com with ESMTPSA id i73-20020a636d4c000000b00553d42a7cb5sm592204pgc.68.2023.07.26.11.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:02:02 -0700 (PDT)
Date:   Wed, 26 Jul 2023 18:02:01 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v5 00/14] virtio/vsock: support datagrams
Message-ID: <ZMFfmcnF51PBnR+N@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Stale from v4 cover, sorry.

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

Also stale. After dropping the lockless sendpath patch and deferring it
to later, this data does not apply to the series anymore.

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
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
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
> 
