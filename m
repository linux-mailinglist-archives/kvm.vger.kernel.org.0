Return-Path: <kvm+bounces-9828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C35E86712D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A06B3B26719
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC8F5F547;
	Mon, 26 Feb 2024 10:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHE7Krd0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A95F546;
	Mon, 26 Feb 2024 10:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942457; cv=none; b=Hahg8MkvmnRqp64Gt6xWukuHB3kv3tKr1yQRvKW18pTONvaXGSNeeXz0nQFEKl7++p1fD/a23pdz2a5opXCysI7NnOhTqaAW07zZNigPn3+i96U2OunznZvw+avpy8OiBZHhfIMiBmPVthsUHGoqR0ZKboCfv/bjbcaAChvRxQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942457; c=relaxed/simple;
	bh=4HO2YbCBf38koFt0D4q9xHiwnrlGQRLYP+Gs/ryYuwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hOc11gpt9QgoEbMVOXFE++A6/6lqrQ7smN1x5cqPtd1I61fPW16uTiFRVDR2hjZnmlIEBTvlUBfnKTEz7TQK8dyGfwQr/aF7XUvCjq+Lm79wBL227xuyTZy66HtfavzoJJCbflXtT7HnFb8bLO5PN1DenlQGQcOq6b0eveyIVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHE7Krd0; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso2169888a12.2;
        Mon, 26 Feb 2024 02:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942455; x=1709547255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOXWXZAlVMmgv+nlo/ME4zbq3RxmSf+X/02kI8VKNHE=;
        b=kHE7Krd0DldXec5soT3YTnGYepclrwirkRJE8GbTE8dsGchTrsPjUJhZdGQ3dx96zg
         Zmvn0CPMIBjkKuk9ZEl9fpXYPnlyAV9njwIVo72xQj/R8xJ7BxauqumRyh1j3wEV6rB/
         W/CMu1cTZAWvd9bkNl/md+LQtLLiaKTo79jtV8MLbshYzGX4vRfrsPRWfRCkLE9QY3zI
         KUr+MWAcC1nLASYs4NacZPPAGuqg0gNl2Frqs5tAVr+BQIlGUKWd7+LiIOkMqjxCttD1
         Wq866AjjhpNFfqdPs5UHw4wqGGKTIErua3YJyYcRKL90r6xLWS7jxbf+DL6UQ4XCNAKf
         5fwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942455; x=1709547255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOXWXZAlVMmgv+nlo/ME4zbq3RxmSf+X/02kI8VKNHE=;
        b=UBNAW6DQxCizuaz61njliEVHQtKZpX6c8l9OnZfx1CUN+x8ZE9fbHHds0e8rtQ2e25
         RkViBTMJp1DM+LwRdy13kug+wog59VVN/fy6oF/xfKTfUSYR0SAjKd/QdHnyTbJFhDrx
         sPD2mMXV0pS3skKTZ25Hboyp3AorfXYo3wxhUfezmjBdIVE6f2v3z0xT2P27uIUChloH
         eOpwl/oJ6fsUMilXBH3bURzOZ2DdeKNJRDGF7SrEgRf/SOj1g3HQs/2DwXbTfXSGsiB9
         9Hpc0eYMzVoqzvC9mBqltZ2JlrJJFAKxTc+DonKJGYkGCauVR2cI6CbUmFiXAYi7LyWc
         oPrA==
X-Forwarded-Encrypted: i=1; AJvYcCWGkEEWRr/WYmo5FMpBDU7ncWXhWYlELf6eAPhiPR2Xj5zm8Tb3r1kZDupcQVf2DqUakId6Gch7eP6hdXtlEvDyuwHE8ZGKIN5FMGa8EtjU/8ACpUfYUwzRGMnhbStLzA==
X-Gm-Message-State: AOJu0YyDrSKpe7zDlCfRzQYIuFZ3+wJIHSkmltaIeDXbjpqGNDGH/nPf
	JlAc930a+WAkjwIw4B5dmeKU1A2tt2R16vyekTSIAPHk5N+5N3Cn
X-Google-Smtp-Source: AGHT+IGZFM7dgLGrchRDSThij/2RiAP6ZqQkCJf+/PUO3rYWGrtCe99Rp9Xn3bFCq/rwBOgNB/6P5Q==
X-Received: by 2002:a05:6a20:9598:b0:1a0:e234:bc79 with SMTP id iu24-20020a056a20959800b001a0e234bc79mr6198058pzb.0.1708942455281;
        Mon, 26 Feb 2024 02:14:15 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:15 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 24/32] common/sieve: Use vmalloc.h for setup_mmu definition
Date: Mon, 26 Feb 2024 20:12:10 +1000
Message-ID: <20240226101218.1472843-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
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
index 700f43527..8c8dd0286 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -152,8 +152,6 @@ do {									\
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
index 296338d4f..a0cfc575a 100644
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
2.42.0


