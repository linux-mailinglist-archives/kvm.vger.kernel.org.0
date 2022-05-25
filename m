Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4599F534670
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 00:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbiEYW0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 18:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344686AbiEYW0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 18:26:15 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53165110
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z11-20020a17090a468b00b001dc792e8660so103992pjf.1
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1+sE54bQx2t4fwpbWEt17sU4LeDI45Rz3nd8Z1fxEVM=;
        b=ShFQVD12P8JMQ//0COOqBxO64VBS2rO4ICn0VoixRym+8gf7yxI5GUCZwQa/dMooZZ
         zNj9bZnqXh6tAOLyWobqHp7Yo6b1qsvfxeaDZbVB87VtxVPq2wCD/RGxCYYFLaCe5kAy
         bUrnz0suGuIVrHH3yNidW0GXjtZYuxoRBQfPYnPVmhB0JYIb/Q0LZKfmmDM1rq12GeE4
         sWjYbFS8TWnaTCjTouv4h7bs6aW21oT6MGJjHjqGSf0Ej0oPq9jCCHZjuzPdTMBqdSj7
         0iv2lnADB6batSLynOoQ5dB9Vg2lm7vggQz5JVZroRUQhzavtTSt6sQU6nnRTKGGZHwb
         tdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1+sE54bQx2t4fwpbWEt17sU4LeDI45Rz3nd8Z1fxEVM=;
        b=mma0f+HTE6Ody55n35yukUdR9Hxqn/dEl9x5B3L6cdVpp5SC/8fBo8z3PDvObUOagz
         J8LRV1kOtuIRWKF26FIjUjLm+Y4yRHLkUyNEQZEwZN515snzozcSU+FKz5O7/QvtQObb
         UyA2ED1u3Y2GDIPsSN5H7pza2Wl7E6xvVX/xIKTuWHHrlz5gNURc8InmJIVA6YVqeApw
         FP2pH1UYiCsG43EGUD9N2liAuL1CmpIEdCnAAtdb8k5DKaLoGO57Wnz2fyjAHZlnMLmA
         mSF7ZmjUplPTQ4jkeD/u9fJQLJrJI3s1+Lub5ta5X3FexuD7pb6ow+fhM1n5zbyu3Z2i
         SuyA==
X-Gm-Message-State: AOAM532Pnby+8vqKavPVk51sA/lNLtgFl0BJ8Z1syeykjZs+yPmZbAQR
        ggm302kjqEqZJ5YE61lr5COGeBgqyfw=
X-Google-Smtp-Source: ABdhPJxzEOOjvl7kgGks3plOPdNixXYXYcduS3W+WrJEIL+vcj1zZdB3vif0SZDFUx6i5RTW5fMkKhe71nU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:38ce:b0:1e0:5bb2:9316 with SMTP id
 nn14-20020a17090b38ce00b001e05bb29316mr12652709pjb.51.1653517569704; Wed, 25
 May 2022 15:26:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 25 May 2022 22:26:01 +0000
In-Reply-To: <20220525222604.2810054-1-seanjc@google.com>
Message-Id: <20220525222604.2810054-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220525222604.2810054-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 1/4] KVM: x86: Grab regs_dirty in local 'unsigned long'
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
        Kees Cook <keescook@chromium.org>
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

Capture ctxt->regs_dirty in a local 'unsigned long' instead of casting
ctxt->regs_dirty to an 'unsigned long *' for use in for_each_set_bit().
The bitops helpers really do read the entire 'unsigned long', even though
the walking of the read value is capped at the specified size.  I.e. KVM
is reading memory beyond ctxt->regs_dirty.  Functionally it's not an
issue because regs_dirty is in the middle of x86_emulate_ctxt, i.e. KVM
is just reading its own memory, but relying on that coincidence is gross
and unsafe.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 89b11e7dca8a..7226a127ccb4 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -269,9 +269,10 @@ static ulong *reg_rmw(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static void writeback_registers(struct x86_emulate_ctxt *ctxt)
 {
+	unsigned long dirty = ctxt->regs_dirty;
 	unsigned reg;
 
-	for_each_set_bit(reg, (ulong *)&ctxt->regs_dirty, 16)
+	for_each_set_bit(reg, &dirty, 16)
 		ctxt->ops->write_gpr(ctxt, reg, ctxt->_regs[reg]);
 }
 
-- 
2.36.1.124.g0e6072fb45-goog

