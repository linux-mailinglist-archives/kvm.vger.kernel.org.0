Return-Path: <kvm+bounces-13670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E47E789980F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8513FB222FB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE961607A0;
	Fri,  5 Apr 2024 08:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJEYh8B/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0014A15FA93
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306275; cv=none; b=b62By6GBo1thzdB5ax763L2P3o5geoXznDbfpInUNP8rvGE7U4d0SPUoPU6nIK3Pz0XBnuePKaF37JzgbaIWg4u/BJsRaD9p6mVLzpaVOW83O24i7e6Ilbpa/PIdqB5WHiE+svWR5jj461W8bQZof6oZZ0dSmKpEcPEzvlW26Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306275; c=relaxed/simple;
	bh=bYb6+xMsaaBjec/+sfvAEHiUmri2GJNX8m6UOakm0MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm+YCiIKmUqwJC4FJXZbIqBr5h9mGDkZMoyO/NYfKlN+KqBhmAKwEXIuvy1+P6IvK6d68CmwCJ8nn09Noh7HsoxyunDFfZwwKRgL2gCLgVyGT0CWhNTSyiCXtlmYlUOhIPSTRIVnj8JrP0gSNBC3TOc4Ace7uOvbMFTFynmYEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJEYh8B/; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e9de355513so852245a34.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306273; x=1712911073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/anYJVaYp4+LJwrTuPW6oFGib9vUgK/MVhC5XY9qERY=;
        b=FJEYh8B/LHmxWPob19ecexh1i2kQ5ro6EtQ+qBliuon02oaiVKCj/nOPXFWNVbgZ8l
         nDjG1WwkihOJMd8ffcOkRKg8+cY0XigalP/738EIP9PipEEt8Hu04rKbGWt8L/TEkp4Y
         FoKye90sZ0atY0V5Yx3QpzDPdl1e5utXpdoD3x5PuhPEe9g/ZITfLJTRTkx2LQq/cYOi
         kJBhBFo5Z/H/tlXqSkeQVVv69k7p2cNMkLPRWifegt0Wyl+stuApcJTeCxQo2AF1/StM
         Xl9u4o5kOLwmiQLZiovTSzo7tSJAHMF8oI5mOH/XnKFWaNqMgEGU9pq9TRO99DkmtiQ7
         bi1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306273; x=1712911073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/anYJVaYp4+LJwrTuPW6oFGib9vUgK/MVhC5XY9qERY=;
        b=P49B6ig7vlIT2lzZ1GvRNHtxgbJyv23AxzBriQvloxnwb59biBDpU4dyRMwK55PvW9
         Hmli9dKqBLLcQXR5eDghwGnaORcDiMr8OKpbB22qSQhQGP8dw5uBO/qPE30afu0p3VEv
         cmy1MStNRisaUlEDkWnnxZ8i8vF4ByIBTsKVntyUmbsPWuZEkX70xMJv09bfcapN2M7r
         7e2em9HyiYfrxAHjRmY+HDQW5VY1NW+6CttoGvGXGzo+xsyN8HAh9K55Ygq228Jfr1wO
         FPsEwwFfYpAzrtuk7LQqVf0Zo2ZYyxCkM9pOyZztQvgp0+kvD7UGuzRhybQ8mSsU1nLI
         rD3g==
X-Forwarded-Encrypted: i=1; AJvYcCUL/KJeB5QnRJeqg+D0Jq01+OEq8ofQRUMXgOjE21RTE9SVAOzB2cI5ZOBDI4nDMpfcm/k9jSEcKYtgudIbqde2FN8H
X-Gm-Message-State: AOJu0Yypg1Y1lrEf7tZTNNmuQDPh4LIDEgGpk+AAmik87gGw5NP2NeoA
	nvBHVdSSsJnLhntNVU0sHjbeYsJWemjuoH7nfUguhVRXm1pFHnqG
X-Google-Smtp-Source: AGHT+IEfFFniJ4CjxEZcpOY//2eHENbvegT1teSegPz3vIaxiVQ8+HEX0Tsj2qjjilKwI2bcCyeYVA==
X-Received: by 2002:a05:6870:15c4:b0:22e:a70f:158 with SMTP id k4-20020a05687015c400b0022ea70f0158mr910354oad.7.1712306273189;
        Fri, 05 Apr 2024 01:37:53 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:52 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 30/35] powerpc: Add sieve.c common test
Date: Fri,  5 Apr 2024 18:35:31 +1000
Message-ID: <20240405083539.374995-31-npiggin@gmail.com>
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
index 5871da47a..410a675d9 100644
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
index 0be787f67..351da46a6 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -121,3 +121,6 @@ file = sprs.elf
 machine = pseries
 extra_params = -append '-w'
 groups = migration
+
+[sieve]
+file = sieve.elf
-- 
2.43.0


