Return-Path: <kvm+bounces-12077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B71F687F89D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99D831C21997
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 07:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFE253814;
	Tue, 19 Mar 2024 07:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THqp6odh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682A1E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835181; cv=none; b=iyKf6FfwYphK+MofAIFlFnmGV6twN5UsmcfkWXESUsyy3Yn7NMPduOOoQ8O9dyTuZ27Dw/btIdpPdUjUbSUw3P82m4m+r9g2AX5MT6tthK1/qfoHZVo6BrEhWo19HBPm7on+9q2/aVcq1H2dZ7U18yqHJgqMuYIos0rPsV+ulbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835181; c=relaxed/simple;
	bh=2cTIX4lBhrOsxzeX5S3KmsoVe4EWR8BsJpBD4F6Ksmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToBnAJ15YjtIpGoCEAbENvtuEVJzWoosBjdPbn+/MNBSjzQOg6CUIeIxhfetQ4HQYVG5Q3CQjlbzIsDsn2nKjqs9HBvmax8/sNj70rCvs6Arhe6pC0cT9ExMW+MX9EFm52igu7QvWb28qP4DwfpjJxptDFUPMGLlsoSv+QSi9eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THqp6odh; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so30708b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 00:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835179; x=1711439979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MV1GkDUYdGk6FpqIRujPCzrSPB/odnEVLVEaqpwb+zI=;
        b=THqp6odh5sJa3t0Kym4qf8WDb+xtMTEbnmhiMowCh8QGKfhg7tlu5l+oRibEWSvE7k
         hcNrOz2LuBVbZRo4MrDdV8G45Kdv6AiR+sNOCw1ieGvz0k0f6+Pjx1PAh3S+CskfVjj6
         JpXKvFcJOKusnF57N6wF0roOE52jt60y1MIEDfO0MGg4TMENbgW0sb19PNTBfyZf9Nd4
         i6COp9iKgAJZlxAh/oCpUK42jJJqnaldgpf9X5vab6Bi+JhD+yKNdu7XET3d6/XWTzk5
         77FCcVRLM56w2Yjd840A/YSfdYkri5/dQVwFu8trCS9kiXPbVXBrXNhgtMoJsmNZRd6F
         Wf2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835179; x=1711439979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MV1GkDUYdGk6FpqIRujPCzrSPB/odnEVLVEaqpwb+zI=;
        b=nGRa5nAtxzMMJ4nSoBLf4brq1z4+qkCVLOC6jtNB6Fw03453E/CBTAOjm7xTOxw4lA
         f2Rf5QSUQEF+EqLPK0BWotA0LtZecgAYFUEnl+o5QF2mLbNZ0zGEd263m7H5UHPQ2Cg5
         c8h/1fl2aCFP4DBX2Adpf2NCCfwtICPopq/2fRylbdu6uSWFKBl1XKZKI4cQzk3OUIZu
         T7E7rw2aPRc9WhuT9KWx7ld0/ixI6sJrIGjTxly7kPm8GLKkKZrZC90PjRQG2ecffcYB
         cQ2bO5dE8BHcnUyjlX/25UD8xb2P037ejPfJehakDFJuFDBpUrEzzdbroORR0gM3NOLt
         QQTw==
X-Forwarded-Encrypted: i=1; AJvYcCVHsUyy7V4mLKh6PQdh2kyRcf7cf9SBl7sIn69E5FpQGjCxpi1qO+dB9IOdHKsKJUvnLfdRrvmzMjTXbO9SK/XmwVFq
X-Gm-Message-State: AOJu0YwidF2XvHx2RPl0Xjob7cfC3EFI4bmr8oB7suHTC6JxmtYCVLdO
	AwjVkggMGqF0MNaJshUVMDw/9j8DKl0WwbxKxj/M4zhBs/+ALrPp
X-Google-Smtp-Source: AGHT+IHeL4fHra/9GDTXS1doTdE3e+vFe2XbaH0TFQXn1QEOJgVJ8PGJhTMXeVyepFJKOTtmHxwhkg==
X-Received: by 2002:a05:6a00:3d10:b0:6e7:2dd1:6e7d with SMTP id lo16-20020a056a003d1000b006e72dd16e7dmr2352807pfb.18.1710835179082;
        Tue, 19 Mar 2024 00:59:39 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.00.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 00:59:38 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 01/35] arch-run: Add functions to help handle migration directives from test
Date: Tue, 19 Mar 2024 17:58:52 +1000
Message-ID: <20240319075926.2422707-2-npiggin@gmail.com>
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

The migration harness will be expanded to deal with more commands
from the test, moving these checks into functions helps keep things
managable.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 413f3eda8..e34d784c0 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -122,6 +122,16 @@ qmp_events ()
 		jq -c 'select(has("event"))'
 }
 
+filter_quiet_msgs ()
+{
+	grep -v "Now migrate the VM (quiet)"
+}
+
+seen_migrate_msg ()
+{
+	grep -q -e "Now migrate the VM" < $1
+}
+
 run_migration ()
 {
 	if ! command -v ncat >/dev/null 2>&1; then
@@ -152,7 +162,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
+	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -162,7 +172,7 @@ run_migration ()
 
 	while ps -p ${live_pid} > /dev/null ; do
 		# Wait for test exit or further migration messages.
-		if ! grep -q -i "Now migrate the VM" < ${src_out} ; then
+		if ! seen_migrate_msg ${src_out} ;  then
 			sleep 0.1
 		else
 			do_migration || return $?
@@ -190,11 +200,11 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
+	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
 	# The test must prompt the user to migrate, so wait for the
-	# "Now migrate VM" console message.
-	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
+	# "Now migrate VM" or similar console message.
+	while ! seen_migrate_msg ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
 			echo > ${dst_infifo}
-- 
2.42.0


