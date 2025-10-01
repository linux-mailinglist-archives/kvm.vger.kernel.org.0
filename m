Return-Path: <kvm+bounces-59349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2791ABB167E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 194E77AE8B9
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2438D2D0C9F;
	Wed,  1 Oct 2025 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QAo2nQrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E816265632
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341327; cv=none; b=myLTQYDoezYYte0QF+pbNZQecxJqHkZU8u9eAkVXxI2bPmvyQnE3IC3FJxQnNnjX2G51bdh6yBQ1Fp/h+SDt5ZkmaKKNDniXO06/3nMnPxXWm1LwwciwVlRu7vbx7xRka9zlIUS5uTEdbuwprvLhy83/I+H5tcS+N/VwO3zbNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341327; c=relaxed/simple;
	bh=QvTg1sXKill88j7IKlThmuT5QmYbUXhhLWfOWDri5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K34Tuupml34n2pdb6Ursi78PT4WOcq3sYp4BP3w7STzOs+e7/4n7bf61bOtOHhWfj067Eyd+0fm205gP+XEkirANdjk1hrVHonC/ZmNLb38ZD5PYciNY8KlvilRAA9HrJfoSL0aNWzBC4xSheBMlVI3P9qh6UKOh4S9+iTf/cd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QAo2nQrX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e3ea0445fso517065e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341324; x=1759946124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aokqeion6vg/XBK7zMSfidbyVnYpQrHhaMRTyeMkDMQ=;
        b=QAo2nQrXRd3uFxxVCxuPq8cXvdKJdpTvgC9q5Ib+f3do3jSpAg8hNHma2K3DvoXDcW
         BdOEIsE/NjgP55s+KpJq5vz5x7ZMqnl4Qd/sL6pM+B/F2Vx0X4uzvOH7CMlKnsULypWc
         E/O1cORR5IKi6zMp0dfWmZ/PYWNo2bENW5Kf6WASfntUuONKZv7FfrYLBvBfc6XZAAgi
         s5tPyMQ38HiJ72uEKOvuEwhx+wKg/mqSnI7CW0V48tNFoXkalXJ9MAtZ3bQA9hN8LueZ
         +0TJr+hENUc52Ya0WJqPvD3RaeJUwm3Vzn5AIgyJ3kn97tAdPX5p/QauwgIHSN5WG0TE
         C8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341324; x=1759946124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aokqeion6vg/XBK7zMSfidbyVnYpQrHhaMRTyeMkDMQ=;
        b=HK0n6pSE5WRdxdVIhOxvGZWQDBI/JgyST8V7H7ZbT1zk8aBJa9XIIwjYdBzhfpx+lv
         t4rfxKIwwDMgUBxpeQJQZpyCHekpsh8OutT7vtgZDIb2KRnkF5HPMbNzYMTr5p60uSMk
         B5FHyLx5XWPTuBIq0iwYV6KbHdDTHeBeU/2QEWPOm4lmPN6t4fz7+iJn8o9QxyZ/6aT5
         ELVvQzFsNLjFJj5qo6C0BdBy7ECGb7/8QTEKURLsvL2cE2w2Oq0FY52CwigKFeU9At5N
         z6RyPAhwpgVPc+4HVW5fsUrjin4+pbxxqa/jRh93XzhL4c3uS3qzmsrGy1EPx2e22UAk
         08mQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnw0rmrDxVQSLxEIWVgqyxe8SlHBpQ9XwfpuMvqa3mq+a9fayBwDUYflO+QASRk9UNaCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTwDLuVw0XDuKNBaXfXSNgBvKm1w4QRl3YaO0L+WM23JyyhECE
	/mbKeNwpSnpkEwcEOYjGnw3GmaSqC6bNtmQuKVi+1gJbu/Byy77azNoiFnSymnMR+Ns=
X-Gm-Gg: ASbGncub3lDbBVY1wrBba6XUX4mSA10IhTIDOQxx26kDUkAYxui8NCwjznzFBII9257
	U9W9he0dQCSUH8VLSSqP1YyVqgSP5csKr3nLC3E586NfSWp8X30onb2PpKpIZ9xEz74orFpy5pU
	gojiKziuo3+kmW53MVEG3hZDmZkVHA2m5m7ymOm6VH2DbVrqXv+WLZz5O57olRkoWSKVKGZuzZ6
	1qBWcgcHSx7mMuVa/nqlmKM/lM8LaQe6KKqXbE2AvBt/EB2c0NmXNJCRhvpGc2Q5sNZ0tvv8P2O
	4I9uhf0fdsy6C4ENRTddKdOrFgcLojJhymG5UxlWTrXqHoVb29fyUH22wRnLcGRg9i2rlmRKqy5
	yHemAy64FNdM0WWoJhdYGT7gizeSkwoEjann6KS5UhodhM1tPMPnmzGIAoeB6jKVYY7m8ktAuRy
	ZpTCAnCPS5ELqKD6PsGrVxisCwDg==
X-Google-Smtp-Source: AGHT+IGTdM+ShrsSYsYPJCqJA4n0otn39Exzcd9EGo7lsVQICK9Ecvf0H7UF6pHszRiQWBgo2Y4+Cw==
X-Received: by 2002:a05:6000:240a:b0:3e7:6197:9947 with SMTP id ffacd0b85a97d-42557a15b6fmr3507602f8f.53.1759341323415;
        Wed, 01 Oct 2025 10:55:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm143400f8f.3.2025.10.01.10.55.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 19:54:35 +0200
Message-ID: <20251001175448.18933-7-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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
index 82fb23beaa8..97ab6bebd25 100644
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


