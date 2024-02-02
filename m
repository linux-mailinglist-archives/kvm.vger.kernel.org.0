Return-Path: <kvm+bounces-7820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9C28468DE
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 226411F245E7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7137182C7;
	Fri,  2 Feb 2024 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZO04/Fp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BF182A7;
	Fri,  2 Feb 2024 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857134; cv=none; b=d6mq732dhwzm0HTO9qu/1VwbI+TtDs4RqlZfr/y+HfgzPcV/MM7bTGBvfT8r9nVVUTIgmrAuV5ctA/OYZ+N3tZHRLpj0nabrlakuuwp2kNpTL/lcLb6XW4Eit6Cj8Vyj39XG/9FkAGQpUDnB7xqbY3fGKdyej3WpUpb5MW14ycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857134; c=relaxed/simple;
	bh=k/P3mR8fsIYxfqTmx4AUyrHMn1pKj7edNiwO+rhP/4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exTmyp2PWI0xDnMmdwtZr91ja+NKjLD05tQ9RqxO9x7C/qq78uDKUApsVqcPo5YLIhZyRVfTmu5jihCUoMlJtfzGQDQLQdqo+nwthCirUwhuxhkXitjv2b8qpBNA98Jno7Bl7zgOxzMbnPyc9So13BEFhFSZGMZrINe1eJ8QTKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZO04/Fp7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d780a392fdso14973975ad.3;
        Thu, 01 Feb 2024 22:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857132; x=1707461932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSBY/qUR3vEv/4J5fGD2VKLCaKXAp4kdXbDH3R5DRjk=;
        b=ZO04/Fp7jTOYnqotKUZyTpRG2DvFmKnqD1FrHj2SMtXG2gWDWyfQckMunINDr6efKN
         BQ1hE9o4JrDt/sUx6HatyPWWBTghIu8Sod2t39eDRJ4RRJYpKdvZaSPqfcJ0IgaBceHY
         RQykVVkAvl33lLrVU3irZsQJzRy9aYehWz9RwI65uhmP8ExT9In3ok8brPMZqhBoC7XF
         3F0rCG1t8XFNu8omeZnx69gD9nMfDCa8OHft5Gl/Z++9XgTrUWF/Fupxr3MBNzC+Y7+r
         4mjsGuMrHaCxpRtO2NDK3gM4csbgwZUONxworNCkfGJAFnHmvr9Al1NM+ezxfOPDUATi
         Brgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857132; x=1707461932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSBY/qUR3vEv/4J5fGD2VKLCaKXAp4kdXbDH3R5DRjk=;
        b=AlfsD4zEpTjYad5CWVCGSKlQlWqePQPxX+h7HaABCiVjNEIxpVUbQxyQ8wCpD2cNkF
         T39bKqsN5Fbj+gz3ldlqO2PLn66qi7Eql+Kfa7NuPY7SPJ923KWJ6a7GtLSyGCfpcePt
         RZ89LpmrwaoJNNa8DlEEeeQJfeYSo/W7rgaQHcKrXJvCwXdx3dBIT4amLUFe+9HRSL7I
         +In+e3z0ju/pyq7JKQ4BZmbueng0R7bbQ8EUZfEt6qKKnNgneF1FciXeFDn1jMXNnter
         5ng/hGvSv9C0j52KjM/m2JdTqmZu8naBl99l+9j2+HXQhPdhdL/UJhowMEqq6Uq04b9V
         DeoQ==
X-Gm-Message-State: AOJu0YyXpeqDzFVS7TKN+LKafLOpFvVzrHfURANvavh2Z3Y8NLwcOiFc
	i7ePyHQcGWHweVdmAPTuwPrU25WE0V4CRsViCwXgdNuLkaWcXPak
X-Google-Smtp-Source: AGHT+IGGWkPpz9cV+EqJznvJjULk/Kf3RcDOGkpaaivKSaza5AuYnVyC7UlPmSNta4kkSAyCE2hL7w==
X-Received: by 2002:a17:902:f807:b0:1d8:cda6:7ed0 with SMTP id ix7-20020a170902f80700b001d8cda67ed0mr3751650plb.59.1706857132599;
        Thu, 01 Feb 2024 22:58:52 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWPJuGCnjBjriAPBKYD/3la8s9SF0GNZmQhuTi4oGje0EqvGe991nJDa7WAr6cANvY8FPwcs0OC8ql+ygmQkAHSnysMxDYXxrNd4qV7sceYT8SxGULB/MPFHFxSFeKbwRKDR0P6eMrg/1WotJ6ph6aRHP43SkeoB2zAFIe6ur4ZmaZU5vwJw1YsdBA12p4+RcwdOISurqTGwcc+czNFCVJfy9uZ/cckNoIWoSq97IyW7aDv+36iBFHLC1YmKW3d3FAPiak+CoKcbvvcHBfhjjql8rJwq0peYKbIPd5uopOVkw2GaFIeDagnYdxwESRog044MC9FUVa1fMw0KMYK+NxEir0l7sWuj5BFRMw8897j3MPsmvkaEGjsN2gvOLgCoMsSFBHKHiTMiqa5ILmKXC7VAoBe822BA2XhBWzwYATv8wFJRR1ZV/nCufn83p35DSBI08qjQaNr3FVHSG3WvuSBN4lzpAOOl0I6/pHGWof7xS39HDZ5GPeObntRDXiafRLamzQEpzrO9eg=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:52 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 6/9] arch-run: rename migration variables
Date: Fri,  2 Feb 2024 16:57:37 +1000
Message-ID: <20240202065740.68643-7-npiggin@gmail.com>
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

Using 1 and 2 for source and destination is confusing, particularly
now with multiple migrations that flip between them. Do a rename
pass to tidy things up.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 112 +++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 55 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 1ea0f8bc..0feaa190 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,38 +129,39 @@ run_migration ()
 		return 77
 	fi
 
-	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
-	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
-	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
-	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
-	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
-	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
-	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
-	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
+	dst_incoming=$(mktemp -u -t mig-helper-socket-incoming.XXXXXXXXXX)
+	src_out=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	src_outfifo=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	dst_out=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	dst_outfifo=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
+	src_qmp=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
+	dst_qmp=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
+	dst_infifo=$(mktemp -u -t mig-helper-fifo-stdin.XXXXXXXXXX)
 
 	# race here between file creation and trap
 	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
-	trap "rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+	trap "rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${dst_infifo}" RETURN EXIT
+
+	src_qmpout=/dev/null
+	dst_qmpout=/dev/null
 
-	qmpout1=/dev/null
-	qmpout2=/dev/null
 	migcmdline=$@
 
-	mkfifo ${migout_fifo1}
-	mkfifo ${migout_fifo2}
+	mkfifo ${src_outfifo}
+	mkfifo ${dst_outfifo}
 
 	eval "$migcmdline" \
-		-chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${migout_fifo1} | tee ${migout1} &
+	cat ${src_outfifo} | tee ${src_out} &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
-	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
@@ -173,7 +174,7 @@ run_migration ()
 
 	while ps -p ${live_pid} > /dev/null ; do
 		# Wait for EXIT or further migrations
-		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+		if ! grep -q -i "Now migrate the VM" < ${src_out} ; then
 			sleep 0.1
 		else
 			do_migration || return $?
@@ -195,79 +196,80 @@ do_migration ()
 	# We have to use cat to open the named FIFO, because named FIFO's,
 	# unlike pipes, will block on open() until the other end is also
 	# opened, and that totally breaks QEMU...
-	mkfifo ${fifo}
+	mkfifo ${dst_infifo}
 	eval "$migcmdline" \
-		-chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
-		-mon chardev=mon2,mode=control -incoming unix:${migsock} \
-		< <(cat ${fifo}) > ${migout_fifo2} &
+		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
+		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${migout_fifo2} | tee ${migout2} &
+	cat ${dst_outfifo} | tee ${dst_out} &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
-	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
-			echo > ${fifo}
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
-	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
-	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
+	while ! [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
+	while ! [ -S ${dst_qmp} ] ; do sleep 0.1 ; done
 
-	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
+	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
-	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
+	migstatus=`qmp ${src_qmp} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
 		sleep 0.1
-		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
+		if ! migstatus=`qmp ${src_qmp} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
-			echo > ${fifo}
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
 		migstatus=`grep return <<<"$migstatus"`
 		if grep -q '"failed"' <<<"$migstatus"; then
 			echo "ERROR: Migration failed." >&2
-			echo > ${fifo}
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
 	done
 
-	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+	qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 
 	# keypress to dst so getchar completes and test continues
-	echo > ${fifo}
-	rm ${fifo}
+	echo > ${dst_infifo}
+	rm ${dst_infifo}
 
 	# Ensure the incoming socket is removed, ready for next destination
-	if [ -S ${migsock} ] ; then
+	if [ -S ${dst_incoming} ] ; then
 		echo "ERROR: Incoming migration socket not removed after migration." >& 2
-		qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 		return 2
 	fi
 
 	wait ${live_pid}
 	ret=$?
 
-	# Now flip the variables because dest becomes source
+	# Now flip the variables because destination machine becomes source
+	# for the next migration.
 	live_pid=${incoming_pid}
-	tmp=${migout1}
-	migout1=${migout2}
-	migout2=${tmp}
-	tmp=${migout_fifo1}
-	migout_fifo1=${migout_fifo2}
-	migout_fifo2=${tmp}
-	tmp=${qmp1}
-	qmp1=${qmp2}
-	qmp2=${tmp}
+	tmp=${src_out}
+	src_out=${dst_out}
+	dst_out=${tmp}
+	tmp=${src_outfifo}
+	src_outfifo=${dst_outfifo}
+	dst_outfifo=${tmp}
+	tmp=${src_qmp}
+	src_qmp=${dst_qmp}
+	dst_qmp=${tmp}
 
 	return $ret
 }
@@ -290,8 +292,8 @@ run_panic ()
 	trap "rm -f ${qmp}" RETURN EXIT
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-		-mon chardev=mon1,mode=control -S &
+	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
 	if [ "$panic_event_count" -lt 1 ]; then
-- 
2.42.0


