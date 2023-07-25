Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB17B7606C5
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 05:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjGYDkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 23:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjGYDj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 23:39:58 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C953173D
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bb775625e2so19994055ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690256396; x=1690861196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McUqq8F18rjKUkfgDDmWRJciO+eOkScPdFBftk4eTRU=;
        b=cPEEBbSJRcPurMMaZ88qjs2nRnjd8rpkZzHjPwOqBd7MuUcYXHXl3uK+WMDecIvYDy
         lv4RGB1z9jToLOw2agxgQWJzQK9xVsDQNJ2trhAAWMcRW1nZMKkQxgM/OwKdh594Nq5P
         qGbvxVMJcnMM5DJOn1X6uv/OeD7FSev/dIavmNnWQkzTnZO4dMXuVjYXX9ssYTEqo3+Q
         jQ0m5rwjrsIO4pVlu1VYvVk3wJBXhRoO4GtqLqpbvhTN08Pd/uQkSgjrgZAstX4x0gA+
         +gkZ4rjsy4z2CO56Ef6L1LT/hf9lX6khM0N0Xq+g1ZNi/crl7KvJG8xb+ZJhvfGaihz4
         qp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690256396; x=1690861196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McUqq8F18rjKUkfgDDmWRJciO+eOkScPdFBftk4eTRU=;
        b=JSCCmRCNMV0Aw/HY7S8SmYWThrJKT63DBmxfEoaKQNuoXVkV2zh0SR2WjReOhnSoCL
         5K8e5DvIjGGHco1HVi+5gnohBukHWm5F43suW29Dol3PAlBDzTw1J5JAXxkVCUusbxSw
         iABixaMSvkzVKShY6ojloP00xxU8bG48N1txo3xY7SZOlJapBHm8u1Cpar4tNmlfStMi
         IoYsmrB6YkwnJNSq+/hiMwGoNsRzZZuyELdfnTfRH3A2dXG9g3+Y4A8ADmZ+jrn2cEMi
         EO5jXp2CVJHC9VTK2BB1MQDGNu0ytJkSOLT3fJm7+FsdwHe31f91x6IwEAxcz1kTeasv
         yr0Q==
X-Gm-Message-State: ABy/qLYHRgWi50KbFnC/L1yadpv84rmNFynzkXR9K/En7riaRVQI9idr
        yLPBN1yoo7x7XH71vWuHUTq7+HcLaeA=
X-Google-Smtp-Source: APBJJlHXTVB3ZRTnKN9wcNbUwiYwM3sCLFgNSDI/W9i4+CSkZEYJ2lJn8aE47V2/KEWGSiQMegzH8A==
X-Received: by 2002:a17:902:ced0:b0:1b8:3936:7b64 with SMTP id d16-20020a170902ced000b001b839367b64mr1690700plg.1.1690256396158;
        Mon, 24 Jul 2023 20:39:56 -0700 (PDT)
Received: from wheely.local0.net ([118.102.104.45])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902c94500b001b809082a69sm9793112pla.235.2023.07.24.20.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 20:39:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 3/3] arch-run: Support multiple migrations
Date:   Tue, 25 Jul 2023 13:39:37 +1000
Message-Id: <20230725033937.277156-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230725033937.277156-1-npiggin@gmail.com>
References: <20230725033937.277156-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support multiple migrations by flipping dest file/socket variables to
source after the migration is complete, ready to start again. A new
destination is created if the test outputs the migrate line again.
Test cases may now switch to calling migrate() one or more times.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         |  8 +++----
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 54 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 13 deletions(-)

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
index 30e535c7..e3155104 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -131,26 +131,55 @@ run_migration ()
 
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
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
 
+	# This starts the first source QEMU in advance of the test reaching the
+	# migration point, since we expect at least one migration. Subsequent
+	# sources are started as the test hits migrate keywords.
+	do_migration || return $?
+
+	while ps -p ${live_pid} > /dev/null ; do
+		# Wait for EXIT or further migrations
+		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+			sleep 0.5
+		else
+			do_migration || return $?
+		fi
+	done
+
+	wait ${live_pid}
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
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -181,12 +210,19 @@ run_migration ()
 	done
 	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
 	echo > ${fifo}
-	wait $incoming_pid
+	rm ${fifo}
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
+	tmp=${qmp1}
+	qmp1=${qmp2}
+	qmp2=${tmp}
 
 	return $ret
 }
-- 
2.40.1

