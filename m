Return-Path: <kvm+bounces-13646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2908997F3
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA2B1F22C42
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0B715FCF4;
	Fri,  5 Apr 2024 08:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ddon7zWo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80015F338
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306175; cv=none; b=Zzf887jnHH7ZD92zpRn8OkfjV+Y0qoQGnVlQK0+HZhrLUWdMofE4/4a0G57JlldVWc3vSK+HwISRLWS+Cd+qIdhVkC3MXimoFpeNwY3CVHoAK8RqibHcp3+ELnrXknO43Q2B1cG5T7TqWd1B8Mj+qvriNi9MrIHi2Qma3Lf/fBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306175; c=relaxed/simple;
	bh=3IRZNZ0AZ7/Wr2zNgtcWotHYvfynStZ13j1k3DSTPus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5ku3acWBBZKyHkJMqNGQ7eDeySphfQkymTHwkUn/KBrRqhVsRl8V+/QFh5r+4eDlzePvazTuHCshGvkONn5/11EVUwhRsus6JAepcB3fIC98nTXcm1Drsqy5Wh9uXClAH8cUacRJ2TNS8EZz3e2niW04IJbvsmZoEmDSf1HoH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ddon7zWo; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c3ae53f662so1170318b6e.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306173; x=1712910973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WioYVqWKFUM6/8tb6Tl776O5r9iFZjAojguUi5vO6u4=;
        b=Ddon7zWoSXfIJSgLMK+kRl2lgZAscIK5aJowgJ2TsY7nKOmrR4vh5BU6R2LHSILEEK
         Qz7OJic8yY4JPLtiwxCh33D60Y3yg0EWpnKBs9gKb+b+AXWdEfZ0RfOMFjKXSZPKw+m/
         KAa8v9yCinS+j3ZTYWJqFHNqCb82yMPgsx2OSwCeUdUP/AS6TDdKighhq8kxKB7x4lSl
         A0OO9FGjA+YVXip0hhZ2OgegyVU24IJsTjDNbm8w7GZ/a2WwJ/krnEMXfO128UwVcIS+
         te5dv/rZNhNm2Aw7nKRyfgoD+4cywT0xg7/ZdDJRgS7Muu49zX7/KxjhEnxBIjh4U4SY
         JsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306173; x=1712910973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WioYVqWKFUM6/8tb6Tl776O5r9iFZjAojguUi5vO6u4=;
        b=D7bib+LX4tXUeKH6/owJo5iaQU9gAVeZ1iSZ84twNrLYrjeA8aQgRXdjDDTqeYua7o
         GwY7zj6Ouo56P29f1y27s/Qta65gNQ7w2mBNaAWRYdtiVcBoMsgE6ppbYwyv/fJEy5Ct
         ERSyFJqmGTFiM0Mf9dGalHKm8q64kPc58bomVSVoeVCJXpkuzfS2fgRLh3MlHOElTDZl
         jJtKp2TRenxE/TtQ2Mz1WhHOZQovEDN88u2gGSdZDaNhkcsyGCo4/Dhh9MhSyESzv3Wj
         RYaH2skn3PlupYe/j8xdNKJ59VKVg3FKa0nULZoEhTSLCd71fjfrQ2j9vA7Mh9xip81W
         iKjw==
X-Forwarded-Encrypted: i=1; AJvYcCUpe/fC8mFy9lfFEbk4bZRb0nd+G49wfJKCJmMX4zIt7e4XaqMk1W3wTWB2csW66ttnjCtjWEAfIdBc7Ulcw2tIs80Q
X-Gm-Message-State: AOJu0YzAbaqWK/WizDTUztR9S0s9NtvHxL+17f5qpdxw31fDlmvgeo1U
	J1btMlZaPweGc5qg+rn9ag+VMOnn7/u9UlL3JS9FN0Y7PSOipNIVh0q73qmo
X-Google-Smtp-Source: AGHT+IEbIySGPa8yUWT1eqjog7KLPOJaWv//O2NLyD7J5C6wz86BZyGO+6gukW1PPTGHk8LbBoWwGA==
X-Received: by 2002:a05:6808:2390:b0:3c2:277e:65c2 with SMTP id bp16-20020a056808239000b003c2277e65c2mr863370oib.41.1712306173114;
        Fri, 05 Apr 2024 01:36:13 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:12 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 06/35] gitlab-ci: Run migration selftest on s390x and powerpc
Date: Fri,  5 Apr 2024 18:35:07 +1000
Message-ID: <20240405083539.374995-7-npiggin@gmail.com>
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

The migration harness is complicated and easy to break so CI will
be helpful.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
 s390x/unittests.cfg |  8 ++++++++
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ff34b1f50..60b3cdfd2 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -92,27 +92,39 @@ build-arm:
 build-ppc64be:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - mkdir build
  - cd build
  - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
-     rtas-set-time-of-day emulator
-     | tee results.txt
+      selftest-setup
+      selftest-migration
+      selftest-migration-skip
+      spapr_hcall
+      rtas-get-time-of-day
+      rtas-get-time-of-day-base
+      rtas-set-time-of-day
+      emulator
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-ppc64le:
  extends: .intree_template
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
-     rtas-set-time-of-day emulator
-     | tee results.txt
+      selftest-setup
+      selftest-migration
+      selftest-migration-skip
+      spapr_hcall
+      rtas-get-time-of-day
+      rtas-get-time-of-day-base
+      rtas-set-time-of-day
+      emulator
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 # build-riscv32:
@@ -135,7 +147,7 @@ build-riscv64:
 build-s390x:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
+ - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
  - mkdir build
  - cd build
  - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
@@ -161,6 +173,8 @@ build-s390x:
       sclp-1g
       sclp-3g
       selftest-setup
+      selftest-migration-kvm
+      selftest-migration-skip
       sieve
       smp
       stsi
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 49e3e4608..faa0ce0eb 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -31,6 +31,14 @@ groups = selftest migration
 # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
 accel = kvm
 
+[selftest-migration-kvm]
+file = selftest-migration.elf
+groups = nodefault
+accel = kvm
+# This is a special test for gitlab-ci that must not use TCG until the
+# TCG migration fix has made its way into CI environment's QEMU.
+# https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
+
 [selftest-migration-skip]
 file = selftest-migration.elf
 groups = selftest migration
-- 
2.43.0


