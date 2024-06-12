Return-Path: <kvm+bounces-19405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E364C904AD8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5324FB21B70
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F74E433A4;
	Wed, 12 Jun 2024 05:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kM3UgXYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC25E38382
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169856; cv=none; b=LxGUK8q497bsVKnRYg73s0dn4amzI+LL5iC6Wy9AhJCZeYwqZqyEvtohm3LCSUOsDn3geGv1aq6gH6wbjUVG43kR6Y+adqM1+0R8BBXJ4UA3c89phPdubMs+o7nyoGYlqYCem/7RnhKLyxwT/1Y7K7wFADEtcbeKjNjWj96Z8Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169856; c=relaxed/simple;
	bh=SHjqplac++yHtEn1s8AlqDEGds4GZUuAxu/gZUEhfvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2ROGOOB9/ErwWPnTFNuWn/5Sru8lC3dqvML6fKPDXQqbqKUHlsWA9zNQP++5BmX9DniJzRx/xawMfNudEjIFG/ZYbgE4b5FFGt0ALyLJe4vNvWfIuwSy4SDeTr4tHyLLaQbrN73yWBWPHpilWknN3171w2p0ww7tt0YCcuKQ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kM3UgXYI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f6b0a40721so46406855ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169854; x=1718774654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9L1xoCrCRrB/Q3jS6x86SGj+fZqpLObyaxaO3glOSo=;
        b=kM3UgXYISj/oBvUzOoWB7y3Aakc05gP1XTIrOt4KVqsQ5+AVnbAj5e4QUBPflWqZtv
         39krRWgT7wWL3bU/hECMa369sO37xbmS+oQXeAtriYUF1HEhFYutvysqK7QGGSNbTNHB
         98MzPeUwocSZaVe4+NTmoY3fnBfoQNPFzPDNDiWLvfk7Vg/+9Rj56tT6qIDS2xo4uZUT
         MxIVVZkRzdAxxHaJiK7YKciETa1w70RodXubUV33nxh3iWoZ+33ypinbIAC24KFT25Do
         O/7L9q1ZcJ7zw+raOilJgvoUHVLaXqJASfGwq90XupsxYA7ldhTQq2gqsnjoJ/0dFXl0
         56Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169854; x=1718774654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9L1xoCrCRrB/Q3jS6x86SGj+fZqpLObyaxaO3glOSo=;
        b=W4Rgyei5TT0TqyGitBmGLTPJhVunk1oJ43zwSsyj/OFXS7WPzjK9MkOvMSEPpPYT/q
         NM2gFmdd+fsPr+RFDgm5atqNbZNCARzg4WOpoSvVaVAaUVk9cUg/6Pt0cV3AMRlWyhm7
         fqHEaeA9WHRrO+VdsFviDPKGt9FHhvpI6XTt6DbinpRGNmZZ5aT+VSf+deuHZkGrRcVu
         ayK3DEeK6GNBPIx2oLmdtAZ+f9Etibcl2eg1a9KSAzlCVGZJCoRXw5wPBTElmSFm07Hb
         fxdSAGdkhkBQtpNOYAusz09+aPonXpR6udTIKiFyCgjOMONLY8M38YoG4pwEkABP0kcT
         e1Zw==
X-Forwarded-Encrypted: i=1; AJvYcCXV7mxIdPsWfAz+czFJK4O3QhOlMdcSuAr2XDVP+Jbg0WwSMLCii8uP6aoGWfA4UpD2qPC67SDnkWMQAFXNRRlwePZe
X-Gm-Message-State: AOJu0Yzb+6ohlf0l0hV6QPT+cBAnW8QaUyH0e3Bzr6soTRMU059ATYNX
	bM2boYnjBpOueDOa/uisNcQv3AtEB7kPmkRr3adX9bbF6YbjNAGl
X-Google-Smtp-Source: AGHT+IF8CsFWZGDaDZHuKFtw+srSJbMsiTXWPPYRhmdRUZYG4Gukwaaw6xFQ5qU3hAIn3lKjcBbrYg==
X-Received: by 2002:a17:902:eccc:b0:1f8:3c9e:3b92 with SMTP id d9443c01a7336-1f83c9e3cf9mr6771865ad.23.1718169854003;
        Tue, 11 Jun 2024 22:24:14 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:13 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 11/15] powerpc: gitlab CI update
Date: Wed, 12 Jun 2024 15:23:16 +1000
Message-ID: <20240612052322.218726-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds testing for the powernv machine. To control overhead, ppc64be
is used to test powernv and 64k page size, ppc64le is used to test
pseries and 4k page size.

Change to using a gitlab-ci test group instead of specifying all
tests in .gitlab-ci.yml, and adds a few additional tests (smp, atomics)
that are known to work in CI.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml        | 32 ++++++++------------------------
 powerpc/unittests.cfg | 34 +++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 0e4d6205f..b5fc0cb7d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -96,22 +96,14 @@ build-arm:
 build-ppc64be:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - mkdir build
  - cd build
- - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
+ - ../configure --arch=ppc64 --endian=big --page-size=64k --cross-prefix=powerpc64-linux-gnu-
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
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci
+   | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-ppc64le:
  extends: .intree_template
@@ -119,17 +111,9 @@ build-ppc64le:
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
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci
+   | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 # build-riscv32:
 # Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 79a123e9f..89455b618 100644
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
 smp = 2
 
+# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [pmu]
 file = pmu.elf
 
 [smp]
 file = smp.elf
 smp = 2
+groups = gitlab-ci
 
 [smp-smt]
 file = smp.elf
@@ -90,19 +104,22 @@ file = smp.elf
 smp = 8,threads=4
 accel = tcg,thread=single
 
+# QEMU 7.0 (Fedora 37) in gitlab CI does not do well with SMP atomics
 [atomics]
 file = atomics.elf
-smp = 2
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
@@ -116,14 +133,17 @@ smp = 2,threads=2
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
2.45.1


