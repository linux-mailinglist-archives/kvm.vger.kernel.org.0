Return-Path: <kvm+bounces-32687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B869DB10E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C21ABB26119
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E6675809;
	Thu, 28 Nov 2024 01:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nLM7Wh+4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B81C07E4
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757736; cv=none; b=OKUJtJhl/TcI0XLACgeWRCyhTnSgDXOSm4lX9S5do0A1M78yxNT7BMPHIrKgbWnMOSyDJ+qSv14QKQUEaSHOofeC7OAKkkIXrUmvflPLOiIs4Ilh/pwhs5SjbVGqbJRw+COriXjyLyhKNcURuci+WuNSDUED9KUCFuNBIq5/6Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757736; c=relaxed/simple;
	bh=jYievFQLmO0ZX/bL0PmetV/5+n0Jtb0BaFQ/3AUzG/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LbVhG4Md4sdkaEjdxwTxGJIXMSLqfpUraNf1We9m4gB/l008U/M3qmXHuX5hhH/e5nrcumdU/81Xg9mMuOU7YFY4QykcIDXjzmh6AVdiniMTh7kk8UOLu52NjL+wjbDcZlgqJXO9eSnDtlVnNR66xyA3PUJ3CeFMN8eYgQdBL0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nLM7Wh+4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea764112f8so513418a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757734; x=1733362534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zfhwkjabiK9i1U3++Dnns7vu53NPqBBvKZSCWfVqk6g=;
        b=nLM7Wh+4qqTDlqTHNwEqc/wIVpKmw9xgagxwvsMZW6exXLiQq3X1whX1l5mt2RK26N
         Li43kXIyp2+IgPSdnSXmZNJ6b4HXro0Ae+EDcrEZwE/9pCCd9vq/u2V5YXVfuHzP8hrU
         GvN74u/h9WeVmVvwo2fcJBCBTbped0psJhS2yTEIwnWNTaUiDGY2VpRF7lkARhowW1cA
         KGj1cdjPTyL0EsTo5pK2orX/+iAdjd2Bah3ca9aRCvx+pZCAH2J6IhGGz2HP97nXWe78
         FqJ7RD9f4z33uTbRp4dUxUUduNVxHKBteIjHCpVuZ1Sj8scYRcYY78PxEgUnOsVifLRr
         t41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757734; x=1733362534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zfhwkjabiK9i1U3++Dnns7vu53NPqBBvKZSCWfVqk6g=;
        b=L3++vb8h9aIGykW9u/rdpezRRQftIg43/azhaJYGkpQnu/ipR4T+Am/BGRUGF1fmT8
         GypkhWnkOzVxWnkrt3wH0uU+cgdImaM8DIcQDsc8hf/cU61YhK62hWPcsXinVlebjJth
         uitAJdN6M/rfttWnHnjw3eXrnYBUPzBZL6G0oY7a3HSBi1Y4gHxBk0Yvf4q0QCE0vnsr
         LQq4Phz+w3VKfX4zF5jgWhtj6AFKdLTrdxKmLogReKEvJ0veqxh6aN2Z3FAaASATqa1k
         /C6NhhfQ2t0A9gjyGPHk3kSvmXcsh6vLB7ARv6lUAf841hMk8tRVGRGYv3YMUBBHr6/x
         wVwQ==
X-Gm-Message-State: AOJu0YyNDpt/cU/ynR/48Ir6QO7GJm039qxKk+/ZrGPVz2l8eHe1ppZd
	cAueBTuvtvS/b4vOfJ2F6SOAMA712gdE1krQGFtybA0Gnicyt2vwAlZmSM99bs23zpILZ5xZngk
	V9A==
X-Google-Smtp-Source: AGHT+IFxxUsXqKXde7ZelUqTghKoxGn+dhYam6XzQdK6/qbfWvV5DM6aYxLSeMquxqy1kR2q1AUWR13riCk=
X-Received: from pjbsj16.prod.google.com ([2002:a17:90b:2d90:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b91:b0:2ea:4c8d:c7a2
 with SMTP id 98e67ed59e1d1-2ee097bf314mr7300159a91.24.1732757734557; Wed, 27
 Nov 2024 17:35:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:03 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-37-seanjc@google.com>
Subject: [PATCH v3 36/57] KVM: x86: Remove all direct usage of cpuid_entry2_find()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Convert all use of cpuid_entry2_find() to kvm_find_cpuid_entry{,index}()
now that cpuid_entry2_find() operates on the vCPU state, i.e. now that
there is no need to use cpuid_entry2_find() directly in order to pass in
non-vCPU state.

To help prevent unwanted usage of cpuid_entry2_find(), #undef
KVM_CPUID_INDEX_NOT_SIGNIFICANT, i.e. force KVM to use
kvm_find_cpuid_entry().

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fb9c105714e9..150d397345d5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -135,6 +135,12 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
+/*
+ * cpuid_entry2_find() and KVM_CPUID_INDEX_NOT_SIGNIFICANT should never be used
+ * directly outside of kvm_find_cpuid_entry() and kvm_find_cpuid_entry_index().
+ */
+#undef KVM_CPUID_INDEX_NOT_SIGNIFICANT
+
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -144,8 +150,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(vcpu, 0x80000008,
-				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
 
@@ -157,7 +162,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
-	best = cpuid_entry2_find(vcpu, 0xd, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -211,7 +216,7 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 	u32 base;
 
 	for_each_possible_hypervisor_cpuid_base(base) {
-		entry = cpuid_entry2_find(vcpu, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		entry = kvm_find_cpuid_entry(vcpu, base);
 
 		if (entry) {
 			u32 signature[3];
@@ -258,7 +263,7 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(vcpu, 0xd, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -269,7 +274,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(vcpu, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -280,22 +285,22 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = cpuid_entry2_find(vcpu, 7, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-	best = cpuid_entry2_find(vcpu, 0xD, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = cpuid_entry2_find(vcpu, 0xD, 1);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = cpuid_entry2_find(vcpu, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		best = kvm_find_cpuid_entry(vcpu, 0x1);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
@@ -309,8 +314,7 @@ static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_cpuid_entry2 *entry;
 
-	entry = cpuid_entry2_find(vcpu, HYPERV_CPUID_INTERFACE,
-				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
 	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
 #else
 	return false;
-- 
2.47.0.338.g60cca15819-goog


