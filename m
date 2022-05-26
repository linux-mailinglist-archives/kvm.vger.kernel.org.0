Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360B453556D
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiEZVYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239874AbiEZVY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:27 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180F99D06C
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id on14-20020a17090b1d0e00b001c7a548e4f7so3903584pjb.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vRAWGApnZo9PQoKSv+ZEImJz7U3HwflIO0rVPe9gUZU=;
        b=AuzYwvO+aFV3coHvl7K8KwGsYi6DGC0TkiEteCchpLesVODaU452xnHzHBJREb8Jbr
         2aGV5xDy4pWsobXF7xO2yRHmoYLNtJKJHnYJ0V8UmMwip981d7pD4jNF5vhqtUmPkWr4
         eANCrVZAUXZ7ZVOwzKTVdyHTRsMc12HjplmVvqUV46xFfqIlLNQ36TqSDqNAOBC9PlfQ
         QAsOKQQYg6EuAwHZMGFY5tJ7OmiP18H5E5XVSklljJ8wBLIv1H3mddfjE5lAbGyBwIdA
         lsJ2mXx4v/foETyFGjPDoN034bzZSwe+07TXR+9mvhmv0gVRQ6+3Pn9X5QkAeXGAFF5S
         pelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vRAWGApnZo9PQoKSv+ZEImJz7U3HwflIO0rVPe9gUZU=;
        b=xqk9/QYCjmX6Tfa8D4atIi25Nu2Z83ap5D2GKl2dlrdE5PcejRMbAPLEA65+4uuIH+
         DEYol3VpLDpQZern+17WyDYqBM3agnExZGPL0umOHp5qHjIKWqbuq2rNnQhcNbkXUENr
         d/mYo17eBmAN9j7iv8GGQg6j+XIdwo/pylWw78FgRwDbMrZTtyIPfNQDG07Lqoh5Pmyv
         GbIX14BV5MNuGsaihL7LLnigXO0KXUrakPosoeY6+9oRqTMQMjObyLS/5czdF0BqHnbB
         oa+X5edyuoo64BpSJAAIuE0dTr2c080n7hJGajTx/8RK9IaiQEMZogVyViU+0tBe4R+a
         iPOg==
X-Gm-Message-State: AOAM5305rk/vefZb6wGqEpuS+8kWs6oxpl8u4Se9sBPRH1/mZRvHZZbI
        JYHkJ0ehWK15YzpJV/aelnUssJsHxVI=
X-Google-Smtp-Source: ABdhPJyvAr6xUQFYgm5WV3rKJQ4tk4S5ntWPyBHIlSXKk1BBeLTAu2f6WznnIhnvLiAHU4OPrsZPctfEhSM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a65:6bce:0:b0:3f2:5f88:6f7d with SMTP id
 e14-20020a656bce000000b003f25f886f7dmr34957881pgw.253.1653600265524; Thu, 26
 May 2022 14:24:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:14 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 5/8] KVM: x86: Reduce the number of emulator GPRs to '8'
 for 32-bit KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>
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

Reduce the number of GPRs emulated by 32-bit KVM from 16 to 8.  KVM does
not support emulating 64-bit mode on 32-bit host kernels, and so should
never generate accesses to R8-15.

Opportunistically use NR_EMULATOR_GPRS in rsm_load_state_{32,64}() now
that it is precise and accurate for both flavors.

Wrap the definition with full #ifdef ugliness; sadly, IS_ENABLED()
doesn't guarantee a compile-time constant as far as BUILD_BUG_ON() is
concerned.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 4 ++--
 arch/x86/kvm/kvm_emulate.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5aaf1d1200af..77161f57c8d3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2441,7 +2441,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
 	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
 
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < NR_EMULATOR_GPRS; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
@@ -2498,7 +2498,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	u16 selector;
 	int i, r;
 
-	for (i = 0; i < 16; i++)
+	for (i = 0; i < NR_EMULATOR_GPRS; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
 
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 3a65d6ea7fe6..034c845b3c63 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -306,11 +306,12 @@ typedef void (*fastop_t)(struct fastop *);
  * tracked/accessed via _eip, and except for RIP relative addressing, which
  * also uses _eip, RIP cannot be a register operand nor can it be an operand in
  * a ModRM or SIB byte.
- *
- * TODO: this is technically wrong for 32-bit KVM, which only supports 8 GPRs;
- * R8-R15 don't exist.
  */
+#ifdef CONFIG_X86_64
 #define NR_EMULATOR_GPRS	16
+#else
+#define NR_EMULATOR_GPRS	8
+#endif
 
 struct x86_emulate_ctxt {
 	void *vcpu;
-- 
2.36.1.255.ge46751e96f-goog

