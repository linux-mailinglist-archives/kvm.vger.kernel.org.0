Return-Path: <kvm+bounces-56538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D727EB3F7E0
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 998F82C0102
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBA02EA753;
	Tue,  2 Sep 2025 08:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="RROp1G00"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542E2E7BC7;
	Tue,  2 Sep 2025 08:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800621; cv=none; b=D+M/3HDC9IHy9biwP2DzwUmCVEm7qsPMc+hR77OiVe/nlx35vVzdS8gBqCKbIXuNcrvOPsVFxkHexWpkB4RuWhEL5P3unseJWKfL5kSk1TI8ZNQML+bZzJVQ2kfzzI/GOwFrqoTwfWEwbxCiaL+s4ZQKK89FmRq3A4f3M2/eYNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800621; c=relaxed/simple;
	bh=cyJKkcqZqbk709afqt1BPhXGf6CjrosVwsdhTAJwy7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQ+i9q/mqE6Ym5G2SORMd8Y1WwTRxLd/UCZABY7LyEiBTH4+vpG+DJOIq22Ij4oSZgksrwafDHeMUpPMo8y2TWvGG4k1BNyfz7NZ18SpIIKBNU2bGr1I+/IvZvFeASTUGYtTqY8KzUUD421Z8dm/IWBztyEwEbYgvivXAp+lkAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=RROp1G00; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.tu-dortmund.de (rechenknecht2.kn.e-technik.tu-dortmund.de [129.217.186.41])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.9/8.18.1.10) with ESMTPSA id 58289x6R004012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Sep 2025 10:10:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756800607;
	bh=cyJKkcqZqbk709afqt1BPhXGf6CjrosVwsdhTAJwy7k=;
	h=From:To:Cc:Subject:Date;
	b=RROp1G00rTRqLopxLsfYpYJW0yfO4NfbPS3b4C1nyB/PX8DeJA/HqfA2BarlvKtVq
	 R4CJZnr8iLw068MHXJhdW/TTI1UcZmT3PnDUDr8js3fL3LJh+Dk4TXxKN7tUPcjIJJ
	 HipDZvSDC2Fv57wREnt0vBmXA8PVZogZbudnlDwI=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>
Subject: [PATCH net-next v4 0/4] TUN/TAP & vhost_net: netdev queue flow control to avoid ptr_ring tail drop
Date: Tue,  2 Sep 2025 10:09:53 +0200
Message-ID: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series deals with TUN/TAP and vhost_net which drop incoming 
SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
patch series, the associated netdev queue is stopped before this happens. 
This allows the connected qdisc to function correctly as reported by [1] 
and improves application-layer performance, see benchmarks.

This patch series includes TUN, TAP, and vhost_net because they share 
logic. Adjusting only one of them would break the others. Therefore, the 
patch series is structured as follows:
1. New ptr_ring_spare helper to check if the ptr_ring has spare capacity
2. Netdev queue flow control for TUN: Logic for stopping the queue upon 
full ptr_ring and waking the queue if ptr_ring has spare capacity
3. Additions for TAP: Similar logic for waking the queue
4. Additions for vhost_net: Calling TUN/TAP methods for waking the queue

Benchmarks ([2] & [3]):
- TUN: TCP throughput over real-world 120ms RTT OpenVPN connection 
improved by 36% (117Mbit/s vs 185 Mbit/s)
- TAP: TCP throughput to local qemu VM stays the same (2.2Gbit/s), an 
improvement by factor 2 at emulated 120ms RTT (98Mbit/s vs 198Mbit/s)
- TAP+vhost_net: TCP throughput to local qemu VM approx. the same 
(23.4Gbit/s vs 23.9Gbit/s), same performance at emulated 120ms RTT 
(200Mbit/s)
- TUN/TAP/TAP+vhost_net: Reduction of ptr_ring size to ~10 packets 
possible without losing performance

Possible future work:
- Introduction of Byte Queue Limits as suggested by Stephen Hemminger
- Adaption of the netdev queue flow control for ipvtap & macvtap

[1] Link: 
https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
[2] Link: 
https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
[3] Link: https://github.com/tudo-cni/nodrop

Links to previous versions:
V3: 
https://lore.kernel.org/netdev/20250825211832.84901-1-simon.schippers@tu-dortmund.de/T/#u
V2: 
https://lore.kernel.org/netdev/20250811220430.14063-1-simon.schippers@tu-dortmund.de/T/#u
V1: 
https://lore.kernel.org/netdev/20250808153721.261334-1-simon.schippers@tu-dortmund.de/T/#u

Changelog:
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



Simon Schippers (4):
  ptr_ring_spare: Helper to check if spare capacity of size cnt is
    available
  netdev queue flow control for TUN
  netdev queue flow control for TAP
  netdev queue flow control for vhost_net

 drivers/net/tap.c        | 28 ++++++++++++++++
 drivers/net/tun.c        | 39 ++++++++++++++++++++--
 drivers/vhost/net.c      | 34 +++++++++++++++----
 include/linux/if_tap.h   |  2 ++
 include/linux/if_tun.h   |  3 ++
 include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 168 insertions(+), 9 deletions(-)

-- 
2.43.0


