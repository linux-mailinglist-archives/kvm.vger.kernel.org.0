Return-Path: <kvm+bounces-49482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 736B8AD9516
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 494253BAB57
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE4B2571D7;
	Fri, 13 Jun 2025 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3VVGb4jD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9D124A041
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842061; cv=none; b=RsG0M2OCqDF5n1/3D03NMggfsuiBd3RIwHx/hbHlH59gNyjNMVkl1PjXSF2empQRx1nzL7l1M4Xg0GFpuu+/dsDtGE95VuEp81ykXSIppXhXtVk/vDxC/w3a2yUpnXa/dF87AThwxlaqVQCEU+amGEebH8l2f8gQgl8GxAFx46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842061; c=relaxed/simple;
	bh=rcNojIrkKk71ZnhBfmVVb45xpOUbdROsZ4vsY+fOfXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1ECM2CtVUyPOleMCH2W7Jd3gDZ5sIb8WnrHapUF7Fto34NOvkcSbIw/r+CCH6GxUzk9pTYUVk4F72Gg12TEhY9d/DYQ5U0sfgBA9RzkFwbR9nA391btQiRR3TvviJX/u0jthPXsebCfg8u26mnaae2RppT0BHlaQGMdwOdTcFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3VVGb4jD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so2068596a91.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842058; x=1750446858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gcb9ynWPHJDnOBsaC+w2WlTETP9YsMoWaIZTF4OWeus=;
        b=3VVGb4jD0ht45eFYVRBwyFPG+6Tiyius9NlrGnIVY+TPsyeXbLgurSUjB+gWr3/Xy+
         uWy2Edbij3ynqh6p36w5D1RKemjO8O8YgfthsuUZvAVtRkBjOn4j3sd23DOmMEYmv3Yq
         lSmwMFisjypvc8HHBOnz0R4G8v3+jQZ+Lcp0IcD+Ow0awWMq2eBtHv3gSC2DWFvJkWQr
         M+kkCBtemAqzmyUnSFMoiPHseB3PbxfPCttIqrCBNI2homAQ3QLfW5cDJA8X3HeJdzZc
         iAgbXSp7LVgQ6z5ZSwolAYpdZbMjUsbxJbaYdLEpmyOyQkgYuO8WZiGD79VqjdYKni4M
         hcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842058; x=1750446858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gcb9ynWPHJDnOBsaC+w2WlTETP9YsMoWaIZTF4OWeus=;
        b=IDhO0dGH3OLt8jinm6P7gGGFj8ebf2ce7JccqDnrNSR94A2xbsiutDIAaJF8MVBEfS
         QoAcRo0AWuhciOngxW0UNrEWFs3BY/Epfw6H4TvY0wA+330/X1rfcL/S9OIWCc6vbP8I
         HqSq1LBqy2j8BVrRcGrSnIr6pN7MsqPRbDqWbwImMeXg3Ustd75NhWMivxX+8Zsk0yVn
         za8HDOlmMyuqSKsN9AxxTwPOe33bSm6XazmL86ejpBAzS8d7TtiseT43Q0LnFQAg8aZl
         t9x06smwbCC8zqlp834AZzNbAl3bBIY/5S30szy/La3yyDg9uc36zYkEdqJmnMfL+jwY
         KEAA==
X-Forwarded-Encrypted: i=1; AJvYcCU5qrCVHYSQiUoch1s9YkAT+iS0oEUluZqRI4bx053faahi8CVEN5bMP7RDVe7f1FvkgOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf2Ptqfa9aQJKkX/v3gD7c3qf1D0zas4AgNekvqE/Qyx/+rGQ1
	6lUEnca0uAinXFajFjhPEU/1MQQRFyotaaeOy81ON1zRFhUoBTQZpPmOykdklix9bY71R8ejAMe
	XyQ==
X-Google-Smtp-Source: AGHT+IEsw8JvuYmpQZvLNlubbPq4JN8tgwPDg0ZH3gf2iYtNn2ncDksTRsRAcT4gWuA7GIhv67eR9tNt9A==
X-Received: from pjbqn11.prod.google.com ([2002:a17:90b:3d4b:b0:311:4aa8:2179])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5250:b0:312:1c83:58fb
 with SMTP id 98e67ed59e1d1-313f1c6f67cmr1129215a91.1.1749842058508; Fri, 13
 Jun 2025 12:14:18 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:31 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-5-sagis@google.com>
Subject: [PATCH v7 04/30] KVM: selftests: Add vCPU descriptor table
 initialization utility
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
2.50.0.rc2.692.g299adb8693-goog


