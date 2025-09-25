Return-Path: <kvm+bounces-58792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3857EBA0D9A
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75314A128C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B61314A74;
	Thu, 25 Sep 2025 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MK3C2EYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488D13126BC
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821348; cv=none; b=dxSH63Tz9vse2I90P2QdkOxreFFMb2U1pQMcT8JbzACdxNmjrgty7vNygU53ZomxPaiVy03aSxKtkeDhFFLCodg1FfhCRDTKKcQvtTx/dEy7TwpsPqscOHIn9v3GmTHpsZ8zvnmJc6EgXQUKUohkkcCnUKje9KBWv97KCSyeDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821348; c=relaxed/simple;
	bh=bOvTd2bB6/WZ+eh2dApwatXxF97GRYm67HVPHEr5nyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tEcS+NxeBabmkNxPL7JCQ6DyiDXbyz5wReNaD+EZKxTpyN6dDazfK9Hq3xdlvqa+f8p8Af8skYcI1PUUJCxNE7FgOK5TYwSdmQVzEJiU7Bo0//LJkZwjWUCgSsc4qj/Ub8ODyltm3iqQlMbpXsqQQJwy872K+njBrvTBzVXoFDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MK3C2EYJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780f7238196so957759b3a.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821345; x=1759426145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1mZRrNcnYUjmo7rmN8LDqwFLvvoTI0A/jd/T6+rTzXE=;
        b=MK3C2EYJ2xhwEz5iOoB8l7jKrN/W046guBM0koBTVXaGOWgEwZwrT8xS/lFBzjiuSZ
         q0i8JNFDsuHcM0Gk0KdUTf0O05B86+d/ajUN2ivDfrA+4oXZ75s+ezaQgi6Pr58oDjme
         lPU1tLmSdEUk90dO+tEKejbVz2lGTididvxwWpoctEyGhuI9sVBFZfhYbTzkrDpQ9JZH
         7oTbFMsj6NpdAXc06qMwDbni8YMGs5mVXvJIkcxzOtZh2OVMgpdPWffwR4O3dHyoT2E2
         tND2b19thsOGwfD7GLkUtfjIIHO3b8cwPPzfZ+/pDeGD8z+Lh9lWhKky8t/FitV9cZ2E
         i+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821345; x=1759426145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mZRrNcnYUjmo7rmN8LDqwFLvvoTI0A/jd/T6+rTzXE=;
        b=T4e6ezMDQjL4sBjZoDXHZCccLO4CfNsQ9h/D+Nl6BjwLYGd8iNf+mtn5TPdyF8h/i9
         8YPzPyi8A0gnxffj4OY9BqUSitBr6SNfjCLD6xlyc9SsFiRF66B3mLMrpbI2pNecxILd
         eoE/IMFmOo6zwKITkKTfZC/OAI91F8z5dhTUwweDFLTBHd+IgmR1PvZt0cTqXY3nsHUo
         DzelepYKpYxOkJk7hFxlwEgZdjJ9jXXSX2h13uLGTIi6nIsHxpk1m+upN6Miq5IpC8D4
         5jVVlC5InGcvcQlY4BT+0WHUKZmHDJTg6PoRvA11y1Gw0YETX0mIDiJO0ubNcteupQuK
         d+4w==
X-Forwarded-Encrypted: i=1; AJvYcCVfjic88BeJQQbBGGygQDWBBCPveGpt4udhzWFUbvmmYiP5iQrGT8Qxyc3e1nGqqJwCcjI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/9Vq31Q7I17GHWjPj9Vt0uZkPe9opnBMLUwFvPf8XTgSwH3Ue
	3yN4w/dFFbUNoh/a1z0jRIHNDmJchn0AFnG5UOKiEYYaswfLdWpwN16M3i2wbqlABKX6Oi1tMry
	g9g==
X-Google-Smtp-Source: AGHT+IHH7Mef2XNVh1ACvfIhTNHlDP18hKQJPvznI4TzvCashHW+qf63OPYFuy4CAmBPIVH0739cX6UI/A==
X-Received: from pfbhh2.prod.google.com ([2002:a05:6a00:8682:b0:77f:61e8:fabd])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b0a:b0:776:1f45:9044
 with SMTP id d2e1a72fcca58-780fcc6b61bmr4255358b3a.0.1758821345338; Thu, 25
 Sep 2025 10:29:05 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:31 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-4-sagis@google.com>
Subject: [PATCH v11 03/21] KVM: selftests: Expose function to allocate guest
 vCPU stack
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

Expose the function to allocate the guest stack so that TDX
initialization code can allocate it itself and skip the allocation in
vm_arch_vcpu_add() in that case.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/processor.h        |  2 ++
 tools/testing/selftests/kvm/lib/x86/processor.c  | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index f610c09cadf4..8e75df5e6bc9 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1109,6 +1109,8 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 	vcpu_set_or_clear_cpuid_feature(vcpu, feature, false);
 }
 
+vm_vaddr_t kvm_allocate_vcpu_stack(struct kvm_vm *vm);
+
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
 int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 83efcf48faad..82369373e843 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -658,12 +658,9 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 	vcpu_regs_set(vcpu, &regs);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+vm_vaddr_t kvm_allocate_vcpu_stack(struct kvm_vm *vm)
 {
-	struct kvm_mp_state mp_state;
-	struct kvm_regs regs;
 	vm_vaddr_t stack_vaddr;
-	struct kvm_vcpu *vcpu;
 
 	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
 				       DEFAULT_GUEST_STACK_VADDR_MIN,
@@ -684,6 +681,15 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 		    "__vm_vaddr_alloc() did not provide a page-aligned address");
 	stack_vaddr -= 8;
 
+	return stack_vaddr;
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+{
+	struct kvm_mp_state mp_state;
+	struct kvm_regs regs;
+	struct kvm_vcpu *vcpu;
+
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_init_sregs(vm, vcpu);
@@ -692,7 +698,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = stack_vaddr;
+	regs.rsp = kvm_allocate_vcpu_stack(vm);
 	vcpu_regs_set(vcpu, &regs);
 
 	/* Setup the MP state */
-- 
2.51.0.536.g15c5d4f767-goog


