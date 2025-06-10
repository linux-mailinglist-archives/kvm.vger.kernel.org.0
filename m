Return-Path: <kvm+bounces-48885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4F3AD462B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 964233A5C88
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C52828C851;
	Tue, 10 Jun 2025 22:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9BRlTPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762A286D77
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596265; cv=none; b=qH9hZeaYSf84JmBwHcOe3FmI9vYefPfMYH0iBPzm7beHehafxB1JRsZxlQKuxtW0rRIAujtxiRmeBPz0+UDWFTHL5ymVA0SYkkmayMVX6mcoV2R9aXP0GVD44A5H1kYb7T/ntLtve4CQcHel1iWFWzPmVMb6lObjlTpSPR6BGqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596265; c=relaxed/simple;
	bh=tTEXLUd/zXDDLNY3MmnlVb5Gbwhb1Oifynpm05TtVX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QDQOhLw3JDKo4tZgX+4gVBAXL/cNuYuAh3lKHIP90zeONE0ip4+V2M4xm5B/8Jm598DrZ9P/k5ndkF0tKIAHgSAJ/MD3wtCibIjBL1i/gaw7zfGMu0kZ+ExGHDMAKz01/b+Oey9b0MQRIKWV49pJRslOQ7+oZKecfSKH+NhVt5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9BRlTPM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so6377464a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596263; x=1750201063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LtGhffg+4qUCmhXz2Gv6Fzz7TJfhsSuBXbr9dL/TWnM=;
        b=C9BRlTPM2S8QfPSLCg+AIVcHrhapeIJpxk8axTJxfEgvP9SsdD0VwDWGkzT1AsfkYV
         Sd2vGpC+ZmoURI/vdvfAi/27hzejh7ls6VZ4jA6rvASzDxfwy6qZnGC3FXw//QKaVTTF
         ochVrpQHqu1ipy4PUEHNU0vDubm/iZRqXD/Kn1W5IMcZZ5Zy3BrhHKs9K7OsDxZnLzok
         NasXJfJWoUc1T82mL+zthkilBCqZmHVt7ZHX7QJ9NW0wdxZc2rnKkLYOEJFbX9mTYnXK
         Uk7kfnx0IncNZyUlncZwHf+J8xKTOrhPLIrJE2bUuum3H2mgJ1t3GBwoh8c+V9ETxplq
         ETgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596263; x=1750201063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LtGhffg+4qUCmhXz2Gv6Fzz7TJfhsSuBXbr9dL/TWnM=;
        b=BzR4KbQGLfNXZiJIKdP4MIbSywGIlLIew9NWasl0P5Bbbx39I4Bj7yUPtLzhHGjFMN
         zQ+XTCi7u4PFLrZnl7Nurq7w/LuGaDcyyaQzJX4qMrgcgZak/r0dLck1Z3pG41q181HI
         UG5obpbl2v38X0GaPHIkf1d8C//7OfT1akuIbwt55nHzLtfWq+o3rHgM6vbJ3tTxowfr
         xXBSnkEmrB9vK1gi2MS0tmQsdX56cD3TOlerFnJbbcjAZNowejk2J7zZ47dXeAIuXJzP
         4xxVTDKnHESMTgr0WbnRRHk71DrKhAa4WAjpEzvF7/LuStenKDXJN2l/zDuu/zpVTzgv
         4bQA==
X-Gm-Message-State: AOJu0Yz0631wHZxLp7Bhcb6rOqPQrObJEeYPka/yVEIykt9qHx/0UQmj
	TyKeY6+d2nO4dRneDx18OoSVm2FnZW8cFf6Q0b8GVQyx2zWcU9z6FFF1OYuILAumjwaz7rp1dtM
	i9UV+Nw==
X-Google-Smtp-Source: AGHT+IGRgtC4yLWdb8Itbiy3X/aS2mIMT2QE2jBxKl1uV/cOtKkRKfJGAlO+SD96Q9qtuFg+lfuRp8EUej4=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5404:b0:311:a623:676c
 with SMTP id 98e67ed59e1d1-313af243c3bmr1739474a91.27.1749596263290; Tue, 10
 Jun 2025 15:57:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:06 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-2-seanjc@google.com>
Subject: [PATCH v2 01/32] KVM: SVM: Disable interception of SPEC_CTRL iff the
 MSR exists for the guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Disable interception of SPEC_CTRL when the CPU virtualizes (i.e. context
switches) SPEC_CTRL if and only if the MSR exists according to the vCPU's
CPUID model.  Letting the guest access SPEC_CTRL is generally benign, but
the guest would see inconsistent behavior if KVM happened to emulate an
access to the MSR.

Fixes: d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
Reported-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ad1a6d4fb6d..21e745acebc3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1362,11 +1362,14 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/*
-	 * If the host supports V_SPEC_CTRL then disable the interception
-	 * of MSR_IA32_SPEC_CTRL.
+	 * If the CPU virtualizes MSR_IA32_SPEC_CTRL, i.e. KVM doesn't need to
+	 * manually context switch the MSR, immediately configure interception
+	 * of SPEC_CTRL, without waiting for the guest to access the MSR.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     guest_has_spec_ctrl_msr(vcpu),
+				     guest_has_spec_ctrl_msr(vcpu));
 
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
-- 
2.50.0.rc0.642.g800a2b2222-goog


