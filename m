Return-Path: <kvm+bounces-12082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6B787F8A3
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01A781F21D55
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E0A53E06;
	Tue, 19 Mar 2024 07:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbToG0Dq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E1F537E6
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835199; cv=none; b=sPJBd6874Qnavqx3tezC2i14RsZPVxpPOUU5QsE6MXkBMgeIsrwWk5Vsa3GTLWhKsbsqhEbc745W/gFTqKPF4K1JPpetnJA8+YQEyzPbm4HZm/W5dYTKJHRe3+eXVG3pzhT1Yha9dZc2SpDkkkEQoWt9pjmcm41b+XImLRqnRag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835199; c=relaxed/simple;
	bh=ugB7R5C4IpGns7+Agj87mAt4ntbe1SqdP4ZPTlaPMOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLbPc2ETirt1QfJ5VIwsbITzSRfa4gNc2YqEwF40AMC2RvN3bKEtpajCWF532RkdzmHCHmMiDOWepOovoGxY1i/SkQE4aXj8MOZZwyd4yAQKQ8TmQIdm+s3odOVwo4xoo2jiQt4AkKM7+HdmYwvzKZlN/R2CD3GHvnygmy9oeic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbToG0Dq; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e704078860so2434144b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835197; x=1711439997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYcSW/ibSMj6iVuV1sk8Zdj3J66OqbMWoQwMjKPP3FU=;
        b=HbToG0Dqty8bG0tD+Dr+jenWVYyVdEM32/OwODAo/m8MZ33odS627GOg+OF0y9yI6j
         IBtDJPAFd+ek2ZybBlR8zAoTPoq+bd5u57peh/Rdc67LIg4+5liudvY+KPfoq4UptmcS
         KIVPkfAFivK3C+z8pzvvPG039hWwiQ/2G6okwPJOd1LTGj1wP9NpehRPv7H4981J1VDn
         n8+HQaFQo3KjsuU0m0fFokHkzp+Uuq5dfDkOAJMG4obNnO5dkngf3ijeor0aakmgXdOV
         0EUflQ6hMV6CuMRRHJjqL4Vaofox+5qU3XhHv6dPt2zKy29PBrv4WhSFt+hkTe6jq6/G
         sIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835197; x=1711439997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYcSW/ibSMj6iVuV1sk8Zdj3J66OqbMWoQwMjKPP3FU=;
        b=hMbIaNn1MD2DEe/imbU+UOUATJvQLdvkFmtpHd0z/RjDziJoN4jaM9HRrtxe6DFE5z
         Pib/3PbNp7jSdHkHXsHniOD5DeMUFr/ueKFSDo4++bjIioGvYz38quTqNoFIbJ2v9TvN
         w1GoICKXKtyZUpscmA83y43s3rlIq6sM7mEXff+KNU7VDjI7oCQXTw28k0i3cpRmOzCT
         7MmUBvICemAkGjgXpM6CA/tpmJ74fMcCtgYTOveqfac2ekBEPchW+Q0tVz+o/VWPaIfO
         4faXtE0a507Yol0sPRVRaYxwSluJ9Xf1IFMFJGvu2/tWbOwNLXSdBpDOI1M3+rlK0by0
         eUfA==
X-Forwarded-Encrypted: i=1; AJvYcCVf1lW3dheceL0H/Yp0t3VFOrS0iSldbiQRXLR5jBMKqsCZM4pF8gSjls8e8QladGoJvow2cmJ6mo1nymPjjHFsxAV9
X-Gm-Message-State: AOJu0YzNy2wLiAAVceSQ6qnuBqJt8iJIf0ZIGe6Vt7zjtxGbLs5kHux6
	jIcTdFNAcQX2ZclS+b+Z3w7dS4V7Pn4ZY4q27APBw7aSj5XoRYQk
X-Google-Smtp-Source: AGHT+IFMGBRGfTdm1Xi8PAhIoZeRYeQWIYa6zNRyD2io/DMVYPLb1oYyq/AdJHPXtgA/PjJTjuJEng==
X-Received: by 2002:a05:6a00:2309:b0:6e6:bb2b:882c with SMTP id h9-20020a056a00230900b006e6bb2b882cmr16430185pfh.13.1710835197183;
        Tue, 19 Mar 2024 00:59:57 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:57 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 06/35] gitlab-ci: Run migration selftest on s390x and powerpc
Date: Tue, 19 Mar 2024 17:58:57 +1000
Message-ID: <20240319075926.2422707-7-npiggin@gmail.com>
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

The migration harness is complicated and easy to break so CI will
be helpful.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml      | 18 +++++++++++-------
 s390x/unittests.cfg |  8 ++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ff34b1f50..bd34da04f 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -92,26 +92,28 @@ build-arm:
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
+     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
+     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
+     emulator
      | tee results.txt
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
+     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
+     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
+     emulator
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -135,7 +137,7 @@ build-riscv64:
 build-s390x:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
+ - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
  - mkdir build
  - cd build
  - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
@@ -161,6 +163,8 @@ build-s390x:
       sclp-1g
       sclp-3g
       selftest-setup
+      selftest-migration-kvm
+      selftest-migration-skip
       sieve
       smp
       stsi
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 49e3e4608..b79b99416 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -31,6 +31,14 @@ groups = selftest migration
 # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
 accel = kvm
 
+[selftest-migration-kvm]
+file = selftest-migration.elf
+groups = nodefault
+accel = kvm
+# This is a special test for gitlab-ci that can must not use TCG until the
+# TCG migration fix has made its way into CI environment's QEMU.
+# https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
+
 [selftest-migration-skip]
 file = selftest-migration.elf
 groups = selftest migration
-- 
2.42.0


