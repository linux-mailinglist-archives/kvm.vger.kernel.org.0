Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA874D54DD
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 09:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfJMHSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 03:18:32 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:54864 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbfJMHSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 03:18:31 -0400
Received: by mail-ua1-f73.google.com with SMTP id t16so3322643uae.21
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 00:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+jS/fgeA9g5b7maojEvnHW9C5zu2iR1VcbKtchXrGvo=;
        b=t3ajNdFAPbH26YVnunixwCMh9vPN7BKt9D6YzrtC3ehk7ZhWr/jvbrqDsDRAvud9hf
         kaGdgVDpgjHGN97SH/VxrfXqVae3h6a9Qt0Q2+bqDIz5afycMeGoqq3mUQ/HCrtVT8Bm
         MhDT8SzREjjpRnmF7JE09zhoFOJx7pH0UysOi0qkT1utQefu/BW00y4ZlwVpCEBFqKED
         hkksIT9+F3sYke8BZ5NGSMnTbdm0ouXmKSIXuzKiB6MNpHD/rr/c0ve960+RpQ6txZvd
         go7uLkDbk0206+x8UeeyqOcKliYef/5cbSH0CpK01fEm1oJ7Rk9w6Ip1C1VK7FrXfCzb
         yRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+jS/fgeA9g5b7maojEvnHW9C5zu2iR1VcbKtchXrGvo=;
        b=hLgif0WqANvYo099urrcYgT78OTSJB1djDEpEU30jzEUAMCDnAg3QlNjyYi+P7jBED
         vsuLIO8FjCl63JB7Y/Uuf30YHBmlVhCFyfkh5zLk9+1emczLA1IazHFvuJKD+Iu7xgw1
         i8ehYRcGjgSfWi1JSVSOt8Su1VeJ+ayUEReWIweAcMNiOcUBR2VK49lfjwy2FkDtcxTE
         rR7aHARFyF7f8p5HbcP9mQJZI/wc3UYAzxiay/VGnSzVakbHsglFBS38Z69dvfSgN0fq
         eeMla7cKtlD6d0k7K97OfuEldzCXCBUzsWL+FUTMdt7aBLtZzanT9r1r6omQjmcfvmU2
         t0Pw==
X-Gm-Message-State: APjAAAWgG0ZExFTLdfjQ4q2mCumvDDqMk32B5kGE/hX+GRG8EevLj37w
        aQIBMSjatmc6/hi7SkimZLEisvc3sWmDZ0ERfz3JwYO3NUosCHSgMIsbES/tR5K6NAYNCvYap3d
        zqMfTDU9uyyfoU4neoV/8dlVeoa5BAEoqaYRKnFkfcfoibLfOA5gftw==
X-Google-Smtp-Source: APXvYqynd2e3ep5GXfzDTkYLzLXqia4dttmm50W9SXS9/5bSl3EjdABMtGtRsx3EJHUEQGnMwEd9gqif2g==
X-Received: by 2002:ab0:1644:: with SMTP id l4mr7507361uae.30.1570951110442;
 Sun, 13 Oct 2019 00:18:30 -0700 (PDT)
Date:   Sun, 13 Oct 2019 00:18:24 -0700
In-Reply-To: <20191012074454.208377-2-morbo@google.com>
Message-Id: <20191013071824.222946-1-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-2-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/1] x86: use pointer for end of exception table
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com
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
index 451f504..cfc449f 100644
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
+    for (ex = &exception_table_start; ex != (void*)&exception_table_end; ++ex) {
         if (ex->rip == regs->rip) {
             regs->rip = ex->handler;
             return;
-- 
2.23.0.700.g56cf767bdb-goog

