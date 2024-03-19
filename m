Return-Path: <kvm+bounces-12106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 478C087F8C3
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33441F2261C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E45F7D07C;
	Tue, 19 Mar 2024 08:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Is7bh7O9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009D154780
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835301; cv=none; b=Qdp07p6wUsvkg5ZbFoPOhnkHb1J62oMTn0cVA4ScrQbFum8XOq3pelcp3CmYQxdEULqs7OdecyadFONYqX1s97/arulJ9WuR+OkC9Vl/NYX11G7VoE5i+qwUEfiy/S9e2KNWM2W9OcjdV12+zrUA8llD8P6zUST3mi9z7J73yFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835301; c=relaxed/simple;
	bh=PA3jnpMDQ2JvGO9Tl3mu9YOJoKe9rHZkaAQGNKXTsbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdoFyxKE6j0R8rozfh+6EBEbSu95W7jUryrgynYuJWE09OGHp8gXq6WT/oJXEvvdONAHbY199Vq8BJp6p1OHCxxZcCE2zsNKgB87DDTW2XgQJijNK8gxU4OH0dYXRB0uQPV5A9ouwV6QySDpDo+0BX0j+9tSfxbmFfLx0Xc/s4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Is7bh7O9; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5a496fde460so1543582eaf.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835299; x=1711440099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHV3i4Gba0d6WT/j4EZFJfZJO1H61IDlaezqmWnREy8=;
        b=Is7bh7O9SYj8dr/WOBQuxbIe8VQyWn15A2GLIqhPVloswnFOHxWpuRlltzmNeSCWn9
         ZZK6qpepwulkBVFw7Dc6I/fMUF7g05wzQVTJnrTcHf2kw9DKfeiyGC6zvCezudKi9AzW
         qdEql87MNYMwaRoTRiQpHzEfrPBY6l7q1ynzo91/xi46DvPC3FqWQey/bgYHsMMW5tIp
         JZJHpVp6hAM/3HN64So7ReBont4hCTft8aylinWCf44ltvd1l9R6dA32In7o2ZNlwGR+
         lLgQiYlDNiU6xlzeaP5lvXF/PauBdolwqEdKds0Q0S5KlK6yZhe82Qe8w6X07N5t/cPR
         MLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835299; x=1711440099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHV3i4Gba0d6WT/j4EZFJfZJO1H61IDlaezqmWnREy8=;
        b=gXV5jLeT6r2hB9OkRgExm1maUT7FpX6U95vt9XqwkHNkQPo2HgwDms2hZFn7ofw0M4
         B0djkq5r/ROqAHCPmIyiP2Co14qjDweBAmz0PQlWEGhE9L3e5/ADIeVRKu28rQ3DWb4j
         WWR9gPM5UXzRe+LoUQEvVrdgriaPeTJsHMtz5nxaJeQF0PAr9X+rFtoQCv60Spy7E++h
         sCAkQRYjiLvLz/e7lxPZq+Y4VIG+lUWP1BysVV7nrR1X7YmXJ2uNrCyWyfJp9BO1jXSB
         t2DWv1OtcuuK9gvfERUYDQMtoR+SGJa8tuPvGCfAbbE0Hq6VTAzZH98w+ChPr7XFDGNG
         qQFA==
X-Forwarded-Encrypted: i=1; AJvYcCV22VZEXrr5A3wtouZQG4IL7nxghA+qLPP6FXoWnTO0PA6c3F78KTiezy4YItmhhkhrb6jb5EqklYmK81bR/prtQvHj
X-Gm-Message-State: AOJu0YxaXT6Y8sa8tzQE+JNXeUR7H8dsT2USd3TnAXs8dPkUwffl+QKp
	y5kgieDbs1ymKHDkVVHTSOuVzUsIlUJgwQuCCAfLE1+2mudJOBHs
X-Google-Smtp-Source: AGHT+IEXs0E8Qb6RA4bkQO4VYmb+dtVmkchk4sJqMglG8DUv1dLfuBOTpKPRWovT8+dXEQ7h57Mfvw==
X-Received: by 2002:a05:6358:56a2:b0:17e:9ca7:c3a2 with SMTP id o34-20020a05635856a200b0017e9ca7c3a2mr12938120rwf.21.1710835299085;
        Tue, 19 Mar 2024 01:01:39 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:38 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 30/35] powerpc: Add sieve.c common test
Date: Tue, 19 Mar 2024 17:59:21 +1000
Message-ID: <20240319075926.2422707-31-npiggin@gmail.com>
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
2.42.0


