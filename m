Return-Path: <kvm+bounces-40506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F9FA57FAD
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6134516ACD0
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F193E20F06D;
	Sat,  8 Mar 2025 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SJYNYLnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57181C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475400; cv=none; b=JzgDbn7qCgDti1lBS4t/6juZovwnTh0e809zO8P0orVSWgpZBP+QZz7MZ+V6HwVZS5M2spbAZlYQ61ytNuenqpOs+RUwZMtY5o9vMq6U2DvtDJjF61j2oIPIAAlCew+XYDAg63Ax7iVOEaL6WrpnDcl9Fq/yJZBSA45G3UkZUwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475400; c=relaxed/simple;
	bh=H8Jdo813l2emcZDHgUTUtanp32FnR3rq9PY/Qi/t+iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GEBHKnKI2kkZDefiAFfmJwX0BLzQQWJ3LGpukTSVMv2g0cgUtIeuMVhFtWmU1VslgHZmfA5MX/orx0EshdeCLp5KzYo09hfy+iEmJaYgtyS6/ugAcHqgAxadRbVJunTS6H5cEjV8+gv+/5OvirN5tq8clv4NIkO1rzm3Tj8jhQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SJYNYLnW; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3913b539aabso418815f8f.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475397; x=1742080197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNAZPNsyTlqo2tLPWvhBvh59TFVcvzQjUjnLojvYJaQ=;
        b=SJYNYLnWgoPW2Z+Wd49+TH7ra5JvfMrWTrSw6eVCcfdQzh0LKGMAq5O3rG3PLO5hW+
         fvc+vCPEbujO1GuhwOnP47AWepe3QXS/ZBObTnpTFB+FSz35b44t6/v/xjlRUB98nTMu
         Oi5d4TlH4dLcKVepsX3rSVwrgDSpAVWs8EuqelI+xzSRDsr+84LgqxOvipr8d5IOis2J
         /OrAE+15X5FYM0WwW9dkq0ZdQdRyH5ch1kMJ8OrVK+IHAaSkr4O/gt2dr8vAPDliEuYM
         iBJq2mHf2hRsUgKx7jTZDR+CrLo22sgE+02cvNuj62sSbnEX8sATo7AVu/PZeRmuuOLA
         V3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475397; x=1742080197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNAZPNsyTlqo2tLPWvhBvh59TFVcvzQjUjnLojvYJaQ=;
        b=B6Sd6Rl7AcC9qOTwIzzDGShbnssm3BPZifNAV6VcNrmq20hOAa7vBb+hxNHFPZPDrH
         dFhEIkqqAhguxXxZQvPvmgMsbaP0wSRrYklLa1Uti2J7FZru1y+rxPgGe9FStYaYZ8aF
         0WskjQNm8u+lGZhpLbOfCyczIkHT6lGrC/jYB3p2A6z4GD1wDRBC0+QzD6dSOpuzXpuU
         k3yqf0rFo8vQh+ZQBUCdg5I2i+aL9qdhJ0ranrVwNCuBIbJ+YOq/PUGAGDS//bSrC8F+
         J0d4gP2WSw3P5s9jn21pmPGnqVp63Qxh5qiIqvPAf1nuQxmmXyjAvgcBqt1yxfpbjmWV
         X9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVuhep8lgJpxHcWiQGIvNb3gC3+uGEhBHv1rKHiA7yl7+mODzuZkrt2KWhD6LwpmWDxrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyHOXBgLlo0TAdgHONp7AraV24PgM+V0bNZeU44lcSirHAGyBE
	6ZHSbF5Qtd2KR132Uc5/l9MQApCQE8ZIU1eq8qzZlymOtdJOJfJ2EPOi13bFgMI=
X-Gm-Gg: ASbGncuDUernZFhrursNrmJHrUQ7eW4OV89KrX4trEjiwfcnTzH83vm/xgqNOm7NrvJ
	Lfs8hOKh+eNSz14Q5A4djYmsTuj+LmcddjFC+oRZkIM5Zcr1A7i1InSMFeH12U1cY84uY2Ncvah
	+Ce5Ecpn65hcAONKYsx6YskyF2jXup7TQ1PxCc7lgijc7uttNZ29V051YtYVzeyhAY2kJ8Ifjgb
	TbfqU2dzbRCQG2ycHCHNtSTGDc/vCBohFJmvsWS/euK5TmitBW0x8PTCnUgbTZ11RDf9WVfnupC
	VyDZD0EsJFIYUgtoTvJW5OSlbLukue4b8bTY2gghF/gZXY8nhrrPDhKluEBOnZNPK4swh2IEg/6
	B6Bkl39VqN0oOEGd0faM=
X-Google-Smtp-Source: AGHT+IG8MQrKfOJU0WoQHCAOd6Oq6wQcj1JZv9hwm7SxDKuTpUWDCbRgEKRZFOWkkDK4Q+3TnMf+nw==
X-Received: by 2002:adf:a1c7:0:b0:391:4095:49b7 with SMTP id ffacd0b85a97d-39140954a39mr1073805f8f.25.1741475396652;
        Sat, 08 Mar 2025 15:09:56 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd426c33asm132242055e9.3.2025.03.08.15.09.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:56 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 06/21] system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
Date: Sun,  9 Mar 2025 00:09:02 +0100
Message-ID: <20250308230917.18907-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Both qemu_minrampagesize() and qemu_maxrampagesize() are
related to host memory backends, having the following call
stack:

  qemu_minrampagesize()
     -> find_min_backend_pagesize()
         -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)

  qemu_maxrampagesize()
     -> find_max_backend_pagesize()
        -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)

Having TYPE_MEMORY_BACKEND defined in "system/hostmem.h":

  include/system/hostmem.h:23:#define TYPE_MEMORY_BACKEND "memory-backend"

Move their prototype declaration to "system/hostmem.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
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


