Return-Path: <kvm+bounces-54275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 825A9B1DDDB
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A279A0009E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B89122D4C3;
	Thu,  7 Aug 2025 20:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k68Pe9QS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE2B2367BA
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597805; cv=none; b=ngBputpuHZkVvrwRG+j5obyZJkJ1iIL9QQCtkZ8x+haW4mKXwqJdqu9khmgAKSgEMXf8n4+AtXRd+TwvpDZOD7mCb0/gC8nB4r1U4CIYhNGUEdr/52+Dv8JlVIKQ637Oh/7Dr0l7CUUXME2tu8ZQhtU7Gj5vBa9s0Jho3IV03rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597805; c=relaxed/simple;
	bh=vvoyDwfrz40cXS2E/qfKw0KPWURpKZQSXbiY0G7zSzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gaZ9O5UeOzltq9kphLYOU+MRtSnQXqhkCT4GIzD2a86r4U/d9PNCoZEHsP3pUhxxG13fw5v3GmHqaCeyx+7TBIiiiaLga8G37kPCqp3G5s6dYsOt4W8qq9feqSJSAG1vNFW68Vr8TG3sABrrK4HDDhUfiPR6GlPPhFrrjehLVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k68Pe9QS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ed2a7d475so1426617a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597803; x=1755202603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZhMhm+oGoXjR1ZKMvnfqRkH9sxXvmJdgGAeHzetkDQ=;
        b=k68Pe9QSBBrKDbEBN5dUL1XNCnuokeOQkA0CnjBPEAkuCVl3X4m2aErekq/HEpm2vJ
         a4i2Z94Rz6n6CM2LYx/wYFRFNtbixIoYi1GuJh+lw7K/py6pvAtfPFlqN0ccCduLITbe
         v7b94KAmE2h2kT4p8NhdW3gBltVXJiipGbwjcG7dHJwpkKxlq36/kbg3jqsjG6a5sa37
         5mACZv9JfwpLcDN4z3DSEmXRoNiovdyUfH2gtSeJDzDs1F4YdgAUW61cGjU5RQCWzXtz
         Y83LaCpfzYbbw3nNKXJmJbh6MeENE58TU7XyyOmbwyiz1+j37ap3EQY3oQiEfcam+zjQ
         p1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597803; x=1755202603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZhMhm+oGoXjR1ZKMvnfqRkH9sxXvmJdgGAeHzetkDQ=;
        b=bzdsxVK1IBRlFZlf8UAArHkglgGzYJOU4ke+V4mTQxKIWbFiloOowS4Y2gp906N7Fq
         rtHu6ji2CvTacVs0qdeZgBiMP3s+UK+0h7kDPufIjFqVCLLnG9MWne9XxivXeJd1KspI
         Nadyh2/F2gHlRtt3cXXXMXJdRKgq7pAlJ8vAY5BPzgYLV8S5NvhwJtuRw5WLFwlWXsoO
         WwstW3Zq5U1qxyYuFjJe3d7mXcywZTmtL0vQRjfEUlzxWxwjn71LrCh6mcsZvYi2fhyI
         s/fUyaSNq9IOLn5kaHkdvbJXvOGxwgDX3YGE1pFmFxwJ8AtFDtbg8tYVFUPzKXoVzzPP
         dQig==
X-Forwarded-Encrypted: i=1; AJvYcCXNeIhgZk9Xyy769Nj1OzbNnujPM2F8pjP9qTv66Hgb4eSAwjiUDAp4AdAG6LARpuKSjF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY9Vib5F+bNnx6wnPM3amxnFIi5Z55+dLNK/WnKcUZ+erMhLkZ
	mIncB2Bn6YC7KdSDKVm5AQRbWYPErwgAzwP3kOX5Xs9d8CWR9akco4DtzSmsODuLunyFPO2eJkF
	v4g==
X-Google-Smtp-Source: AGHT+IHjDcLQX1WhIoIZLM1WoaOz3EieXlE18GHV1p955qAC5wr4S8qpo4H4d6sFinEdYcxFY537Ys6L5w==
X-Received: from pjbqb13.prod.google.com ([2002:a17:90b:280d:b0:31f:61fc:b283])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f90:b0:31e:c8fc:e630
 with SMTP id 98e67ed59e1d1-32183c46068mr418295a91.26.1754597803497; Thu, 07
 Aug 2025 13:16:43 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:00 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-5-sagis@google.com>
Subject: [PATCH v8 04/30] KVM: selftests: Add vCPU descriptor table
 initialization utility
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Turn vCPU descriptor table initialization into a utility for use by tests
needing finer control, for example for TDX TD creation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c     | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index f2eb764cbd7c..37ad1e4d86ba 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1178,6 +1178,7 @@ struct idt_entry {
 	uint32_t offset2; uint32_t reserved;
 };
 
+void sync_exception_handlers_to_guest(struct kvm_vm *vm);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index da6e9315ebe2..d082d429e127 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -585,6 +585,11 @@ void route_exception(struct ex_regs *regs)
 		   regs->vector, regs->rip);
 }
 
+void sync_exception_handlers_to_guest(struct kvm_vm *vm)
+{
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
 static void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	extern void *idt_handlers;
@@ -600,7 +605,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	sync_exception_handlers_to_guest(vm);
 
 	kvm_seg_set_kernel_code_64bit(&seg);
 	kvm_seg_fill_gdt_64bit(vm, &seg);
-- 
2.51.0.rc0.155.g4a0f42376b-goog


