Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3957EAB9
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbiGWAvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiGWAvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA65B101F3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:44 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r6-20020a17090a2e8600b001f0768a1af1so5003472pjd.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dDbBsniYzHp/DkWFlMs8orp7Z4WhIFDdPFs5eLnWS08=;
        b=WyABck1LPPvjC6je72o/2E18L+yh/Fefg4gzXmU5uIknt5PWWm5Juk50jGnGUtiQnX
         hL+pyIBGmbbkOSj3PqffyytipWE5zL2OikSniX+VkGUBtgsE/QHMIORPqtS+ULO3Zsaa
         ip8JF1lShaoow/UOoWUm2xuTcdwdRR7wAlhiAa4RLE45hJ8wce19sHdZdHdllfSkLK6V
         LOqw13njtxrvL89XeQ7yv0bKFbXteI/wBieQBJ+L+BYTKD4Dbm0ODZNY2jIuJxf9MG75
         61waSCk9Pa1sLCf7zN07XU0d1YcML5jhU8F//+FbyNdZvfCA6QT4vDmCl3tA8S74YScj
         PyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dDbBsniYzHp/DkWFlMs8orp7Z4WhIFDdPFs5eLnWS08=;
        b=jToQvEF37ZknlaCFL/j5qXp2SoblLqeDxWR0wLzSv2tgIwPsuI9M65iV1B37FQxd1Q
         B/+nzd+708AfbE2XVdDX+F7BNQusv9pGXuFifHRWHbVjRWM3ljTtYzFri9CVZFczK2Zf
         MUURzlVa67uhC4NHPhKyocwQNjNxM8xE+NOSud5TvCIjKdR/oPdIWxnaXbVrNP/m61tu
         HVl7RwOe4oq8dQ59RBnHlize5Cb3R3DrydsI7LiCuzE6LIApJrKUaX6dqj6OVMBzz5XV
         u+F6xdryLKe7zMAE7h2wNMF1A0YrWgCBKg/Nx+biDWZbwQk+NgPiSmxNqDZZFfcVsPKl
         vtQA==
X-Gm-Message-State: AJIora9cxWNhSU5/wcELqGvVkUdtJprxTXqDJEUoC/UN9urj5S6s+HvX
        SvfgtWScDhW5ZQHFmUhXqdNL/OK3EoU=
X-Google-Smtp-Source: AGRyM1uJ5QTu58N+K9iKE/YpRT81L0TBA2fMLg0Trw/QkA46BeeOGxKp1UHrTTFXsIZm7jzXx47C/bCpyX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7784:b0:1ef:c0fe:968c with SMTP id
 v4-20020a17090a778400b001efc0fe968cmr19848862pjk.26.1658537504313; Fri, 22
 Jul 2022 17:51:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:14 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 01/24] KVM: nVMX: Unconditionally purge queued/injected
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index b9425b142028..a980d9cbee60 100644
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
2.37.1.359.gd136c6c3e2-goog

