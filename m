Return-Path: <kvm+bounces-58251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2250B8B81B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B34CE18874C7
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E1D2F90D3;
	Fri, 19 Sep 2025 22:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2527/r1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25672F60C2
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321229; cv=none; b=KwM+Jm2tCdZ/ILmtGGwy/9bnnmX4D/CyDoQsplQFPaWxFxaMgBAhTrOgV/8kHerr0XR/JFnPKs/4Ig4309mvEWiMG7JMp/E+Mz7vkJ94IfGoTWywtgn+6G741tq+tIiwV3PV/IA+4WJ+tubexzv8zcsk9o/hjIvnJfBhEMv/fuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321229; c=relaxed/simple;
	bh=Lksy7fgnHb3oGFbHmwu7Ep1364/PziXfDdmvLhbhInE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yk3ozR4tMqYnMkdbNJ9ecnsrTDSZr0kxheuceRHH0+Ev8hbwnWlAqO/LAE33KFPfwTqN3etzJ2pBk1qGjbNPdvX4pyv9HfyhTuynziHcOlHdDB2Se46AUCaWpIBoDeDPUo6GOoBH6qAiZPLg0GlrXoD1X5C/iNSgtcnlXKeK1qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2527/r1Y; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2697c4e7354so25528825ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321226; x=1758926026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sOIGEq5gDcEIjyNKw2jybRiZJubyWXYuSTFzzG+izY0=;
        b=2527/r1YfJ7Pkj+wYw5QqSb8yW//xQ5VvEfPAjqIiSEYRcuyOUy7EUYXbmSzI1e72A
         jscxd+1ezrdENQ/GpJ2utaLjNtZxwdaUMCincTaQTQP1IIWrbujoblUWxjvD39dyUus5
         2076mkEamh3EdjtSpwOKDIgidGDoWGf5b9eEh9yEv0kmoL53LCJdNpMgqlBlPNX8e2wo
         tHiWkXuzfHrXeJV71I68rCLoBw+ynmluvwxJHAOK0Wu0Mm/L3xPz2iXXBYEx2EpsTry2
         GuwwYVS1E6FjSH7SuvU4kFW1pTXtdLIWNAV4Q0gSmUf2NjA1xt8FxUJEFX1LYpjhkyzE
         OwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321226; x=1758926026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOIGEq5gDcEIjyNKw2jybRiZJubyWXYuSTFzzG+izY0=;
        b=Vk7y46VPC4vVKXn+X3b8wGC9Rr+zqibeSCmd7tqQqBL2ZVuL/13u+BCi/0sCG7Txbe
         uoUbXZMHQPJiHMKThkMBCgGmfSvk5VyZ98upPyUsH7D7O1hx1qmoWUqWstx4dYB4DdY5
         2zJBixOebhc2P08q7E8ajjMwo/xKsLfjsmHN3z8APR1zo/leo1PgmxUpSM+Eaayg9/HQ
         JXsrlPIXfC09Ifd+IyV7muPlnfwgDcFGLGxRFsvy1gpl5ORiuIzw9qKzyYHgqQnFcHzm
         OMaajoqh5zlFJ7Zy0QEaTw6+VYr/u1azJBCRWd91RQlcCaVK2J9KAk8eoax655BtXC8H
         KzWg==
X-Gm-Message-State: AOJu0YzIAAzWK+htQ1OnZDsW3jZYtfJv1i/QXrgzBPVV4tjxErgB44qi
	uS4nPED9xrQQJlzI2lbynKma6BtzYXFGxnzFtWO/3k+TB8rvxI6NrMkiFe+vK/WuyHckzVmAznv
	tKjTBcg==
X-Google-Smtp-Source: AGHT+IG9W+mhuWq/3Edt85NHzcquQu8FlWM08mGeajSH2y4PssgONNdFP+QiMP2Z0IRNUW5w2WZKrx2hyT4=
X-Received: from pjur5.prod.google.com ([2002:a17:90a:d405:b0:330:6eb8:6ae4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c88:b0:327:53f0:6368
 with SMTP id 98e67ed59e1d1-33091915146mr6219417a91.2.1758321226177; Fri, 19
 Sep 2025 15:33:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:30 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-24-seanjc@google.com>
Subject: [PATCH v16 23/51] KVM: x86: Allow setting CR4.CET if IBT or SHSTK is supported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Drop X86_CR4_CET from CR4_RESERVED_BITS and instead mark CET as reserved
if and only if IBT *and* SHSTK are unsupported, i.e. allow CR4.CET to be
set if IBT or SHSTK is supported.  This creates a virtualization hole if
the CPU supports both IBT and SHSTK, but the kernel or vCPU model only
supports one of the features.  However, it's entirely legal for a CPU to
have only one of IBT or SHSTK, i.e. the hole is a flaw in the architecture,
not in KVM.

More importantly, so long as KVM is careful to initialize and context
switch both IBT and SHSTK state (when supported in hardware) if either
feature is exposed to the guest, a misbehaving guest can only harm itself.
E.g. VMX initializes host CET VMCS fields based solely on hardware
capabilities.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.h              | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 554d83ff6135..39231da3a3ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 65cbd454c4f1..f3dc77f006f9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -680,6 +680,9 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
+	    !__cpu_has(__c, X86_FEATURE_IBT))           \
+		__reserved_bits |= X86_CR4_CET;         \
 	__reserved_bits;                                \
 })
 
-- 
2.51.0.470.ga7dc726c21-goog


