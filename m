Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6374AA157
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiBDUrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBDUrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:11 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6010BC06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:11 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id i28-20020a056e021d1c00b002bdb4d7a848so3347794ila.16
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZzD3Qd5+UuG7KtmWYBVImdRfI9mhz2RqQAIMX8GTIfs=;
        b=VzmTT57UQrRncU8qeto8DeZbJQbtA0BTOZGSAljGg0xVtZ+rYGqdQ6Oh/4JCxeHh6t
         jlBIIyRIfGaif1Q7OSvhz10hoE8Q/HiEv6dgo5umfTdx6RXM9cP1AsKZGyshzMcxh2RL
         eKB7WwdrFCf4HRGWFzMJV2htSOsJCF659QKY+itizN2RvZQki5Cy1P21IwB8fDpFgTfQ
         GQFbGvujr9S/zdnJb80T4NULKv3g7ZxRE5rMig7De163xmlPrqV2UW89R8zWamQNVhFw
         YmZQ2QQ/ipA1kB2zHEaODeTzhilCCCsQ45xSYJ0TTf38vpViyEp0rb8fKnM241VyQPs6
         K29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZzD3Qd5+UuG7KtmWYBVImdRfI9mhz2RqQAIMX8GTIfs=;
        b=ry4NtuAa1ph5vhn2U/71/is5FYV384i9w43sD3KGo0TD1z2Fq3KGfrSy7efzLdKlQM
         Tk9Z7TvGRNU/Q2VZUyuLqsMUenqkX83MenTPM+xrZrXNeLMC4wpGgK5xUjwZsKDzNmwI
         PK/q7vIFk36x5BGOaOGnKaspjTsNlAF1xX/qIBhG6gj/FOeDyO3eOSIlFPeT+ptbn0YF
         HFyqxQ1RZDG2hbIPqzQnYgoQzdF+O2EmzYkzSapHcY1rVY7kMHl4BTvLxX5ea/gtbdjZ
         FLs2H5SrQbolc+YclI+CvgPpyAH/X8DJ63F1zK/YtrZLITy2qYUpVNQ+3GMSCDSEQjue
         hzJA==
X-Gm-Message-State: AOAM531O0On0GOg0u/hIu6u+ALjylWkonz5PPNkBXuUDmAK5BBLOB0X8
        SFAbCHMLbiyhbcIRt7C98QXMAGjMLuY2f2zsNtEaGrrtx+J3CzaPyifEdaOunnm1jS/yInjoSiC
        Yu45cF02oxyn75sWF1v8o2pWmsAjFDSUIdJEb9q2jTn7xKVxnbTutN1uM7g==
X-Google-Smtp-Source: ABdhPJznkZ+Ssj7CQPuYNsb8/U15o5Kq3Sx/nHARJvav4GGCg788syAR0J9SIFMhjcAvfSwXm19fr3FVwBM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:2804:: with SMTP id l4mr509115ilf.292.1644007630737;
 Fri, 04 Feb 2022 12:47:10 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:46:59 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-2-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
when guest MPX disabled"), KVM has taken ownership of the "load
IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
MSRs if the guest's CPUID supports MPX, and clear otherwise.

However, KVM will only do so if userspace sets the CPUID before writing
to the corresponding MSRs. Of course, there are no ordering requirements
between these ioctls. Uphold the ABI regardless of ordering by
reapplying KVMs tweaks to the VMX control MSRs after userspace has
written to them.

Fixes: 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ba34e94049c7..59164394569f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1291,6 +1291,15 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 	*lowp = data;
 	*highp = data >> 32;
+
+	/*
+	 * Ensure KVM fiddling with these MSRs is preserved after userspace
+	 * write.
+	 */
+	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
+	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
+		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca3ae2a02f3..d63d6dfbadbf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7227,7 +7227,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 #undef cr4_fixed1_update
 }
 
-static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f2c82e7f38f..e134e2763502 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -423,6 +423,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.35.0.263.gb82422642f-goog

