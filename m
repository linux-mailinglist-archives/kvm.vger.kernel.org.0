Return-Path: <kvm+bounces-16586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D958BBB4E
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C26D282BF8
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55810364AC;
	Sat,  4 May 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhIR2UGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174CB39AEB;
	Sat,  4 May 2024 12:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825823; cv=none; b=mVQMrsKNSvXE5ib8jkzqHYzx+ZMVdv/Fco049EqPHylvkTKkv/w8SfY78ZiFAVSJqM9DolERS7ZejAXAVeFPADCIwUz1I5FYxk0n6LMeEPlgqZtpYECPo16DZXDDrCbQc38c0eBInJ7/blVp+RobpbVXToVE25fVPqXAYNnzKmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825823; c=relaxed/simple;
	bh=KiC6K0da/98EFnBGY92R450ZUqAwL4fRmtoTVFoCEG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnmtHhhW+FYLhZZSDGNtvqcHtdwQXA70gMAemXKCOBD18lvCTijOmuq7w29OsqHgZVz3vwWo/ecw9lqqorl1CD+t4wFkLa1lmRcCRGcWzqMtI7qc9LyE1iSGBKyex4GJ5wT6x0/DxfYZ9mFP583J05lDCeI0gktuTrYbeAsoD+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhIR2UGZ; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-23f02e15fd6so86097fac.1;
        Sat, 04 May 2024 05:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825821; x=1715430621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Ev3MpJK+g2Tv7erZ4N92Jbmsn4hd/SpLK5/bTsHc98=;
        b=YhIR2UGZK+MgHbIF3KF6MB/ZL1TIybl7RtBD61z4Wqaiq8DEmKlSPyaBRI51pWFs01
         4KC5revKl0Lod6Xl1vFYsCB8w3NcuCHkyTFeq9M5UI/+waBu/+tNUTxK8Cxaqrc8Cth9
         tbbyrD8HfjHto50tRA4ARw+LbQKc8e0yH/Y4VlAk6vbgjkMslve6VuYA9t2HvmAaNQx7
         cjr8Wyl3YqPREwA5Kn9/qmonrtUHAaooj6UuVXey5+jYQRlXGifvPhdd3ouq26ONhjta
         ynnCEhl56z+roT3OyN/YynEx6mjWCxB9G0FZPF/C/kc9ZzMvunj0WNdTK3FkIIdIx95D
         KVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825821; x=1715430621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Ev3MpJK+g2Tv7erZ4N92Jbmsn4hd/SpLK5/bTsHc98=;
        b=LPqQIv73FUJhwRgHVmSajoTbiJKc52ycVq3oiaZlKm3kKyJCWMSFHiNWd+7TDpmV4l
         NVa0EZvR6Y2PWJdBkeZ81ZZSfdnB2ehwdhQCzkoMesT5BkXyEyEs/8EX4HWWgPh6ucgR
         ZfLX+eSnxu3hwgWVKNfG0BR1chI3IbAxni4kRso5EI3xxd0i0ohd4D0GLB65cV4rCHq4
         v5ui/crLa6HpwZxTEvZB0BVX8t1eSkqtwqf8H3Ug6a56noUHPZZXhzEranozioP1Ulhe
         eP2+r/SmPyNXfeEJK7O/zEj6eWnV6IQQeJNmcLnbaIYO69oS3u6ziDR27cy4VD3ylagm
         lXPA==
X-Forwarded-Encrypted: i=1; AJvYcCWtl0JPSt3zNqlQfMz02XOGOHEq42dwp71Zdyhu5da6stv8QZZzUE15qo6g2dLyHyQXe1i4uQRBuV8r0xkBSNjhTp6d4Js4QSDYge50LGHRxtie8RhpXIW/oyj/NaLjVg==
X-Gm-Message-State: AOJu0YzIqTm8lXKelxuvvsFgCmoJOLG5fibTKFZ7iPwgA7hG8eRiFE3r
	gVFB1rtGrPxNhA7zRiIyOenBAbe2s/g8BfB84m1kPVIkyHcwGtW/
X-Google-Smtp-Source: AGHT+IGXK9FNNpuv9Y86irFXe62k+b4lm3bpmrwgI75eg9XgfuOVju3ss2aGbqNi5oKlxkQRfiVoHA==
X-Received: by 2002:a05:6870:958d:b0:23e:8a6b:6acf with SMTP id k13-20020a056870958d00b0023e8a6b6acfmr3925485oao.32.1714825821168;
        Sat, 04 May 2024 05:30:21 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:20 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 23/31] common/sieve: Use vmalloc.h for setup_mmu definition
Date: Sat,  4 May 2024 22:28:29 +1000
Message-ID: <20240504122841.1177683-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is no good reason to put setup_vm in libcflat.h when it's
defined in vmalloc.h.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Acked-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/sieve.c         | 1 +
 lib/libcflat.h         | 2 --
 lib/s390x/io.c         | 1 +
 lib/s390x/uv.h         | 1 +
 lib/x86/vm.h           | 1 +
 s390x/mvpg.c           | 1 +
 s390x/selftest.c       | 1 +
 x86/pmu.c              | 1 +
 x86/pmu_lbr.c          | 1 +
 x86/vmexit.c           | 1 +
 x86/vmware_backdoors.c | 1 +
 11 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/common/sieve.c b/common/sieve.c
index 8150f2d98..8fe05ef13 100644
--- a/common/sieve.c
+++ b/common/sieve.c
@@ -1,5 +1,6 @@
 #include "alloc.h"
 #include "libcflat.h"
+#include "vmalloc.h"
 
 static int sieve(char* data, int size)
 {
diff --git a/lib/libcflat.h b/lib/libcflat.h
index ae3c2c6d0..16a838808 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -154,8 +154,6 @@ do {									\
 void binstr(unsigned long x, char out[BINSTR_SZ]);
 void print_binstr(unsigned long x);
 
-extern void setup_vm(void);
-
 #endif /* !__ASSEMBLY__ */
 
 #define SZ_256			(1 << 8)
diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index fb7b7ddaa..2b28ccaa0 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -10,6 +10,7 @@
  */
 #include <libcflat.h>
 #include <argv.h>
+#include <vmalloc.h>
 #include <asm/spinlock.h>
 #include <asm/facility.h>
 #include <asm/sigp.h>
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 286933caa..00a370410 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -4,6 +4,7 @@
 
 #include <sie.h>
 #include <asm/pgtable.h>
+#include <vmalloc.h>
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 4b714bad7..cf39787aa 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -2,6 +2,7 @@
 #define _X86_VM_H_
 
 #include "processor.h"
+#include "vmalloc.h"
 #include "asm/page.h"
 #include "asm/io.h"
 #include "asm/bitops.h"
diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 62d42e364..10909fb7a 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -15,6 +15,7 @@
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
+#include <vmalloc.h>
 #include <alloc_page.h>
 #include <bitops.h>
 #include <hardware.h>
diff --git a/s390x/selftest.c b/s390x/selftest.c
index 92ed4e5d3..3eaae9b06 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -9,6 +9,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <alloc.h>
+#include <vmalloc.h>
 #include <asm/interrupt.h>
 #include <asm/barrier.h>
 #include <asm/pgtable.h>
diff --git a/x86/pmu.c b/x86/pmu.c
index 47a1a602a..7062c1ad9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -6,6 +6,7 @@
 #include "x86/apic.h"
 #include "x86/desc.h"
 #include "x86/isr.h"
+#include "vmalloc.h"
 #include "alloc.h"
 
 #include "libcflat.h"
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 40b63fa3d..c6f010847 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -2,6 +2,7 @@
 #include "x86/processor.h"
 #include "x86/pmu.h"
 #include "x86/desc.h"
+#include "vmalloc.h"
 
 #define N 1000000
 
diff --git a/x86/vmexit.c b/x86/vmexit.c
index eb5d3023a..48a38f60f 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "acpi.h"
 #include "smp.h"
+#include "vmalloc.h"
 #include "pci.h"
 #include "x86/vm.h"
 #include "x86/desc.h"
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index bc1002056..f8cf7ecb1 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -6,6 +6,7 @@
 #include "x86/desc.h"
 #include "x86/isr.h"
 #include "alloc.h"
+#include "vmalloc.h"
 #include "setjmp.h"
 #include "usermode.h"
 #include "fault_test.h"
-- 
2.43.0


