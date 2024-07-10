Return-Path: <kvm+bounces-21345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B55A92DAB0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 828F31F23B5A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78F813C908;
	Wed, 10 Jul 2024 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeXW9fOL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416094206C;
	Wed, 10 Jul 2024 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646758; cv=none; b=ojRsSx+4XWRqBUSwJf3viBi6l3uE8qPB8N97+4WTVgsF11yilnV7ZPhThC7JkQrZAwMlaECLO5WktpnRBvor/oSSIX0vPT2yZaorzXA9kH6uKqi9gj405gsc1bgxk6Jslv7u0TqUoEzoLHmXCGvT8HCkkFjVwtJUAXMFp1UWADI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646758; c=relaxed/simple;
	bh=IRtZNpuJNMmXPtNDOFUO3vtkI4/OVSZb2YHRY1Upuy4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IDTfXJMzc5em7kq2BquCthtQVZhGtedaKIPG8sC3bAlNX3+OZK04wcAof5JbOo1F2fUQGjWYgmeReQaszlFKld73F8pOzFuEUWzI4mLM4ZuN+MP3t6oP6NURt6kROQDc+c9dtivl3KKqeL/GUcMSg9vBp6swXEOj6xau2ifLPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeXW9fOL; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79f15e7c879so15792085a.1;
        Wed, 10 Jul 2024 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646756; x=1721251556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QbggaOSaHuCesi2CRg2wXU+q+eIk0OlAl3CaZ0eNZU8=;
        b=WeXW9fOLNarLuuBjZtX9MBBk6hIIXzviPv0H5Fjxf4aZNiOI0wZYCi1v1SwqW0p1S7
         PzbHP3Xni/WrsbAm5GEX1qTY27OKTnXYqk1wL0vV0yrgfDOSNlQH5sGMJvZrETDzzzDc
         2hb9lEVx0+nUveHDZCBepezBvvf5R3Zyj6R2zUB61lX/zKjQ1+ff8aErUm+UBZky0uSM
         6hI4x0VJXCxU49kToiivbLawfd8lPVYy+sLi5m8IMbXgwP2UxVLjcYeJWHABGfEthCrU
         yKOyblLK5QZbBcXcY0j01kfqq0MHVB/xb5PbLqni7LKTRERHe5tfbIF3UcA2P+8LFSLq
         RTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646756; x=1721251556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QbggaOSaHuCesi2CRg2wXU+q+eIk0OlAl3CaZ0eNZU8=;
        b=nsSRpM/FmJCX0f/QEbghApz+Rr5mQFQ+ChnXJwsYkRh0YpXPFJ3LdLPgrfGEg4tz9/
         kQXwdKCDYKIYRTZgFVgvfJTZfEij+yXPIYoRC4BwvsOxAAoggs8sxt+IQ1bBgyMPHBhI
         4szDtRWv2bHgviDjqAhxEwQdH9M/s212yP3m0tCVrpc9LSnnK+kY2bY3nkC3z5H03e9m
         16ytQJ2Cy2wDLlGN7wn7CUmdosd0nbP0a2SZVaswdqqPPMZPf+NH3H0cwY7FNjEMHU5g
         0KYsEktYKyaIii0doocfnZRPVXctLluqkjqFq9uP9sZx2c9BwgbadwOVs+BrTxoRkhNu
         lTrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmQ2Pj4aNfeEVzZnOVRsl906efEod7gggTeHC9yrjp0NWs5FVJ9e1UrWdSdQ6KlS+NjvN05FlqXiI7Uf/OmDMofd6liPTI1fi8e6hPMV2wgNg/ly6hXtaOv13QyYibxF7FoNWRyDcx63BA1ALhWThjnOTFNw//K79QRhQYUqJaF28dDDnAq7MuG05OegCZmJYP+AjNthiTh3pfob9VJRxtEeehETs0ISKc4MzG
X-Gm-Message-State: AOJu0Yzwq2tZv31UrBaFScpyIukx2xPmHOfTZ3FqsgCdUz+CbOCXrTOD
	yZ1bU+ANx10kmu2za261S8UYBn5i5yTcWswQtRIq/0QFwYmpo/po
X-Google-Smtp-Source: AGHT+IFe0i7wU8rrpD+HqlfKPUEgBWA6vsqjfMceJ75v21AkhfrEYglh+zMZJB1mRaN1tBQCuxzMAw==
X-Received: by 2002:a05:620a:44d4:b0:7a1:41df:cca6 with SMTP id af79cd13be357-7a141dfcf26mr277624185a.23.1720646756076;
        Wed, 10 Jul 2024 14:25:56 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:25:55 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 00/14] virtio/vsock: support datagrams
Date: Wed, 10 Jul 2024 21:25:41 +0000
Message-Id: <20240710212555.1617795-1-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hey all!

This series introduces support for datagrams to virtio/vsock.

It is a spin-off (and smaller version) of this series from the summer:
  https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/

Please note that this is an RFC and should not be merged until
associated changes are made to the virtio specification, which will
follow after discussion from this series.

Another aside, the v4 of the series has only been mildly tested with a
run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
up, but I'm hoping to get some of the design choices agreed upon before
spending too much time making it pretty.

This series first supports datagrams in a basic form for virtio, and
then optimizes the sendpath for all datagram transports.

The result is a very fast datagram communication protocol that
outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
of multi-threaded workload samples.

For those that are curious, some summary data comparing UDP and VSOCK
DGRAM (N=5):

	vCPUS: 16
	virtio-net queues: 16
	payload size: 4KB
	Setup: bare metal + vm (non-nested)

	UDP: 287.59 MB/s
	VSOCK DGRAM: 509.2 MB/s

Some notes about the implementation...

This datagram implementation forces datagrams to self-throttle according
to the threshold set by sk_sndbuf. It behaves similar to the credits
used by streams in its effect on throughput and memory consumption, but
it is not influenced by the receiving socket as credits are.

The device drops packets silently.

As discussed previously, this series introduces datagrams and defers
fairness to future work. See discussion in v2 for more context around
datagrams, fairness, and this implementation.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
Changes in v6:
- allow empty transport in datagram vsock
- add empty transport checks in various paths
- transport layer now saves source cid and port to control buffer of skb
  to remove the dependency of transport in recvmsg()
- fix virtio dgram_enqueue() by looking up the transport to be used when
  using sendto(2)
- fix skb memory leaks in two places
- add dgram auto-bind test
- Link to v5: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com

Changes in v5:
- teach vhost to drop dgram when a datagram exceeds the receive buffer
  - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
	"vsock: read from socket's error queue"
- replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
  callback
- refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
- add _fallback/_FALLBACK suffix to dgram transport variables/macros
- add WARN_ONCE() for table_size / VSOCK_HASH issue
- add static to vsock_find_bound_socket_common
- dedupe code in vsock_dgram_sendmsg() using module_got var
- drop concurrent sendmsg() for dgram and defer to future series
- Add more tests
  - test EHOSTUNREACH in errqueue
  - test stream + dgram address collision
- improve clarity of dgram msg bounds test code
- Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com

Changes in v4:
- style changes
  - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
    &sk->vsk
  - vsock: fix xmas tree declaration
  - vsock: fix spacing issues
  - virtio/vsock: virtio_transport_recv_dgram returns void because err
    unused
- sparse analysis warnings/errors
  - virtio/vsock: fix unitialized skerr on destroy
  - virtio/vsock: fix uninitialized err var on goto out
  - vsock: fix declarations that need static
  - vsock: fix __rcu annotation order
- bugs
  - vsock: fix null ptr in remote_info code
  - vsock/dgram: make transport_dgram a fallback instead of first
    priority
  - vsock: remove redundant rcu read lock acquire in getname()
- tests
  - add more tests (message bounds and more)
  - add vsock_dgram_bind() helper
  - add vsock_dgram_connect() helper

Changes in v3:
- Support multi-transport dgram, changing logic in connect/bind
  to support VMCI case
- Support per-pkt transport lookup for sendto() case
- Fix dgram_allow() implementation
- Fix dgram feature bit number (now it is 3)
- Fix binding so dgram and connectible (cid,port) spaces are
  non-overlapping
- RCU protect transport ptr so connect() calls never leave
  a lockless read of the transport and remote_addr are always
  in sync
- Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com


Bobby Eshleman (14):
  af_vsock: generalize vsock_dgram_recvmsg() to all transports
  af_vsock: refactor transport lookup code
  af_vsock: support multi-transport datagrams
  af_vsock: generalize bind table functions
  af_vsock: use a separate dgram bind table
  virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
  virtio/vsock: add common datagram send path
  af_vsock: add vsock_find_bound_dgram_socket()
  virtio/vsock: add common datagram recv path
  virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
  vhost/vsock: implement datagram support
  vsock/loopback: implement datagram support
  virtio/vsock: implement datagram support
  test/vsock: add vsock dgram tests

 drivers/vhost/vsock.c                   |   62 +-
 include/linux/virtio_vsock.h            |    9 +-
 include/net/af_vsock.h                  |   24 +-
 include/uapi/linux/virtio_vsock.h       |    2 +
 net/vmw_vsock/af_vsock.c                |  343 ++++++--
 net/vmw_vsock/hyperv_transport.c        |   13 -
 net/vmw_vsock/virtio_transport.c        |   24 +-
 net/vmw_vsock/virtio_transport_common.c |  188 ++++-
 net/vmw_vsock/vmci_transport.c          |   61 +-
 net/vmw_vsock/vsock_loopback.c          |    9 +-
 tools/testing/vsock/util.c              |  177 +++-
 tools/testing/vsock/util.h              |   10 +
 tools/testing/vsock/vsock_test.c        | 1032 ++++++++++++++++++++---
 13 files changed, 1638 insertions(+), 316 deletions(-)

-- 
2.20.1


