Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F3B3A1D40
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhFIS6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhFIS6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:58:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B81C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:56:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x64-20020a25a0460000b02905394c6727easo690080ybh.13
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KTEpwu4bqR1p8wvp17ZxzJ840iYXPnqSGeeyMtkh558=;
        b=BK37mY3b/vCaVFAmjS3+wuKg+njrSO95JI/u5Tmp2gBMuXkMK9UePml6M/e2waTOGV
         q1ePkup2RYO/3Xp8jdd97rVfkeQVb2oa4QAiY4HjRWriW8b0LcY6fRZBI/IGVB2jYkbx
         ZE8044mUAylUMmAk9DiaP7LpLv8aQnuRa+ZDSuP61gdYF5uO8r+a63in32D8vSirQfsX
         DoDyuvcxpDI1Cq981uPRA0lKmV1lBgs+um4ncXuhK8oa4wgC6UjQevxPhuU92WINF4YG
         T7U1HAUaD7YooMoaZ9tJzlk6mCPL4HcAnwmPqPjwZM4kupUBtT1FH2VyxXS5imOk49zn
         n9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KTEpwu4bqR1p8wvp17ZxzJ840iYXPnqSGeeyMtkh558=;
        b=k3kb6Y3dk/GCjz7kItbnoLJRSmePxe9+geA3gDDPaMyYhI2iUJSVK29GoIeYr53z31
         bpT2DjNy7+AuYTwqdVnnBmLi/a+B4I4VCpkVcFzQqwlPNiZgHjvDwRC4+JjrJRQ5SxGB
         cZbZsZnjtHHOMiR7mwqc2R2t9PWWK2NZBKBk7cuHErZr1U3bXmtQB4TrmzIIbAr/LiEl
         AoJyMsoXdF7ua+ILd1Sjf7yzF4Zx5vvQ+oBa7emS21xTlipblnkJcCIX/5mdT/UGFIB4
         ReQdGlQh0l2wmLdC3m3BgGs2OZ9Y0EmMMXMw/hfZesxtu7R+SkUKGrFbOnMNDRUKsZbn
         QVFg==
X-Gm-Message-State: AOAM5312mngMWtn8WCB+0M44ZhB4dViRT7FoZmugMVE9EHYJa9fREOoH
        XHgkQyjmmEHLmObuLkaOAD8Wgc0xL5A=
X-Google-Smtp-Source: ABdhPJzBND09fjq/4DJeyZJ8vtjMoRARyd8cdN848SzR7XyYO/SOd+9sBcakKdjiuGFh3pagdwckmcfVoCU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a25:e097:: with SMTP id x145mr2112944ybg.226.1623264995557;
 Wed, 09 Jun 2021 11:56:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:12 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM emulation fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM_REQ_TRIPLE_FAULT to properly emulate
shutdown if RSM from SMM fails.

Note, entering shutdown after clearing the SMM flag and restoring NMI
blocking is architecturally correct with respect to AMD's APM, which KVM
also uses for SMRAM layout and RSM NMI blocking behavior.  The APM says:

  An RSM causes a processor shutdown if an invalid-state condition is
  found in the SMRAM state-save area. Only an external reset, external
  processor-initialization, or non-maskable external interrupt (NMI) can
  cause the processor to leave the shutdown state.

Of note is processor-initialization (INIT) as a valid shutdown wake
event, as INIT is blocked by SMM, implying that entering shutdown also
forces the CPU out of SMM.

For recent Intel CPUs, restoring NMI blocking is technically wrong, but
so is restoring NMI blocking in the first place, and Intel's RSM
"architecture" is such a mess that just about anything is allowed and can
be justified as micro-architectural behavior.

Per the SDM:

  On Pentium 4 and later processors, shutdown will inhibit INTR and A20M
  but will not change any of the other inhibits. On these processors,
  NMIs will be inhibited if no action is taken in the SMI handler to
  uninhibit them (see Section 34.8).

where Section 34.8 says:

  When the processor enters SMM while executing an NMI handler, the
  processor saves the SMRAM state save map but does not save the
  attribute to keep NMI interrupts disabled. Potentially, an NMI could be
  latched (while in SMM or upon exit) and serviced upon exit of SMM even
  though the previous NMI handler has still not completed.

I.e. RSM unconditionally unblocks NMI, but shutdown on RSM does not,
which is in direct contradiction of KVM's behavior.  But, as mentioned
above, KVM follows AMD architecture and restores NMI blocking on RSM, so
that micro-architectural detail is already lost.

And for Pentium era CPUs, SMI# can break shutdown, meaning that at least
some Intel CPUs fully leave SMM when entering shutdown:

  In the shutdown state, Intel processors stop executing instructions
  until a RESET#, INIT# or NMI# is asserted.  While Pentium family
  processors recognize the SMI# signal in shutdown state, P6 family and
  Intel486 processors do not.

In other words, the fact that Intel CPUs have implemented the two
extremes gives KVM carte blanche when it comes to honoring Intel's
architecture for handling shutdown during RSM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 12 +++++++-----
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/x86.c         |  6 ++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5e5de05a8fbf..0603a2c79093 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2683,7 +2683,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	 * state-save area.
 	 */
 	if (ctxt->ops->pre_leave_smm(ctxt, buf))
-		return X86EMUL_UNHANDLEABLE;
+		goto emulate_shutdown;
 
 #ifdef CONFIG_X86_64
 	if (emulator_has_longmode(ctxt))
@@ -2692,14 +2692,16 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 #endif
 		ret = rsm_load_state_32(ctxt, buf);
 
-	if (ret != X86EMUL_CONTINUE) {
-		/* FIXME: should triple fault */
-		return X86EMUL_UNHANDLEABLE;
-	}
+	if (ret != X86EMUL_CONTINUE)
+		goto emulate_shutdown;
 
 	ctxt->ops->post_leave_smm(ctxt);
 
 	return X86EMUL_CONTINUE;
+
+emulate_shutdown:
+	ctxt->ops->triple_fault(ctxt);
+	return X86EMUL_UNHANDLEABLE;
 }
 
 static void
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 3e870bf9ca4d..9c34aa60e45f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -233,6 +233,7 @@ struct x86_emulate_ops {
 	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
 			     const char *smstate);
 	void (*post_leave_smm)(struct x86_emulate_ctxt *ctxt);
+	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 54d212fe9b15..cda148cf06fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7123,6 +7123,11 @@ static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
 	kvm_smm_changed(emul_to_vcpu(ctxt));
 }
 
+static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
+{
+	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
+}
+
 static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
 {
 	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
@@ -7172,6 +7177,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_hflags          = emulator_set_hflags,
 	.pre_leave_smm       = emulator_pre_leave_smm,
 	.post_leave_smm      = emulator_post_leave_smm,
+	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 };
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

