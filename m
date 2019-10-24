Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5915E3F59
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 00:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731543AbfJXW2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 18:28:08 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:35112 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfJXW2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 18:28:08 -0400
Received: by mail-ua1-f73.google.com with SMTP id z5so95091uae.2
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 15:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a6D0LvDSWvcPBISgGIo9u1LrVZKZJkW1is0FU9Md0OY=;
        b=QgIbbNPzQRq8lf+1LZBbxpjdewMwplI2ZoV9XkzgGYuAhNQyKZ1vHAPEiMbi7u04Gz
         KqWNHCK1iD6mvnvff7f92kfMTMraxWFI5RMWoo8z7PQjgeH722jU5nrjQ+GgSn+WCgDW
         0SG1fU3JnR9i3Ja4jYW1xVWDwRp034JHajPpa6sdU48Jt0pHAsfan3z5znxHJvxF8wIB
         KKprUAHaz7qtACM0xK4KpKhD/0vphO2PWh0so/wb04Z2pkkJuIuLcE4L4jOk/1ymxtAk
         kvbl1VbDxa70e2FgdW5ezpXQ7euebv7Ekn8RxST4yBiVWdGG9tBS0qJPShHxZUMiDpQm
         SSlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a6D0LvDSWvcPBISgGIo9u1LrVZKZJkW1is0FU9Md0OY=;
        b=YXebimbvNbIjE5JSLePaDSM/ZC0dlb2VQq8sL16+aO+kMKtyvjbhBI9v2kACCV54PQ
         8i7b4vl61jCElVSH6ROTCRtbObss789MXrZ6NV7qQb5p3Zcyzn50tvdNSotv9NKqJXSq
         h2tmWW2noTPjNBLqX+P6btLOGVJhWOLiamXpg9ZKMu/K4KYU2/OUBzevMRruvTbHXlER
         +zvZgg0azLXQMiCfRs3yUN9TKF8DyKYn6Aj+/ktTVPOhmcEv3ur/ZGpvBq1iE+7zuuDJ
         nVqCNYv5qGYq1iz8Um2tPrjnpNCE3hW5yC7xzilJXZDtH3nFAR7uBk75zs9Cj5n+sYeQ
         5pdQ==
X-Gm-Message-State: APjAAAVij1yqwU3aO4jNh4Yr7b3poks45ATR4VH9AiJgQDW8Zvm51mvh
        kJi5Oekyd+HE0AHi/kokZ18e8lB2jFsmOuLPgbxb8NhuYSUIZQ5ki5Xg+J8K8zOt79ooq6cEJ7i
        N73Pw+9hDS5mMPY7e4Qg8EUTfUAbLF1cjbNkqJT7KNNg8E81ZkkvfM3NSuatPAcSbXPPV
X-Google-Smtp-Source: APXvYqwrgkNXBSU0aSof+GA/FUiQFEnHAHvhzyeU3r+6GzVla+fja8N0iBVoMaF6B4paXluH4IHotiNN/1VQegH3
X-Received: by 2002:a1f:b202:: with SMTP id b2mr453354vkf.59.1571956087093;
 Thu, 24 Oct 2019 15:28:07 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:27:26 -0700
Message-Id: <20191024222725.160835-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH] x86: Fix the register order to match struct regs
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

