Return-Path: <kvm+bounces-59248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A352DBAF940
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D4C77ADC38
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A7227FB28;
	Wed,  1 Oct 2025 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wVpdhIqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09C319DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306925; cv=none; b=RBaXcoBNsJl1GTrrxx2isZPGUU65tkZYqxvhTGvOTKzHlHZerP+NbUiL3VeO2RId7z2sJ6mv6GsHIU9AFVWWGIs/Jn5q5sKqwps3Qi3s6kAFDEBhY4MCGBUAiVDfactj8u7G7VI/ysw18QrVlxJo/8dQpw17O2CB0whOqJpK160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306925; c=relaxed/simple;
	bh=am/53L3nYTbaM8zEf7rftKfSucLpbyHSzUwGcPYUySU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0ZDMWgSqrW/aMAU+OASIMGOXSkUFh+AnMsp1Lm8GLjtUvfm9py5xMoCXK5Xmla1Zyvo9UiSb541iOb6EBGpmKLhbBibTXmKEshrSh4LuIRIfw+g5BaEVkHEu3mnV037P/opAhSd5jUfF0TJQAR+G27LYY7RKiTzTj+g3hsW1N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wVpdhIqw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so24751535e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306922; x=1759911722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PmMYrzZ4D+COFB5SMLmnCIFwzyfRzy/9G7uraFCWXGE=;
        b=wVpdhIqw/35W4Yjm2DbN65hxTk9otQi2MUxVMCZr9qKkq5CJKOakc5IJ1LNcgDXtq2
         W76ms5T50m26M6RO8CKITuwNvDMIHo8mKMWAkNGooygUCa2lNHAiMqpnxM1a1W0l0B1U
         XF0JQ+l4oo2jJqwJwXuGTKzNaMoeg+H7NkMn3VdC0xxPFa6uax5vRawTATr4sQS8S0e+
         IEpyUAyVt263vVxpir2VCk0s32xPbNOwJZIGO3GairK2Idzltl7Mi8aX+mA9J022h8Xq
         D3qbEgUimA3A5OqL71BJMT66QkFv00sMAHy2HOvDh3h1vL9i2BH+64IrKEA3mHWYBrpA
         qecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306922; x=1759911722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmMYrzZ4D+COFB5SMLmnCIFwzyfRzy/9G7uraFCWXGE=;
        b=fy1d0PdQV/Mhoc0PNrT5fAHMMnlIYnoz+lMka5VxoSBoR0lShUbHrjAcoXXzaankxf
         0J7ssLxF+9ctMDtl6mAhZO/U8JpDuAFnv4aRJc1sUSyX+NypuN8rV4b8U3eIZrN4GXle
         tLBH85ebcBXM94iYk9EmCm26s7oG9LoYtm7HZ0l8qeu6nuvmNGNVNvT7VLxn4wU4sY7s
         0IsTCLgKy82ffcBNmSra8W646yIf5CBjBZYJJmoUqWFO7A7i8GDee7RSS3WPiUP/fKGU
         0iGbVHnoYtulzr0pJXZaFVbg2sL9uTJQo3j3NBlsPrM0yqsMTmrVSuzz5Lsdigr/hBIY
         o4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3Op3KAolxqYgMtnwrDQFz4DkvDEFACh+oHeGRwMk2ECxq7gUxvsuKA97ElszYwoextY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFFGSDDNB6nIGZ1LZxrhSY3HEJx15silKDOjqnljmEr2KmHeXF
	qzqlPrPPEaH2hQZ2M6pdbIDsDJ7x5bTAFVpUnqiJ9UxJFYibxxApYlED5tI0qnwjIy8=
X-Gm-Gg: ASbGncud5Dud76ipL00tRAzcw4rRJoFa6f+noW8Nixbze8mheRvRsZZGe7kC9X3aclg
	15rVr5kJ9bvhHf7i1MrMi9U8ck71lwwxIWQjpPbF/QsU0pyBEXMKlsHkD4F6+5oSdWSkSDmHbgM
	IciSx/mPF9izq4Mjvk0aCM26QBhL70lIxDlZVV1BfWTPMGPuyvrqsvkqS836jzZmigr48n5yC0E
	5ckYtoQ+AO54CR8jtABViFmXaLhHPCIRKl1Of6qWJeN9nLsqxnqu6REycNuGBLtfbK7aqvkyx4e
	rCt870rWGgy8lmHFhVITgiJ0mY+ekJPUbBbCzDB8vvszl+DE20EHs+YpKZr7AaMfe1TzvEW663c
	7n5Tx+tyImAypdzc5ozLktrImhFRg46Nz+i7YB+O+gR1yna/oFQu6dAaXP1P/4wCcdDJFS1ALql
	+ifBta1SxRaKc5GJI/6zNB
X-Google-Smtp-Source: AGHT+IHO1xSfq3+2eBPBriOScyM58WZ+3hjUuJsBi94Lwh6mBwAPJdjI/1LMjxcK+JWGn/tb5utZZw==
X-Received: by 2002:a05:600c:468e:b0:46e:36ba:9253 with SMTP id 5b1f17b1804b1-46e6127b93cmr20886795e9.15.1759306922129;
        Wed, 01 Oct 2025 01:22:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3b75sm27136995e9.7.2025.10.01.01.22.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:01 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 06/25] hw: Remove unnecessary 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 10:21:06 +0200
Message-ID: <20251001082127.65741-7-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

None of these files require definition exposed by "system/ram_addr.h",
remove its inclusion.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c                    | 1 -
 hw/ppc/spapr_caps.c               | 1 -
 hw/ppc/spapr_pci.c                | 1 -
 hw/remote/memory.c                | 1 -
 hw/remote/proxy-memory-listener.c | 1 -
 hw/s390x/s390-virtio-ccw.c        | 1 -
 hw/vfio/spapr.c                   | 1 -
 hw/virtio/virtio-mem.c            | 1 -
 8 files changed, 8 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index eb22333404d..15d09ef9618 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -77,7 +77,6 @@
 #include "hw/virtio/virtio-scsi.h"
 #include "hw/virtio/vhost-scsi-common.h"
 
-#include "system/ram_addr.h"
 #include "system/confidential-guest-support.h"
 #include "hw/usb.h"
 #include "qemu/config-file.h"
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index f2f5722d8ad..0f94c192fd4 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -27,7 +27,6 @@
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 #include "system/hw_accel.h"
-#include "system/ram_addr.h"
 #include "target/ppc/cpu.h"
 #include "target/ppc/mmu-hash64.h"
 #include "cpu-models.h"
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index 1ac1185825e..f9095552e86 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -34,7 +34,6 @@
 #include "hw/pci/pci_host.h"
 #include "hw/ppc/spapr.h"
 #include "hw/pci-host/spapr.h"
-#include "system/ram_addr.h"
 #include <libfdt.h>
 #include "trace.h"
 #include "qemu/error-report.h"
diff --git a/hw/remote/memory.c b/hw/remote/memory.c
index 00193a552fa..8195aa5fb83 100644
--- a/hw/remote/memory.c
+++ b/hw/remote/memory.c
@@ -11,7 +11,6 @@
 #include "qemu/osdep.h"
 
 #include "hw/remote/memory.h"
-#include "system/ram_addr.h"
 #include "qapi/error.h"
 
 static void remote_sysmem_reset(void)
diff --git a/hw/remote/proxy-memory-listener.c b/hw/remote/proxy-memory-listener.c
index 30ac74961dd..e1a52d24f0b 100644
--- a/hw/remote/proxy-memory-listener.c
+++ b/hw/remote/proxy-memory-listener.c
@@ -12,7 +12,6 @@
 #include "qemu/range.h"
 #include "system/memory.h"
 #include "exec/cpu-common.h"
-#include "system/ram_addr.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "hw/remote/mpqemu-link.h"
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index d0c6e80cb05..ad2c48188a8 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -13,7 +13,6 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
-#include "system/ram_addr.h"
 #include "system/confidential-guest-support.h"
 #include "hw/boards.h"
 #include "hw/s390x/sclp.h"
diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index 8d9d68da4ec..0f23681a3f9 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -17,7 +17,6 @@
 
 #include "hw/vfio/vfio-container-legacy.h"
 #include "hw/hw.h"
-#include "system/ram_addr.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "trace.h"
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 1de2d3de521..15ba6799f22 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -25,7 +25,6 @@
 #include "hw/virtio/virtio-mem.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
-#include "system/ram_addr.h"
 #include "migration/misc.h"
 #include "hw/boards.h"
 #include "hw/qdev-properties.h"
-- 
2.51.0


