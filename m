Return-Path: <kvm+bounces-8395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A15FA84F088
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2F3D1C26B70
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D55651B0;
	Fri,  9 Feb 2024 07:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNHTyj4R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FFE651B4;
	Fri,  9 Feb 2024 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462151; cv=none; b=sN+cdkaSfjEoG/88KiPEo0BxDCgsrKZ5zVqpjx57WQ5K/Xqe/Cz/H9vouh9pm7rslfxkNyuFgkks5vmMRsZrWZhopSNcOFcmHRkBneTlot/nyGRlN/6bZ9XEoXMd6WOxZMK1Ux3aZliOLFVduIDSRiIG8qsAdJhKrtzqS2nm1sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462151; c=relaxed/simple;
	bh=Gg7afgpKgLqxRrIVkPZ3CNm/sV/oLsSSBPr/dtBKVug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUrT/VV4m9FreD27F1N4QOGmVPQhQAhiihhTNc07yZY+T4/ygHLyaI0IMp4IfQ5TRXPiC8vH4LPWqpznM4RYMTBj3b6jj1ZGr50pswCc/WAP+lIEwv31gitXjpOil6DkY7vBv4LYFdvgXhfEhyTqeOx78QeYbDhjogD5dxPLvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNHTyj4R; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d934c8f8f7so5023505ad.2;
        Thu, 08 Feb 2024 23:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462149; x=1708066949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpqZHmKQT++Y4YOLTxyI6uDILUR5f0/cqNvHxqH8mFw=;
        b=kNHTyj4RSMAxYU/5DDb05KClcOi4Y35A0oCM/WYNH444Z4l9rV+P0tuBrx7UfWY9Ki
         6VWNtrZ/oVhhLHkEX6b8h8MSjdzMYZeNq7ZX8sgGIGHWx/cS2P5fIEIth5MhvbtE7l3+
         TAk0urTDVt9AbiFRDO9bE1IL1VJcSv3IQxp+gqrKlrDmfdnnHT4/TLmxhMjWzmlvSLS/
         YjlhIILNV0GGEfbrLm5+IZSRX53GyJGUjsf9bbBF9+1op+HtZ10zNC21mvUNOQazy3yu
         mdaatUWemPszH8dk3R4xBHVQQQ4in6t3JaXdEEDv+LSc0R1FqfVhDVLHtGLqzR0BFyPX
         SfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462149; x=1708066949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpqZHmKQT++Y4YOLTxyI6uDILUR5f0/cqNvHxqH8mFw=;
        b=IixueKTF6C3j1y6S3aCyaLDvs5zFLzf235foQdKJ/KlUqQyFlf2ldSuPcKNNdtIiU9
         /1XgSYN6MrEROC1pkxCPQEtkOSwAjkT4XfvOClvoKpi3tJwbxwwdBkQPOZFDCb0Xvuye
         WBHMK9xKUshHioO2AWMaYvfiLd6AZ5RIdLN28JLrtykGKhxZ8pTHjdl1+uk21wv1pZZy
         /lS+o0yneyOxRha+lozHvxEiok9B/VzvfjqKmvjAL+Ul6WRWtleNbyj8f8Z3verbDImt
         fv5u0PTAufmpykqZWgrP3qcICp7PjtaN74/OHRZ+io2AL7GEB2ON7K3Gg5Ao0SPQKtbL
         a/3w==
X-Gm-Message-State: AOJu0YxKpsABMss5lWsJOYZsrGSIacnafuMiau6T3HIJOi8aymigOY9U
	DLF/oT1nFvz3inNk0/UoRyUSDBwcHUJRAgjU9OMaSknKwa+e5iqOnR11DpZi
X-Google-Smtp-Source: AGHT+IE2tIcOzUjaHbEFDbBS5ugMbCwQY5qSy1ZC290ksdvjYfnwFlD/RrP/ga59ZKlW8QV7r/wUFg==
X-Received: by 2002:a17:902:c40e:b0:1d9:d444:313 with SMTP id k14-20020a170902c40e00b001d9d4440313mr904753plk.43.1707462149502;
        Thu, 08 Feb 2024 23:02:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUgb6TKnUtHNlr8ipsjz4i1op2gc+f7F4d9VegZaGXA20hmCD99A/dslBGtMaI+Pav04qe5ou2LwgxvwZgseJGgy1Bc+fZw2A7XsD994oakvysOOyE6btj4338nDFtq65ODbJmey8AYyYSVi8+QTbf/HosjEZNzpJKHOJCb7p8rz06sgGaRYpSfN/8/RzcoJzWeMTXp7tjovHRok7nk1ir4/AO2QuMZNX9dp2ydB3YMDWkwfcmYqG17aismMgV98MEYGLrqOpBk8X5WIRDMeSzhyehmrhjPs36Z59IsMuscXZAbEuxNdEzRMTc5ZBbnVQEgwrvwJYzTirPHlYjKaWLBjA8BvA4zZM1kzBYiFJkf5ADxFJYFA+ZIh1b9720ojImzI7dMfJ5m6DfOENpqMniqONd4fMi/hcfDojYzuqw4vGoxWqztQSFRq4+YerCfnohjOwdEt/NOf3nJSlLeOn8Ts+3SMRcGAWXFVT55/R7vfNhjALDmO9h6pELO2lCPwBrLSJQyswnNvJkwHiNJ+V3aIgfULqC+y3zBD4YNmrhZYKrRBETlwpN3
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:29 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 4/8] migration: Support multiple migrations
Date: Fri,  9 Feb 2024 17:01:37 +1000
Message-ID: <20240209070141.421569-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
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
 scripts/arch-run.bash | 93 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 85 insertions(+), 17 deletions(-)

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
index 3689d7c2..a914ba17 100644
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
@@ -142,18 +146,61 @@ run_migration ()
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
+	# The test must prompt the user to migrate, so wait for the "migrate"
+	# keyword
+	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+		if ! ps -p ${live_pid} > /dev/null ; then
+			echo "ERROR: Test exit before migration point." >&2
+			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+			return 3
+		fi
+		sleep 0.1
+	done
+
+	# This starts the first source QEMU in advance of the test reaching the
+	# migration point, since we expect at least one migration. Subsequent
+	# sources are started as the test hits migrate keywords.
+	do_migration || return $?
+
+	while ps -p ${live_pid} > /dev/null ; do
+		# Wait for EXIT or further migrations
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
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -164,7 +211,7 @@ run_migration ()
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 3
 		fi
-		sleep 1
+		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
@@ -176,7 +223,7 @@ run_migration ()
 	# Wait for the migration to complete
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
-		sleep 1
+		sleep 0.1
 		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${fifo}
@@ -192,14 +239,34 @@ run_migration ()
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


