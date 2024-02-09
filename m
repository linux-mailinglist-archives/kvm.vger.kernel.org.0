Return-Path: <kvm+bounces-8419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA0484F20B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 770671F26972
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875AB664CB;
	Fri,  9 Feb 2024 09:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7xeAvSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF1664C6;
	Fri,  9 Feb 2024 09:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469944; cv=none; b=kCyAntGzSMkITwKCW8KUnpbSxsGJ7mblWFF9gbaxGgvZCnAxE85+53enhrE09gwpp331RvioVTX+ZqFPfGALL998enmu9nbbiw4pxYgGXwmb8MmP8XtGU9TQPRCqxyTsTM4ovISXbKo5Z13TOLX7xe4sFRU+xkCzyZ+GI7H24zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469944; c=relaxed/simple;
	bh=hFQmAXGuXJzsU+D6+fezDb5bPNLYd+sNQribc7Q6YxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+yCIeKdOg0gpS4VS7PcTz9a5TH7QxiZy/PdUOJmU6mUJ0tOivqxoBRXWXBJM7KPkHfKQgH4JQNfA8idegpPxLsWmOYM9uxt0aGVv62MX4um8qTN3Ph3Xe9R0o6vCVh3q67mbh7+uOvftiJJMoPY7uW4vse/sPVZrww3iBwbq4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7xeAvSD; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3bbb4806f67so451503b6e.3;
        Fri, 09 Feb 2024 01:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469942; x=1708074742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4s6FdHef7vHJmaayGa/KenEMFLkhsTB2Fe0/1F6SbM=;
        b=Z7xeAvSDJkrttKIlB85D3aTzrdzXXwo3/bpnExbO3d/sMbJhsR7vcZZr4GtZTwqIEi
         CfdTZhkfB2fOxDZfPTfw1EiHFZPb3wmqVI9HhfgxF4qRRrS8JWRFZK5Y6HOfCBYS3RnD
         BCrkbG/ez2iJEFs6eeh6XwdOYCp91/s80yn7iJO2LpGjvqN+l6KM0bbQgQz9gWziWu8K
         jUyo+CHgwOi6/86+Bd0gVAT85J+KREt5PgBWPkqypYZukRLCOwkXMJHtny2hBA/LlYR5
         Xw+rgWC6Li5ivoweJk5NgtPlXnuXCBzACFYfAUEQHiKXbyc+GbXLuja453HNpP0xJRWq
         zwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469942; x=1708074742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4s6FdHef7vHJmaayGa/KenEMFLkhsTB2Fe0/1F6SbM=;
        b=Wchhnft+ifYfgsekvJx/MBRjvQn+uflb5LX5k3qYvnckWNyv8N6h+/s4o3LHl5nti+
         gAAdwrLGmSImGOPHsVDJIwf4r1Bgg55uYe8XlmpliFE6A/8r2Iad6t8lKvKjgHn1bUMW
         DZVzwY7a8ntlmOHTeoWjbMlHYTrRRGzdAVOqDEMsxM2JCF8qpDlfrqiwgbfI1XuQdI7P
         k6DYry9op4Dp2e9J5JNL6VUvSrSTu4AE2+/cllss3SsLR8WPLtc7Be900xoB7llKW1IU
         ZTHsZEnopp4G/X7djaY8jOPGE/gp/S0AzqoA2sCFpQylt5IibtkpiJILDToEw7h9EpF9
         Pt2w==
X-Forwarded-Encrypted: i=1; AJvYcCV8E15gzNLgweCnCw2LCznqNHdj2ffCloYJiXEcp3UPvr/SlfyzC+5MQDXG6gLdwF4GALtQ63ktyucUA5Zel8+kzF9Et+V1wfisUp31JmVEtbG6h3W3ap6FLbMWWMJxZA==
X-Gm-Message-State: AOJu0YwXFDger/j9z7+UfAPF4n1cztw9EXCNbRPzMD5a7Y4wvnUlWEDy
	Tvq9Fa/w7R5QNWwlRJ6XkPvk+Y+BaTsgqYInd/zco5C1Jio1/6iS
X-Google-Smtp-Source: AGHT+IHzygceGEjkPjUx0xiCajopPxJC7oryA1WqG+A/YiVXTpAlz8lhX39kYbGZTCk+iygcpAOZSw==
X-Received: by 2002:a05:6871:888:b0:210:b468:6a5d with SMTP id r8-20020a056871088800b00210b4686a5dmr982709oaq.16.1707469942286;
        Fri, 09 Feb 2024 01:12:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKIzIOsROoCCo0GMYrwniUaZ4ECGCXrpd7nSeCWNDa7srXa24kJgicmOyaUEtvuC5H7ZuHqBX5XyVdmtQMrrH9+TJka+KvnEJG9BWBrL9jZQ9qVBJCOx5XZrM5C9NJtyoub16ywUB116Nk8aLVO+1LoLpqVZinTA8vznJM/LHt3o8kjpKjABgq7JhubrCdpM3DG05g7uzZ7yQni1/ln6w8NNVGWnCGmX7uvKUncNnqFbjEeNi/i6hKLl7wD729SMiITlNt9nEFJX4IE94OHsj1NLNXoSBdiw2cMGvcqi2nHWFgpkZY0CG5WqxtfYVyJsIXGqWfV9H2YaAy2HJpU1N74m8fRiRRtqukEbUw1p/bx9avPGME1U3BMu7ukU6Vf/yXwzquYMae78uUG6nTwxozOB7rddS+71+Y+YtIkx2xPOrMbnce7EtAi9OFs7SiwqpH7Nt948WvbtxL4qkPmOYQ80srRVLRA4io+LPSffMsLiN/N6vz7R96DH7+B8gSNPc7iS98UUCpxXl6HIqB8JsDqN7lU0+gL+vYk0mj9WvT2GerrLzpQxi4
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:21 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 5/8] arch-run: rename migration variables
Date: Fri,  9 Feb 2024 19:11:31 +1000
Message-ID: <20240209091134.600228-6-npiggin@gmail.com>
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

Using 1 and 2 for source and destination is confusing, particularly
now with multiple migrations that flip between them. Do a rename
pass to 'src' and 'dst' to tidy things up.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 111 +++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 55 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c2002d7a..c98429e8 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -132,27 +132,27 @@ run_migration ()
 	migcmdline=$@
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
-	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
-	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
-	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
-	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
-	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
-	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
-	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
-	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
-	qmpout1=/dev/null
-	qmpout2=/dev/null
-
-	mkfifo ${migout_fifo1}
-	mkfifo ${migout_fifo2}
+	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${dst_infifo}' RETURN EXIT
+
+	dst_incoming=$(mktemp -u -t mig-helper-socket-incoming.XXXXXXXXXX)
+	src_out=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	src_outfifo=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	dst_out=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	dst_outfifo=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
+	src_qmp=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
+	dst_qmp=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
+	dst_infifo=$(mktemp -u -t mig-helper-fifo-stdin.XXXXXXXXXX)
+	src_qmpout=/dev/null
+	dst_qmpout=/dev/null
+
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
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -162,7 +162,7 @@ run_migration ()
 
 	while ps -p ${live_pid} > /dev/null ; do
 		# Wait for test exit or further migration messages.
-		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+		if ! grep -q -i "Now migrate the VM" < ${src_out} ; then
 			sleep 0.1
 		else
 			do_migration || return $?
@@ -184,80 +184,81 @@ do_migration ()
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
 
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
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
@@ -280,8 +281,8 @@ run_panic ()
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-		-mon chardev=mon1,mode=control -S &
+	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
 	if [ "$panic_event_count" -lt 1 ]; then
-- 
2.42.0


