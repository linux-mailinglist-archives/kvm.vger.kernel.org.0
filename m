Return-Path: <kvm+bounces-49481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B416AD9512
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD6457B0923
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A7A25487C;
	Fri, 13 Jun 2025 19:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xWzCelGk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D9F248195
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842059; cv=none; b=UNpn9fxMmnMbt94M7cxIc4sddZbJArlFUsoAt5m8KX3g1eTdOd7AzyhEV1sASwQ7W9Yf6p1Kwuxb9Jj12DISO4vGYNvDsyWvAqSJmXQGSVpabFVHZGEJE1qju9tjTk+dvBVs8SieBhp6e+Bc1yoMS/3UcSOYpUHwRkGqL2tL47w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842059; c=relaxed/simple;
	bh=CZWxcHUWIhBEiyWiB8Z0zKn1NDMKTAMio7jW/0D0t28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YtpYFXUc2wVfGXN9APGZciOvDmbXIVL1j0ZbYVTBrC198Dci1FJsX0GFNHLAiGi6pPFMhTX8JFW/VvsepGxjDKf+M275Hu2fuYViKBESsV/kjD9KlxVownX9E+tmA+nrjInZR8cHwZdzBTkCF6j3NltLaB/PeBBgfZwUd/+Go94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xWzCelGk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31218e2d5b0so3640008a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842057; x=1750446857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGEpLUgqYonvIFbVng+CrES4z2xij5mJ0NWE1vzcGwk=;
        b=xWzCelGkIZ7DRH6ns82atV8v2tof31E8Eun95Ns7Z58js8RBx1UmOwMI6Xd5LANNjH
         8XuZJwcdrGRMRBvvonc6Dbjn02EGZcgDShh4M6pmSeHaNDcDa8UKeplFzTt+js7pFlP9
         ZYazBoXiOcDvmNUVhEsKInSj/2EjksOD8bPZmFDQWqY+osTNYOhQC1Yk6I/8c/Pf1Oi3
         KS1ndoObwWcKA1FULqJzZ1BCjftrbn/FunB0xlhbua6f8lvK8MXpDY/H+6zwnlWOwP91
         sHfy1oi2wVtmIgDBV+VGrdLGC45KIZuj1bpma1fZM0WiqahXbEz1qAzIIdWYPXdU7Pl2
         Bm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842057; x=1750446857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGEpLUgqYonvIFbVng+CrES4z2xij5mJ0NWE1vzcGwk=;
        b=fMMVrFuawnIGRcuJS8efxn41JwXYR/7mJccNw03y1qsmQ20bP4GH56i3tdi7u/jm7z
         4bQVaYwci8wzetd9BpI/U71Gsu9pEasqeNa7j3toJSlabG6q1wjHW85MuJnqwlaoAk3R
         yG1WkyRJnSfEPCWuAOTsMVAlf4fvxC2g+JNdoV9efcn2DYqMSuneB3wiy474QOXMt0to
         qDZVVC+3QeqCffH1cQwR05J7gDrNdWOZN5O4mlVg0NLW5WJHZ3Gs2fw49F+qdDl6+IMj
         6obNFfJ00hB6bk22YG8t3qOua1CilXPlmYEFrLZ+MDCdIs7rFzbnDWLtOTuPiMj91LtA
         4ZHw==
X-Forwarded-Encrypted: i=1; AJvYcCX8foUML5vSn49B+Ng3oTXyZI8CUBFQznI6D2KWDtZZOWbwdxxPKbG9qrSfmbLyqdWYuiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0vvTcW2sZmORP9fDrocoTXqIkdDmyhp91euVuB3oRc0mymcAf
	YORYYf7THthTgw4uC+cDTBtakInYGUtjEL8XBq815YoqPKixVaVIMyuruNnljNs8b9IhE/q4Mcm
	KjQ==
X-Google-Smtp-Source: AGHT+IGT7zb30UgV45DG78+lDcZgeztvaDSS1mxGV5acscZ5LWb0SsPW7nfVbgggzN4Y8RwiM+4/xNFPgg==
X-Received: from pjgg14.prod.google.com ([2002:a17:90b:57ce:b0:2fc:2c9c:880])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5284:b0:313:db0b:75e4
 with SMTP id 98e67ed59e1d1-313f1d2a17emr1364010a91.33.1749842057235; Fri, 13
 Jun 2025 12:14:17 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:30 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-4-sagis@google.com>
Subject: [PATCH v7 03/30] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

Store the stack address as part of struct kvm_vcpu so that it can
be accessible later to be passed to the boot code for rsp
initialization.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h  | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 9994861d2acb..5c4ca25803ac 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -58,6 +58,7 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	vm_vaddr_t initial_stack_addr;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 002303e2a572..da6e9315ebe2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -694,6 +694,8 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu_init_sregs(vm, vcpu);
 	vcpu_init_xcrs(vm, vcpu);
 
+	vcpu->initial_stack_addr = stack_vaddr;
+
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-- 
2.50.0.rc2.692.g299adb8693-goog


