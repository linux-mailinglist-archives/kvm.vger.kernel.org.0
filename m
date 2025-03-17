Return-Path: <kvm+bounces-41207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 457F7A64B83
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2AAC3A5F29
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DF0235BF3;
	Mon, 17 Mar 2025 10:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ZKl24BFh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4AE22DFB4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742209092; cv=none; b=ogJhTESmJUz3B5kY2F6wrp0anKzQJ3LHmy5h+wn5N4CCRsTI3a4otoZv4juVDGKWf6nNZrQiIU0jAfkRQ6+d5QAaTnXFkOyMyWpChffc+x/Zrz2UI3jvLAZEM4nHxm+aVGy2JW2vZd79ikwZKRYcEIO1wKh/rHWaFnGnvxH3qBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742209092; c=relaxed/simple;
	bh=qsDMwGdZQLFJZ8Cpig7FzRSvbjMllkPDI2sN2I3QJ5A=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=jiUjOQEh/xNPISpzdWsfkNJhKbgMsJeSvWH1bfmziJwrBJ7p65heXUKTazsWetZe4rF5h+0KNvlh+CBWj7C77ZZg1ZLsYkyN+U5nvQGrdmKg5LMrUXv1RHbGsbtYbYXMkEz/7+zCR6XC8kxeehx1XXbukESCO8F/5xcBku2pANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ZKl24BFh; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22398e09e39so84997985ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742209089; x=1742813889; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KCvgTiEawu29sH4ByokBNvEWLF1KpXJnCBPg6/tj2M0=;
        b=ZKl24BFh7/WrPJbhaXx4SUqiPalOKmmAB95H5fV31eIpnHl0Mc3yNUihJV+/dvTvoi
         FbocVHJpF99L5+PyDcs1AXRab+uWFDT42FWXQVFADntNAr7Wafx0i/ivTj9uyREu7NuB
         0nGqaPRfSnXB2JR2kFX6NEpaxH8G0ZG2ymU6QCIQB5/DCmJ4T06um2dbyoSPbPzN6DQn
         3wQLzoURd2ZPyYGoNFg/FdFGF6x79XM6r2WppQjZsyOn+EYgsH9KPqo0zElXkPtRygVt
         jYXO26UuLxipMzMU1blkYhXLfnnzh/6FsVeOLTp2e+pYX6e8p1XbGLnKTVx8VSE4JhFg
         HzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742209089; x=1742813889;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCvgTiEawu29sH4ByokBNvEWLF1KpXJnCBPg6/tj2M0=;
        b=BqsFbuTUoqz+BX/I0/E49Gv/WwOsmupqqnZG/IvDSphEvZjoS2157qu2PUgfTABzj4
         Klm7bVzluYhPk5UTl4MDHhH3N7RYmnsraHgPeboP2X1+40wsOkDMYVk+BO2VImbKl90v
         X69G2o5tunPBRgTaB8ZbyOrpeBAz82Swzdjtl/ehGmfTySeK7OSA2r0hWX4+/oHD8Sv5
         dHrFu132neAeirK2wy8LQq1eSDl0D5mpRvZCF8Izy4Yyzsp7aAUKk3hXTMYSYnlSGlii
         bdl6Sf0shr1TccoZ1XNsa2sMTB1/DfeEA6kjIJFwVQ/Y5wh8ScxC5YcSTntZ4AcjJ+qT
         cFSQ==
X-Forwarded-Encrypted: i=1; AJvYcCW12vXotFvAUuLDwN/MUp28M2ge9WXenH/CRXBVTwdnLeC7dlL9vg4hChh8uo03PJrO6oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiUOeWXkjo+cOu5lf8xNU2QBonsJKzpA63Iy1EzVYOAKszyhXD
	KROJj7rAOMztjJU+EwiZJD4tC82VkikSXEkhulQAEaS90eXhosze26EFcd5RGU8=
X-Gm-Gg: ASbGncuz/I8HdbjnYLT5xxixe/2DESDpLlHzirTCFFXX7DIEB5fRHXlb+OcmUKbrzbD
	MrPFMBz64PQFpZl4HESJcbq1sayc4RY0lWlWmL71tGhGBItn4tkYT8sQU8rpNIn0QGCCkbIdsP4
	rFXh1Wf7GA+420YEXctD3X73Azd07vbku9P2uKGZsAXd1FIJPv5nwVHPckzjM3JGQRkMwHLxEEg
	NcIzoiTjv2Kvm4FbeCQ9fTZOBSOYWVf0OXns9jMtJZ3LEV8I2/Ts4N083Fj3kGEDacY76J5kdEf
	KcYDAQL3uILTyXdz1cCQhFJIOAEUu+JyIY6g4j0z4bxOpdIb
X-Google-Smtp-Source: AGHT+IHIemQ3oAfcEA3ILoOSCg5Zh3JtO67wmQnjQ93SNsixlgSzi1nAEcGtR/i7bSKLCV3BPKLOgg==
X-Received: by 2002:a05:6a21:394c:b0:1f5:80eb:846d with SMTP id adf61e73a8af0-1f5c117de5bmr16765553637.10.1742209089213;
        Mon, 17 Mar 2025 03:58:09 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-af56ea7c759sm5715282a12.59.2025.03.17.03.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:58:08 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net-next v11 00/10] tun: Introduce virtio-net hashing
 feature
Date: Mon, 17 Mar 2025 19:57:50 +0900
Message-Id: <20250317-rss-v11-0-4cacca92f31f@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC4A2GcC/4XSzW7cIBAH8FdZ+VxWAwwD+NT3qHrgs4ui2KntX
 W0U5d0zsfPhyofebJjfAKP/SzeXqZW5608v3VRubW7jwD9S/jh16RKGP0W0zAudAoWAoMU0z6J
 YbbPzpQZrO658mkpt97XNr24oixjKfel+886lzcs4Pa/9b3Ld505aAjgwSoI8S0RUSkgRHtqlP
 YznMfPXzxyeh3Y/p/Fx7XNTOyuNREmIZ0VASP+1+tMieGnWF9y0AJFIAzfLEZw6INwhhRtCRg6
 L16okKJQOyHyh9xduyDCqOlVyuQKYfED0iQxI8BsiRlEmDyFbcJUOyH4jpT5Osuv1UIFJMeZ8R
 O4baaANOUY2RKyGakWlD8jvkd2QZ5SrJeLpKFPiAUnYKbmlhheZaelMtjr4UOEf9roFaSp/rxz
 D5SNNXyHsT+tYlQaxXAdBVCQE9BGS7XmE+7yupTxMSSJeay3TLDyXY6wcn5p6DhOXxzAXwSc/t
 qU/5ey0NbZSIUdBSee8tykaF423plrEGK11xNd8fQNWIBGkNQMAAA==
X-Change-ID: 20240403-rss-e737d89efa77
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

virtio-net have two usage of hashes: one is RSS and another is hash
reporting. Conventionally the hash calculation was done by the VMM.
However, computing the hash after the queue was chosen defeats the
purpose of RSS.

Another approach is to use eBPF steering program. This approach has
another downside: it cannot report the calculated hash due to the
restrictive nature of eBPF.

Introduce the code to compute hashes to the kernel in order to overcome
thse challenges.

An alternative solution is to extend the eBPF steering program so that it
will be able to report to the userspace, but it is based on context
rewrites, which is in feature freeze. We can adopt kfuncs, but they will
not be UAPIs. We opt to ioctl to align with other relevant UAPIs (KVM
and vhost_net).

The patches for QEMU to use this new feature was submitted as RFC and
is available at:
https://patchew.org/QEMU/20250313-hash-v4-0-c75c494b495e@daynix.com/

This work was presented at LPC 2024:
https://lpc.events/event/18/contributions/1963/

V1 -> V2:
  Changed to introduce a new BPF program type.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v11:
- Added the missing code to free vnet_hash in patch
  "tap: Introduce virtio-net hash feature".
- Link to v10: https://lore.kernel.org/r/20250313-rss-v10-0-3185d73a9af0@daynix.com

Changes in v10:
- Split common code and TUN/TAP-specific code into separate patches.
- Reverted a spurious style change in patch "tun: Introduce virtio-net
  hash feature".
- Added a comment explaining disable_ipv6 in tests.
- Used AF_PACKET for patch "selftest: tun: Add tests for
  virtio-net hashing". I also added the usage of FIXTURE_VARIANT() as
  the testing function now needs access to more variant-specific
  variables.
- Corrected the message of patch "selftest: tun: Add tests for
  virtio-net hashing"; it mentioned validation of configuration but
  it is not scope of this patch.
- Expanded the description of patch "selftest: tun: Add tests for
  virtio-net hashing".
- Added patch "tun: Allow steering eBPF program to fall back".
- Changed to handle TUNGETVNETHASHCAP before taking the rtnl lock.
- Removed redundant tests for tun_vnet_ioctl().
- Added patch "selftest: tap: Add tests for virtio-net ioctls".
- Added a design explanation of ioctls for extensibility and migration.
- Removed a few branches in patch
  "vhost/net: Support VIRTIO_NET_F_HASH_REPORT".
- Link to v9: https://lore.kernel.org/r/20250307-rss-v9-0-df76624025eb@daynix.com

Changes in v9:
- Added a missing return statement in patch
  "tun: Introduce virtio-net hash feature".
- Link to v8: https://lore.kernel.org/r/20250306-rss-v8-0-7ab4f56ff423@daynix.com

Changes in v8:
- Disabled IPv6 to eliminate noises in tests.
- Added a branch in tap to avoid unnecessary dissection when hash
  reporting is disabled.
- Removed unnecessary rtnl_lock().
- Extracted code to handle new ioctls into separate functions to avoid
  adding extra NULL checks to the code handling other ioctls.
- Introduced variable named "fd" to __tun_chr_ioctl().
- s/-/=/g in a patch message to avoid confusing Git.
- Link to v7: https://lore.kernel.org/r/20250228-rss-v7-0-844205cbbdd6@daynix.com

Changes in v7:
- Ensured to set hash_report to VIRTIO_NET_HASH_REPORT_NONE for
  VHOST_NET_F_VIRTIO_NET_HDR.
- s/4/sizeof(u32)/ in patch "virtio_net: Add functions for hashing".
- Added tap_skb_cb type.
- Rebased.
- Link to v6: https://lore.kernel.org/r/20250109-rss-v6-0-b1c90ad708f6@daynix.com

Changes in v6:
- Extracted changes to fill vnet header holes into another series.
- Squashed patches "skbuff: Introduce SKB_EXT_TUN_VNET_HASH", "tun:
  Introduce virtio-net hash reporting feature", and "tun: Introduce
  virtio-net RSS" into patch "tun: Introduce virtio-net hash feature".
- Dropped the RFC tag.
- Link to v5: https://lore.kernel.org/r/20241008-rss-v5-0-f3cf68df005d@daynix.com

Changes in v5:
- Fixed a compilation error with CONFIG_TUN_VNET_CROSS_LE.
- Optimized the calculation of the hash value according to:
  https://git.dpdk.org/dpdk/commit/?id=3fb1ea032bd6ff8317af5dac9af901f1f324cab4
- Added patch "tun: Unify vnet implementation".
- Dropped patch "tap: Pad virtio header with zero".
- Added patch "selftest: tun: Test vnet ioctls without device".
- Reworked selftests to skip for older kernels.
- Documented the case when the underlying device is deleted and packets
  have queue_mapping set by TC.
- Reordered test harness arguments.
- Added code to handle fragmented packets.
- Link to v4: https://lore.kernel.org/r/20240924-rss-v4-0-84e932ec0e6c@daynix.com

Changes in v4:
- Moved tun_vnet_hash_ext to if_tun.h.
- Renamed virtio_net_toeplitz() to virtio_net_toeplitz_calc().
- Replaced htons() with cpu_to_be16().
- Changed virtio_net_hash_rss() to return void.
- Reordered variable declarations in virtio_net_hash_rss().
- Removed virtio_net_hdr_v1_hash_from_skb().
- Updated messages of "tap: Pad virtio header with zero" and
  "tun: Pad virtio header with zero".
- Fixed vnet_hash allocation size.
- Ensured to free vnet_hash when destructing tun_struct.
- Link to v3: https://lore.kernel.org/r/20240915-rss-v3-0-c630015db082@daynix.com

Changes in v3:
- Reverted back to add ioctl.
- Split patch "tun: Introduce virtio-net hashing feature" into
  "tun: Introduce virtio-net hash reporting feature" and
  "tun: Introduce virtio-net RSS".
- Changed to reuse hash values computed for automq instead of performing
  RSS hashing when hash reporting is requested but RSS is not.
- Extracted relevant data from struct tun_struct to keep it minimal.
- Added kernel-doc.
- Changed to allow calling TUNGETVNETHASHCAP before TUNSETIFF.
- Initialized num_buffers with 1.
- Added a test case for unclassified packets.
- Fixed error handling in tests.
- Changed tests to verify that the queue index will not overflow.
- Rebased.
- Link to v2: https://lore.kernel.org/r/20231015141644.260646-1-akihiko.odaki@daynix.com

---
Akihiko Odaki (10):
      virtio_net: Add functions for hashing
      net: flow_dissector: Export flow_keys_dissector_symmetric
      tun: Allow steering eBPF program to fall back
      tun: Add common virtio-net hash feature code
      tun: Introduce virtio-net hash feature
      tap: Introduce virtio-net hash feature
      selftest: tun: Test vnet ioctls without device
      selftest: tun: Add tests for virtio-net hashing
      selftest: tap: Add tests for virtio-net ioctls
      vhost/net: Support VIRTIO_NET_F_HASH_REPORT

 Documentation/networking/tuntap.rst  |   7 +
 drivers/net/Kconfig                  |   1 +
 drivers/net/ipvlan/ipvtap.c          |   2 +-
 drivers/net/macvtap.c                |   2 +-
 drivers/net/tap.c                    |  78 +++++-
 drivers/net/tun.c                    |  90 +++++--
 drivers/net/tun_vnet.h               | 155 ++++++++++-
 drivers/vhost/net.c                  |  68 ++---
 include/linux/if_tap.h               |   4 +-
 include/linux/skbuff.h               |   3 +
 include/linux/virtio_net.h           | 188 ++++++++++++++
 include/net/flow_dissector.h         |   1 +
 include/uapi/linux/if_tun.h          |  82 ++++++
 net/core/flow_dissector.c            |   3 +-
 net/core/skbuff.c                    |   4 +
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/tap.c    |  97 ++++++-
 tools/testing/selftests/net/tun.c    | 491 ++++++++++++++++++++++++++++++++++-
 18 files changed, 1194 insertions(+), 84 deletions(-)
---
base-commit: dd83757f6e686a2188997cb58b5975f744bb7786
change-id: 20240403-rss-e737d89efa77
prerequisite-change-id: 20241230-tun-66e10a49b0c7:v6
prerequisite-patch-id: 871dc5f146fb6b0e3ec8612971a8e8190472c0fb
prerequisite-patch-id: 2797ed249d32590321f088373d4055ff3f430a0e
prerequisite-patch-id: ea3370c72d4904e2f0536ec76ba5d26784c0cede
prerequisite-patch-id: 837e4cf5d6b451424f9b1639455e83a260c4440d
prerequisite-patch-id: ea701076f57819e844f5a35efe5cbc5712d3080d
prerequisite-patch-id: 701646fb43ad04cc64dd2bf13c150ccbe6f828ce
prerequisite-patch-id: 53176dae0c003f5b6c114d43f936cf7140d31bb5
prerequisite-change-id: 20250116-buffers-96e14bf023fc:v2
prerequisite-patch-id: 25fd4f99d4236a05a5ef16ab79f3e85ee57e21cc

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


