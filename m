Return-Path: <kvm+bounces-9785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D93866FC5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 944961F28089
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F02A5DF16;
	Mon, 26 Feb 2024 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBOPT8Wj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189655DF0C;
	Mon, 26 Feb 2024 09:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940361; cv=none; b=GF6aZdWjATuYF68k/Y7NCAFcwy0FUD1CrrKTvbgi4UO/hN/mn8qj+6kAd/CbYsJrKBE0aSDYEIAGFT37kogMsvNP0aQv/XFEtizTt4GKAm061a/A4T6TiCAHXvhctUNivm7A6K7ssiBnUNGxPlv/451gyMN56z7NF5wVUdf/+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940361; c=relaxed/simple;
	bh=aidDpGUNOhroDLY0H6jPOoGBVRns5KrAKiGzCb72D2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTcbIuR+O3LaWVTAAUvohbT0KKrPklt0ITujtN17z7lQs+8YRakicvhuXz9SS5j/MHBM9bbw20FyqzInCz4R19rfJG+NCxWHHMGM1rX3si4caoPnZAGIBVGHfxo5YEgWEk0ooBvjVyy6X0P6q9svf97VTOaNiqX2YqVQxBTDINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FBOPT8Wj; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so1815764a12.3;
        Mon, 26 Feb 2024 01:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940359; x=1709545159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfqFlNeWfcRgXj7UGW4upVJVIE+P49J1N2eRNhWx+y8=;
        b=FBOPT8WjavSY++IxWpZzRRngI+2mRW0pcgwtk495HIyQztrvbAliYDy2PA15KS2w21
         +Y9C5lubod0XWE3KX99Cj9xODK7Z2qqxsoRPO1Mi5Lt4Oww2DvJnLv+BXjJjw3CxtWNm
         OXHJZp6g+PgTSBU1OVd1NXp3VPYbNxi0YXO8Yh+hBgHdONQTbeDyIUCWLx3dZYobub8t
         0Z1w7dv3ZC5DeUbWBD01yUJSkH6/WVTXTRVM3bZa4rTwDLcMkdWItC9E2YM+bSzqdwoH
         4lejlt7g/jhbHsl086yjhu3F+kIx94DQZnlWDEtlbD4FSOk+Dx+qW2xpe+kmrsvuHp8m
         kb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940359; x=1709545159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfqFlNeWfcRgXj7UGW4upVJVIE+P49J1N2eRNhWx+y8=;
        b=r96t9Vx9IgPbxDiUkd0E5BOqFwKfb7s1K1PBJ6Ww4cKdHL/XnXRgDbqbsk5sdYmsD3
         7VnbsrHnlQ3Jj7azLflh9jrMGZbGfw5WX6RsP4rULmONQ1IugzXCfW87J5Rt7kDWyGe1
         eVIJNDHxYq+g7MvcCND8EJV2AaoB378iLIY363SeJVbOysW9MwxTrvn5/tjviqbq6NiR
         4Q6WSD4ieFwnBNIHl0uqFJCpK164g9swsRqSuH/XfUG8SVazjsKUATf/OwCqFSzkDDhl
         ExzsQzh/GMIidUKGhN2DbNCApOjmQvCCV2a56uRagQjH13h/HaqTi6n9jnKwMzjWsz66
         MbJA==
X-Forwarded-Encrypted: i=1; AJvYcCXv/BZjo8J+Ll75R98R3JExmIoTt4uCkTpgcAkwopP2TmMLRTxFtrz6QQaPuRMFzW7NpnuML7xBEi3SrdlYfDJ5GBW58BO1jut4QYC0LYum4WtwTjBz8rEE8bjVS8burg==
X-Gm-Message-State: AOJu0YxtJrraB3749jh7AAy+LIa8/tCEgOryePcMK04GkfOgDhp18O5a
	+LB4kDUm9bjFT4+P37oCwiraYP9XZWbxQ7dLwCM4oaeqpHcOoKB/
X-Google-Smtp-Source: AGHT+IHbh6SI8T6/s0c3UOyoHhOzc5xA5DNsPoVfksWo0VGv11hLE0/hAfkwS0iY70YPjKgUhGHHIw==
X-Received: by 2002:a05:6a20:9694:b0:1a0:e09d:8ed1 with SMTP id hp20-20020a056a20969400b001a0e09d8ed1mr3838940pzc.53.1708940359344;
        Mon, 26 Feb 2024 01:39:19 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:39:19 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH 5/7] arch-run: Add a "continuous" migration option for tests
Date: Mon, 26 Feb 2024 19:38:30 +1000
Message-ID: <20240226093832.1468383-6-npiggin@gmail.com>
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

The cooperative migration protocol is very good to control precise
pre and post conditions for a migration event. However in some cases
its intrusiveness to the test program, can mask problems and make
analysis more difficult.

For example to stress test migration vs concurrent complicated
memory access, including TLB refill, ram dirtying, etc., then the
tight spin at getchar() and resumption of the workload after
migration is unhelpful.

This adds a continuous migration mode that directs the harness to
perform migrations continually. This is added to the migration
selftests, which also sees cooperative migration iterations reduced
to avoid increasing test time too much.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/selftest-migration.c | 16 +++++++++--
 lib/migrate.c               | 18 ++++++++++++
 lib/migrate.h               |  3 ++
 scripts/arch-run.bash       | 55 ++++++++++++++++++++++++++++++++-----
 4 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/common/selftest-migration.c b/common/selftest-migration.c
index 0afd8581c..9a9b61835 100644
--- a/common/selftest-migration.c
+++ b/common/selftest-migration.c
@@ -9,12 +9,13 @@
  */
 #include <libcflat.h>
 #include <migrate.h>
+#include <asm/time.h>
 
-#define NR_MIGRATIONS 30
+#define NR_MIGRATIONS 15
 
 int main(int argc, char **argv)
 {
-	report_prefix_push("migration");
+	report_prefix_push("migration harness");
 
 	if (argc > 1 && !strcmp(argv[1], "skip")) {
 		migrate_skip();
@@ -24,7 +25,16 @@ int main(int argc, char **argv)
 
 		for (i = 0; i < NR_MIGRATIONS; i++)
 			migrate_quiet();
-		report(true, "simple harness stress");
+		report(true, "cooperative migration");
+
+		migrate_begin_continuous();
+		mdelay(2000);
+		migrate_end_continuous();
+		mdelay(1000);
+		migrate_begin_continuous();
+		mdelay(2000);
+		migrate_end_continuous();
+		report(true, "continuous migration");
 	}
 
 	report_prefix_pop();
diff --git a/lib/migrate.c b/lib/migrate.c
index 1d22196b7..770f76d5c 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -60,3 +60,21 @@ void migrate_skip(void)
 	puts("Skipped VM migration (quiet)\n");
 	(void)getchar();
 }
+
+void migrate_begin_continuous(void)
+{
+	puts("Begin continuous migration\n");
+	(void)getchar();
+}
+
+void migrate_end_continuous(void)
+{
+	/*
+	 * Migration can split this output between source and dest QEMU
+	 * output files, print twice and match once to always cope with
+	 * a split.
+	 */
+	puts("End continuous migration\n");
+	puts("End continuous migration (quiet)\n");
+	(void)getchar();
+}
diff --git a/lib/migrate.h b/lib/migrate.h
index db6e0c501..35b6703a2 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -11,3 +11,6 @@ void migrate_quiet(void);
 void migrate_once(void);
 
 void migrate_skip(void);
+
+void migrate_begin_continuous(void);
+void migrate_end_continuous(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0f6f098f..5c7e72036 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -125,15 +125,17 @@ qmp_events ()
 filter_quiet_msgs ()
 {
 	grep -v "Now migrate the VM (quiet)" |
+	grep -v "Begin continuous migration (quiet)" |
+	grep -v "End continuous migration (quiet)" |
 	grep -v "Skipped VM migration (quiet)"
 }
 
 seen_migrate_msg ()
 {
 	if [ $skip_migration -eq 1 ]; then
-		grep -q -e "Now migrate the VM" < $1
+	        grep -q -e "Now migrate the VM" -e "Begin continuous migration" < $1
 	else
-		grep -q -e "Now migrate the VM" -e "Skipped VM migration" < $1
+	        grep -q -e "Now migrate the VM" -e "Begin continuous migration" -e "Skipped VM migration" < $1
 	fi
 }
 
@@ -161,6 +163,7 @@ run_migration ()
 	src_qmpout=/dev/null
 	dst_qmpout=/dev/null
 	skip_migration=0
+	continuous_migration=0
 
 	mkfifo ${src_outfifo}
 	mkfifo ${dst_outfifo}
@@ -186,9 +189,12 @@ run_migration ()
 	do_migration || return $?
 
 	while ps -p ${live_pid} > /dev/null ; do
-		# Wait for test exit or further migration messages.
-		if ! seen_migrate_msg ${src_out} ;  then
+		if [[ ${continuous_migration} -eq 1 ]] ; then
+			do_migration || return $?
+		elif ! seen_migrate_msg ${src_out} ;  then
 			sleep 0.1
+		elif grep -q "Begin continuous migration" < ${src_out} ; then
+			do_migration || return $?
 		elif grep -q "Now migrate the VM" < ${src_out} ; then
 			do_migration || return $?
 		elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < ${src_out} ; then
@@ -218,7 +224,7 @@ do_migration ()
 
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" or similar console message.
-	while ! seen_migrate_msg ${src_out} ; do
+	while [[ ${continuous_migration} -eq 0 ]] && ! seen_migrate_msg ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo > ${dst_infifo}
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
@@ -229,12 +235,32 @@ do_migration ()
 		sleep 0.1
 	done
 
+	if grep -q "Begin continuous migration" < ${src_out} ; then
+		if [[ ${continuous_migration} -eq 1 ]] ; then
+			echo > ${dst_infifo}
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			echo "ERROR: Continuous migration already begun." >&2
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			return 3
+		fi
+		continuous_migration=1
+		echo > ${src_infifo}
+	fi
+
 	# Wait until the destination has created the incoming and qmp sockets
 	while ! [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
 	while ! [ -S ${dst_qmp} ] ; do sleep 0.1 ; done
 
 	if [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < ${src_out} ; then
 		# May not get any migrations, exit to main loop for now...
+		# No migrations today, shut down dst in an orderly manner...
+		if [[ ${continuous_migration} -eq 1 ]] ; then
+			echo > ${dst_infifo}
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			echo "ERROR: Can't skip in continuous migration." >&2
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			return 3
+		fi
 		echo > ${dst_infifo}
 		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 		echo > ${src_infifo} # Resume src and carry on.
@@ -266,8 +292,23 @@ do_migration ()
 
 	qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 
-	# keypress to dst so getchar completes and test continues
-	echo > ${dst_infifo}
+	# Should we end continuous migration?
+	if grep -q "End continuous migration" < ${src_out} ; then
+		if [[ ${continuous_migration} -eq 0 ]] ; then
+			echo "ERROR: Can't end continuous migration when not started." >&2
+			echo > ${dst_infifo}
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			return 3
+		fi
+		continuous_migration=0
+		echo > ${src_infifo}
+	fi
+
+	if [[ ${continuous_migration} -eq 0 ]]; then
+		# keypress to dst so getchar completes and test continues
+		echo > ${dst_infifo}
+	fi
 
 	# Ensure the incoming socket is removed, ready for next destination
 	if [ -S ${dst_incoming} ] ; then
-- 
2.42.0


