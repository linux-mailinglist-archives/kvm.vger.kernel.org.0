Return-Path: <kvm+bounces-53704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 392A7B155A8
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6143C18A7B5A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971522D94B5;
	Tue, 29 Jul 2025 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KBeHc1KV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C89F2D876B
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829774; cv=none; b=qKbTM2Kyd+0rUiAaVSWQQ6FGQp/taxM9zDX+6D5wQc+UW/NKzq5cJ2I2O/0XNWBL5E+C2ybUn8cdEK9f7isXydsj0HgVhv5xEdpTkFgImz+Sb9LImWcHhjjNWbG3NJawcgUPPD/sYVfoXj0jOLt3z24tTC/LW2tBMVkgHd5VsbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829774; c=relaxed/simple;
	bh=iqeIz6zYpzKsdgmtTVnjWowKoLeDnq0bjWKhZ9mqs7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zm0xU6lbiwPG954sRU1rL2gTFtu22NgJPVN/8olCjHO+wdfZ+x1srPC7geJMFXofSy2caerdcB3+UghtYDVjUeyeXhniriJONp1V4Eu3r1qmC1S9b3PkR1RbOIwaXFUn6B9h7aIexnqCFH+MzPSX7GMA53Bba0aq86pveRDzW/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KBeHc1KV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea10f801aso5782106a91.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829773; x=1754434573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EorjiQ424BTohGrqf8DNWx/AmqFoym4CNGeVIARROHM=;
        b=KBeHc1KVJwXSKbp9O+czZQIFCBP4hHC9Sl3G6K5juUs8b+3jEYqaJvhwjUq7gL3vjp
         JwwJz0j9Wo2qFPkGSf+wq5vEVhiIs92xjffMoe1ar9NcCY3BItYEdKrviEU/rLST5Yeq
         h9v4UYhaaxQ1Nkh/kTuKtfu5LZD9ZbPRe+Nc+fpEvMxaPxH/70lO9dRGm5gDruzOFWc8
         /tGDGwd4DTFvt0Pg9NNvNiIrSAf43jp5AgnwQerklyYdHi4GLfo3mJB0B2YKzmEaiLc5
         rS51waiMHl/llJ8pt+5gAjwJo1NC8hrU5GfLdcffomE4GtDdldFY37m9vuTalSNs9JrE
         62Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829773; x=1754434573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EorjiQ424BTohGrqf8DNWx/AmqFoym4CNGeVIARROHM=;
        b=RyGbh4lmrtn77cuPegduGMmAcfV6QvcalKlanILl5ObSQ9dOOMyLdZzbEbSYHuinyQ
         KEzskAgQzKrSYgNhFTD8hyD6pUH1Rv52lx/3QlXrpbMGvY4BJJMRfrO7CTOg3DQNzLQw
         bb/VjHJtRwIA5N28Irysgq/774WJ5Dn2q8FWHskWmQY+BXxFRbsTrSbg0V3AQ5k6puKF
         ryoxiB7jrY/dqErteWIQAZeOelgqPxPKJOXmhFkkJMKt8fU6mhtooaerVl7MbVgGsPn5
         FQXT4so//IJuKNjLzlV74w9fWZfR5e8o9MOqzauGNkUls+rqCHsaSrcf3OKYQxG7G5Ae
         3D6w==
X-Gm-Message-State: AOJu0YxEH+aLLdHbH82emMrcex5paar23KxzRe7U11lEP7lDtmUasiQp
	UpGSMY921lfFoDuTc++ZLrFTFD51WneolSrAhK/hm5usPTeEwmt3Opu9yfvnVa6oGEKIEHPYbdA
	ieQKQGA==
X-Google-Smtp-Source: AGHT+IHB9c2363ufbpvtr+JBuwDrzcLhfsH2Xd3qM0cBsmlln2L/OVyYyxyGr5yAT46jm6mjT2DN+GL7x3k=
X-Received: from pjee15.prod.google.com ([2002:a17:90b:578f:b0:31e:fe0d:f464])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288b:b0:311:df4b:4b94
 with SMTP id 98e67ed59e1d1-31f5ddb7ea8mr1459342a91.4.1753829772835; Tue, 29
 Jul 2025 15:56:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:55 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-25-seanjc@google.com>
Subject: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_memfd testcase to verify that a vCPU can fault-in guest_memfd
memory that supports mmap(), but that is not currently mapped into host
userspace and/or has a userspace address (in the memslot) that points at
something other than the target guest_memfd range.  Mapping guest_memfd
memory into the guest is supposed to operate completely independently from
any userspace mappings.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 088053d5f0f5..b86bf89a71e0 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/sizes.h>
 #include <setjmp.h>
 #include <signal.h>
 #include <sys/mman.h>
@@ -21,6 +22,7 @@
 
 #include "kvm_util.h"
 #include "test_util.h"
+#include "ucall_common.h"
 
 static void test_file_read_write(int fd)
 {
@@ -298,6 +300,66 @@ static void test_guest_memfd(unsigned long vm_type)
 	kvm_vm_free(vm);
 }
 
+static void guest_code(uint8_t *mem, uint64_t size)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++)
+		__GUEST_ASSERT(mem[i] == 0xaa,
+			       "Guest expected 0xaa at offset %lu, got 0x%x", i, mem[i]);
+
+	memset(mem, 0xff, size);
+	GUEST_DONE();
+}
+
+static void test_guest_memfd_guest(void)
+{
+	/*
+	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
+	 * the guest's code, stack, and page tables, and low memory contains
+	 * the PCI hole and other MMIO regions that need to be avoided.
+	 */
+	const uint64_t gpa = SZ_4G;
+	const int slot = 1;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t *mem;
+	size_t size;
+	int fd, i;
+
+	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		return;
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
+
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
+		    "Default VM type should always support guest_memfd mmap()");
+
+	size = vm->page_size;
+	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
+	memset(mem, 0xaa, size);
+	munmap(mem, size);
+
+	virt_pg_map(vm, gpa, gpa);
+	vcpu_args_set(vcpu, 2, gpa, size);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
+	for (i = 0; i < size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xff);
+
+	close(fd);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -314,4 +376,6 @@ int main(int argc, char *argv[])
 
 	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
 		test_guest_memfd(vm_type);
+
+	test_guest_memfd_guest();
 }
-- 
2.50.1.552.g942d659e1b-goog


