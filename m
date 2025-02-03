Return-Path: <kvm+bounces-37179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 883ABA266D2
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 23:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E81E165C96
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C215421146C;
	Mon,  3 Feb 2025 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZKjHZ+/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BAC20FA96
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622360; cv=none; b=Sx4aNwj6yneEdCF1VEIcxF+6hLFyWWY06b+DErR9LED3z8MHWPZPnV/rHoCdMkDTlqN0BzP4dfiTZUxBtWOnvXSo5Iu2n7mUL8+uoT0HJombZEfsmXtpSE0PyCB9WujHTNmdzUo0Nxz+lxwISWWKP+/k+uASNZ/X4yjnJ/tL1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622360; c=relaxed/simple;
	bh=8FA02/VlhFsavq77cgzUsZDA7wvbkIrTAbtsEWgl9+0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rEmSXgPJe+egBDUilASzivYE8JGKnuY6ug63vMrFP/gNKYUF37aMzx19cU8QbUkrWt9RVWRpbGQZJmIv0L1rTSPYGDCsusyvbxLjM0fNgjwO7kOr9rhtZayegfCNttpQVSBh34wIB58DUTnbZUnK3aHLFvspwdd0Ge5tQwr0EuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZKjHZ+/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso68739115ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 14:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738622358; x=1739227158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DpVz/r6M+4jdUlj/0dtddbtyJ6bs+xAbBw0llf++aSI=;
        b=DZKjHZ+/zjEPtwJR8UsnstRp7o6PxeWhYznVsKpDZe1T73n5+TwP/w8Spkxw81vLjY
         g5blG7F26SaSX0iE4YiOSwYBldNm7LY+2tT4v7ieR5ZwXUytuW5ZX2a1WmechtddGiSS
         G4tEIMbENTiiYomLIaAURsVHCHgkJQ06MsxJMvMn6yPDnp+LFLOs1j+uslt8AorbmFuz
         YJ+7U/0UVJKALSJ0Gbbqy9UB5TW6hVPhwDTOHD5Qo551JTRgVWQE/phNtp7uvoPsQQnA
         G/fj3Ya+c9CjmwR1Ynvxmj7WT9z3X/rnA1KfZPMpFlGJjl+4R0ABXsbqbH2wfKPXW6/I
         w4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738622358; x=1739227158;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpVz/r6M+4jdUlj/0dtddbtyJ6bs+xAbBw0llf++aSI=;
        b=No9dBVmFwTin6vzBnrtgDApOzsqog6cYNn9Mvpom4zmtr7a0I3SFRgyJR/AMk2yZTd
         ygQ5rDLY07A9xmzr3Y7B2TFDDzblgyDbfGBxbItRe4T1LE+9DoIPMjz9MR+areMdvC0C
         BWSsP/3xfdc3W0SVKCS/Qr3spvEd+u6FG6bOIxLUxJEsGNhqMXMPnBAgg4kZoJ24OeUf
         sERPZEQ4ekCnLkCs//1THdSCOxC82D4fcbDfmYvWxos/8eGVUgRiSx0ZT048lBUldzda
         tnG7WFLbfejPXckvqfKSWcter2zerg21XOjBC2dsiAFJj6GNxLyjDBnHv7YldEdlJBGA
         owzg==
X-Forwarded-Encrypted: i=1; AJvYcCVmk9EBE4F5k8iDWMuTPHeDRjGvnNVbkRiDtLhOxVbiDtt4i/U9PaqiRPC8YF7fVOuAh8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgTH+TgPQLLRXo4e6HzvgmS9s09Kw8inYoTSd0PjZc7CGoqDOs
	XMjmkSgzZ2aQNEBd28OatauniZME5y9ApSX4NuZ8xi2nQKwUDWWzXp69WAfTOZyPhE4pI2dBI3l
	3f1dbTESs0tCBcdTy7VVJoQ==
X-Google-Smtp-Source: AGHT+IF97h5eMc5w+O4ZHZ7ijNLoTSeU5pPjnzCFRaJOKi+O14JUCiTrYoh8NH3BVvd4oKzPH0pY0w2f/PAfDZ65XA==
X-Received: from plbjz6.prod.google.com ([2002:a17:903:4306:b0:21d:de18:6ea9])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc4b:b0:215:72aa:693f with SMTP id d9443c01a7336-21dd7c44298mr388279915ad.9.1738622357760;
 Mon, 03 Feb 2025 14:39:17 -0800 (PST)
Date: Mon,  3 Feb 2025 22:39:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250203223916.1064540-1-almasrymina@google.com>
Subject: [PATCH net-next v3 0/6] Device memory TCP TX
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

v3: https://patchwork.kernel.org/project/netdevbpf/list/?series=929401&state=*
===

Address minor comments from RFCv2 and fix a few build warnings and
ynl-regen issues. No major changes.

RFC v2: https://patchwork.kernel.org/project/netdevbpf/list/?series=920056&state=*
=======

RFC v2 addresses much of the feedback from RFC v1. I plan on sending
something close to this as net-next  reopens, sending it slightly early
to get feedback if any.

Major changes:
--------------

- much improved UAPI as suggested by Stan. We now interpret the iov_base
  of the passed in iov from userspace as the offset into the dmabuf to
  send from. This removes the need to set iov.iov_base = NULL which may
  be confusing to users, and enables us to send multiple iovs in the
  same sendmsg() call. ncdevmem and the docs show a sample use of that.

- Removed the duplicate dmabuf iov_iter in binding->iov_iter. I think
  this is good improvment as it was confusing to keep track of
  2 iterators for the same sendmsg, and mistracking both iterators
  caused a couple of bugs reported in the last iteration that are now
  resolved with this streamlining.

- Improved test coverage in ncdevmem. Now muliple sendmsg() are tested,
  and sending multiple iovs in the same sendmsg() is tested.

- Fixed issue where dmabuf unmapping was happening in invalid context
  (Stan).

====================================================================

The TX path had been dropped from the Device Memory TCP patch series
post RFCv1 [1], to make that series slightly easier to review. This
series rebases the implementation of the TX path on top of the
net_iov/netmem framework agreed upon and merged. The motivation for
the feature is thoroughly described in the docs & cover letter of the
original proposal, so I don't repeat the lengthy descriptions here, but
they are available in [1].

Sending this series as RFC as the winder closure is immenient. I plan on
reposting as non-RFC once the tree re-opens, addressing any feedback
I receive in the meantime.

Full outline on usage of the TX path is detailed in the documentation
added in the first patch.

Test example is available via the kselftest included in the series as well.

The series is relatively small, as the TX path for this feature largely
piggybacks on the existing MSG_ZEROCOPY implementation.

Patch Overview:
---------------

1. Documentation & tests to give high level overview of the feature
   being added.

2. Add netmem refcounting needed for the TX path.

3. Devmem TX netlink API.

4. Devmem TX net stack implementation.

Testing:
--------

Testing is very similar to devmem TCP RX path. The ncdevmem test used
for the RX path is now augemented with client functionality to test TX
path.

* Test Setup:

Kernel: net-next with this RFC and memory provider API cherry-picked
locally.

Hardware: Google Cloud A3 VMs.

NIC: GVE with header split & RSS & flow steering support.

Performance results are not included with this version, unfortunately.
I'm having issues running the dma-buf exporter driver against the
upstream kernel on my test setup. The issues are specific to that
dma-buf exporter and do not affect this patch series. I plan to follow
up this series with perf fixes if the tests point to issues once they're
up and running.

Special thanks to Stan who took a stab at rebasing the TX implementation
on top of the netmem/net_iov framework merged. Parts of his proposal [2]
that are reused as-is are forked off into their own patches to give full
credit.

[1] https://lore.kernel.org/netdev/20240909054318.1809580-1-almasrymina@google.com/
[2] https://lore.kernel.org/netdev/20240913150913.1280238-2-sdf@fomichev.me/T/#m066dd407fbed108828e2c40ae50e3f4376ef57fd

Cc: sdf@fomichev.me
Cc: asml.silence@gmail.com
Cc: dw@davidwei.uk
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>
Cc: Samiullah Khawaja <skhawaja@google.com>


Mina Almasry (5):
  net: add devmem TCP TX documentation
  selftests: ncdevmem: Implement devmem TCP TX
  net: add get_netmem/put_netmem support
  net: devmem: Implement TX path
  net: devmem: make dmabuf unbinding scheduled work

Stanislav Fomichev (1):
  net: devmem: TCP tx netlink api

 Documentation/netlink/specs/netdev.yaml       |  12 +
 Documentation/networking/devmem.rst           | 144 ++++++++-
 include/linux/skbuff.h                        |  15 +-
 include/linux/skbuff_ref.h                    |   4 +-
 include/net/netmem.h                          |   3 +
 include/net/sock.h                            |   1 +
 include/uapi/linux/netdev.h                   |   1 +
 include/uapi/linux/uio.h                      |   6 +-
 net/core/datagram.c                           |  41 ++-
 net/core/devmem.c                             | 111 ++++++-
 net/core/devmem.h                             |  70 +++-
 net/core/netdev-genl-gen.c                    |  13 +
 net/core/netdev-genl-gen.h                    |   1 +
 net/core/netdev-genl.c                        |  66 +++-
 net/core/skbuff.c                             |  36 ++-
 net/core/sock.c                               |   8 +
 net/ipv4/tcp.c                                |  36 ++-
 net/vmw_vsock/virtio_transport_common.c       |   3 +-
 tools/include/uapi/linux/netdev.h             |   1 +
 .../selftests/drivers/net/hw/ncdevmem.c       | 300 +++++++++++++++++-
 20 files changed, 819 insertions(+), 53 deletions(-)

-- 
2.48.1.362.g079036d154-goog


