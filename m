Return-Path: <kvm+bounces-9871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAB48678C1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DFAE1C2297F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D85012F394;
	Mon, 26 Feb 2024 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcAbNFFq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F912F374;
	Mon, 26 Feb 2024 14:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958105; cv=none; b=rNiR6nffdCRX5WvccKVrCRvKXdRsptvNWHqG+b+JeviNoXZ5gV36zJuQfGUAlJFvTpxdbJbtw5faOj12TiKMebFziH+k/P7Uq0VF46z13BBVgyaQGt+zBBBrYuOJtoFtK33GyWSUv4Anv456W95G1rPYf5Z+2urE/UZRMlYh2us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958105; c=relaxed/simple;
	bh=xwIh858WObmvtC725DseRlAcONsFGiQgeAooN8QJfLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kBtWYugZg09k0AMOF0MxsRp3w4/hDv0jH6+fjcL12AxchTK8txCbiu3ZtXpLgVhLvnIL1MU4RiVLBU7Owa0E84WLzSSq8HcAG3Smu18hZ0mhJzHRWqK+qc7iKRgs8VQKqBpzy0vSHq3weq6CNSoqYPMUeq/05meT0iJipNNLQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcAbNFFq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dcad814986so4522245ad.0;
        Mon, 26 Feb 2024 06:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958103; x=1709562903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0atspnxIjLDF90X6FTNIM6Zc64/TGzPipqn5jcW5+A=;
        b=jcAbNFFqFWQf4TszNix7Wtee3nBY0rSo9QUNMj0eDj1CIvaqyM5WZSuInKdXcy7h+1
         znYssp4BkOU9C46NzzmnFTeJOgdI1HU7mzN4Sn/SQDX05J87dFmVpISJ6hlmy6at8xgU
         GmNR3PJQ+3kKBfW71h0/xvXMZUiDXVAepgpWTc3ET3EiGAx6Tr5Ch7WbJynLy5vdKIeq
         ShmsMKaLwI10vdL2c9/yi5gqYat1B0Bhjz/95K1/V2dYHJPzGEvd/XZOo4y2IrtzEsd+
         Sc2e8MktQ6kXy38wZJIjM8Vto/P9bXwPfP0OiGtAOmk2i12atOJK2xIXgetiEdJ1S01F
         fAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958103; x=1709562903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b0atspnxIjLDF90X6FTNIM6Zc64/TGzPipqn5jcW5+A=;
        b=tWfjcAJhYggyD2dplFhIoJqhO+s+FyzZcNe47Tqx9u78PSRw+E6J3vvQkcZfheX7lX
         7cPZdSBGR2I5OodcxcOMdB65GitDCWBbN4XChLi0kh9LPPvL0reeQ8bFlqVsQIEb96eW
         me3SKJkxxeIacp1Seme604+u1qDO4fL6oKRLrsbuM20MPNW69BLNQsb8V71F+YEQRgqC
         xDw/2AUbk2UDtIE7nEa/0JsrYupb8irIlCW2mxmlq/qeAlmP8E068e38nE4P92Z0MMsV
         J1qej+TsamwBRSdwTaWBNZ3cpvRAAPO/uoCkF/IK5sf+u4KmNn4kW9gFnVWy96ivXXpC
         skyA==
X-Forwarded-Encrypted: i=1; AJvYcCVSf6V7jxnPfwmjqZWBsWjJQrrmsDv0tYurlItmlSgF3/ss6IpykjkqZxeXyTYMO1KV8ZyGSDS1fhvrO4ISSBRsNlXr
X-Gm-Message-State: AOJu0YxtjyoTI5FkH9sKPKx9IZdnfOX5eqLqwVEw5+DczsNoI8bMABt9
	yw5qWLjJqT8EdO/DAU0iDYzxMyJc9z7bnDJIzf6ShljkiOqd3+Rgi/nVM6wl
X-Google-Smtp-Source: AGHT+IFZXkg7BuUXLXx7GpKe0W887fXA9MAv5WAGUy5HQDjLkpsO0IpvshxneGsKwVIG1iDVvBSLhw==
X-Received: by 2002:a17:903:2342:b0:1dc:30d7:ff37 with SMTP id c2-20020a170903234200b001dc30d7ff37mr9570988plh.42.1708958103167;
        Mon, 26 Feb 2024 06:35:03 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001db608b54a9sm4011080plj.23.2024.02.26.06.35.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:02 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
Subject: [RFC PATCH 08/73] KVM: x86: Allow hypercall handling to not skip the instruction
Date: Mon, 26 Feb 2024 22:35:25 +0800
Message-Id: <20240226143630.33643-9-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

In PVM, the syscall instruction is used as the hypercall instruction.
Since the syscall instruction is a trap that indicates the instruction
has been executed, there is no need to skip the hypercall instruction.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
 arch/x86/kvm/x86.c              | 10 +++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76bafe9c7e2..d17d85106d6f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2077,7 +2077,17 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
+int kvm_handle_hypercall(struct kvm_vcpu *vcpu, bool skip);
+
+static inline int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	return kvm_handle_hypercall(vcpu, true);
+}
+
+static inline int kvm_emulate_hypercall_noskip(struct kvm_vcpu *vcpu)
+{
+	return kvm_handle_hypercall(vcpu, false);
+}
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 96f3913f7fc5..8ec7a36cdf3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9933,7 +9933,7 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+int kvm_handle_hypercall(struct kvm_vcpu *vcpu, bool skip)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
@@ -10034,9 +10034,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	kvm_rax_write(vcpu, ret);
 
 	++vcpu->stat.hypercalls;
-	return kvm_skip_emulated_instruction(vcpu);
+
+	if (skip)
+		return kvm_skip_emulated_instruction(vcpu);
+
+	return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
+EXPORT_SYMBOL_GPL(kvm_handle_hypercall);
 
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 {
-- 
2.19.1.6.gb485710b


