Return-Path: <kvm+bounces-9898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8306867904
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAFCE1C242E3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7F01384AE;
	Mon, 26 Feb 2024 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbTF86xe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247A6137C28;
	Mon, 26 Feb 2024 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958194; cv=none; b=IskGchOQhhtV498mrCMkKrMgH4EHwfkd38zyTefqoUB6iOqYcX8u4kg9R5En8YtUdfB3LJ/fxFT050MOtoQfHxQWABtIRxeUInswvvu3mI8NM01jrnJw0v16FWv8ZJCJ+KVOkOg0rNoTriFT4vttvGqK2Pyn4h666BkQt97dtFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958194; c=relaxed/simple;
	bh=TBy/bNE8b+sGzQQeRO6wKchQYra2E1+jmrOAziFjCG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XA3qLeYfp0gLlZqSc3V+xLYx8N86kRZUcnQt7zFD5D4xBIx8i6a/+dvA9KugU0Gr35D6ujV8HIyJE7+2K3u2WzUaUKbA4PneCdomeqRcTpX9WT7z1Ulxqm7HmfEQAUb3Ph3fvFJBLe7c5UCp8uUiqOZ7xH64kaA5wjchG5PmmQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbTF86xe; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e08dd0fa0bso2687626b3a.1;
        Mon, 26 Feb 2024 06:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958192; x=1709562992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r31fdmf865h0HOvGM8QPICowYa+OjjDSIGglWYpsdYg=;
        b=lbTF86xew8igCPX7Kxo6Qq8LBVTNC+jWBKSgCaQrKn7SiHqQ7377v5AYkRUriK1EGJ
         WtUMlCVONnUHt+YBWbuAOBAGQ4T0bl6Yd9hn4TsmjyNS+C5mVXQbprWV1A/ySeRbF6hI
         k26Prx3RHTsKQtcgpw0USJJ02Qtij5OEwSrGLwrmFBjIreQn1hsJv9izRVtvjdmNy8k6
         7Ewij0RJeYlXEnknQ+wbnhoT7+srLXAtCUEE1YzoT9a9vNf4sEtzZq1EN/IPtNqtLG1B
         NuQYidbEKB/uoPMUHOC8dcIP7haOc0NT1fHDTyKHLhS5bYAdM9UY7N08736EyXh+HooD
         d9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958192; x=1709562992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r31fdmf865h0HOvGM8QPICowYa+OjjDSIGglWYpsdYg=;
        b=tv8c7eJ57AnmJ4xFy/7oOfK+BmQas1QwPR7BmjAfAcQoqSGqxLR8Ovt5Idg2LevlD/
         W06ZpSc3LdrEP7OP3bwDDPKuFNp5Y75tLPjJa8VmVH4bp4sRsFXQL2z94WiNh/bhFl6j
         Hk6QAc/SCnPAaBW+BsrTIhkln4g8SLUw/Q/GuE2XfADchLBKEFIrlIGAwIG50epLdhth
         I6PkE9UH/q3twMH3zhNKAZ/zwctuglp8K4vjzMrLIq/jfsKbT4AwqeuUTUqiW6SRw6un
         BThOSVZ9Xj8HKYl3Ia0Lf3sRVVElF0KxrzE3SpLatMtD5DM+Xk962gKpU8tDLQnIdyn1
         /+bg==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ucg5EtKtSdlzvKX2U3n5f6J2yguYGKbGNvTUpcWlh8G5XFnnGqVDPYkUYIpHvzE99Iki1RZgc8p3wKuWt07SWahA
X-Gm-Message-State: AOJu0YyTij2vheVYR7NWdYi4eXddHbzNFMWKq5HUrO7ZuRKoxqG1ltIN
	sq++hIgBijDC6nMPTC2KAOMsPsb6pZO+69GpZv/IjXIHYETQ6OUVvLe3EziC
X-Google-Smtp-Source: AGHT+IEVd1oTp1pMqvLImfkxKHeXcEgGZK9UOD91jprlyG02MUCEiplvDZZwsZ4L49WqyJBbUJ03Mg==
X-Received: by 2002:a05:6a20:9f43:b0:1a0:694c:c467 with SMTP id ml3-20020a056a209f4300b001a0694cc467mr8755527pzb.14.1708958192240;
        Mon, 26 Feb 2024 06:36:32 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id h20-20020a635314000000b005dc1edf7371sm4012540pgb.9.2024.02.26.06.36.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:31 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 35/73] KVM: x86/PVM: Handle PVM_SYNTHETIC_CPUID synthetic instruction
Date: Mon, 26 Feb 2024 22:35:52 +0800
Message-Id: <20240226143630.33643-36-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The PVM guest utilizes the CPUID instruction for detecting PVM
hypervisor support. However, the CPUID instruction in the PVM guest is
not directly trapped and emulated. Instead, the PVM guest employs the
"invlpg 0xffffffffff4d5650; cpuid;" instructions to cause a #GP trap.
The hypervisor must identify this trap and handle the emulation of the
CPUID instruction within the #GP handling process.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 514f0573f70f..a2602d9828a5 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1294,6 +1294,36 @@ static int handle_exit_breakpoint(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static bool handle_synthetic_instruction_pvm_cpuid(struct kvm_vcpu *vcpu)
+{
+	/* invlpg 0xffffffffff4d5650; cpuid; */
+	static const char pvm_synthetic_cpuid_insns[] = { PVM_SYNTHETIC_CPUID };
+	char insns[10];
+	struct x86_exception e;
+
+	if (kvm_read_guest_virt(vcpu, kvm_get_linear_rip(vcpu),
+				insns, sizeof(insns), &e) == 0 &&
+	    memcmp(insns, pvm_synthetic_cpuid_insns, sizeof(insns)) == 0) {
+		u32 eax, ebx, ecx, edx;
+
+		if (unlikely(pvm_guest_allowed_va(vcpu, PVM_SYNTHETIC_CPUID_ADDRESS)))
+			kvm_mmu_invlpg(vcpu, PVM_SYNTHETIC_CPUID_ADDRESS);
+
+		eax = kvm_rax_read(vcpu);
+		ecx = kvm_rcx_read(vcpu);
+		kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+		kvm_rax_write(vcpu, eax);
+		kvm_rbx_write(vcpu, ebx);
+		kvm_rcx_write(vcpu, ecx);
+		kvm_rdx_write(vcpu, edx);
+
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(insns));
+		return true;
+	}
+
+	return false;
+}
+
 static int handle_exit_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
@@ -1321,6 +1351,9 @@ static int handle_exit_exception(struct kvm_vcpu *vcpu)
 		return kvm_handle_page_fault(vcpu, error_code, pvm->exit_cr2,
 					     NULL, 0);
 	case GP_VECTOR:
+		if (is_smod(pvm) && handle_synthetic_instruction_pvm_cpuid(vcpu))
+			return 1;
+
 		err = kvm_emulate_instruction(vcpu, EMULTYPE_PVM_GP);
 		if (!err)
 			return 0;
-- 
2.19.1.6.gb485710b


