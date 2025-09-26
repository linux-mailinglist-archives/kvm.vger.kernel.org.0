Return-Path: <kvm+bounces-58887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10CC9BA4A38
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:32:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E7E4326019
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CC42FAC18;
	Fri, 26 Sep 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Irp2F4Z9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D012F60DA
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904289; cv=none; b=QreLW5SI+okUdk13+YkZ/t8JDG0kf4QGocRdcqemIRM84gnS1zpbL85IsOHH4kQOIeyi45KKhqJIVrq1n8XvHiHrRCe249cDtELgVXteXuvFd/S5f+POVZUZeUZ+K0FgMOcJRE8YIVjHagnpx/hqiOU18gQhNPt9JStwM9d/fdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904289; c=relaxed/simple;
	bh=MAGU8L12jB8wVEW47uqOWIWiTe/Qj22xQ0Pomduj5Gs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uet31DPBHLZMRowTOpi+lZcTj0PdP3NVadP6oQaUFrgO+6Y6Tsz5sPLhDbHkoUpRbeAx43gcQnZbY9CXKMk/Ox1qpBQoZ8XUO2JBMi4rUsK/Xwvqt9frL2ax5SEfKOtFHRlmtNw4N2WwNhjAHweP1cIUUYYibXZgmCTRNCHytiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Irp2F4Z9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec2211659so2515518a91.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758904285; x=1759509085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mLOzX8BBzpvK79s3HUFrSzFihc7sYmH8hFEiPkJQUNg=;
        b=Irp2F4Z925w4CsHyohU65XE71waG1UAcapHx7AJwN5Zu7xuG8AZX/OB7gzbEN4syVp
         qpbi4xga1qvICLefV7/y/bWFNwA6Ix7fVk9f/+XF18OcNZtICzI0PM++54H2ZoHmuIPg
         oRT2OFruLuOLrSqqptapfrfsl4Q5cXy93DO/STTpQ1NEJJfuWuK3ArGWd3pP5uJYFOgN
         LHZxwnBU3fm6+XS7jPz8aTwNPNZDF4s1p7zy912t5qy4z90G2u54WtfyP8aMG58FJ/Kv
         evibcg8WUmI6lbVqKM+hWA9rWfWqzW9rA2y6kfRV4ZGFXnxgA7UqS5s8EAOT8y+EW29l
         spFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904286; x=1759509086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLOzX8BBzpvK79s3HUFrSzFihc7sYmH8hFEiPkJQUNg=;
        b=vRT06WdOaTqBsUk9BgfvFuzArSDM26irRTgtWO4RU8LGYL+EPoNMC+3I8YuFBtkg7f
         TnHpaM5EBmwC48i1MmInPcvgiLFaJzPSQTOa2IGyRLqf5aWgYJCA3u92oZT4rnRNGnQ3
         kIWudnqxnZjbmRSCoK8jDiLQIJpejFSNjgvw72F2Qfacg3xRo4PqH+YmZENznt4Kd/0l
         CbdluHWuJK28vS8wpsdpswwPh97cN4L9/AFHPxHpcbn1lcYP6CAyz71+pO2ciVeAy1CA
         gTLTWS6nZbLPRurJoxJehxMs4DVskajJCG7y+WXsFqi7+5kPTEvQUsdW46sAuTyfKg/Q
         YQ1Q==
X-Gm-Message-State: AOJu0Ywm2kAMR6Yult5+4v7DziY8QMUQyjSFMQ7jT5HLPlFJiIps9tbd
	fCPe8c+V+vavs/v5AIzGeW2Rvkl3kusmCLywh4Poo8qKe9+TMzDMLfozkU6VMfxPyPdICsJTY+1
	KCaHUwQ==
X-Google-Smtp-Source: AGHT+IHkMCOD5/dHxBWIFTEBy3wYtTT/yvxoDVojAwCUGYoSg7l/3kr2egBxNpTIWTnHjRUN0RtqQ3g60JM=
X-Received: from pjyt11.prod.google.com ([2002:a17:90a:e50b:b0:32f:3fab:c9e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4c:b0:32e:8c14:5d09
 with SMTP id 98e67ed59e1d1-3342a23718dmr7605186a91.7.1758904285619; Fri, 26
 Sep 2025 09:31:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 09:31:04 -0700
In-Reply-To: <20250926163114.2626257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926163114.2626257-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: selftests: Create a new guest_memfd for each testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor the guest_memfd selftest to improve test isolation by creating a
a new guest_memfd for each testcase.  Currently, the test reuses a single
guest_memfd instance for all testcases, and thus creates dependencies
between tests, e.g. not truncating folios from the guest_memfd instance
at the end of a test could lead to unexpected results (see the PUNCH_HOLE
purging that needs to done by in-flight the NUMA testcases[1]).

Invoke each test via a macro wrapper to create and close a guest_memfd
to cut down on the boilerplate copy+paste needed to create a test.

Link: https://lore.kernel.org/all/20250827175247.83322-10-shivankg@amd.com
Reported-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 31 ++++++++++---------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 8251d019206a..60c6dec63490 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -26,7 +26,7 @@
 
 static size_t page_size;
 
-static void test_file_read_write(int fd)
+static void test_file_read_write(int fd, size_t total_size)
 {
 	char buf[64];
 
@@ -259,14 +259,18 @@ static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
 	}
 }
 
+#define gmem_test(__test, __vm, __flags)				\
+do {									\
+	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
+									\
+	test_##__test(fd, page_size * 4);				\
+	close(fd);							\
+} while (0)
+
 static void test_guest_memfd(unsigned long vm_type)
 {
 	uint64_t flags = 0;
 	struct kvm_vm *vm;
-	size_t total_size;
-	int fd;
-
-	total_size = page_size * 4;
 
 	vm = vm_create_barebones_type(vm_type);
 
@@ -276,24 +280,21 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags);
 
-	fd = vm_create_guest_memfd(vm, total_size, flags);
-
-	test_file_read_write(fd);
+	gmem_test(file_read_write, vm, flags);
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
-		test_mmap_supported(fd, total_size);
-		test_fault_overflow(fd, total_size);
+		gmem_test(mmap_supported, vm, flags);
+		gmem_test(fault_overflow, vm, flags);
 	} else {
-		test_mmap_not_supported(fd, total_size);
+		gmem_test(mmap_not_supported, vm, flags);
 	}
 
-	test_file_size(fd, total_size);
-	test_fallocate(fd, total_size);
-	test_invalid_punch_hole(fd, total_size);
+	gmem_test(file_size, vm, flags);
+	gmem_test(fallocate, vm, flags);
+	gmem_test(invalid_punch_hole, vm, flags);
 
 	test_guest_memfd_flags(vm, flags);
 
-	close(fd);
 	kvm_vm_free(vm);
 }
 
-- 
2.51.0.536.g15c5d4f767-goog


