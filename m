Return-Path: <kvm+bounces-59331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D73BB147A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D4EA194602C
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E752BE62E;
	Wed,  1 Oct 2025 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QrrUE2/o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB782C11C3
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337116; cv=none; b=U0WijolBN9qSaNm2TP8aS52hMyxxb0CbzzShZSSFhcfIoV8/hEnfdGwrbM7Ej0+IwJmhYynqIOPj2tUUrLjCIjDF9DiaYtNjUznGbNsPuqf71AHK3horsTVW0X7IaICi6Jp+K7scOzwSGBMg7Smli8x4UIfKHdgXbEwYe+ziHf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337116; c=relaxed/simple;
	bh=wvkEB1SrVW4Kk8kmJTB8S7WEC4GTn9XMdkv/HDk5KfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qqGFn91Bmov4NzMx/aq7sBTZR35On/uRdSi+xs9ylahAGFvCCyP8waqnpWW41wBeAZj0c0VIYl1iGsSahl3yLo+FHcIYyT6aUjlk0lpOfvXToqtODK0+jZQJNd+Wp1Vb6Adh7gGS4sTn6h+pDXJv2QGpTLqKPwUPE0czyxP7Dq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QrrUE2/o; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42557c5cedcso14972f8f.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337113; x=1759941913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZF0/7NKHmGsxltQLUgG2+GyvAElBS9/WQenlIVcQwVI=;
        b=QrrUE2/odvZK4ViHUtVVETcXO9xR9ngmwcvdsjTpL3ln4HSSa0yLa83KpVZt+JP6pk
         FLEaogxR0r4yy8XKA+FkvzlH5MwDA4wJKYAGTK4zZo4ysyqBQsd3VlU7+7H8WdZguiIQ
         iZdZeWZ+un9i6/LdxR7cVJtkL0utKvEsZ19tetkPhRbXIpfTucTFBvg3XgG+EE5b8hfs
         ymqm1KeFz4B3Sxt0884naUHAIi/XoX2phvu7EETpssQQF+QJQ6zKla7XPRE0YlDH736Z
         aLRDdNsXwG7VL+uQrTfz1rEtv1NFyDQj/b3tZoqM2TkUA/dQDR/AsHUbUZRV6v1eZiDy
         A0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337113; x=1759941913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZF0/7NKHmGsxltQLUgG2+GyvAElBS9/WQenlIVcQwVI=;
        b=o6CbpL5LOGgkpmjy7aXhsTC6XVlm8kBiLyFuCQf5d1DuRYw5AkUjpEJmMvXLJPLzLm
         s25N9+gcQ1zWMqdU5I2W87wzCI991JNU0fwElUCcHy0F8eDsAd/mYeaQNIqFo9f2EAcN
         AC3Z5vVVEyiuYNhswcWL7sBtR67GRWMnvENN9iRA17irEnCPPBKl2NqxSSiCUPNzIUd5
         OU7WZ43G9TYTnN5GYbuBblkczTQVWUngcNEh0m6g4YSNy70nvO5INS+K5i/Woht1an7D
         0UQvYplM2EYQdZ0UCDMTpVFUgHb/C9+UhaA+p7LYO4r/k+GuWLqGgINFd4Kp6uJ/SjMU
         Jepg==
X-Forwarded-Encrypted: i=1; AJvYcCX9H/V4qaH7jW15V+jEJ2DgoM+xEXUYhqgRKssDZFCFbTarMqRnIMx63x+pJMT8O97I5Tc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8xjRBEFLpf+lRAvzcL/FxzHlc7AxDieBhpYfcYYJ8/nzb3wtN
	+re5X/cty7rVe6iu5jus3ZJL8zAx5m2xLGLNQk3RKf/6BLiH+O+iDrtwQu8Au4iAIKY=
X-Gm-Gg: ASbGncttEkgiW3//vdvOgyOaUcsK1ec67hu8Ru6Z64o3UsFY1+bOzHvD4Hc+HWNJSYl
	4p1vltClb7YGBdKhHvgJ5WVYLKDPc09Wrl/jkNGvQqMbYwBsg0INYfHaxe2I9stLbjV5XoptL0k
	YNDtIov14bZYinmYD6jYHhuGOFlfU+EHKv2Qd6Wfnawu729vTdKAx2j0xl0kBDUykznFK5ZORbM
	7Ypjf7Jge9NJrBIfR+dZ80F4zD+bzzKy2/wrZ5cn8JzzAyfIXhBvYswLzgmOWyjakyJasr0Nzcj
	6MHPBXhpITT43w02SUwOvHTYa9y4Z+BoSRnxdlVV60gQdQaOMnEj78pSvYABZvPZ9klQ6ROveby
	8qsDRCM5wQNkPiYxAbdDwrGjJYarRX72K2c2yCJhpNmI31174GRoNXahv2gZ3N6Y6bb08HaAwxi
	hoJfCDBue5dIWazt6lqhqg
X-Google-Smtp-Source: AGHT+IFnPvn/75MQHEavymTCcU+aMgCbscZUZr4f9pa21JdkbQhKSiJMn9TY1QMBoMpVPn0VhJXgoQ==
X-Received: by 2002:a05:6000:2890:b0:413:473f:5515 with SMTP id ffacd0b85a97d-4255781b8c5mr3187923f8f.48.1759337113221;
        Wed, 01 Oct 2025 09:45:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41f00aebdb7sm15112856f8f.57.2025.10.01.09.45.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:12 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 3/6] system/ramblock: Move ram_block_discard_*_range() declarations
Date: Wed,  1 Oct 2025 18:44:53 +0200
Message-ID: <20251001164456.3230-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001164456.3230-1-philmd@linaro.org>
References: <20251001164456.3230-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Keep RAM blocks API in the same header: "system/ramblock.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cpu-common.h                 | 3 ---
 include/system/ramblock.h                 | 4 ++++
 accel/kvm/kvm-all.c                       | 1 +
 hw/hyperv/hv-balloon-our_range_memslots.c | 1 +
 hw/virtio/virtio-balloon.c                | 1 +
 hw/virtio/virtio-mem.c                    | 1 +
 6 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index f373781ae07..e413d8b3079 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -163,9 +163,6 @@ void cpu_flush_icache_range(hwaddr start, hwaddr len);
 typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
-                                        size_t length);
 
 /* Returns: 0 on success, -1 on error */
 int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 7059b20d919..530c5a2e4c2 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -103,6 +103,10 @@ struct RamBlockAttributes {
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
+int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+                                        size_t length);
+
 RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
 void ram_block_attributes_destroy(RamBlockAttributes *attr);
 int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9060599cd73..e3c84723406 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -32,6 +32,7 @@
 #include "system/runstate.h"
 #include "system/cpus.h"
 #include "system/accel-blocker.h"
+#include "system/ramblock.h"
 #include "accel/accel-ops.h"
 #include "qemu/bswap.h"
 #include "exec/tswap.h"
diff --git a/hw/hyperv/hv-balloon-our_range_memslots.c b/hw/hyperv/hv-balloon-our_range_memslots.c
index 1505a395cf7..1fc95e16480 100644
--- a/hw/hyperv/hv-balloon-our_range_memslots.c
+++ b/hw/hyperv/hv-balloon-our_range_memslots.c
@@ -8,6 +8,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "system/ramblock.h"
 #include "hv-balloon-internal.h"
 #include "hv-balloon-our_range_memslots.h"
 #include "trace.h"
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index db787d00b31..02cdd807d77 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -23,6 +23,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/boards.h"
 #include "system/balloon.h"
+#include "system/ramblock.h"
 #include "hw/virtio/virtio-balloon.h"
 #include "system/address-spaces.h"
 #include "qapi/error.h"
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index c46f6f9c3e2..1de2d3de521 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -17,6 +17,7 @@
 #include "qemu/units.h"
 #include "system/numa.h"
 #include "system/system.h"
+#include "system/ramblock.h"
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "hw/virtio/virtio.h"
-- 
2.51.0


