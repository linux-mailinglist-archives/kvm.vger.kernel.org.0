Return-Path: <kvm+bounces-22116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E2793A2E6
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 16:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD5F6284BEB
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 14:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FFB14BF86;
	Tue, 23 Jul 2024 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJF6YH6l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE88154455
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721745531; cv=none; b=S53RHKRNgN7PIeQd9JBT/OpaA039IzTIsuBvOyIJkkpVHX47okkSj8SnF88SmMReGGVVRTqmrfd3hhH+RugYkd/ugEQriw6TkwOk8QCfhW6ibnzDy0cB5I1I5DFlnOmmAiEG0hu8iu4W5JA02kbqNC/Mj5j4q9eWSZWWA2vjWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721745531; c=relaxed/simple;
	bh=FWZ7L31FilGlYNAsUr06+iq7uJW1afQnO+E9VdJEghI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T8eJMQB2G/1AZJMyO9Apy3+7BNQz4xbWJo1Q0eyYgAMVpM3p/MdrRwmMhAC6O0HpZiy/Qetj2u7jrlk69s6dHGEWbQusa8pbV33QFRvWUdH2CXHS2/hB1NV+VaUcwN2Bh5lnW6p5mpPHDewkQg8Z4DRShP34XDRy+LPaQKql/8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TJF6YH6l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721745526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8D9zZcUE0U3hHmqSilSWN7yBwFstQGaORKtcOXi3Go=;
	b=TJF6YH6lN3yWtHRpC+buyoG3ZvRoLAQxayams8Oh/xwbndEdikmoJfuzMrkLRFXkMjfVDB
	6UZvwk2mNUcumASL3Cz/gIrbpN81LL14ZfIItLRh0cP7h4hF4TdekUJTFfh1GZJ08aWlrR
	PcsQcenCs6Qwq8cXkwU6k+bsZIc9up0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-tWR6D3PPMZSkftDpiAt_Ig-1; Tue, 23 Jul 2024 10:38:45 -0400
X-MC-Unique: tWR6D3PPMZSkftDpiAt_Ig-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79f1d37915dso957610785a.1
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 07:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721745525; x=1722350325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8D9zZcUE0U3hHmqSilSWN7yBwFstQGaORKtcOXi3Go=;
        b=VfS9XG9DBCdHLuB3DzTMSIxoUhRYLAGduOGJwcl6FoV1WzWh9PNcnA0Ve2LGCmZo1Q
         ZJz7FrAMxHnxjWd7fG1ziCNuzhitDrTx92cFbR6v7ZfmF3le2I+DSs5o3tuwAeQ3k9FY
         iZ+tmbg9SQCy1gxFWToTGs9+rekKrAXgHNYe9Tu9V2OKW1rkDCpqRGbF0TdfcviQ8txI
         yUkwulYg0877idyNIzowgWv8KEFdczqT7M5MwVf0J8idxdkhB1iqmFaasxuyePATRhC/
         DRiEHZuEFPKr9ksFe5dru7b58fdQKaVP6riam1roW0a/anWDppB1WSFIckLgFAH+Lc//
         CyqA==
X-Forwarded-Encrypted: i=1; AJvYcCX8Zhw2hVhUUbzqvACg9j8tcLFeGNSOaPpSPHHdwbJA0R2wJXfJCUdi/RGxSWd9Se8i3Qx/jnAEVYi9SrHUfzaVhfbM
X-Gm-Message-State: AOJu0YyJ3Pru5mE1b76hsBMNDEGA6dnie1sFjost/Oq8IaLGj0hHJHnT
	ph9dPP+Z+G7dftKVTcJQuT/P/sDfx+t+TV6bkUdu1RME5EslyMtOmipsVFokwY1qH3F3Y500ys0
	M5MS1oBI+rLY2J7p6s6QjZ0RTWju3NdDpsmgYCUr4HCmXQafIxQ==
X-Received: by 2002:a05:620a:4509:b0:795:5f15:f9e8 with SMTP id af79cd13be357-7a1c2f7a688mr357762185a.31.1721745524765;
        Tue, 23 Jul 2024 07:38:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt+6RarktAqnam78KX5eGOY82IGXpcHtmA5V03az2mrl145h+XI2RXXmH48ChifXYWujtFZQ==
X-Received: by 2002:a05:620a:4509:b0:795:5f15:f9e8 with SMTP id af79cd13be357-7a1c2f7a688mr357755685a.31.1721745524147;
        Tue, 23 Jul 2024 07:38:44 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a198ffe9d4sm480822485a.63.2024.07.23.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 07:38:43 -0700 (PDT)
Date: Tue, 23 Jul 2024 16:38:33 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Amery Hung <ameryhung@gmail.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org, 
	decui@microsoft.com, bryantan@vmware.com, vdasa@vmware.com, pv-drivers@vmware.com, 
	dan.carpenter@linaro.org, simon.horman@corigine.com, oxffffaa@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Subject: Re: [RFC PATCH net-next v6 00/14] virtio/vsock: support datagrams
Message-ID: <ufohkq4g3v6mzpmheftdac5rtuy36ocvc4mczuhwc6fv456kmh@kyttvegsdxva>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>

Hi Amery,

On Wed, Jul 10, 2024 at 09:25:41PM GMT, Amery Hung wrote:
>Hey all!
>
>This series introduces support for datagrams to virtio/vsock.
>
>It is a spin-off (and smaller version) of this series from the summer:
>  https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/

Cool! Thanks for restarting this work!

>
>Please note that this is an RFC and should not be merged until
>associated changes are made to the virtio specification, which will
>follow after discussion from this series.
>
>Another aside, the v4 of the series has only been mildly tested with a
>run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
>up, but I'm hoping to get some of the design choices agreed upon before
>spending too much time making it pretty.

What are the main points where you would like an agreement?

>
>This series first supports datagrams in a basic form for virtio, and
>then optimizes the sendpath for all datagram transports.

What kind of optimization?

>
>The result is a very fast datagram communication protocol that
>outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
>of multi-threaded workload samples.
>
>For those that are curious, some summary data comparing UDP and VSOCK
>DGRAM (N=5):
>
>	vCPUS: 16
>	virtio-net queues: 16
>	payload size: 4KB
>	Setup: bare metal + vm (non-nested)
>
>	UDP: 287.59 MB/s
>	VSOCK DGRAM: 509.2 MB/s

Nice!

I have not tested because the series does not compile as has already 
been pointed out, I will test the next version.

>
>Some notes about the implementation...
>
>This datagram implementation forces datagrams to self-throttle according
>to the threshold set by sk_sndbuf. It behaves similar to the credits
>used by streams in its effect on throughput and memory consumption, but
>it is not influenced by the receiving socket as credits are.
>
>The device drops packets silently.
>
>As discussed previously, this series introduces datagrams and defers
>fairness to future work. See discussion in v2 for more context around
>datagrams, fairness, and this implementation.

So IIUC we are re-using the same virtqueues used by stream/seqpacket, 
right?

I did a fast review, there's something to fix, but it looks like this 
can work well, so I'd start to discuss virtio spec changes ASAP.

Thanks,
Stefano

>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Signed-off-by: Amery Hung <amery.hung@bytedance.com>
>---
>Changes in v6:
>- allow empty transport in datagram vsock
>- add empty transport checks in various paths
>- transport layer now saves source cid and port to control buffer of skb
>  to remove the dependency of transport in recvmsg()
>- fix virtio dgram_enqueue() by looking up the transport to be used when
>  using sendto(2)
>- fix skb memory leaks in two places
>- add dgram auto-bind test
>- Link to v5: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com
>
>Changes in v5:
>- teach vhost to drop dgram when a datagram exceeds the receive buffer
>  - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
>	"vsock: read from socket's error queue"
>- replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
>  callback
>- refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
>- add _fallback/_FALLBACK suffix to dgram transport variables/macros
>- add WARN_ONCE() for table_size / VSOCK_HASH issue
>- add static to vsock_find_bound_socket_common
>- dedupe code in vsock_dgram_sendmsg() using module_got var
>- drop concurrent sendmsg() for dgram and defer to future series
>- Add more tests
>  - test EHOSTUNREACH in errqueue
>  - test stream + dgram address collision
>- improve clarity of dgram msg bounds test code
>- Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com
>
>Changes in v4:
>- style changes
>  - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
>    &sk->vsk
>  - vsock: fix xmas tree declaration
>  - vsock: fix spacing issues
>  - virtio/vsock: virtio_transport_recv_dgram returns void because err
>    unused
>- sparse analysis warnings/errors
>  - virtio/vsock: fix unitialized skerr on destroy
>  - virtio/vsock: fix uninitialized err var on goto out
>  - vsock: fix declarations that need static
>  - vsock: fix __rcu annotation order
>- bugs
>  - vsock: fix null ptr in remote_info code
>  - vsock/dgram: make transport_dgram a fallback instead of first
>    priority
>  - vsock: remove redundant rcu read lock acquire in getname()
>- tests
>  - add more tests (message bounds and more)
>  - add vsock_dgram_bind() helper
>  - add vsock_dgram_connect() helper
>
>Changes in v3:
>- Support multi-transport dgram, changing logic in connect/bind
>  to support VMCI case
>- Support per-pkt transport lookup for sendto() case
>- Fix dgram_allow() implementation
>- Fix dgram feature bit number (now it is 3)
>- Fix binding so dgram and connectible (cid,port) spaces are
>  non-overlapping
>- RCU protect transport ptr so connect() calls never leave
>  a lockless read of the transport and remote_addr are always
>  in sync
>- Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com
>
>
>Bobby Eshleman (14):
>  af_vsock: generalize vsock_dgram_recvmsg() to all transports
>  af_vsock: refactor transport lookup code
>  af_vsock: support multi-transport datagrams
>  af_vsock: generalize bind table functions
>  af_vsock: use a separate dgram bind table
>  virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
>  virtio/vsock: add common datagram send path
>  af_vsock: add vsock_find_bound_dgram_socket()
>  virtio/vsock: add common datagram recv path
>  virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>  vhost/vsock: implement datagram support
>  vsock/loopback: implement datagram support
>  virtio/vsock: implement datagram support
>  test/vsock: add vsock dgram tests
>
> drivers/vhost/vsock.c                   |   62 +-
> include/linux/virtio_vsock.h            |    9 +-
> include/net/af_vsock.h                  |   24 +-
> include/uapi/linux/virtio_vsock.h       |    2 +
> net/vmw_vsock/af_vsock.c                |  343 ++++++--
> net/vmw_vsock/hyperv_transport.c        |   13 -
> net/vmw_vsock/virtio_transport.c        |   24 +-
> net/vmw_vsock/virtio_transport_common.c |  188 ++++-
> net/vmw_vsock/vmci_transport.c          |   61 +-
> net/vmw_vsock/vsock_loopback.c          |    9 +-
> tools/testing/vsock/util.c              |  177 +++-
> tools/testing/vsock/util.h              |   10 +
> tools/testing/vsock/vsock_test.c        | 1032 ++++++++++++++++++++---
> 13 files changed, 1638 insertions(+), 316 deletions(-)
>
>-- 
>2.20.1
>


