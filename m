Return-Path: <kvm+bounces-19400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4585904AD1
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1EFF1C23864
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FA23F8ED;
	Wed, 12 Jun 2024 05:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7D++ZRL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8622B3BBF6
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169834; cv=none; b=CDWm+ofBv9G289qO8tX8NMCpK41Bc2SBKlAPxFj7wBr0TOKCT+h0qZGOgsYZ/OlUxl4Y20d57n/iNqE3ao16HumW3RIOjKEtd96S17uBPNrjJxkQQ9Srs6uk4WQXl52wTuPGimZJTLsRVBgQ0fL7irhr0v2OqqUnNthV/gWvot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169834; c=relaxed/simple;
	bh=HmQqNDMlSHLY+95ZE540v3IC83aHplhjs/SF/I6B96Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYCaZb6y8KNK6mV4Vuv4zB6TzwAqH7LbbrgJSi3IZgXGISXyD+wLCJEPZK3t7MvCGYIXDrLnVWsRMtW58fJu0J51HhGxQ/aeO/O8PgBGj3Qs96/thgFDZZLXziJeU5Ww1/dA3gM3pUPASnNFHbFpI0/FkWzIsotU+bFk/RCpB3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7D++ZRL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f692d6e990so60579205ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169833; x=1718774633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTVzxmkOngiwY2AMcf/1w5MP+3nR1mu8fLqrjh5W7lM=;
        b=Z7D++ZRLdGYyoD/vdh8YCpVfIUR1r4SJkquben2rEFX2MS7UfS36PV6/iYdudac24c
         c9nXs5GHIpa+IyKoSWBZBaFmo8um19z+MkJEFH5EFNAwdP/0yhZyJn/GM23u9GEB/xN2
         MCY795Ldk7slUMEIt7SO7pplS9LIFIijdNvKWC1XBu3oOhVD7oqrgDrB9rE2wKgBZ50s
         /5xkw+76YQMP8epEw3n2AURw/Z6nLSHEwKi7rWVtY5ka01tvsY2AnhTL5aLR3pCozbHU
         NX7B2S5E270Nvavg7W+RTr3WC3xEOWTxyKXp10czv3sXhDUE93whUmZUIAiN+J4IHq2p
         pg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169833; x=1718774633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTVzxmkOngiwY2AMcf/1w5MP+3nR1mu8fLqrjh5W7lM=;
        b=UCksVPWYeA0G+EGR1cm9Q7pXyv/PI1Yc/sm8Cc4JciSjS483ZhU56NviHqKqwrSyUg
         sxqED2aSmq1zLYuNqAdiyoJNTBrF3pSlm0Mks/VOq6JYMAPBIMFE+oNKgehStGBNfVZD
         TL7PKJE6AUEAls90bR0ETrpYFSGr85A8PhJokhkhlXe5md6OiM7ZzV3K2n0nvhqE1vyM
         Coq59wv7Jsbibvi7w3by2jgVdFOqHI+8X6z25nwW0ztqXqjfZSFAHnswmB1O79nSXkWm
         LxicaX8G/ri0tzOyYQaadK+iykQtNm6xmEFeMcpFFghb+AskBDkNiKvr8h7Yzafvwz8H
         f+2A==
X-Forwarded-Encrypted: i=1; AJvYcCU2BM7DDLUhgFcVb02bC2L0gCtrzHNvZ+QlchgWofwD7ujNL5OViA0pKiZlK/M9cAiA/p1qcpIzwWsQidNOrbyQS3wH
X-Gm-Message-State: AOJu0YwOVlGx5SVei8zWXJEggcpKYPOA8LkFSyWh7X1ZvvZLNu/gnlXn
	sE7sv1IvccYAkpzSknUZyS6jYU4uNVDjiATch7r/hA5Wj/8tSD0L
X-Google-Smtp-Source: AGHT+IFT4vVNxGrh0/Ssaxl+Nv3a6M4E9eQlhkw95iQGq43XTwW8DEHnaM1OPRJ7I6K4NvAm1pkm3Q==
X-Received: by 2002:a17:902:d2d1:b0:1f7:38c5:1f1a with SMTP id d9443c01a7336-1f83b565bc2mr9422475ad.11.1718169832831;
        Tue, 11 Jun 2024 22:23:52 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:52 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 06/15] powerpc: Add sieve.c common test
Date: Wed, 12 Jun 2024 15:23:11 +1000
Message-ID: <20240612052322.218726-7-npiggin@gmail.com>
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

Now that sieve copes with lack of MMU support, it can be run by
powerpc.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common | 1 +
 powerpc/sieve.c         | 1 +
 powerpc/unittests.cfg   | 3 +++
 3 files changed, 5 insertions(+)
 create mode 120000 powerpc/sieve.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index d8db19580..900b1f00b 100644
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
index 9af88d2ae..149f963f3 100644
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
2.45.1


