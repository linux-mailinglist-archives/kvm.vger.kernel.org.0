Return-Path: <kvm+bounces-59486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEDEBB8646
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D1154E992C
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713342DCBEB;
	Fri,  3 Oct 2025 23:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zen6oU47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36228030E
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533991; cv=none; b=Tubu2ZdM22vQ5K6VxRp/IZr2sAn7VSRaci2bNkRBadGADhEoyFKnJqVa830/Q4pDNOzE3c7HzIzqwocJuVRfyGHOZDI9a9hEjWhcl2cFGD/jzEaK8zju8TsXWSyZGx1V0L1SZ9NO3e6t3Ir8zxMBzjNAQ0OntGTo+3g33S8dcAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533991; c=relaxed/simple;
	bh=0xeumNRu0bdu/oLbIMPmUD2rrS5rFLO2H9kNKTpm7Eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lA0j6yMXzAnTqkfC0AcbM9xFpYNI2yMl3VgXrAGbrLz/law1bbH0eSVn6VroNdHbPqDdSDK0GUPX8u5Ed5fMcWSTsRj+tXbXU2IBFyrhdvFomDbRCvtQ/dVqnifFBow9nIDwxM0fA5nZ7pSJK4uX7KhTC20C3zCFvAbWuP4RUNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zen6oU47; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-277f0ea6fc6so61830695ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533989; x=1760138789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qrTDG0acHPOPKJ3AVdBdofNeaQKfhOMghQNh09nNQB8=;
        b=zen6oU47fV/1SDB+LIeNzFsLd35ERNRIYcyID8yvAuvb793VqKD8bIrIPqoSE2YNFC
         yY7ish9Upr3nxIb3LGMX79ZSmf8Wb6FnLCIkPVLARK+wLDpKI1EWFjanWAs4/Zi6WVD5
         VmEIb+T8fEJQh4aP6z1EsMJfPRIYOF8JQtj7PafnJL3bUB0GE5iIFiUmtLnFRSANyNeH
         a9FNoMGOLtCEEuONSkUBGsWNOMcFl9GFR0Bo0UmrBpWBa5c+lRHR5uBQeEo1aRzjXZp0
         2JHtzbGUWtIySbaydOn5MFPvtfdoVLVc9p1q00/ORWFC+fu2nlulS9UfMkd0o67tdZWw
         UtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533989; x=1760138789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qrTDG0acHPOPKJ3AVdBdofNeaQKfhOMghQNh09nNQB8=;
        b=aerNVJWfbiuwLKnDsYQ12avqVHKQN6SHAV87YzGhwqlPhB67lNCHd59cSW9dU2dPXh
         qwfL2QqKF76OQueOnVDop9eed23Wruln+iC2Gfmv0/GxyJN8XasuKo4c7EGKyx0LSSiv
         dZJo/DRexlF0agem86ii3i8YFWVYEIyKHZgiPcA0ReBiOdm9lN/7cGTZsemc0KY72gM3
         Z5Lh8lfT8eJRzIZyCW53YbEUhi/xnwxR8TThiUOD3CSgP/ALkUtzraQPhq8gqlgbBEmh
         h1egPf7f8NEPZtuQxH6cJVgR1GVkeq24d7794B+5n8QmH/+y9CmBzuR3nXfvhIYatd0E
         +zUg==
X-Gm-Message-State: AOJu0YzSqZ48yY+N7O69GawZeRupK9IBJ6bXcni82RlsUBeKTzv/8SHO
	BExHLgKAGOcBxp4IoC6RfBOvTX01Cn9F6c7zc7PFYOsYIbqNl3K56A49kyhGYgWrfDkiOXH4wzg
	pB5J2tg==
X-Google-Smtp-Source: AGHT+IGTaO3/D04Td+DbjpLaoUihiDB5eETO+E+bVM2wQesLhDsp0vKrjYvnc7RvC0OhiVRi6XrR4kqXyXQ=
X-Received: from plot3.prod.google.com ([2002:a17:902:8c83:b0:27e:4187:b4d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b50:b0:24e:3cf2:2453
 with SMTP id d9443c01a7336-28e9a7031c4mr52954735ad.61.1759533989354; Fri, 03
 Oct 2025 16:26:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:26:03 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-11-seanjc@google.com>
Subject: [PATCH v2 10/13] KVM: selftests: Isolate the guest_memfd
 Copy-on-Write negative testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the guest_memfd Copy-on-Write (CoW) testcase to its own function to
better separate positive testcases from negative testcases.

No functional change intended.

Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 319fda4f5d53..640636c76eb9 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -40,15 +40,20 @@ static void test_file_read_write(int fd, size_t total_size)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap_supported(int fd, size_t total_size)
+static void test_mmap_cow(int fd, size_t size)
 {
-	const char val = 0xaa;
-	char *mem;
-	size_t i;
-	int ret;
+	void *mem;
 
-	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
+}
+
+static void test_mmap_supported(int fd, size_t total_size)
+{
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
 
 	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
@@ -272,6 +277,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		gmem_test(mmap_supported, vm, flags);
+		gmem_test(mmap_cow, vm, flags);
 		gmem_test(fault_overflow, vm, flags);
 	} else {
 		gmem_test(mmap_not_supported, vm, flags);
-- 
2.51.0.618.g983fd99d29-goog


