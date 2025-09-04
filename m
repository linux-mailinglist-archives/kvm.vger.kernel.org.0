Return-Path: <kvm+bounces-56761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E370EB4331E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBA171C26637
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C7029D29D;
	Thu,  4 Sep 2025 06:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/UKW17+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE629BDAB
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968929; cv=none; b=XtqYa/vs+RxsBwQ/nsYkXt6Kq5Dwar+dZ/XHUDvU/Y99xajS4BsVpWu0ciAnv8J1c4oLWdy3UnCGvKH3Ur7EJJKECGKyu1nH/4pKnkvRt4xVltGi3tr7MPZ2AM44W+cwAxr/JXLEFlg8V8+5haLRahvnNmJJRkMLaZZnXLUGd1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968929; c=relaxed/simple;
	bh=A3rvNv5tLE6sXzjWetLlKSM8k2q2gEXk49EouZJdocs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GINPPlPYnA6JWZyFhO4xjwPfCbCtBrSy+NfgzNM5Ba9ddOjVods2681lo7ch6UT1rQPiCBBuAlt1bAQiPQquF58cio/t5bpyK0Pzk3PxvmBkgl76JIrSB0JmpUcVJiSSCNmGue0DWyaQOuI0WwvmThBADnnAzK56JMK9Gq7+taM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/UKW17+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24b0e137484so6646435ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968928; x=1757573728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7jyzFRHHiSGpkjG2s+KNnXbL/OeDAvT2CWWv4I+ohEc=;
        b=v/UKW17+yXm+POY8T+V38W1I0sjblkHsI+MFHch4DhumNF4VSPrywAguzrCRGPlglh
         LgnfG1OYHk9WSDsZ9Uh2dZJQv7PHZJbA8o9C7N9yojS7z+LMfpVdeZNw58ZUbZ8u4ku/
         syNYliZQe1ov94Q+sZSLYwHqB1/5ZdnjPqEL0tfxCrCI1CAgPbIiGrP01WCqxA6DJCzy
         a+7re2latKmqMNmLfJujocCq5fdHUnDXJ1L4KEO32OY2vXA/vg5uWL5NEy02tAUSmXwh
         n4hDYILU9OhZAFWbFyZGDZJXIBNcyQdZDIdEXzETD+GQa0/JQd6WFV/9WB9iGlHhX8KL
         Z30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968928; x=1757573728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jyzFRHHiSGpkjG2s+KNnXbL/OeDAvT2CWWv4I+ohEc=;
        b=OUUJK8qi8jHUVToVPO+XstcKjNXqtj8BpDBG9JT/On/FUhH4/bFXRFUtmOm9wFKXHN
         WqpeflX9AaGD7oZH0US0QSTntU5OPnYmyp3OabX/RZ2nAyBZv8053v7kuAzSIdDYk87c
         KAO+mcx/Nun3PwsyZXdZxY0GSDcLnCvVJoGXXj0DXBSUdU1C10NBy5w/x7kxmm8Yhm5c
         A+pcwSKgRrIULTvaeYM1buiQtIxz74GChj7Qr3/FfwKL+ikGszB8+8vmIRVp9SZ8IsOm
         tXCNnfRFSIaDNmkPCQXE/gZkVgiU/jwsujlkQMdiStChx8Zq7QGWgKSWzkWzUSmwFw+L
         qrUA==
X-Forwarded-Encrypted: i=1; AJvYcCWPaL6esDIsicPtTu2Ue7p8lm5QIJt5pL4z+oMqNw3f6gsiXSDl3M5q/WdsakLZ1Di3l00=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9rB8GUMqSLnnGAOklB9JZS13bPnEC3ESE5s7oLjRJpoNr2zZw
	Gw51pvj9G7Kr2urRp5drilT2O+2SzlMdRceCkaXfVeaLHiKWPKjBeYk8aNmAEFOxCb3zFCTpmix
	WQw==
X-Google-Smtp-Source: AGHT+IFvmfVW+KjlSTZrEQuN275lpqi6Zns8OFz+/5+P3JxjVk+2+fXszGsfdn7feAXTaG2YLUI81w0/kA==
X-Received: from plao20.prod.google.com ([2002:a17:903:3014:b0:248:df48:c4e])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce03:b0:248:cd0b:3454
 with SMTP id d9443c01a7336-24944873445mr201783715ad.9.1756968927646; Wed, 03
 Sep 2025 23:55:27 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:46 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-17-sagis@google.com>
Subject: [PATCH v10 16/21] KVM: selftests: Call KVM_TDX_INIT_VCPU when
 creating a new TDX vcpu
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

TDX VMs need to issue the KVM_TDX_INIT_VCPU ioctl for each vcpu after
vcpu creation.

Since the cpuids for TD are managed by the TDX module, read the values
virtualized for the TD using KVM_TDX_GET_CPUID and set them in kvm using
KVM_SET_CPUID2 so that kvm has an accurate view of the VM cpuid values.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../testing/selftests/kvm/lib/x86/processor.c | 35 ++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index c255fe1951be..b1e5f4137629 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -685,6 +685,19 @@ vm_vaddr_t kvm_allocate_vcpu_stack(struct kvm_vm *vm)
 	return stack_vaddr;
 }
 
+static void vm_tdx_vcpu_add(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid2 *cpuid;
+
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	vm_tdx_vcpu_ioctl(vcpu, KVM_TDX_GET_CPUID, 0, cpuid);
+	vcpu_init_cpuid(vcpu, cpuid);
+	free(cpuid);
+	vm_tdx_vcpu_ioctl(vcpu, KVM_TDX_INIT_VCPU, 0, NULL);
+
+	vm_tdx_load_vcpu_boot_parameters(vm, vcpu);
+}
+
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_mp_state mp_state;
@@ -692,15 +705,21 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	struct kvm_vcpu *vcpu;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
-	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
-	vcpu_init_sregs(vm, vcpu);
-	vcpu_init_xcrs(vm, vcpu);
 
-	/* Setup guest general purpose registers */
-	vcpu_regs_get(vcpu, &regs);
-	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = kvm_allocate_vcpu_stack(vm);
-	vcpu_regs_set(vcpu, &regs);
+	if (is_tdx_vm(vm)) {
+		vm_tdx_vcpu_add(vm, vcpu);
+	} else {
+		vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
+
+		vcpu_init_sregs(vm, vcpu);
+		vcpu_init_xcrs(vm, vcpu);
+
+		/* Setup guest general purpose registers */
+		vcpu_regs_get(vcpu, &regs);
+		regs.rflags = regs.rflags | 0x2;
+		regs.rsp = kvm_allocate_vcpu_stack(vm);
+		vcpu_regs_set(vcpu, &regs);
+	}
 
 	/* Setup the MP state */
 	mp_state.mp_state = 0;
-- 
2.51.0.338.gd7d06c2dae-goog


