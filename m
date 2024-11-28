Return-Path: <kvm+bounces-32629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1019DB05A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC0AEB22C83
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BA94778E;
	Thu, 28 Nov 2024 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LRbohuJA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09171219FC
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754634; cv=none; b=WtUbLzSZS5bZx5TCqYZaQUlbfNBncQaQJaO+UGCqAl//3Uy9v8GOg+gQUNr99i2fAQlmCgluow39sznFvegmzaAqEw1gBNxZdvAxQZhfYZS6LeLjD5Yf/O4XeXkJEvSPlxxqe37oZoFG0ucxMa9PvHtaBeHEHQQThlgx8UK38FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754634; c=relaxed/simple;
	bh=jyPX3MdAUnX1bDy5TiI1V6ZoW1meXejrHFasqL8eDK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RG6doMLeEt/WeYYip9mzQznH6vhkm04n3Pz6PO22zQN51yXq8O2/aTOTnI8ZdzllKTislwPg4Zsw1XdvKlVM+4+sc+aoHjpB7U23klhzqDPoDIuyaNIRE/bVwOMPWPhHs6u4uqCo5qmuOs6/8BaFVdRQiIHAtApyZBtl+DU8wcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LRbohuJA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee0c9962daso311237a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732754632; x=1733359432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1w6JVsg4OUo1AnaxThquyWJswnSGtvGXHMhG9ntSUjE=;
        b=LRbohuJAneS6Fzwyo0Nu1qq3tkK9wU4TjGm/exnwHhou4HP0qz9ZFla55/i07tyYm0
         TlueK+Uk8TDzc9+KfSvPEs3vi+tnaa1jSWLw33uhrBHngTEnQutuPbYrnV50SlOBNfcp
         aH05IDaep7q9HEE84f0Z2fPgtvY0BzBo1XLza0Rpu7yNgQn3lYFmUiBAyluZWXdgI6M3
         uQwDmlvxVqRniicympzZmF0roTylHiFgvy90VFHSUzq6/pM2vbLlEXXyhUOj4+hpHMfV
         nHsCgtgz7St2OdhdD3x+Hd3PaBmZ2OXQqoRZ3lQEcRgkibYVavk8ZOsx+VI/b6vM0Ow1
         55hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732754632; x=1733359432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1w6JVsg4OUo1AnaxThquyWJswnSGtvGXHMhG9ntSUjE=;
        b=c3NjGNi23CjVYGfERMFxbq3X0nGMigGD1AKz0DT+Io5b91s2cRIa8QiqJPY5K/oOY7
         NUXkmFo4ZIRDHwR1oZQL8dm6nHpKKNBOesfF0rdUnzDIEBfIegRVMsKKlBsF6+tW8hHj
         4rFSCUJZFJtIhKn3rCUUDgyPiCo65s5eDBXYCZ5kF0mNFDtQgOQ6tf6lU2rwsw7xpyeP
         qttCV1CtcplCum4OhIftkLXBl86FAx5UbH8W6JQFEIrShNipAwN6IVlb8gNQBhEFYs3K
         YPLYQ71uutvLVue7APkmZBbWjG+9fVkP9kQuoQO9ARkkRxDrdB8peeiNOhX8Z8A7dNHh
         J5AQ==
X-Gm-Message-State: AOJu0YwjAUJTAEVgWHimg7bmUKW98AX243etnkJZtSdSH2m/GJBq1dvY
	6xVMJIyhhNSH8ByBXhN2H0prGVi/tluqSUPohjPQVbyUmmtsgxm4+U3JS+ItWd7GgdxcxmtEnVd
	LNQ==
X-Google-Smtp-Source: AGHT+IEQTw6NycY68SHBk7WI4L2KbulF4hVElsyaIaLj1wJbiWRwmM/PjWD0Btsx9ro7hcsaxrPuaWvf6Js=
X-Received: from pjbli14.prod.google.com ([2002:a17:90b:48ce:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d12:b0:2ea:4c5f:923e
 with SMTP id 98e67ed59e1d1-2ee08e9a0dbmr6652768a91.5.1732754632474; Wed, 27
 Nov 2024 16:43:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:43:41 -0800
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128004344.4072099-4-seanjc@google.com>
Subject: [PATCH v4 3/6] KVM: x86: Move "emulate hypercall" function
 declarations to x86.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the declarations for the hypercall emulation APIs to x86.h.  While
the helpers are exported, they are intended to be consumed only KVM vendor
modules, i.e. don't need to exposed to the kernel at-large.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ------
 arch/x86/kvm/x86.h              | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..c1251b371421 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2181,12 +2181,6 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl);
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
-
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 45dd53284dbd..6db13b696468 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -617,4 +617,10 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
 }
 
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit, int cpl);
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.47.0.338.g60cca15819-goog


