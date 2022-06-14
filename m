Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9554BC23
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357147AbiFNUsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344972AbiFNUr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:47:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC7224586
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:53 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u10-20020a17090a1d4a00b001e862680928so4108106pju.9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/TuCx+mMC/wWO+wCOMNM3bKKbwcesvJBIffjbKO56Bw=;
        b=EXnkADu6RTXV+ib1jbxWSMLKVki7PKLtpXvmbrKGr1wxeZWUrsr61IsHWiwHEf0pfg
         qQZ3wjYx3pdYZQgdg3r+72YXMx7RcUwoMH3KcXd6ehSu5fKAu8tA8PfYyqlRowpbk0gg
         cWQ6geMtAhCjmdrTsw1XkaTXddSWFsOhm7BBj0Q6afoWf9dfCVGVrn9bUYCljrZLbMZt
         0QzEhPK0g13S4RBTn3zN1PoijTNol+n0QJmJKuE/qhvi41OZ7AUZuaj6TQZF8ggwlGPO
         6hOIufOCh/p2Vzffj9QPxCzA+r2W5rLEb63J7eMK39NUsXaL+PQJsIdItwEyz/zg04mN
         BF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/TuCx+mMC/wWO+wCOMNM3bKKbwcesvJBIffjbKO56Bw=;
        b=TsiDM9NrEZobK/Nr6wkgOIbqwS7d18xiGZOndYLfqIF/bk/y0GLsQG6UYukoErDYBE
         PU/scSDdWUPsQIHzgg5pU0Jd8IZQ8aclwOohxhxdNLhHN12md/mqyksjv7bGa68y7ejA
         qe24qjPHL80eXElakxAcOvej89YDbziolz3RuueMpD9dimZ8SBUsRyS/fbv2Zeu7Yie+
         ggpOlNkk+ZjiUFXyphEYRbCC/NOh4iOMgXnv06E4bn+x7DVjZBzjIqjoZwsgYEmFstuH
         sz0OpPkLo/+WL3dp7HnQDdAxgUzKeq2Jqggtyg9orj/FZkjz5mBR9lKrIFL372DgfuIU
         SnvA==
X-Gm-Message-State: AOAM530eMrDMcaOF+UVDdQwPmrngJ1Ee8VTKcAVbqdz2ntaYARtXv+z2
        sflMFUv5pdUuMOl783HcRBDcimFTRFc=
X-Google-Smtp-Source: ABdhPJz4TFfgEbPvptgdgeqmoRmXfp4kjzJF01Rq80AvhdYmZSiQbcvuoZiSx2RF+fw1ABPTREqfL1KbBAU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9f84:0:b0:51b:b64d:fc69 with SMTP id
 z4-20020aa79f84000000b0051bb64dfc69mr6543168pfr.7.1655239672654; Tue, 14 Jun
 2022 13:47:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:18 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 09/21] KVM: nVMX: Unconditionally clear mtf_pending on
 nested VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Clear mtf_pending on nested VM-Exit instead of handling the clear on a
case-by-case basis in vmx_check_nested_events().  The pending MTF should
rever survive nested VM-Exit, as it is a property of KVM's run of the
current L2, i.e. should never affect the next L2 run by L1.  In practice,
this is likely a nop as getting to L1 with nested_run_pending is
impossible, and KVM doesn't correctly handle morphing a pending exception
that occurs on a prior injected exception (need for re-injected exception
being the other case where MTF isn't cleared).  However, KVM will
hopefully soon correctly deal with a pending exception on top of an
injected exception.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d080bfca16ef..7b644513c82b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3909,16 +3909,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
-	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/*
-	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
-	 * this state is discarded.
-	 */
-	if (!block_nested_events)
-		vmx->nested.mtf_pending = false;
-
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3927,6 +3919,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
 			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+
+		/* MTF is discarded if the vCPU is in WFS. */
+		vmx->nested.mtf_pending = false;
 		return 0;
 	}
 
@@ -3964,7 +3959,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (mtf_pending) {
+	if (vmx->nested.mtf_pending) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
@@ -4562,6 +4557,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
+	/* Pending MTF traps are discarded on VM-Exit. */
+	vmx->nested.mtf_pending = false;
+
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-- 
2.36.1.476.g0c4daa206d-goog

