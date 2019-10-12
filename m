Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AEDD4E19
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 09:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfJLHpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 03:45:06 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56902 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbfJLHpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 03:45:06 -0400
Received: by mail-pf1-f202.google.com with SMTP id b17so9226524pfo.23
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 00:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5O5gglNth+YtyDFdYw1NFlZ4gHrm+Unlxufs87AIcww=;
        b=Z8JGy3ioDaYFTJH2IczyUodRM519pG2NGsWauK6fXwmbNLcKafuBgObe/O0mSnxWs+
         tq82kwySNpLyIpoZnWBOoPqqvG714Shjo5zcYOy0B54MVMKtV0hIRw1dM3ELfHC8CKal
         d10J+MHo7kA2EdCbiJIQB0gySfq1dSlGVj32/kZ4VP+YuzJK4xayuq14TgMiTDDPxmq+
         bssNcr/V/YB/jtyPBmAcrWPX1qg4SAle6c1DcnL5qzNpLNku6U5PUvoyqcU2LlWVfIB6
         QO5MHJaczGd+kmNfqC9ONe6pqRW8YZAEC5+Lg2c85BzLqL2ANWHWT8Axwp+PrPdqgz4C
         eWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5O5gglNth+YtyDFdYw1NFlZ4gHrm+Unlxufs87AIcww=;
        b=Zmu34hdNDTm206Q9seBCwml78lWpJOmT5KNXoUsX1QJ/xylfSp6AmcteWAZjtqoAiK
         wMfHSftHgWNwh/QZ2eO2r+xRWoFKx1VTg1rpsGtmZ5m0uABD5c1E8/pRR4RKrGRU2Apc
         Kr7OCvTVWQSek9fCRW5lZumQfW+8mhDbk62u1ygFd4ugW4PWi59ch60DCszEHXyxMePC
         Wot3yeML8bUfffHbcDdCMBzq2w3mBMfHK2Mk8+q+9QlWhvTw6g4UG10PAXGBbsl7hDt1
         ZvVRHLSXY0mxDVqKhKzdo6muvMhifvjw9me1P1gtaW+p2MNRQ+hiwT463/BCiVwmV0AU
         TnJw==
X-Gm-Message-State: APjAAAUugxFAm+/MEntTmB2/dZYqDG0WRIqn+IVqceUAxgxvRtqZwoqc
        52AJKAhy2KS2HiLSLvBEvRICj9Z6QCB+kcBBjh9eJQ83QmH0SFty20u0rQkhdDtvUXW9wxlI7uL
        OpzGnaOW4lgsALga4mbYM8ulDUNEORp5vn6SLR9ZkV1laxNo1r+MSug==
X-Google-Smtp-Source: APXvYqx4oDHlhcobr8xsZ46aq+eTWvtZY+HgW91BpvtnNTr6HSfZZQGXag25pJYpBGxJygnvWwu1M54HEw==
X-Received: by 2002:a63:c80a:: with SMTP id z10mr20986388pgg.290.1570866303860;
 Sat, 12 Oct 2019 00:45:03 -0700 (PDT)
Date:   Sat, 12 Oct 2019 00:44:54 -0700
In-Reply-To: <20191012074454.208377-1-morbo@google.com>
Message-Id: <20191012074454.208377-2-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: use pointer for end of exception table
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two global objects can't have the same address in C. Clang uses this
fact to omit the check on the first iteration of the loop in
check_exception_table.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/x86/desc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..bfe8651 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -41,7 +41,7 @@ struct ex_record {
     unsigned long handler;
 };
 
-extern struct ex_record exception_table_start, exception_table_end;
+extern struct ex_record exception_table_start, *exception_table_end;
 
 static const char* exception_mnemonic(int vector)
 {
@@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
 		(((regs->rflags >> 16) & 1) << 8);
     asm("mov %0, %%gs:4" : : "r"(ex_val));
 
-    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+    for (ex = &exception_table_start; ex != exception_table_end; ++ex) {
         if (ex->rip == regs->rip) {
             regs->rip = ex->handler;
             return;
-- 
2.23.0.700.g56cf767bdb-goog

