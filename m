Return-Path: <kvm+bounces-13645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3BF8997F2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61CE21C211C0
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA25D15FCED;
	Fri,  5 Apr 2024 08:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQaHd0PU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD915F30B
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306172; cv=none; b=GRc3CdpKB8M9HYzmVJR9Z1Vk2l01//162aUx923wRDc6f1+DEJkxEU2Bb38xvwPG7lCkK7ttMUkGS2aAN13JkMVnrV/L/vmh0nWnzyrSFFrLrKbVbH51TsQgHc3pN2eHz+3nVw0Q2Ljc8REk3gViSW3JzRbkKwXVTT9UpiX5f3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306172; c=relaxed/simple;
	bh=OOvzAwg4vvhkhxbEUvNhP6Tgn7j1VSkVOtNpzBrJ00o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGS34HkZ9ZEs+qCUdL8RuLY7oqp52JOKV/ioIYz4jiWqYCN+3dYjrUHCp0TruZwpntqn6C3Z3lKjs9Ow5qGPrruQcUwg6GPaIjkE1sVnmf2O1RwVjOcIP0hSKiPC/f/LScD0QBdgG9k0Egvh/SCKLc/Oww67kT+PlPOL3DXADis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQaHd0PU; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a7d6bc81c6so1224617eaf.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306169; x=1712910969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCF8CELi+SjVv+NCZQU1TgZAmwKEyNScC88fkFD6Xtc=;
        b=GQaHd0PUOSp1AID2NWmBjHUqSPz0nJcIeLihnz2BJOv7H29hh5IJJMQv8NQRsiGR0n
         2//LLB8U/nzMc1fs058F5Y+MSuvldkRiz+CjcF7V3bBO6PrFljTiQDjgcWZ2BgkdDYqk
         6sGF33QDr7FTBFaJ3qfmQe+VaRJGioe/Lne13Hmwd6QqpI4iRa53qGQ1l0WW4VG/Jc2H
         Y3g47D4TDZH3r6/KBJUx/IbfY1cMGO7vRw9AgdvH09K+ttvkY8rN/NP8GEZB9AA0+5p2
         gqRx1oAOtIsxdR7In0fnTKDu4bJSy+DiD3etYvkonSVl8cDnUq0OtCMCJyeLPQ9r9Yho
         f09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306169; x=1712910969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCF8CELi+SjVv+NCZQU1TgZAmwKEyNScC88fkFD6Xtc=;
        b=jWZiFWMOlbTcVW51hYVaOKK+xnJ+1MPWPZ+uGH83vfr036qozmXKLITB/UbJURmmYM
         z0jnaJouXhInD53BLH3ew2lH62XNBvKxvS1MnyuUxE49MTQQN6Hu19LLW27zke6ry7Ks
         eq6HcMXU9EUV4j5u2GH4KeFpgkzBkOEVLA4DPeQVxLOp6mO1Y2M0X7d16Rn01DAuDz2e
         5I3qdeH/9XuzpIAP0E2I0QIukXwvQo/FUenYhuy8neCDZVfMnJDlXoaNoJUCIOSpfccU
         EXOjUYETOwzdsbrkcjjixQOnTerN+hRnaXAvzJvRJBcuKjVaLDXvaVOdyT/pIwg6WmLp
         bJeg==
X-Forwarded-Encrypted: i=1; AJvYcCWuKGcjwMBJjprEWMQnpn/gPcFrw1qrkkSEPraWqFomdGNHjLRDZc02XWFiW/NeCDx8ovFkCQ3OeWheA7gRWfl7lU20
X-Gm-Message-State: AOJu0Ywdhez16zNTpScJFA+1urQZJmt1Lu1xW36mKwrm1XTX9AGhZGNb
	nWXxJ2rwdEEdrbp8tDt25Icd3KmDDYK14UrCrvzs68fJnUuxGRah
X-Google-Smtp-Source: AGHT+IGBTaBzPlaZbDERwXoO5iqZJmQWJ4Nnt95EUEj71ivqQWdjsvpM4tFM31NCoNdjvudnJ7lMaA==
X-Received: by 2002:a05:6358:ed18:b0:17f:72ff:221e with SMTP id hy24-20020a056358ed1800b0017f72ff221emr964534rwb.4.1712306169455;
        Fri, 05 Apr 2024 01:36:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:09 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 05/35] arch-run: Add a "continuous" migration option for tests
Date: Fri,  5 Apr 2024 18:35:06 +1000
Message-ID: <20240405083539.374995-6-npiggin@gmail.com>
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
index 4a1aab48d..1901a929f 100644
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
+		if [ ${continuous_migration} -eq 1 ] ; then
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
+	while [ ${continuous_migration} -eq 0 ] && ! seen_migrate_msg ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo > ${dst_infifo}
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
@@ -229,12 +235,32 @@ do_migration ()
 		sleep 0.1
 	done
 
+	if grep -q "Begin continuous migration" < ${src_out} ; then
+		if [ ${continuous_migration} -eq 1 ] ; then
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
+		if [ ${continuous_migration} -eq 1 ] ; then
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
+		if [ ${continuous_migration} -eq 0 ] ; then
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
+	if [ ${continuous_migration} -eq 0 ]; then
+		# keypress to dst so getchar completes and test continues
+		echo > ${dst_infifo}
+	fi
 
 	# Wait for the incoming socket being removed, ready for next destination
 	while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
-- 
2.43.0


