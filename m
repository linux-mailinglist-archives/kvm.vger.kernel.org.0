Return-Path: <kvm+bounces-7819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DADC8468DC
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C76E28A20C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B9E182A0;
	Fri,  2 Feb 2024 06:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2EIvxfo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75A18036;
	Fri,  2 Feb 2024 06:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857126; cv=none; b=FPNKMymPdTVHjwEblIjKMF+JDRa+SDxlYIE6GjdIM4wAHzFIv/hdPGA42ZwR8i2WfjGpCpjC8d4Y6M9IN8zH/XBMsTy1tJwhB8/91/qxI/s7HXciHUkmocRTYupqIxeHreKY2BuGrZSNQ2t/L+5xtWAntTNJbCv7g83frZwxefw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857126; c=relaxed/simple;
	bh=qf+Z507zWm1DYmhr84DySroy53fHkmOS7q7f629dhLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXopRguK9VGvt7pEYXApHVe604o0dsVq04GgZHcBREoRi0eg2u6yrC1KoGNHIyAGqze/xq8OQjSJ+S5TRs2tRfp5splGbHkGExoLXbGWbzXhdjCGlelLgnXLFEk8oCghaIPsZdAXPHK/VAFuUxZDhN0L8swsa02/OGVRtmhX1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2EIvxfo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d751bc0c15so15399915ad.2;
        Thu, 01 Feb 2024 22:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857124; x=1707461924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEmc8hWH0N3MbdgZGlp8+ITWi7wqdjs4A+FtzR//oQE=;
        b=A2EIvxfo7MIoFhDuiSu0WDmwHczfsXcNssVd8mOFcgddTiTHeKXbddOQGIHEF37Sv8
         jvkeRENnNIfl0Wt2m9PNKwUU3iaQ8knyAIceE+WfJHFNtf4f+Txfc+Cyf8iaBqRJxaFl
         C6HJ+RAUE3QZj8F75GqcJF+4WTnZVvn9RmX3iuHZupeejT2LxasK7MqB737Qi8OQE8tt
         KtTfDavhwEtv3eOpb34+8MA39vkl2J9yLiOVRFaY+G7ysFKNEQGi0Fg8V3+4vLPV1Kfq
         4yvhLFJxIbKI8mL8fLgTAM8XpsdFHxo//BzhVQymJ3Oc/ajhOwBOzvTvbIeS7LkLH8rc
         77Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857124; x=1707461924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEmc8hWH0N3MbdgZGlp8+ITWi7wqdjs4A+FtzR//oQE=;
        b=JeF43bykzNjllDCs7Qo7hkUJZ976oo9vaYamb0AegOxSx93svbtDtJONwIRwnB3cut
         eD0CILLYKrgMN0C3oFuNbS0cOlhbfW8ww+gvHBhveRamYZWI8JbJr1lL3aO/3dGooJ0M
         nI7pspcB2u60rMucScvh+HrBmbE/8uAejfTAjSTZ9w8HTQEzMNBuAC+FeyWYwdRFZeCc
         K108smxtKEucS0hqjyuzFttlWfvkK+EkBsOtN0D6BaCWxQu3hH6K8TrgH48GVEnIvYnX
         6VpRkysmld6PTPqZ9vLCvSV2+qid0daxBla8I0rYTak/d4M3oyLAdEU5YvnUh1GweSWN
         /emw==
X-Gm-Message-State: AOJu0Yw1Xs8X8wgpGji9YQrLbCIEfn17pa9Kw6yZykHWVUcKehPkk2Iw
	m1i2G/t5jqKcy3Wf3aAFKmOSpgw9qOhUKP7ylL82GOdXt2nPxjsL
X-Google-Smtp-Source: AGHT+IEKYSABCOjkDGMGdflmfxV2qc3jRIH3QBD7Yhpq7BkGGiFXaxmnSnvXekXjilfsnWCWCzgQEw==
X-Received: by 2002:a17:902:ee44:b0:1d9:711b:2698 with SMTP id 4-20020a170902ee4400b001d9711b2698mr803903plo.11.1706857124309;
        Thu, 01 Feb 2024 22:58:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVGs40QBZIB/PfkkQGjhB9nNwbC6szViKBKZbD4ssk5eDDBBXi3L3W4/xnS+CNzjZjseBDW6soqOFMTzUp7VUdlpLWOvvbqW0ZFKRdKAlITp0zIzzXEvie/kSq/k6NkaBf6OdKxreuobIT8w8amTZSCylrDZGsgpRAWKCv71MuBaILpYLuGNeYdwkdOxsXiYxfVtPa8bI5CAYATcitzsm3j/RHzXjMf4iji5mNgAR5szw/iLTWEEcWbap/JJliBi3QrUH7tvtUbTbs3RFX4LodEpXF6ygmvVoaQoCqNkwGQnB0363KLrjutPDGK40bX7dAAlpTNKgGjtCfvquUCTFm68Z2xoH1j7VP1PHDltFnZHpxTBM83/CC7WOknxgF/MyMQcXhQhV1+YxbZHTKlK7gAQ4FDgtA3IYk3wawkOvOwVNj3azwgzD7w3xun3mqkX0Y7T5/3Of98pM32Q7DbHnzvqnVrejo0j6//MVmoXE/iL1MIJK2aVoMuqo4uYSLbi9+sosQGzqLwFGo=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:43 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 5/9] migration: Support multiple migrations
Date: Fri,  2 Feb 2024 16:57:36 +1000
Message-ID: <20240202065740.68643-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
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
index 8fbfc50c..1ea0f8bc 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -132,29 +132,76 @@ run_migration ()
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 
 	# race here between file creation and trap
 	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
-	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+	trap "rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
 
 	qmpout1=/dev/null
 	qmpout2=/dev/null
+	migcmdline=$@
 
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
+	mkfifo ${migout_fifo1}
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
@@ -165,7 +212,7 @@ run_migration ()
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 3
 		fi
-		sleep 1
+		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
@@ -177,7 +224,7 @@ run_migration ()
 	# Wait for the migration to complete
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
-		sleep 1
+		sleep 0.1
 		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${fifo}
@@ -193,14 +240,34 @@ run_migration ()
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


