Return-Path: <kvm+bounces-9836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6673886710A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18A65287019
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B3B5FBB9;
	Mon, 26 Feb 2024 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0hSZJIN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF75FBA0
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942496; cv=none; b=qASY+Oyu4rfHTQwktDdkotA3uwrh0OL/HRrWlHnX2FcjZz+sx2qF6vL0rBjXmVwrRvItLU6Vz4WfQChJUMEB/0yV53OET+dsIvU+JeEDuZ1TJ09DXy0MZWEw8Jb2Xn4tQCnBmlevfEJjiy8wLxn8jZarlA3L8FqWB04Vqj6rzfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942496; c=relaxed/simple;
	bh=I2a/TP7g1GppWyjQzPyGXpoOO9wJLxVvHSCZCHZQpdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7zDomdROhrsTmuNdkYQ8pWLSCPeUGVON5ZgIxW5+jCRpP6YmWM0e5Q2ESz1NRUqpln30JXLpabyaN4AP7b7Iq+IauTZfNk3alCDtsGT8egnT2swyHabnv7IKNyX0r9Dzr8Zi9heLAUZQnBOD3WkqbqaXozy6UcgzkdoScrxQdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0hSZJIN; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e435542d41so1651752b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942494; x=1709547294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oiwxTGWU6IUJhXbPXi9jlCFl9jNsVOAORO/dFL4KH8=;
        b=l0hSZJINukdfRcQQwS4nbsUhsq19PiH0gXN3TB1IgdyqmtmC+nfYBzT/aFQ9Pae4Vd
         +QDlZxmHbWk8xIuawvLeVCybc68uKb5SG/HC0CiHyUATf8ASajVRo24mK+9xT6SqnxZJ
         lu8kAn3Zvg9JMR5qOe+b8TFStuWu/oPEUYk/V8emm6P5i9WnORhJxWXLzVFGWCu6Q7PR
         IXj/Q076FP2ZpsJ5DJwNIKtelqmz56oyylJdVC0z4bFUR1cA/3RPYQK6Vb9Wr0SWXren
         GuuGhZwZ3mod/E/sbhFeSUy2SWK7BLITNHPnkR9PGoM5LBVCPl6SgG43G0t4eO0O+0DN
         JRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942494; x=1709547294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oiwxTGWU6IUJhXbPXi9jlCFl9jNsVOAORO/dFL4KH8=;
        b=q0yFFsebG1fMBEyOEYIFXAfDxclR8Idhbsiw4qxijKKx3cWkiIu2hGsHraUSCn4fmY
         wMak+SYCalnDcv2751l8kLntHn7Ic5eQdzqbv65Lxz2znMVPwdLwS/BLwE0Up/9UHLNS
         CBqr8ia4fOOfOHQIdIQbIynXb+NdcYX3/VZ6/n757OO71sygY9cteLlcgsLn02afhZIb
         2Wed3KR6XQhO+9YnjNo4CfFoo8vqZ4u4ZjPbgAgQccoO4+ZwVczYhScMMl9KFkVepN4i
         kBIYNN/qzJ5WbrSe3GhB5gQU7lWnEp1ZH2j58tAJJunSXkMv9L1sN79HJu1eYfktmhff
         0ErQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiCMeiPrZhtKh/BsU2aQYr1vHWRZSp7UwnlDfQxV2CnPDzm3zBT0A9RJLZmMa5zbkKoet61jR5P8YdDTam9pdxCnhc
X-Gm-Message-State: AOJu0YxeTDpEGD/rGDQP5SR79i/nHARyJpTOgxAEE2XUwqWVQhF3Xr9y
	tKHc7MWVlwJ0h3RB73LHKvgHWtTsa+SmkL1SmOwUkRLBHbWo/TNm
X-Google-Smtp-Source: AGHT+IEdmNJCAyNnb0OHlETxiDPkAQRNZ6Rj92dODzdJv+fmEZif4N25wNv6OUOT4lP8rkt8ITdgiA==
X-Received: by 2002:a05:6a00:3c86:b0:6e1:3cdb:76f1 with SMTP id lm6-20020a056a003c8600b006e13cdb76f1mr9030138pfb.20.1708942493857;
        Mon, 26 Feb 2024 02:14:53 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:53 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 32/32] powerpc: gitlab CI update
Date: Mon, 26 Feb 2024 20:12:18 +1000
Message-ID: <20240226101218.1472843-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
 .gitlab-ci.yml        | 16 ++++++----------
 powerpc/unittests.cfg | 15 ++++++++-------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 61f196d5d..51a593021 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -69,11 +69,9 @@ build-ppc64be:
  - cd build
  - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
-     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
-     emulator
-     | tee results.txt
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
+ - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-ppc64le:
@@ -82,11 +80,9 @@ build-ppc64le:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
-     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
-     emulator
-     | tee results.txt
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
+ - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 # build-riscv32:
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e275f389b..21071a1a1 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -34,17 +34,17 @@
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
 
 [selftest-migration-skip]
 file = selftest-migration.elf
 machine = pseries
-groups = selftest migration
+groups = selftest migration gitlab-ci
 extra_params = -append "skip"
 
 # This fails due to a QEMU TCG bug so KVM-only until QEMU is fixed upstream
@@ -56,7 +56,7 @@ groups = migration
 
 [spapr_hcall]
 file = spapr_hcall.elf
-machine = pseries
+machine = pseries gitlab-ci
 
 [spapr_vpa]
 file = spapr_vpa.elf
@@ -67,24 +67,25 @@ file = rtas.elf
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
2.42.0


