Return-Path: <kvm+bounces-67279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B4206D002CB
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30584306DC05
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F2E33D6C6;
	Wed,  7 Jan 2026 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="Sq0wj1q+"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42A2309EEB;
	Wed,  7 Jan 2026 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819978; cv=none; b=bVy1Yy7BJnuJxMg/1QinFqj9beS335dHfaLFP3Pr663op2hEg8jZndfxNmHnBscFBUIsusKkb5Ldm04brbzhzCopYey9ORHKsWirixKHeRJoJEeZ8/iFmzv/1RKsSfPRYU83qT2RThr5bEd0eou/B42DCeZy1P57Ie5Aifm8M78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819978; c=relaxed/simple;
	bh=FOJqPaYxG6cRyRs6ejw1IpRSh7w2Q4J+fibPs2sqeUo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=X4ueL9bdeCMWQMA3tgSr5vMAvaOzmDboGLwCrp5pdTEETcIK4fjdYa3+F6Yogbd4rXQBHGPKfnreKadu5GDipMDSyon8UxlZbq7vV5r5nFE6WPSWLKlvFDRmpBGnxjYM7QZgJ8IqQjCgY9v/zASzHWpYfVro7l3UaO0TKLgMwc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=Sq0wj1q+; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9F026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:05:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819959;
	bh=FOJqPaYxG6cRyRs6ejw1IpRSh7w2Q4J+fibPs2sqeUo=;
	h=From:To:Subject:Date;
	b=Sq0wj1q+rlEwwZt9jgxv/yVljqUaCReh9VY3Em/zhUji0zCrRingZT0CkWcBNuI6Q
	 AZuYp71AwnNvhJw/XHC0msGircmTSmO6hjU/qez8eKu58i/He7Sa4jAsSB/T2KHHcX
	 npd/pSUfoqe+C13OQYIqDLEg4Ig5gotGzQpZl+oA=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 0/9] tun/tap & vhost-net: apply qdisc backpressure on full ptr_ring to reduce TX drops
Date: Wed,  7 Jan 2026 22:04:39 +0100
Message-ID: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
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
patch series, the associated netdev queue is stopped before this happens - 
but only when a qdisc is attached. If no qdisc is present the existing 
behavior is preserved.

By applying proper backpressure, this change allows the connected qdisc to 
operate correctly, as reported in [1], and significantly improves 
performance in real-world scenarios, as demonstrated in our paper [2]. For 
example, we observed a 36% TCP throughput improvement for an OpenVPN 
connection between Germany and the USA.

At the same time, synthetic benchmarks (details below) show only minor 
theoretical performance impact:
(1) With the noqueue qdisc, the patched behavior matches the stock 
    implementation, as expected. In both configurations, a significant
    number of packets are dropped.
(2) pktgen benchmarks show a ~5-10% throughput reduction for TAP alone, 
    while no performance impact is observed for TAP + vhost-net. In both 
    cases, zero packet drops are observed.
(3) TCP benchmarks using iperf3 show no performance degradation for either 
    TAP or TAP combined with vhost-net.

This patch series touches tun/tap and vhost-net, as they share common 
logic and must be updated together. Modifying only one of them would break 
the others. The series is therefore structured as follows:
(1-2) ptr_ring:  Introduce new helpers, which are used by patches (3)
                 and (9).
(3)   tun/tap:   add a ptr_ring consume helper with netdev queue wakeup.
(4-8) vhost-net: introduce and switch to the new tun/tap ptr_ring 
                 wrappers with netdev queue wakeup.
(9)   tun/tap:   avoid ptr_ring tail-drop when a qdisc is present by 
                 stopping the netdev queue.

+-------------------------+-----------+---------------+----------------+
| pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
| Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
| 10M packets             |           |               |                |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
|           +-------------+-----------+---------------+----------------+
|           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
|  +        +-------------+-----------+---------------+----------------+
| vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+

+-------------------------+-----------+---------------+----------------+
| pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
| Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
| 10M packets,            |           |               |                |
| *4 threads*             |           |               |                |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 26 Kpps   | 26 Kpps       | 23 Kpps        |
|           +-------------+-----------+---------------+----------------+
|           | Lost        | 1535 Kpps | 1551 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 64 Kpps   | 63 Kpps       | 66 Kpps        |
|  +        +-------------+-----------+---------------+----------------+
| vhost-net | Lost        | 1550 Kpps | 1506 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+

+-----------------------+-------------+---------------+----------------+
| iperf3 TCP benchmarks | Stock       | Patched with  | Patched with   |
| to Debian VM          |             | noqueue qdisc | fq_codel qdisc |
| i5 6300HQ, 120s       |             |               |                |
+-----------------------+-------------+---------------+----------------+
| TAP                   | 1.71 Gbit/s | 1.71 Gbit/s   | 1.71 Gbit/s    |
+-----------------------+-------------+---------------+----------------+
| TAP + vhost-net       | 22.1 Gbit/s | 22.0 Gbit/s   | 22.0 Gbit/s    |
+-----------------------+-------------+---------------+----------------+

[1] Link: https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
[2] Link: https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
[3] Link: https://lore.kernel.org/r/174549940981.608169.4363875844729313831.stgit@firesoul
[4] Link: https://lore.kernel.org/r/176295323282.307447.14790015927673763094.stgit@firesoul

---
Changelog:
V7:
- Switch to an approach similar to veth [3] (excluding the recently fixed 
variant [4]), as suggested by MST, with minor adjustments discussed in V6
- Rename the cover-letter title
- Add multithreaded pktgen and iperf3 benchmarks, as suggested by Jason 
Wang
- Rework __ptr_ring_consume_created_space() so it can also be used after 
batched consume

V6: https://lore.kernel.org/netdev/20251120152914.1127975-1-simon.schippers@tu-dortmund.de/
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
---

Simon Schippers (9):
  ptr_ring: move free-space check into separate helper
  ptr_ring: add helper to detect newly freed space on consume
  tun/tap: add ptr_ring consume helper with netdev queue wakeup
  tun/tap: add batched ptr_ring consume functions with netdev queue
    wakeup
  tun/tap: add unconsume function for returning entries to ptr_ring
  tun/tap: add helper functions to check file type
  vhost-net: vhost-net: replace rx_ring with tun/tap ring wrappers
  tun/tap: drop get ring exports
  tun/tap & vhost-net: avoid ptr_ring tail-drop when qdisc is present

 drivers/net/tap.c        | 66 ++++++++++++++++++++++++---
 drivers/net/tun.c        | 99 ++++++++++++++++++++++++++++++++++++----
 drivers/vhost/net.c      | 92 ++++++++++++++++++++++++-------------
 include/linux/if_tap.h   | 16 +++++--
 include/linux/if_tun.h   | 18 ++++++--
 include/linux/ptr_ring.h | 27 ++++++++++-
 6 files changed, 263 insertions(+), 55 deletions(-)

--
2.43.0


