Return-Path: <kvm+bounces-49503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB51AAD9556
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47C027B1AC0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052132E92C5;
	Fri, 13 Jun 2025 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mc03Tefr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE62E888E
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842092; cv=none; b=hAyYO1WghZ4BbVcEp31ieGBzc4KJPXXPKlw2UK8p9oDURhbuyqqGWrXjVvpstZt1W1n0m1OY/NEZFy4+Hbe5H2nHeDsopEk41mgpjwFp9kMyuf+TIUQPEb1gTafK5BXwEh9wmi/noTfdS2wb3oxA8nOPDn8vqqXgUL607h4yOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842092; c=relaxed/simple;
	bh=EYmmSlBF4C/72f7adu2xrFOYMqAVykY+Yges75e1mk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZjuR3tHW4UbRHmDUuP83CRb3INtowqW8eheu5t/iNnBEHtd2n9EEqhj4UlCNA2KLouNGYXBQAEYjxJCMmcqdL/evfYSwvwLj6VgE2pr7ZTUs91QZe4ZeWwQsC49kgbt0swJZTUGYtHC0H0TUglBvLC+zro6ueuGgSlpBNLrfLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mc03Tefr; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7462aff55bfso1856310b3a.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842090; x=1750446890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQS9KEcxjrfBhT5g6y6btmmw0Zrm/EBAnz28lESsUJQ=;
        b=mc03Tefrk34C1Ez1tsp8bzS/pW5L/dgSM+oDnEu8kCEz/Hf89u5nPArn3PDYVLZZwh
         mHlLRe4CIAVX/6f3Q37gpzPfFUFVhJS3fxHA1fuWIi3xOPTvPG3ZIq7tADUB4UZq/CXd
         6/FtXg7QLDu4mJIhfHoRK/IZHUQKK9jsQOx7Ofyv5o5apTWYHMF7Fo+IVtv3se5WUaLg
         Hduq0xJZBM+yO1JHaTsdyuBtVjbMRWuJDHsNKEh/qcOf1yWXprixmY+PNDqinuSz3KGg
         Sm1UiRxFUiuW/FlVIOiVpIRFj7rXS4b+Ut+KaH4zCCfPoxJhZwCFCeoviz4jEVFpZ0EH
         /Btw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842090; x=1750446890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQS9KEcxjrfBhT5g6y6btmmw0Zrm/EBAnz28lESsUJQ=;
        b=Q6kqy1awB8jHnSuyCF+ayi1flgaqwJR83m+TIl6jHDrwcQCznuUwf3ibpO1h9EO0jZ
         DJKexHEIv32XG/CH8BGNoR5Q+IQTV/0+6ywUrKyAnxoaOb3Psr4J6eKinAGCIEsj4S0g
         YNzxNg+9b9lmAk/p+TgUcd4mPsPiHZ24t9oPjR8k3tG0Jy40TxmLDLdaFdPgryc3vPWI
         ynKfFUVIWVpD6nnMYFLrA4xPaTUVrReyAjn0FT3hoRj7RA1KlXnuibGHh7tk0qzZVQTm
         Grrjl+hH3EHky/8lqPCrbK+58YmiXnZtdIxPTSnCnIzuYML+GPcFvf2Wcy4yveNpcEfA
         5OFw==
X-Forwarded-Encrypted: i=1; AJvYcCWBD9nVGuRDiHg07wDVK7qrdrfDrEIW2BsfMeuycdyju39kS+5mAhyStzPhZ9itzU5NXUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPiESb8XXgEz3DJGBy1KeC0SspcFU6sDwbY2b8j0kyVZkVah2m
	WS0Npg/q6cms5VwAJcNZZc8uz8oP2vGlxUnOtx4UUctiM1XOh0zCKsCX5gIXf9gQA0XMKo0fi1+
	C9Q==
X-Google-Smtp-Source: AGHT+IEOP4GrUzQcNjvdcHvZ0T90I3oYrH2Eb488bsbJSQug0p1LrqzO/9hpSqb5M4HMhpMKbNB+gqPsIg==
X-Received: from pfbhx21.prod.google.com ([2002:a05:6a00:8995:b0:747:a9de:9998])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2185:b0:736:a8db:93bb
 with SMTP id d2e1a72fcca58-7489cdedbb5mr672632b3a.5.1749842089751; Fri, 13
 Jun 2025 12:14:49 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:52 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-26-sagis@google.com>
Subject: [PATCH v7 25/30] KVM: selftests: KVM: selftests: Expose new vm_vaddr_alloc_private()
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

vm_vaddr_alloc_private allow specifying both the virtual and physical
addresses for the allocation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2e444c172261..add0b91ebce0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -652,6 +652,9 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 				 vm_vaddr_t vaddr_min,
 				 enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_private(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, vm_paddr_t paddr_min,
+				  enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_identity_alloc(struct kvm_vm *vm, size_t sz,
 				   vm_vaddr_t vaddr_min,
 				   enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 14edb1de5434..2b442639ee2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1503,6 +1503,13 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 	return ____vm_vaddr_alloc(vm, sz, vaddr_min, KVM_UTIL_MIN_PFN * vm->page_size, type, false);
 }
 
+vm_vaddr_t vm_vaddr_alloc_private(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, vm_paddr_t paddr_min,
+				  enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, paddr_min, type, true);
+}
+
 /*
  * Allocate memory in @vm of size @sz beginning with the desired virtual address
  * of @vaddr_min and backed by physical address equal to returned virtual
-- 
2.50.0.rc2.692.g299adb8693-goog


