Return-Path: <kvm+bounces-19409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3A7904ADD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1A7D1C23B91
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55383716D;
	Wed, 12 Jun 2024 05:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRW5k8t2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D0E374C3
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169870; cv=none; b=ISrhs0RFggjCYHHl5DTlpuFwuQHwerZ2mjWT0ypJMYvFInoBbxZOZ77fY12+LXT6GE2ThHIfXPRijG2bSJg7PgHRpZ4qj9LhehZJYHWZoxhU6ld4QkfrqZf61o4d9qzZ3M4Y31i3MH2us+8npPBkx/dY6VXm1GPTfqxkq4N6IGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169870; c=relaxed/simple;
	bh=Wp09YmZaYT4E1tUG9MaYjVy7/1+vq3LPpePDvc5kwKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C74jyfbfTORFR5p+KEE5LyCu0X1m4JFYxwBPW9myeRQS1WkcRfKAfQ9SrnmV9BE3Tu3Fl9rDfy3Y+o+5eNNiz4mMXiKS3Af20zrkQJiLt4BAy9UcQo6nKaoys9O/ceiQIxG+9N45dPzVh2dWvSIPw8I1SSYpZxJdIyOLHTslTFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRW5k8t2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f4a5344ec7so4559115ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169868; x=1718774668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlQRgBFNQaoTa6dz8Jq/4j8RyKmazPn0sRYigP/0Fhw=;
        b=BRW5k8t277PYYN7ZuY7XqJr5JoY4jYwSAMj87VyrzJ+r3IBXCkW9RkzBxD7XjRHcpX
         tat7yYBForRNJeNccCHAmEvoV2GNl1Zmuqm7tCJb7TFyn4EMaElJD7Izxu03fpkAbw73
         nZMK+t7d1CKbbaPqdObOwBJsIOoX+coYpsXhcgbheos0RUSoFQoOzdX02bnPNSGyzpkZ
         Fi3h/JjyWXiuQ/GljyguhWoZY4uoEx6tD0Bs1wUDCEvG+lgjHh7c4yAJIAgG4CIgSfKx
         cIN5EjSUT9iJUn4toA+/ssWmOwwmsi7yYlHZOGM0m7QeztmbTM6+3JKyzh03+H11jhE+
         prag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169868; x=1718774668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TlQRgBFNQaoTa6dz8Jq/4j8RyKmazPn0sRYigP/0Fhw=;
        b=haT3o1hKfcU58WPFncCjgClnXle64f8G4tx37jULB5FaH/GaiFv99F7/bWHyLEXyAJ
         fKImyqZiwq7Y5A6Uiw02o5f2Q8fYMp67p0PidEXnLGDXCOrkBtIU1KlROcljtDBc3YDK
         bC09ZmlZAXd+LCtsbz+J6iayfzBt6xKWiHKr2WkTf9M/8jHzkUmK35uEJxVj3LXvpAy5
         algHQke4hyySSK1w5/+R8aBZxJsTN3iAV6frpIBJAwSQrVtL+RNnet7qD/+UAMxyAIw6
         gK0rabax6FOTjj43r/lx9MqLmvK7qw0lECwFbRXb4ZpYuxvtDKVEY9surhqAiUpEYct3
         JlFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHIZw9+ifM828KDOnqzURHA0RNh38kFPxzBR9U0cl60IKcb2Mvon8x+obmxg69+Az/HeIRMWveh51zYbQwpgQG7Fsn
X-Gm-Message-State: AOJu0Yw25lpWTrY6yAITPNpi1CZHUy6Kt1f+nzPr5VwFwlgY34OUKWCR
	P2sqpyDjCcc8g2Z5aspm8aXJFQmcYNCcoV9OaIDm4Hw/xIM7kM81
X-Google-Smtp-Source: AGHT+IEqLz5Dn4PKUTWY9xRYytx04I5xM9up7gD53spppmLeXqURYzOa8OHXdMBNI8YPHgpkyPGQjw==
X-Received: by 2002:a17:902:c404:b0:1f7:2185:d2d9 with SMTP id d9443c01a7336-1f728791b33mr72648115ad.5.1718169868000;
        Tue, 11 Jun 2024 22:24:28 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:27 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 15/15] powerpc/gitlab-ci: Enable more tests with Fedora 40
Date: Wed, 12 Jun 2024 15:23:20 +1000
Message-ID: <20240612052322.218726-16-npiggin@gmail.com>
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

With Fedora 40 (QEMU 8.2), more tests can be enabled.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml        |  2 +-
 powerpc/unittests.cfg | 17 ++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ffb3767ec..ee14330a3 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -110,7 +110,7 @@ build-ppc64le:
  extends: .intree_template
  image: fedora:40
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat jq
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg MAX_SMP=8 ./run_tests.sh -g gitlab-ci
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 9e7df22f4..27092b185 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -28,7 +28,7 @@ file = selftest-migration.elf
 machine = pseries
 groups = selftest migration
 
-# QEMU 7.0 (Fedora 37) in gitlab CI has known migration bugs in TCG, so
+# QEMU 8.2 (Fedora 40) in gitlab CI has known migration bugs in TCG, so
 # make a kvm-only version for CI
 [selftest-migration-ci]
 file = selftest-migration.elf
@@ -81,18 +81,18 @@ groups = rtas gitlab-ci
 file = emulator.elf
 groups = gitlab-ci
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
+# QEMU 8.2 in Fedora 40 fails because it allows supervisor to change MSR[ME]
 [interrupts]
 file = interrupts.elf
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [mmu]
 file = mmu.elf
 smp = 2
+groups = gitlab-ci
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [pmu]
 file = pmu.elf
+groups = gitlab-ci
 
 [smp]
 file = smp.elf
@@ -120,15 +120,15 @@ machine = pseries
 extra_params = -append "migration -m"
 groups = migration gitlab-ci
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [timebase]
 file = timebase.elf
+groups = gitlab-ci
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [timebase-icount]
 file = timebase.elf
 accel = tcg
 extra_params = -icount shift=5
+groups = gitlab-ci
 
 [h_cede_tm]
 file = tm.elf
@@ -138,16 +138,15 @@ smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
 groups = h_cede_tm
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [sprs]
 file = sprs.elf
+groups = gitlab-ci
 
-# QEMU 7.0 (Fedora 37) in gitlab CI fails this
 [sprs-migration]
 file = sprs.elf
 machine = pseries
 extra_params = -append '-w'
-groups = migration
+groups = migration gitlab-ci
 
 # Too costly to run in CI
 [sieve]
-- 
2.45.1


