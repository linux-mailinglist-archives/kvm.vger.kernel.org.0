Return-Path: <kvm+bounces-9897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B98867993
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2847BB2F407
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27500138485;
	Mon, 26 Feb 2024 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhF8/ckU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFB137C49;
	Mon, 26 Feb 2024 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958191; cv=none; b=iD7zM9SG4iCzG5N5oeKgrnZXQoh5dZgBv0ss0grFaw5ISCQPOcMI+U4OW2TZ1I1DwRxDszuRDeoAcsslRLr5/AQFmC9FpALOFTqmP7VmvjhG5b+JETh1ASOqxyQGuzKRJPdMKOoY9cPF7/sVGz+Ay0+2KOUeytXsTTzJZP6t49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958191; c=relaxed/simple;
	bh=psHI8zxpnvNzC6HzjO8u2HuTrjxyl16doUd1Ga+thcE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=awtGEWSIULOspr6vIW7QEq0z9SbgHP34oybpAN3S1t03IEopOtJDzEfwURGxhkRpXOF73hxlklHTvONJsrHD6II7RgNKuKMRx84pDLCW4BXP4wv9rDCGi+iWhzlMZcBE1/G3ny6PI5KzCB0yqLxf5z1i0CSD961/7vfM6y3dIaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhF8/ckU; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e457fab0e2so1882673b3a.0;
        Mon, 26 Feb 2024 06:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958189; x=1709562989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQ/nS0bgBloNdtpxFga4Mz7X6Yf8rS35YXtEExYA9cI=;
        b=OhF8/ckUC6I4X2JVgIc0RRMIJTttTBpAbGEYPhkjbSm/ZRI0iu5GVIaZ3GYFU/5JZo
         qvZd6Yuxl9kkP8cBJUDzTpzlPpmUTG0uvOCWrHW71Z3s763krArxkNPN4exaAoe0Dqm1
         K2z/M1o5apPUorx4oc/NCCVh3iJqIllq4b7oboW+O9EqcC50Hpdqj1LZ1mky17TAt8dy
         0aoAHhJLI9wZ0DbFqiActbO1mUJDN3cTc769mmx72hKJhd9ZqBcK24kl9Hmv7Jy+ClfP
         I91DGnu3fsBxHaKI6VftZqhwzIOdMzIBj8aq64U1XoziBvXnmsoGwzpK9Lg1k2DgEIwU
         Bm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958189; x=1709562989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQ/nS0bgBloNdtpxFga4Mz7X6Yf8rS35YXtEExYA9cI=;
        b=M0XthRboPolxGd330ywkJdcY0SZsih5VN/pVQuXIsNxemq1AmUUutYvROUBt7wzhO0
         JdUdZ0zYKwOq602No0hqiZSanwUyjM7CPoD7ZJwf7yzkwNoBFCqaFzUG9kG10koLuVRQ
         K7dZ9mp26WYeBEFR9Nol9M5wqH/qhlOUuEraLIyaXWEbVBxHYaMeQrWQKLv0ABdxU6hI
         0KVLF6sM4GdDI7yhK8a4b7xavo5DT0JwFttmA/5qk6yh/2LJ93faK2B25Ge7N/Jaav1D
         OeyTSbgp/OVhpg6pCbNYTR/LxLwT2XD6NytrPFi/IVgO+hVtu4tR8QuZOHhGbRfJpF7a
         eEIw==
X-Forwarded-Encrypted: i=1; AJvYcCV/9r7+9VCLzULlpyTaUrKOB2EkBsIkTX/VpIOFhzxgekzSv3GpF/TebZIY5pieCFxdaKQVCKsFSsNII5g+splS5PZ5
X-Gm-Message-State: AOJu0Yx7beuKR3re804e+ZnULV65OcwmelfB+SKDXiX8gpak5FoSZXA/
	s+6vAgVirTEPQTNtW9KCNgTErkwb0SNYD0IiLG7tHxhVVenZmP5+UyzcZhVo
X-Google-Smtp-Source: AGHT+IG2wXl5b5ObFHNLA75gIkPTapG8hUSmdxDiOsx492fO/MObCAdwGggzwvMH2P2Zznwt4ZBAwg==
X-Received: by 2002:a05:6a20:c888:b0:19e:cbe9:63b with SMTP id hb8-20020a056a20c88800b0019ecbe9063bmr8230483pzb.3.1708958189007;
        Mon, 26 Feb 2024 06:36:29 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id v6-20020a626106000000b006e53e075d60sm672837pfb.70.2024.02.26.06.36.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:28 -0800 (PST)
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
Subject: [RFC PATCH 34/73] KVM: x86/PVM: Handle ERETU/ERETS synthetic instruction
Date: Mon, 26 Feb 2024 22:35:51 +0800
Message-Id: <20240226143630.33643-35-jiangshanlai@gmail.com>
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

PVM uses the ERETU synthetic instruction to return to user mode and the
ERETS instruction to return to supervisor mode. Similar to event
injection, information passing is different. For the ERETU, information
is passed by the shared PVCS structure, and for the ERETS, information
is passed by the current guest stack.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 74 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index c6fd01c19c3e..514f0573f70f 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1153,12 +1153,86 @@ static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
 
+static int handle_synthetic_instruction_return_user(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct pvm_vcpu_struct *pvcs;
+
+	// instruction to return user means nmi allowed.
+	pvm->nmi_mask = false;
+
+	/*
+	 * switch to user mode before kvm_set_rflags() to avoid PVM_EVENT_FLAGS_IF
+	 * to be set.
+	 */
+	switch_to_umod(vcpu);
+
+	pvcs = pvm_get_vcpu_struct(pvm);
+	if (!pvcs) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
+	/*
+	 * pvm_set_rflags() doesn't clear PVM_EVENT_FLAGS_IP
+	 * for user mode, so clear it here.
+	 */
+	if (pvcs->event_flags & PVM_EVENT_FLAGS_IP) {
+		pvcs->event_flags &= ~PVM_EVENT_FLAGS_IP;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
+
+	pvm->hw_cs = pvcs->user_cs | USER_RPL;
+	pvm->hw_ss = pvcs->user_ss | USER_RPL;
+
+	pvm_write_guest_gs_base(pvm, pvcs->user_gsbase);
+	kvm_set_rflags(vcpu, pvcs->eflags | X86_EFLAGS_IF);
+	kvm_rip_write(vcpu, pvcs->rip);
+	kvm_rsp_write(vcpu, pvcs->rsp);
+	kvm_rcx_write(vcpu, pvcs->rcx);
+	kvm_r11_write(vcpu, pvcs->r11);
+
+	pvm_put_vcpu_struct(pvm, false);
+
+	return 1;
+}
+
+static int handle_synthetic_instruction_return_supervisor(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long rsp = kvm_rsp_read(vcpu);
+	struct pvm_supervisor_event frame;
+	struct x86_exception e;
+
+	if (kvm_read_guest_virt(vcpu, rsp, &frame, sizeof(frame), &e)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
+	// instruction to return supervisor means nmi allowed.
+	pvm->nmi_mask = false;
+
+	kvm_set_rflags(vcpu, frame.rflags);
+	kvm_rip_write(vcpu, frame.rip);
+	kvm_rsp_write(vcpu, frame.rsp);
+	kvm_rcx_write(vcpu, frame.rcx);
+	kvm_r11_write(vcpu, frame.r11);
+
+	return 1;
+}
+
 static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long rip = kvm_rip_read(vcpu);
 
 	if (!is_smod(pvm))
 		return do_pvm_user_event(vcpu, PVM_SYSCALL_VECTOR, false, 0);
+
+	if (rip == pvm->msr_retu_rip_plus2)
+		return handle_synthetic_instruction_return_user(vcpu);
+	if (rip == pvm->msr_rets_rip_plus2)
+		return handle_synthetic_instruction_return_supervisor(vcpu);
 	return 1;
 }
 
-- 
2.19.1.6.gb485710b


