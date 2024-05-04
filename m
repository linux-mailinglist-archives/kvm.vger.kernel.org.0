Return-Path: <kvm+bounces-16594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F31658BBB5A
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA5AF282BDA
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A86347A2;
	Sat,  4 May 2024 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVcN0woV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE2F22F0D
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825856; cv=none; b=jRKTFq+XvUz3CVxDJJR2N5qOj/PPqaKokdVLcY0JQRzffn0FvI999dhnoQmZwFWE36NT6Snm7pieeU41vkKm/IGKPaDaTlLjn9q+DYcY3F0I4hJmxxsycq/tfkasj7d+rXJHy+WRrB7H7hqj9NX5XQcAuarexKuBfA+eDPczmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825856; c=relaxed/simple;
	bh=RLg/GdgVF0GhSqC5pIs50MGv7ydgRO/qGea7Z+i6NOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAzIwbiPi8DUAinS9Dxg3ssOWZM4+AsaNBek5HcuBlXtrC/l9F4fcWYaE0G8DaND3tQ6IjrYzx1cjBNvEiFWh/13lf1+wWx+FloHH0K2OlD8PaGLcT4dKY5EFHcmETaE+oaWtvKFF3mDvjiVj+Id266mPZEjrcBTSyecHZDFB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVcN0woV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6f447260f9dso444411b3a.0
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825854; x=1715430654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8yFjHHWiVn05YU2Lfr80oawzBMI5TmP8UkXksKXrkY=;
        b=AVcN0woVRVmybTCDERXn3a8L6B9wrTnQw6imMkjdCzInF9G9UeD9YvdF1vquaz3Thm
         EtleS49C2iHvEUS5njSrlQW60ug4uaSsd5todn1WSAwPTpe9xcX+n2Z4ILD1GbCh1bVJ
         CDxcupUTfF42QY8jDAS7vPa7XSvB2Yi1TLs55De/Kf3oG6ywYeOcXmYzmbEV6Nt3U4EN
         NMJelVl5zgIXJCI0oYGPaMddB43Pr6DnT0YI24tX43sOe7SewGhYmtGYuU1850JIeAg2
         CRTIAOyDfKYh0zZSbsuEU7lIBQ9/FqI8+UXTf8bCRgfEFVmfyO316yvcMVM2FfINOqis
         ZMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825854; x=1715430654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r8yFjHHWiVn05YU2Lfr80oawzBMI5TmP8UkXksKXrkY=;
        b=dBs7UPwUjI/bVRbz1qGwFWllLleygwpEkhjQgmHF4/DxsBSr/s1WrQGvPS2WIctWM1
         75G+Ea5ut8ULfcC5rl5fd19lU9/lihHKHqwR1Fn70Aodc2HMEa7Z+oWK6Or8I2R3FQ1f
         zLUhRlZwnrM/xGWgvC3KpyIfG/B+lq/XqRlEsxYzk39YlWm8a1cmv1STaLm/Bm0RILaq
         nj43L625tUoADC3FKSE3F63rhn4KBbln9mgK+6dY6NO6H4XZcMCNB2nTnShW/S2ZcLHk
         lspB6MKUNHLrqe1bAtxNuVXPyoagsk4o+JZENEd7XFdC/F/BfQnLcRMijfYvYp1VaSWg
         nFVw==
X-Forwarded-Encrypted: i=1; AJvYcCWS7i+Zulb8aPpm6jzSVH2iwYam7J8PSP1mVExeRRftSP/vQQZy8L3gIOKZAtXC6HHDTtV2A3rWgiT6V9jr89+1JTre
X-Gm-Message-State: AOJu0YwWsVRmk41EEwCk5g+85OTCGkSYHDUM5leHr6i1EQdAFrQ1aH6q
	p2cN4OWhODgRc9lCBE607S0HhyKndh1arezOVsx7p36mHq/Dp0Au
X-Google-Smtp-Source: AGHT+IFK1UoGsUuy1jTGZj15GLUUMj86a05csarOb+o+flJ9cXlyK08mpPMTmyD9G8IPIczuf3KW8g==
X-Received: by 2002:a05:6a20:f3af:b0:1ac:423b:7c7a with SMTP id qr47-20020a056a20f3af00b001ac423b7c7amr5094243pzb.21.1714825853935;
        Sat, 04 May 2024 05:30:53 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:53 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 31/31] powerpc: gitlab CI update
Date: Sat,  4 May 2024 22:28:37 +1000
Message-ID: <20240504122841.1177683-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds testing for the powernv machine, and adds a gitlab-ci test
group instead of specifying all tests in .gitlab-ci.yml, and adds a
few new tests (smp, atomics) that are known to work in CI.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml        | 30 ++++++++----------------------
 powerpc/unittests.cfg | 32 ++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 23bb69e24..31a2a4e34 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -97,17 +97,10 @@ build-ppc64be:
  - cd build
  - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-      selftest-setup
-      selftest-migration
-      selftest-migration-skip
-      spapr_hcall
-      rtas-get-time-of-day
-      rtas-get-time-of-day-base
-      rtas-set-time-of-day
-      emulator
-      | tee results.txt
- - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-ppc64le:
  extends: .intree_template
@@ -115,17 +108,10 @@ build-ppc64le:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-      selftest-setup
-      selftest-migration
-      selftest-migration-skip
-      spapr_hcall
-      rtas-get-time-of-day
-      rtas-get-time-of-day-base
-      rtas-set-time-of-day
-      emulator
-      | tee results.txt
- - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 # build-riscv32:
 # Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index d767f5d68..6fae688a8 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -16,17 +16,25 @@
 file = selftest.elf
 smp = 2
 extra_params = -m 1g -append 'setup smp=2 mem=1024'
-groups = selftest
+groups = selftest gitlab-ci
 
 [selftest-migration]
 file = selftest-migration.elf
 machine = pseries
 groups = selftest migration
 
+# QEMU 7.0 (Fedora 37) in gitlab CI has known migration bugs in TCG, so
+# make a kvm-only version for CI
+[selftest-migration-ci]
+file = selftest-migration.elf
+machine = pseries
+groups = nodefault selftest migration gitlab-ci
+accel = kvm
+
 [selftest-migration-skip]
 file = selftest-migration.elf
 machine = pseries
-groups = selftest migration
+groups = selftest migration gitlab-ci
 extra_params = -append "skip"
 
 [migration-memory]
@@ -37,6 +45,7 @@ groups = migration
 [spapr_hcall]
 file = spapr_hcall.elf
 machine = pseries
+groups = gitlab-ci
 
 [spapr_vpa]
 file = spapr_vpa.elf
@@ -47,38 +56,43 @@ file = rtas.elf
 machine = pseries
 timeout = 5
 extra_params = -append "get-time-of-day date=$(date +%s)"
-groups = rtas
+groups = rtas gitlab-ci
 
 [rtas-get-time-of-day-base]
 file = rtas.elf
 machine = pseries
 timeout = 5
 extra_params = -rtc base="2006-06-17" -append "get-time-of-day date=$(date --date="2006-06-17 UTC" +%s)"
-groups = rtas
+groups = rtas gitlab-ci
 
 [rtas-set-time-of-day]
 file = rtas.elf
 machine = pseries
 extra_params = -append "set-time-of-day"
 timeout = 5
-groups = rtas
+groups = rtas gitlab-ci
 
 [emulator]
 file = emulator.elf
+groups = gitlab-ci
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [interrupts]
 file = interrupts.elf
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [mmu]
 file = mmu.elf
 smp = $MAX_SMP
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [pmu]
 file = pmu.elf
 
 [smp]
 file = smp.elf
 smp = 2
+groups = gitlab-ci
 
 [smp-smt]
 file = smp.elf
@@ -92,16 +106,19 @@ accel = tcg,thread=single
 
 [atomics]
 file = atomics.elf
+groups = gitlab-ci
 
 [atomics-migration]
 file = atomics.elf
 machine = pseries
 extra_params = -append "migration -m"
-groups = migration
+groups = migration gitlab-ci
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [timebase]
 file = timebase.elf
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [timebase-icount]
 file = timebase.elf
 accel = tcg
@@ -115,14 +132,17 @@ smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
 groups = h_cede_tm
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [sprs]
 file = sprs.elf
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [sprs-migration]
 file = sprs.elf
 machine = pseries
 extra_params = -append '-w'
 groups = migration
 
+# Too costly to run in CI
 [sieve]
 file = sieve.elf
-- 
2.43.0


