Return-Path: <kvm+bounces-16588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6434A8BBB51
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A911282C2E
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0CE8F6D;
	Sat,  4 May 2024 12:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOaNhG62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848492D058
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825830; cv=none; b=XJJxcLbRd9KEANGzgSwiNSAk+N1U6vAzuFOcHpiXxkAn3Pc6HJ5ZXpGqk5gjgp84YxwmbwzKmMnDr+BbyPV5c7NoQqjW5eNbTROzEaW6vyU83R4exrlDt0pGKbyJma+4Atz3vaAAsp4qpiC5pCR2zeEKdea2tufRFCP0TzkknK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825830; c=relaxed/simple;
	bh=FlelZ5oGIActBcC1B6DyQsfMivb4Dafr1103vPjFc98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOjFo0exTOyWKdotcbJ/jHiCjAPLp0OO7Ei21OmxS/qAG0fLcg0PiTCkGzaPhGcvgmvJrt4TstFDiyKRDa5bkNdvNWdOOy6Kbosn5kR10Yt/uHmjJqqlVUvR5bfnB65hzmS19oJwN67RWm4yrU14jWBSBhWMDGosIAAkoaBbsEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOaNhG62; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f44390e328so524795b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825829; x=1715430629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NGJB2kU/PZBgZRxhGgnfzeZa2zBkfZth+TZPJCBD2U=;
        b=aOaNhG62p6jOFpAS5df7DNkW01AMwAcdK2cIPn2ksubCD42rveAvGEJfnEPXCautXk
         uazV3oXDqHA8g++UD4P4M1Z6PBobvzGQ9cy9jaHxItvtUqSOZi8UFPN3mCg3v8MUaO2Z
         RPf6vwQkvgK8xkCfRBBmqMjnnLdzgxrbNcV52Vdez8v3eSkmkND7W9e6fZ8pCn6c9i4A
         JHVvpomIj6OQ2RNSQFOzZa4f2JfizfLzxDIpeA0j0tr1vn2KSL0z+5Z6M0rOguTPsmfX
         8CU0M3Pr6RaV+2B1NL0+Z+3L44OujruZdfLnNVrpawNqlE+vU/m5fHfCo1a7TBaJYaGx
         9MuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825829; x=1715430629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NGJB2kU/PZBgZRxhGgnfzeZa2zBkfZth+TZPJCBD2U=;
        b=t9NBaTfnV1vLc2WRzuK8+BhCwrFHSL2UcxejBPxtFz6r5/WWBfAs2sg34+zwKCl444
         e6Juoy4nKHBwPP7EMm7pmNhbF8VX4m4U5FIkVMG9PVDtBEgkjMUNDpFxJVGWiBib5JMg
         LdQZ67bK82SHppKRDBYN53iVcBJbvDrlD0X4p8lBO5YZ/euUlnp1LKCJoTZk50MsD6W+
         TKNGey0ts/KJh6eyo4ZEN21jJ81a2Oo5hzN1AYKoYXo/HRGuHvxwkIR2t7HxGvVbXo8I
         RVqFrmNL4f7Yaupl6hHC2R4r+PF4LT7Wx23CI5hjiKecjgu7D/4J+CidxUNNhnvDYckp
         FrNg==
X-Forwarded-Encrypted: i=1; AJvYcCUF2hoH+tZ2OQoPRH0KDTLeuBPCxmxxz52wpiDFrr5ZsXu8SIHATkHIxMdclZvs8VaVRTgNGhbAdRDfNx1JlgI6ytob
X-Gm-Message-State: AOJu0YyU6E/lZ/avLrPPrXPJH4n4JtDYhJ4LrnS/DbJUoV14kZpv5Te9
	tS6n2UEx2haGHko4eQ56Wzfp+lJBo+dLWVBDmN/QZwac2QV8vtUJ
X-Google-Smtp-Source: AGHT+IEoUYJSmTBuUD/jk1CLYptkUeIzK0xq1aBA4WJ3bd83Z7S3fr1cnVqSRKmY/XCfM4wCkaZB+A==
X-Received: by 2002:a05:6a20:3948:b0:1a7:8610:bb62 with SMTP id r8-20020a056a20394800b001a78610bb62mr7155624pzg.51.1714825828863;
        Sat, 04 May 2024 05:30:28 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:28 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 25/31] powerpc: Add sieve.c common test
Date: Sat,  4 May 2024 22:28:31 +1000
Message-ID: <20240504122841.1177683-26-npiggin@gmail.com>
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

Now that sieve copes with lack of MMU support, it can be run by
powerpc.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common | 1 +
 powerpc/sieve.c         | 1 +
 powerpc/unittests.cfg   | 3 +++
 3 files changed, 5 insertions(+)
 create mode 120000 powerpc/sieve.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 7378b1137..b2e89e4fd 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -8,6 +8,7 @@ tests-common = \
 	$(TEST_DIR)/selftest.elf \
 	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/memory-verify.elf \
+	$(TEST_DIR)/sieve.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/sieve.c b/powerpc/sieve.c
new file mode 120000
index 000000000..fe299f309
--- /dev/null
+++ b/powerpc/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 286e11782..c7cda819d 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -120,3 +120,6 @@ file = sprs.elf
 machine = pseries
 extra_params = -append '-w'
 groups = migration
+
+[sieve]
+file = sieve.elf
-- 
2.43.0


