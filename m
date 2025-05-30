Return-Path: <kvm+bounces-48067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7263AC8767
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 762887AA461
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 04:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2181E1E572F;
	Fri, 30 May 2025 04:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="iHxuenpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E071A2396
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748580630; cv=none; b=K4vb5+/agESWWq5vD+S3yzv2lWo3gnXwibo42SxNGdxw8ZPIsSjgS1+hv1VAL9NFzTZdu3NELllxV67bTwSxoYunMX1GUgXov57Uvrn9r0CRV3iVRX7qBbGXwOfDG/bn+u5rM1epaKXmkdXTV/nkZHfgVwwZPgIALZCUTux6Y0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748580630; c=relaxed/simple;
	bh=N8sW+IwYvL5X5LNdVS5M4lmPLLZ+kwZNLPyEOkP5pHA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=drBeOOjbbUMevX05vIhnWxh8pzteYaRTcnqVMwVAL+PF/x7kF+2L6zXYJud0cpBMPl9Q45u/tKuHM53RAYD5onPFvwAE2EWsEhegKNeEPeKRgSScfDcqwaEitHsQ/vG35lAKGhUtVDCSvygRQurda4Z8jDbDCOZeTssmDEz9VpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=iHxuenpq; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-742c73f82dfso1251922b3a.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1748580627; x=1749185427; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPQKvC3ql9fhFzmc6zvGI30HxdvNWYp5SnQBcJyISWQ=;
        b=iHxuenpq/7pGSEhYalJmM0fUAev/hb4TJG0UJMDoCKKZ80TytPtOdOmYnsLIZV41gJ
         Y7YUPwuLQEDH32zfXmsSeRlNrzEDY2C7DPphXUtvli88flN8z296A4X6+txDls0BX0ZH
         VIyKmJGRL4+jPEi46q04LaqNlmA+oKz1+do3nnJEfuAMUyS1h6VoiYSKMeJctTg9tge+
         8mqGVTSWpSGwuzmrbzg6bs/oDpFWr8JIX1lArnjLk+C6hkeVPweKGiXDVm0Vd0nqV8Tj
         SpZ3XGSxi+YOt/OBPy29ag9PHhlcKM8nUC4k+oUcIOcktNecOWxp9R92E7WZOgxknN0m
         6tZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748580627; x=1749185427;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPQKvC3ql9fhFzmc6zvGI30HxdvNWYp5SnQBcJyISWQ=;
        b=Mgizvulggzy7Rko/5iaH3Nz+TlR88UM1H8NC+NZ4w6lpSz/CZStM/n8iyJcUy843aK
         vlvvWgqCSKJRpEH7gw+UNAd0Ar6L3NukEW3YTEnMFh1rifhmvvWhtZ13XL8E89M5Tl7S
         p122sLjr0AhibwGk1fZMLp6+TWAPjkLTHOWdPWWpUUcD1JH4YSxJtgCj3xo1VeKhKXge
         W67wU5AOyODCYZWhhHj9Ur+UPYY7uglEZj5hOW7V+esxjDjmuCoHGWNugohyrQiYNg28
         uonSMkid8vItKXHPJtWGBhYAIda4BHz9pmTSPsMDveCNiq7pacbMvB3DSLnRojQFznJ9
         KcxA==
X-Forwarded-Encrypted: i=1; AJvYcCX0mRsOsa5clufje5sybtg5i7dJJw0imd6kmzEUOT4UsLNrOnpxWw9Kj4+bXQ6Ki5eiTaw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbkIljphzeOuHzakplzMHFZBHDGahBnTGrKIJHi7XeY4Bx6XDr
	mOrYmCEgq9ELlBgWyyycKw5zt2oy6TYzDPYhgrJqa4He3R/F4Eb5cTGSFue0aXKPrJE=
X-Gm-Gg: ASbGnctMbA4dTOZ/Fdr9Q1LZr/R6dtmLnS+PxTZqxwoV8DA3jSn2Ko2TfBSFLZfWi4R
	I71ewzcN3Hv3+xPilSwd9cBQGCqVqIzmHwh1Dad2LLcIo4IodqkeXrvdmCtLDYTlKa//WMw51X2
	MiFQCm7PSGbmFdbSjrrTjrmgS889SPB7g52ueUSNnrKCsQHbDPRh6UYZ5FQboM17OtQsXAz9AG5
	2Vyg81wEQhAXikL/9BVuolVO9fxOGiGG1DA6pitwGxlkkd1OcqiCjMIrT7XkbS6vB/yo18T12xv
	b64mQY9VNxgVbd9KBL1FBC30nHd3evPgnOJCzmXTytoMBLZQA+E3
X-Google-Smtp-Source: AGHT+IHqoTL77XLOwzCe4hUoocyG8Rzb3Oor60nWaLLzGCI3oRz/BPnDLMFFIcAqwWKligPLSQnBfA==
X-Received: by 2002:a05:6a20:2449:b0:1f3:1d13:96b3 with SMTP id adf61e73a8af0-21ad94e0024mr3321043637.5.1748580626892;
        Thu, 29 May 2025 21:50:26 -0700 (PDT)
Received: from localhost ([157.82.128.1])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747affafba1sm2156259b3a.110.2025.05.29.21.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 May 2025 21:50:26 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net-next v12 00/10] tun: Introduce virtio-net hashing
 feature
Date: Fri, 30 May 2025 13:50:04 +0900
Message-Id: <20250530-rss-v12-0-95d8b348de91@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPw4OWgC/4XSyW7bMBAG4FcxdC6FGXK4+dT3KHKguNREECmRF
 MGGkXfvRHIaFTr0JnL4/Vw092bKY81Tcz7dmzEvdapDzwOUP05NvIT+dxY18UQjQRIQKDFOk8h
 W2eR8LsHahle+jrnU6xrzq+nzLPp8nZsnrlzqNA/jbc1fcK1zkkIAB1oiYItEJKVAEZ7rpT4P7
 ZD462cKt75e2zi8rDmL3FnUSGiIWmnAkPmvVV+WwKNeb7AoASIaBRyWOnDygGiHJG2IGDnKXsk
 cIZt4QPov+rzhhjSjomIxLhUAnQ7IfCENCH5DhlGH0UNIFlwxB2S/kZSPnex6PJKgY9eldETuG
 ykwG3KMbOioaFMKSXVAfo/shjyjVKwx/DpS5+6AEHYKt67hSWYKnU5WBR8KHBnu2WMzRGYUQ4z
 By6Kw/MM+tv4b89s7d+/8aMIuTFlw/aXO59Ni2s/fHg2v/vgDNtHPdvMCAAA=
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

NOTE: I'm leaving Daynix Computing Ltd., for which I worked on this
patch series, by the end of this month.

While net-next is closed, this is the last chance for me to send another
version so let me send the local changes now.

Please contact Yuri Benditovich, who is CCed on this email, for anything
about this series.

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
https://patchew.org/QEMU/20250530-hash-v5-0-343d7d7a8200@daynix.com/

This work was presented at LPC 2024:
https://lpc.events/event/18/contributions/1963/

V1 -> V2:
  Changed to introduce a new BPF program type.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v12:
- Updated tools/testing/selftests/net/config.
- Split TUNSETVNETHASH.
- Link to v11: https://lore.kernel.org/r/20250317-rss-v11-0-4cacca92f31f@daynix.com

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
 drivers/net/tap.c                    |  80 +++++-
 drivers/net/tun.c                    |  92 +++++--
 drivers/net/tun_vnet.h               | 165 +++++++++++-
 drivers/vhost/net.c                  |  68 ++---
 include/linux/if_tap.h               |   4 +-
 include/linux/skbuff.h               |   3 +
 include/linux/virtio_net.h           | 188 ++++++++++++++
 include/net/flow_dissector.h         |   1 +
 include/uapi/linux/if_tun.h          |  80 ++++++
 net/core/flow_dissector.c            |   3 +-
 net/core/skbuff.c                    |   4 +
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/config   |   1 +
 tools/testing/selftests/net/tap.c    | 131 +++++++++-
 tools/testing/selftests/net/tun.c    | 485 ++++++++++++++++++++++++++++++++++-
 19 files changed, 1234 insertions(+), 85 deletions(-)
---
base-commit: 5cb8274d66c611b7889565c418a8158517810f9b
change-id: 20240403-rss-e737d89efa77

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


