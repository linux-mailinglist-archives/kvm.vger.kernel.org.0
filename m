Return-Path: <kvm+bounces-37044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1AB7A2466C
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10F9A7A1B34
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96944192B76;
	Sat,  1 Feb 2025 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZC8sR7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F91A1741D2
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374938; cv=none; b=d61H3mipoYvSX6+8YXdHw98OCjI+saNE0hL8jaRW8L/Wz+KviKkXK8qqhSjDTIYdvca04L3f77nhIl4ON346ozukc/G0T+1t8F3TyWAMyOyAfSUaVuMTtbkGYqcoGobL+bwYM9bHcIt0YIYBDxDawoLcE+c3reeCa2cCu/yQwpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374938; c=relaxed/simple;
	bh=fM1n6FDclVKHXlvkcF8mqpqAtx9unY5xnqToGnbHTSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HykbCDXjanwjbTjiGgTrRGIAKuN369KEuDEhLDfja182e2wGydXqLUxoIYRziEUPRgK9zF0YL1LOve8hP5CgVxidiRX9cVOHnkVsJR8jEyB2sgwjmD7v17xONIrG+FnQ+XVqImO9lmvIFBy6i3DU2n9MMoZeXRJTxggfgzmccvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZC8sR7k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f816a85facso5031488a91.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374936; x=1738979736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3rffIwZzBf9w84td9LkYxb8GhDME9X7gCVMSc0UnAfs=;
        b=WZC8sR7k5BetvDrfTeU1Q4m0g6YPFGcOY/l+Hnzl6Vqr0Q0wLiUltxdw5n4TONAreX
         11hcStpGpCR9A9jBIIuaFomY9BfYoUUX/WlK47R994X4D0sL72xD12a39+/Ir1ts4lmN
         YoxJu7AFkkpmKq00QT1i3gf5HAJAjZvFLx1DZJc7Sa2f4hpqZOpVqJVvFBcBFisb6fqn
         Vxv1qwY4mFH6WbLr5rDRGj8cv8k2Sr6wU9dIqyPw0N4K8Hvzog1raXGDfE5IktH4VOsF
         Oj92rxUfHQPSFitYYgXVuXzQMvbnouLM5gta9S8oh2VR6J/7hctiFbV0d5uUXx4BvRWK
         VY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374936; x=1738979736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3rffIwZzBf9w84td9LkYxb8GhDME9X7gCVMSc0UnAfs=;
        b=UvT+e1kAdrZv4LgDaESKMjlMI8jfiqHZzFwcvGe4uk/NNHRdGgjvZD6kI+OyhbjeHV
         07iMvzqMnJIX7Djs183fSkVlkyKimzTV+VMiBr2aQiMdm5h7dEWwKhSzrs4XicHf5iqW
         Dt4eiBXVcKghEKie1pZHP/8RkGAf5A9o43w4OeNNG5qTNPneejhn1y8OYUkhqpArTULC
         PyekrO8nOW8e416ZCTzSWVtJ4Jm4JfRXp8irAexCYTtIPDlZFIi8bwQDlGHxNjatLPdI
         MV1MGTlgu7d1KDrqxy7ttajz9xPshOPh2KXp3ocng/9g0vZTctJwG3BXgAas3WUX4LD+
         M5Jg==
X-Gm-Message-State: AOJu0YzV1AKLrx620j9XpvsR+8Fh9tUiBk460btWkrOBiQObSmtVYEMo
	QwwV7aCNPAp1u1gDeihdV0Q+QsjXfUxtKNzG8487Vld8Lfez4p3kQeG95FGtgqwsO7WbkmBOeRM
	hgw==
X-Google-Smtp-Source: AGHT+IGBrZrpg8PhfwimecksOm2WshEEHhnGVFTAyj8Gg4iqO42wRkXAmfH9Cuj7cPTKzFEH7NV75D/W+ME=
X-Received: from pjbqi9.prod.google.com ([2002:a17:90b:2749:b0:2ee:4679:4a6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2709:b0:2ee:693e:ed7c
 with SMTP id 98e67ed59e1d1-2f83acb10c6mr22641043a91.33.1738374936503; Fri, 31
 Jan 2025 17:55:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:17 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-11-seanjc@google.com>
Subject: [PATCH v2 10/11] KVM: nVMX: Synthesize nested VM-Exit for supported
 emulation intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When emulating an instruction on behalf of L2 that L1 wants to intercept,
generate a nested VM-Exit instead of injecting a #UD into L2.  Now that
(most of) the necessary information is available, synthesizing a VM-Exit
isn't terribly difficult.

Punt on decoding the ModR/M for descriptor table exits for now.  There is
no evidence that any hypervisor intercepts descriptor table accesses *and*
uses the EXIT_QUALIFICATION to expedite emulation, i.e. it's not worth
delaying basic support for.

To avoid doing more harm than good, e.g. by putting L2 into an infinite
or effectively corrupting its code stream, inject #UD if the instruction
length is nonsensical.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 70 +++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dba22536eea3..7b2a6921f156 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8008,20 +8008,13 @@ static __init void vmx_set_cpu_caps(void)
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
-				  struct x86_instruction_info *info)
+				  struct x86_instruction_info *info,
+				  unsigned long *exit_qualification)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	unsigned short port;
 	int size;
-
-	if (info->intercept == x86_intercept_in ||
-	    info->intercept == x86_intercept_ins) {
-		port = info->src_val;
-		size = info->dst_bytes;
-	} else {
-		port = info->dst_val;
-		size = info->src_bytes;
-	}
+	bool imm;
 
 	/*
 	 * If the 'use IO bitmaps' VM-execution control is 0, IO instruction
@@ -8033,6 +8026,30 @@ static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
 		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
 
+	if (info->intercept == x86_intercept_in ||
+	    info->intercept == x86_intercept_ins) {
+		port = info->src_val;
+		size = info->dst_bytes;
+		imm  = info->src_type == OP_IMM;
+	} else {
+		port = info->dst_val;
+		size = info->src_bytes;
+		imm  = info->dst_type == OP_IMM;
+	}
+
+
+	*exit_qualification = ((unsigned long)port << 16) | (size - 1);
+
+	if (info->intercept == x86_intercept_ins ||
+	    info->intercept == x86_intercept_outs)
+		*exit_qualification |= BIT(4);
+
+	if (info->rep_prefix)
+		*exit_qualification |= BIT(5);
+
+	if (imm)
+		*exit_qualification |= BIT(6);
+
 	return nested_vmx_check_io_bitmaps(vcpu, port, size);
 }
 
@@ -8042,6 +8059,9 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			struct x86_exception *exception)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	unsigned long exit_qualification = 0;
+	u32 vm_exit_reason;
+	u64 exit_insn_len;
 
 	switch (info->intercept) {
 	case x86_intercept_rdpid:
@@ -8062,8 +8082,10 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_ins:
 	case x86_intercept_out:
 	case x86_intercept_outs:
-		if (!vmx_is_io_intercepted(vcpu, info))
+		if (!vmx_is_io_intercepted(vcpu, info, &exit_qualification))
 			return X86EMUL_CONTINUE;
+
+		vm_exit_reason = EXIT_REASON_IO_INSTRUCTION;
 		break;
 
 	case x86_intercept_lgdt:
@@ -8076,11 +8098,25 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_str:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
 			return X86EMUL_CONTINUE;
+
+		if (info->intercept == x86_intercept_lldt ||
+		    info->intercept == x86_intercept_ltr ||
+		    info->intercept == x86_intercept_sldt ||
+		    info->intercept == x86_intercept_str)
+			vm_exit_reason = EXIT_REASON_LDTR_TR;
+		else
+			vm_exit_reason = EXIT_REASON_GDTR_IDTR;
+		/*
+		 * FIXME: Decode the ModR/M to generate the correct exit
+		 *        qualification for memory operands.
+		 */
 		break;
 
 	case x86_intercept_hlt:
 		if (!nested_cpu_has(vmcs12, CPU_BASED_HLT_EXITING))
 			return X86EMUL_CONTINUE;
+
+		vm_exit_reason = EXIT_REASON_HLT;
 		break;
 
 	case x86_intercept_pause:
@@ -8096,15 +8132,21 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 		    !nested_cpu_has(vmcs12, CPU_BASED_PAUSE_EXITING))
 			return X86EMUL_CONTINUE;
 
+		vm_exit_reason = EXIT_REASON_PAUSE_INSTRUCTION;
 		break;
 
 	/* TODO: check more intercepts... */
 	default:
-		break;
+		return X86EMUL_UNHANDLEABLE;
 	}
 
-	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
-	return X86EMUL_UNHANDLEABLE;
+	exit_insn_len = abs_diff((s64)info->next_rip, (s64)info->rip);
+	if (!exit_insn_len || exit_insn_len > X86_MAX_INSTRUCTION_LENGTH)
+		return X86EMUL_UNHANDLEABLE;
+
+	__nested_vmx_vmexit(vcpu, vm_exit_reason, 0, exit_qualification,
+			    exit_insn_len);
+	return X86EMUL_INTERCEPTED;
 }
 
 #ifdef CONFIG_X86_64
-- 
2.48.1.362.g079036d154-goog


