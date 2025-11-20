Return-Path: <kvm+bounces-63878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B07DCC75069
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id DF98631040
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CA03A9C06;
	Thu, 20 Nov 2025 15:30:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE2D36C0C1;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652611; cv=none; b=HAKeu6NY6o2ctwBjcDiRg0Rk9BnvoUSZjqkX8uXOOeS7br/JE+z6o+VkAXHkmN+x1O8sZJuNKFuEEMUVLhJGz7AHkGcsCZHX5AYI9ZrD1qSX9oGJ5OTVIaBnKlcr/n/0kD/eTNtJ90rFsOr7jL6isepowsEfbWQJ50/D4me2FZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652611; c=relaxed/simple;
	bh=6EeIOj0G8SMRpDz7jx8AmBg6UIHfQTAT0QT+vXDOdQo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=l+DPA/PdjhKwViYxFW/Us+YE9WxD8N3ZUCmfL9keUCm0y2wPZ8zflZDZT4pjYDI+X4W6W84VxOKyPOSskigmHujwqSZC2ycuWjnv1XLdlwhwAKhQC61G2YlH4AdxcQG+HHKOrWTOfdc+MyhUCL2yb6hxkoA/tb7R978xxK821Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu86005406
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 16:29:56 +0100 (CET)
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v6 0/8] tun/tap & vhost-net: netdev queue flow control to avoid ptr_ring tail drop
Date: Thu, 20 Nov 2025 16:29:05 +0100
Message-ID: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series deals with tun/tap and vhost-net which drop incoming 
SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
patch series, the associated netdev queue is stopped before this happens. 
This allows the connected qdisc to function correctly as reported by [1] 
and improves application-layer performance, see our paper [2]. Meanwhile 
the theoretical performance differs only slightly:

+--------------------------------+-----------+----------+
| pktgen benchmarks to Debian VM | Stock     | Patched  |
| i5 6300HQ, 20M packets         |           |          |
+-----------------+--------------+-----------+----------+
| TAP             | Transmitted  | 195 Kpps  | 183 Kpps |
|                 +--------------+-----------+----------+
|                 | Lost         | 1615 Kpps | 0 pps    |
+-----------------+--------------+-----------+----------+
| TAP+vhost_net   | Transmitted  | 589 Kpps  | 588 Kpps |
|                 +--------------+-----------+----------+
|                 | Lost         | 1164 Kpps | 0 pps    |
+-----------------+--------------+-----------+----------+

This patch series includes tun/tap, and vhost-net because they share 
logic. Adjusting only one of them would break the others. Therefore, the 
patch series is structured as follows:
1+2: new ptr_ring helpers for 3
3: tun/tap: tun/tap: add synchronized ring produce/consume with queue 
management
4+5+6: tun/tap: ptr_ring wrappers and other helpers to be called by 
vhost-net
7: tun/tap & vhost-net: only now use the previous implemented functions to 
not break git bisect
8: tun/tap: drop get ring exports (not used anymore)

Possible future work:
- Introduction of Byte Queue Limits as suggested by Stephen Hemminger
- Adaption of the netdev queue flow control for ipvtap & macvtap

[1] Link: https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
[2] Link: https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf

Changelog:
V6:
General:
- Major adjustments to the descriptions. Special thanks to Jon Kohler!
- Fix git bisect by moving most logic into dedicated functions and only 
start using them in patch 7.
- Moved the main logic of the coupled producer and consumer into a single 
patch to avoid a chicken-and-egg dependency between commits :-)
- Rebased to 6.18-rc5 and ran benchmarks again that now also include lost 
packets (previously I missed a 0, so all benchmark results were higher by 
factor 10...).
- Also include the benchmark in patch 7.

Producer:
- Move logic into the new helper tun_ring_produce()
- Added a smp_rmb() paired with the consumer, ensuring freed space of the 
consumer is visible
- Assume that ptr_ring is not full when __ptr_ring_full_next() is called

Consumer:
- Use an unpaired smp_rmb() instead of barrier() to ensure that the 
netdev_tx_queue_stopped() call completes before discarding
- Also wake the netdev queue if it was stopped before discarding and then 
becomes empty
-> Fixes race with producer as identified by MST in V5
-> Waking the netdev queues upon resize is not required anymore
- Use __ptr_ring_consume_created_space() instead of messing with ptr_ring 
internals
-> Batched consume now just calls 
__tun_ring_consume()/__tap_ring_consume() in a loop
- Added an smp_wmb() before waking the netdev queue which is paired with 
the smp_rmb() discussed above

V5: https://lore.kernel.org/netdev/20250922221553.47802-1-simon.schippers@tu-dortmund.de/T/#u
- Stop the netdev queue prior to producing the final fitting ptr_ring entry
-> Ensures the consumer has the latest netdev queue state, making it safe 
to wake the queue
-> Resolves an issue in vhost-net where the netdev queue could remain 
stopped despite being empty
-> For TUN/TAP, the netdev queue no longer needs to be woken in the 
blocking loop
-> Introduces new helpers __ptr_ring_full_next and 
__ptr_ring_will_invalidate for this purpose
- vhost-net now uses wrappers of TUN/TAP for ptr_ring consumption rather 
than maintaining its own rx_ring pointer

V4: https://lore.kernel.org/netdev/20250902080957.47265-1-simon.schippers@tu-dortmund.de/T/#u
- Target net-next instead of net
- Changed to patch series instead of single patch
- Changed to new title from old title
"TUN/TAP: Improving throughput and latency by avoiding SKB drops"
- Wake netdev queue with new helpers wake_netdev_queue when there is any 
spare capacity in the ptr_ring instead of waiting for it to be empty
- Use tun_file instead of tun_struct in tun_ring_recv as a more consistent 
logic
- Use smp_wmb() and smp_rmb() barrier pair, which avoids any packet drops 
that happened rarely before
- Use safer logic for vhost-net using RCU read locks to access TUN/TAP data

V3: https://lore.kernel.org/netdev/20250825211832.84901-1-simon.schippers@tu-dortmund.de/T/#u
- Added support for TAP and TAP+vhost-net.

V2: https://lore.kernel.org/netdev/20250811220430.14063-1-simon.schippers@tu-dortmund.de/T/#u
- Removed NETDEV_TX_BUSY return case in tun_net_xmit and removed 
unnecessary netif_tx_wake_queue in tun_ring_recv.

V1: https://lore.kernel.org/netdev/20250808153721.261334-1-simon.schippers@tu-dortmund.de/T/#u

Thanks,
Simon :)

Simon Schippers (8):
  ptr_ring: add __ptr_ring_full_next() to predict imminent fullness
  ptr_ring: add helper to check if consume created space
  tun/tap: add synchronized ring produce/consume with queue management
  tun/tap: add batched ring consume function
  tun/tap: add uncomsume function for returning entries to ring
  tun/tap: add helper functions to check file type
  tun/tap & vhost-net: use {tun|tap}_ring_{consume|produce} to avoid
    tail drops
  tun/tap: drop get ring exports

 drivers/net/tap.c        | 106 +++++++++++++++++++++++++--
 drivers/net/tun.c        | 154 +++++++++++++++++++++++++++++++++++----
 drivers/vhost/net.c      |  92 +++++++++++++++--------
 include/linux/if_tap.h   |  16 +++-
 include/linux/if_tun.h   |  18 ++++-
 include/linux/ptr_ring.h |  42 +++++++++++
 6 files changed, 372 insertions(+), 56 deletions(-)

-- 
2.43.0


