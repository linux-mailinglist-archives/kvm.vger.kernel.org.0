Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F58C535567
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345240AbiEZVY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349062AbiEZVYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE2C5F27A
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j13-20020a170902da8d00b00161d78a9e3eso1678820plx.17
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+ARLUoQErvE10R5Z3P5YbADKHrFc+h+h9fYwAe9gqkQ=;
        b=P1O1m4A5QB3PkqYRhvWgKI3trzoLpiD17Kap9u1Ntf7VXNNt1LmTVq0xans+HuPbwP
         mrMXwad+SEnBrc5v+SdXuwL7TfEDMDuy3jr82opB5JprY8fpDve5pmyhw/qPJ5KCyALt
         rFJ5C02+GK3Um1cpjhCZFsMdja3ACtm7xaEK2uFGIcSrATj61okbfsKEv/q9Q2V0qgcE
         8XbzvEcswTakOhChRP0G2ohPJDooOxl1wJ3oRkV0+YniNUu3+5oXZwertnhEL7elo276
         CFUTe0QOajucWkgSzuSbC60D7gFaNKbeIkXJgjThxp8libH4wQFoylreajXaLkiXjahY
         loeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+ARLUoQErvE10R5Z3P5YbADKHrFc+h+h9fYwAe9gqkQ=;
        b=gL19QHvaxtvJDILZ3CxJESv/thKdvEokbQxHbA1DpBji6H0Fdx+QO+6VqMjyEOQoXw
         FDdk8peDVAIgYt4G6wsvNq0JsPbuf2AfAWeKpUOKD7RWlnrgJsfmFsLO7EUKkGOy98Yg
         jWZivlAcnG36qXWovGZdEg5J4UuBlctIFtB5zGGzRq7gk2vq/OcO+Xkz4aDEz9xf0FeD
         4LllqLoPS0YsZDiKmexwpPaBeDha/FWDydOOqcnd/GTMnCkPNQEI0b0GRMQgw/Vraauy
         dq5Kq/w8dV6KpWpI4bL5la1SUq2+fQYKL0M/ML3UlymIzoHSCUN4Wb8yBx4cIfw7u6NV
         smsg==
X-Gm-Message-State: AOAM530xKngCd2bV3Tf+HuYh59RDv5eqJObDG20Wl6VpKqGd8ls5eyFY
        0lJkI/2GNTFmyajtjFDnt0yOvovdQXo=
X-Google-Smtp-Source: ABdhPJw0nK+wAhiONzhiRIha9jnwWLcnJmVTgMO2zOQF0Ko9glHAJQlpshUO38CIPt2CWi406/F7XXICRcc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:e819:0:b0:518:6a98:b02 with SMTP id
 c25-20020a62e819000000b005186a980b02mr34100356pfi.74.1653600263944; Thu, 26
 May 2022 14:24:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:13 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 4/8] KVM: x86: Use 16-bit fields to track dirty/valid
 emulator GPRs
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

Use a u16 instead of a u32 to track the dirty/valid status of GPRs in the
emulator.  Unlike struct kvm_vcpu_arch, x86_emulate_ctxt tracks only the
"true" GPRs, i.e. doesn't include RIP in its array, and so only needs to
track 16 registers.

Note, maxing out at 16 GPRs is a fundamental property of x86-64 and will
not change barring a massive architecture update.  Legacy x86 ModRM and
SIB encodings use 3 bits for GPRs, i.e. support 8 registers.  x86-64 uses
a single bit in the REX prefix for each possible reference type to double
the number of supported GPRs to 16 registers (4 bits).

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 3 +++
 arch/x86/kvm/kvm_emulate.h | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c74c0fd3b860..5aaf1d1200af 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -262,6 +262,9 @@ static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
 		nr &= NR_EMULATOR_GPRS - 1;
 
+	BUILD_BUG_ON(sizeof(ctxt->regs_dirty) * BITS_PER_BYTE < NR_EMULATOR_GPRS);
+	BUILD_BUG_ON(sizeof(ctxt->regs_valid) * BITS_PER_BYTE < NR_EMULATOR_GPRS);
+
 	ctxt->regs_valid |= 1 << nr;
 	ctxt->regs_dirty |= 1 << nr;
 	return &ctxt->_regs[nr];
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index bc3f8295c8c8..3a65d6ea7fe6 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -356,9 +356,9 @@ struct x86_emulate_ctxt {
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
-	u32 regs_valid;
+	u16 regs_valid;
 	/* bitmaps of registers in _regs[] that have been written */
-	u32 regs_dirty;
+	u16 regs_dirty;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
-- 
2.36.1.255.ge46751e96f-goog

