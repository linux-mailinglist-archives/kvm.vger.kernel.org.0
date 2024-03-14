Return-Path: <kvm+bounces-11853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B29887C656
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6E011F21139
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EB118E1D;
	Thu, 14 Mar 2024 23:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3BBKRojW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA6A18027
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458809; cv=none; b=aLF1hsmPLP2oB4IVFXsnudiHrKEnGpGvEV55q/7QdBkb9eiWYWccb8U96WPcxA6T/YQcARkY3cFk0UczwmFvpExh5CAuRZ7OWZzR8z4x+uyz//CMi7wTi/vOMLxWoCIOLZRVRntfsdeDgZP+hfB2HjikWjUJn05gwrKthkSieDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458809; c=relaxed/simple;
	bh=hVROtGdDjNDokjJTyibuSKcjvmcYXHYDj2oTedDMiks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0rMFq9NAWtPfci5MBJ0uQN1eMT0XibBK3M1zPng9juHGGXGHjf2lRgYPw3NqTaCTZ/JPEG+7xm5hEq7BMU+KSweNR2vrJhh6QoxIOtfaWfe4T2ZYIqkwNAy9/MT/pQxXBRbnKpbKTkvXBXcL6BK8dHKmh0HbgIZF0l1lPgA6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3BBKRojW; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6dd65194396so2131671b3a.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458807; x=1711063607; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f7mdClvgIXUuf9+yuKM3CelLdMACw57Fq4PBdMk33ZU=;
        b=3BBKRojWR/jRYG1n/FKYWL5/dqIp5HYlcuoZneAhJoUI68SBSUM98/RfD26Taft5bx
         +ga/ChJEKn5Zg3O/EChjn7e2tUpWI5MGpCWsOaHxfUhbOuYTP3KfEO6IvsdRZdNUDcwb
         we6eiHAn2YrDnyE8g/NLOr6Rn8wdz158ZQGEBI4vefEa2vA3ViHgorXE3GFVztaUOXRs
         34UNS3o+6zVZFCf1C4R7VzgU2XWkJKu/Ye9JJfTqxLLrNw4+i5f27yUiq8iwm4JlmFgz
         cFfbrtIKYkE2mww5pjA8tW+q0WGwazOz+GD1QI9Yd8F2nnno6ySRdvwSUA3vtpubhMZy
         YGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458807; x=1711063607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7mdClvgIXUuf9+yuKM3CelLdMACw57Fq4PBdMk33ZU=;
        b=WLUGzEXB8dw9VkQdwozjgmx/wmHXHIHeKOXxkgokq8Yp7GSh7gUpmpn/6KzIapMYxK
         vnMKxGU8GP9AfJ3ex4+xx9O6m9rBNohenZqjKFPgWvBTiHtw0uN4oNUMVt2ZVieeSx5O
         gvge6Tr3SFASTAqhwVglyxHE+N6ScTwTEQ1Hx6Cif0E1EW3THI8RlngK6fBRI4L3fhgf
         SEB5RyYf2bz+8ollYGPrEDMYjYM7AA3Dw399v5OjTqLQZxvvQ1jDBM1nxlNhqhrhYDkO
         FKMzl1d2mhU7qqqaaQ3zlxym3yAQRVQsyfHqr+WxB8qh/I1pkvcReRpKzzglW+F+Qi00
         WkJA==
X-Forwarded-Encrypted: i=1; AJvYcCUTuuF2MePA7xfHGcVTKg/zHyWFQuYoYvDcaYFwxzyQ/aZPrx6RxJPn7DeeQ792f9GAt1h6+V8Cke98MkFgyG3V1onP
X-Gm-Message-State: AOJu0YwdTZWcsE7ASK3VuFTaIZDrmwCepIWhEQv1Hq5hZR3gafGAn/aO
	m3qTSSdjHM9dbW4vL0WmXLIvwj9GlayJ4QS+YAIHak6sxX5uf03fHsb/4+gostUtnC3PWUhBktj
	NyQ==
X-Google-Smtp-Source: AGHT+IHP+9uB+bS3/lKcsyk7/8c0Ce59jwpM+G35vfnwrWKSRS2+iNaQrX8dqel6o4dt3H0Nsgf9UIQa3fs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a:b0:6e6:eefe:945d with SMTP id
 h26-20020a056a00001a00b006e6eefe945dmr9863pfk.0.1710458807233; Thu, 14 Mar
 2024 16:26:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:23 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-5-seanjc@google.com>
Subject: [PATCH 04/18] KVM: selftests: Fix off-by-one initialization of GDT limit
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

From: Ackerley Tng <ackerleytng@google.com>

Fix an off-by-one bug in the initialization of the GDT limit, which as
defined in the SDM is inclusive, not exclusive.

Note, vcpu_init_descriptor_tables() gets the limit correct, it's only
vcpu_setup() that is broken, i.e. only tests that _don't_ invoke
vcpu_init_descriptor_tables() can have problems.  And the fact that KVM
effectively initializes the GDT twice will be cleaned up in the near
future.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 45f965c052a1..eaeba907bb53 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -522,7 +522,7 @@ static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 		vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 
 	dt->base = vm->arch.gdt;
-	dt->limit = getpagesize();
+	dt->limit = getpagesize() - 1;
 }
 
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-- 
2.44.0.291.gc1ea87d7ee-goog


