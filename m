Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D42542273
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiFHA60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 20:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382392AbiFGXjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CEB176D7E
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h10-20020a170902f54a00b00166449db7f8so8080987plf.9
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xglW57R7dPrxeD1+iu7KlOWod3vvDTBjvAqs2DB9Tyo=;
        b=Z8n2j8d/l+NC3N9+mbSwNLqH3Dk5xFYh3W8mbYfNzq6SnxKTw2miTYcRgW55MA898M
         tmofR+kdMmdNHI4Ukui4H9GO2TaNKM1ORixz8VRgMCvGIBmAFOimwOB+cmuXfel+5/Q8
         wmI/GlXJFGuExnuB2R051rnXIKjHh8mXRiGXe0GsvU/ke6Z2UFuzAycPdzJLmrqYUVNt
         u0757aLcVkOOPfwGMK8VmL5NOw5E6tMyLH7XQY94dWQS5DUwDJMA4buwRvXpM0cNjGLX
         Ri77c5iIuMaAm6afVDTEFcuQgsRqJZPMXnoDhaUyRHigFNl1sYnLGmktT7uVpepWchos
         Hf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xglW57R7dPrxeD1+iu7KlOWod3vvDTBjvAqs2DB9Tyo=;
        b=FQ/GeQg+KDbt9iZ5IVA2+AUycLzrcapxyKe+UnfYL8yn+ni/sttN+lnUzqM9w7+wmy
         Pr9v6SScy8Xg4bCcYUMS1dWW7Ch6tUphiB5sZvSgKK1gpnzLyH6GmEjmJGqW2iUCq+CB
         mbnsEOX0GwFTAWLYVUR/dvzjRSSOa9UGNm9hDGbqITakN5Ef1zEPsZJZ8tMxnj4gGLIM
         IQTr5dYAlWjMvYfIiBXhxeN2c0rFX+7UINy7h1HG6tFgXzjT7Gup1OY+vWl8bX3HDue3
         NEl34fPuOSnuEiD+Xh6YmUiQU52BqIHvYctTvnBT54K6USNZPzF6fxx95w+VL6bSznPf
         o0qA==
X-Gm-Message-State: AOAM531VsNgEKQ3Sr1wR5lzjdzFJ9aAaQ4Y3XhGtUCqp3iwxOySeUiOF
        4y+UM058nTSjuC0ngAkhOFrw68M+Ig8=
X-Google-Smtp-Source: ABdhPJyYWskGfqg7Lzc1BANxoat/HX9oJuMU6eVjhdTVKgpGqjo/fAChIvEUAOBwu0ruJlwRyubKpPudm4k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9b8a:b0:163:d0ad:f9e8 with SMTP id
 y10-20020a1709029b8a00b00163d0adf9e8mr30305164plp.79.1654637791642; Tue, 07
 Jun 2022 14:36:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:57 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 08/15] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl
 bits across MSR write
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
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

From: Oliver Upton <oupton@google.com>

Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control"), KVM has taken ownership of the "load
IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.

However, commit aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime()
from kvm_update_cpuid()") partially broke KVM ownership of the
aforementioned bits. Before, kvm_update_cpuid() was exercised frequently
when running a guest and constantly applied its own changes to the "load
IA32_PERF_GLOBAL_CTRL" bits. Now, the "load IA32_PERF_GLOBAL_CTRL" bits
are only ever updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning
that a subsequent MSR write from userspace will clobber these values.

Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
vendor's vcpu_after_set_cpuid() after all common updates") still require
that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
the benign call in place to allow for cleaner backporting and punt the
cleanup to a later change.

Uphold the old ABI by reapplying KVM's tweaks to the "load
IA32_PERF_GLOBAL_CTRL" bits after an MSR write from userspace.

Note, the old ABI that is being preserved is misguided KVM behavior that
was introduced by commit 03a8871add95 ("KVM: nVMX: Expose load
IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control").  KVM's bogus tweaking of
VMX MSRs was first implemented by commit 5f76f6f5ff96 ("KVM: nVMX: Do not
expose MPX VMX controls when guest MPX disabled") to hack around a QEMU
bug, and that bad behavior was unfortunately applied to PERF_GLOBAL_CTRL
before it could be stamped out.

Fixes: aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
[sean: explicitly document the original KVM hack, set bits iff CPU
       supports the control]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f1671d7cbe4..73ec4746a4e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7413,6 +7413,20 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	/*
+	 * KVM supports a 1-setting of the "load IA32_PERF_GLOBAL_CTRL"
+	 * VM-{Entry,Exit} controls if the vPMU supports IA32_PERF_GLOBAL_CTRL.
+	 */
+	if (cpu_has_load_perf_global_ctrl()) {
+		if (intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu))) {
+			vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+			vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		} else {
+			vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		}
+	}
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.36.1.255.ge46751e96f-goog

