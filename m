Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B3B4C83AE
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiCAGEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiCAGEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:46 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD360D84
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:06 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id u25-20020a5d8199000000b006421bd641bbso8079961ion.11
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hKYGlAUdZ25ql2C/Gsw0koexLM8OWhnhOaAg6E1WDkU=;
        b=PNbBxy7c6v9D2F9vFc4E0Fyd4ICAd/PH1o1iJlOdm6vtAsni+2laL0XjK0GitpaciV
         VaN3YUgrTfhnxvEll4rj4+8zz9dMk/caFNY7AGGwSBr9VAekIBCjAdxhHCh2UI2bYCej
         ZKoTeWtxs5qYmP6HbOpZAEPKNscAmd9M1XExYyXpHhOduQa+cBNaKJVVYbsRDPsX/o5I
         BOYJVApKuvpeHukdVlXwpJKfZoqSryRheXUXTFGcu1eswnCqsg327k1P9OTHzJuu5Os8
         MmDsxuIWXE+8/rkpZRkrFwrcgcm3DCNUlFyWIsmpyKvpezEkbWtt2XMgdEkBcZ0zUZyc
         943w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hKYGlAUdZ25ql2C/Gsw0koexLM8OWhnhOaAg6E1WDkU=;
        b=JZhk1Day2QVEuSVYg0qIFbWpIW/AoPi1ZCqJ/uHJiCmVNC6rhZp6Lr9FqCcoYRZa1Z
         ONBMNOxPI7C8Wi/j9DT7PVfCTyDMeVOQDqI4SZIClBy4PgcVSl3Fo4YnSE7EkKBHN1vs
         FMTk7vlwmAII1rTRuX85Nu6+ydUTaZjrXGO2IGLPXD/VvetF8oZPM7vyR98bCV0rtDhY
         ia08IyS8eiuoK6BmS0RGcBMny4Oc1q8+nw2Mqsyb+fiIspPJIE2+MFvreGE4UsSgHlox
         sphmqkp2QWGz68Nll/pTCBVaPih0v3IbDsxW8fTbg3G8ul29AUNnZtaaKaZt60yS5MSt
         k/zg==
X-Gm-Message-State: AOAM531ZHGxA6YqIoCKu9akkVOZdK/LyzWhTl9b5UYJSgab2Da3qucPN
        TRRXjZ9kXQOqunmfGjxLVApgqUvGvJT9d+V4ONpQusFWXNTglh6PG0YDqFYLoriWDeIOKSb+odV
        VuA9prOKzhRaX+FK2tMx+NqefbCK3I5JwTX07dGRR0GbNTKXHUwQhCHZuGQ==
X-Google-Smtp-Source: ABdhPJwNDxB3v29ycUUfRV/jirXb8eV4WfwkAb9bHnDgjPFmkRA3OSlTFzTQDSoU9N1uUIQWJyG0F/beEpI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:144e:b0:2c2:e890:2c7a with SMTP id
 p14-20020a056e02144e00b002c2e8902c7amr7814463ilo.103.1646114645543; Mon, 28
 Feb 2022 22:04:05 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:44 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-2-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
index 1dfe23963a9e..a13f8f4e3d82 100644
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
index b325f99b2177..3a97220c5f78 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7246,7 +7246,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
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

