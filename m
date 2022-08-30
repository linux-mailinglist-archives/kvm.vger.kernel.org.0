Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8F55A7188
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiH3XRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiH3XQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:16:46 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA38696EC
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id j192-20020a638bc9000000b0042b23090b15so6085572pge.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ZlynD2151oAwoVetBZOi7ygkuiFbrmF9qnEbeilSaHk=;
        b=sW9B9SLCPv5zTB8B7Fiify7VlWOcvvPppU5ir+i6uzPnaTl8E2HyJpqa2R/2WmMSwY
         ecEecOG1/Xu+vJomiRWhB7S3JLY+HnlJcWomwIJjekLwfUyJtSYi3jsLlijpBPASrdUp
         hRD9p5uufXXSE7j5YmZCtxVZ7eBdyJ+qps1Wn1CKOqyvYS2nyV6K9W4wdEBGRb6syGJr
         NDxLQYZ1oR2w95a2Z+X9McwPsoKnW1DoA2ekhRX1wPMieLhP1BRLIxS4VjYlrMqCVv6h
         6rEV77Pn8/8xy4flunM19T1whsgGBnUQFe2CHqSoSllmL7OsHvQpZMd0iSWJ3lfLq3kq
         G8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ZlynD2151oAwoVetBZOi7ygkuiFbrmF9qnEbeilSaHk=;
        b=x+c3howxA1UWL7xszZik8YNLfLqz6fCPtHuGg2RNJWbsR9WyMayF80tBQyjthsz5hg
         HH3RLuAPOW2BnJvXfuAG2jZP1yecB7zZ7k8CGN2yYfbPMQYCpHiMK2vXpmahlRbwtXN6
         yVl5BAjHRVs/v7bN0vDBiYS2Kp9K577A3S0cI+wgGo4x/ODWRpkuj1MlM0+6JHrbA3d7
         wlxQtFnnOBukBmts4AuyHTyMfHI+pk5EcCLIJxY7pp+JmGz7z/ygALFoWoHSIA9k1XkU
         fJaMX20v/a+l7ZZG/zD/i/S67C6mbXx986JQ5Z8z1lVTiizPwnOWMI61pPYFvmLJToe5
         QCkw==
X-Gm-Message-State: ACgBeo3j/GrSL1VuoZdMbxlJQz3LU7MixSq0ehvwVrjlh4aIlGIcVuee
        OVzlbAclESV3SGTVY5b+H0bJh9NQNGw=
X-Google-Smtp-Source: AA6agR5ardEOM1vUttPFlIZwPDoClV3JBCEUdeIemWGtCUXWy+yd11oFjAIkUOIh++12NAYBBHHZQ53S4dQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1496:b0:52f:734f:9122 with SMTP id
 v22-20020a056a00149600b0052f734f9122mr23792706pfu.85.1661901378626; Tue, 30
 Aug 2022 16:16:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:48 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-2-seanjc@google.com>
Subject: [PATCH v5 01/27] KVM: nVMX: Unconditionally purge queued/injected
 events on nested "exit"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop pending exceptions and events queued for re-injection when leaving
nested guest mode, even if the "exit" is due to VM-Fail, SMI, or forced
by host userspace.  Failure to purge events could result in an event
belonging to L2 being injected into L1.

This _should_ never happen for VM-Fail as all events should be blocked by
nested_run_pending, but it's possible if KVM, not the L1 hypervisor, is
the source of VM-Fail when running vmcs02.

SMI is a nop (barring unknown bugs) as recognition of SMI and thus entry
to SMM is blocked by pending exceptions and re-injected events.

Forced exit is definitely buggy, but has likely gone unnoticed because
userspace probably follows the forced exit with KVM_SET_VCPU_EVENTS (or
some other ioctl() that purges the queue).

Fixes: 4f350c6dbcb9 ("kvm: nVMX: Handle deferred early VMLAUNCH/VMRESUME failure properly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..ca07d4ce4383 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4255,14 +4255,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			nested_vmx_abort(vcpu,
 					 VMX_ABORT_SAVE_GUEST_MSR_FAIL);
 	}
-
-	/*
-	 * Drop what we picked up for L2 via vmx_complete_interrupts. It is
-	 * preserved above and would only end up incorrectly in L1.
-	 */
-	vcpu->arch.nmi_injected = false;
-	kvm_clear_exception_queue(vcpu);
-	kvm_clear_interrupt_queue(vcpu);
 }
 
 /*
@@ -4602,6 +4594,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		WARN_ON_ONCE(nested_early_check);
 	}
 
+	/*
+	 * Drop events/exceptions that were queued for re-injection to L2
+	 * (picked up via vmx_complete_interrupts()), as well as exceptions
+	 * that were pending for L2.  Note, this must NOT be hoisted above
+	 * prepare_vmcs12(), events/exceptions queued for re-injection need to
+	 * be captured in vmcs12 (see vmcs12_save_pending_event()).
+	 */
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
+
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
-- 
2.37.2.672.g94769d06f0-goog

