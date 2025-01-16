Return-Path: <kvm+bounces-35620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32761A134BA
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37991888968
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234951ACED3;
	Thu, 16 Jan 2025 08:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="wEQMDi9f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7FD1991B2
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014914; cv=none; b=duJuM6spbnDFtWIwb80e4sOXDwdWu8kNtMLVC0w+9C6935Gi8VNanYZp+jEcBP+UD6BHJvZiCMEIgxBxpxsU/RVlBCDA5WE33QTQwgfhjqTze0l3tEBh1jsNijEIqMXP0hligXvdKgcD3pMtMDd9aNr00/ofr0ileEKZkRLaFN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014914; c=relaxed/simple;
	bh=+CC2205P/4QjZOTULtxLx/pTHHo7ousX5VpLNpbUGG8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=buiU7efyt5HixA1naVmgMGAyZPpzMExdQNuZE6XvHPtJfgcP+3+M+9RYhpaTysmnwRnG815azGUHqFc4Cfl0pEV+ptGyXhEIOQgbNtF3/Q2qPQBYoM/iHZyUeLcQrE8cLtTgbqmj0VtKOGMBlk34ujp1twmbNH0Ue3alknT+8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=wEQMDi9f; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21661be2c2dso10236285ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737014912; x=1737619712; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NvSgzzLjp0cbfCfki4o3Cp/OkRE34mhTHVsplAbYOvE=;
        b=wEQMDi9f+r7KOE71G/1n85bG0I1SDHTu9ohOFbAaWXjjUCT8McDYr1vYixO3ljyjFf
         dLWJiZ7Vtpacy6Vn29a9WFziqFrdOFj29o7WTgumhspHCN6IyCd2xFQX5KGcvnNNZ+D5
         gZNAC/cTSrBgmCwJccuBdwaPrVF9aZsdThfzcoUSHZM+qx4H7pCVcClf1s3FESbpc+8/
         kOaeu42Y475EYYPB2oZNK3oFURjXaBAwqs7pWqhoquDHMmTgqJZLYtjYJ1ImhC/S7zVf
         3zWsBP2ETFdhSW7zdrzmNQAgX0tEO5Zx5EH1kIvjEIm56kSfg1LVr51oDYQnRRTKl7XS
         pAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737014912; x=1737619712;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvSgzzLjp0cbfCfki4o3Cp/OkRE34mhTHVsplAbYOvE=;
        b=qAtWN+Kx7PtgIht1cErB6f8pw7r3LNQnFMtDxsNKk0jED+g45uUpMMuzleUO6odxJ9
         cEOk0ZBC9EKKfwWAnZ/AcR3CRftmHFkJTkY/OtNOcWF4hPBdAnXxOUgLcPkC2lIG2PFS
         5vozPvBew+a1mgQvlaswBXNk8tb54dvgkLjKPo4modyZ0jsZzK5TnHQWICATD0uruyth
         0zlP6XmwpQAjR9ybuP3QC29Ql+xWca3l0jpHCPq/XNfi9Iy4cP0ADm6eU3VsFYlODQwI
         eBijJhMReVlcHkQDMGaRR/hyeHiy25ECacVy0mCq9cUGDcNX6vSsajihjTHyWFV6a92/
         igbw==
X-Forwarded-Encrypted: i=1; AJvYcCVHdCJpyG3ZqtcF1sWcYrXxgoZO+z7G78AWbqsZCIxKaV4KNGFvzPUXDQIP+MvmVquuPNA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5qpC/3KO1YKncLQI5e6VKURzTxYZ4MwySUH9Z0SLZYqCAFJlL
	IRXQ/oN9WXly5LQaXRanXGRkTkQLfrDGc6K1mQDoM7Qy+BrXnJvNVg06cGGxtHY=
X-Gm-Gg: ASbGncvtsibEA47P5GUdIW8ub25F7gpYkxGGM6nRh+x+m0XlYzvTFPnKY6vp3CinuQB
	gbFba6mReynBm9ZLR4F7Ly5+voQaJ/6YCuSqq+yzROB8VQG2H87Yck/t7Z/WD9tejB23zAV2N7u
	QOejDydwdGiDDnRp76fJUFlM9dfDkXv1x/xn0CnRMIo8lLpDmk/OthRRp93TOcLjUN1fQnm8N3z
	EWDGmtMrT+wvvCU+vo0xtGSV7wLoHYL/lZf7nkMs69M/OYf644sv/DuQAk=
X-Google-Smtp-Source: AGHT+IFRLQCwktjyooiJq73WQ5ddpyLIN010dTt0KbqmXVNLbU3CCPmJHJQ7IqxozW/WCRUUVDqOaQ==
X-Received: by 2002:a05:6a20:6a25:b0:1e7:6f82:321f with SMTP id adf61e73a8af0-1e88d10749amr45114735637.17.1737014912054;
        Thu, 16 Jan 2025 00:08:32 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-a31de807786sm10985666a12.76.2025.01.16.00.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 00:08:31 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net v3 0/9] tun: Unify vnet implementation
Date: Thu, 16 Jan 2025 17:08:03 +0900
Message-Id: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGS+iGcC/1WPyw6CMBBFf8XM2pq+oMWV/2FYFDpKFxZtC4EQ/
 t2mbHR5Z+ac3NkgYnAY4XraIODsoht9DuJ8gn4w/onE2ZyBUy4ZF5SkyZO6RkaNbDraK8iX74A
 PtxTLHTwmaPNwcDGNYS3mmZVVllSUUV0kMyOU1MoqLTshhZI3a1bvlks/vopg5r9Qc0A8Q0Jrq
 2xluFbmD9qPLgE/U34kHYXaff8CSWeB7uYAAAA=
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
X-Mailer: b4 0.14-dev-fd6e3

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
 drivers/net/Kconfig    |   1 +
 drivers/net/Makefile   |   3 +-
 drivers/net/tap.c      | 172 ++++++------------------------------------
 drivers/net/tun.c      | 200 +++++++------------------------------------------
 drivers/net/tun_vnet.c | 180 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun_vnet.h |  25 +++++++
 7 files changed, 260 insertions(+), 323 deletions(-)
---
base-commit: a32e14f8aef69b42826cf0998b068a43d486a9e9
change-id: 20241230-tun-66e10a49b0c7

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


