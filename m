Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3112F4C4F4C
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiBYUJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiBYUJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:08 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D1C1F03AD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:35 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id r4-20020a92d444000000b002c26d0c9354so4182117ilm.15
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fYriT5sTbSgfVO4QQDGpq5qecvrAi6oVy79bePg6sX4=;
        b=Vcb7aYtUOA5chCsJa1T4h0PoJBp4GvbQqFJfS4NA0xSOOHYLIuayNrNwgpgZJDy2XZ
         Rn1nd85nukRjjzYmj+HhBpusJ6iLssFpNlbINQfbxy3QcS3F3NJZpsY03KZlfX7vQfG6
         yDWOA0FRNdxEcaBMY8lDl94YkBN2mHnhKk3uxg481x2fW8HsbZtd2Vbabz3WjLlrykeh
         9vlAHFf3QoElDmvqtgtgTxaZfx+xRjXXW4VPqdf75R30JZyCW4A+ShjJvdT8bQbNwfH+
         ltl76sFvBrqZfNZbAfowISys8awaYqHxHvOxKahWyoES8gB1p1jjvTIwy+xhSoHSe6Bd
         PSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fYriT5sTbSgfVO4QQDGpq5qecvrAi6oVy79bePg6sX4=;
        b=rgja17UDmMWZpIUpEmQggO9hFnPOgvXfYnuNdFKOfA3rljidaXktnHrFUVZFiouTx5
         fXLhJLu1TMa7fCxmI8F2618DnQGUAq7ZY0AxgMFKiCcmxfdlzxdmsY9HwDFW3W0MDEJx
         f/uhhl5m1UVhiqqNtfv6O8COEaxtHOmX+LnTTVZ41S4qKmflksTILE7ucVJgqY7fnvIp
         uQiKZ0SispP0xbUM2SKoJqLg8Q6mfmZzbj1UwJXxQ5t2Aig8euclCIC0itedeFTqcn+n
         +vvnq7PQH6hYYVq0RcvCm4FuMPXK088CyqJboIQeA1GQM5lZ5vB4iSvFX0tu0gpK2q7Y
         7bqQ==
X-Gm-Message-State: AOAM533n7YER5RGPfaDZ4Nj4Q4S+H2noCDdaJCqHlZmvfjWo2XcK4JdU
        O5VO6N5Iqe/guSpdLqa8KXcfS3Ep70bqy13qPJavUc9FCiJdECa6+/c1uP47qtk2fOuTw5jJREh
        Vw7/PQyor/ZlXGwF2GkfERe0oJ4RAzMCSUpfF6nJepMLk6BSH+9dCW1Bg1w==
X-Google-Smtp-Source: ABdhPJwKVsN8lyBfOpRTXxOeLVy4aPRQqE6sJNOZ6G8mUsyQIXjhQG3AHbCrwBBIXjfJgdQBWL3QrWrLfpI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:d10c:0:b0:641:63b2:9ef8 with SMTP id
 l12-20020a6bd10c000000b0064163b29ef8mr6616997iob.135.1645819714747; Fri, 25
 Feb 2022 12:08:34 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:18 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-2-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 1/6] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
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

Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
when guest MPX disabled"), KVM has taken ownership of the "load
IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
MSRs if the guest's CPUID supports MPX, and clear otherwise.

However, commit aedbaf4f6afd ("KVM: x86: Extract
kvm_update_cpuid_runtime() from kvm_update_cpuid()") partially broke KVM
ownership of the aforementioned bits. Before, kvm_update_cpuid() was
exercised frequently when running a guest and constantly applied its own
changes to the BNDCFGS bits. Now, the BNDCFGS bits are only ever
updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a
subsequent MSR write from userspace will clobber these values.

Uphold the old ABI by reapplying KVM's tweaks to the BNDCFGS bits after
an MSR write from userspace.

Fixes: aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
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
index efda5e4d6247..9617479fd68a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7242,7 +7242,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
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
2.35.1.574.g5d30c73bfb-goog

