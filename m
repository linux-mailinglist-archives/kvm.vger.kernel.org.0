Return-Path: <kvm+bounces-58993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C91BA9D50
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF03B189ED70
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5889630BBA5;
	Mon, 29 Sep 2025 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JlUfd+qi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6B2FBE1E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160749; cv=none; b=YxNeHSTF8gyKjM45S1W5axXRdFts2LatqfnxCfXwOoM0kAzaLtaOAoxZzAmv4tulOc6OyZILWQWgLnles4IdOjGGtASR5PafTKjOwSXf6EdC6F7tExBl00icql+Mx4YySHc5hjpm4eB/EcuVfcnQsgKWatCvDHJ/y6/Xv6iKPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160749; c=relaxed/simple;
	bh=fVH1wojNxCOwBGSIrrV2Ehy4Wu46MFweR9F6VLl9xOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnxP2aK169gZ77ITe3wFneQEv3T0vAiJmYo5Yb6WCdgOco+ZNrdBNHA4v60iuiTdX4J0/gv1be5tV6Pf5MArEq5idj61CoIvnIiS+ARVQ8PZHWaav61HRCc+bsUgDH2nWfZCDjonYNiQVJv5DpLitRNEPEHseXHUJU3Ba1bpEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JlUfd+qi; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46b303f755aso43416265e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160746; x=1759765546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOipWRU8fk4RKadfaCTuleiBvZNuXiEbbPLdGlI48oU=;
        b=JlUfd+qiAvcf4piazEdo1VDP9Id1NetTvvQZVVHT53J2cHqX2tdXAwk9xx/doUG+g4
         hRXBccRnUhQe5b2xtQZlV7Emz9M6q74V613xGLCh5+hLKnILz754mqQncUa0uJyM9XBJ
         JMEga4aOlL52q8DB10M1iweNxbw0pGgB4VvlP+QybgAGTs0bSVQ41IBeijVDah5+l63P
         +jEUDqr/Jv6rt2qJUnLXtL7tIuh2ZNvnGLpM4XBx/7oiz9CZJm5Z71gabrfxe2zp+uyl
         Ea8UX4ywhrr2TMEkEVbJsspuibbwv8h+jZeYYEwwc7hPnnJI2uneRfEPZT4buCLL62dv
         ZIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160746; x=1759765546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOipWRU8fk4RKadfaCTuleiBvZNuXiEbbPLdGlI48oU=;
        b=Pir7PmaPcCS/p0qA1c1MfwIRcrQwsTk4dsqeB9cdeWRrzROTqHZkHsE/n8grdK3Dg8
         M2ICnOeIzU0MAujKCA9bvHn91iFOboB+2WuXoA0F73nq3b/FYyUoUUHPqEtGORJMfJyE
         TkMon8Psj9nrwB4gz8fqLLvIfMsHY0Phsmu7dGa66rFDIw2G9SO/08hqSJbba2jn40/m
         Vd0jwrnlJTfLPXZlWXMN6xb7IPEO1VPdW01ZFNWI1EfwtVS7uFRN3eWmR9g6dBW6rvex
         RzMYb3ytkG/ccjn27msEw70xl21uEvpqftECHWsZ30eRCVudZA4s8xwfGQ+w/1dXlYWw
         yCmw==
X-Forwarded-Encrypted: i=1; AJvYcCV9WToPbpNKRFI6JQrFnDnZY9r2JNONjJLVi7JpgRCIpqFq0juz7TKVUced4XoRob5us9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKqOt8ZDdLoxAPFTvM3wnoq0rHzJuh7DiYXYkmrE4xkKSFdcRZ
	4l6ZJTzxCeKWqgxe13V+FOmbVLNJnmRpZElBuCIz9zNXGtmRBIIOjbGSkcNBuqRgIzs=
X-Gm-Gg: ASbGncvZlvdQKVfo2cmCGMKGFbNQ/vmYuoUk3jrQCn70e2ylTdfl4yPDySsYcIW85kh
	Q85MOwQrzGZB+YmxTckmmUrDRXDTfOX30nYYn02OODC23FtpzlQ0RlWah5qzcIzWH7vc33Rs4pG
	g3Gj5wIhna2SCAxcN5uFtRURHoyyNIhzJDAyw7HILW5o9IPJMqvov4sYVGIHsDTzEjascXHVvCf
	8ocHTFXltAFTWnhFZGs0DI8Z6cqPkbz0MmWF7WH8QD/lfhGUOBMQojpQSN4wIDczDHUOYywo4Il
	8imoP4Yx7xXDUwVr0ZDuxvDYN2UPo8NzraT+4eYEmNC2ObJMJmkIlZa8tXL8OFAXqcguj0LhKGz
	Kg8wcLjEppHCHEF+d3lxLxIR+ZLEE68mN3T0m+PCILNmOdmEf58Yjfojr6nLgW94M4VjmhXNE
X-Google-Smtp-Source: AGHT+IEqDnpJSC0UsoPMmNpmG7ETJKIQx2OcIo9sQftcKrpnYAKz1TRrqCbtGIzqdge9XOJaoUrErg==
X-Received: by 2002:a05:6000:613:b0:3ec:8c8:7b79 with SMTP id ffacd0b85a97d-40e4d9ca985mr15223191f8f.61.1759160745826;
        Mon, 29 Sep 2025 08:45:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e572683ccsm18198795e9.22.2025.09.29.08.45.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 3/6] system/ramblock: Move ram_block_discard_*_range() declarations
Date: Mon, 29 Sep 2025 17:45:26 +0200
Message-ID: <20250929154529.72504-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929154529.72504-1-philmd@linaro.org>
References: <20250929154529.72504-1-philmd@linaro.org>
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
index 12f64fbf78b..e69af20b810 100644
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


