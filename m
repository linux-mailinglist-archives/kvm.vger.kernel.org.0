Return-Path: <kvm+bounces-9248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D92D85CEC0
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F1E81C22D0B
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFBC39857;
	Wed, 21 Feb 2024 03:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EylNUC4M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7184C39843;
	Wed, 21 Feb 2024 03:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486145; cv=none; b=tQQr9N/Ar2ZPCGTOoyOQ+jPjlihlFNdqAYNqpu8MbAvH6joYdHHn1HDbq878Pq8wsdgQmVMBqcSoGgYkQ6kQCcLfKoeo+/FMAUGOXjrp5dC5ZlF+95mweQ4LEFqKm+8Y4+j7k+oqiGqkCR3StejmT4Pq69j1TJBu57vUNj5RStw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486145; c=relaxed/simple;
	bh=qDu6HLAwjNl8M0s+0tLz6VpR3l1XS4W0h0eQig5mi1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leKsGIdrDUDBwR58YaM8TPEIvj2dK8jcKQ7eJftqgmIwLA8bUukdNZ3fU2E8K8o7ToTGaQWLr6WsIvFjJFGtG2AA68CwIB8cji4IysDku3ylENQWKwVrT9O8P9NIZrKUjmpXvdexxqpf93fAUxR8cQanBVBqHe/BnPt0hWMx9Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EylNUC4M; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dba94f9201so40629865ad.0;
        Tue, 20 Feb 2024 19:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486144; x=1709090944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIo+YCQIpcqZZQl5SQPpBtKwaaGVQawpmU1ARg6aVZc=;
        b=EylNUC4MetQBC5T7EQ/lKzuVAE3CUuC1ozcv+0bd+K6dcBnu2iVCf1Hu0MlH6eGhe8
         5zFsoFFdr4wTtWTm6ZmeqENpD3v2P05sOn9sd0rv2FGhwo+juO0MsRBZNKb5BbFB4VSH
         xVW5+DQaNY7n6t5NlLMVQQwa4tD3Bi1sWvSTU4dc3VR9C1saNnQEQkWzLlIQdQaFv9+4
         87jIipC4YHXjkuvXAhqzu5k4GCHPcClWRW8uWTalVKTSXFNUc6vesYZNSNCiDHDYrLTT
         r7FfxrbGGT3tsiv5ltXi1AMLllTrbRwGZgxc3ZUf4QXJcPJFXBPe7+qn9yK/+oXnPkkS
         6anQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486144; x=1709090944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIo+YCQIpcqZZQl5SQPpBtKwaaGVQawpmU1ARg6aVZc=;
        b=bYihPaMB4LRf94HxvZ0Qg7rNR5K6REyMIJ5c1pKEqbF1Cms7rtka24jkyD219Nuao2
         gz/jM9WEc1emVRQff0azZIRJ7HZC8uwfaaV2Hs1eAM5+4RfQ1gPNZim2Gac2eUIQIAJu
         rK5Vj0FIE4WeByHv5JnWuX9GLP5Z91emi/2w3AuXrJ6Lz2vUrHkQglGo4aOh9hOwhgRq
         KHEMmh5T5UO0YJjg92WPzmQ2nITHg4+A/rXeDlmA0EtCebLF7w/O+WRBB328GnZ0oJ6n
         bBtiBRhxPMjPBHfXQCBnkBqspjqwCCEvKAKtXOEsH0HwtwVUcT1kPYWQJ9cydEwSY+4X
         zo4w==
X-Forwarded-Encrypted: i=1; AJvYcCUcqzYcpiXaanra1Vs6QUH6psvv9yocXsQh4qUywpGbV7cRNHqoA8+SMlLnln5ymp3leFkRRMpjWj9qX/zPT/+hommwZhTfws0eF7KCQ/A+VDjfMDBV84HDKI0MYXEALQ==
X-Gm-Message-State: AOJu0Yz2YisyfrpScfu1HiagwpQI8x6JxD3h44YuP46pAiIvQRpFwqb/
	t5Gl2ATmQVQUb4xaqUTeeVP2VHSYK3csXxizawljfWDXV4o9TqEt
X-Google-Smtp-Source: AGHT+IGkE2tXMoP+uu2dMPF9yafXmDF1WYeLW14EiA+DBNvKy9Jy7TtJJX6AdHjI0vAVunFoMBALqg==
X-Received: by 2002:a17:903:1211:b0:1d9:a609:dd7e with SMTP id l17-20020a170903121100b001d9a609dd7emr19873074plh.55.1708486143769;
        Tue, 20 Feb 2024 19:29:03 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:03 -0800 (PST)
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
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 6/8] migration: Add quiet migration support
Date: Wed, 21 Feb 2024 13:27:55 +1000
Message-ID: <20240221032757.454524-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Console output required to support migration becomes quite noisy
when doing lots of migrations. Provide a migrate_quiet() call that
suppresses console output and doesn't log a message.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         | 11 +++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b77216594..92d1d957d 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -18,6 +18,17 @@ void migrate(void)
 	report_info("Migration complete");
 }
 
+/*
+ * Like migrate() but suppress output and logs, useful for intensive
+ * migration stress testing without polluting logs. Test cases should
+ * provide relevant information about migration in failure reports.
+ */
+void migrate_quiet(void)
+{
+	puts("Now migrate the VM (quiet)\n");
+	(void)getchar();
+}
+
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
diff --git a/lib/migrate.h b/lib/migrate.h
index 2af06a72d..95b9102b0 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -7,4 +7,5 @@
  */
 
 void migrate(void);
+void migrate_quiet(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c98429e8c..0a98e5127 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -190,7 +190,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
-- 
2.42.0


