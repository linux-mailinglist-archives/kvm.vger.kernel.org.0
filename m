Return-Path: <kvm+bounces-40227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB13EA546FD
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01C3C162B54
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 09:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D6920ADCF;
	Thu,  6 Mar 2025 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="XKl0PTF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3762220ADC9
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741255024; cv=none; b=GAG8z65ujdIT0kyWAz2nBK4tiAXlTxSUX16ctCL/yGTjRZ+yiuBOuSoWwGluKFNRUFa/qU6dnZOyiAVn6ZIIw2DUjumFJSelm+DzWcRBRC86qyB48LJt2CUQ6n54sN41yreaebyGSrynyqKIL8rUhYlxQFy17khNtVIr+fKQe3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741255024; c=relaxed/simple;
	bh=8nXRTGudzBBRfx66S5WuBv+BBtiXafaeFQXEswlaDnY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=KgpjLUGkP0x199vmKteFy9I5ZA8jOGnENugEcKeuzeTO9bod7/gAgheXetO5eO5OQkmlt4cabzv3/2A0vv3Ks09XgwnNtq2+W/oBPhAqTWCOPfXl7Mhl9lDu9+FI0NgQ4e8gEZjvsZLqDHrWT3ZMq6O9ikz7jqZrVn+8UF9rMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=XKl0PTF0; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223378e2b0dso5430185ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 01:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741255020; x=1741859820; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+1Q1NyitEWr4IZ0KCgYL2Tz8PJ2srBtknby9HFciIus=;
        b=XKl0PTF0QDgQ3pEkSAZXmAz4DxU0bDJLhSCUzWlzLm6/Tj3f46HHPPuT6VIkeEEuVp
         C2uyUuR5brWIOHRmvmJnp3UOlNewyGniYYY54fZQTwQUkCek7i/5fwYLvAHZZq8gZaXM
         351rl/eVReKewj61M3BniMU0qeH7gyen064WoLT5mkanYVLFV/POnDgRnrLQ3kXCqpfk
         y73WeD/fWCtWzQBX67pUJHpAvEL9GVuUoxLV8OeC2T82ohp3P//dfQgZIbmn1cEx6mnH
         Cpd0K7Gh5pFLexjsUOAxa8Zr2HK5sYMqKiqivCr0OFauD7GHnU8uDZqLIkp46BaZVW2q
         +1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741255020; x=1741859820;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+1Q1NyitEWr4IZ0KCgYL2Tz8PJ2srBtknby9HFciIus=;
        b=lOCGILFvmCov+eoDiw0Iqy+/vLBwqXtoi5dUAxcAvq8vH6gnd/iLFbRMNt+h94kDtU
         D8s0e/w/LBZxEiQGUfWcAs0uYLS5LFvxBOMtLAc1hpf6hDPWy/TRlBdjoGLSpLirhFEP
         tNeXEOONDX90q+ArVkYZvcqWb/0SZVawdKbiq3jdJPXFgvjh0ebVtD/3K/gsolWpCv9/
         E0hQn23xJfYuF1Rqm6z0Gw7JI19NDL9yBNYbq1FZA+lrWF7EA/uIMi0WsBxa3MscTwEx
         dF0yBYvBkapDnUTGEGfYN29IGnojGR2v1UNKFMuus/oslgm9RJJpru2MXF5kWvks/K6c
         wCVg==
X-Forwarded-Encrypted: i=1; AJvYcCVcBtJ8idTjGHYVcHzZbc+ENyqBha5Y4c0eHRSLGYUnKub//CRGChGlWot7WCFG7rRT6qw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzTrj+9Ztppv4RS/e/SroVBDJhBaqcJG+gEmJk+l51VqGnPLG4
	8Vt6fmzIhrYxR9dLjs/pHhuNHftMv7dGNHTOmxnd657wCzwPjzIPkGSf8h1+3yxyEn+aTKcFCIp
	sL94=
X-Gm-Gg: ASbGncuFvPZr2Tvv1QjR3piHA3lgdYAkFMF8u9j8rMZmIKwk/VtZxmfc2quKGQovMtr
	9YYXW2TT7qv5dtN93Ce2ySD1OFIng13AlFAUhItpXn9HwzEXFhPOEz1cyipAr0VxsV7zvY3AweF
	C+npM8gtnI49YJPUMh898XjI1a3FSWGZSrwlqWLMG6zUfwjKxDbSbu2ppdC8QulC0i7aDo029Mj
	aWBOc5sllgBQYjpD+PggsvnkTBrkIt1SpZSdeiQdbPuBcQaYNuQk0puvBJiangeu8GcM1IAc5zw
	ZUKrDwP9fL++h0ElSvHlmiy7D0uI4Uiq8v8xgXThTWGg2a1g
X-Google-Smtp-Source: AGHT+IHXeng5qGtVnY36Dm4C6gPvAiJUnMMUTbAF4BmiVlWPS+BPqS54LKH0wpj1Sfm2RVks4zC/qA==
X-Received: by 2002:a17:902:e891:b0:223:47e4:d288 with SMTP id d9443c01a7336-223f1d83ce1mr103355185ad.47.1741255020410;
        Thu, 06 Mar 2025 01:57:00 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410a918f0sm8255215ad.168.2025.03.06.01.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 01:56:59 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net-next v8 0/6] tun: Introduce virtio-net hashing feature
Date: Thu, 06 Mar 2025 18:56:30 +0900
Message-Id: <20250306-rss-v8-0-7ab4f56ff423@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE5xyWcC/4WSTW7jMAyFrxJ4XQWURFGSV71H0YUlUROhqD1jO
 0GKoncv6/Qngyy6E0F+j494eu0WnhsvXb977WY+taVNoxThbtflwzD+YdWK1J0Bg4Bg1bwsir3
 1JUSug/edTP6dubbzpvLQjbyqkc9r9yidQ1vWaX7Z5E9664uS1QABnNGg9xoRjVFaDU/t0J6m/
 VTkdV+Gl7Gd93l63nRO5orVTqMmxL0hIKRfWfvFIkTttgtOVoHKZEHESoJgbiC8ggxeIBQoIEd
 rOANTvoHcN/Rx4QVyAlWbK4VSAVy5gegLcqAhXiASKOkcYSgeQqUbyP9Axnxu8ps9NOBySqX8D
 71dcpr531FCXj/D+s64322ujQW1HkdFxBoGjAmy78Xh9XfYRsWrJpWOtfK8qCjjmKqkU3MvWcl
 4GhZWsvm5rf2ulGC985WYAg1GhxCjz8mF5KJ31SOm5H0gsfn2DtcaZfOTAgAA
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
X-Mailer: b4 0.14.2

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
https://patchew.org/QEMU/20240915-hash-v3-0-79cb08d28647@daynix.com/

This work was presented at LPC 2024:
https://lpc.events/event/18/contributions/1963/

V1 -> V2:
  Changed to introduce a new BPF program type.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
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
Akihiko Odaki (6):
      virtio_net: Add functions for hashing
      net: flow_dissector: Export flow_keys_dissector_symmetric
      tun: Introduce virtio-net hash feature
      selftest: tun: Test vnet ioctls without device
      selftest: tun: Add tests for virtio-net hashing
      vhost/net: Support VIRTIO_NET_F_HASH_REPORT

 Documentation/networking/tuntap.rst  |   7 +
 drivers/net/Kconfig                  |   1 +
 drivers/net/tap.c                    |  67 +++-
 drivers/net/tun.c                    |  98 +++++-
 drivers/net/tun_vnet.h               | 159 ++++++++-
 drivers/vhost/net.c                  |  49 +--
 include/linux/if_tap.h               |   2 +
 include/linux/skbuff.h               |   3 +
 include/linux/virtio_net.h           | 188 ++++++++++
 include/net/flow_dissector.h         |   1 +
 include/uapi/linux/if_tun.h          |  75 ++++
 net/core/flow_dissector.c            |   3 +-
 net/core/skbuff.c                    |   4 +
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/tun.c    | 656 ++++++++++++++++++++++++++++++++++-
 15 files changed, 1254 insertions(+), 61 deletions(-)
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


