Return-Path: <kvm+bounces-8418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBEE84F209
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5FB31F2694C
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55957664DE;
	Fri,  9 Feb 2024 09:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDm1EluY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB99664C9;
	Fri,  9 Feb 2024 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469937; cv=none; b=iox1wdQuqP2ov1f/RkKGpQmsYqrgVSff188qLNtY1YlVchiGj1NNmv3zTsKEa0YSlnuHf2+uBQRoeQgW2PlgurjMu0zGUt/mEeOGUYimlYDUhwDxHRWt6XUFV8BZS1G88oypE+iPr3fc7yee9vV8X6qjNmICEROlaRVKHKlMLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469937; c=relaxed/simple;
	bh=/BWxHdbgtJmDCBbNGut75HtAqp/5+5sSfL8SAdWk/SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThWGrc0BxZq377CFE9vphNliO/f520YZw4xyztzGCb7KcARDPLBNwuh4qtyU9uk970bGB3P3mdKC6Brljt2WdyF995FybBvmTJiGt92YrwEnxx31UvDnkdEPm3gdJosbizEwK+hpEfnRw5qxOnCtF3T9Faa5np1qN6moeYwrFM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDm1EluY; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-363dde86f0bso1927345ab.3;
        Fri, 09 Feb 2024 01:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469934; x=1708074734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT6qMRC+pw0S3IxnByVmt3CuBvluv9Wtp5vBNNErLSM=;
        b=dDm1EluYObNvEVCeZFeS7pvRbRHIGJw1Pj0Xu8XAVHWyCVnMr8DJI9q2oJWjh12Ccq
         DgPq/YEWQYbBcTEzBps0Ux5ptdrjqMb+zXnjlPTgk+qfhJqnOkZxneXldaLMexZa1bDJ
         26BR2EbQr70yYecJThy8527BTfWMR2MF1JqvvGD4a9EaFscSBR0GB9izmClKTvC4HaIs
         +yJyigpbnzPgDinXyfTFKWwIo7mdc1tKS9Vp4giDyFt7LWwstmdsQQbZJPgW6iy5mz+x
         XiQDoeIemlSZNlHeosUiFye39ulCzgYa27ftH7ya5Fg+dAO//jJayST1ostCRQwuhRox
         OHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469934; x=1708074734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fT6qMRC+pw0S3IxnByVmt3CuBvluv9Wtp5vBNNErLSM=;
        b=gi9BXQSxOcehCDW84SXaqB1GE8k1b1N6raKWD8nwJNOJD/5j4tt2mJz2rA+cubfEFM
         dpjYBWx7M9sKL5C33500JJg/onamEhMUiDBqQIYTHPobMjvpea6fvO5vo/ngYYa4G70w
         i21MMewCWSHEWMiTiYmY2CHi+JSANrKPaxpFB2eY01dSYped827NDfoSzSMh0UPvr5Lz
         erp8Acukn8BE90BSgCavXfvfL9uuxnmzYkXwkBng/WPfr+/Ct2jeY9u6djsKERkDKMRE
         SS/2AZYwfy5T1wYs/sBGneHego7JGwHMd3J/uTxpCNzmEDHzYHSaS/+lShdPdleW20pS
         1+Mg==
X-Gm-Message-State: AOJu0YzTnAkD4i91qSFeilRoY8U7ux2/+pH/LxHp2hnIW+WnErrtraDF
	809NoNkysrBgMsnXmkxdlKBPYRDVCys6XwVlf5WnpZ6g9FYQAX2tD5/sqkyN
X-Google-Smtp-Source: AGHT+IHibsT0DSntKBcN9RYYZqiACNyhgKRW2VVt94qySfQqZmMFZ504tD+p+VBnJx+v68Q4gh04Fg==
X-Received: by 2002:a92:b74e:0:b0:363:c664:cfed with SMTP id c14-20020a92b74e000000b00363c664cfedmr1118904ilm.32.1707469934457;
        Fri, 09 Feb 2024 01:12:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUVYUB37apMvQ3VGs+5Ws3Gf62dyGZo9vthw/uz2L8OaqTwDVzG54ysbUP990pgHiF+QNtoyOA03eNjx1V+XPOOE9bPSzjN43HzQNvLlrAC9EAgh47UXkUot0FXDfz9bYAWPqelgBgje2D8EMT5PUnZGIl+6zCs7aIg3+ZGh/7zewiyD1ugr9cR3Ec3QFOGVtoTxgGaa0mco2m36Gc37syL5HxoDl8tB7OUqiiwCs73+Ag2Lt3vx/yDxMcfmIzSFRPihipEKRuVJH1AypJqKPjCUu28AGG6v534t8byoP2pY8YAy8QkPbGM+d+AaywgPttwLbA19VlO0PFkRzhUw4hI8Cj7EOQ8R/MnpLdZrgyWTzY/O0kidqUV9XJE3B7Ju0OampFZD00XE6Msn/CHG2OmecmFiFyY5M4pv1zwbh+LAtrk8zIzClmGUq/8ArY+g0DyeHn9H/bgFP7SA0cpfLUH3hKHqDsTEri1+o1FQzMuKvgpkWukjEm+chYWmmmo3dU5nf8NhrTVyoNDows/v56C+GpToh/abzr/uRsw+gG/UMq1QvVLg3Pf
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:14 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 4/8] migration: Support multiple migrations
Date: Fri,  9 Feb 2024 19:11:30 +1000
Message-ID: <20240209091134.600228-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support multiple migrations by flipping dest file/socket variables to
source after the migration is complete, ready to start again. A new
destination is created if the test outputs the migrate line again.
Test cases may now switch to calling migrate() one or more times.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         |  8 ++--
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 86 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index 527e63ae..b7721659 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -8,8 +8,10 @@
 #include <libcflat.h>
 #include "migrate.h"
 
-/* static for now since we only support migrating exactly once per test. */
-static void migrate(void)
+/*
+ * Initiate migration and wait for it to complete.
+ */
+void migrate(void)
 {
 	puts("Now migrate the VM, then press a key to continue...\n");
 	(void)getchar();
@@ -19,8 +21,6 @@ static void migrate(void)
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
- * Since migrate_cmd can only migrate exactly once this function can
- * simplify the control flow, especially when skipping tests.
  */
 void migrate_once(void)
 {
diff --git a/lib/migrate.h b/lib/migrate.h
index 3c94e6af..2af06a72 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -6,4 +6,5 @@
  * Author: Nico Boehr <nrb@linux.ibm.com>
  */
 
+void migrate(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 9a5aaddc..c2002d7a 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,12 +129,16 @@ run_migration ()
 		return 77
 	fi
 
+	migcmdline=$@
+
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
@@ -142,20 +146,54 @@ run_migration ()
 	qmpout2=/dev/null
 
 	mkfifo ${migout_fifo1}
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
+	mkfifo ${migout_fifo2}
+
+	eval "$migcmdline" \
+		-chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control > ${migout_fifo1} &
 	live_pid=$!
 	cat ${migout_fifo1} | tee ${migout1} &
 
-	# We have to use cat to open the named FIFO, because named FIFO's, unlike
-	# pipes, will block on open() until the other end is also opened, and that
-	# totally breaks QEMU...
+	# Start the first destination QEMU machine in advance of the test
+	# reaching the migration point, since we expect at least one migration.
+	# Then destination machines are started after the test outputs
+	# subsequent "Now migrate the VM" messages.
+	do_migration || return $?
+
+	while ps -p ${live_pid} > /dev/null ; do
+		# Wait for test exit or further migration messages.
+		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+			sleep 0.1
+		else
+			do_migration || return $?
+		fi
+	done
+
+	wait ${live_pid}
+	ret=$?
+
+	while (( $(jobs -r | wc -l) > 0 )); do
+		sleep 0.1
+	done
+
+	return $ret
+}
+
+do_migration ()
+{
+	# We have to use cat to open the named FIFO, because named FIFO's,
+	# unlike pipes, will block on open() until the other end is also
+	# opened, and that totally breaks QEMU...
 	mkfifo ${fifo}
-	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
-		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
+	eval "$migcmdline" \
+		-chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
+		-mon chardev=mon2,mode=control -incoming unix:${migsock} \
+		< <(cat ${fifo}) > ${migout_fifo2} &
 	incoming_pid=$!
+	cat ${migout_fifo2} | tee ${migout2} &
 
-	# The test must prompt the user to migrate, so wait for the "migrate" keyword
+	# The test must prompt the user to migrate, so wait for the
+	# "Now migrate VM" console message.
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
@@ -164,7 +202,7 @@ run_migration ()
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 3
 		fi
-		sleep 1
+		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
@@ -176,7 +214,7 @@ run_migration ()
 	# Wait for the migration to complete
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
-		sleep 1
+		sleep 0.1
 		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${fifo}
@@ -192,14 +230,34 @@ run_migration ()
 			return 2
 		fi
 	done
+
 	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+
+	# keypress to dst so getchar completes and test continues
 	echo > ${fifo}
-	wait $incoming_pid
+	rm ${fifo}
+
+	# Ensure the incoming socket is removed, ready for next destination
+	if [ -S ${migsock} ] ; then
+		echo "ERROR: Incoming migration socket not removed after migration." >& 2
+		qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+		return 2
+	fi
+
+	wait ${live_pid}
 	ret=$?
 
-	while (( $(jobs -r | wc -l) > 0 )); do
-		sleep 0.5
-	done
+	# Now flip the variables because dest becomes source
+	live_pid=${incoming_pid}
+	tmp=${migout1}
+	migout1=${migout2}
+	migout2=${tmp}
+	tmp=${migout_fifo1}
+	migout_fifo1=${migout_fifo2}
+	migout_fifo2=${tmp}
+	tmp=${qmp1}
+	qmp1=${qmp2}
+	qmp2=${tmp}
 
 	return $ret
 }
-- 
2.42.0


