Return-Path: <kvm+bounces-13675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB8A899815
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 698282843D8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AA815FCE7;
	Fri,  5 Apr 2024 08:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUhZ68H4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F0415FCEE
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306298; cv=none; b=bcMNmHcVLqDoRPlXlvFBwfq4G/92l9Lp8mD3fk7QngAlbPcxe0qyQWHVFcgAP77WBEPz0eiIxlxZEVhc1ED7KhZ2KDSDPL70a52cv5g0gnT3i2M5E01sapQ07CjKcBNTwEJBllzLqrRJkCY08nv+JRq8qCRchcgAFgTQKIS1/LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306298; c=relaxed/simple;
	bh=9CMfoz67JY0V5zmXDLlEw7AgRUrRJ4HR9H4YbewJqJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaBoysIoBWsILWaR9SL6UrZ4I4rhOyvNNHfmrFi4rao2z8WdKNTXZVwnDqQTI6+3+AOpHJi/UBPZyCCWFueInScOLc4hk5/wE9lc8SM3aLU9b12oyp/E++ZsQzted8gg0bbuQ+lRieltc0kGtrlzMdB5LkM2hYjZWMj0Yrinh7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUhZ68H4; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-22eccfeee22so340233fac.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306296; x=1712911096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08ZJSlQgPb2U1wJ1wtHQmw6+VW0gHONEQZpvI78Rx0A=;
        b=dUhZ68H4rvXodVGjhTxMw0p18kU702cFO1Btd4coC1t4emiaFrka7Q12iIil75mI10
         VzNJHga59LblE9nO/9tNyHcsJSPjUIbNivXeL47338OSsuEfC3H5UEyo2RKQeXrkPuuB
         8JlKJD+hAUV2tqricfhoI4G8vB/tP+LncW4KD242Xfnpv4LQtNAeh0p/ih8xAYMN0WeG
         Fgj1tLo1aRLl2ZRfFbgZ+rJX3HUAfn3hfDs5fPyWLoAgC8kvszCuhkuWS9SAngBQWaRc
         nYwbCr0E/x9AgFplkScQYZIVoU4zZ0hFZdcFp7HEipxf9ZBdv8e9u1KOcRDEoLCbdRKd
         aL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306296; x=1712911096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08ZJSlQgPb2U1wJ1wtHQmw6+VW0gHONEQZpvI78Rx0A=;
        b=kIzq+wvQpJLRxl786+4xz4jKIkAuSiy6kxisVFBFE9DwS7NM1xeE4n69oueLMJtl4A
         kzGsXrc6Tt6ZTj4Dvr8bEIuw/saQ9q75NoFHP+wMYp3QTIM3REUlpt2TkxKpbpS44Xio
         z0ByRHs/Kec2xY3ZG1TXJGn3ZhuFQq1QXEgAx9nhZku2aK+ftkxzbqsYOiWcFahkzIBl
         BVrOWBmFbHXN7tixLQ84ApgUyVCdiaUgUYcuyoOFcUkJarynbQmpBaYwkmcEP+DMVJwv
         Lit6l1vsSBVgrm32rSAZQQBWvPM1V1eR7eXSCOor21x2YBIWpKbHpC86l3wB8UdZfOrk
         nyow==
X-Forwarded-Encrypted: i=1; AJvYcCUEJPqThcjeWX2mcVKmNi+/fyO5SzzcwxN4nrGli9wSFF9Oo6QTu7CXNYhHCppYZoxk1QLEa8hD+HEO+L3yGxovmekx
X-Gm-Message-State: AOJu0YyZUnwpUpY0pLQyBUQ6oqBaHL62RW+JDGa++yp17ZMwhcV5RjOa
	TNgzTNytKEDpeoylqONS7g6Uz1yGbEInK6HR+rGt4VggiJyP9fUk
X-Google-Smtp-Source: AGHT+IFcYX8of89RQmkZnvOZcAdSrslSQo+ySFnFFYsF1LPh5xNvi2PP8LfX0/lXzBcR/I+RMfni0A==
X-Received: by 2002:a05:6871:587:b0:22e:d0e3:925f with SMTP id u7-20020a056871058700b0022ed0e3925fmr904892oan.1.1712306296168;
        Fri, 05 Apr 2024 01:38:16 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:38:15 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 35/35] powerpc: gitlab CI update
Date: Fri,  5 Apr 2024 18:35:36 +1000
Message-ID: <20240405083539.374995-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds testing for the powernv machine, and adds a gitlab-ci test
group instead of specifying all tests in .gitlab-ci.yml.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml        | 30 ++++++++----------------------
 powerpc/unittests.cfg | 14 ++++++++------
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 60b3cdfd2..e3638b088 100644
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
index 379aa166b..f6ddc4a7f 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -16,12 +16,12 @@
 file = selftest.elf
 smp = 2
 extra_params = -m 1g -append 'setup smp=2 mem=1024'
-groups = selftest
+groups = selftest gitlab-ci
 
 [selftest-migration]
 file = selftest-migration.elf
 machine = pseries
-groups = selftest migration
+groups = selftest migration gitlab-ci
 # TODO: Remove accel=kvm once the following TCG migration fix has been merged:
 # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
 accel = kvm
@@ -29,7 +29,7 @@ accel = kvm
 [selftest-migration-skip]
 file = selftest-migration.elf
 machine = pseries
-groups = selftest migration
+groups = selftest migration gitlab-ci
 extra_params = -append "skip"
 
 # This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
@@ -42,6 +42,7 @@ groups = migration
 [spapr_hcall]
 file = spapr_hcall.elf
 machine = pseries
+groups = gitlab-ci
 
 [spapr_vpa]
 file = spapr_vpa.elf
@@ -52,24 +53,25 @@ file = rtas.elf
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
 
 [interrupts]
 file = interrupts.elf
-- 
2.43.0


