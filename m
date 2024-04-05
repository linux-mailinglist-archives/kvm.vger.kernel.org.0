Return-Path: <kvm+bounces-13668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE35E89980C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61DA82889D7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A364B4CB3D;
	Fri,  5 Apr 2024 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DS2YMK4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494E115FCFE;
	Fri,  5 Apr 2024 08:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306267; cv=none; b=CxcSxoeZFhkX6sccIUBlHzFQEB8ovGrpzuXTSMC7qcFljYLGXmtrhx7ntpEfmHDyDqe5Uwp42vGvpiDMMQSCWIfWwBPpfv2J0V+vsUZCfHQmd/+lJsx2Pe68TmRz6yfsQnZ2jBlFUBr7MFeTJvE485UZOwLLfh0X9iDBIpYa8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306267; c=relaxed/simple;
	bh=AKckDfCTXypWrrOdAxRwikYyybwFfW5X617fvy582RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQ3DDD4l/+zRec3xDs4CR4TSXDWyd7SgdPky7FfWTXNMBsHSgb1nQG7HtNePEuZIRHJ3x09hux2yQoP7qglQx8aOmyc5Rr8DoE5PKGHWGBjZ9YtdUPhd8z2uIRfdDAAI2/k6e7sYT0RcplNqY8roSH0lmh5J0gS9DLpAQXkAA38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DS2YMK4O; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so1212347b6e.2;
        Fri, 05 Apr 2024 01:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306265; x=1712911065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecQCAwbQxkkxUlhSFJlIXC1kR8UrvIOTCdxcEI2+MAs=;
        b=DS2YMK4ODsZYI3NXwG0GmTtZOZkAcY5vNLxFpnicx4SFXJACY8v+hkUBAyEiVgZenW
         /09znhelN4HAkYcqHpNfAV62aa1tLuzNpLDfvW8l/PDOdXtd3Mk1bZUbPnpS0lnx75Ny
         0lr3bXwUFQDRq+m6vkD83jCOw7UgzZb7MDVJxSNtNptW/1huk4NYoZvIp8mD+fFnSUC1
         LYACe7PmdAj3AaROC7KVvo8yOQgZJNxbsGW+mT4nuQBwEB5bANYa2ty7dfLgnTGGrs2I
         Wy7nekmRHq09vLAMe3ZTD0MR8JO1ZcnEKUk7Q7yWcALEBo7Yc1Ym1MqYzSrlRFh1ATj6
         G+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306265; x=1712911065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecQCAwbQxkkxUlhSFJlIXC1kR8UrvIOTCdxcEI2+MAs=;
        b=NQXJnJLcRqDBgcq8jwgeMrJXut805fFojxpBf+jaVXVcVuf/yP/sTsKIxY1JxsTj9y
         XAirp63epjYq7KYH3N9n+b6eBJA2rOL57yKIdu+GkHs2OIP4298vQAclTtqSMSaawnFt
         GkPrKUQ2SIOxr+aN7SgyrVvfaIVpd5Q+f5fyrcVoBt3t2ODwrn8yaqk1vN6m2igxjh+y
         H0r1Eo4vQzp1aA5Aw/JSp5q6REvBC1cKCE2AA308ZAKZnfnDio0hiZU6gBqZcv6JVdRY
         Z8AmmattNDy8UCyvJxwnhWJIOyDkFEHV+uSootPG3V3KJdr5FRo5Poop/yAazEPiyYFN
         7npg==
X-Forwarded-Encrypted: i=1; AJvYcCUSG31ZlWGfHeIaYbHH2V5GwtSJ5IZbI/390cxYAny6tdp8XBAYiAOUk6ElJzoReyloBtYFQxKhuI7Fdp5gWYx+B+jRYT2nwaVoAvNXj/nGU2mM/ltKGWgbHHSKvmaSYQ==
X-Gm-Message-State: AOJu0Yy34UaMki31337ex2BHWxUTB6fsdqWnBbPqWKL9VhLx7y43Rb4p
	zE7rWPg60zsV6ZhMulpgAO5w6PxNxnh+Ik1e0I5s7IZj/35kyqxj
X-Google-Smtp-Source: AGHT+IGW29UYKqDLZAk+yL4v7/50eGF/rvzg/Lhhx6XRFsz75OKULY49heFMhhxfjo56f8CDu05fmw==
X-Received: by 2002:aca:f13:0:b0:3c4:f89f:2a8e with SMTP id 19-20020aca0f13000000b003c4f89f2a8emr780399oip.44.1712306265363;
        Fri, 05 Apr 2024 01:37:45 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:44 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v8 28/35] common/sieve: Use vmalloc.h for setup_mmu definition
Date: Fri,  5 Apr 2024 18:35:29 +1000
Message-ID: <20240405083539.374995-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
2.43.0


