Return-Path: <kvm+bounces-9903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5EE867910
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4461C23D17
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100D513A261;
	Mon, 26 Feb 2024 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcY5fNCO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366513A24B;
	Mon, 26 Feb 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958210; cv=none; b=mAic7tQJamEvk2mUX4yXWLu8evAynvgsBjjpNLqcyqxnvbZy6L4x8b3kctTewg5oAc4CyILsH7CoNlZqm4oU7t3dw+VgE8cqyXIqL+qtfZnmoduFmJBD1L1iciQ0uEc4VNb8jmIQrDwdXqKQvPvoTE8uokePNQLKD9mxxJCnK9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958210; c=relaxed/simple;
	bh=Ck1F5Gy12w7sgnoP3E6l6/tEBdI4swyAdKim2OPHJkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q01tUHmz1uz9lemeYdA1o33qHOx3YTQ+nVIq0Vh+OKs9oKPwmJ5wn+9ReGIawmt2tA4m7wK/8zZJ3FIcuXkb8qDBrIKW5GEu4mNBCVXsCuhNkrBa14caoBPsbWOl4Op5wC+7Z3mkxORjOtPUOLgXZqxDM9yWyBYTLqP4Y9pj6w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcY5fNCO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dc96f64c10so9032825ad.1;
        Mon, 26 Feb 2024 06:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958208; x=1709563008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ruju1XhRDDaW6b1WJ3BMmV9hOYmSG+m9SE28NxmRmbc=;
        b=BcY5fNCO7iH1NAuaKAnSOMKpaH94O9SyXnF1k6O5byIUZ/TY1tiGwDQROgXk0OTRp8
         CHdXOLqY9uJgYm6JQYAkgYlZ7XBd/hcsbB5RMM0pP4JgmkZDb6kWekx9fFezbzB1h1Lt
         bnRASG2/nu9dVfe32vdrX0Wxq/KbywZRMTKiafgylBoWp/kTYxh0NtSIWpTO93vBvuux
         2WtRd6INLd7QIcXWof+az/WSD33M61MWFYBPVmc8GJd8fMGA1Wlg/E/Pk5ZDwslCNYo/
         Z1BNxPpv0uMLksNXdH1p2Vfna98S8PcpAia7WLVSv6nWjiD9PKk/HzPcbgUYZCw/jUPp
         +18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958208; x=1709563008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruju1XhRDDaW6b1WJ3BMmV9hOYmSG+m9SE28NxmRmbc=;
        b=WMj0LQRLx8Qg2wB/m79h6rgin7iJ6rZeChf072Bxq4Xiijdk/FWxGqC1HM7/k+SnIm
         CMDUgtMKLyluFbs5TbJmp2TPqgd2VVdMpTgxQ/gW199tqVWF/blTwG/BxRR6fhe0XU3E
         Kb81Fq58J0+iSC3qI2ZOtmQ5EGl+Pnrrs79uvLFt/skZhuqWX46rxMkRJzEzFE7ny/7g
         3aH2wlMZnw9zvv+7Ug+ptLagBASl6RrLNTn6SND8AWU7pMB/HePRi4t1f5I4xLosv7hj
         4Ub3uM1+KJWd6EW6Q5FFJ3gvP4uzp7ySkB8Zz+4NhrlIsmlJT8CvPnDbs64R0jUSUkTP
         ALGw==
X-Forwarded-Encrypted: i=1; AJvYcCVIMGBO1ACj2Jbh/Gpgsy+JsELC5OFTriEx9fYmdvvYPHXiC4ojitChfwC2ZDpKCUSD556ylW3RG8p5lkSk0uHomCF7
X-Gm-Message-State: AOJu0YzMXJmVh9/SwSSTuyxzVKrivN+iD4Rj7hmJO6vg7lFVNXUFLNh7
	5Gl+F/JoJW0ShDru9mdW7p/WfK/5zybdW1m9+Wg//0rPSzbNwikiltI8xiMt
X-Google-Smtp-Source: AGHT+IE7smdj7NwrDT3NNyZiEHYf8vaUn/EqAmZtnBzXvryKXBZoXfIAi/pXWEgFE4lZlYJ9YXmLmw==
X-Received: by 2002:a17:902:d4c7:b0:1dc:94f6:3326 with SMTP id o7-20020a170902d4c700b001dc94f63326mr4099780plg.18.1708958207963;
        Mon, 26 Feb 2024 06:36:47 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902b70500b001dcabe7a182sm1219740pls.161.2024.02.26.06.36.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:47 -0800 (PST)
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
Subject: [RFC PATCH 40/73] KVM: x86/PVM: Handle hypercall for loading GS selector
Date: Mon, 26 Feb 2024 22:35:57 +0800
Message-Id: <20240226143630.33643-41-jiangshanlai@gmail.com>
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

SWAPGS is not supported in PVM, so the native load_gs_index() cannot be
used in the guest. Therefore, a hypercall is introduced to load the GS
selector into the GS segment register, and the resulting GS base is
returned to the guest. This is prepared for supporting 32-bit processes.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index ad08643c098a..ee55e99fb204 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1528,6 +1528,75 @@ static int handle_hc_invlpg(struct kvm_vcpu *vcpu, unsigned long addr)
 	return 1;
 }
 
+/*
+ * Hypercall: PVM_HC_LOAD_GS
+ *	Load %gs with the selector %rdi and load the resulted base address
+ *	into RAX.
+ *
+ *	If %rdi is an invalid selector (including RPL != 3), NULL selector
+ *	will be used instead.
+ *
+ *	Return the resulted GS BASE in vCPU's RAX.
+ */
+static int handle_hc_load_gs(struct kvm_vcpu *vcpu, unsigned short sel)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long guest_kernel_gs_base;
+
+	/* Use NULL selector if RPL != 3. */
+	if (sel != 0 && (sel & 3) != 3)
+		sel = 0;
+
+	/* Protect the guest state on the hardware. */
+	preempt_disable();
+
+	/*
+	 * Switch to the guest state because the CPU is going to set the %gs to
+	 * the guest value.  Save the original guest MSR_GS_BASE if it is
+	 * already the guest state.
+	 */
+	if (!pvm->loaded_cpu_state)
+		pvm_prepare_switch_to_guest(vcpu);
+	else
+		__save_gs_base(pvm);
+
+	/*
+	 * Load sel into %gs, which also changes the hardware MSR_KERNEL_GS_BASE.
+	 *
+	 * Before load_gs_index(sel):
+	 *	hardware %gs:			old gs index
+	 *	hardware MSR_KERNEL_GS_BASE:	guest MSR_GS_BASE
+	 *
+	 * After load_gs_index(sel);
+	 *	hardware %gs:			resulted %gs, @sel or NULL
+	 *	hardware MSR_KERNEL_GS_BASE:	resulted GS BASE
+	 *
+	 * The resulted %gs is the new guest %gs and will be saved into
+	 * pvm->segments[VCPU_SREG_GS].selector later when the CPU is
+	 * switching to host or the guest %gs is read (pvm_get_segment()).
+	 *
+	 * The resulted hardware MSR_KERNEL_GS_BASE will be returned via RAX
+	 * to the guest and the hardware MSR_KERNEL_GS_BASE, which represents
+	 * the guest MSR_GS_BASE when in VM-Exit state, is restored back to
+	 * the guest MSR_GS_BASE.
+	 */
+	load_gs_index(sel);
+
+	/* Get the resulted guest MSR_KERNEL_GS_BASE. */
+	rdmsrl(MSR_KERNEL_GS_BASE, guest_kernel_gs_base);
+
+	/* Restore the guest MSR_GS_BASE into the hardware MSR_KERNEL_GS_BASE. */
+	__load_gs_base(pvm);
+
+	/* Finished access to the guest state on the hardware. */
+	preempt_enable();
+
+	/* Return RAX with the resulted GS BASE. */
+	kvm_rax_write(vcpu, guest_kernel_gs_base);
+
+	return 1;
+}
+
 /*
  * Hypercall: PVM_HC_RDMSR
  *	Write MSR.
@@ -1604,6 +1673,8 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 		return handle_hc_flush_tlb_current_kernel_user(vcpu);
 	case PVM_HC_TLB_INVLPG:
 		return handle_hc_invlpg(vcpu, a0);
+	case PVM_HC_LOAD_GS:
+		return handle_hc_load_gs(vcpu, a0);
 	case PVM_HC_RDMSR:
 		return handle_hc_rdmsr(vcpu, a0);
 	case PVM_HC_WRMSR:
-- 
2.19.1.6.gb485710b


