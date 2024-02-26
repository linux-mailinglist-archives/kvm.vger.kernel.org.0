Return-Path: <kvm+bounces-9894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF858679A0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA083B2EA34
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A6212CD80;
	Mon, 26 Feb 2024 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OchYuHc4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722513666D;
	Mon, 26 Feb 2024 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958181; cv=none; b=F46dMhL42sUf9ofF4Ii3p508obrzbjFNHfTY4N/U1fM/uhmVTCDTqZVo3S5k/AtqZ76mmpvqZSa8rRbDdhf6VjSHnQ6oSxD8mk5AAmU1I0YooxL/Lc8Q/TfEG7JTuyx3F5umKSgUg7yVISpJ5PVqQQhhR/B9lABEeqZlb27uTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958181; c=relaxed/simple;
	bh=DrPI0FjABGzIoUG3fKSzVnoxo2ZVis3PQz/praGRAjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDCWiRJnC65f7tYLAX0WLuM5Mw3RAkgbkKni+SkRl0tGrScgVUEm6ElyDVH9C3X4LJL074SbgOWgN+nmjdgt79TFQU9WV4wVPSo/HTfz69ys5U5FaHQF0awk79Olw4ybzbIO1+cbi5LRo8J8005WLsai3THB5kc0/r6XPE9J0r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OchYuHc4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dbd32cff0bso21998925ad.0;
        Mon, 26 Feb 2024 06:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958179; x=1709562979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPbfhC/aAqAbSyaObXdyVLUFdRm0DA52iNK6y2iv5Zg=;
        b=OchYuHc4KxErK7dxZIet03ALcYYwqc6obL5xCoLAgp3gVAiSqQCMQcnL0Khj2uJbY/
         eWjkNnBPH+StnRNWHvZi9TTfmQlDpbu811ogRdAzPPz+WmooiJcyt+6egQSRWZ2MWCpl
         wCMs8UOPr0Jm8cl1LYcLlGx1Jt2Mx5y8PgzwoZ60jb45gIUF7x+511qg50r2n0r5RbKr
         ZhgGjF5gMwZqbcMCYDhRjit0eEZZ+aa9TUAlAPhTg9ZuF8Hp2K/jGj2L5cRwBDUFMUmD
         Gug8ybBUn15Jg/ybVh/5sC5/AeUvaYFqIeMOcjxy3FqjPVys+vNc8y2EKrWFBz4ULsfd
         LFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958179; x=1709562979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPbfhC/aAqAbSyaObXdyVLUFdRm0DA52iNK6y2iv5Zg=;
        b=BHcRS+1S2DwJDg+bZoEMS24I/JQVXiYyT7ffYJCKBRhve+sZ818jtWAnr+UE1WdiPr
         0w61z/gn3l1Dxswh/+qAD04nHgO4o744PPmfOX+xK8qHvWuFpywRRY+hTnmZwc5sUBDN
         03YuClW75hHGCcZRwDjdaNBhOTX37MJZbLocjuc2mM2Kobh9bHkElIiR162dxTnhH787
         WfgxkGwLJI77sdAI00r8ywH2Tds7orDav+LUJMmQVJnLfOjElAX7/idAI/FTA4Wca6oV
         LbNFZTOWiQA0+8y4Iv9sUAxLge/D153yskIuAPOUaiAMP06IVWDl5pRe5kra/SH9mG/z
         tjLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1H430rzzH/EXHDPBTwAhvkAsl3ncx2kxXKTJaH+DK9P90ekmyMBcqu2YiBXWwHqgRUUxu50zdSQE+D5t98EXEAiHq
X-Gm-Message-State: AOJu0Yxfjyxj7Q7M0zuAsY8L+t4WDW2Vk2lZIxIHPXzJc8naV7soV6VW
	rOVnWec42ou6z++DL4npoLgs3EKEJyI3l7RYogXEbpw0wLqQ1rkhuM/sjyrO
X-Google-Smtp-Source: AGHT+IG5rBMQsBjvkaIYNUuj+uXskXTIoKE+AQ7xs4oeIW/gqaIHEwUUGjBYF7X7C2QKKW1z6tgWRQ==
X-Received: by 2002:a17:902:e848:b0:1dc:722a:1e0a with SMTP id t8-20020a170902e84800b001dc722a1e0amr7156547plg.41.1708958179150;
        Mon, 26 Feb 2024 06:36:19 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id mm12-20020a1709030a0c00b001d8d1a2e5fesm4005783plb.196.2024.02.26.06.36.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:18 -0800 (PST)
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
Subject: [RFC PATCH 31/73] KVM: x86/PVM: Implement instruction emulation for #UD and #GP
Date: Mon, 26 Feb 2024 22:35:48 +0800
Message-Id: <20240226143630.33643-32-jiangshanlai@gmail.com>
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

The privilege instruction in supervisor mode will trigger a #GP and
induce VM exit. Therefore, PVM reuses the existing x86 emulator in PVM
to support privilege instruction emulation in supervisor mode.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 6f91dffb6c50..4ec8c2c514ca 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -402,6 +402,40 @@ static void pvm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 }
 
+static void pvm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+{
+	/* KVM_X86_QUIRK_FIX_HYPERCALL_INSN should not be enabled for pvm guest */
+
+	/* ud2; int3; */
+	hypercall[0] = 0x0F;
+	hypercall[1] = 0x0B;
+	hypercall[2] = 0xCC;
+}
+
+static int pvm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len)
+{
+	return X86EMUL_CONTINUE;
+}
+
+static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
+}
+
+static int pvm_check_intercept(struct kvm_vcpu *vcpu,
+			       struct x86_instruction_info *info,
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception)
+{
+	/*
+	 * HF_GUEST_MASK is not used even nested pvm is supported. L0 pvm
+	 * might even be unaware the L1 pvm.
+	 */
+	WARN_ON_ONCE(1);
+	return X86EMUL_CONTINUE;
+}
+
 static void pvm_set_msr_linear_address_range(struct vcpu_pvm *pvm,
 					     u64 pml4_i_s, u64 pml4_i_e,
 					     u64 pml5_i_s, u64 pml5_i_e)
@@ -1682,8 +1716,10 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_pre_run = pvm_vcpu_pre_run,
 	.vcpu_run = pvm_vcpu_run,
 	.handle_exit = pvm_handle_exit,
+	.skip_emulated_instruction = skip_emulated_instruction,
 	.set_interrupt_shadow = pvm_set_interrupt_shadow,
 	.get_interrupt_shadow = pvm_get_interrupt_shadow,
+	.patch_hypercall = pvm_patch_hypercall,
 	.inject_irq = pvm_inject_irq,
 	.inject_nmi = pvm_inject_nmi,
 	.inject_exception = pvm_inject_exception,
@@ -1699,6 +1735,7 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
+	.check_intercept = pvm_check_intercept,
 	.handle_exit_irqoff = pvm_handle_exit_irqoff,
 
 	.request_immediate_exit = __kvm_request_immediate_exit,
@@ -1721,6 +1758,7 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
+	.check_emulate_instruction = pvm_check_emulate_instruction,
 	.disallowed_va = pvm_disallowed_va,
 	.vcpu_gpc_refresh = pvm_vcpu_gpc_refresh,
 };
-- 
2.19.1.6.gb485710b


