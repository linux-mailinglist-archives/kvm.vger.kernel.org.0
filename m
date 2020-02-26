Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8CD16FB25
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBZJoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:54 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:37947 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgBZJox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:53 -0500
Received: by mail-pj1-f74.google.com with SMTP id 14so1663143pjo.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZriTMGPJdIBl60+ly0kTO53DNTTG646ayUk1xBLJ7Ls=;
        b=CLavvEzEBBBh55R2mU+kQkVXAtm9zE5JBnu8k6n4ANx6ioS7Q9Hqq991Qi4Jpdea80
         7+OH7AIV13iuwO/sl1ARkliD0Ba61LVHe6PmBrj/9fNPndDLvPvfvMhvvpYS+e4q+uWZ
         7YVBCay9Mlv99eKkj1RnY647ey7cy441I7GBG0BdhDU5P7WWhhjubUHY9Awz4tTX4z0k
         Tbo2F44Yn0R5WigHdxSsoEDmYdQGkIRZcDzQoItjOQ2Pk2pj3PkUsRCey8NEFhzGQWEV
         wFgbIxwgr/41aSC5zjHrfZGgxTMNeyFJpBjXrIT+VGV9hKShym1LxC3zM8UMnDqGb6Fe
         njDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZriTMGPJdIBl60+ly0kTO53DNTTG646ayUk1xBLJ7Ls=;
        b=UgyIQMdOj/ESe4ivk5jlkIK682wgshVbCfZVKY6pByviB3PkaCDM77aDqicVmZoR53
         G+UyNdyMKMOJieWkiX9i/MQIfSuuBkI4SoCp0LRO84TOml3wsDHE84Dya1mZme1tWB14
         80vA5o9iLCSKlBnBvsUnsge0o9DKnRwxinHpuGrkAIwjjDGAc7okGvlYQQ6Kh01S6ra5
         UITk/K9/vKf+u05LoQMngRF6KOTXWrygXTr+WGK6jYRrI3isIngM6TyjcTM6b6gyLUid
         ssreaQNOolRcl/sWk3LTvW4IB/tfG8v2oQJMVHaBK/67Ibsgr+6LEZ224H/XQA0uu2k2
         ILzQ==
X-Gm-Message-State: APjAAAX/+QRpdvRlbJ/wyztblopRjPtuqXpQBY1QwETypV5FwhcVqMC6
        DjCB489rOeNpBchclUzemQ7FQ5iKJAnb6pU7P0Itd6p9h4VHX53oT+8u20K1DYuRdG6dtvcxwY4
        cR9QuQYgPajwGLgWkiqz9MQXAV7koEkQxxXJuldwxNidSIlpAiUp1Lw==
X-Google-Smtp-Source: APXvYqz+rTxnSQEQ/WeXDZSmmEWNVYpSKSgj7yQ6H8GbaIW7ibrKP3Cllg1KLwROqGOyi/blfRfcuH5aVg==
X-Received: by 2002:a63:4c66:: with SMTP id m38mr3098817pgl.313.1582710292205;
 Wed, 26 Feb 2020 01:44:52 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:25 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-7-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 3/7] x86: realmode: syscall: add explicit size
 suffix to ambiguous instructions
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang requires explicit size suffixes for potentially ambiguous
instructions:

x86/realmode.c:1647:2: error: ambiguous instructions require an explicit suffix (could be 'cmpb', 'cmpw', or 'cmpl')
        MK_INSN_PERF(perf_memory_load, "cmp $0, (%edi)");
        ^
x86/realmode.c:1591:10: note: expanded from macro 'MK_INSN_PERF'
                      "1:" insn "\n"                            \
                       ^
<inline asm>:8:3: note: instantiated into assembly here
1:cmp $0, (%edi)
  ^

The 'w' and 'l' suffixes generate code that's identical to the gcc
version without them.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 6 +++---
 x86/syscall.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index f5967ef..31f84d0 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1644,7 +1644,7 @@ static void test_perf_memory_load(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_load, "cmp $0, (%edi)");
+	MK_INSN_PERF(perf_memory_load, "cmpw $0, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
@@ -1657,7 +1657,7 @@ static void test_perf_memory_store(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_store, "mov %ax, (%edi)");
+	MK_INSN_PERF(perf_memory_store, "movw %ax, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
@@ -1670,7 +1670,7 @@ static void test_perf_memory_rmw(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_rmw, "add $1, (%edi)");
+	MK_INSN_PERF(perf_memory_rmw, "addw $1, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
diff --git a/x86/syscall.c b/x86/syscall.c
index b4f5ac0..b7e29d6 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -38,7 +38,7 @@ static void handle_db(struct ex_regs *regs)
 
 /* expects desired ring 3 flags in rax */
 asm("syscall32_target:\n"
-    "   cmp $0, code_segment_upon_db(%rip)\n"
+    "   cmpl $0, code_segment_upon_db(%rip)\n"
     "   jne back_to_test\n"
     "   mov %eax,%r11d\n"
     "   sysretl\n");
-- 
2.25.0.265.gbab2e86ba0-goog

