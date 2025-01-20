Return-Path: <kvm+bounces-35953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15694A16893
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D62267A2999
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9930F19D086;
	Mon, 20 Jan 2025 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="jO+qGSC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCE4C2E0
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737363640; cv=none; b=rs0ofXRdJMcDgEVu5lWoZbPERJWhalEcjsMg27qsbVLahjHuUDGvGoRe/BbTn4oobZWv2NmGs7i6Lru8b8TIn69+9GIDa9BH+ZG2QoLhlRazyeD03ePpABT/ohI3c0I9fSoA/xdrPpwtm4r5kW2lc0tmeSlOnK+BhT52ajkF76s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737363640; c=relaxed/simple;
	bh=qcajYeuzQqig2Pw2OjJksSWvVLoxEiTtaDCHiGYHL/Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dbiW0iQBY9OPOjFyhn/k8tZvhUc3QWuK/hQr6OxlXqZeJzV0Wbek2b1egPDU8+FxB9OIs0VNCJE1wD1+6diS7a5ZuZVcT6FRPPFQmI7Hbghgu9N0yPvBcEKPx7E2O+ZcqXWwrkS18zqGaU97gfIZobUoAcXtbS5qDQuh51QtrFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=jO+qGSC7; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21675fd60feso90702105ad.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737363637; x=1737968437; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M73wUmCTBGNSLAfxRhHe8Rnzzifp0+HNyWyW7z7nYBg=;
        b=jO+qGSC7YWWbp38q5aTRWnoE8tafva1nVW3kCSAxnGTNgoR9bXi4NW5Ld9J80XOMhl
         aLjahDPnPiGFCwwUzUgY3G75GAMqy5fy/GUo5IEHAqJQk4hAA4ljTFZoLuqSTF2D1tYf
         DXcynP+xqyli6+wG7ji3pTO84t0RCdErZphIuBncGEDH0dn3PYaj0n9xk/bMU2+Wu/BC
         KTMAH867L7+lgrc7dxSjXAyAiBIYj6of/UkmH0RYEsSVSb2v832u3p1qRWipRLUZ7xxm
         LvAEqqSujc3n0frz2sDQiXKkkwOUpn8Sf7bZt6j/2M+PUq9v1Bf9OJiGDVGMRqe+7/jX
         ybIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737363637; x=1737968437;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M73wUmCTBGNSLAfxRhHe8Rnzzifp0+HNyWyW7z7nYBg=;
        b=rXagkVscICu0uMLbsgzvJje4FK14eQ+WYRmwn9jzmB8TvKdBKTGmk2+QWo2wUUBE29
         tPkBcDI4CzLofh6U0Dv899R1YANvtslEPSH/rnOlyOie9kmAgVesUO3QQINYoc+AgryJ
         3fLc+lyUC2FB9OrPBKKR506eOJqcczgAEEXkSi8PxC9XGqKoijes3xslJQbvAgO0ZvHh
         JLEUTalVZzbsU15mYRI2eAw26/3iy/yexqXwbbOOtJufuCPSFtsFo9i90dvFbSYF9dn1
         k6SfgTbL0U+Vc0cnx+LJQ9GQos3FQnK0qtIa9zY5aOUkHQU2yHCc/a/eCqDA966Ie+Vu
         YDDA==
X-Forwarded-Encrypted: i=1; AJvYcCUIhXQHebB3sxIffaN5z2jmLcUup15xgJA0V+gJ2dg3QhFqghls8VxMYahRUW+BlpeMY2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzO3Uu5Sv3W6Hl7zyjHnMMiatzhMvdtKkcSIiYtCjDCyL9Zl7e
	MDjjSTvIfOd14ZXn2H1Cf7hdxYqUsMCM3yUEIWn34NsICsoKj6xy6z6pRVQnxyE=
X-Gm-Gg: ASbGncuwh0/9mSxsx43yA4QlW0Xky6HEtx/uVQgDt8hc5EUNXlFOZDNp9bri3F++kRJ
	uIPpY8O2wSn4fyVUWUwM432AjSjVzeOOhXBvMI1zgqJkFxDHMRnIu72OLpqssWL00MZl6PvAiDO
	UpKZorFdVtPDKLhFaIacwyYazjD7p1hwJOc6i+CtQIEs/YFGwYRaGeujA43XN5+SGQl0bNn09WZ
	TLYF4G1ygWteTtz4zTKQfSX6PrfbmhRimLEx9nfUbwldleQZ7SehBcdzGoT6oz6cA3uFaF/
X-Google-Smtp-Source: AGHT+IE1pLyS0CRQUGICRpfL+cuS6Zd8b3NmmH3IRRXgasWGxiLbxjOpEsY6IBDF/xH/j3M5fZzgCw==
X-Received: by 2002:a05:6a00:802:b0:72a:a7a4:b4cd with SMTP id d2e1a72fcca58-72dafbb61bemr17694966b3a.21.1737363637519;
        Mon, 20 Jan 2025 01:00:37 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-72daba44453sm6487254b3a.127.2025.01.20.01.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:00:37 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net-next v4 0/9] tun: Unify vnet implementation
Date: Mon, 20 Jan 2025 18:00:09 +0900
Message-Id: <20250120-tun-v4-0-ee81dda03d7f@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJkQjmcC/2WQyw6CMBBFf4V0bU1ftMWV/2FcFDpIFxYthWAM/
 +6kbDQub+6ck9x5kwlSgImcqjdJsIQpjBGDOlSkG1y8AQ0eMxFMKC4ko3mOVGvgzKmmZZ0hePl
 I0Ie1WC4kQqYR1kyu2AxhymN6Ff3CS4+mmnFmi2nhlFFtvLGqlUoadfbuFcN67MZ7ESziG2p2S
 CAkrfXG105Y4/4g+QVxvUMSoU63eM+hMb35gbZ9RYLnjC/I+5Trtn0AjlRLryABAAA=
X-Change-ID: 20241230-tun-66e10a49b0c7
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
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Willem de Bruijn <willemb@google.com>
X-Mailer: b4 0.14.2

When I implemented virtio's hash-related features to tun/tap [1],
I found tun/tap does not fill the entire region reserved for the virtio
header, leaving some uninitialized hole in the middle of the buffer
after read()/recvmesg().

This series fills the uninitialized hole. More concretely, the
num_buffers field will be initialized with 1, and the other fields will
be inialized with 0. Setting the num_buffers field to 1 is mandated by
virtio 1.0 [2].

The change to virtio header is preceded by another change that refactors
tun and tap to unify their virtio-related code.

[1]: https://lore.kernel.org/r/20241008-rss-v5-0-f3cf68df005d@daynix.com
[2]: https://lore.kernel.org/r/20241227084256-mutt-send-email-mst@kernel.org/

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v4:
- s/sz/vnet_hdr_len_sz/ for patch "tun: Decouple vnet handling"
  (Willem de Bruijn)
- Reverted to add CONFIG_TUN_VNET.
- Link to v3: https://lore.kernel.org/r/20250116-tun-v3-0-c6b2871e97f7@daynix.com

Changes in v3:
- Dropped changes to fill the vnet header.
- Splitted patch "tun: Unify vnet implementation".
- Reverted spurious changes in patch "tun: Unify vnet implementation".
- Merged tun_vnet.c into TAP.
- Link to v2: https://lore.kernel.org/r/20250109-tun-v2-0-388d7d5a287a@daynix.com

Changes in v2:
- Fixed num_buffers endian.
- Link to v1: https://lore.kernel.org/r/20250108-tun-v1-0-67d784b34374@daynix.com

---
Akihiko Odaki (9):
      tun: Refactor CONFIG_TUN_VNET_CROSS_LE
      tun: Avoid double-tracking iov_iter length changes
      tun: Keep hdr_len in tun_get_user()
      tun: Decouple vnet from tun_struct
      tun: Decouple vnet handling
      tun: Extract the vnet handling code
      tap: Avoid double-tracking iov_iter length changes
      tap: Keep hdr_len in tap_get_user()
      tap: Use tun's vnet-related code

 MAINTAINERS            |   2 +-
 drivers/net/Kconfig    |   5 ++
 drivers/net/Makefile   |   1 +
 drivers/net/tap.c      | 172 ++++++------------------------------------
 drivers/net/tun.c      | 200 +++++++------------------------------------------
 drivers/net/tun_vnet.c | 184 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun_vnet.h |  25 +++++++
 7 files changed, 267 insertions(+), 322 deletions(-)
---
base-commit: a32e14f8aef69b42826cf0998b068a43d486a9e9
change-id: 20241230-tun-66e10a49b0c7

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


