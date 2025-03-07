Return-Path: <kvm+bounces-40373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A98E1A57000
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9190188FCE3
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFD123F296;
	Fri,  7 Mar 2025 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mDuJ7H+n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7F821D3D6
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370656; cv=none; b=RMAw95EYDhan6WnmvFnL+e3StSr3vbJUH0m8qgVXQfPrLQcmqvowXls7oLjDeC4E1he0D+AQQ1klpwFPl3oi0Yn1rliVE7nUy8LrTtc2S72Ne6eG/OIdsPqzxDBLyE8n0FqzAF0A8QaAeRwgAIRr1WZ64tbfFNhPwEVkI6zlrLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370656; c=relaxed/simple;
	bh=vMkJ4ZDNQbkS/rzmnAR5OMytElf/TyZxD5UeVX3EGfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hy9fkWcPgcwhStEA/cKtLfOiZt2uW84Q4DFNVCfUG5l5pdWxng5paxsSVwXG9f5V7eFrFCNhCpYQ1ktc7PXL56WYMBXdtlRCa1vcS7WwlaJa9iW31rUkIb4iLyjCb4F7YMhdq2TWns/TblMvrewAVNq3TjSCHLwagu/mwckFkqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mDuJ7H+n; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43bc0b8520cso13517765e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370653; x=1741975453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrW4KPeEMsJGAah1rF/LLgEoRbvBGZD/GNv5niDZ+2Y=;
        b=mDuJ7H+nTC/fXi+L6FIXNCQfbEL79XqqOKi4eTIiYqkPWaHQ3E5MtbD3/SvAywjC7F
         GUJ5Tto/146NfxkmPAavnqoSy4/WPhBGqn6POwUAvmG2TZzSiqVIcNoMjyB47SGyeqZP
         NzdJJYX70SEhoIragVj+HhM6mygLQTOr2n4NX3hicgG1IFqnr4QzopjXGuMEUS5rRxtp
         XGWHKXQL/vNOAB1ip4zFaFrLrAjN3z2zzJP7QRUgXCmfzwwCgpyCHL8LVtyVYuf3Wlqm
         s6nOq16Fv+wtLzpyxu5FwQLdwKzp5coBQu7CYy0x3zcCXYIILxrn6X+lvpadJXCVCDOL
         g6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370653; x=1741975453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrW4KPeEMsJGAah1rF/LLgEoRbvBGZD/GNv5niDZ+2Y=;
        b=MIbnxwVEvus75/W7790P8NM7fp9zlBWKJ3ISitGmoOGvtiB53d6wVl56/NSP4OYDL3
         n1r0v1GfSoNt9WnmfSgl1O7DltT8ujRFMg6gYGhH5vo0/xWg9GmOPLscr67iQuUGdif1
         TV4eqUzp0qXfRWN277GeEgH4SW/IzkXfHMnwAtJWmX8KVQbjUIaRDBm4ngMB+E1mJbnD
         jjE28k87LGBOtlusEFcMmNH5vOoW9jaMX/fYwJGUaNV/AIFbRajzTDI483n9uejEYPF+
         UwefhA4gXfWfA432gWoM0vhqKu5qwr3VG/YljAXKLkVyNUYE6VIVkHbgbBakKmz8I4E6
         lWpg==
X-Forwarded-Encrypted: i=1; AJvYcCWO2Tz37v0oqgIr3F/FzOwR2OtLvZ0siL0K5z4JKkT5ESSD42xNM+jKFZzQNrkJPePEYyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPhxiUAaM9IA7iLUEUlj0VCS/N9zdYsRwiN4M7WH8PIw89a6uN
	AzV4i02pdry0A7NZR6obD6qjM6tYbWQzNQ8MVc+8VIER/u1UJaH4JjlAHawDMZ4=
X-Gm-Gg: ASbGncstxC8ZZX81KJgQAIZm7cicpylms3F4tCqMSFJs3qjRui8HvRr7feLVR4Uue+T
	l5gOFMHDhruAWxypd2WnbwRVCSJnN0BauAkuHHgnN3kBQUm4EyLi2oo47G42LleL9iJ13qA4HWL
	DYmR8oowURUm3/3Gs96/qWfi2uL2GL4UCwXGcEPRDWMwjSv5CbDRfrsLPQ7LkvAU9TEW/W2KAJ7
	CeatyXRWDny8xalVU2AaSkvZFXju+a+G22rk9RJl9IHotmtx8M1SmMuf4nlchHcsGA19wkFsVTV
	gNtcQbdCmoGruScHRnRKBqfJwnhbY7SbJDkXJOrXf1TBTgELd/GbjwKqT9qxXI28F/DddhK5BX1
	bDVqm1rt+qIk9UZWBD2Y=
X-Google-Smtp-Source: AGHT+IGFTJtAtCuhG8E9BzVu/Ipl6XSR97mVKepvf/WN8vp2isiEEQxnLWYj7XYHqmF1ObgwOUeF7w==
X-Received: by 2002:a05:600c:4f87:b0:439:9828:c425 with SMTP id 5b1f17b1804b1-43c601d9508mr32710975e9.7.1741370652735;
        Fri, 07 Mar 2025 10:04:12 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8b046dsm58400885e9.5.2025.03.07.10.04.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 06/14] system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
Date: Fri,  7 Mar 2025 19:03:29 +0100
Message-ID: <20250307180337.14811-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Both qemu_minrampagesize() and qemu_maxrampagesize() are
related to host memory backends. Move their prototype
declaration to "system/hostmem.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/ram_addr.h    | 3 ---
 include/system/hostmem.h   | 3 +++
 hw/ppc/spapr_caps.c        | 1 +
 hw/s390x/s390-virtio-ccw.c | 1 +
 hw/vfio/spapr.c            | 1 +
 5 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 94bb3ccbe42..ccc8df561af 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -101,9 +101,6 @@ static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
 
 bool ramblock_is_pmem(RAMBlock *rb);
 
-long qemu_minrampagesize(void);
-long qemu_maxrampagesize(void);
-
 /**
  * qemu_ram_alloc_from_file,
  * qemu_ram_alloc_from_fd:  Allocate a ram block from the specified backing
diff --git a/include/system/hostmem.h b/include/system/hostmem.h
index 5c21ca55c01..62642e602ca 100644
--- a/include/system/hostmem.h
+++ b/include/system/hostmem.h
@@ -93,4 +93,7 @@ bool host_memory_backend_is_mapped(HostMemoryBackend *backend);
 size_t host_memory_backend_pagesize(HostMemoryBackend *memdev);
 char *host_memory_backend_get_name(HostMemoryBackend *backend);
 
+long qemu_minrampagesize(void);
+long qemu_maxrampagesize(void);
+
 #endif
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index 904bff87ce1..9e53d0c1fd1 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -34,6 +34,7 @@
 #include "kvm_ppc.h"
 #include "migration/vmstate.h"
 #include "system/tcg.h"
+#include "system/hostmem.h"
 
 #include "hw/ppc/spapr.h"
 
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 51ae0c133d8..1261d93b7ce 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -41,6 +41,7 @@
 #include "hw/s390x/tod.h"
 #include "system/system.h"
 #include "system/cpus.h"
+#include "system/hostmem.h"
 #include "target/s390x/kvm/pv.h"
 #include "migration/blocker.h"
 #include "qapi/visitor.h"
diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index 9b5ad05bb1c..1a5d1611f2c 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -12,6 +12,7 @@
 #include <sys/ioctl.h>
 #include <linux/vfio.h>
 #include "system/kvm.h"
+#include "system/hostmem.h"
 #include "exec/address-spaces.h"
 
 #include "hw/vfio/vfio-common.h"
-- 
2.47.1


