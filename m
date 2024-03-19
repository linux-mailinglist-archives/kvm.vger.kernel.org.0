Return-Path: <kvm+bounces-12081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0180387F8A1
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38133B21A82
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE5B5465C;
	Tue, 19 Mar 2024 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoCDJ0ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D64C5381D
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835195; cv=none; b=iiKm+QzuCt63FkRyik/sN4QeGV1Yl3rEFHkkyT+Vry7rj87On3ZwjU8hTAglHsY+2o0d2GOFM44vXg34G/e0Cv1PDKKOlNPk3UahwNEDVb+ypowsajKbpkP+IuPafrBKZHK34okAkNxp0BsEplHzkX2ep/BLmD3PEvebApEQP6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835195; c=relaxed/simple;
	bh=8IXr4UuQi3NgEUSLWaFgv0MPTheZH9vSih7eJWOsIuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iokChCpmugU8O1u6DO0OabVbT9EnIEOHW7XIVyQ60HgNNrWxVz/6je3TxUXcV6kxSmDCx0zJY0kiGCzjw0a/ks/hHiQM5wI75COSTv/b+VFqpITORgXJjETi4vY/ecVtm2hNc54Xgj75LyB3lK+QcHG2I448UmfRbEx4/9SljNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DoCDJ0ls; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6cb0f782bso4408740b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835194; x=1711439994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwiLL+39rNvTnl3S/NlQsxl8YV1cuqwJpTXMZpjU20o=;
        b=DoCDJ0lsOEb2hT28tz/ztIxU1gqw7cCohZqiEyPwci7zJgob2sCFPU8o0La8BWGX0H
         1epnPmYqu315IwQbkDHxckTAOC99Y0YAD9kjagbBjXX0zpeoiaeEjRRtMobNfF+7aeCx
         BKv6mTFpzFyAM1B/wCfuCq0PTXrp3fGz8pTIiiVwVGe6P3qYvS+JbN630GHhQqRx2coa
         wc2j9l1Hb01bWM0Y0Bvr1iJ8xu5995uGR0Udk8daZOOs/u/3hyM4jFvZky4iiAd8+f+/
         2qJaOPtj3AsIgMgEdpZQxD19MfNsAGO0fYYayykipPlTvfk80SpupZOR/ShRbvrZzNLG
         LLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835194; x=1711439994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwiLL+39rNvTnl3S/NlQsxl8YV1cuqwJpTXMZpjU20o=;
        b=KTz/Ut5K+WDvYln5WfwCxcYHDw6rD8VE6upMctOtGwuZgyCS3dw3lwYFeg9jqS/giA
         xv1wdnV8W+/lpAz2Fn6FaswIV5dm9WBzCCI8kLpthlApkGcf8CMEBHKkLwrq2GBEPq3n
         +usnebtcsYXYNtmpDg6Ek6dWu2uugx90ZyPFysa9cxzU8+HbzAfl3FDhRD6SDbtM4mGp
         DumYk3/ItMX2CeC8xlxWMwcL0Gohzn581TmmQYmBRJDFP8Cfacs+cFLJUUtFS9Q3M4Mb
         L47jMGCEQciRBkjEauBGJOsfodZvnbwsZdB7Lb0pWixldlkylVl9ysve5SFlcJK8yYSS
         m6mg==
X-Forwarded-Encrypted: i=1; AJvYcCVFgSwf+AHhphPPazX2PLNbMD2QpsLoRhY/rAWiXhMFtw3qXx22v4nHwP/xyC+eqwVISuVoXXvREiJJl4O6g8I7ZIA/
X-Gm-Message-State: AOJu0Yz2VGVQx0GXYNkW7HLeWcsZkX8XtEhmvujXHvteICByphWncfOx
	Exc+FNsnoWY7W6AHGRU15QZX5Y7R4OA6OCh1+R9C8PajhORnqRvV
X-Google-Smtp-Source: AGHT+IF9J5BfMuicYhHFmGj3QmDkgtilbahQgsH/XQQp9Mr0YY71rN0t/oPLgM3FmJxBPiyt5H8umA==
X-Received: by 2002:a05:6a00:844:b0:6e6:fb34:2568 with SMTP id q4-20020a056a00084400b006e6fb342568mr2080064pfk.0.1710835193686;
        Tue, 19 Mar 2024 00:59:53 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:53 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 05/35] arch-run: Add a "continuous" migration option for tests
Date: Tue, 19 Mar 2024 17:58:56 +1000
Message-ID: <20240319075926.2422707-6-npiggin@gmail.com>
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
2.42.0


