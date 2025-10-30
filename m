Return-Path: <kvm+bounces-61516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 411D6C21D47
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 639B94E9D13
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBEC36E342;
	Thu, 30 Oct 2025 18:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y5zcmqUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773123BD17
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850209; cv=none; b=ucaWVRz4vjpThM08nDhb079MprXx4r0+C0lNzuSP3LMnrbNnfOU6SjWHi7OBgzLSUxQ9BJ2k1CeptqFSweE6MJ+baYw0C97sqAhJz4Hn5UUnUuLvVwPn1PkoI/JcaoOBbtsOUWcFfH8FDzrIQr6gs/YhCOGk5zftakaCNOzswy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850209; c=relaxed/simple;
	bh=A+WDfzdXC40Sq/9wrvjPlPLDo/3gwYMZ9f+8uEEuYZk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qRLXJiDOFgEJn13KMcPmjHZpSswJa+G7f9PQ9keTfdEFOdSJauwA/5NAXmvMNyO7VUnwarahhAOyd3F64DCLPgeAeyF3UfNRDD6JRsxwWcecwbQM50D8A0MClm2DNBB7RU1mdzbdjoS+WrNkFmLk8KthTrNmA7vS/9O0an9VLQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y5zcmqUs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340299cc2ecso1527900a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761850207; x=1762455007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhASEPgcAJIgjSND95sOQSORkzyJK56v/9+vwSD9zco=;
        b=Y5zcmqUsUB0RvR+q7ldKAyQD9FGd/BWxiOghynSGU1BF1G1nbajPbH1t/+LwWhkd8u
         IPNKfewA8oO249REiq29UqCJfAz0oCViuMVcngkFprd+xNGZowVg5fhVx+kkcfCoI5Al
         NueOUvWfLvqq9b2XwWjvcVzfNAWYI5fGgjFeQtZF3W7j8qkKnCWxyhoPa1bfYC/NZxLJ
         PPDRWVzrHWIaEuL6bbX63+cwA7dCDG56cuVL+36ChcfLJN6S0GDW6gAd6oa4LIkGLF90
         HybXwJ7Qe/54wafBc2uBEss+ProgSUwZKE/cPk+ojfg4dL9MCTtpPFlKHwSK6XMtFVH0
         lbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850207; x=1762455007;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GhASEPgcAJIgjSND95sOQSORkzyJK56v/9+vwSD9zco=;
        b=efXhytOgUQe00MSUMaUZ/07Jj5ocTBhFhGNjnfWc8bpPGjdJM6x73b7ZAqG+fcQez8
         43zqj+ji+JXYPiFDcckktSonC6GIXpQMbx88yZYo58j8UpfgcueZ5a2Ungy63R+dhX/D
         5S3MY830CQzhy10n5BQRyjIefuv229b5GZuC805uNh4rYPf7WZfcYIrOn7ru+/yGSrAF
         ddCXkVilVf7051Zec0Zo3OGYrCHTtWi7VQQCU1F+pHeUxsnzvwu2OKmsTly04tRokWke
         C1+3RIdKk8nR7XMY591IUKxyK3FM5ust90q7VnqcQpNqDOPrKL03NLAgEokrWclw/FkV
         458w==
X-Gm-Message-State: AOJu0YzsFHIvwtEam2hOlpkslmcnysX4wDNkW129uwuLYv29ugD9oC8J
	nQa2hWXqojrLPdI+UVDFX+aSq5tJEjtlOVGZyxMi5IB6XxE1p7cwJSMrd6HPDt3D5GHf5KA9cRN
	TtF9gPg==
X-Google-Smtp-Source: AGHT+IEyImF3y4s/FXpVuZsZYGpbmF0ZTyfGO9w0HTZqVW16uZesyicU7fWy0+6LcBB/GlDQMIo6mUdtepY=
X-Received: from pjbbf20.prod.google.com ([2002:a17:90b:b14:b0:33d:9628:960e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b4c:b0:340:767a:221f
 with SMTP id 98e67ed59e1d1-340767a2300mr2068608a91.4.1761850206851; Thu, 30
 Oct 2025 11:50:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 11:50:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030185004.3372256-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
code that fills the exit reason and CPU when KVM encounters a VM-Exit that
KVM doesn't know how to handle.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          |  7 +------
 arch/x86/kvm/vmx/tdx.c          |  6 +-----
 arch/x86/kvm/vmx/vmx.c          |  9 +--------
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 5 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..4fbe4b7ce1da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
 void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
+void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa..83e0d4d5f4c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
 
 static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
 	dump_vmcb(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..079d9f13eddb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2145,11 +2145,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	}
 
 unhandled_exit:
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = vp_enter_ret;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	kvm_prepare_unexpected_reason_exit(vcpu, vp_enter_ret);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1021d3b65ea0..08f7957ed4c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6642,15 +6642,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
 
 unexpected_vmexit:
-	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-		    exit_reason.full);
 	dump_vmcs(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_reason.full;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..c826cd05228a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9110,6 +9110,18 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_event_vectoring_exit);
 
+void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason)
+{
+	vcpu_unimpl(vcpu, "unexpected exit reason 0x%llx\n", exit_reason);
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_unexpected_reason_exit);
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;

base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
-- 
2.51.1.930.gacf6e81ea2-goog


