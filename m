Return-Path: <kvm+bounces-68270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3965D293A8
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2CF0B3018348
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F4432E137;
	Thu, 15 Jan 2026 23:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpW59nio"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDA2330D47
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519341; cv=none; b=nO5vOimFsslHD5plXDW55aUIUyHVcZNs3LSt+tvvuGflHQQHbp1vQ7YiSS9KC00HNCOGrMKuJftTfgDvOedhaY9PKZgBA6k4d7awZJ8rS6We+36Lhqf+/5egXis3mmUWMYAJIBqgSXJLV+/jV9rcNH4DQ7r7oAhDXtevV1DxBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519341; c=relaxed/simple;
	bh=pQGqZHvp21TJMQpJakX2U4AKh8qO1CopjjvFOdIp6ko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UgCErWJWvoz2jEGAQGp0kPQ+05IOchki1K8f39OB90UzhMNubnOvPTojFIUBn2bfd6puhgOvlEo5cWPqWHw99xCT/NPTCvPlbPhiIrrFk18bqIIY9Z/J25BfIlWPxCKl7vAoHqWgZyGr806A6XxO9cRUk3ZrRt4HvWt2hnEKQgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NpW59nio; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c52d37d346dso770186a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768519338; x=1769124138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M/rH7YdPCxq3Y37lIh13jkzHenRj4dLCp8dTpSUr3u0=;
        b=NpW59niolhJW9LTEvEBhLa2YE6rELXZZ0J3OmLd+CsODYS9fVLAzXI1U7x5YSlBOZ2
         N7fvIYwYbWQwpFuUMD/rHd+4rDl4oazUHzJ2tT2fksIONqT0UktLi8d0WpXD/Btg03Vb
         75snIUS5c6yZKCsBYHwr3PIqJtA5xDHwxz/qCoM3Fd9odc4C867JlGTP56MTvrbYrcRm
         Jsdhr/Px5Z9ChuOfkclknmlm7qQPYunxQz15KUCRqEkaR8nG/kevGeY7KwEYVZxVJrN2
         x4F5EuEucQ8UracKlSQ2NBP2WyICbiLNcBNwufHpBR86hNWn8FsYoMh7l3QMm8hTsqqQ
         FcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519338; x=1769124138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/rH7YdPCxq3Y37lIh13jkzHenRj4dLCp8dTpSUr3u0=;
        b=Rxn55lKS+NdB9HT+gIG+yKhWZ7rBcirNJL9QEQvRXR0DN0k986iSRteitOuAJfsvi0
         N5s/ffu6y12HfNo1hb79zoSFk3szfO4pHNpJwucGGI4FDmo8tnUj4Yv+sB+5HFsHbTbg
         FDx23Vf/FVLz1UmpSGMKLHVU5hbvGI17YgdcqSHZ3Ei3BqH+b7W8ifjX9HtnIbC9lBi4
         M6e695FgCJx5vhiMMB1AVvfcYdSsT64+V3lOUnh6AVpHRBTJfSU0wYwAlpSrqD/lGyaJ
         tr63l1wZ71YnGy9a8acL+aY4WLjnb5lzwfqEhzWJbXkUGA/wD030cIvq2HUloJxBag20
         vF9A==
X-Forwarded-Encrypted: i=1; AJvYcCXIyAlEbbeWoeDgCF4PJSpqEh7e3WT8NZE8UBekIluAdeG5j0Nd2xwJyDn/6m99v9lF2vo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC1tT0RX5bLxd/u6S4Z9uKzXNHghRBzxulzLWBCNG849C9TL4u
	IWVI/apKGiOuT8Xt/cbEIgFrHaKIQx/uEXDNwd2Vz6LCUke74TWh+aFN4LJjI7mjRYsOz1a1GZM
	nPVQkH6ImDqpZ+Q==
X-Received: from pghi22.prod.google.com ([2002:a63:e916:0:b0:c52:7760:c1bb])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:428b:b0:334:8a8e:6576 with SMTP id adf61e73a8af0-38dfe5e7ae7mr1184649637.29.1768519337975;
 Thu, 15 Jan 2026 15:22:17 -0800 (PST)
Date: Thu, 15 Jan 2026 15:21:43 -0800
In-Reply-To: <20260115232154.3021475-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115232154.3021475-5-jmattson@google.com>
Subject: [PATCH v2 4/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When nested NPT is enabled in vmcb12, copy the (cached and validated)
vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
register lives in the vmcb02 g_pat field.

When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1,

When NPT is disabled, the vmcb02 g_pat field is ignored by hardware.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e65291434be9..b0c0184e6e24 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -656,9 +656,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	nested_vmcb02_compute_g_pat(svm);
-	vmcb_mark_dirty(vmcb02, VMCB_NPT);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -666,6 +663,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		svm->nested.force_msr_bitmap_recalc = true;
 	}
 
+	if (npt_enabled) {
+		if (nested_npt_enabled(svm)) {
+			if (unlikely(new_vmcb12 ||
+				     vmcb_is_dirty(vmcb12, VMCB_NPT))) {
+				vmcb02->save.g_pat = svm->nested.save.g_pat;
+				vmcb_mark_dirty(vmcb02, VMCB_NPT);
+			}
+		} else {
+			vmcb02->save.g_pat = vcpu->arch.pat;
+			vmcb_mark_dirty(vmcb02, VMCB_NPT);
+		}
+	}
+
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
 		vmcb02->save.es = vmcb12->save.es;
 		vmcb02->save.cs = vmcb12->save.cs;
-- 
2.52.0.457.g6b5491de43-goog


