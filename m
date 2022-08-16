Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0838A596441
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 23:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiHPVK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbiHPVKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 17:10:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031AE7E80C;
        Tue, 16 Aug 2022 14:10:20 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p10so14040307wru.8;
        Tue, 16 Aug 2022 14:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=NvNulZm0TaP1hFN6sFnwsfQo9WSALWLxEbOFV0/Etb0=;
        b=llH9ZkFRAetfgniIRfo626k3PmRVOGGhOmX6sWe3T6jLtLLCgL57AInAEjvDL1lRF/
         TdhvAPFcoCaps76Pai/2DjNQpHUC4cZxNPffYiHe1hH4UGTUNHPauXloHTdUOcINnVBb
         WekGW/pwkRmJLwkH0kRKUWsXKbYJzwaeydW8Nb4eEtUObTfQ4MHk4Yu8TzGaI45coZLn
         eEx1JlFuv/VGkwK00fVuX77ij4ku3RTGsLunasCNJYUcBtizMYZzCw/L8gfpkegIb2XG
         H+vz687uPAUd5TIEClEzIdxKWuK3/b+aYUAqEOYNepdJ8QqZKmlEQRMV6XoJ3WoFdAsq
         NqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=NvNulZm0TaP1hFN6sFnwsfQo9WSALWLxEbOFV0/Etb0=;
        b=WueYmIV8ouQrL2sflWK19r5cvFpAxeN9MBLzAc3vGpks2yzzB0vQ5gJ3eAVx99Oh3A
         dATTCeLiYIRgGYT4hq+neXdFnYp9BP82xiPvq+LFn+3nK4m6MlrYKUfQBKEnXU62/Un8
         ccbQvNZmtAl97V+koAni6J7v8CL5NOsV1F8xkHz6Sil9fiPl6weKNsqlY4f0MKrZR+PQ
         d+CUfifhzNbJgggSzH9wjMBstH/SL5TXJnCT+XM19YxQhC12EBlSa4q0R0gZzPeSSW4D
         HWsKWBbONnjWBPeZmkRlr0NmcNxEJunEPAnWou+Poza0qgyL8ajle6+Yo2SoFIcbPk8R
         uZ1w==
X-Gm-Message-State: ACgBeo14eCOTqGqd7B8oataMYXumRfnttjfWqBc8YHbNXyt/vVTY0lck
        NZPXh6EyVlyDzv/gbdPGDVF3LHr1e1EouA==
X-Google-Smtp-Source: AA6agR54R0jvZDNto8jeRWNpADovphd1WCeclyeH4A9PeiGp62sUC3gDIh2XRPDjsc4b1Af5wLMuHw==
X-Received: by 2002:a5d:6285:0:b0:225:1fb3:5ca4 with SMTP id k5-20020a5d6285000000b002251fb35ca4mr1637056wru.332.1660684218287;
        Tue, 16 Aug 2022 14:10:18 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c12c700b003a53e6c5425sm6504wmd.8.2022.08.16.14.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:10:17 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM/VMX: Avoid stack engine synchronization uop in __vmx_vcpu_run
Date:   Tue, 16 Aug 2022 23:10:10 +0200
Message-Id: <20220816211010.25693-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid instructions with explicit uses of the stack pointer between
instructions that implicitly refer to it. The sequence of
POP %reg; ADD $x, %RSP; POP %reg forces emission of synchronization
uop to synchronize the value of the stack pointer in the stack engine
and the out-of-order core.

Using POP with the dummy register instead of ADD $x, %RSP results in a
smaller code size and faster code.

The patch also fixes the reference to the wrong register in the
nearby comment.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 6de96b943804..afcb237e1c17 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -189,13 +189,16 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	xor %ebx, %ebx
 
 .Lclear_regs:
+	/* "POP" @regs. */
+	pop %_ASM_AX
+
 	/*
 	 * Clear all general purpose registers except RSP and RBX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
 	 * via the stack.  In theory, an L1 cache miss when restoring registers
 	 * could lead to speculative execution with the guest's values.
 	 * Zeroing XORs are dirt cheap, i.e. the extra paranoia is essentially
-	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
+	 * free.  RSP and RBX are exempt as RSP is restored by hardware during
 	 * VM-Exit and RBX is explicitly loaded with 0 or 1 to hold the return
 	 * value.
 	 */
@@ -216,9 +219,6 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	xor %r15d, %r15d
 #endif
 
-	/* "POP" @regs. */
-	add $WORD_SIZE, %_ASM_SP
-
 	/*
 	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
 	 * the first unbalanced RET after vmexit!
@@ -234,7 +234,6 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
 			   X86_FEATURE_RSB_VMEXIT_LITE
 
-
 	pop %_ASM_ARG2	/* @flags */
 	pop %_ASM_ARG1	/* @vmx */
 
-- 
2.37.1

