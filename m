Return-Path: <kvm+bounces-50133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D27AE211C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AB933AF223
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D902E6135;
	Fri, 20 Jun 2025 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XYhBzksc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E12E3B14
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441230; cv=none; b=Is3Y9r6HDk30ED4u03dCJkWpVdGBCzDfpzfC6u3+dV/nVYQ9BkA1AVgxXaY76hzMfKTeTwhTthS+w5DlhdxbXJgq9XpFGgEwfNqakmhqCPfA3cffHiSnslkMAPxLfTZkxdeEP/ID1dnOpbx7okrprCMm6LdUeCLz4DbQO6BiwyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441230; c=relaxed/simple;
	bh=JyR5ApjjHltRSIOWdEdyNfdg74uCGz8cpfpWdy659B0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XyYs5q2FYputoJAg1BpSgj6mNG/a5TKzn6BMZ3NyT3UvT2Qc2Q2mmz35M/OdNthVX7fvLMf+fxlN9ze8bJFJV3n3hyXGhB5WvrjGzYkXtQsnMc2vyn7fRsMfb9p6hsS5Vo4lQXiU3/+5FsZjiu/EsN49Os363SJB3e+TKHmrr6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XYhBzksc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eYjr+DE+i7naenhD6oUtB+o+dSFFV7s82NMBEs65ov8=;
	b=XYhBzkscIT7LIEBd6OPEBdiEJzeg5INhoo5jl3UcRsWXaA7hRUQbAzmYICTDlKoHWTWEPh
	ZyI/eBNRpAAOhFv1z92n+N+2g3Lzua91XCD2QHh4zy19Tz2GoSvr4LrYbNLO8MTmAlNas0
	ewSte6xF7maHKEIcHvU7bY/Vxd+BjLw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-sKU2Z5wKMtevSHWskxutsg-1; Fri,
 20 Jun 2025 13:40:24 -0400
X-MC-Unique: sKU2Z5wKMtevSHWskxutsg-1
X-Mimecast-MFC-AGG-ID: sKU2Z5wKMtevSHWskxutsg_1750441222
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C8851800287;
	Fri, 20 Jun 2025 17:40:21 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4990719560AB;
	Fri, 20 Jun 2025 17:40:15 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kvm@vger.kernel.org
Subject: [PATCH v5 net-next 0/9] virtio: introduce GSO over UDP tunnel
Date: Fri, 20 Jun 2025 19:39:44 +0200
Message-ID: <cover.1750436464.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Some virtualized deployments use UDP tunnel pervasively and are impacted
negatively by the lack of GSO support for such kind of traffic in the
virtual NIC driver.

The virtio_net specification recently introduced support for GSO over
UDP tunnel, this series updates the virtio implementation to support
such a feature.

Currently the kernel virtio support limits the feature space to 64,
while the virtio specification allows for a larger number of features.
Specifically the GSO-over-UDP-tunnel-related virtio features use bits
65-69.

The first four patches in this series rework the virtio and vhost
feature support to cope with up to 128 bits. The limit is set by
a define and could be easily raised in future, as needed.

This implementation choice is aimed at keeping the code churn as
limited as possible. For the same reason, only the virtio_net driver is
reworked to leverage the extended feature space; all other
virtio/vhost drivers are unaffected, but could be upgraded to support
the extended features space in a later time.

The last four patches bring in the actual GSO over UDP tunnel support.
As per specification, some additional fields are introduced into the
virtio net header to support the new offload. The presence of such
fields depends on the negotiated features.

New helpers are introduced to convert the UDP-tunneled skb metadata to
an extended virtio net header and vice versa. Such helpers are used by
the tun and virtio_net driver to cope with the newly supported offloads.

Tested with basic stream transfer with all the possible permutations of
host kernel/qemu/guest kernel with/without GSO over UDP tunnel support.

This is also are available in the Git repository at:

git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_20_06_2025

Ideally both the net-next tree and the vhost tree could pull from the
above.

---
v4 -> v5:
  - added new patch 1/9 to avoid kdoc issues
  - encapsulate guest features guessing in new tap helper
  - cleaned-up SET_FEATURES_ARRAY
  - a few checkpatch fixes
v4: https://lore.kernel.org/netdev/cover.1750176076.git.pabeni@redhat.com/

v3 -> v4:
  - vnet sockopt cleanup
  - fixed offset for UDP-tunnel related field
  - use dev->features instead of flags
v3: https://lore.kernel.org/netdev/cover.1749210083.git.pabeni@redhat.com/

v2 -> v3:
  - uint128_t -> u64[2]
  - dropped related ifdef
  - define and use vnet_hdr with tunnel layouts
v2: https://lore.kernel.org/netdev/cover.1748614223.git.pabeni@redhat.com/

v1 -> v2:
  - fix build failures
  - many comment clarification
  - changed the vhost_net ioctl API
  - fixed some hdr <> skb helper bugs
v1: https://lore.kernel.org/netdev/cover.1747822866.git.pabeni@redhat.com/

Paolo Abeni (9):
  scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
  virtio: introduce extended features
  virtio_pci_modern: allow configuring extended features
  vhost-net: allow configuring extended features
  virtio_net: add supports for extended offloads
  net: implement virtio helpers to handle UDP GSO tunneling.
  virtio_net: enable gso over UDP tunnel support.
  tun: enable gso over UDP tunnel support.
  vhost/net: enable gso over UDP tunnel support.

 drivers/net/tun.c                      |  58 ++++++--
 drivers/net/tun_vnet.h                 | 101 +++++++++++--
 drivers/net/virtio_net.c               | 110 +++++++++++---
 drivers/vhost/net.c                    |  94 +++++++++---
 drivers/vhost/vhost.c                  |   2 +-
 drivers/vhost/vhost.h                  |   4 +-
 drivers/virtio/virtio.c                |  43 +++---
 drivers/virtio/virtio_debug.c          |  27 ++--
 drivers/virtio/virtio_pci_modern.c     |  10 +-
 drivers/virtio/virtio_pci_modern_dev.c |  69 +++++----
 include/linux/virtio.h                 |   9 +-
 include/linux/virtio_config.h          |  43 +++---
 include/linux/virtio_features.h        |  88 +++++++++++
 include/linux/virtio_net.h             | 197 ++++++++++++++++++++++++-
 include/linux/virtio_pci_modern.h      |  43 +++++-
 include/uapi/linux/if_tun.h            |   9 ++
 include/uapi/linux/vhost.h             |   7 +
 include/uapi/linux/vhost_types.h       |   5 +
 include/uapi/linux/virtio_net.h        |  33 +++++
 scripts/lib/kdoc/kdoc_parser.py        |   1 +
 20 files changed, 789 insertions(+), 164 deletions(-)
 create mode 100644 include/linux/virtio_features.h

-- 
2.49.0


