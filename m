Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E63518B80
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiECRxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240642AbiECRxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:53:37 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB92B29813
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:50:04 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id f5so10208174ilj.13
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gw+un10uJqUNP/SbL+e25B/lzjHm7kiGfOYsGY9F7XM=;
        b=IQ5l1Tw0QCU5PbCxVcnsc+tTDYVs0hkTHeCetz8NmOg+tc+WmC7hJ9Db1EH0ffn3vt
         lWg5GdxzYnone+VZISJSZcdXLdgw+/rkq0ScHAzuDlP8aaHL8YJrpDCusQSa2CwLTYVQ
         5kiLmnnxp6CBthc47Q1I3FP1g2FAl3KmjJcy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gw+un10uJqUNP/SbL+e25B/lzjHm7kiGfOYsGY9F7XM=;
        b=wjSW8EKPxRv3+8EDS+f2TdzmUFMJtfqo2/rK5yx68fj3aO2I0mv6lLFQSqZz80w46e
         uSg04LBTjEs8A88j+gf/jCUU5CfpGMRWeJViSzgl+C9M9A1uNS3OHIM0esrgmGTXICb1
         0CnUGe0nUp+WCmT4lrerY6zRDfUCmqYGbISj46+Tf9KFqdKc0B9GrT1ms8+UwXGsJ3M9
         C5vhm4znvUTCH54RwbAq5z1u+KODzl8XeLMII9WW1PFGWrmJA6fE/gEQbyFoH4cDlzyU
         j/XSlzuQO9/9FvRdYLjBH6n8VLh9zv7ss4ao+yX7ClpXTl0SOlFSYowzn8isfB5DhNzR
         65Bw==
X-Gm-Message-State: AOAM532q6OShwZi3qVAQc5fms9ZHYovkCUiApgM+Vd/N5MEtm031qxWU
        FuZXIDzQ0S++8fBEA13jpmBirLw62eEwgc1f
X-Google-Smtp-Source: ABdhPJzh+zb6aoHIl3yp5z+2hS5YP62Z1ngPLTw5+X3w+daEd6SSNy6hBReYVKdBs4/XoKgoLBqttA==
X-Received: by 2002:a05:6e02:20e4:b0:2cc:4535:9d22 with SMTP id q4-20020a056e0220e400b002cc45359d22mr7443763ilv.195.1651600203864;
        Tue, 03 May 2022 10:50:03 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:80d8:f53c:c84d:deaa])
        by smtp.gmail.com with ESMTPSA id u6-20020a02aa86000000b0032b3a78176dsm4049997jai.49.2022.05.03.10.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:49:48 -0700 (PDT)
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a livepatch is pending
Date:   Tue,  3 May 2022 12:49:34 -0500
Message-Id: <20220503174934.2641605-1-sforshee@digitalocean.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A task can be livepatched only when it is sleeping or it exits to
userspace. This may happen infrequently for a heavily loaded vCPU task,
leading to livepatch transition failures.

Fake signals will be sent to tasks which fail patching via stack
checking. This will cause running vCPU tasks to exit guest mode, but
since no signal is pending they return to guest execution without
exiting to userspace. Fix this by treating a pending livepatch migration
like a pending signal, exiting to userspace with EINTR. This allows the
task to be patched, and userspace should re-excecute KVM_RUN to resume
guest execution.

In my testing, systems where livepatching would timeout after 60 seconds
were able to load livepatches within a couple of seconds with this
change.

Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
Changes in v2:
 - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
 - Reworded commit message and comments to avoid confusion around the
   term "migrate"

 include/linux/entry-kvm.h | 4 ++--
 kernel/entry/kvm.c        | 7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 6813171afccb..bf79e4cbb5a2 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -17,8 +17,8 @@
 #endif
 
 #define XFER_TO_GUEST_MODE_WORK						\
-	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
-	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
+	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
+	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
 
 struct kvm_vcpu;
 
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..98439dfaa1a0 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 				task_work_run();
 		}
 
-		if (ti_work & _TIF_SIGPENDING) {
+		/*
+		 * When a livepatch is pending, force an exit to userspace
+		 * as though a signal is pending to allow the task to be
+		 * patched.
+		 */
+		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
-- 
2.32.0

