Return-Path: <kvm+bounces-11864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 523AA87C66F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E702AB23532
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748C857337;
	Thu, 14 Mar 2024 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ReKB1Qn2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85D854F93
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458830; cv=none; b=RYf0wZgU0LzFKzAMMNlKAP8Z9Roy1AJb4SYmLhlpcvAO/2T2TuzA7kVROqGGZlAAc1tsrwibnPaJKswps/3WqjhSmo2QQs5vDnkRGJYZ3ZjIZhl4F71DY9YtZPtoAArPJPbH1FpxgqxpwepCYYhbN+l1V0Iy+TQFSIThTZf+RKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458830; c=relaxed/simple;
	bh=jUV1XZXOApDn8WUrRGJsIujEhPRAE62JvDa/WRT16zw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I9Hwntw52di28OYqoXRa9Tj/cNYkqgimCG95MyBYdOhaV7zALR1/FIWQP6MxvjaykR+YdMbDM8KDswaCsvtp4Oo9+TDxJdjkIZDKvg+qGIXwRbSAdfz+vmbqhb5OhJjzgEXnQnvpkPfNDIJQLFd0Pr3RCqt5pjKrO/MXrTwEOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ReKB1Qn2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a20c33f0bso26524297b3.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458828; x=1711063628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uF6G18lAXQi7SGjNgTcxotaL8n8pv6tjDstW0Eyh3/8=;
        b=ReKB1Qn2+k9AbxeqOKDN15hZigiNAx4WBg47yVUrPgZ996NzhhQqOptjWcfpVPTPio
         lRkMdf9UykW4zGTBTzW10IS7BowxAtBwgSrNihTarK2kV0jUvW0BrI0oWKHrFsDjmtX0
         UEIIvioN5dm0sYs44R1joQ4oBrgrgr+r4i33+y5PzYXpJhG/D90UqJFt9YB0A/p0b/yz
         beyrI4dd0QzJ0VzK5z3QhGzi1yxo4Nxka5zDSwojvsw57mXibBRYOkkyb1Gc1ZqhLC89
         9gfEUSYnjQyTF8OBBA3bnPU2ge7WRoJa4ryjGe+i+QVxO8XYcOgGmhjX9d056olnjryk
         ujjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458828; x=1711063628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uF6G18lAXQi7SGjNgTcxotaL8n8pv6tjDstW0Eyh3/8=;
        b=FHmiASXzXLkUO6aqCz0FwGeGx/sdZIj5lmxScJf0zFB6YVXMVab/VbYeBZafWUh9Xw
         Q3Zoyx9fxrOM6UrFafeJc3XYNWRoZJjyOlh2puCxZGqckiPLyvIBZdQySjAT/CVHTtZ+
         Vbd1NdOMH6w7+6b8S4JNtNpGw7t2CEGcERzSLTWy2hzOj3p9UaAdYe5VG9ZSxBU4+dSN
         UUZyCFLcuDY1FP86ZDNMmaZJm8RDU5Mqz6S627k9tJslv4VGg+U1A/OJZPrDVUoNjoVA
         t6ZO1f/4mz8VesHpIzZgfsoIpGJwXAJvA59AeqYQe404kZ2qf0HlY08d4bhDaYOKJ0TK
         NRrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9asbkPoSowzgrUaGL9+DvazICnnKA83Vy32AW677haJ3P4gsUawAn1/VjyfEF+7rP8Oab3OieHfbes0z9YWJbJzZi
X-Gm-Message-State: AOJu0Yy6vjRwBKwjqLcfmFXDiaZ6BOCT9KyhDHVbtBkr8OYaFB/QpbKh
	FAMU/+SNRr177EmBIOvSp4zEbd4YaDCgcTrcPIzI2b6u+KNj17MbJrkVVd0+WuJUK5jRb7BeTz9
	vgQ==
X-Google-Smtp-Source: AGHT+IGMAa0pMvN41GmLVswUQh74G2T7pDQzvawBbi03BR+h8KyfNdFr8QIGXJ12aJ6DdfK8GuReLQ77fHo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d5:b0:dc7:68b5:4f21 with SMTP id
 ck21-20020a05690218d500b00dc768b54f21mr168369ybb.9.1710458827844; Thu, 14 Mar
 2024 16:27:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:34 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-16-seanjc@google.com>
Subject: [PATCH 15/18] KVM: selftests: Allocate x86's TSS at VM creation
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate x86's per-VM TSS at creation of a non-barebones VM.  Like the
GDT, the TSS is needed to actually run vCPUs, i.e. every non-barebones VM
is all but guaranteed to allocate the TSS sooner or later.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5cf845975f66..03b9387a1d2e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -519,9 +519,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
-	if (!vm->arch.tss)
-		vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->arch.tss;
 	segp->limit = 0x67;
@@ -619,6 +616,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-- 
2.44.0.291.gc1ea87d7ee-goog


