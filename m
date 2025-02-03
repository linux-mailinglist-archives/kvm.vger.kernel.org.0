Return-Path: <kvm+bounces-37181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF33A266E4
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 23:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5180A18852D3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803D1212B24;
	Mon,  3 Feb 2025 22:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LJRxAFHN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F2210F45
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622365; cv=none; b=aFGolBV25gPYd2yLMUeVag8AgUQbw45Q5AUjDun/r93ILq1e2+mAloPmGoZ4HVWaAaG+eaYBeAkKq8R3/eWd8h2Hg+XR/2SimH57pf2tS2mAsj8RHCUNNwNMTj7uikYpzph62u7hkzh1LkXNMnHv2qko9JYutkbI2ovzbAgZojk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622365; c=relaxed/simple;
	bh=3u/7jLBYe2KfRcVNNTNkFn5t4vUJKiOG+tUb7ZrbBhE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WEUpCPLkE0y/Wm/hGl1xak25WSRFjcEpsUoGWVLMbmLh+ndkv95AjNeQphWaBmij2cPn4dU91sBuybJHLICtWY5cSiMkuPzSk3jxIdiDxRy6/bV6VNI+12tz9VyFZ41Bw21ycWkFxIend+ezNct+wwLJPVRkXEAi9AyxFEY8wkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LJRxAFHN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so9170211a91.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 14:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738622359; x=1739227159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kMF0lC9HmaCcCSq7dy1+BxkweYLRN4mbfBRIjXSD14=;
        b=LJRxAFHNc1dq3DvZOQHS65sAb3rmvor7b73POo2LrQ0Ck8JQOyuBK6RwmsIE/4eYeK
         nvDmKc8wdYNNaJk+OO28kmPevG/K4b8nDulC0Q7VaJJ9e6BCnjAjFttKF3XelTMp02rA
         adEKS6BhS0S3d4WRWZ4q1wR92RObVzJBWPhy6iO0Zf4Tuf2p3Jbt1hepUCiQyA93afDR
         4wtNeZ30JWRA5P1ts0xKrvi2LgTXfrpeVTuOXg3qgD9b0SEpTGTLaLc+Gq1kbNHxBrge
         DWGsQ3PdrZwMsYX6e05hO/C7dNtVs8K8HSAURARRvq5yzOS8g8QPRSFYE6IU/Ty9qAJ6
         SxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738622359; x=1739227159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kMF0lC9HmaCcCSq7dy1+BxkweYLRN4mbfBRIjXSD14=;
        b=UyNi+0sb/3iflQAWB5207V/j9pxCh2w3puxjOdq74mKgxMsHnaqPtGXTjYGS50tM9x
         bEI4jlGqGhH00spGrqTdE+pX/q8wjdm9aCcN3C81OfA8dj6y8g0QF8YBIODVomGjYRJv
         uKY3+bHG9DjDq4PJP01hj8eKFl+9LoHVWfGT2GNfejw/T4BJp7npAXduX2mpD+tyFhOH
         /QcOaY+V3P7ufI5oS8Wd37plS+ecnCpcEUIGpZd8Z9Oqay4fppK9FtS7dmKJpFazE3ce
         IrTaK28Ig8xGPsSWrpCT/zPPfG69F7T7tRYEkDR8ZaTcZCMJwL0Kk6fxUiYOszECbEMs
         /OUA==
X-Forwarded-Encrypted: i=1; AJvYcCXjrzb1UVQEoPU6MD+d5Z75qxSAxtX3T4GORrW9vnf+eJpxsGJQ0oeeuL+7+9fdTo1R17k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwasP54xEnipaZ97XiR/Aloalx/gUeslQT1YsbDMkL19uUOr8A8
	ObzI/negnT4VQN8Vj5UOBgTb6t+AMuE8Dyrarw5ZS1Lx0EOjQnzeI92dkEYuHMK8IY3un5Ass9X
	4Sl+oTXNRs6Zl+Bd9H6urRQ==
X-Google-Smtp-Source: AGHT+IHb13gQXiLhCy8lu7S+LD4XF4ggchabFxgYbLgWDs+s8DOSBAGbImDSpE2rflM6SVyUqDbN1DXEF3FRb/M8sA==
X-Received: from pfbha6.prod.google.com ([2002:a05:6a00:8506:b0:72d:7a13:7a84])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:10cb:b0:725:ebab:bb2e with SMTP id d2e1a72fcca58-72fd0bfae9bmr34000927b3a.11.1738622359422;
 Mon, 03 Feb 2025 14:39:19 -0800 (PST)
Date: Mon,  3 Feb 2025 22:39:11 +0000
In-Reply-To: <20250203223916.1064540-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223916.1064540-1-almasrymina@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250203223916.1064540-2-almasrymina@google.com>
Subject: [PATCH net-next v3 1/6] net: add devmem TCP TX documentation
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, 
	asml.silence@gmail.com, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Add documentation outlining the usage and details of the devmem TCP TX
API.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v2:
- Update documentation for iov_base is the dmabuf offset (Stan)
---
 Documentation/networking/devmem.rst | 144 +++++++++++++++++++++++++++-
 1 file changed, 140 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devmem.rst b/Documentation/networking/devmem.rst
index d95363645331..8166fe09da13 100644
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
@@ -235,6 +235,142 @@ can be less than the tokens provided by the user in case of:
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
+to the semantics of MSG_ZEROCOPY.
+
+	ret = setsockopt(socket_fd, SOL_SOCKET, SO_ZEROCOPY, &opt, sizeof(opt));
+
+Sending data
+--------------
+
+Devmem data is sent using the SCM_DEVMEM_DMABUF cmsg.
+
+The user should create a msghdr where,
+
+iov_base is set to the offset into the dmabuf to start sending from.
+iov_len is set to the number of bytes to be sent from the dmabuf.
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
2.48.1.362.g079036d154-goog


