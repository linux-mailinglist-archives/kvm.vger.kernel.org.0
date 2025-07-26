Return-Path: <kvm+bounces-53498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A607DB12918
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 07:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ECEB1C267DD
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 05:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B37204680;
	Sat, 26 Jul 2025 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdIf8veI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B92A1AA;
	Sat, 26 Jul 2025 05:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753509230; cv=none; b=HSCnv0pisXgwQKUxoH7dUY3seYhmvB5DrDH+Qrr8copoP1ld6AjdpT7B04Cjh2/Ev2dIgAoubalsuDBeN3t7LfXBWPLaf9yI/4YbSoDOpZB2gHaecfzySA/VXFFezDafzTa/ZHq7gjol8nL5g8zRi1Q4tWIt5hdALlZVg0MKs9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753509230; c=relaxed/simple;
	bh=qjAtuM6bjE5YOicSXvKnHeXz95Ueb3CFX9BTvqHz/ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hDaCAldpJLJmc6nBiLF0dM/gTF2CPLLPACHkC0vmtrt/2YmBjfbWuB6nyKFmhgfkQ9cBEAf2xmnZst1MTie8TQxBSbHai8aeVT2OUUIc2FeFjpczJMY0gFHSLKdgYZKjxSzhTK6b/mrt6i1Pa8OrtEUHJLA76EgW0P1L254VEVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdIf8veI; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7183fd8c4c7so30037857b3.3;
        Fri, 25 Jul 2025 22:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753509227; x=1754114027; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWn+ulxpcv7HdNLVJ+yLthV3Vv9Iaz7WMBgkwYUe3vQ=;
        b=fdIf8veIBifnc1fNbXFYmsB0WHMGyApvRQd6YZV+A7cQPISmKY4w+gZhBeCW3tJHz3
         tm3dpb63YglWtF3Qm+ZlzHN7E3OcsIZnwmNhJyRFyGuhvCJVgPPP3dWXnG6GlAw2cuuY
         7xZ/tdN49sCJ2i1j9Kr4zruaS2U1VAywtIFB2YOJX0QT28t37TPbhHioN4uhcQwW0XYP
         cdBmRkg95ouqiRS+IVtoTfej2LHKCy+sBUEyabneH/8BCGZUC8n0GIvYxft3TFcZeaZM
         oqUAGOgquf0Ii7WHkvsfkSgiB/+3DMci5Nw1bF53OfLQDgyzd29SdapSXw+5eLhCD7x6
         j9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753509227; x=1754114027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWn+ulxpcv7HdNLVJ+yLthV3Vv9Iaz7WMBgkwYUe3vQ=;
        b=BvaF4WJWngGkIVA35dvKN3FjmzdS2jXPl0oHnP4/1KwCNaIU+6r9aDkWPVzGwo/gxK
         TtQrXnggA4RwRvfeBN+W4hb3YKzEnBvXYbupKu6bf6KixMrAa4R6WWXN8Q9pWRTjLxox
         ZsWJb53QHtQ0QlQD+EfVQGMANYs1cFUUCYfwd3HUT/jJW6jA987qV54DGMOI8f6EQcq6
         HF1Rn/NrVXD8goNnxYjr9B3kYpAUkTY7UYHvyZakm7yRLRcTxNApOaHX6C75VoeluPwY
         1DVsHZbn4Qp8qi9kssYvlHitJn37SV9+zQgzSKbgGCiqLZQwZDaQowBUzXmaNQ9cnP01
         aW6w==
X-Forwarded-Encrypted: i=1; AJvYcCV0pW6f3O3M6C5Jg8WXMaN6g5YhcOzrVRMMKCmzWdPAUM2aGcVKHvII8lIoDKg6vCnHetK7wB9L@vger.kernel.org, AJvYcCVD9a6Ea2Du/2FmE7UKl/u8HRfR3phFQVXh0GsuyMUbByPyVX1NHn7xYC77hnBVh1EZO7jG@vger.kernel.org, AJvYcCWqSjn+iJP+LQNHKoiNJO4QlXqQ6C6kYSPncgHT6XZu+bTNVlSVUWgIVe8wYhkGBjDlyv0=@vger.kernel.org, AJvYcCWvixmdIhq57KzekA3F3xBegqpZq5HuyQ42dXiZhlljCMbTv9Uwvhi9zo1r4fP0mPzVZF/L/KnSPDaIGtg9@vger.kernel.org, AJvYcCXDsTyQc3a/8bIi1F2zSQbG5GaxU0tcKYvY1uS4asK/xV0ZPjt6UKzBl4J6djJH7BU7eF9GLHO2V8KU1NCB@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf8kmhuUGZYR7NNO5ygqcYKbw/oOC7F5v6uK199B/N9WYJUg+N
	wpjspcXUPCubOg2946YUaaUhmKw4dFMV5o+2x4mtVtTT2oOYbEzMwQ7aDTEHllTzEwT/GY0ohml
	sjaAlZgH/K876d+NBskoaLOlAnNJZhVA=
X-Gm-Gg: ASbGncvtuOr56OEsB8RbL0p3rNAOfFdcyMAoCmIszuqVbeObXv9kOcRORsRiSnae6vz
	0H4RjuG79dqmhA8yptGW/9Ey+Uds/4mPVBLegu6zicv96pcz9oMarFGG5dtk0jgIEMGKkzw0JKB
	d/NRebPah/BF2X7ZEYK1war0gv90jdAo02Nz9aKJhGYQRE/ZuHxtd4GF5rFaiDkwlaRQ2ECdxtI
	NAKdeGcEiN1cQDL+Q==
X-Google-Smtp-Source: AGHT+IE0Lg8OC1qQflbm42pTUDEXQn5wEtvjZAGDRpEYT9WPYGJBWJxfXrPWc1WTljH0ya6XcqQMq2gpMQ7Ymg2lRdk=
X-Received: by 2002:a05:690c:e0a:b0:6ef:6d61:c254 with SMTP id
 00721157ae682-719e348e675mr51700067b3.38.1753509227288; Fri, 25 Jul 2025
 22:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com> <dsamf7k2byoflztkwya3smj7jyczyq7aludvd36lufdrboxdqk@u73iwrcyb5am>
In-Reply-To: <dsamf7k2byoflztkwya3smj7jyczyq7aludvd36lufdrboxdqk@u73iwrcyb5am>
From: Amery Hung <ameryhung@gmail.com>
Date: Fri, 25 Jul 2025 22:53:35 -0700
X-Gm-Features: Ac12FXyMvpkfh1BVRP1lxRseahm_ttdL_F4ac_DTON4U9vvl5wd6WOkrVb-fPTk
Message-ID: <CAMB2axNKxW4gnd6qiSNYdm2zPxJkbbLgZz9P-Kh7SS0Sb1Yw=Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 00/14] virtio/vsock: support datagrams
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, 
	wei.liu@kernel.org, decui@microsoft.com, bryantan@vmware.com, 
	vdasa@vmware.com, pv-drivers@vmware.com, dan.carpenter@linaro.org, 
	simon.horman@corigine.com, oxffffaa@gmail.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2025 at 7:35=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> Hi Amery,
>
> On Wed, Jul 10, 2024 at 09:25:41PM +0000, Amery Hung wrote:
> >Hey all!
> >
> >This series introduces support for datagrams to virtio/vsock.
>
> any update on v7 of this series?
>

Hi Stefano,

Sorry that I don't have personal time to work on v7. Since I don't
think people involved in this set are still working on it, I am
posting my v7 WIP here to see if anyone is interested in finishing it.
Would greatly appreciate any help.

Link: https://github.com/ameryhung/linux/tree/vsock-dgram-v7

Here are the things that I haven't address in the WIP:

01/14
- Arseniy suggested doing skb_put(dg->payload_size) and memcpy(dg->payload_=
size)

07/14
- Remove the double transport lookup in the send path by passing
transport to dgram_enqueue
- Address Arseniy's comment about updating vsock_virtio_transport_common.h

14/14
- Split test/vsock into smaller patches

Finally the spec change discussion also needs to happen.



> Thanks,
> Stefano
>
> >
> >It is a spin-off (and smaller version) of this series from the summer:
> >  https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@byteda=
nce.com/
> >
> >Please note that this is an RFC and should not be merged until
> >associated changes are made to the virtio specification, which will
> >follow after discussion from this series.
> >
> >Another aside, the v4 of the series has only been mildly tested with a
> >run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
> >up, but I'm hoping to get some of the design choices agreed upon before
> >spending too much time making it pretty.
> >
> >This series first supports datagrams in a basic form for virtio, and
> >then optimizes the sendpath for all datagram transports.
> >
> >The result is a very fast datagram communication protocol that
> >outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> >of multi-threaded workload samples.
> >
> >For those that are curious, some summary data comparing UDP and VSOCK
> >DGRAM (N=3D5):
> >
> >       vCPUS: 16
> >       virtio-net queues: 16
> >       payload size: 4KB
> >       Setup: bare metal + vm (non-nested)
> >
> >       UDP: 287.59 MB/s
> >       VSOCK DGRAM: 509.2 MB/s
> >
> >Some notes about the implementation...
> >
> >This datagram implementation forces datagrams to self-throttle according
> >to the threshold set by sk_sndbuf. It behaves similar to the credits
> >used by streams in its effect on throughput and memory consumption, but
> >it is not influenced by the receiving socket as credits are.
> >
> >The device drops packets silently.
> >
> >As discussed previously, this series introduces datagrams and defers
> >fairness to future work. See discussion in v2 for more context around
> >datagrams, fairness, and this implementation.
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> >---
> >Changes in v6:
> >- allow empty transport in datagram vsock
> >- add empty transport checks in various paths
> >- transport layer now saves source cid and port to control buffer of skb
> >  to remove the dependency of transport in recvmsg()
> >- fix virtio dgram_enqueue() by looking up the transport to be used when
> >  using sendto(2)
> >- fix skb memory leaks in two places
> >- add dgram auto-bind test
> >- Link to v5: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v5-0-581=
bd37fdb26@bytedance.com
> >
> >Changes in v5:
> >- teach vhost to drop dgram when a datagram exceeds the receive buffer
> >  - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
> >       "vsock: read from socket's error queue"
> >- replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
> >  callback
> >- refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy se=
ries
> >- add _fallback/_FALLBACK suffix to dgram transport variables/macros
> >- add WARN_ONCE() for table_size / VSOCK_HASH issue
> >- add static to vsock_find_bound_socket_common
> >- dedupe code in vsock_dgram_sendmsg() using module_got var
> >- drop concurrent sendmsg() for dgram and defer to future series
> >- Add more tests
> >  - test EHOSTUNREACH in errqueue
> >  - test stream + dgram address collision
> >- improve clarity of dgram msg bounds test code
> >- Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0ce=
bbb2ae899@bytedance.com
> >
> >Changes in v4:
> >- style changes
> >  - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
> >    &sk->vsk
> >  - vsock: fix xmas tree declaration
> >  - vsock: fix spacing issues
> >  - virtio/vsock: virtio_transport_recv_dgram returns void because err
> >    unused
> >- sparse analysis warnings/errors
> >  - virtio/vsock: fix unitialized skerr on destroy
> >  - virtio/vsock: fix uninitialized err var on goto out
> >  - vsock: fix declarations that need static
> >  - vsock: fix __rcu annotation order
> >- bugs
> >  - vsock: fix null ptr in remote_info code
> >  - vsock/dgram: make transport_dgram a fallback instead of first
> >    priority
> >  - vsock: remove redundant rcu read lock acquire in getname()
> >- tests
> >  - add more tests (message bounds and more)
> >  - add vsock_dgram_bind() helper
> >  - add vsock_dgram_connect() helper
> >
> >Changes in v3:
> >- Support multi-transport dgram, changing logic in connect/bind
> >  to support VMCI case
> >- Support per-pkt transport lookup for sendto() case
> >- Fix dgram_allow() implementation
> >- Fix dgram feature bit number (now it is 3)
> >- Fix binding so dgram and connectible (cid,port) spaces are
> >  non-overlapping
> >- RCU protect transport ptr so connect() calls never leave
> >  a lockless read of the transport and remote_addr are always
> >  in sync
> >- Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079=
cc7cee62e@bytedance.com
> >
> >
> >Bobby Eshleman (14):
> >  af_vsock: generalize vsock_dgram_recvmsg() to all transports
> >  af_vsock: refactor transport lookup code
> >  af_vsock: support multi-transport datagrams
> >  af_vsock: generalize bind table functions
> >  af_vsock: use a separate dgram bind table
> >  virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
> >  virtio/vsock: add common datagram send path
> >  af_vsock: add vsock_find_bound_dgram_socket()
> >  virtio/vsock: add common datagram recv path
> >  virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
> >  vhost/vsock: implement datagram support
> >  vsock/loopback: implement datagram support
> >  virtio/vsock: implement datagram support
> >  test/vsock: add vsock dgram tests
> >
> > drivers/vhost/vsock.c                   |   62 +-
> > include/linux/virtio_vsock.h            |    9 +-
> > include/net/af_vsock.h                  |   24 +-
> > include/uapi/linux/virtio_vsock.h       |    2 +
> > net/vmw_vsock/af_vsock.c                |  343 ++++++--
> > net/vmw_vsock/hyperv_transport.c        |   13 -
> > net/vmw_vsock/virtio_transport.c        |   24 +-
> > net/vmw_vsock/virtio_transport_common.c |  188 ++++-
> > net/vmw_vsock/vmci_transport.c          |   61 +-
> > net/vmw_vsock/vsock_loopback.c          |    9 +-
> > tools/testing/vsock/util.c              |  177 +++-
> > tools/testing/vsock/util.h              |   10 +
> > tools/testing/vsock/vsock_test.c        | 1032 ++++++++++++++++++++---
> > 13 files changed, 1638 insertions(+), 316 deletions(-)
> >
> >--
> >2.20.1
> >
>

