Return-Path: <kvm+bounces-37042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9D2A24668
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78FB93A3CC4
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EF115D5B8;
	Sat,  1 Feb 2025 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0dgpIlbX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723A1534FB
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374935; cv=none; b=I2u/aVHMybSOMQsdiHMlfCbG5mrYrRxAvjtLA86d+ugyl4m8g9ggRjINC0hk/fD6ZEbsOyokfQybRXR/dxh6Bdu1KXd26ev3ffNHuCa3j2X5m2ylb8sEylBl+hp6UA54M0r4GmktOo07iSLlTh48P60stkdJjbM1TJXmF7PtRTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374935; c=relaxed/simple;
	bh=U3aXYtXvj8rJ6en4q57EqfG8FlNrWEsTovi78JWBpUA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b9Djie6nsPRwl0Mw7few7foUN9BWigKO4QrCWSanttzB8l0gMLalLUtNI1B/IcVDFR2/YkQy5bOh9tmYvwVr3qDZEmZ9RFpg7gBcyD4fR148i/C8V298RxZyBnqxCXXoar78BHkoptKoluJCrlUS8HsFwgkQ3cQGHEh3PJKbYwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0dgpIlbX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso4988292a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374933; x=1738979733; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v6o3I4DBxjxkxXVmgva/ae+3lJMpdQxl+ZvTS60XPAM=;
        b=0dgpIlbXH/nk/f+ntCR66WCWi/dJgWHyos7+TcjRTir2R2E0YiHc8DlenTQu+1AoCr
         uq2NOpg9P/wetKjvuO1pguoWkFXeI6G5J1GUQiEt9rDvYnfvjdMBRw0Rw0/L1tmdKXHO
         0S3+ftzo+1Fa7H9x/zVBzzwnnXWrcKZQ34Tn2R2jWA29wj7Muu6wmphUfzV+J18S5fss
         2Vfz13DMInf5peD8VGGJ2Z7H9C27qstEpz03YyCSX0qkbyOd6MOcq5naf5C7xhghRYaO
         JoeHGYtVV0JanVuyD2xrFXqgsffnonm+sptkugnB0580g+q/MGblVzdJ3Mgx97JwcLU4
         MLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374933; x=1738979733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6o3I4DBxjxkxXVmgva/ae+3lJMpdQxl+ZvTS60XPAM=;
        b=WSNSKjC5fEG/ruEhf2ZZADxyKUMTV+L7CgSdIzxds10Eg+OD5XcKLFTMRfqGw128k+
         WAheUjWagD9oFfoAnfPEYw7+QlF74TchHAMVgnYvaoRZRiwbgFzU5Xs83giezmBg6H6D
         +hzWPAXNIO0CUfMgcVMg0kaViAkYTC5/6eCwxYMyMG4kbtOQofyrcyRgrst/6JewMGIU
         IMy+08/TMbaNUABY9y+2wgrkaQULM8NGPUIaOvZsydj7qFah/jwDKEdoRDjG1G4U6MCd
         X1IHmsuQp/dU02uHMx+y6yUurJCsksPFs2ms/+j/zzPqVMNlvuiBOBCU2LTadmbFVTjB
         w3Rg==
X-Gm-Message-State: AOJu0YySQlQSVt8X81dvceMC7y9o3pKlf9sXmrV+I/3Xf22/4/SOFdiT
	iVhgN+hU4XgK51jnDSgQanGeoduhK+i9OVLx3AfV4030mofG2x5MGignGPYnx2colj6uqGyhXJ1
	IxQ==
X-Google-Smtp-Source: AGHT+IEJyl6b/CyC+v0x5BmLUOl5YD0/ntJw9qfYUQQK6gKPQKvDqtvewlO1PBrsM/VzRTPHCwo9rVN/4f8=
X-Received: from pjbpx11.prod.google.com ([2002:a17:90b:270b:b0:2e9:5043:f55b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:3de4:b0:2f8:4589:a305
 with SMTP id 98e67ed59e1d1-2f84589a325mr13600663a91.1.1738374932981; Fri, 31
 Jan 2025 17:55:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:15 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-9-seanjc@google.com>
Subject: [PATCH v2 08/11] KVM: x86: Add a #define for the architectural max
 instruction length
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a #define to capture x86's architecturally defined max instruction
length instead of open coding the literal in a variety of places.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_emulate.h |  4 +++-
 arch/x86/kvm/trace.h       | 14 +++++++-------
 arch/x86/kvm/vmx/nested.c  |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 35029b12667f..c1df5acfacaf 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -275,8 +275,10 @@ struct operand {
 	};
 };
 
+#define X86_MAX_INSTRUCTION_LENGTH	15
+
 struct fetch_cache {
-	u8 data[15];
+	u8 data[X86_MAX_INSTRUCTION_LENGTH];
 	u8 *ptr;
 	u8 *end;
 };
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 0b844cb97978..ccda95e53f62 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -830,12 +830,12 @@ TRACE_EVENT(kvm_emulate_insn,
 	TP_ARGS(vcpu, failed),
 
 	TP_STRUCT__entry(
-		__field(    __u64, rip                       )
-		__field(    __u32, csbase                    )
-		__field(    __u8,  len                       )
-		__array(    __u8,  insn,    15	             )
-		__field(    __u8,  flags       	   	     )
-		__field(    __u8,  failed                    )
+		__field(    __u64, rip                              )
+		__field(    __u32, csbase                           )
+		__field(    __u8,  len                              )
+		__array(    __u8,  insn, X86_MAX_INSTRUCTION_LENGTH )
+		__field(    __u8,  flags       	   	            )
+		__field(    __u8,  failed                           )
 		),
 
 	TP_fast_assign(
@@ -846,7 +846,7 @@ TRACE_EVENT(kvm_emulate_insn,
 		__entry->rip = vcpu->arch.emulate_ctxt->_eip - __entry->len;
 		memcpy(__entry->insn,
 		       vcpu->arch.emulate_ctxt->fetch.data,
-		       15);
+		       X86_MAX_INSTRUCTION_LENGTH);
 		__entry->flags = kei_decode_mode(vcpu->arch.emulate_ctxt->mode);
 		__entry->failed = failed;
 		),
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8a7af02d466e..fb4fd96ce0f8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2970,7 +2970,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		case INTR_TYPE_SOFT_EXCEPTION:
 		case INTR_TYPE_SOFT_INTR:
 		case INTR_TYPE_PRIV_SW_EXCEPTION:
-			if (CC(vmcs12->vm_entry_instruction_len > 15) ||
+			if (CC(vmcs12->vm_entry_instruction_len > X86_MAX_INSTRUCTION_LENGTH) ||
 			    CC(vmcs12->vm_entry_instruction_len == 0 &&
 			    CC(!nested_cpu_has_zero_length_injection(vcpu))))
 				return -EINVAL;
-- 
2.48.1.362.g079036d154-goog


