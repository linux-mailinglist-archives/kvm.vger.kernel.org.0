Return-Path: <kvm+bounces-59383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B32BB26ED
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E79F426F2E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E091411DE;
	Thu,  2 Oct 2025 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UvfUFBgO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B03149E17
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375716; cv=none; b=KpcDrloBPhj8YSZi0v+HMb42OceuF0LCWFOKEacD0qyNbmuga+ByTSGc8IWCjhgMKf94Z1a92GmoH9IwaoRslybAPGHQ8yURmK6aggi/WWB61Atzb+C+OZwjuQrJJuXojqKqd+rp/uZmYxX+RkKOgc25sWZ4OxjpwpjVu/juJyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375716; c=relaxed/simple;
	bh=sAyWCEnEoJ4+T7vNLcfj9hCPMIO01/zs8lZFlvZLNto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qG+wnrr7YTYI7O0xEaqkU3zNGl6kMeF0CXYBwmW5nHBswkSHJoPdId1VzDxb4T3ttJM62e07NBldIJQxc+3RbnqKRg+SBzzKfiiLWl0ft2/BGxUAztoayQJwqtoNxVBcYNGO3f5884ebIt1nWNefxayt3gtQPU7bUN+GLtM2BXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UvfUFBgO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so4445845e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375712; x=1759980512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzSBSlHCaylp8fky8q2R9+J/jUXS84YVjjAZKK8ryHc=;
        b=UvfUFBgOdjc5psrLglXs6MraQhItOd3teFE0c8L8umcztNHBfrQZmW3X07KI5YxjO9
         QD9SlyPCkWdPyLwFAM+k9q9wsMrbDM86931l5MmJIoDfGUxWXWvkDT6RmgRCxAFPD2dA
         8mz1glzjkTdvJckDe93d2ikzCYz469o9qHXi2khjnyvgwRyK0/6QlXfw7gD6y834hzLQ
         UF9Z7Yooo6wiwE75+UC0S/ndK3BZr9SDITxf+KKhWKLNjyYxnNrFiBQKBdy3HOmdjdjR
         Mw6h/Dg+Ly87J/xpac9X6mnDg1HRoCAs1nyefGPMKDcf+NP0oqAo36CtUUyVFXazYBDX
         sbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375712; x=1759980512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzSBSlHCaylp8fky8q2R9+J/jUXS84YVjjAZKK8ryHc=;
        b=N+5svCoBzUN9AjyQL2NMQIQry0lKz8XTToHqCWG4r+PXUspEpn/turp1G9tkIk/33y
         HCIeEER12J1zh6mjLxWFPWn4bKHWBbfmpxo93ZifoCXKBnilpwGZzDfKEn4cOD2A1CET
         Ywv1lAoZYGq3zxapsom8AjPExwy5dfr8h/Hetle98ojuQYGZPeAe4UGcK7lxTtgmqhKj
         xuHBIGIRj21KLJAwmQ8WF6oPtFiyw2PuNIjDLWodPEbrKGAy2qTcqXe+KXIo5hF6ABrM
         HKD0/5qPgWeKx0j+nembwR7cZOq7QEtv5nfQKRX1TYf0p0GygvsUwJ0LtG8j91Aa+1Gx
         D/kg==
X-Forwarded-Encrypted: i=1; AJvYcCWtcOvaM60O77qmC63+XwzbW82fDt6Qu0FbZUo3FdyHI1E2UhaKFESzakhUNdlHp2/vMfc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+nF5qQrmlAQE5y/Bee8M4ehjhYj6WoUYPECGYCMKO7DHfWc3v
	6sPgVHiSQ5KLlbRnWumRiMxFn2jmV4HnN02rJHOWjjPz8cJM//Ltj375hD/EFsh3hvo=
X-Gm-Gg: ASbGncsGvXNFuEX/zRMpbGIYYFeNIQ5N6nfuZGgIdtpNFNYKmqfbMboUtKWLw09BE0o
	K0fTJ+2yq/979JrvfDNsWJ24UVn4MLuUBD+HskbRjPqXrGItuwer6rE3jZDKlyUWspNt6BgVpLX
	dszlg8elQTiC/fKeL5e182hL+FTw8+3D1mHTZzKtdoL/fOwkDQtn6Mb79gbuAJxwEbDXdnBXNEt
	hz1xA+FLYbTTIKMfq2rYKezfsHymVxdblPjSFBRG2BYXtI3BO1tHorIau06qWEeJePPpU/+SDkC
	j2t99dvN7SfJGhbgkSHkl/UdSORIzhnWA+GlFbzVGI7vJ/HDvm6K8zoGpL27qXjNeaNOIvzyvco
	7JIduTuvScY+WiuoC/pirRsNUbr2y2LaG1mXHX+9KaN7ozwC/mBkPID/zWcyY1dbpRRGNnV00V0
	p4hFZSrsmDn4mNkgQWV9/O/Ld5Dj7/HpDguCTtqjB6
X-Google-Smtp-Source: AGHT+IFI90XTy9jeau0chMpSrKJtHcRaacrHSXE9+mPhxzMInivlCbyXQQVWlV2ajvnKP0lGmemyFQ==
X-Received: by 2002:a05:600c:8b02:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46e612dafafmr47030715e9.31.1759375711852;
        Wed, 01 Oct 2025 20:28:31 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e97f0sm1578485f8f.27.2025.10.01.20.28.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:31 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v3 3/5] system/ramblock: Move ram_block_discard_*_range() declarations
Date: Thu,  2 Oct 2025 05:28:10 +0200
Message-ID: <20251002032812.26069-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
References: <20251002032812.26069-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


