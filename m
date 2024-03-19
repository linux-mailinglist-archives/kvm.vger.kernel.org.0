Return-Path: <kvm+bounces-12080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC95A87F8A0
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33ABFB21455
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2613653813;
	Tue, 19 Mar 2024 07:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHpjUNRi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5346537E6
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835192; cv=none; b=BKi0eheDL8mrk2ML4Y1War9HwMNynr+mXP9sf+/atsxt41ojhWim4GZh8g7ayJrauR1odLQ3qK7YxRvoCpjlQ9Cu8Cn/4+o3s4z+IlTqBeJKvdkmzP1hq6Q6uSJYLGSQVYD8pzzln1TJuhQ8Phj0qbpzevMnukuuK83uzkeVXhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835192; c=relaxed/simple;
	bh=2umHXM6xiBPQG/I8pgOddpvnQPJz3BshwfTMvbLF8mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=envf6LKBbB2C3jgo8Cc1Kw4m8I+BhHMLry7S4lJCyEKSSB/abWNPTMnddXdYCSEeVlzdOqemgNsLudt83LvQif2wvGw3fMcx3695UHsi85I1Ty2P5mmhH4JrzMfMjWckfghXo3AKs7swpCmHMK2gdRmrDdpdBzw4LrbjewCzdAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHpjUNRi; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2218da9620cso3398617fac.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835190; x=1711439990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10lGgDqnsMt0XwfaOryIvipVXVv9JLsYtLmwhCPRr0M=;
        b=MHpjUNRiIntJ0FeHSmhratVMd7UAPmDWWcInlrYpaUdvSiQKyWcJJ79FdVWUjJX2XC
         oZP1NaqGUN0pWwIM3UlbmA84cPwnEcrhPWACSnSFdNYQKC5p6tmhy3BMG0nmPIDjGIUm
         qlxbm4o4ukGWZy8ba0BIutaz/yrtZfstBUOEs69xYwtNYaIh6bTJNlP/CgGTXl0IxHia
         mh5oRORyknWh8rTme5hpucQe5v924NThGJwD/N08rsQS5vexIIJRb/L3oZruLfYkoO8P
         4ihlmFs46RiBdgdZYBTa8kv+gq3+NqdRRrlkq/e2o+i6FUKJ8fRUOvOu+5/DGFHvjrod
         DMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835190; x=1711439990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10lGgDqnsMt0XwfaOryIvipVXVv9JLsYtLmwhCPRr0M=;
        b=n6U82IxrgxC0FJt/dSivLIMoiMyM6P4kKWE71vXiFVXe2d7FrobtekqoJ0SlcIq/R2
         BSjHMzJ+hv9R9ZBkCdLobMfiVIrjFWr0lZfCTFP/GkJEvtahln/j+1sKZErc5acqGKcK
         VIhBMbSOwaDbHRguZyKA3JR+4n3COE/F1O5aXeo4mvnVOKF9NFvbfaSBKsSyAa65Azr1
         Kx8WGv2Azc24JzwEx1I0jAPGTh/D1upuS7+NTr87fC4wmHdU3ZWC5IqIMwf1JtgwpjiP
         YwZYJX8znt0b/j+pechJJMO+DPj7+L1spyB2y4JfG8SBbEfC6yls5po7+9v5PuqvCj6p
         Gc8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVU2TT5FWzt7VJAWsnJTxDh1n3HwqraBNsFvcxi6Dvj8+kx+vUQQFIhePatqCZMhPKc1htGBb+0mQQVgI0+9EJC3ywX
X-Gm-Message-State: AOJu0YzYcEzaujhBz8//VoqLuY5ooRqNHYf96+3/dmgWs45LQ89Fm+GA
	k7wiSzbPdJw/sOapAJAq8GGxYYF1ZkeWYn3phmzBJ0WpXNEsNF9XvySm5Q15ZRw=
X-Google-Smtp-Source: AGHT+IEHA5cS3U9V0i0I4RyX7h8FZvucKUvdH1mBrotXbjx1EaX70J8HT3P3/TbrepxQrYOrIZQcZg==
X-Received: by 2002:a05:6871:7411:b0:21f:d4ee:ae01 with SMTP id nw17-20020a056871741100b0021fd4eeae01mr15154634oac.18.1710835190083;
        Tue, 19 Mar 2024 00:59:50 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:49 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 04/35] (arm|s390): Use migrate_skip in test cases
Date: Tue, 19 Mar 2024 17:58:55 +1000
Message-ID: <20240319075926.2422707-5-npiggin@gmail.com>
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
2.42.0


