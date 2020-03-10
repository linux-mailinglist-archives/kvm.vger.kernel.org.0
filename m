Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC31D180472
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCJRKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:10:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42627 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgCJRKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:10:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id v11so16853608wrm.9
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 10:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w1HtT6GncF2D/jICWHxCXiDFA3NuhpTuwzMHtGs5MNk=;
        b=mcGrcW4NkNBmlcjsAjrf+ecneR5Y8x01BDF+MPm0+vjv1NaAdFAMFz/jTxagXLN7Rd
         xAF8GdwIM4IQEvmfZy4PvSpdb6vEnxLmxNRUaXWG685IBNeGOk4oVCyr5Pnto0M6/iqK
         VD8Uu6HJjdrMED7vwGpCWzl2EPVacg5jxD7RjUOFIj5k/4/BHP4bcN+47e2Bl0UcGAuI
         U6P/ySQxuQIsSXuAJDJ0KNYL1yv79io6wTREiWmx4ygDkQESmbZFMeEX7ia+nqUacVPY
         CewxNH159dGcrwwLTQEdwFfyXTdUqYbbAXcyiXwRzn5wh617j+j8xmVeURhhx+/PiZDU
         tRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w1HtT6GncF2D/jICWHxCXiDFA3NuhpTuwzMHtGs5MNk=;
        b=nv7UmSo856QF6hCE+TDgucvoBcZ/bYLeNwT0Zx54LNanTQpiM5c2GJ7hOUUVWCCnrZ
         6bRrwbh3lUVa7WwIj1KeahS2nqo03bGBmIPVD4JzIbxISdbgTfqRSbScTrwQjA1ke4zk
         GxGa2JraEAExN0K4am5HJJxTp0uEmOBSjogXDlU+D4JlL3Vv7pVFD1P54lLogvu5Zd9w
         BpilAUK92QtU4+iid5Wzrco+FfNERkYD9OdnRrOl6LzJ7RNhi16MvB5Ihj8jjrYZm3cf
         67hffPUq4q+KQMr7qlM1lq4DZRov7S+VUPT0l1+HYeLSJJhosb46elweY3+dIrWHHGZk
         /grQ==
X-Gm-Message-State: ANhLgQ0GK9pDxgGd+dJl2ylOw8b5D79/L9Q3imKc8Tb8uqGArO7XGedp
        igPIvE2FXtVb4btwPC7TOvxFMwjR
X-Google-Smtp-Source: ADFU+vv8BRQdbL05cC3CzdOkgz6AEdVXpErwTgGxX7NDtWqhKIn8UQGfkx1qoFW2Cf4zgBey9pnO+g==
X-Received: by 2002:adf:ecca:: with SMTP id s10mr29621943wro.255.1583860233892;
        Tue, 10 Mar 2020 10:10:33 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id v2sm4308734wme.2.2020.03.10.10.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:10:33 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH] KVM: VMX: access regs array in vmenter.S in its natural order
Date:   Tue, 10 Mar 2020 18:10:24 +0100
Message-Id: <20200310171024.15528-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Registers in "regs" array are indexed as rax/rcx/rdx/.../rsi/rdi/r8/...
Reorder access to "regs" array in vmenter.S to follow its natural order.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 81ada2ce99e7..ca2065166d1d 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -135,12 +135,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	cmpb $0, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
 	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
+	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
+	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
 	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
 	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
 #ifdef CONFIG_X86_64
 	mov VCPU_R8 (%_ASM_AX),  %r8
 	mov VCPU_R9 (%_ASM_AX),  %r9
@@ -168,12 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 
 	/* Save all guest registers, including RAX from the stack */
 	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
-	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
 	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
 	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
+	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
+	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
 	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
 	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
 #ifdef CONFIG_X86_64
 	mov %r8,  VCPU_R8 (%_ASM_AX)
 	mov %r9,  VCPU_R9 (%_ASM_AX)
@@ -197,12 +197,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
 	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
 	 */
-1:	xor %ebx, %ebx
-	xor %ecx, %ecx
+1:	xor %ecx, %ecx
 	xor %edx, %edx
+	xor %ebx, %ebx
+	xor %ebp, %ebp
 	xor %esi, %esi
 	xor %edi, %edi
-	xor %ebp, %ebp
 #ifdef CONFIG_X86_64
 	xor %r8d,  %r8d
 	xor %r9d,  %r9d
-- 
2.24.1

