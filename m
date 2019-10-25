Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C675E51D7
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 19:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409574AbfJYRBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 13:01:33 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33741 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407149AbfJYRB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 13:01:27 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so2384062pfn.0
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a6D0LvDSWvcPBISgGIo9u1LrVZKZJkW1is0FU9Md0OY=;
        b=HvfRaXXBnGrJSskwO0aa3yK7r+fVk0GhnUvg8UuwljtMvXv/KUagkTPmoVgEVUkq9Q
         sRYAcnWBSCQkCNI4xtJsuZ47zKbDmg+Ql2+80FxQjKqH1gDRubxox973Olwc0pzVWeOc
         4hfk0I+7tw7P+JyaINX52bPHkJRjzvaQZiG5pz6Sza/ZzR/l+/h8twyra8ntCwfu0Ai6
         wbK7aOTcLUZUTYPLQVsYMi63Z3Y2L4Z31NBSwo3UJNzELEpy0FOXP+Kl/mfl8oQqaEPQ
         XaBOtjkeW04gFuxGfUxC3LWNTFaGGspYJM6BavaDn6ssdpW0CRra8zrI7Dob2/HVLFpf
         E/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a6D0LvDSWvcPBISgGIo9u1LrVZKZJkW1is0FU9Md0OY=;
        b=rxpKOy1r6R4aTb4PSDBOMkVoIB4VJuTsqppusIg4ExfTzlr7T4Efng/IOO+qBMValT
         NVqEOwalwzW/AkOOz+LoIbfSaFfoM86Ke/Y7IyyTYVmVGddHrf+ZC0LB1O/Zuh6ZIPVn
         P3nibn7VSsOXmXcN87Ibvt1diSa5LAgyJpRjvM7qPTZtvK28uCiyM2mGxDGnFDzyjuDD
         Bst4fCpEJTfClyDlhlRer7FyiXojutQx5lp7XAngqVa2vvCVMVf+MssAAT9tlWH9BH7Y
         OEnzJX/s/RDz7i/NWxEJfLnrskR2Q9FOFcpCVUiX1X77fqFc0zNUl0b8ZY4IBzilM9jg
         p/fQ==
X-Gm-Message-State: APjAAAWb6MXq1Io+EvQu2EsMYpPZMKOXlXgVZjtve+E+jgSIu9Y0Yxto
        xroaTpcpzh53VsVPlJve5o4qG3yjoXZC2GIs9g0RNsDfkXuqvUZsn1M5uPFGJLoH80WFSmn8plU
        YU4idGGT8Ox25El7SzDOLADbaqcEDOfmIySTdN7SL8d26uGahXLMDOIKzHHj+NV7M/dQe
X-Google-Smtp-Source: APXvYqzM+PZUsiUM0XEyTdAz47yojmWnA/U//ZUx038MVrVrkkLbzob+ZLq40EC7C0Er45FGIR1DW5A0X5YxwzuU
X-Received: by 2002:a63:28f:: with SMTP id 137mr2506003pgc.301.1572022886509;
 Fri, 25 Oct 2019 10:01:26 -0700 (PDT)
Date:   Fri, 25 Oct 2019 10:00:57 -0700
Message-Id: <20191025170056.109755-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [kvm-unit-tests PATCH] x86: Fix the register order to match struct regs
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the order the registers show up in SAVE_GPR and SAVE_GPR_C to ensure
the correct registers get the correct values.  Previously, the registers
were being written to (and read from) the wrong fields.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 8496be7..8527997 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -492,9 +492,9 @@ enum vm_instruction_error_number {
 
 #define SAVE_GPR				\
 	"xchg %rax, regs\n\t"			\
-	"xchg %rbx, regs+0x8\n\t"		\
-	"xchg %rcx, regs+0x10\n\t"		\
-	"xchg %rdx, regs+0x18\n\t"		\
+	"xchg %rcx, regs+0x8\n\t"		\
+	"xchg %rdx, regs+0x10\n\t"		\
+	"xchg %rbx, regs+0x18\n\t"		\
 	"xchg %rbp, regs+0x28\n\t"		\
 	"xchg %rsi, regs+0x30\n\t"		\
 	"xchg %rdi, regs+0x38\n\t"		\
@@ -511,9 +511,9 @@ enum vm_instruction_error_number {
 
 #define SAVE_GPR_C				\
 	"xchg %%rax, regs\n\t"			\
-	"xchg %%rbx, regs+0x8\n\t"		\
-	"xchg %%rcx, regs+0x10\n\t"		\
-	"xchg %%rdx, regs+0x18\n\t"		\
+	"xchg %%rcx, regs+0x8\n\t"		\
+	"xchg %%rdx, regs+0x10\n\t"		\
+	"xchg %%rbx, regs+0x18\n\t"		\
 	"xchg %%rbp, regs+0x28\n\t"		\
 	"xchg %%rsi, regs+0x30\n\t"		\
 	"xchg %%rdi, regs+0x38\n\t"		\
-- 
2.24.0.rc0.303.g954a862665-goog

