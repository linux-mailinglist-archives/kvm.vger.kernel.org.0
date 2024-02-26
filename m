Return-Path: <kvm+bounces-9782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8770C866FBE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB0A11C25FAE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D135D8F6;
	Mon, 26 Feb 2024 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0shKZjw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32435D8F8;
	Mon, 26 Feb 2024 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940342; cv=none; b=A8fSxar9tZjyds3VVE+RuZIJo0RmfmLpFvoyMBB9/rIAut8NDZjqcCg6QQ4NRvWr2D2EuP1bv24EPTb3hW+OWwRbfh1y0947mwqibZSCSxk7JnBwtQfcxt8YcE+8E9KJO/qXKT+5meqQagQJA27AfAYc+qeG3L1baHnuXyVTEJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940342; c=relaxed/simple;
	bh=wsx7BsMuBLw39joSdYo5FDkv0qdEtnTE4Cwdt+maEYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc6suXXAzosRl4SBHfiImehdojB0Kc2DSo4JX8EG1AqutH0I17jhxtReaZnkkJT3UQ4RbVsQxM6vf4y7d5ZJ2nAwyyIIvK9EZatxEQCUiEuU3pIuDEaMh+I4j1owmbo8a0FxFvuhQUVXL99MPeOD5kbbuQOicm/Bwml/+o67AsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0shKZjw; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-299354e5f01so1592955a91.1;
        Mon, 26 Feb 2024 01:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940340; x=1709545140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONMw/aUYjeV89BATWOApXz401ptx8GI2JoexNBRfWig=;
        b=J0shKZjwPzgJx+iZti4mhySmTLiAXU4tl7QdQk85xI8TyjkuxsXFW5Q0LNz86EBRjt
         muMMMfMD9JW69894b13Qzol9ewaWqJEWqHhDBxqh1hbFDCm8UPQHS+E51m842poPPGtL
         G6OH+QQOKwRbSHQ2lY8EcAktMcOUBRR+R4cdE+pFSLkoWqqgfG6/cOMhkT/nkgGlO8/v
         ddGehqOibNXWAkfiTeCxLmn7pN3guHs4isi/KJH8lpBcNY4YvydG4o5Apv6K18vH1q+I
         9QQIEU7I5YSsmURny6a7zha8GEnvW0dIbCEvKzDLF80GvxwSsNzzIPwKdIEdDxTdqEuk
         EYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940340; x=1709545140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONMw/aUYjeV89BATWOApXz401ptx8GI2JoexNBRfWig=;
        b=hVl+nR4Fx07mywKaaOf0SuC8GKcvIzoC/aBDUH5oZIj+8b8B06wlWzROpaMfes9NWQ
         /t/8W+Yg1VmBCZflpLQZ1eVjhUcQB106u3Hef3UKCfnDJKTOjJ+DQI7KAcw57yzAHaEq
         tcr4vvXA/ZLGB9TH0Z30cgIjWT4WaqH3j5IvqAwH0J6h5zxNetUU+AXY93cqipXPuAVV
         5pqyB1s6z3FG2nh2KPUgLxZWYxarNvkgRB2P/EhUObFw/XhMlm8B3WohgDfKZfQX39jy
         DE63vH6xZzi+nXibo5bzG2Ek2QX22ZwVOg2Jrj7dVUCcnajHrbsJp0n9iaIjWtTiG5tb
         OQIw==
X-Forwarded-Encrypted: i=1; AJvYcCUUtcc2N1l789m/enqFJLlVQBFWDZAmOWtIiYuBUbeD0K8ZFVjNeXwdyk2DEFvb22CgVkM3pZbP/81fhf2fGXdwDpjG+ydApcXY6G+WR1g+0QzWHQPRMh1xDspmMF3dPQ==
X-Gm-Message-State: AOJu0YxYeKvm74LykesH2qRGjg25sgM9wWmE0MldEILMLNk72XQ5bLWA
	tAAiXUpCHNI9BU0fSox30u9c/dmn/BIe/FEXgm/mDpYd5YxIsnJaySX31K9x
X-Google-Smtp-Source: AGHT+IG8Lyq/lSbfkngouOGrJUMUuWUk/DM4NGMBnzl8BD3XkX5WjjmPgixo8kXQDh0Qy0uQtYwdYg==
X-Received: by 2002:a17:90b:f0a:b0:299:d975:89ea with SMTP id br10-20020a17090b0f0a00b00299d97589eamr8526892pjb.21.1708940339907;
        Mon, 26 Feb 2024 01:38:59 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:38:59 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH 2/7] migration: Add a migrate_skip command
Date: Mon, 26 Feb 2024 19:38:27 +1000
Message-ID: <20240226093832.1468383-3-npiggin@gmail.com>
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

Tests that are run with MIGRATION=yes but skip due to some requirement
not being met will show as a failure due to the harness requirement to
see one successful migration. The workaround for this is to migrate in
test's skip path. Add a new command that just tells the harness to not
expect a migration.

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
index 7ce57de02..89abf2095 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -40,6 +40,12 @@ groups = selftest
 file = selftest-migration.elf
 groups = selftest migration
 
+[selftest-migration-skip]
+file = selftest-migration.elf
+machine = pseries
+groups = selftest migration
+extra_params = -append "skip"
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index a7ad522ca..f613602d3 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -28,6 +28,11 @@ extra_params = -append 'test 123'
 file = selftest-migration.elf
 groups = selftest migration
 
+[selftest-migration-skip]
+file = selftest-migration.elf
+groups = selftest migration
+extra_params = -append "skip"
+
 [intercept]
 file = intercept.elf
 
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index e5b36a07b..d0f6f098f 100644
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
@@ -263,6 +285,9 @@ do_migration ()
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
2.42.0


