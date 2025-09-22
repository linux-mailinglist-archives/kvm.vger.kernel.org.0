Return-Path: <kvm+bounces-58419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8D4B9374F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 653B319081F4
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B8631CA4E;
	Mon, 22 Sep 2025 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="KYjzm+1j"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74509189F20;
	Mon, 22 Sep 2025 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579431; cv=none; b=Mz6qD4vCr6D5JO1ezlnu9ED9ThViruRFpPH1QSVAm+f2fmsyfOMvx1TTYuSh6cz8tNBQxMh119aHe1pzLcdGJbJu4HSlXO3djkSLW+Y+mLa/EjmGObZATb0we31e3j0pffWzNq5/4vGNdcxYtJ2EE4e1t3WwPJiBZBswZrJMJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579431; c=relaxed/simple;
	bh=nmyEGiL0XcP3DsM0BryU/XYIgJ1RzI+qJ7IJRoiaqm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hCgNdRQaiHqiFpIj2KK3q4wdYorJe2UpX7B/jqtwOwJ7xwepoe+hK6dr/G0pTPr1Po5dwcJs6Jd3KYeRRREZYS/XfkrkzdoLJNirI1I9foZ7uHm7nWOnca6cT2tHSLNezDwUQHFPXMGx4GbkkLwaO/SKnVrBppG68wO+fO45dYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=KYjzm+1j; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4eX003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579425;
	bh=nmyEGiL0XcP3DsM0BryU/XYIgJ1RzI+qJ7IJRoiaqm8=;
	h=From:To:Cc:Subject:Date;
	b=KYjzm+1jLJPnLgbwrCx9bWuIgZpixpvgvNcul6XMI35pal3ZAWYMRR/Y0gcugaS3v
	 sFFF97BDScUJWHN836FNSc7Digv3wyrG5kAm/SXG9lG27GP89KlO2du8nzvS2pKxkj
	 gawFCwsZQ382rjtSwwoAhvM7QymI4JbSMYqkYXCg=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>
Subject: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow control to avoid ptr_ring tail drop
Date: Tue, 23 Sep 2025 00:15:45 +0200
Message-ID: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series deals with TUN, TAP and vhost_net which drop incoming 
SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
patch series, the associated netdev queue is stopped before this happens. 
This allows the connected qdisc to function correctly as reported by [1] 
and improves application-layer performance, see our paper [2]. Meanwhile 
the theoretical performance differs only slightly:

+------------------------+----------+----------+
| pktgen benchmarks      | Stock    | Patched  |
| i5 6300HQ, 20M packets |          |          |
+------------------------+----------+----------+
| TAP                    | 2.10Mpps | 1.99Mpps |
+------------------------+----------+----------+
| TAP+vhost_net          | 6.05Mpps | 6.14Mpps |
+------------------------+----------+----------+
| Note: Patched had no TX drops at all,        |
| while stock suffered numerous drops.         |
+----------------------------------------------+

This patch series includes TUN, TAP, and vhost_net because they share 
logic. Adjusting only one of them would break the others. Therefore, the 
patch series is structured as follows:
1+2: New ptr_ring helpers for 3 & 4
3: TUN & TAP: Stop netdev queue upon reaching a full ptr_ring
4: TUN & TAP: Wake netdev queue after consuming an entry
5+6+7: TUN & TAP: ptr_ring wrappers and other helpers to be called by 
vhost_net
8: vhost_net: Call the wrappers & helpers

Possible future work:
- Introduction of Byte Queue Limits as suggested by Stephen Hemminger
- Adaption of the netdev queue flow control for ipvtap & macvtap

[1] Link: 
https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
[2] Link: 
https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf

Links to previous versions:
V4: 
https://lore.kernel.org/netdev/20250902080957.47265-1-simon.schippers@tu-dortmund.de/T/#u
V3: 
https://lore.kernel.org/netdev/20250825211832.84901-1-simon.schippers@tu-dortmund.de/T/#u
V2: 
https://lore.kernel.org/netdev/20250811220430.14063-1-simon.schippers@tu-dortmund.de/T/#u
V1: 
https://lore.kernel.org/netdev/20250808153721.261334-1-simon.schippers@tu-dortmund.de/T/#u

Changelog:
V4 -> V5:
- Stop the netdev queue prior to producing the final fitting ptr_ring entry
-> Ensures the consumer has the latest netdev queue state, making it safe 
to wake the queue
-> Resolves an issue in vhost_net where the netdev queue could remain 
stopped despite being empty
-> For TUN/TAP, the netdev queue no longer needs to be woken in the 
blocking loop
-> Introduces new helpers __ptr_ring_full_next and 
__ptr_ring_will_invalidate for this purpose

- vhost_net now uses wrappers of TUN/TAP for ptr_ring consumption rather 
than maintaining its own rx_ring pointer

V3 -> V4:
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
- Use safer logic for vhost_net using RCU read locks to access TUN/TAP data

V2 -> V3: Added support for TAP and TAP+vhost_net.

V1 -> V2: Removed NETDEV_TX_BUSY return case in tun_net_xmit and removed 
unnecessary netif_tx_wake_queue in tun_ring_recv.

Thanks,
Simon :)

Simon Schippers (8):
  __ptr_ring_full_next: Returns if ring will be full after next
    insertion
  Move the decision of invalidation out of __ptr_ring_discard_one
  TUN, TAP & vhost_net: Stop netdev queue before reaching a full
    ptr_ring
  TUN & TAP: Wake netdev queue after consuming an entry
  TUN & TAP: Provide ptr_ring_consume_batched wrappers for vhost_net
  TUN & TAP: Provide ptr_ring_unconsume wrappers for vhost_net
  TUN & TAP: Methods to determine whether file is TUN/TAP for vhost_net
  vhost_net: Replace rx_ring with calls of TUN/TAP wrappers

 drivers/net/tap.c        | 115 +++++++++++++++++++++++++++++++--
 drivers/net/tun.c        | 136 +++++++++++++++++++++++++++++++++++----
 drivers/vhost/net.c      |  90 +++++++++++++++++---------
 include/linux/if_tap.h   |  15 +++++
 include/linux/if_tun.h   |  18 ++++++
 include/linux/ptr_ring.h |  54 +++++++++++++---
 6 files changed, 367 insertions(+), 61 deletions(-)

-- 
2.43.0


