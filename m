Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6694851B394
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380466AbiEDXiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384604AbiEDXXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:23:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568A84B87C
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 16:19:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 16-20020a630010000000b003c5e4be54b2so1382583pga.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VcebJ8RjoQuwv5ad92t1ZGJ+FKDAFLhZ1oZKB3ykXv0=;
        b=XJW9YxB7dNOPZ47OHkBC4XURGSZ0HKYRbTbTvC+xVJ6+K210pYALkRZOMDbnumWwKx
         A8aeH+M2jk3QpC8ZYgQMcwlhnT9ni5+p8czWJ8HW4mDIq3aTz9pWukKOeR+SFU16f2JQ
         SGmR9KgqdDZ2IuwQkMVY4tqdkv0U7VpLsnCGDOfRWDXWk22q8BjrXg9PdbRRxZnpMOfD
         zE1c73Voo4SH7bq58qEUGpKTjQkhXQcDoZFDxIjSXnbYSGazV6IX85bXVOO/J5t513d9
         fQoMpa/O6VpBZW8gkxmhRuuPH+PrTwOCg8q8t++YoVslWnHkQvRUcqqB1m1k+2Tq+ZYm
         7M1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VcebJ8RjoQuwv5ad92t1ZGJ+FKDAFLhZ1oZKB3ykXv0=;
        b=tJEk5NcjDonDYvXWznpVyRm850sbcMH8zDIloqd4LbufuiV/dxLLcaJiN3znsrI80s
         yHE83/VZBN/x64JyIuLgVasYG6dk0xoypjWb6uiPOuFaYftprbYiUwYHuukVjnFOcAZb
         zgqhIIZk+V+Ml9d6HUGzJeSRyYRqPQDupk3PAHJ4Jmt5+LdyVdbEaX/18Qzhp5cVCJUh
         K8OFcb6i9aNOTyX3ZHFqR8gO6NhgNQsiHUg5lYUdp7+5cz8PA9kTFHjNQBU/Nx6BjEFk
         c4raHHOpaCbN0sCy3VJi1QoICsveI5y7G1jpvdJTbKIDchNW1XyMuj1l5z2CftOvHr5/
         WNjw==
X-Gm-Message-State: AOAM5325PhpN+K9QthUr3ATymTCRem9ZLuZqeB/jQuMrlPxl3w8DH7Ir
        nqPxCwKjI4zAD638q627rdac1/3CTZvo3xYt3b5P6BQwJkjHwMdyGY+CbQmfsz80+4tdDqrmgr9
        7ATqDrJHejfz6NmKhdFW7Wg67sd7UcPYcigeP8bSn2uJKQQbUhs2pw0fVz2jZKhk=
X-Google-Smtp-Source: ABdhPJy4pFA+qcHPR0SF93YeeKi7a3NpVDrgWdeNbqAn692ArtzeMaml4GI87Dl+f4E9BRhY/0HO8KUFtnqxpA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:8608:b0:158:c532:d8b2 with SMTP
 id f8-20020a170902860800b00158c532d8b2mr24467023plo.46.1651706367716; Wed, 04
 May 2022 16:19:27 -0700 (PDT)
Date:   Wed,  4 May 2022 16:19:16 -0700
Message-Id: <20220504231916.2883796-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH] KVM: VMX: unify VMX instruction error reporting
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Include the value of the "VM-instruction error" field from the current
VMCS (if any) in the error message whenever a VMX instruction (other
than VMREAD) fails. Previously, this field was only reported for
VMWRITE errors.

(Omit the "VM-instruction error" field for VMREAD to avoid potentially
infinite recursion.)

Signed-off-by: David Matlack <dmatlack@google.com>
[Rebased and refactored code; reworded commit message.]
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d58b763df855..c7d2d60fd35b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -392,24 +392,26 @@ noinline void vmwrite_error(unsigned long field, unsigned long value)
 
 noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmclear failed: %p/%llx err=%d\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmptrld failed: %p/%llx err=%d\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
 {
-	vmx_insn_failed("kvm: invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
-			ext, vpid, gva);
+	vmx_insn_failed("kvm: invvpid failed: ext=0x%lx vpid=%u gva=0x%lx err=%d\n",
+			ext, vpid, gva, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
 {
-	vmx_insn_failed("kvm: invept failed: ext=0x%lx eptp=%llx gpa=0x%llx\n",
-			ext, eptp, gpa);
+	vmx_insn_failed("kvm: invept failed: ext=0x%lx eptp=%llx gpa=0x%llx err=%d\n",
+			ext, eptp, gpa, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
-- 
2.36.0.512.ge40c2bad7a-goog

