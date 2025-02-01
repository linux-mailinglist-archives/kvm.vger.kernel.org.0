Return-Path: <kvm+bounces-37043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D62A24669
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55AEB165A46
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993E8180A80;
	Sat,  1 Feb 2025 01:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GkxcYgxu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383B514AD29
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374936; cv=none; b=NtX7v3n2Y4MD/NpLFofTA0YpLpZW5k2lmC+s/EXiFV4mXkUfW1PxavHdOrFd7lsSPZyyspEGsQlav1lGYq/ie8awYskCdlbcI7pxYDRrcCRO5AV2YeGgxB1nLYZXgmUwBqEiPh5uMcq3VXRHaDDcnNs5bzsHVWKkyo6RUkSzRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374936; c=relaxed/simple;
	bh=9iTUooTz+GzVh7vu6TOu+J68+KiYzSjVIC9jQQLaLOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NEcww78hJIU3MRW12KLyRq3/qUSsnm+/m3UhS12CPVO2+S6JqTOid0wruQmjPbvMXrv81+16NLprunT+FvkcxlreU36DZrgHTR5km41qDxht6q3ZjXHen7lloy9rEw/pel8/E4CUIgBAdg8Rina+HgV/zawz0sGoK1UzvIC1Yy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GkxcYgxu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef8c7ef51dso5129109a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374935; x=1738979735; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3XvAvsURv6o+VBrJhyeGBkEYBU2JVuvbJ6IwloO/TZA=;
        b=GkxcYgxu0vHUVBHp9OhoP7jzzjcnUoodKe9oW04kojqnxnyVLvpMRB0CzTr6V70GN5
         G+K/mKCruldubRQGcOZzIBNkpB8CBULmyHPJ6yMKUvFdR4uvf2ceZjBVL50WGQZL3d97
         9w7VQcNJLnOa1RippEhRgNAJoDmKJ1ThW7AhzDcDVkGipMrbNUWzWBRg+B/vqCPlmMNb
         Dt3axv0NOgefFiZ+fp9H+nFMg/y9/Sz0eURfmCwgyK3gpHF1N8VQHvmFSwxrRfYtvuTm
         8zt4obe9/8TrUaGjrAb71tlb3xKz5vzVFtGrpjoUpPrySEHvt7dCObV8jwQUZhqHhosf
         WB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374935; x=1738979735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XvAvsURv6o+VBrJhyeGBkEYBU2JVuvbJ6IwloO/TZA=;
        b=fwM1GxGnv0S4f5OnmPARFUyg6Fl1BaHENnlp4PiGq7Fm8pjKglILWjAeq7U7/97tUg
         gljXbYbyBJOiH5uU6iNZNTzdQmpk6hWQJ/Tjnf4QUHcvPmkXvJf2SzdpBY1Geku6Q/ss
         d8opf7DgmbwlWrTxLmWkyBpgKUpbXi/7vvKCe3F6u1IgrNs8EzVBE7X9HG0t5uHJvaxC
         mFvspL+vnqgkmYAL/jxkmxJp/8JXMiktoBtMwg1AHtzV9jr//dTt+NdAxkuesAFRq9o6
         l60qIEHeStebkQmKtVpGZCqDd+lXMSadruxIaK68DIgsWNuz6J0UNGKHqjff2Ycq6k/R
         Em5Q==
X-Gm-Message-State: AOJu0Yw2ULX7NkG4EjIRlbGrVVW8Z5c9G5Vj8l/5TatpafEdmbJoFCF+
	m2U7sqLNfvrt9xIXcUR5cl/TviCUPc8ofmpaTK1EJTj5aCReYFBhNGQVjx4gJb8XrhRnOZbmYGc
	54A==
X-Google-Smtp-Source: AGHT+IGOzvDdQI0HEUYlP00LQniZPDx482XdAtwcGW/8CaLpA5IH2YAm75ndxRKBH6ny5DWYhQDp8G6wGwM=
X-Received: from pjbeu13.prod.google.com ([2002:a17:90a:f94d:b0:2ef:85ba:108f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568f:b0:2ea:8aac:6ac1
 with SMTP id 98e67ed59e1d1-2f8464056b9mr14855857a91.15.1738374934730; Fri, 31
 Jan 2025 17:55:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:16 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-10-seanjc@google.com>
Subject: [PATCH v2 09/11] KVM: nVMX: Allow the caller to provide instruction
 length on nested VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rework the nested VM-Exit helper to take the instruction length as a
parameter, and convert nested_vmx_vmexit() into a "default" wrapper that
grabs the length from vmcs02 as appropriate.  This will allow KVM to set
the correct instruction length when synthesizing a nested VM-Exit when
emulating an instruction that L1 wants to intercept.

No functional change intended, as the path to prepare_vmcs12()'s reading
of vmcs02.VM_EXIT_INSTRUCTION_LEN is gated on the same set of conditions
as the VMREAD in the new nested_vmx_vmexit().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 arch/x86/kvm/vmx/nested.h | 22 ++++++++++++++++++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fb4fd96ce0f8..791e00d467df 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4618,7 +4618,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
  */
 static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			   u32 vm_exit_reason, u32 exit_intr_info,
-			   unsigned long exit_qualification)
+			   unsigned long exit_qualification, u32 exit_insn_len)
 {
 	/* update exit information fields: */
 	vmcs12->vm_exit_reason = vm_exit_reason;
@@ -4646,7 +4646,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 					  vm_exit_reason, exit_intr_info);
 
 		vmcs12->vm_exit_intr_info = exit_intr_info;
-		vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		vmcs12->vm_exit_instruction_len = exit_insn_len;
 		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 
 		/*
@@ -4930,8 +4930,9 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
  * and modify vmcs12 to make it see what it would expect to see there if
  * L2 was its real guest. Must only be called when in L2 (is_guest_mode())
  */
-void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
-		       u32 exit_intr_info, unsigned long exit_qualification)
+void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
+			 u32 exit_intr_info, unsigned long exit_qualification,
+			 u32 exit_insn_len)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -4981,7 +4982,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 		if (vm_exit_reason != -1)
 			prepare_vmcs12(vcpu, vmcs12, vm_exit_reason,
-				       exit_intr_info, exit_qualification);
+				       exit_intr_info, exit_qualification,
+				       exit_insn_len);
 
 		/*
 		 * Must happen outside of sync_vmcs02_to_vmcs12() as it will
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 2c296b6abb8c..6eedcfc91070 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -26,8 +26,26 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu);
-void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
-		       u32 exit_intr_info, unsigned long exit_qualification);
+void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
+			 u32 exit_intr_info, unsigned long exit_qualification,
+			 u32 exit_insn_len);
+
+static inline void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
+				     u32 exit_intr_info,
+				     unsigned long exit_qualification)
+{
+	u32 exit_insn_len;
+
+	if (to_vmx(vcpu)->fail || vm_exit_reason == -1 ||
+	    (vm_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
+		exit_insn_len = 0;
+	else
+		exit_insn_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+
+	__nested_vmx_vmexit(vcpu, vm_exit_reason, exit_intr_info,
+			    exit_qualification, exit_insn_len);
+}
+
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
-- 
2.48.1.362.g079036d154-goog


