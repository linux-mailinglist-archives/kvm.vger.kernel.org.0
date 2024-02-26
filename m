Return-Path: <kvm+bounces-9783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AB3866FC0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77A411C26041
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B344B5D912;
	Mon, 26 Feb 2024 09:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+huvIjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CA25D909;
	Mon, 26 Feb 2024 09:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940349; cv=none; b=j4Ugn5kils9IXhFm7aBh2+JZNF8sxznsg/89hZXAuM+L6BE16gJoKcuXNxEyyW1XSiVW+BHJjAbOth/tsqjWWPaOxjY9GZEzF/kwznTF/AWwqYN+H9cNr20Z+PlueMQEJITmzzF9ZBL04Qo/h+INDN3pFqvmiEjaL2tdg1w9h3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940349; c=relaxed/simple;
	bh=iA7DaoP+QuzBYk7Rfrwd+LjSvPic0A1ECWLT/5NJYi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiTsmsNc/1dVVlrxlz/7zLMMJU3o+psMKUUbJy+1PXpIgRihkiECkfwxHbXnZLLrjwLnxcdirTHLQM2NIMoANo0slcVWOOh24xp5k3asBEfzDuMEMS52XCS0mkBjegoN8Vq+j4NddTNKmHe/F82EQf7w3Mbm07ujyw0lHqq/wsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E+huvIjH; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso2784865a12.1;
        Mon, 26 Feb 2024 01:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940347; x=1709545147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uC/70SEJzTHOJH25vt3H9h8+D3sESjLNUn4k7CqK+9E=;
        b=E+huvIjHMVsobA8XDev+PADz32hMv07aiZj2mEGezUB573NQfh3S7meYIAIWLQFdqt
         96b5+HLNUchvWCljMBsPL8Ln8uxqsmzuBOErRGSkGSbz3SFAZFGeRzbngsQ4Kj5BvF6z
         2DqSPcuu21cb2OOuTnx8JdMKH7WI/OEO/uvNV04O1IDNu6lUGbMhJmcZXhCXmgVhr6a4
         XnDg1FbVcbhirmAvbg27/d2KEYIaTK7+B5LZsCKsu0TDePdOQ36LKlr+LHQR4kEb+2s+
         jTq8goaUzHjVtUl/6gXhDsKjL9+scHl3s/J1JbAXmfquhPG5w1X9lPaF1sO+d6GdzW6Z
         qRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940347; x=1709545147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uC/70SEJzTHOJH25vt3H9h8+D3sESjLNUn4k7CqK+9E=;
        b=eDuto3WkW2lkofUGy4NAjY2t9FCs2eeH2wMWkJhmNyJHPzT2aNfmZuJ8QfKSoYDd+o
         XsaXw5IvTDo7vE+UAGVNWf+NPJOnaVt+Qa5jE6Sxv/Wf1G79zJIo4XOBUwJRgDwOOXJy
         B6hhzOU1SdloJDpwEoIoMjr/Fuc3Qj+rkK1sb24c/xUGJortlj/Aq0tL4Wgik05TQH78
         HfgDNx2d6XNalSGlMn2FDrsQDBOMY1/o25Qr8B0RrM70DN2Cn1iBL6X4zfI8B/55VGtO
         0qO8dPLVrQyyDOPzkY1dlAijkTIk40kxR/BvypvYMKTpJhZsbbvLtz/UBQkk8tHPtscE
         PIiw==
X-Forwarded-Encrypted: i=1; AJvYcCUCaVapJMBABFV1bN3eSB+2YbTQJ0eY2LaUDa1ZGUJQjbW1oTY5+3ir6oQk6ablaVryzxRXkQXwXuWu+4JccFnx+EeQvB3ebo+hAUU4997DUmHbQ9xcfYCvAwVOipZ4fg==
X-Gm-Message-State: AOJu0YxcQQxkSShYzn6ctdM86fUf/j727OHSR25R0zWrPZX6aX2nrXkc
	kCmSAktVpCl0hzAyLVz5LbHFmrs+jHL+Z74xZCECUUHUwP1Hnj3L
X-Google-Smtp-Source: AGHT+IGVHjLqOx0JzfzvBlojtHENa9XElZf47hWf9jVMVAK+crqgExNKzAI0S0P3U/MhCCZoNTPxcg==
X-Received: by 2002:a17:90a:9bc5:b0:29a:be1a:ea40 with SMTP id b5-20020a17090a9bc500b0029abe1aea40mr1608384pjw.9.1708940346798;
        Mon, 26 Feb 2024 01:39:06 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:39:06 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/7] (arm|s390): Use migrate_skip in test cases
Date: Mon, 26 Feb 2024 19:38:28 +1000
Message-ID: <20240226093832.1468383-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226093832.1468383-1-npiggin@gmail.com>
References: <20240226093832.1468383-1-npiggin@gmail.com>
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


