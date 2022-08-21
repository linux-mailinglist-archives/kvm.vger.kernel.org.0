Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFBF59B68E
	for <lists+kvm@lfdr.de>; Sun, 21 Aug 2022 23:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiHUV7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 17:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiHUV73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 17:59:29 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8523615A10
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 14:59:21 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oPsyU-008sg9-OQ
        for kvm@vger.kernel.org; Sun, 21 Aug 2022 23:59:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=Y8xlPINiAr82q0yWzCQ+duX31yqFp04n0IHEjKYdbm4=; b=YdgFBCwt14Eam
        Z/NSQkYr30PSp/Jh8kScyScV2LLn/lqYJdwOgnHis4Y8bT+wH+Qz8Njqs9FsbN8Aae9Nb3qK4eGo1
        U/KDvyUhb8jYiFsLvZ/zRHcW7ggmt3HVCdl81/DLhbfcbLJZk4vTzMQm8RQGSBiaHpVaaVRQuf1rS
        3tXC9MGy7sU7e3Rm+FDj1hzSNtk/C2fD5X7Vfw0dMR+1F7pDZfICVYFPEvoC8T1VeHXCm/pznH6+Z
        0LdRP7DtPPS3PiY2oyXqfxDHREHtOY049btvroEFen81COFtXX7L5BPVuawGgGPbhk7BnJ3r1gioj
        ZZz0stiFrzOHpfcO9nNNQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oPsyU-00047X-6L; Sun, 21 Aug 2022 23:59:18 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oPsyT-0002Ny-7Z; Sun, 21 Aug 2022 23:59:17 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility
Date:   Sun, 21 Aug 2022 23:59:00 +0200
Message-Id: <20220821215900.1419215-1-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The emulator checks the wrong variable while setting the CPU
interruptibility state.  Fix the condition.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
I'll follow up with a testcase.

 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b4eeb7c75dfa..5cfd07f483b3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1967,7 +1967,7 @@ static int em_pop_sreg(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);
-- 
2.37.2

