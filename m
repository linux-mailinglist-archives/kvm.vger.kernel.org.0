Return-Path: <kvm+bounces-57469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9968AB55A2F
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55274A018D5
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DF42DEA97;
	Fri, 12 Sep 2025 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jbllZj0x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8912DEA98
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719454; cv=none; b=UFMkP8o6KY90f9EHAF5NrdTK3m+nDy3p7u+sCW7KLpulikQWHjrwpuClZpRiKA/JOyEJ/TnGrBaWOtwaN5naq3viOYlDv/TvbxLhs1NWw4MmHAh4uxuo40lmf0P9pp9CDgV2eeooEgwCWCfcNvbubx7xeKgo4PR8DYcwmiR3nz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719454; c=relaxed/simple;
	bh=LAJPzAlmyWIBgpqdwLkUgQB3TkWNzFrLEjxU5EluKAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhORTa9n+z01NBuHW6eXAlKZc4Jn+EEtsgo/x7NwHghgSIVGieXYUNx/YlKSAMmvq8HTGs2+o7In/GwyDe6QZjtpfOJct89IR4K/L1EQf9Z91CTRuePbzatHVLtk/gIzAFcBaciWqTG8Wk8YVhCN5oKbJY359py5btgLUHBc43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jbllZj0x; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32b57b0aa25so2525526a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719453; x=1758324253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hzDjAlD4iHwUuuZo4Nh78/wEEXvtZ0Xx1CFsvM7LDXc=;
        b=jbllZj0xb15tQlQOvp/7SAdhWDVaRdzc7YwkhwTgFh9rDQ5r0lZxytdWjnFD+mFWkX
         JEwm0awEbAGhoBQivBWHN2/MSVW6R1nDpVWPe+H3RBwrKHseZpWUS5cc7OjVfaHj8i+g
         36VKXMXB8OfDkL2s7ze3Yadsq6p5jRFOdEZfBG8+sT8hweURfhk/4BLKilTj8Ys+6Jdm
         J8zOuSPY8J64mK9B5uG44Qar+zDNzR6VWVURSwzaQq+Y9BUZmCWqKJE0eGNEgCovuTAc
         fr3wU1ZMQCPFndB08n3n/OfiGhzk9JTZjsqQl1xzUjTbwfj16c6SWvTBKmGR3SoaSKBs
         9C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719453; x=1758324253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hzDjAlD4iHwUuuZo4Nh78/wEEXvtZ0Xx1CFsvM7LDXc=;
        b=vjo4idUR7bIcSnA5wPjhlG3v8/hJHSzq3WR8jtPja5Fm9jeCtL1HA4xN0Bz2Dy8zuu
         IAf2iJM7w2XkZOAYUUTyl+76K8x2jWktzlxCBGIItR0gY1fib8VURrrVv4tYDDKeXjW3
         rMH+KbyY63jNQPmJGvWhopn1o4X5xeImHwTauOsYG3udA3gFHKAio+hiIwjTiGppP5b7
         Mvr6E9WqHFOAJJLMKxmbmiL2FPcG33LYt1RHcxQYnwgTljVOjA5OJnvlkEkRWBoB5uIM
         B3fpTjLqJp8lCctjoFMSmqoHMsZBqSaOk7ERTcs849q47TmaHVsPvVMx/Vv9iA4vIBnF
         hD3Q==
X-Gm-Message-State: AOJu0Yxxr0VlGOHszCy/FOrlbN2AUMddalR7uchWj0ZRuBSIKMNUGW8N
	E0C5CXOm8xLoncC6qw6ugevCyFcLaThVcZcPV5SpnEV8AycAi/Vcp2cRyCS+khcJNl9AS5luo5j
	E9Gmmgg==
X-Google-Smtp-Source: AGHT+IHSdGKZy5soiUAoOrnYCvC/h4VFq/ncPK5C7FSM5qNoiAhCXYyzhUL/nqH5X5GNExI4WprY3NEICjc=
X-Received: from pjbqa16.prod.google.com ([2002:a17:90b:4fd0:b0:329:e84e:1c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da88:b0:32c:c40e:db12
 with SMTP id 98e67ed59e1d1-32de4f858f4mr5231651a91.17.1757719452938; Fri, 12
 Sep 2025 16:24:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:04 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-27-seanjc@google.com>
Subject: [PATCH v15 26/41] KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Transfer the three CET Shadow Stack VMCB fields (S_CET, ISST_ADDR, and
SSP) on VMRUN, #VMEXIT, and loading nested state (saving nested state
simply copies the entire save area).  SVM doesn't provide a way to
disallow L1 from enabling Shadow Stacks for L2, i.e. KVM *must* provide
nested support before advertising SHSTK to userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 826473f2d7c7..a6443feab252 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -636,6 +636,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CET)))) {
+		vmcb02->save.s_cet  = vmcb12->save.s_cet;
+		vmcb02->save.isst_addr = vmcb12->save.isst_addr;
+		vmcb02->save.ssp = vmcb12->save.ssp;
+		vmcb_mark_dirty(vmcb02, VMCB_CET);
+	}
+
 	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
 	svm_set_efer(vcpu, svm->nested.save.efer);
@@ -1044,6 +1052,12 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 	to_save->rsp = from_save->rsp;
 	to_save->rip = from_save->rip;
 	to_save->cpl = 0;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		to_save->s_cet  = from_save->s_cet;
+		to_save->isst_addr = from_save->isst_addr;
+		to_save->ssp = from_save->ssp;
+	}
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
@@ -1111,6 +1125,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb02->save.cpl;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcb12->save.s_cet	= vmcb02->save.s_cet;
+		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
+		vmcb12->save.ssp	= vmcb02->save.ssp;
+	}
+
 	vmcb12->control.int_state         = vmcb02->control.int_state;
 	vmcb12->control.exit_code         = vmcb02->control.exit_code;
 	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
-- 
2.51.0.384.g4c02a37b29-goog


