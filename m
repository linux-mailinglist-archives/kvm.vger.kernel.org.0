Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A37606C4
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 05:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjGYDj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 23:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjGYDjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 23:39:55 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D531712
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-666eec46206so4758862b3a.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690256393; x=1690861193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzLR3F7S7iyxMgTaa6P6CQt1AaDb4dzAxc+FVHI9xRA=;
        b=erRAFX1fS8zUpfwRh8YeNr61s8REwhxloQXoPivU/ap2LYwi0bc9/7gJz3Hc0k3ZoA
         TQ8j17KXzvOR3nXkFeEu3JDOF2cqlHDBr1DuVerxbm4eo9RAEAZKDmcqIJeGXY45yM3q
         4V6wt/jQ2Fd0ZK4SwKngTQcKH8hvLWLVDpieyQcGcNQ9mJeRynP/F6tBUv8oqTPIR2+Z
         apfqyroYU7Q48FPRvpv6eZGd9Js/1iBUQrdh6tCyujeuzCddHsfHtsUcCv9r9LBK5s4z
         kzQDl+XxroabsNTdt4hJVXla+UxX0gt6Qvq/hp+mRePi9kSLq/8YHYp9cTD3vj+NcBfu
         +odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690256393; x=1690861193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzLR3F7S7iyxMgTaa6P6CQt1AaDb4dzAxc+FVHI9xRA=;
        b=b9p0wp1jEHEjRE6hMMnO4FtdFgYOz5cOch6v7vN6yfMb1IIryKte1zgK+xFPaxoYdB
         YlJ34L5KvbjRfnRyUTEi4f2tNF9us5V93qVjzJ45FgMbQ+3BE6Fd18lLnNySHgi1bzag
         OKv8PE+ccd9Edm8SW4qBQVa2YpoAK0WD31r+DLw9z4Uu1rnKehaF5khoxWbpJ9QDJRIa
         TBbicguKIOrRqRg+hFvKFJS4n1QaXXs/DXvBqqJCeMdyRthrI7Z2OKFpjgCnxtdW50nO
         Ou6GTHRDkU4AST/mv1Puyx2Vld9BPM+j7+/INSfbicfArpX/2cfAhK1AlQ8eNf1Pn9QK
         V8fA==
X-Gm-Message-State: ABy/qLbAk+eiKtDgTa5SdLbhhsUhjjyvh7ljR6UDLuYFRJNnkj8eKZuE
        sr8zQXbNtVGYc4ZRu1os6THubOO101I=
X-Google-Smtp-Source: APBJJlEU0cw2IOUsXF7Q5jP28I0sn4FrhiK/VxVjLIiU9EmpLrEAUcy4idCEd9kWLeobwL+X/SoLdg==
X-Received: by 2002:a17:902:cec1:b0:1b8:8dbd:e1a0 with SMTP id d1-20020a170902cec100b001b88dbde1a0mr15345101plg.13.1690256393209;
        Mon, 24 Jul 2023 20:39:53 -0700 (PDT)
Received: from wheely.local0.net ([118.102.104.45])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902c94500b001b809082a69sm9793112pla.235.2023.07.24.20.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 20:39:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if source does not reach migration point
Date:   Tue, 25 Jul 2023 13:39:36 +1000
Message-Id: <20230725033937.277156-3-npiggin@gmail.com>
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

After starting the test, the harness waits polling for "migrate" in the
output. If the test does not print for some reason, the harness hangs.

Test that the pid is still alive while polling to fix this hang.

While here, wait for the full string "Now migrate the VM", which I think
makes it more obvious to read and could avoid an unfortunate collision
with some debugging output in a test case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 518607f4..30e535c7 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -142,6 +142,7 @@ run_migration ()
 
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
+	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -152,7 +153,14 @@ run_migration ()
 	incoming_pid=`jobs -l %+ | awk '{print$2}'`
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
-	while ! grep -q -i "migrate" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+		if ! ps -p ${live_pid} > /dev/null ; then
+			echo "ERROR: Test exit before migration point." >&2
+			echo > ${fifo}
+			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			return 3
+		fi
 		sleep 1
 	done
 
-- 
2.40.1

