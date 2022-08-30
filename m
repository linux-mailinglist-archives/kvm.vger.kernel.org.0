Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0BA5A71B0
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiH3XTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiH3XS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:28 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45D9A3457
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m11-20020a17090a3f8b00b001fabfce6a26so5454247pjc.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=6ySBpcF4lKWLS5C3rbGFno/maiuEG4amRlwLIYIj7Fw=;
        b=Fp+ybHU7tXWGco9N1mrxhlVMyaP8GG7vmr4K7HvHUqLX5LmaaDPqvcowp32xViDG1G
         RbYaxDcSyhp0DWJrGHw2dqiyfmqAyPxRdpWWJl2ygQYLp8/GewC2D+aMfUlkmNvogHWx
         KXKsWUB+Da6fTuodQ5uHGWM9jmXcHsNp82w05l7+lr+tnI64uPiHm0B5xj8e1ahkDGsh
         ryVJMwxtbZ9OXhqTbSQDyFAnyfpvYMuCOmIbHUu/seRDplNey5UmDrj4URJNPsACtJD3
         atdEjiWrEXMuKA9H+2u5hV2EWTtJAX7XRiCwO+QqAFxH9KGyLO+OgJfPoORBLi3tflcJ
         TrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=6ySBpcF4lKWLS5C3rbGFno/maiuEG4amRlwLIYIj7Fw=;
        b=0YJsdBHiTd/ia8JbShMxv4N9OayQaH7FzTrsiVcYIiexsHBRsP62dKPBYNxGVDc+D6
         JHoTbhPeKYKnYS2XJFdrpiy+G+ax8L5gJRMLtB8lhOF4uyJddV57LiU0To7TGDl6kF8o
         ESPFhVtIwl1NdVO3zIPwIY3aM9zww8+KShHno6ISNoQ1x4W79BHm5Gip/N0DVrwMCczH
         cwvKj28K1Vp80Eq0gfo8wx8WPvgXkWfqMsmuDIlH6UwWQ4lD9uH3t1ha984OvrdTS1ur
         Hs2eds4n6SFBluSAHWpqDrDPnOgaxuH596iextPgdicVnpbLjlX6DfE397XhX/HbnNnc
         MBhw==
X-Gm-Message-State: ACgBeo3AJnaoYhPnFX/nsInr4Z9nFSMWN3oNvNYEHMVl+v3PEIrFCeVi
        aehYp4odIlWD+Cq15QAKMjlUbEBxqeM=
X-Google-Smtp-Source: AA6agR6pjTyrc/T678JckRIztZpU3eppXKLhLEgPILC99Mj8Juy4l2Gh7YhdtIkxfxYol078VGaIoj+vimM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c7:b0:171:2818:4cd7 with SMTP id
 q7-20020a17090311c700b0017128184cd7mr22786217plh.136.1661901410547; Tue, 30
 Aug 2022 16:16:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:07 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-21-seanjc@google.com>
Subject: [PATCH v5 20/27] KVM: nVMX: Document priority of all known events on
 Intel CPUs
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a gigantic comment above vmx_check_nested_events() to document the
priorities of all known events on Intel CPUs.  Intel's SDM doesn't
include VMX-specific events in its "Priority Among Concurrent Events",
which makes it painfully difficult to suss out the correct priority
between things like Monitor Trap Flag VM-Exits and pending #DBs.

Kudos to Jim Mattson for doing the hard work of collecting and
interpreting the priorities from various locations throughtout the SDM
(because putting them all in one place in the SDM would be too easy).

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 83 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b76c69c50649..ec954ca8a0e3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3908,6 +3908,89 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
+/*
+ * Per the Intel SDM's table "Priority Among Concurrent Events", with minor
+ * edits to fill in missing examples, e.g. #DB due to split-lock accesses,
+ * and less minor edits to splice in the priority of VMX Non-Root specific
+ * events, e.g. MTF and NMI/INTR-window exiting.
+ *
+ * 1 Hardware Reset and Machine Checks
+ *	- RESET
+ *	- Machine Check
+ *
+ * 2 Trap on Task Switch
+ *	- T flag in TSS is set (on task switch)
+ *
+ * 3 External Hardware Interventions
+ *	- FLUSH
+ *	- STOPCLK
+ *	- SMI
+ *	- INIT
+ *
+ * 3.5 Monitor Trap Flag (MTF) VM-exit[1]
+ *
+ * 4 Traps on Previous Instruction
+ *	- Breakpoints
+ *	- Trap-class Debug Exceptions (#DB due to TF flag set, data/I-O
+ *	  breakpoint, or #DB due to a split-lock access)
+ *
+ * 4.3	VMX-preemption timer expired VM-exit
+ *
+ * 4.6	NMI-window exiting VM-exit[2]
+ *
+ * 5 Nonmaskable Interrupts (NMI)
+ *
+ * 5.5 Interrupt-window exiting VM-exit and Virtual-interrupt delivery
+ *
+ * 6 Maskable Hardware Interrupts
+ *
+ * 7 Code Breakpoint Fault
+ *
+ * 8 Faults from Fetching Next Instruction
+ *	- Code-Segment Limit Violation
+ *	- Code Page Fault
+ *	- Control protection exception (missing ENDBRANCH at target of indirect
+ *					call or jump)
+ *
+ * 9 Faults from Decoding Next Instruction
+ *	- Instruction length > 15 bytes
+ *	- Invalid Opcode
+ *	- Coprocessor Not Available
+ *
+ *10 Faults on Executing Instruction
+ *	- Overflow
+ *	- Bound error
+ *	- Invalid TSS
+ *	- Segment Not Present
+ *	- Stack fault
+ *	- General Protection
+ *	- Data Page Fault
+ *	- Alignment Check
+ *	- x86 FPU Floating-point exception
+ *	- SIMD floating-point exception
+ *	- Virtualization exception
+ *	- Control protection exception
+ *
+ * [1] Per the "Monitor Trap Flag" section: System-management interrupts (SMIs),
+ *     INIT signals, and higher priority events take priority over MTF VM exits.
+ *     MTF VM exits take priority over debug-trap exceptions and lower priority
+ *     events.
+ *
+ * [2] Debug-trap exceptions and higher priority events take priority over VM exits
+ *     caused by the VMX-preemption timer.  VM exits caused by the VMX-preemption
+ *     timer take priority over VM exits caused by the "NMI-window exiting"
+ *     VM-execution control and lower priority events.
+ *
+ * [3] Debug-trap exceptions and higher priority events take priority over VM exits
+ *     caused by "NMI-window exiting".  VM exits caused by this control take
+ *     priority over non-maskable interrupts (NMIs) and lower priority events.
+ *
+ * [4] Virtual-interrupt delivery has the same priority as that of VM exits due to
+ *     the 1-setting of the "interrupt-window exiting" VM-execution control.  Thus,
+ *     non-maskable interrupts (NMIs) and higher priority events take priority over
+ *     delivery of a virtual interrupt; delivery of a virtual interrupt takes
+ *     priority over external interrupts and lower priority events.
+ */
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-- 
2.37.2.672.g94769d06f0-goog

