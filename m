Return-Path: <kvm+bounces-13644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 139288997F0
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EA83B21DEA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0292F15F300;
	Fri,  5 Apr 2024 08:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLyzFTJ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AE315FA94
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306168; cv=none; b=Lxmd3Zft5/RTcCF5yCXHEZZOdKh+BCRpeHtcycbRFP7IChQyPc5QLHteKNan72zy/9g0eJH8TAViX7jqZSM4M6q0SKp5kBZmu5o0H1hW8eTYu0VNlYH4PxjeYCIs/ybPKl+YwzZtvvkldAtbaqp8l57wr0lDPGKV9Ocwia9ZzYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306168; c=relaxed/simple;
	bh=X8QpAEb039gU3GNFbbllPcL5MHFmhDcUHJthAUkeqGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1cdEkrtPsDSOx0b04VXDjjPlsKsr5/NO3wMWtoDyzL24dJ/Mt6kZJyrWSuwECGxjwl03HJbDy25+qyUtAReT28nRfRso3RaA8Q3dAjLjc5YDk4oH4XIeRPTORqoh1zRog5+3mGHJ7ooM31AAQfAGwspAWAtQ1WErrBdFOVZWn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLyzFTJ8; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5a7c3dd2556so826518eaf.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306166; x=1712910966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hN1hRX0cnQA0eHx430zzveXl6A1e4BW3MBeplV5X5sY=;
        b=DLyzFTJ83chrhkh21BxFcy/xYooEXmVUskEFUNr1BKLbu3zo+eyFyIgl/iv4pNVSbG
         n0fIpIMqPceFHmuJTa7wdafmMl6iDBHDguCfjKnajlefgLAZ30FNMqHg2xLyEhb18vqH
         S097VrbIvAbwyPxaYEXRS7URUlsxaucgHV3u2YhDQLoJ+a26YuwtT/89pN7AkdjaDNCc
         +IOsTxOgLFJlh/TdLALgjG25c5W/P0EZ680hefybySJl0st3rTzDDNbPQstJxb+Ckd7B
         JnqGdRjpFuZzy5bW3Jpc273pVDH0WF5YocQimzaTsUEKL5CCFWfxxxe28XkXyIGjNpc1
         vpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306166; x=1712910966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hN1hRX0cnQA0eHx430zzveXl6A1e4BW3MBeplV5X5sY=;
        b=Xkrh6USTQys3IIJjsH7VC9Y2bkqNODQJGpAU4Z4w4hxNqbI7txZQv4hmtGmQ34wNYw
         SovLbbi/6ydmr3SjW//KlH9/EdbTXFvjwMgP8i645c9EUMPCemuf4pydyDKaePIEUhfB
         ufT9Reb7iSzFlB0ru/NAhfj1Pj4oJwael+a3WEBx4DYeQkI1yW529t9mpwi6jJBDnqo/
         +xxkCkoRl7zeluI6VRPKk43KxR755E8aR5R9yeDnTqUHTPc7qxkotfZ81RDBGBBMWwRF
         d4IaIALirb7ozjnJYMVhkQ7bgU2ILHdbl0RjJnQVfxBTpyNZRiLeSWoiiIyLU48v/RLd
         yTJw==
X-Forwarded-Encrypted: i=1; AJvYcCUwhrKChOYH2jIVTQLyV7lbJ+2JDrTEyi6CMQxFbwUkYPKPXjfF57R2bP1dqeykcPz4pxkQn01HW8pP2Z/LJdcgO3cC
X-Gm-Message-State: AOJu0YyWqIxINYv/+ob8awEQWNYYULlctTgG3HnoHRpax3aIcKeykTMh
	o0ErQVPdU1tiFD/mtxa3e1v68/1gz4YOgBSxgA2K9En6TKf66KcBfnvrZF+n
X-Google-Smtp-Source: AGHT+IE4X/ePynNQWpfbCZfQG6Gt/+FF3DicGox3f+vUkzFG3EidwqU5XM7OOMFn+Ba6KmLfrchbGw==
X-Received: by 2002:a05:6358:928a:b0:183:8bc6:82b with SMTP id m10-20020a056358928a00b001838bc6082bmr757890rwa.28.1712306165717;
        Fri, 05 Apr 2024 01:36:05 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 04/35] (arm|s390): Use migrate_skip in test cases
Date: Fri,  5 Apr 2024 18:35:05 +1000
Message-ID: <20240405083539.374995-5-npiggin@gmail.com>
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

Have tests use the new migrate_skip command in skip paths, rather than
calling migrate_once to prevent harness reporting an error.

s390x/migration.c adds a new command that looks like it was missing
previously.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/gic.c              | 21 ++++++++++++---------
 s390x/migration-cmm.c  |  8 ++++----
 s390x/migration-skey.c |  4 +++-
 s390x/migration.c      |  1 +
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index c950b0d15..bbf828f17 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -782,13 +782,15 @@ static void test_its_migration(void)
 	struct its_device *dev2, *dev7;
 	cpumask_t mask;
 
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
 
 	dev2 = its_get_device(2);
 	dev7 = its_get_device(7);
 
-	migrate_once();
+	migrate();
 
 	stats_reset();
 	cpumask_clear(&mask);
@@ -819,8 +821,10 @@ static void test_migrate_unmapped_collection(void)
 	int pe0 = 0;
 	u8 config;
 
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
 
 	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
 		report_skip("Skipping test, as this test hangs without the fix. "
@@ -836,7 +840,7 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
 
-	migrate_once();
+	migrate();
 
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
@@ -875,8 +879,10 @@ static void test_its_pending_migration(void)
 	void *ptr;
 	int i;
 
-	if (its_prerequisites(4))
+	if (its_prerequisites(4)) {
+		migrate_skip();
 		return;
+	}
 
 	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	its_send_mapd(dev, true);
@@ -923,7 +929,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_enable(pe0);
 	gicv3_lpi_rdist_enable(pe1);
 
-	migrate_once();
+	migrate();
 
 	/* let's wait for the 256 LPIs to be handled */
 	mdelay(1000);
@@ -970,17 +976,14 @@ int main(int argc, char **argv)
 	} else if (!strcmp(argv[1], "its-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-pending-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_pending_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
 		report_prefix_push(argv[1]);
 		test_migrate_unmapped_collection();
-		migrate_once();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
index 43673f18e..b4043a80e 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -55,12 +55,12 @@ int main(void)
 {
 	report_prefix_push("migration-cmm");
 
-	if (!check_essa_available())
+	if (!check_essa_available()) {
 		report_skip("ESSA is not available");
-	else
+		migrate_skip();
+	} else {
 		test_migration();
-
-	migrate_once();
+	}
 
 	report_prefix_pop();
 	return report_summary();
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
index 8d6d8ecfe..1a196ae1e 100644
--- a/s390x/migration-skey.c
+++ b/s390x/migration-skey.c
@@ -169,6 +169,7 @@ static void test_skey_migration_parallel(void)
 
 	if (smp_query_num_cpus() == 1) {
 		report_skip("need at least 2 cpus for this test");
+		migrate_skip();
 		goto error;
 	}
 
@@ -233,6 +234,7 @@ int main(int argc, char **argv)
 
 	if (test_facility(169)) {
 		report_skip("storage key removal facility is active");
+		migrate_skip();
 		goto error;
 	}
 
@@ -247,11 +249,11 @@ int main(int argc, char **argv)
 		break;
 	default:
 		print_usage();
+		migrate_skip();
 		break;
 	}
 
 error:
-	migrate_once();
 	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/migration.c b/s390x/migration.c
index 269e272de..115afb731 100644
--- a/s390x/migration.c
+++ b/s390x/migration.c
@@ -164,6 +164,7 @@ int main(void)
 
 	if (smp_query_num_cpus() == 1) {
 		report_skip("need at least 2 cpus for this test");
+		migrate_skip();
 		goto done;
 	}
 
-- 
2.43.0


