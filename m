Return-Path: <kvm+bounces-59418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3334BB3593
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3A5B466353
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FD4313D77;
	Thu,  2 Oct 2025 08:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ls+oxcni"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45D52DE702
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394605; cv=none; b=Bo0KhcP/pkZcRGp4o1BpNkk2ZLzGuyYE9CQDrdoxPFxOYaIZYazkbX+fOHjClViJ88mU6h118bozTmkKSgPOaph7GW8wP4LGvkS4znHrwmb0xkNsEewaXzANFTsl5WWdmPPgq6hku/E8CIRJMEpgXrGumn6EczGco5M3EyqHGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394605; c=relaxed/simple;
	bh=HXkBbK/IK9wSbZzT4VkfYJNoB2xGeaIkjuyRXtVGRws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRRKo4N5mp3kkZUiqThM3K7FwhE9UPH7T0uBEmB2vI1wJuNeo7lilKMbEGj0SuWfgswQkDr9CXT76re5uSr+n7V0xBsL2xd2VNIlbpiYd4KS2IGYbZrPRQSSJYSGly/t7V5H+xNCWIs8WYnja9EzC/T2wNPq1147LIvsJeFi78c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ls+oxcni; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee1221ceaaso422986f8f.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394602; x=1759999402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9bjNs8nbmPHtqp1O3nLNnIUYP6MFEbM89LgRhzC8Oo=;
        b=ls+oxcniYFKAoqKbbQIJPYzx195hk6fWwOKwAiTUIos5KmpbHi1r7KTMtWHKbYAFfW
         wkk+bgvbXZ71iU6hWuFhYtzdeI9BOXzG9CQBHKOJ3LSA3cI+U2y2cA+EvBEPRbugYpUT
         5cOVlaJTm9+NRJnCwoBZ5aG0fmGafOGIxUGnJRLZY1WUlY9vqeB48qpYqP+PDrnpPnAu
         EjxdMlgbTzv2hJ2YZJq6eB7T5Xp8t85Lk8Ex7yf8l4/2r802n5SV2Hl7HIimH9nRkMIx
         SA2NTxU1TisL+H/gtgHOlww+4H8cbDDJU64aYvZKR+ss/zotMUES9zAHi+DGTfyPYLwB
         7xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394602; x=1759999402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9bjNs8nbmPHtqp1O3nLNnIUYP6MFEbM89LgRhzC8Oo=;
        b=tIKKxv5c57aRqH51Yq7NA0vNLumu46q8DtkrhdCQnRKQ51lIhnHTaYOokwhx61ReCq
         0tqjoz5PpnwGh10f98RpA8fFXkmqaRLeJpZBZzm6QC8Z1gv5o5YsBQRSW62M112I0kJF
         RPSc6PjWVKLqiGTvNYW7i4G2QHJGGrzJWE6UtUf0TJDkgIu3VR7sJml7y/xwR7JdKkC5
         FsBNW7nDb6LCQS/V0Dd38zDTieKfIAFx1JR1Jxqi2DpHWOWiX+aUshvkReQ2JwVK8mix
         A5xagp4mRN28ZsvQ4KN58zsUCwg92j4NkdgvZCSKWoExPiR+XfxL2GFSN99yPA2PGC5N
         rQ6g==
X-Forwarded-Encrypted: i=1; AJvYcCXWcovOc2qS/wXOKjfiz+VQdyf4RIpknPKTPhRrflxwJDDVP0ao+7g+VMcGzJISzkNrBjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyto1hzJK0SCSG9qB/hGBhuWnfWW4e1zfSvlzf0ahadtHc08lC
	ngRRYOaUV3eYTdKwFC6egimzzfa2dPBzxfgfEyk2xrg5DMbcswgHj7xyu1oFNLARvtA=
X-Gm-Gg: ASbGncu520nHbLobKG8ErZyxavrGe64+3CvhIZEj28PDGSWVPHC8JpHdp2Ig5qLW5WG
	BDHNCq3lXAd7F3LLXyg/JC4RsML5omJEK3H/+Oo27JeBMiPT2thTgFh2O0kXL0lyBo9J1ybKc5e
	h6wPVOyQH4A+wwy3t5VATjcEq1iDleJHUYQR1kq8pb4Fm7x89KCejUrQEFuFxsuKlSfCRk+ZfyK
	ogctvLRdTjg7HD23szfNK6a0Im5jZe6x0Fj+8GbQNIsIFggNdLO2Uv5XpUnsOqzPVc98a3o2hA1
	mMj8srZ0YmnmFRVkiw7c5Ix1T3u/BHY9RPV1tzMFZPOpgrjXi5mDROEy8CzRlj7ihREb+HzzZD7
	vrbxpNSFsgDOYFgrR4DrQk2UlRHc8EhRQ3yb3tOQgHhksHuKCS3QqllLQN3whRRP5pW3qkEGQlO
	kxe5RxHWEIp/jmh43dEZGBZOU/urwAoQ==
X-Google-Smtp-Source: AGHT+IGyb5rK3wU2eYffbepInpQ5nRpyDFkLvUQpXIwaKbJPhsQ9zk9+/o3WwrGqdXtMXrkY9srT5g==
X-Received: by 2002:a05:6000:40cc:b0:3fd:eb15:77a with SMTP id ffacd0b85a97d-425577ee891mr3832972f8f.6.1759394602152;
        Thu, 02 Oct 2025 01:43:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c3eca22sm54562995e9.4.2025.10.02.01.43.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:21 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v4 16/17] hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
Date: Thu,  2 Oct 2025 10:42:01 +0200
Message-ID: <20251002084203.63899-17-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use VirtIODevice::dma_as address space to convert the legacy
cpu_physical_memory_[un]map() calls to address_space_[un]map().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/virtio/vhost.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 6557c58d12a..efa24aee609 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -27,6 +27,7 @@
 #include "migration/blocker.h"
 #include "migration/qemu-file-types.h"
 #include "system/dma.h"
+#include "system/memory.h"
 #include "trace.h"
 
 /* enabled until disconnected backend stabilizes */
@@ -455,7 +456,8 @@ static void *vhost_memory_map(struct vhost_dev *dev, hwaddr addr,
                               hwaddr *plen, bool is_write)
 {
     if (!vhost_dev_has_iommu(dev)) {
-        return cpu_physical_memory_map(addr, plen, is_write);
+        return address_space_map(dev->vdev->dma_as, addr, plen, is_write,
+                                 MEMTXATTRS_UNSPECIFIED);
     } else {
         return (void *)(uintptr_t)addr;
     }
@@ -466,7 +468,8 @@ static void vhost_memory_unmap(struct vhost_dev *dev, void *buffer,
                                hwaddr access_len)
 {
     if (!vhost_dev_has_iommu(dev)) {
-        cpu_physical_memory_unmap(buffer, len, is_write, access_len);
+        address_space_unmap(dev->vdev->dma_as, buffer, len, is_write,
+                            access_len);
     }
 }
 
-- 
2.51.0


