Return-Path: <kvm+bounces-12111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABF687F8CA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1B791F2288D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A3D7D09D;
	Tue, 19 Mar 2024 08:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJ2rdwMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8D95465C
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835324; cv=none; b=EMTtVGQsOoU06QA8VyjUHOFypcoq0GRV43wKTaCFY8pyLn2rxM5TACpVY6mmc6lLz7HtkW/25TnLmE/T9r+5TfwkrNawiFQuuACjLf9I/7AGkX/eqrrbTqIJ47ygZfgVgsUsVD8okNbICI7tLnhLw72xWyOQeOOzTNKUX+nbmxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835324; c=relaxed/simple;
	bh=PLM1yzHyFqOyo6oUslF5K7tm2DolFwMGHz4EG3T34Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB7JFA3BpAjb2hCgljdL0YBZZoDupONaA5GbeO8dIXSxL7NUewmhUeAW516/YCSP8BpfJklkbEKn5QYWbeSNjc1YFvujutDYH9JDxno9eNxzCUmv+SJ6+l/uzBGfFlPorAXb466xjE/NaPRaHQJ56Q8ywGaftwubNCHd4L7TAsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJ2rdwMe; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e6ee9e3cffso3171442b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835323; x=1711440123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qexXpkpnrPosSamG4rwhfxX05W0nrjIaC9l6HzJDgrY=;
        b=gJ2rdwMeps6IfCS/dhcGxuUxJNMBGJptzP0NOPhbAJhN1/KZQmg9BPrz5+PLwsVkiW
         oBN2dfYdvxef93LruRHMJ4XBFdmFK0PvpwD/C1DUPqAjW1YPdxcAW+0mQRagUZWXLMWv
         3lLW2pugmvc+s8LN5OHbiOGJKWsA25BG8nVzN/UUu0mUu3Akpnch893qwfKdwPQbH14E
         gnL0ZoPAMTytIrx6VqI5zhpxk1+4lmUNHrJUghLsXwPq5lJ7CUx5VTD/RP27Kz3ArDZj
         pWDmfy//gDX8SVeF4ICu3kM9lbbr6ZHRGpGtyyM5FZJRCwXaOK+UMN9aPWxDLT1lH2XM
         fqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835323; x=1711440123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qexXpkpnrPosSamG4rwhfxX05W0nrjIaC9l6HzJDgrY=;
        b=TKmmj3LbeMhQlJ4bT2rd46ENOTp3yeb9AJ9GCwT9V/A8H0ajRAgnAxYcYTNC0lGDu4
         yI7JMZFedOtwq9rgeQroevoe+F2kTFimcIwKeJWf5F2G7QUYoT2+4K+gi6hKQEzfWHUj
         Un8SYRpavVQ3UdlG7XYv6WgSP/Tw7ILLxD3h+otbJn87AeW/hMqVTYTWYXBX7ATsUgkt
         Z9x25Y0G/41n7VfPaX5wQcNllLFchP7rLThbkK1wQVXvBxJrJ18UB7zF7/KTmotSoyRg
         58GFAu9lGJnMwI0L2ke3o2kJKik1jcpEkpB4AGFI0wFMaVjAGUkjRliV+bSrCl9b9m1S
         9GXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdlzii3tOHuZci1uHU84s4KlSP7lIw3s7gLazUPYjQSYUnfJSUvuCXTuNIJ+M/161aZ73v6y382hgsx7iApJqNvxcl
X-Gm-Message-State: AOJu0YxNlEDr242zKYsb+52+BwP194gQQ+wKz6SAMT3nKHfiEuLUaDq0
	OsBt5jA0ANYxBO5ytr748tIspebTPDD+cZkAMzbZzy/Dsi3n5oryjUbdDZtcRy8=
X-Google-Smtp-Source: AGHT+IHs8YWGPGhmUNPd0Btq9HERv+NAaHotqwxHbqd2DVNc7XUkljS2Bi/D/KDM1wOxpVIcJpG6LA==
X-Received: by 2002:a05:6a00:1a89:b0:6e6:c256:9d49 with SMTP id e9-20020a056a001a8900b006e6c2569d49mr2457020pfv.0.1710835322806;
        Tue, 19 Mar 2024 01:02:02 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:02:02 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 35/35] powerpc: gitlab CI update
Date: Tue, 19 Mar 2024 17:59:26 +1000
Message-ID: <20240319075926.2422707-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
 .gitlab-ci.yml        | 20 ++++++++------------
 powerpc/unittests.cfg | 14 ++++++++------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index bd34da04f..e3638b088 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -97,12 +97,10 @@ build-ppc64be:
  - cd build
  - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
-     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
-     emulator
-     | tee results.txt
- - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+ - ACCEL=tcg MAX_SMP=8 MACHINE=powernv ./run_tests.sh -g gitlab-ci | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-ppc64le:
  extends: .intree_template
@@ -110,12 +108,10 @@ build-ppc64le:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
-     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
-     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
-     emulator
-     | tee results.txt
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
2.42.0


