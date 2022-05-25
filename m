Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA226534674
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 00:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbiEYW03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344762AbiEYW0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 18:26:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3627F13D
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so35733ybp.9
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BYFiENncuVJ2TvmhMEdP2audf2NxqV608VtgAVJJeVI=;
        b=IbW8vJJI7X1j43Z/4nZsPK9eWZGKk7cSQrblreYcVOM8uer7o4RhoKvjJykAXprlTB
         KZJ5FFDsh7YZlMwSMhwukU1EBAvaQYfiqnxlWu7iUMVV28K5YiIFBDlJs7UlRwO1c2S3
         Ri9Pm1jcibc8+s3HqE/fhhiKexxkDhj0t2HzF1Sj8WL1qrdv1GkzDOp/1IxiYYDhElzD
         yVXwDkobkNF6dkpArA3KJc2pl13xsmdCi4ZPivuPHm5KniCW54AnQSxFx8X8rzWr+xy5
         tdP5sPDHNJp3Phv8z1LnX1h8YbTLOW98xzDiPylEA6E+NqqhJbGJpVulvBMNbad2vMc/
         QNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BYFiENncuVJ2TvmhMEdP2audf2NxqV608VtgAVJJeVI=;
        b=0zeJsQqr2A6OEVy741KSKS8dZtbAEUkwgWzT6b88iAxZ6HvXMsBFGxy6zQ3SguTKp9
         zcDANZAyJJcF3iDSKXgfR0O41c7FiK1LSi3RHz6UycM73EarZsCeS6KYDVZ6IyNJb69D
         wcuG6lr0N0a0HUk8htFthj9mT1uO1omIq0EwcwM8evxtLHLPn1bnkIRlzdM0VvyrV1tk
         UEP3XFoukzX7n25zYDK+bTVmoQRjL/Dzkr3SKLHILdShOib3nOSAWip9ATSztNZG3jzc
         6ZbsnuDPtUxvcVTOkMOQ8q0Ys9QQEVmcszKOJnl7qMJddO5fU3wwqTaw4z1nbqwrsoD3
         kAzA==
X-Gm-Message-State: AOAM533JypLveAwM/snr24tU+ppxC2hTcy1v3N2rZdOHv5hch+uUrPgL
        U1z0oozjItuP/xBxN8YtT2L9ypv2SK0=
X-Google-Smtp-Source: ABdhPJzG9ZXHCHAK8MpiWigPcMD718Z2JGUtzMAwdktki7ZuPJWTkQQn7bqwbKeLlXo4t+/9JDe0zQOVZXI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:5a87:0:b0:2ec:239:d1e with SMTP id
 o129-20020a815a87000000b002ec02390d1emr35367109ywb.211.1653517571441; Wed, 25
 May 2022 15:26:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 25 May 2022 22:26:02 +0000
In-Reply-To: <20220525222604.2810054-1-seanjc@google.com>
Message-Id: <20220525222604.2810054-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220525222604.2810054-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 2/4] KVM: x86: Harden _regs accesses to guard against buggy input
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

WARN and truncate the incoming GPR number/index when reading/writing GPRs
in the emulator to guard against KVM bugs, e.g. to avoid out-of-bounds
accesses to ctxt->_regs[] if KVM generates a bogus index.  Truncate the
index instead of returning e.g. zero, as reg_write() returns a pointer
to the register, i.e. returning zero would result in a NULL pointer
dereference.  KVM could also force the index to any arbitrary GPR, but
that's no better or worse, just different.

Open code the restriction to 16 registers; RIP is handled via _eip and
should never be accessed through reg_read() or reg_write().  See the
comments above the declarations of reg_read() and reg_write(), and the
behavior of writeback_registers().  The horrific open coded mess will be
cleaned up in a future commit.

There are no such bugs known to exist in the emulator, but determining
that KVM is bug-free is not at all simple and requires a deep dive into
the emulator.  The code is so convoluted that GCC-12 with the recently
enable -Warray-bounds spits out a (suspected) false-positive:

  arch/x86/kvm/emulate.c:254:27: warning: array subscript 32 is above array
                                 bounds of 'long unsigned int[17]' [-Warray-bounds]
    254 |         return ctxt->_regs[nr];
        |                ~~~~~~~~~~~^~~~
  In file included from arch/x86/kvm/emulate.c:23:
  arch/x86/kvm/kvm_emulate.h: In function 'reg_rmw':
  arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing '_regs'
    366 |         unsigned long _regs[NR_VCPU_REGS];
        |                       ^~~~~

Link: https://lore.kernel.org/all/YofQlBrlx18J7h9Y@google.com
Cc: Robert Dinse <nanook@eskimo.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7226a127ccb4..c58366ae4da2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -247,6 +247,9 @@ enum x86_transfer_type {
 
 static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON_ONCE(nr >= 16))
+		nr &= 16 - 1;
+
 	if (!(ctxt->regs_valid & (1 << nr))) {
 		ctxt->regs_valid |= 1 << nr;
 		ctxt->_regs[nr] = ctxt->ops->read_gpr(ctxt, nr);
@@ -256,6 +259,9 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON_ONCE(nr >= 16))
+		nr &= 16 - 1;
+
 	ctxt->regs_valid |= 1 << nr;
 	ctxt->regs_dirty |= 1 << nr;
 	return &ctxt->_regs[nr];
-- 
2.36.1.124.g0e6072fb45-goog

