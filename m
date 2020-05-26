Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEB81B8FCE
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDZMat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 08:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgDZMas (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 26 Apr 2020 08:30:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB5C09B04F
        for <kvm@vger.kernel.org>; Sun, 26 Apr 2020 05:30:48 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d17so17155795wrg.11
        for <kvm@vger.kernel.org>; Sun, 26 Apr 2020 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZ4RXNvMIlD6HNwpFjr0pliVf/jgEqSPZK6SSI3jXkE=;
        b=AsA3ppnkWiWKWgebL0ITYk0Rz8cYQOeX2ahsJCtPtEIVcxjEb7lXV1GQTV++N/j6tB
         XP9cB8EmJ4EvcSCffaIPU6f2vTWOU/g9RcT2FJhtQQORy5GAaFjPACDnzEbj7IXMDVcE
         Fl9sXifb3EBSggwhUW3TbHgaeZ3+DdCs4bgMjpFLZSXIQmN0rpFzYIxfXYSkPXEgvpAw
         EeUPeIkLwHBBJP1QTEOUw1zOAjX54X6O++rIZP0z/NGhZaBs+KTD2ASxBnl4DG5fi/Kk
         2XeCaQMbcD0xVrVYlQQIfOtJ2QW/hWFDaL0kgtaE/yyc82hiKlwvj7Q+pyfItWuAA85h
         1ApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZ4RXNvMIlD6HNwpFjr0pliVf/jgEqSPZK6SSI3jXkE=;
        b=g9RcoL05WCE7pJsNAb/VcQ1EiuVTYVKBh8RjCeOjLt0g5xftF1/ZITQpDtE6de2IDV
         /0fIiCx18HUhzNZPxm1msTYhFR6CREoUd9YK3KdIZrjyaSg+v+HdPmOHCLKmXEp4zKS4
         uaSatwV2cLDBagle7lMfcgUgGCr6nSzQee0oxL2rC+atchIEjrxthy2CtYahQFxq7jyy
         Dt8qYl1okPibfaQJmujtNYnkvmsxW00htNLoU4PI2Bg6lS2aYEn89STFKs4VEkIDVktD
         bsGUhq8fCTjVA4YgmO38lLyErUOaSiF9YApoHQFfEfI+l21a7dOKi1FiIY68lqnqbxYb
         9BiQ==
X-Gm-Message-State: AGi0Pub2h+XJxo771q0NW98RQoWA25es2pPLpy9xW1o3t3F/ik09zhlS
        HP55q0SNVrVA8HJy1+5zRBWj5j7h0fc=
X-Google-Smtp-Source: APiQypI4IefkO31jzEh5+mkcVC/Du+SgcRbmCPzZalXTmujkNJn4Os4jb5lPoI0EoL3Vjg3ejXIrlQ==
X-Received: by 2002:a05:6000:108e:: with SMTP id y14mr23747920wrw.292.1587904246700;
        Sun, 26 Apr 2020 05:30:46 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id y18sm12572230wmc.45.2020.04.26.05.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 05:30:46 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: VMX: Remove unneeded __ASM_SIZE usage with POP instruction
Date:   Sun, 26 Apr 2020 14:30:38 +0200
Message-Id: <20200426123038.359779-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

POP instruction always operates in word size, no need to
use __ASM_SIZE macro to force operating mode.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 87f3f24fef37..94b8794bdd2a 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -163,13 +163,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
 
 	/* Save all guest registers, including RAX from the stack */
-	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
-	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
-	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
-	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
-	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
-	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
+	pop           VCPU_RAX(%_ASM_AX)
+	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
+	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
+	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
+	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
+	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
+	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
 	mov %r8,  VCPU_R8 (%_ASM_AX)
 	mov %r9,  VCPU_R9 (%_ASM_AX)
-- 
2.25.3

