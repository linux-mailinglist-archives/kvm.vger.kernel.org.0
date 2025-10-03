Return-Path: <kvm+bounces-59484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 890BCBB863D
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2604019E41F8
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8FD2C08D5;
	Fri,  3 Oct 2025 23:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cRQCnXHj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8122DE70D
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533988; cv=none; b=U0UP9q+TjSDvY3xlBPbTH50InN8L+ml8CMDJuuFnWwiI3KE6PDNkwjOddCBeBw+BkVHw9dQhooByRvTqtBmMRv5VrnSh+wqjuTe8CqTd4JZH91uIfqPXos8ZZOYFlK7YPxJ2A02lGfsns1UEe8Y4s0CZa81UncsJr4mbRB2tQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533988; c=relaxed/simple;
	bh=BhNjeYFnokF+ua1tIz2LPgXh7HZumKowhDkAoR9n5/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hWKpEZpsZukUqn3H/MG3MrySmtTPmVR4g6+6rHUflGY+fALvNFA6MxfyvepSTjebf9modF/6rVdpkLeoyZLwKdjJlWf/fGvFuNU1O1j1rTOePmT12/vCxA1WBeZs46qntGlrnr41oEd6nYJ85bRGyDBG+Dv227jhmFeRh9LgWio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cRQCnXHj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2697410e7f9so53575265ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533986; x=1760138786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xXKfxRFAWdW67r2vJNGKUvHwEwOyssnfYlc7e1a1sls=;
        b=cRQCnXHjIMiSJBqC7T4VhxM9qBrTFH1xG439IsB2THbwDY4JYU69VJMqGEUMwY9aJ6
         xjA/vB5Zgjk6GacmAMQcy4Lj0AhV7NsXQIeEXayJI/t5vqaiO+1kmBffCt85zCwDVhcr
         B/Lqy0KbW4a3xIK37bZL2APzHmQTdSu6sLDzhaUVbGZqsrvel2tgzMQzfeKU6Mv59V24
         kj2NY7EQ9KpJmO2MDmTziWcYj5JpxdXN1hoA1L0459wbHnPJe2UDA9eSXZjyUFGoUWEF
         TjykEUgHL07e2W1L9e4cvhCXPHpLzvA2u0gp710Qih7O4G7iO448FVwKKBlrRCWNi1uG
         km9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533986; x=1760138786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xXKfxRFAWdW67r2vJNGKUvHwEwOyssnfYlc7e1a1sls=;
        b=SHTvPcRDqQ4FnZAwNCYrMzS2X1Z9GZ9SNYslRvVrdMdswCxuCdDj8tC6FYK3QV8+pD
         hH75LU3JveZyLov/tlTspXX1PO+Ja44S0d0qk9W1Ltlcd6RmOCYqVUyMqq1JrUMMijF1
         BbkLeop0b+cBt/6czGue8QemEFEFMZ1KQAgwCzC3s8EjsmQGOKB8FI24MnahYD0BUB7c
         Wyp2V6Fz6GDNK50+hYhB+Xabh/7B+z6lR/z8rwTQrDOvveTRagsJaK38Nv2vaWM0H5VZ
         RwKCFhn9RWO9JtmVyISyso7J6lnWHNkzzVNc42RYyecJrGOkhmcCLN02TcTPcPsI6vc/
         qqDA==
X-Gm-Message-State: AOJu0YzDwYqkh5DEcJnGzu567eSIfO0vA1UpRzjAhi2vpLbGJW4sPgGf
	QBjMg38ISpmIHjYfRD7eFpbQu6LkONh6qyzTiU4T4WSTT4YrZ5LmUMgw7PXvbtzE7qsIaaelO/5
	qh5jHhQ==
X-Google-Smtp-Source: AGHT+IHbwSDrgPwwBMoC86LZ0150nH47BB8TTUv2JzYBTbBocZiPvWuMmbMAGYRM+VW0iAgrepLc0aq8W/A=
X-Received: from pjvh15.prod.google.com ([2002:a17:90a:db8f:b0:330:6eb8:6ae4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3845:b0:267:af07:6526
 with SMTP id d9443c01a7336-28e9a693c63mr53558535ad.55.1759533986435; Fri, 03
 Oct 2025 16:26:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:26:01 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-9-seanjc@google.com>
Subject: [PATCH v2 08/13] KVM: selftests: Add test coverage for guest_memfd
 without GUEST_MEMFD_FLAG_MMAP
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

If a VM type supports KVM_CAP_GUEST_MEMFD_MMAP, the guest_memfd test will
run all test cases with GUEST_MEMFD_FLAG_MMAP set.  This leaves the code
path for creating a non-mmap()-able guest_memfd on a VM that supports
mappable guest memfds untested.

Refactor the test to run the main test suite with a given set of flags.
Then, for VM types that support the mappable capability, invoke the test
suite twice: once with no flags, and once with GUEST_MEMFD_FLAG_MMAP
set.

This ensures both creation paths are properly exercised on capable VMs.

Run test_guest_memfd_flags() only once per VM type since it depends only
on the set of valid/supported flags, i.e. iterating over an arbitrary set
of flags is both unnecessary and wrong.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: use double-underscores for the inner helper]
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 27 +++++++++++--------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index afdc4d3a956d..9f98a067ab51 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -268,18 +268,8 @@ do {									\
 	close(fd);							\
 } while (0)
 
-static void test_guest_memfd(unsigned long vm_type)
+static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 {
-	struct kvm_vm *vm;
-	uint64_t flags;
-
-	vm = vm_create_barebones_type(vm_type);
-	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
-
-	/* This test doesn't yet support testing mmap() on private memory. */
-	if (!(flags & GUEST_MEMFD_FLAG_INIT_SHARED))
-		flags &= ~GUEST_MEMFD_FLAG_MMAP;
-
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags);
 
@@ -295,9 +285,24 @@ static void test_guest_memfd(unsigned long vm_type)
 	gmem_test(file_size, vm, flags);
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
+}
+
+static void test_guest_memfd(unsigned long vm_type)
+{
+	struct kvm_vm *vm = vm_create_barebones_type(vm_type);
+	uint64_t flags;
 
 	test_guest_memfd_flags(vm);
 
+	__test_guest_memfd(vm, 0);
+
+	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
+
+	/* MMAP should always be supported if INIT_SHARED is supported. */
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_INIT_SHARED);
+
 	kvm_vm_free(vm);
 }
 
-- 
2.51.0.618.g983fd99d29-goog


