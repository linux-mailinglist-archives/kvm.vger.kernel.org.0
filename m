Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE984943F9
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344753AbiATAGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344601AbiATAGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:06:30 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302CEC06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:06:30 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so2570934pgg.16
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=frZ7Kn6il6EA/Sc4lSu7iKex2wppY/L5v7EjTL3Zk00=;
        b=I16sXiQtWhOPCE5+QKwq7dmnACs5A1B/OmmgXUJxWlWfU2WSF1HVK7t1fJe6/kLCbp
         Gh3ch69F1EAmMUzPEydXEJ8O4j/GkCV6o7JMiH/LELYOFr83/pccJrOTTxfYq/+0d7ey
         XJsqGpUp2QFJARde2D/9Isv5MTjL29vboF8L2hgB1hXv19UvZZ0oRqFY1rFRkSOIWabd
         q7sDMcZx4YXipkQ7IqtqL2dSi+zUQypSwpOYOOdyjLcSl0esmYp74goKlbHAz3L598TS
         B+mRu/dLyNlkg6VyaG+Tx+vctza54r5KMbVTLmwTMSteMsZlAoxLbInOAbxSlZnwcuTQ
         n7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=frZ7Kn6il6EA/Sc4lSu7iKex2wppY/L5v7EjTL3Zk00=;
        b=IJvm5KqPoulhLPgsqMhGgBjlE10RXO/O5Xt/5NK7uP3N8nK0BIGzu7A3Gxo/ciNjJY
         MGhiHYbxebDK7dTqUrg53+N7zv7WslldAPkEsKreh9vX4wGVfGcPT6x7ovRV+nyA6CUl
         xcknZV8iNYsa9Ey7/2C6TP0DK53vFOEE6JjQZYtitJgnei1Nv7w/pqPe1D9AYVrtS1D3
         CHQxeQyunnjkQHIc+hH0HQRjatq0bVNMXMn0qKrE0bw0sDqYZq55G/XtLTWO2A7eUGYb
         8vskjKApVORiFCH+W7EAUn3qBSeHx81UzClFvKpADHU9QhXSFMtjsgYr8QFV9wP5f9fX
         VYag==
X-Gm-Message-State: AOAM5316RuSr5ir6fdmEXWyjXkJDzTC461aB3uotIYGXJjnVev8Bxa8f
        TI/XovATqnoBoDuH6rfay3yjFdKj1Qs=
X-Google-Smtp-Source: ABdhPJx1rp2WlxQ0mvrptdGhmccaJOJ0IV2q9N2i/NtSdyyrDpYZSLiCaci8oNY334GVJxXkOZxx2EXxcQQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab12:b0:149:c5a5:5323 with SMTP id
 ik18-20020a170902ab1200b00149c5a55323mr35793911plb.97.1642637189571; Wed, 19
 Jan 2022 16:06:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:06:24 +0000
Message-Id: <20220120000624.655815-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS
 blocking shadow
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS, a.k.a. the pending single-step
breakpoint flag, when re-injecting a #DB with RFLAGS.TF=1, and STI or
MOVSS blocking is active.  Setting the flag is necessary to make VM-Entry
consistency checks happy, as VMX has an invariant that if RFLAGS.TF is
set and STI/MOVSS blocking is true, then the previous instruction must
have been STI or MOV/POP, and therefore a single-step #DB must be pending
since the RFLAGS.TF cannot have been set by the previous instruction,
i.e. the one instruction delay after setting RFLAGS.TF must have already
expired.

Normally, the CPU sets vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS appropriately
when recording guest state as part of a VM-Exit, but #DB VM-Exits
intentionally do not treat the #DB as "guest state" as interception of
the #DB effectively makes the #DB host-owned, thus KVM needs to manually
set PENDING_DBG.BS when forwarding/re-injecting the #DB to the guest.

Note, although this bug can be triggered by guest userspace, doing so
requires IOPL=3, and guest userspace running with IOPL=3 has full access
to all I/O ports (from the guest's perspective) and can crash/reboot the
guest any number of ways.  IOPL=3 is required because STI blocking kicks
in if and only if RFLAGS.IF is toggled 0=>1, and if CPL>IOPL, STI either
takes a #GP or modifies RFLAGS.VIF, not RFLAGS.IF.

MOVSS blocking can be initiated by userspace, but can be coincident with
a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
is problematic only for CPL0 (and only if the guest is crazy enough to
access a DR in a MOVSS shadow).  All other sources of #DBs are either
suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
are mutually exclusive with MOVSS blocking (T-bit task switch), or are
already handled by KVM (ICEBP, a.k.a. INT1).

This bug was originally found by running tests[1] created for XSA-308[2].
Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
presumably why the Xen bug was deemed to be an exploitable DOS from guest
userspace.  KVM already handles ICEBP by skipping the ICEBP instruction
and thus clears MOVSS blocking as a side effect of its "emulation".

[1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html
[2] https://xenbits.xen.org/xsa/advisory-308.html

Reported-by: David Woodhouse <dwmw2@infradead.org>
Reported-by: Alexander Graf <graf@amazon.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a02a28ce7cc3..3f7b09a24d1e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4901,8 +4901,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		dr6 = vmx_get_exit_qual(vcpu);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+			/*
+			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
+			 * instruction.  ICEBP generates a trap-like #DB, but
+			 * despite its interception control being tied to #DB,
+			 * is an instruction intercept, i.e. the VM-Exit occurs
+			 * on the ICEBP itself.  Note, skipping ICEBP also
+			 * clears STI and MOVSS blocking.
+			 *
+			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
+			 * if single-step is enabled in RFLAGS and STI or MOVSS
+			 * blocking is active, as the CPU doesn't set the bit
+			 * on VM-Exit due to #DB interception.  VM-Entry has a
+			 * consistency check that a single-step #DB is pending
+			 * in this scenario as the previous instruction cannot
+			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
+			 * don't modify RFLAGS), therefore the one instruction
+			 * delay when activating single-step breakpoints must
+			 * have already expired.  Note, the CPU sets/clears BS
+			 * as appropriate for all other VM-Exits types.
+			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
+			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
+				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;

base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.34.1.703.g22d0c6ccf7-goog

