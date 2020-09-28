Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD9C27B39F
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgI1RuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgI1RuT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:19 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rbk1bd/7lqywfI5yBzrlH96ni1KcOagDbEDVefpwTVo=;
        b=U78fSbMi/mCLZuWk8rtupbGQcuCz2zaEitcvpMWvUy8lkfLVesiOZxodHl8S3iJQtCh8Zq
        +O5o702ts2yt4zIa3pOup/ZxqAnqgBw5veuoWsd82C7g/pllnrPZiE8Dg8025W6ShqDiL+
        byTgC8BJTeaCsvIuzAYFwFCJ4gqoYzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-Iq5dPd32Pvqd-bZ8KBVZWQ-1; Mon, 28 Sep 2020 13:50:15 -0400
X-MC-Unique: Iq5dPd32Pvqd-bZ8KBVZWQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F21188C137;
        Mon, 28 Sep 2020 17:50:14 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4309E10013C0;
        Mon, 28 Sep 2020 17:50:12 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 06/11] common.bash: run `cmd` only if a test case was found
Date:   Mon, 28 Sep 2020 19:49:53 +0200
Message-Id: <20200928174958.26690-7-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

It's only useful to run `cmd` in `for_each_unittest` if a test case
was found. This change allows us to remove the guards from the
functions `run_task` and `mkstandalone`.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200923134758.19354-2-mhartmay@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 run_tests.sh            | 3 ---
 scripts/common.bash     | 8 ++++++--
 scripts/mkstandalone.sh | 4 ----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index d7cad9b..65108e7 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -136,9 +136,6 @@ RUNTIME_log_stdout () {
 function run_task()
 {
 	local testname="$1"
-	if [ -z "$testname" ]; then
-		return
-	fi
 
 	while (( $(jobs | wc -l) == $unittest_run_queues )); do
 		# wait for any background test to finish
diff --git a/scripts/common.bash b/scripts/common.bash
index 9a6ebbd..96655c9 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -17,7 +17,9 @@ function for_each_unittest()
 
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
-			"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			if [ -n "${testname}" ]; then
+				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
 			kernel=""
@@ -45,6 +47,8 @@ function for_each_unittest()
 			timeout=${BASH_REMATCH[1]}
 		fi
 	done
-	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	if [ -n "${testname}" ]; then
+		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	fi
 	exec {fd}<&-
 }
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 9d506cc..cefdec3 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -83,10 +83,6 @@ function mkstandalone()
 {
 	local testname="$1"
 
-	if [ -z "$testname" ]; then
-		return
-	fi
-
 	if [ -n "$one_testname" ] && [ "$testname" != "$one_testname" ]; then
 		return
 	fi
-- 
2.18.2

