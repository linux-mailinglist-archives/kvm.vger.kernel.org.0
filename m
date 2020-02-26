Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1576216F8B0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBZHo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:44:59 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:36871 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgBZHo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:44:58 -0500
Received: by mail-pl1-f201.google.com with SMTP id t12so1409182plo.4
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v0kAimqMmAthsdANDZDbLgds4YdFM+K+E13QIetrdbM=;
        b=cIZI/OzmBenIvKEfOgu5v9GuZKjhj0W7tXibySmLIK0kxwNxmm11dDO5LZ+zoSNCNC
         koLMIthzvo6MrgoGc1Sj5pQabViVGdweIhohtdgd+u/TAzv4hMsSeUWf9zEJ5OZBdLLf
         thdQpoHNT7Nqctpr8ECTxwD10RnSp6DJiUs51mWrpHDggnrkmNW7VX1UN3XRn/L3rHBN
         6fuTb/TjtpUrEwWHkvm0x/DYTYNZf9V1XkaEucYuz3sl1YLEVPfAkvuEq/V5uMNQNqUy
         OLS9Gl28rNFi02AHCd2sa81MzcIO+gqhDoDg8FjbPZhS3vY5RTccrP0VmDikwW4U3sdG
         MGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v0kAimqMmAthsdANDZDbLgds4YdFM+K+E13QIetrdbM=;
        b=NmYe5NmbSC9bf+qiUGbBdiRquGhECeDzqWi+mz/GSHVrfwh7Hw3LgCIgduGWL6Gol+
         ZBIxNHrK9oa9iE0zOr4a8mzTjKltk9T36dlHryEvjYhA1Y+n0FUvz2kPYm9MygUWybJv
         XBykPm8y/gMDU/RsfDpR69BiURq0LkpD9RdB5xaQnsh0sXb9fNJx5shLY2egjVBYxdMu
         dgiFGKUKqsYuY5AYtz7jffXi64ZMl+S7xKiB+aIkGMRkMOXSXCgVfoAfxJoQ4NlaSLSs
         o7uTd6gs8asilJdTG32gE3KKsAEssqQeXXqzR9JJH8zMd2/6w1Rz0i5Fmgo3Ds6TSoiU
         KgMw==
X-Gm-Message-State: APjAAAWxpF6XED1rqAiz/4oXL0vm+PnayvqgFi2jupnOKeppaHG3h2sv
        wUMw52vMw26E8xqMNEg/CjJbRxkYODf3kOprT6vAnRxUDXl4j7j7IIxtBXvT4CYdhaOPNjuZrj0
        cqyjO6pMGeqYKASdUXtYgz34Tx3qhxGswebDaDJZbDdzl0b5iHKlu1Q==
X-Google-Smtp-Source: APXvYqzy8ZpIwcAB1hYmYxTBKjYDuBodQVRA8fiBO589/S5pjHtr8WOVH6+TpF15OaNl8N2F262Caw79TQ==
X-Received: by 2002:a63:4b07:: with SMTP id y7mr2528703pga.272.1582703096932;
 Tue, 25 Feb 2020 23:44:56 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:23 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-4-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 3/7] x86: realmode: syscall: add explicit size
 suffix to ambiguous instructions
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

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

