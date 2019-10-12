Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690E9D535D
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 02:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfJLX7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 19:59:11 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:56060 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJLX7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 19:59:10 -0400
Received: by mail-vk1-f201.google.com with SMTP id n79so5333049vkf.22
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 16:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1c3/4XvvM3pptgQ9eG052L3zXWS4WmiadVHCv3Es8bc=;
        b=DEBgRx7nECy/kgccXF+o/TeCJhmrR18KbupJmrm0WeVJ/TgsM8SCpU8g6OW8w8XA99
         9KDxec6AWz82o2WrJEBPqGofAG5TYPA7FDnxjqQLFhX+30alMK+T5gN7Pmehu0fsksoi
         gwN5DVzqYfVa1TpmYDKRVE3C72b/IWLNPWOmsFkwpokWDcdCu+s17cXdXwhiWQmgImjI
         RZ/Jv0OKjCYscLFep5qXuQ2+jgds3ICToa7gAbV/yT3xyFXr9EU+eayANSVoUElI9KBe
         78e3mPZ/CPg7THmXvqPLl47ct/VS8cmW/Py3HhQIqKbTT0tuyCf7ciqdQy7mEOaT/G6n
         n9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1c3/4XvvM3pptgQ9eG052L3zXWS4WmiadVHCv3Es8bc=;
        b=n/fOMZvm7X2QL51uXcxVycNosSsFvM9VgKi0hK2xzkz2EW5GNPO2wu2l3u7yZWsT02
         FFPWK/N9CCp+zQlKQss5S5zo7mdYYMYRFvRVvyNUlMj0A966or6VqGap5vQ+6ghC5iGK
         bULpJcZmUlT5NkaemAuK1heNcN6vwY+WbnRGl/DAmJkRlh2+XqUkHFkggwZ8bJMsvVvc
         vVud4US/YmEc1VK8m1pmTF4V+kqRFaTRretLYQogqVDzZdQI+oIUTUA+h0XQy7JT+X9b
         ibkjBnCBAhkgDVIkXxnzT/rvJxlZsE79HSMYhg59JdgEjzx0o73VYcdjheAuzAgR2W3U
         a/Sg==
X-Gm-Message-State: APjAAAXbX6E2CH4PldmQfl1umutM98kG+mqnRkLUje10HznSDyKEipWZ
        riLlGRASRzduY6e7XKDldZXyWYGHKD6OkqOk96FR3SJJHIaxNVxFiNKQVw0rdzx+p70ENbSmsuw
        L4qbTsOf1Lf+O0SVc3Z9OGrkoX4BtRF5YKq5q5KrDshckBI5b+CQxOQ==
X-Google-Smtp-Source: APXvYqzgv1wPyLSLizxdIHZ6gXAFeEiv6JDREnxmm4i5mbnZR+nBAG9gIMm6LbBpOXg2587kec6psuCdew==
X-Received: by 2002:a67:fe47:: with SMTP id m7mr13628405vsr.100.1570924749963;
 Sat, 12 Oct 2019 16:59:09 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:58:59 -0700
In-Reply-To: <20191012235859.238387-1-morbo@google.com>
Message-Id: <20191012235859.238387-3-morbo@google.com>
Mime-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: realmode: use inline asm to get stack pointer
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's fragile to try to retrieve the stack pointer by taking the address
of a variable on the stack. For instance, clang reserves more stack
space than gcc here, indicating that the variable may not be at the
start of the stack. Instead of relying upon this to work, retrieve the
"%rbp" value, which contains the value of "%rsp" before stack
allocation.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index cf45fd6..7c89dd1 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -518,11 +518,12 @@ extern void retf_imm(void);
 
 static void test_call(void)
 {
-	u32 esp[16];
 	u32 addr;
 
 	inregs = (struct regs){ 0 };
-	inregs.esp = (u32)esp;
+
+	// At this point the original stack pointer is in %ebp.
+	asm volatile ("mov %%ebp, %0" : "=rm"(inregs.esp));
 
 	MK_INSN(call1, "mov $test_function, %eax \n\t"
 		       "call *%eax\n\t");
-- 
2.23.0.700.g56cf767bdb-goog

