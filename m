Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72E175F8AF
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 15:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjGXNkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 09:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjGXNji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 09:39:38 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB44D1BD1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 06:37:37 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bb74752ddbso513600fac.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 06:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690205804; x=1690810604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6wx68ceSLh8Ks0MxsN/kGGoL4STvpKuDm3iHwiSZh+I=;
        b=JNRyTwDsuQwOeGmQMv2TkWrWtBVY7yRvShkB7KcN/RfhXSZ3FCPDvUvFKohBmDRj7Q
         XoWB6gclor3APaveOXsRmXVsFIz8I+z8WJ9AVyTEihFQ80yRsFTh+coVrzEBY2hBehDW
         FVzJaR35+qUzIhl1EDyvcbl0dUnPnhEm40yFG4izfrShj09i49FIyGjtMLUOQVD4IdW6
         EEJd6Wu56pdApT1iBZOFjHFAz2P11pnwpL8xzSvjXcEsclKRLvswhsmkpQsilV2pj2HI
         0vmcZ/G+qU1nytsvCvleGO9LhZ7Rejs1bEPQv4cHonDWJhqP7rO5TPxOJ0ord0MA7tLn
         /YLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690205804; x=1690810604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6wx68ceSLh8Ks0MxsN/kGGoL4STvpKuDm3iHwiSZh+I=;
        b=f+UA4nAgQLDaL5yXtzZ4ohGrJ81mpyYl25cYcafIu89IqKjayacFeRvcCAoChh4riV
         CA1UKJYrNXz0csWRn5gnID/V0m0pnbLp2eyextTcPDNgXAqckYvavOJhq95xOLgD0uGN
         XhStyKxDsNDTNIfVTOlnophs9hQ38HyDlyFjQMDwou6Aw2b/ZHW4yb+rZ6Mz8uJfak7h
         sgUHn1TnlApYjmdHcb8SoOnQqfP+OaYsf7nP0tjl9RMqpIMnFns5rRPqno+oRWeuKQK/
         dHsP5tCEoL2wu8RMLLfbZJ9raNh7xmywN+/n9kWLb7F9uaiy+l+c/QWhyJ79QZe8V/lG
         xOVw==
X-Gm-Message-State: ABy/qLZjJM8WUBhiYshQlXmtJj3bX5qdCcoSCdmEnlzC1er9vHiGNXxA
        QSwn1H0xA/36uq15SS3ZKE1NpW9P+Oc=
X-Google-Smtp-Source: APBJJlG7FjCcvQABc2dPjKLoa5tQ+K4vxm84KdF9nc7rm0P/XXOUAiahv5Y3m54sO3pfH3hg5AKkaQ==
X-Received: by 2002:a05:6871:68e:b0:1b7:2879:a0e with SMTP id l14-20020a056871068e00b001b728790a0emr11360454oao.12.1690205804306;
        Mon, 24 Jul 2023 06:36:44 -0700 (PDT)
Received: from wheely.local0.net ([118.102.104.45])
        by smtp.gmail.com with ESMTPSA id m22-20020aa79016000000b00676bf2d5ab3sm7713474pfo.61.2023.07.24.06.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 06:36:43 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH RFC] arch-run: Support multiple migrations
Date:   Mon, 24 Jul 2023 23:36:30 +1000
Message-Id: <20230724133630.263232-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It could be nice to migrate more than once in a test case. This patch
supports multiple migrations by flipping dest file/socket variables to
source after the migration is complete, ready to start again. Test
cases may now switch to calling migrate() one or more times as needed.

Only problem here is that the migration command now polls for the
"EXIT: STATUS" output line to see if the test is finished or wants
another migration, and x86 doesn't seem to output that line. It does
print something, but only if !no_test_device, so this will break x86.
I'm not sure why the exit status isn't printed in that case. Any ideas?

Thanks,
Nick
---
 lib/migrate.c         |  8 +++---
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 59 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 53 insertions(+), 15 deletions(-)

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
index 5e7e4201..6a0a54f5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -131,28 +131,58 @@ run_migration ()
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 	qmpout1=/dev/null
 	qmpout2=/dev/null
+	migcmdline=$@
 
 	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+	trap 'rm -f ${migout1} ${migout2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
+	eval "$migcmdline" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
+	live_pid=`jobs -l %+ | grep Running | awk '{print$2}'`
 
+	# This starts the first source QEMU in advance of the test reaching the
+	# migration point, since we expect at least one migration. Subsequent
+	# sources are started as the test hits migrate keywords.
+	do_migration || return $?
+
+	while ! grep -q -i "EXIT" < ${migout1} ; do
+		# Wait for EXIT or further migrations
+		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+			sleep 1
+		else
+			do_migration || return $?
+		fi
+	done
+
+	wait $live_pid
+	ret=$?
+
+	while (( $(jobs -r | wc -l) > 0 )); do
+		sleep 0.5
+	done
+
+	return $ret
+}
+
+do_migration ()
+{
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
 	# totally breaks QEMU...
 	mkfifo ${fifo}
-	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
-		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+
+	eval "$migcmdline" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
+		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) | tee ${migout2} &
+	incoming_pid=`jobs -l %+ | grep Running | awk '{print$2}'`
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
-	while ! grep -q -i "migrate" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
 		sleep 1
 	done
 
@@ -172,12 +202,19 @@ run_migration ()
 	done
 	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
 	echo > ${fifo}
-	wait $incoming_pid
-	ret=$?
+	rm ${fifo}
 
-	while (( $(jobs -r | wc -l) > 0 )); do
-		sleep 0.5
-	done
+	wait $live_pid
+	ret=$?
+	live_pid=${incoming_pid}
+
+	# Now flip the variables because dest becomes source
+	tmp=${migout1}
+	migout1=${migout2}
+	migout2=${tmp}
+	tmp=${qmp1}
+	qmp1=${qmp2}
+	qmp2=${tmp}
 
 	return $ret
 }
-- 
2.40.1

