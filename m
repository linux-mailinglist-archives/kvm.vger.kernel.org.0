Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F018A4D58E3
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346006AbiCKD3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346007AbiCKD3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:10 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D48BEB313
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p5-20020a17090a748500b001bee6752974so4417640pjk.8
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=I+0PCK08cjf4M6d/EijWO6MxFUvmgvYBy0yuwDtEnpk=;
        b=gSWPnigYbX/RC9U7qKUlH9roio4rflbomJk7Ap7DYKERzce0Iionv/jdFxt70QdlHi
         1wnOabBbi4hvTonv1Inf9a7CfmQHGagoM0DdCPUHi6X9lHD+DqFYxyVWh+dkk2V7flUx
         6YkCA0sAONc025Unx9uYQagsk49dsH4TBmpXGcT7PF87bxMIgigQbLBVn9I5AhpWGT01
         De7ZCA0sQOaN6UjiioD3taDE+i2ciZe8/QxNJIs1FGzwjvR46avRUNveVp4hHEbonFd4
         JTl3+oHXtzjGUiM4ULQe9m85BYR+9lMbndDabaxrq8ISO9RMHBPkerPiLNCiCbUBO65i
         CYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=I+0PCK08cjf4M6d/EijWO6MxFUvmgvYBy0yuwDtEnpk=;
        b=dyx3LgSQXm5wiql8ieN2Dj9IsW0vq2jNo3Zik/U/H5iwYfsBiXDmRw5dZb8G9NlwLM
         mtFLt2uKRyZF577MOD0Rp0Z5aDrWuHzUJMasxgWOg7lzPv+GsIaV1xJb0kQViKPhypQD
         sGEd9ot7srHs+MVwhO/WcqT6nYf6SQXXTg6pT9r7yUf8pMgxnVSnQqSVhhSqYC+PvH0Q
         pFpcym6yPQjW9XRn8wdARCOiSlH/HJO04ikCql/FsziwIqIiU4XQMyuNgbnEwRGA5f7m
         hz7RPJWez2rhNEUV5cbuXqiHEnxPuXviLWphppHGQ5DQWJhcpst+SWJD7vvTWtgTvPUj
         B53A==
X-Gm-Message-State: AOAM533QfVNBZ7EPVnSjN28ad18K+oRFMV6Hiq/bH47wzaEYYpiOWgbe
        csq7F4ZbwfoIEEC/5ipyn1O6BSoqbxk=
X-Google-Smtp-Source: ABdhPJwLdSK+KhhkYT2ZHcDo1u9dHFKUt+OzU3gMQIT20p0hhay4A2TMQWO48JBhg7usPwbX1PAQcgsKfvg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:124f:b0:151:76bc:6e0b with SMTP id
 u15-20020a170903124f00b0015176bc6e0bmr8632554plh.81.1646969287475; Thu, 10
 Mar 2022 19:28:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:42 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 02/21] KVM: nVMX: Unconditionally purge queued/injected events
 on nested "exit"
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
---
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..f09c6eff7af9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4233,14 +4233,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -4582,6 +4574,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
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
2.35.1.723.g4982287a31-goog

