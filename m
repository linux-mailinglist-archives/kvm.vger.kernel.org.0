Return-Path: <kvm+bounces-13643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 400A08997EE
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB50B1F22967
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0EB15FA77;
	Fri,  5 Apr 2024 08:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMNVX4vJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78903DB97
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306164; cv=none; b=kBiSsGvQWvaS+3H0X5KvP0edazkHTY4Xn9Wdi7MqYYcQkud1Zy8m6cW5yLayORviYAIPNwCD6oKX+RtGw1b5sA+M3E1hjPuC8/GLktWZGkFy+LTo7gn1MNkFAbTSEoakt/LeGkJu3CKM+zYCOaT4Ggn1TFtq1Xv+lEPR4u5jvM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306164; c=relaxed/simple;
	bh=uOYbCMEoaf6PSDZTTGTARiCFhdqK6IdC2GwK+ScH1wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCbtESr+FmBPGKp9eKAZ9SzhVisNDgeGuaKGDQ5k24UwbZny5bVDWkJKqDys++luhQ21/7K8trnfuhBMJ89LbhCMQN00cLSwkYB0dAE+puZ1dd0Hy/ATPkDyyvY6mIuh3/5AbpSm68ohZUgnZxcpRGnyPaX4v/b1R4UCummOszQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMNVX4vJ; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3c56c6b5a36so534511b6e.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306162; x=1712910962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlJh78zrq2nypdEtpjDjfqC1R1hkLUUpunc23kqyAYQ=;
        b=MMNVX4vJ89z67ONf+WEe2iLcw46O03oOl537PA9+EiVM/O9XBLD3FrtgEtcG1Uywq+
         rI2xKUD+CnAzkwEeQ5up9HFp5n6JCbokavY2c0IHskeMvtnhRjUxzecRx0rfVZ70Vp+D
         IU1Jdl29QJ2JuwPKSu0bFEF0OnT60uGNrAZX3qNe5Z6jgOr0fwTSmCl7SXWoMO8Dr0w2
         Hv/9ZXileXs9vX1tAJ/HDCSyIfNXGocBotdyLbbaHc3HG0S8sNpooaxgi2+ItcGkyeXz
         +Gq0Ji+l9aPy4a+K//6rS3gl0AWEe5MC2FB2XV3rOVu9DviatIom9BxpovB56yqfTGid
         yJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306162; x=1712910962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZlJh78zrq2nypdEtpjDjfqC1R1hkLUUpunc23kqyAYQ=;
        b=hjJbPfH5OGPivnutgaQREI+LyC3Car7hue2wRZ74650C0CB9vTDExCd62k4lHRKS3s
         wBGLQtsjwPW3V39GifURPzWe99zZAGUMZ2sP8apDAe16jX/vxjQ5Rb/4pJzNimsM3JIz
         710TIw3yoPWXuRvd7lhzoX1pV5PP1mdtLnTG6tmA3Khm6e1l6LXcXdo5wqHRAMEgY7mx
         /bVWa5vKbCkejjIo5py8TLnrMCEbZugWrgnW/4aV52DYl+nA4WabJZgFXfgJABahbAZB
         N7cCh5F7tgpIq9SGIXXyHs3eZlCejeTxUZye6DDKpFr+KcUKc8S98m0pnEYrMXaQTIwO
         gHLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA7XMVMU43QkLmeta1RGWAJ78aC0hBFteAYRVRLi5H/nweBgBQA9ATgMxU7uNABAcwcgeghNIrSNnx/gmMvygsj9ap
X-Gm-Message-State: AOJu0Yxh/wsdcsX09vkXWCQ6GrGt6Thzyn059bKxpy/txc0ZoKub7IvE
	F9FHlhWY1rNKoBZ3nDy3FidKwQC2N+GBTEKT+funUkl5pkcYCo6X
X-Google-Smtp-Source: AGHT+IGmFhThdGg1uP3VOdDIq6TrDyGWPTtbICHPs4tcbKyfnBXHfScFeiKlMkVXPPvDvt4gvwPpdA==
X-Received: by 2002:a05:6808:48b:b0:3c3:9d04:9ef with SMTP id z11-20020a056808048b00b003c39d0409efmr732524oid.50.1712306161994;
        Fri, 05 Apr 2024 01:36:01 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:01 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 03/35] migration: Add a migrate_skip command
Date: Fri,  5 Apr 2024 18:35:04 +1000
Message-ID: <20240405083539.374995-4-npiggin@gmail.com>
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

Tests that are run with MIGRATION=yes but skip due to some requirement
not being met will show as a failure due to the harness requirement to
see one successful migration. The workaround for this is to migrate in
test's skip path. Add a new command that just tells the harness to not
expect a migration.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/selftest-migration.c | 14 ++++++++-----
 lib/migrate.c               | 19 ++++++++++++++++-
 lib/migrate.h               |  2 ++
 powerpc/unittests.cfg       |  6 ++++++
 s390x/unittests.cfg         |  5 +++++
 scripts/arch-run.bash       | 41 +++++++++++++++++++++++++++++--------
 6 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/common/selftest-migration.c b/common/selftest-migration.c
index 54b5d6b2d..0afd8581c 100644
--- a/common/selftest-migration.c
+++ b/common/selftest-migration.c
@@ -14,14 +14,18 @@
 
 int main(int argc, char **argv)
 {
-	int i = 0;
-
 	report_prefix_push("migration");
 
-	for (i = 0; i < NR_MIGRATIONS; i++)
-		migrate_quiet();
+	if (argc > 1 && !strcmp(argv[1], "skip")) {
+		migrate_skip();
+		report(true, "migration skipping");
+	} else {
+		int i;
 
-	report(true, "simple harness stress test");
+		for (i = 0; i < NR_MIGRATIONS; i++)
+			migrate_quiet();
+		report(true, "simple harness stress");
+	}
 
 	report_prefix_pop();
 
diff --git a/lib/migrate.c b/lib/migrate.c
index 92d1d957d..1d22196b7 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -39,7 +39,24 @@ void migrate_once(void)
 
 	if (migrated)
 		return;
-
 	migrated = true;
+
 	migrate();
 }
+
+/*
+ * When the test has been started in migration mode, but the test case is
+ * skipped and no migration point is reached, this can be used to tell the
+ * harness not to mark it as a failure to migrate.
+ */
+void migrate_skip(void)
+{
+	static bool did_migrate_skip;
+
+	if (did_migrate_skip)
+		return;
+	did_migrate_skip = true;
+
+	puts("Skipped VM migration (quiet)\n");
+	(void)getchar();
+}
diff --git a/lib/migrate.h b/lib/migrate.h
index 95b9102b0..db6e0c501 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -9,3 +9,5 @@
 void migrate(void);
 void migrate_quiet(void);
 void migrate_once(void);
+
+void migrate_skip(void);
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 1559bee98..cae4949e8 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -43,6 +43,12 @@ groups = selftest migration
 # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
 accel = kvm
 
+[selftest-migration-skip]
+file = selftest-migration.elf
+machine = pseries
+groups = selftest migration
+extra_params = -append "skip"
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index dac9e4db1..49e3e4608 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -31,6 +31,11 @@ groups = selftest migration
 # https://lore.kernel.org/qemu-devel/20240219061731.232570-1-npiggin@gmail.com/
 accel = kvm
 
+[selftest-migration-skip]
+file = selftest-migration.elf
+groups = selftest migration
+extra_params = -append "skip"
+
 [intercept]
 file = intercept.elf
 
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 39419d4e2..4a1aab48d 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -124,12 +124,17 @@ qmp_events ()
 
 filter_quiet_msgs ()
 {
-	grep -v "Now migrate the VM (quiet)"
+	grep -v "Now migrate the VM (quiet)" |
+	grep -v "Skipped VM migration (quiet)"
 }
 
 seen_migrate_msg ()
 {
-	grep -q -e "Now migrate the VM" < $1
+	if [ $skip_migration -eq 1 ]; then
+		grep -q -e "Now migrate the VM" < $1
+	else
+		grep -q -e "Now migrate the VM" -e "Skipped VM migration" < $1
+	fi
 }
 
 run_migration ()
@@ -142,7 +147,7 @@ run_migration ()
 	migcmdline=$@
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${dst_infifo}' RETURN EXIT
+	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
 
 	dst_incoming=$(mktemp -u -t mig-helper-socket-incoming.XXXXXXXXXX)
 	src_out=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
@@ -151,21 +156,26 @@ run_migration ()
 	dst_outfifo=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
 	src_qmp=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	dst_qmp=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
-	dst_infifo=$(mktemp -u -t mig-helper-fifo-stdin.XXXXXXXXXX)
+	src_infifo=$(mktemp -u -t mig-helper-fifo-stdin1.XXXXXXXXXX)
+	dst_infifo=$(mktemp -u -t mig-helper-fifo-stdin2.XXXXXXXXXX)
 	src_qmpout=/dev/null
 	dst_qmpout=/dev/null
+	skip_migration=0
 
 	mkfifo ${src_outfifo}
 	mkfifo ${dst_outfifo}
 
 	# Holding both ends of the input fifo open prevents opens from
 	# blocking and readers getting EOF when a writer closes it.
+	mkfifo ${src_infifo}
 	mkfifo ${dst_infifo}
+	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
 	eval "$migcmdline" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
-		-mon chardev=mon,mode=control > ${src_outfifo} &
+		-mon chardev=mon,mode=control \
+		< ${src_infifo} > ${src_outfifo} &
 	live_pid=$!
 	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
@@ -179,8 +189,11 @@ run_migration ()
 		# Wait for test exit or further migration messages.
 		if ! seen_migrate_msg ${src_out} ;  then
 			sleep 0.1
-		else
+		elif grep -q "Now migrate the VM" < ${src_out} ; then
 			do_migration || return $?
+		elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < ${src_out} ; then
+			echo > ${src_infifo} # Resume src and carry on.
+			break;
 		fi
 	done
 
@@ -207,10 +220,10 @@ do_migration ()
 	# "Now migrate VM" or similar console message.
 	while ! seen_migrate_msg ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
-			echo "ERROR: Test exit before migration point." >&2
 			echo > ${dst_infifo}
-			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			echo "ERROR: Test exit before migration point." >&2
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
@@ -220,6 +233,15 @@ do_migration ()
 	while ! [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
 	while ! [ -S ${dst_qmp} ] ; do sleep 0.1 ; done
 
+	if [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < ${src_out} ; then
+		# May not get any migrations, exit to main loop for now...
+		echo > ${dst_infifo}
+		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+		echo > ${src_infifo} # Resume src and carry on.
+		skip_migration=1
+		return 0
+	fi
+
 	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
@@ -259,6 +281,9 @@ do_migration ()
 	tmp=${src_out}
 	src_out=${dst_out}
 	dst_out=${tmp}
+	tmp=${src_infifo}
+	src_infifo=${dst_infifo}
+	dst_infifo=${tmp}
 	tmp=${src_outfifo}
 	src_outfifo=${dst_outfifo}
 	dst_outfifo=${tmp}
-- 
2.43.0


