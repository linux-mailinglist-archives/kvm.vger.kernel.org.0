Return-Path: <kvm+bounces-9899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D870867907
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C46E1F27527
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C4D1386B0;
	Mon, 26 Feb 2024 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nF4q06WL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BF51384BC;
	Mon, 26 Feb 2024 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958197; cv=none; b=KrZq/znptVOuNKyZ6QwuXtreWG3HLhu/9Mbh7zkiJ+eaVKCAGbDp/PR0H0Q7HJfCVN7jl0aEwthZ33FS885OShMbbMS2CJgY4wvQYQ/4kGb48xPDRkHz0s+M2aGfiBM+MUxNiREhj0S891mvVvUP4+KAoD6YBhVXBVDRECoq5SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958197; c=relaxed/simple;
	bh=/z7tYbeor/O77YAziAWp5Dpxyzv/isU/KTQwhYd0TaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SDZfFRjMsrf6F0CNoN0ifaV5PUpPyv0A5Lniz3/aSXS0H65xMB68jrB1wMMwpPlPaTgB1D7/l4fsp6BN2uEAlOxoatP+uvK1bUACQRdTtpRiFcympx4IEj5KWUC200zN6Ljmjm79ENaYYijQATr1LUwufHju1jwzMlJh4zG2QkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nF4q06WL; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e459b39e2cso1730867b3a.1;
        Mon, 26 Feb 2024 06:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958195; x=1709562995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQSm8Jft4e9xZ2lN58L7pK7AxP5HjLCoF4G+WEfOzXo=;
        b=nF4q06WL2nlJ8lk+eH0HWGgMVdOnXOqBdcrtooSo4KUVK5CAwLITu/aySuwE69iv/8
         2PtPalPJOLOYpVIV/iCfGUZ7t4d0lfzulXFpEX1Y9dm+ndUAAAnuOD/2aQsgiNX/ibs0
         O2ftsOVtG6qY77fnPJMeGRP7Fe8+OjlhuOwvCajTMqsg1v10tM3S6aP0ykF8KJsbMfPM
         Q1yTI3qBz64+OT48FVuY9C0qF48gde0RVfnG94csnlu9vfG/Sg6OxDCMl7VtOGOqStrF
         U9GUoFa96lQjgO8/m+tkzDjg7ImMsPRTrJ7C+2jghFV5ukI+nGLzNzlcNkt0vbKY/Y30
         30Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958195; x=1709562995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQSm8Jft4e9xZ2lN58L7pK7AxP5HjLCoF4G+WEfOzXo=;
        b=egUghtLpERoJVZS5Jwn+8iBcP/f5qPaI8SvGzgFs2luLwrLnD91ZyJnvDbILT7Bfcv
         1OEYfZcg6nNerrycMrzlrsEIbT1D/PTQNxpWiW8Piqb88yR0g/1s7jxcIwPni6kXar8D
         UPCTiVWyrPLpaJtRNTyQow5EddCGCyO+dzM3gtIy6A+jGU2BmoIaYG3mDq1gUFhljJuz
         dPQD1NwAb8QZ3ZOqXFP895I5zjknQ8KnToVa5gITt8Z++aBojm494MgZPHDJWLNpeWNr
         FUyPCznbr0pni5GAYEMaH5N0TrUuep2uFJHG4zOrJeRc8Zvn8ACTDqh47F4drTN5om7Z
         YKqA==
X-Forwarded-Encrypted: i=1; AJvYcCXL0NyZX7Gs452WGBE6JIOBMXf1ail8vsjOujMeM0KtUNEtA6dR9QawoYzL7vAwjo4sdQSs/74WbFaODLA24CZfg5aH
X-Gm-Message-State: AOJu0YxChEAQvMvyfS/MbhHn7R6cfcmoIVIvvuc2o4Jir7UKPuoExtbk
	NV2Xg9YPc+iIwj18OyJ917FlEXGWOAYEouR4cq67vsNGeuZtHm+vuTDhE89q
X-Google-Smtp-Source: AGHT+IF9pJaU2X3yeMtQVJ4YQJDksTT8euB4/X95jZUNCKB+O09eLtY+VHN80jZNMntxB/oHCwGlcA==
X-Received: by 2002:a17:902:dac9:b0:1dc:b16c:6406 with SMTP id q9-20020a170902dac900b001dcb16c6406mr1205885plx.6.1708958195290;
        Mon, 26 Feb 2024 06:36:35 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id jd12-20020a170903260c00b001db63cfe07dsm3985445plb.283.2024.02.26.06.36.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:34 -0800 (PST)
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
Subject: [RFC PATCH 36/73] KVM: x86/PVM: Handle KVM hypercall
Date: Mon, 26 Feb 2024 22:35:53 +0800
Message-Id: <20240226143630.33643-37-jiangshanlai@gmail.com>
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

PVM uses the syscall instruction as the hypercall instruction, so r10 is
used as a replacement for rcx since rcx is clobbered by the syscall.
Additionally, the syscall is a trap and does not need to skip the
hypercall instruction for PVM.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index a2602d9828a5..242c355fda8f 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1221,6 +1221,18 @@ static int handle_synthetic_instruction_return_supervisor(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_kvm_hypercall(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	// In PVM, r10 is the replacement for rcx in hypercall
+	kvm_rcx_write(vcpu, kvm_r10_read(vcpu));
+	r = kvm_emulate_hypercall_noskip(vcpu);
+	kvm_r10_write(vcpu, kvm_rcx_read(vcpu));
+
+	return r;
+}
+
 static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
@@ -1233,7 +1245,8 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 		return handle_synthetic_instruction_return_user(vcpu);
 	if (rip == pvm->msr_rets_rip_plus2)
 		return handle_synthetic_instruction_return_supervisor(vcpu);
-	return 1;
+
+	return handle_kvm_hypercall(vcpu);
 }
 
 static int handle_exit_debug(struct kvm_vcpu *vcpu)
-- 
2.19.1.6.gb485710b


