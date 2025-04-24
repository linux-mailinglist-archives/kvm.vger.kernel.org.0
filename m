Return-Path: <kvm+bounces-44059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8EDA99FE5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9368E19464B0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 04:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811621B4141;
	Thu, 24 Apr 2025 04:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sTnzVxQV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28881E51E1
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 04:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745467396; cv=none; b=nl2UIY0YKHQwTCsqnH/u2YDg99gWufID6Tvxe+sLE5ZSYkX/P27lHVQrL8liUyxm0NdrtLRfsrw4+tm2iHf5BJ24KBvQtQpbU1nEcevOgefDUXAbe00/prYh5f7aOv5tXk6rV6Gq97BKN6o7KHQljHtsZsNeRD2jkPkp0iDMTm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745467396; c=relaxed/simple;
	bh=QDLXXaueecCgO5Axw+Nyu5EgxIhVwC4DuRcRjtwAJ5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uEykVbH2d6EIY/kcx5XxbqzQyCaVoxaMuFb3Zh31cd6IR5zqUOjKDZLRVyyRxMP1FhBo0owpcc9R5qH4+NvzJ02EZB4oJGmckzQB1gYs+iDj4kh+kC0bLkZ2YEOJBrjhB8XHrq1bISRVoN+WfzyivhjxtenNs6VBv41flOPGbpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sTnzVxQV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-309c6e43a9aso811444a91.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 21:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745467393; x=1746072193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8s7bJQK9mVBiBVARPJ5kkauQHM9lxUZX4qjjEP+CsW4=;
        b=sTnzVxQVdhbgUb1hJpIpuSNo+o+MCvmzgCb+ytxDh76N/7/QVfzWDPJlgJi2kdRjHk
         qm6FLI6BoCR1gMuNwd++WgVq761Sr+1AGU+TJl9i2gL4fAD8mz3pxtXnlNhZl+XI4m4X
         pGQOCEteKBzZEpya/E9uRBN9w1jS6s0D7OTzHH5t8VhGsEStsIqUt4g7EMX398psrt6v
         WkiQi3h/pFqf9rRcY8mHGZmuys9xttdfLhQ4njB4DA8LrzWuSH/5DKYMaUL7XNj4OXb7
         M00nvD4Eaon2iNUjM18lSh+K+vmtSg38cq6tKOpp+QUihfdg0xHfFNLyRdz9WyK1WeRg
         wUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745467393; x=1746072193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8s7bJQK9mVBiBVARPJ5kkauQHM9lxUZX4qjjEP+CsW4=;
        b=VVfy5eztfdGnnEs7Fd5at9Dh54an6NdaZ1T5LVjonADIihVvlc/CQP9Gv+1mxcoEX8
         hIQRSctU3X4+VHaZkGlllgT6yi8JgBtc4SR4IIcXgf8WCc7OiU34JaJPTQWIWfQ4HyVO
         PkE5eV4nwfxkaF+xyU0ZunAXkEXanLOBEFk9POJ8Bs3EjtRIu/m5/QDDmsQM0MnVMr7d
         Xxf+3PHbRSPHkcGFtZlUt7dQtFcdW0dt3u+76ShmYJke14Zubq5p5ZGzQf3I0V/uWGo3
         s1i2omxV9xq2eN42wxvfjSxB31Nf+PDQq9q3EJ82JWUXVYlHWd3JHxIB2JItKcuz8iLq
         v5Ig==
X-Forwarded-Encrypted: i=1; AJvYcCXZsc72s/7p1i89JV0ECp02kLtBf2wasRWcBSifR3HLDvnrvVJhqXFTPgJFKDa6Whp1Z5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRjUaCt90Xb0resIAWUM1tw6Si+9YK1uvZZiVWzpBcWISRBswr
	EfcH62V7pzGqrBMbohS1AiMTi+t8GOHDsjokYFh2xl8ax6Hbbawh8/XQXED1zpRhwsLLsDTFGlx
	rgnGU9lz8ijBmAL0Cvvmpyg==
X-Google-Smtp-Source: AGHT+IFDmjk5qYhlVEvcaWV/6HkyWEY6bOujBoJ8R/I3J2khGHfAvgsbrDZnCgnzdM+djzfP0cvjIoh5gcQPKiQEqg==
X-Received: from pjbsc15.prod.google.com ([2002:a17:90b:510f:b0:301:2679:9aa])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:c2d0:b0:2ee:f687:6acb with SMTP id 98e67ed59e1d1-309ed271ad4mr1819350a91.13.1745467392967;
 Wed, 23 Apr 2025 21:03:12 -0700 (PDT)
Date: Thu, 24 Apr 2025 04:02:57 +0000
In-Reply-To: <20250424040301.2480876-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250424040301.2480876-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250424040301.2480876-6-almasrymina@google.com>
Subject: [PATCH net-next v11 5/8] net: add devmem TCP TX documentation
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Add documentation outlining the usage and details of the devmem TCP TX
API.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v5:
- Address comments from Stan and Bagas

v4:
- Mention SO_BINDTODEVICE is recommended (me/Pavel).

v2:
- Update documentation for iov_base is the dmabuf offset (Stan)

---
 Documentation/networking/devmem.rst | 150 +++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devmem.rst b/Documentation/networking/devmem.rst
index eb678ca454968..a6cd7236bfbd2 100644
--- a/Documentation/networking/devmem.rst
+++ b/Documentation/networking/devmem.rst
@@ -62,15 +62,15 @@ More Info
     https://lore.kernel.org/netdev/20240831004313.3713467-1-almasrymina@google.com/
 
 
-Interface
-=========
+RX Interface
+============
 
 
 Example
 -------
 
-tools/testing/selftests/net/ncdevmem.c:do_server shows an example of setting up
-the RX path of this API.
+./tools/testing/selftests/drivers/net/hw/ncdevmem:do_server shows an example of
+setting up the RX path of this API.
 
 
 NIC Setup
@@ -235,6 +235,148 @@ can be less than the tokens provided by the user in case of:
 (a) an internal kernel leak bug.
 (b) the user passed more than 1024 frags.
 
+TX Interface
+============
+
+
+Example
+-------
+
+./tools/testing/selftests/drivers/net/hw/ncdevmem:do_client shows an example of
+setting up the TX path of this API.
+
+
+NIC Setup
+---------
+
+The user must bind a TX dmabuf to a given NIC using the netlink API::
+
+        struct netdev_bind_tx_req *req = NULL;
+        struct netdev_bind_tx_rsp *rsp = NULL;
+        struct ynl_error yerr;
+
+        *ys = ynl_sock_create(&ynl_netdev_family, &yerr);
+
+        req = netdev_bind_tx_req_alloc();
+        netdev_bind_tx_req_set_ifindex(req, ifindex);
+        netdev_bind_tx_req_set_fd(req, dmabuf_fd);
+
+        rsp = netdev_bind_tx(*ys, req);
+
+        tx_dmabuf_id = rsp->id;
+
+
+The netlink API returns a dmabuf_id: a unique ID that refers to this dmabuf
+that has been bound.
+
+The user can unbind the dmabuf from the netdevice by closing the netlink socket
+that established the binding. We do this so that the binding is automatically
+unbound even if the userspace process crashes.
+
+Note that any reasonably well-behaved dmabuf from any exporter should work with
+devmem TCP, even if the dmabuf is not actually backed by devmem. An example of
+this is udmabuf, which wraps user memory (non-devmem) in a dmabuf.
+
+Socket Setup
+------------
+
+The user application must use MSG_ZEROCOPY flag when sending devmem TCP. Devmem
+cannot be copied by the kernel, so the semantics of the devmem TX are similar
+to the semantics of MSG_ZEROCOPY::
+
+	setsockopt(socket_fd, SOL_SOCKET, SO_ZEROCOPY, &opt, sizeof(opt));
+
+It is also recommended that the user binds the TX socket to the same interface
+the dma-buf has been bound to via SO_BINDTODEVICE::
+
+	setsockopt(socket_fd, SOL_SOCKET, SO_BINDTODEVICE, ifname, strlen(ifname) + 1);
+
+
+Sending data
+------------
+
+Devmem data is sent using the SCM_DEVMEM_DMABUF cmsg.
+
+The user should create a msghdr where,
+
+* iov_base is set to the offset into the dmabuf to start sending from
+* iov_len is set to the number of bytes to be sent from the dmabuf
+
+The user passes the dma-buf id to send from via the dmabuf_tx_cmsg.dmabuf_id.
+
+The example below sends 1024 bytes from offset 100 into the dmabuf, and 2048
+from offset 2000 into the dmabuf. The dmabuf to send from is tx_dmabuf_id::
+
+       char ctrl_data[CMSG_SPACE(sizeof(struct dmabuf_tx_cmsg))];
+       struct dmabuf_tx_cmsg ddmabuf;
+       struct msghdr msg = {};
+       struct cmsghdr *cmsg;
+       struct iovec iov[2];
+
+       iov[0].iov_base = (void*)100;
+       iov[0].iov_len = 1024;
+       iov[1].iov_base = (void*)2000;
+       iov[1].iov_len = 2048;
+
+       msg.msg_iov = iov;
+       msg.msg_iovlen = 2;
+
+       msg.msg_control = ctrl_data;
+       msg.msg_controllen = sizeof(ctrl_data);
+
+       cmsg = CMSG_FIRSTHDR(&msg);
+       cmsg->cmsg_level = SOL_SOCKET;
+       cmsg->cmsg_type = SCM_DEVMEM_DMABUF;
+       cmsg->cmsg_len = CMSG_LEN(sizeof(struct dmabuf_tx_cmsg));
+
+       ddmabuf.dmabuf_id = tx_dmabuf_id;
+
+       *((struct dmabuf_tx_cmsg *)CMSG_DATA(cmsg)) = ddmabuf;
+
+       sendmsg(socket_fd, &msg, MSG_ZEROCOPY);
+
+
+Reusing TX dmabufs
+------------------
+
+Similar to MSG_ZEROCOPY with regular memory, the user should not modify the
+contents of the dma-buf while a send operation is in progress. This is because
+the kernel does not keep a copy of the dmabuf contents. Instead, the kernel
+will pin and send data from the buffer available to the userspace.
+
+Just as in MSG_ZEROCOPY, the kernel notifies the userspace of send completions
+using MSG_ERRQUEUE::
+
+        int64_t tstop = gettimeofday_ms() + waittime_ms;
+        char control[CMSG_SPACE(100)] = {};
+        struct sock_extended_err *serr;
+        struct msghdr msg = {};
+        struct cmsghdr *cm;
+        int retries = 10;
+        __u32 hi, lo;
+
+        msg.msg_control = control;
+        msg.msg_controllen = sizeof(control);
+
+        while (gettimeofday_ms() < tstop) {
+                if (!do_poll(fd)) continue;
+
+                ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
+
+                for (cm = CMSG_FIRSTHDR(&msg); cm; cm = CMSG_NXTHDR(&msg, cm)) {
+                        serr = (void *)CMSG_DATA(cm);
+
+                        hi = serr->ee_data;
+                        lo = serr->ee_info;
+
+                        fprintf(stdout, "tx complete [%d,%d]\n", lo, hi);
+                }
+        }
+
+After the associated sendmsg has been completed, the dmabuf can be reused by
+the userspace.
+
+
 Implementation & Caveats
 ========================
 
-- 
2.49.0.805.g082f7c87e0-goog


