Return-Path: <kvm+bounces-34867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 285EFA06E6F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD7D81678EA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 06:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52353214812;
	Thu,  9 Jan 2025 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="JKRvsN14"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9E12147FD
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 06:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736405941; cv=none; b=NjRC/8cI6rGagAAJCR/+u7S5c20sCu8RtpO05AD2TDfR7Xrnfio1qBpPkni0ubyd0FIl/R9DXV747R4qRY3sODSCwChdgxLyPkB4rs+A5fSn6ondBn3WyqU8ug1U+T30dKbEqr9ZFKvX4iPSrahKcBmeexMlDn/ksz6UVQIBRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736405941; c=relaxed/simple;
	bh=b4nGT7bzNP9cYs0RRg/GoDk6GVo5jtMW+D3RbTMnfIM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=JaaSONXA6WVTX3XnT88Cc1zoA1jpRa0TG0oL0oBuqhlV/tjhKND09U6vfvD2haeLeNWy8R3uteqXwb1hlbZ8sO8fE6VI2UbQ0FvlrL0U1IduTZIomp4/K8aE4DNW7z60/kp2BaRT4anHQ8qxZHyBg4j/Le3zbzA1blGS7t/nnPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=JKRvsN14; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-216401de828so7902665ad.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 22:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736405939; x=1737010739; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V6t1qxwBoLWfejlGfA7U17j5uTd/JzY8q21mk1j72ew=;
        b=JKRvsN14t1CeuzF/R4TvpFmIOqmoYh19+Y81mLRsBMwVc43qr6/CRnWCOWtMbhW2Nr
         rwWoZRYvWkfqDaZC4fHFIfSkjVWs03eVf/l0ej6Zi2Sja/nhgT5RdweaUlLMA/V2rafC
         dq81UurJScMIzEA9tZT0Ov886BguUp5zLhU2g794i9Oozh9Rrg7mRsd53UJljL36ZZvR
         n/z6MkMGty0fNc8Pc4oi3MtsSd59OrEsVyax691l5+AQrkpUKGup6qj4Pp29ASm38dYf
         KEQRoGZ9W/bx+/oYd2fmvmhBw18HrvFRaaI5RfKlcJuvyLoNQkP6VlIHlrQyTE1j3X4B
         z3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736405939; x=1737010739;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V6t1qxwBoLWfejlGfA7U17j5uTd/JzY8q21mk1j72ew=;
        b=Rr18DhApOoe5oWK9cfKEB6zJ3kEGPfvUaMtQ7UoUfcXJKt609E1a8O7apFLutmtOqO
         QNSlk6xyS6Aixpv9pJcOGdkqBzQCrZoChG3DpEJO/+5jcwan8kQcNAQgz1KI+xeKdMCK
         y97YX2GKsy5tHDQaVOoqmbhDyRTr/mPmOf2PWZgS1JLfoqeTSyTIbGd7vPwa7cwQ8rEH
         HnTPCAVHiL6aJKgtNs904aMo/DFdNTfzyP955qk1OvpNar7J6hizIV/zFFcGS9Boz0NY
         h5H/pJp/LvESelZXMUa11TtbR3ZEqhw+FaLv7eZn/wkSl3xCSJxX6RN4PmtkhK5sQeTw
         xyyw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ3xbzst5dB1iQGIJW6YuwqM8vhJ6pSlJ2aHlCYOU3jHsqeoRkVRJsZjTrBy0z0hnkt2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YztPYEyBB2LbvsU+aJTt5AKE347kX2B6TECxxB2KZtIC90Q1kEa
	/5GVJYs1/VXGEFHFHhAN0ECjVaB4nwdJKh1AkpChNAIdcABAz92veu4s3vjbZOA=
X-Gm-Gg: ASbGncvrE7OxGK3xXThnDCITB1Jcd9nBmv1BYesB+Rk8aV08zVtikE6viWJv2MvybYD
	FVzQ5oL0xgXFbx26L5vxgZnrFkjAM3UXn8kGigQYb9MhpDktWbAGpay0WmhzVgMLOdfw+ScTqYC
	GGuxWi0wVzlD9+uGpfO7mLfdkNiX+uxtLmgyC4cgSvEe5/gUIpoWdN9GLuet+Tz+nxPLMbRivGJ
	c9qCI4x4Mo7saznyKPw2xrcSc8HVVAh0hkGHsr1aRZD5nshz6luKsSjmeY=
X-Google-Smtp-Source: AGHT+IFVrPaDE5bT1NedCIHg/BRb9M1axoVZQXe+QhCRKOheUBg8nZqyVlcuDTD0PULcei7AMQYLnw==
X-Received: by 2002:a17:902:e5c2:b0:215:6f5d:b756 with SMTP id d9443c01a7336-21a83f36e79mr79407695ad.7.1736405939214;
        Wed, 08 Jan 2025 22:58:59 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21a91767f94sm5432205ad.40.2025.01.08.22.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 22:58:58 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2 0/3] tun: Unify vnet implementation and fill full vnet
 header
Date: Thu, 09 Jan 2025 15:58:42 +0900
Message-Id: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKJzf2cC/y2OwQ6CMBBEf4Xs2ZptqRQ9+R+GA5RV9mDBFgiE9
 N8t6PFNZl5mg0CeKcAt28DTzIF7l0CdMrBd7V4kuE0MCpWWKkcxTk4UBUms9bVBayA1B09PXg7
 Lo0rccRh7vx7SWe7pvr+gxPLYz1KgKExrSt3kOjf63tar4+Vs+zdU8Wf09JnSnfGvjfELvQd+h
 qwAAAA=
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
Changes in v2:
- Fixed num_buffers endian.
- Link to v1: https://lore.kernel.org/r/20250108-tun-v1-0-67d784b34374@daynix.com

---
Akihiko Odaki (3):
      tun: Unify vnet implementation
      tun: Pad virtio header with zero
      tun: Set num_buffers for virtio 1.0

 MAINTAINERS            |   1 +
 drivers/net/Kconfig    |   5 ++
 drivers/net/Makefile   |   1 +
 drivers/net/tap.c      | 174 ++++++----------------------------------
 drivers/net/tun.c      | 214 +++++++++----------------------------------------
 drivers/net/tun_vnet.c | 191 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun_vnet.h |  24 ++++++
 7 files changed, 283 insertions(+), 327 deletions(-)
---
base-commit: a32e14f8aef69b42826cf0998b068a43d486a9e9
change-id: 20241230-tun-66e10a49b0c7

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


