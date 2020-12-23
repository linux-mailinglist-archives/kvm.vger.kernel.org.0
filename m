Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6861F2E1D8B
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 15:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgLWOpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 09:45:51 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43011 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLWOpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 09:45:50 -0500
Received: by mail-wr1-f41.google.com with SMTP id y17so18827568wrr.10;
        Wed, 23 Dec 2020 06:45:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=/RYWY/ozUzONgf/e8tkqi1F1m1XJVpNw0P3pUzv1ZE8=;
        b=X5+/Yo+mIvjsomxG9bItqm/LYiN44HTZO9dPshAARGhb2uaHn9Dj886EowJUeblVdO
         KyZ7r7j1VOdPEzfIlXofnyd9j+p+RNm4Ul/rrWV1On23LbCXoYsqXc71/3qh8+Ql5zZq
         2pIpVHRmanv4sCO3ezx05oYIA/5uTfN1pXrS9SLfcL+WXJuUrndEMs77ltqFSTxMhUoe
         KCiTKUzzav4Qd/OSqvE1ut7HO/NR2qgZxxTdLhvNpW3/ueLnUzRgdayfEmsYPvOCvb1U
         AtPqi6gTt9efY7myAbAwyhYvvCeMr/761eonzrBxf3piHMYJHquvhbLDZfE9Y+EG9rmH
         bYtA==
X-Gm-Message-State: AOAM533hKP7UfqqAwvcJlsuRN+4Fl/XgOVAPOxABhwVztAQ37SK5ngiv
        0jTt7X7gGc3KIKkQBtvFayc=
X-Google-Smtp-Source: ABdhPJzooqwx43SF6qvhRQyu88Dxbeu+iMIJK0mMPr7+eYzTZFzd16bPD4io+4sIJ33XfsCrvRJk2A==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr29641501wrv.384.1608734708673;
        Wed, 23 Dec 2020 06:45:08 -0800 (PST)
Received: from [127.0.1.1] (87.78.186.89.cust.ip.kpnqwest.it. [89.186.78.87])
        by smtp.gmail.com with ESMTPSA id h9sm46305wme.11.2020.12.23.06.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 06:45:08 -0800 (PST)
Subject: [PATCH] kvm: tracing: Fix unmatched kvm_entry and kvm_exit events
From:   Dario Faggioli <dfaggioli@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lorenzo Brescia <lorenzo.brescia@edu.unito.it>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
Date:   Wed, 23 Dec 2020 14:45:07 +0000
Message-ID: <160873470698.11652.13483635328769030605.stgit@Wayrath>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>

On VMX, if we exit and then re-enter immediately without leaving
the vmx_vcpu_run() function, the kvm_entry event is not logged.
That means we will see one (or more) kvm_exit, without its (their)
corresponding kvm_entry, as shown here:

 CPU-1979 [002] 89.871187: kvm_entry: vcpu 1
 CPU-1979 [002] 89.871218: kvm_exit:  reason MSR_WRITE
 CPU-1979 [002] 89.871259: kvm_exit:  reason MSR_WRITE

It also seems possible for a kvm_entry event to be logged, but then
we leave vmx_vcpu_run() right away (if vmx->emulation_required is
true). In this case, we will have a spurious kvm_entry event in the
trace.

Fix these situations by moving trace_kvm_entry() inside vmx_vcpu_run()
(where trace_kvm_exit() already is).

A trace obtained with this patch applied looks like this:

 CPU-14295 [000] 8388.395387: kvm_entry: vcpu 0
 CPU-14295 [000] 8388.395392: kvm_exit:  reason MSR_WRITE
 CPU-14295 [000] 8388.395393: kvm_entry: vcpu 0
 CPU-14295 [000] 8388.395503: kvm_exit:  reason EXTERNAL_INTERRUPT

Of course, not calling trace_kvm_entry() in common x86 code any
longer means that we need to adjust the SVM side of things too.

Signed-off-by: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: kvm@vger.kernel.org
Cc: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
Cc: Dario Faggioli <dfaggioli@suse.com>
---
 arch/x86/kvm/svm/svm.c |    2 ++
 arch/x86/kvm/vmx/vmx.c |    2 ++
 arch/x86/kvm/x86.c     |    3 +--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143a6f80..ed272fcf6495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3741,6 +3741,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	trace_kvm_entry(vcpu);
+
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..ff20f9e6e5b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6653,6 +6653,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return EXIT_FASTPATH_NONE;
 
+	trace_kvm_entry(vcpu);
+
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..a79666204907 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8973,8 +8973,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.request_immediate_exit(vcpu);
 	}
 
-	trace_kvm_entry(vcpu);
-
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
@@ -11538,6 +11536,7 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);


