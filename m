Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFD3A1D57
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFITAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 15:00:00 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:54791 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFIS7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:55 -0400
Received: by mail-yb1-f202.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so32540195ybn.21
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5JkdbCsi6tIMNzzVm9wHxYFjioeO7OutYnXez6KJdD4=;
        b=PeTUXy9cc2wmG5/l4EXI/SnMkKG54zwMJuM84t+r4OK/dEvDelLEyMYyXbck0tMcZc
         aIfblnk6SnM0IC6Dgq98V+LWomj5kEdz+97UvLCLJykk2i1sHCJCY+OmKsEqusB2bFrs
         3B3Ar22Cl+GRPdw03r6r+ExdGBR07zjwuUnN110uzyEK6m+y3Ql9+ZkIStKBa+ys9pC7
         K0EVk+9GlHPZakS3Tq9SxLVD6ztHW+yoHLDAjFICtCT3O+9+tfjtV4gq8E3m2zuOvImh
         fk+iiNMpy7UHE+0ri2YDlh1qTtWmV+BcAf2ynWyG+OW7YeI5U5Vdyxnpu41/VTQe325i
         S3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5JkdbCsi6tIMNzzVm9wHxYFjioeO7OutYnXez6KJdD4=;
        b=OzM8xt3eAKWQcgkb17sqpX7PfNg4qgmEtzVTPtX425hOQF66zE28Ph4oDtns1n07o4
         UXdhoCRnDBHVcZK0pQMzaIglAkzpEeF6hr2as6xBotTLieghKU27ockQsbftgY2foRGp
         RCxQbOfVv8InWzpw3i+iJucHpgZ//FFNzzH1sEg52w7SXmqRP35hBkGxYHGN9RzH2ZSp
         D0+nHvWnVmsEf6uPO4lAi+m9KvwO3axgbNTLDq44+YtMo2kn5t35HV8qtKr0NNqp7rWj
         rlN0fHC87fD8aRk8tavfhkfKoFFgHyjlarLxObonHlgKXpNNClRqaVgtjVAa+JagIdOE
         u6gg==
X-Gm-Message-State: AOAM533VTGu3SKbcSAcbZ/Ny00LqcXmSUuL4QzuH04DZf3WRr34cMr+q
        ncpJ3Fth64s5UxHCzuk82I+2gt9WDG4=
X-Google-Smtp-Source: ABdhPJylFlQJSONUQygVK3Jt8FR6p9wSXLpWvrG8ERHkl4IjKkciv5lK77KLyZSWRVNvhxf/d8ilP7+t9bc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a25:3103:: with SMTP id x3mr2141380ybx.8.1623265008446;
 Wed, 09 Jun 2021 11:56:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:18 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 8/9] KVM: x86: Drop .post_leave_smm(), i.e. the manual
 post-RSM MMU reset
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

Drop the .post_leave_smm() emulator callback, which at this point is just
a wrapper to kvm_mmu_reset_context().  The manual context reset is
unnecessary, because unlike enter_smm() which calls vendor MSR/CR helpers
directly, em_rsm() bounces through the KVM helpers, e.g. kvm_set_cr4(),
which are responsible for processing side effects.  em_rsm() is already
subtly relying on this behavior as it doesn't manually do
kvm_update_cpuid_runtime(), e.g. to recognize CR4.OSXSAVE changes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 10 ++++++++--
 arch/x86/kvm/kvm_emulate.h |  1 -
 arch/x86/kvm/x86.c         |  6 ------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9e0d5900c011..34c9f785d715 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2694,8 +2694,14 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	if (ret != X86EMUL_CONTINUE)
 		goto emulate_shutdown;
 
-	ctxt->ops->post_leave_smm(ctxt);
-
+	/*
+	 * Note, the ctxt->ops callbacks are responsible for handling side
+	 * effects when writing MSRs and CRs, e.g. MMU context resets, CPUID
+	 * runtime updates, etc...  If that changes, e.g. this flow is moved
+	 * out of the emulator to make it look more like enter_smm(), then
+	 * those side effects need to be explicitly handled for both success
+	 * and shutdown.
+	 */
 	return X86EMUL_CONTINUE;
 
 emulate_shutdown:
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index b620782c1fb5..31dc7ca4ff2b 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -232,7 +232,6 @@ struct x86_emulate_ops {
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
 	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
 			     const char *smstate);
-	void (*post_leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06f3be2d170b..347849caf1df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7112,11 +7112,6 @@ static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
 	return static_call(kvm_x86_pre_leave_smm)(emul_to_vcpu(ctxt), smstate);
 }
 
-static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
-{
-	kvm_mmu_reset_context(emul_to_vcpu(ctxt));
-}
-
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
 {
 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
@@ -7170,7 +7165,6 @@ static const struct x86_emulate_ops emulate_ops = {
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
 	.pre_leave_smm       = emulator_pre_leave_smm,
-	.post_leave_smm      = emulator_post_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 };
-- 
2.32.0.rc1.229.g3e70b5a671-goog

