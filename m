Return-Path: <kvm+bounces-12104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC85587F8C1
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D2571F226AB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD4B7BB1E;
	Tue, 19 Mar 2024 08:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAfgS2/K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBBC1E536;
	Tue, 19 Mar 2024 08:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835292; cv=none; b=OIHKtJenm3Jj6OYYnG24DYsjZty0jwDBw3+RHNeVE0pYeP2BvC+qSce4IJtmYvTnym4TzvoauFI0qZpDhuHvNlCYvyfns+v2dKx8BXB/7DzFSXT/t8I/Ev0CIJtHE8JdlJj9IttdMc6rdP1yMVXiCXOj3CCZTwlT0hS63QjY+T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835292; c=relaxed/simple;
	bh=8ITJigJwLmN4RQittjkENr0d55kOqyfbD7DDNd6PBpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mOfy008CK7twj4QGCQspOwe8C4sEO97o7ZtJAYHN0ThOE3rwFe2x8IRfbWfEEnBKnxGV7PHf6a3grd7KiFgsiIdqO0eoURcYywuchPhv0TKz3QJBSlSpXh+b0noQYm7XCeCUjwqI3/eYtQ/YHyf27Eah4m1pc8yX2Ho0UsPvlOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mAfgS2/K; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6f69e850bso4126028b3a.0;
        Tue, 19 Mar 2024 01:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835291; x=1711440091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtkbIYHcs9Z7wd6d39OXgdj3kfUKXbm4ZJQ1x4xi+EM=;
        b=mAfgS2/Kx1Y2O8/hyF61RifXOYaBLgMDOwAU8CeuFhM5SQDF1fg32AqrOaT2E1ME5L
         fX4bW9OPFg2NBXCmNoaFsaEgFkYSFQ0iGmPcG/bEf8WqDk2WxNjNTvEmwL5E4doSj+CY
         TjYq6pyvGfAZjyJXE4D33HUmb2WOBHH2VWzzew080suzqWtP7+1bM9dh/0gJ8DHuTLfY
         26lNrHFmBvoqvkrhKLYFbtzHnRSTDX0pFXIj5XtxOJcyJC4Mn2vMtEulO6xsM07rYTmU
         wUGmZ30bIB7C85B5zfvYnw5koMhQCN9j+C5UJYy3IXRWDJiFHjlU0hZDrLe+iWEVqGwS
         efkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835291; x=1711440091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtkbIYHcs9Z7wd6d39OXgdj3kfUKXbm4ZJQ1x4xi+EM=;
        b=bR7MOi/uapBdhGozZnRKE6JHKkfLSzZWxuTCDU2x+WSPTq2Ib0m8VcgknSqkd96HRv
         JI9nKs1l1D13ThKOWDFHJrMpQmiC7dBRRwY5+kgeFTpm5KtsUSU9OKTUcwSNF7B0okJ+
         1bWTnxK0Tw5DkGyxYHQSTY3o1aBxQ9Cmtk6RWIKnk7eKE7i5GYD+x0DUNHAlkgpu6od9
         FuCC0sT2O4pGAaEjKDeHv7u2zSP6XnZMsJAcqa/b7kxLyJ2KgReVIWMKvSCL8v/xN4A/
         OomZPDmgbP2wHVhQF6y/CCLz3Mv4AD1nCijQH24dfzEs39FOvsq3ZFAPwE+Vnj1yFIWZ
         MRqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxLE/oPKL5gk6zKmgRC5Sj5gWxV40usWPoZ3GVk80zHTvZKXnj7aiQiGSYBguVEsie1BdFgkSZusb5rMgDjPSYhaEzeKc3h8slMfkfZn2rTrOvYhb/UWdyYJVpDFCL/w==
X-Gm-Message-State: AOJu0YxW/dqlH1TAE/riTNgK3Y8zPkXud/7FOWhoIO8Yi7RrEhYZ/ZqD
	Nrnza02acZih8RNvGq3rcIrHnZquIFfI2BMYR8pU8mYzoum2ebkP
X-Google-Smtp-Source: AGHT+IHh8d74HAxWLNZuLT7882WxsnK+rCPvG3s+cIXFd6F5jOkgfb78HhHkZfJKKDCSzgvliCjSZQ==
X-Received: by 2002:a05:6a00:b82:b0:6e6:843f:1d05 with SMTP id g2-20020a056a000b8200b006e6843f1d05mr19243112pfj.25.1710835290863;
        Tue, 19 Mar 2024 01:01:30 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:30 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 28/35] common/sieve: Use vmalloc.h for setup_mmu definition
Date: Tue, 19 Mar 2024 17:59:19 +1000
Message-ID: <20240319075926.2422707-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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


