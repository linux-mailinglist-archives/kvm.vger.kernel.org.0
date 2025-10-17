Return-Path: <kvm+bounces-60395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E415BEB9F2
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 35A5D4FF30E
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6E934C9B5;
	Fri, 17 Oct 2025 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HKFJ/hTo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE94336EE8
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760732017; cv=none; b=uNrnA/Fi+gZESYCyvShBz7AcafGicQI/mXT7Lc+aD100EHNJYT1JkS1ORXMxyeyOvEb2UIUGxk8hBqBFMfoOT3BWjAeWwwUhRE72nWN+QO82svb+psSwEuDZ7O9QsyBd79yCFJILwkHFtfxf+NQ7JJoADimymK7ieU+2duVz+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760732017; c=relaxed/simple;
	bh=qhndFbd/Csb/pEoEo8xEbgb9ANe1Rhwu0LFv+C2pbWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DNk2E3uc4cHv0iQ0lW9t9LDFdlBSrakjErkSulya/3JflExpo98yhZe/1/6bLF1kwPHSRCbFWB68nBRD0jTbDZJSGfhGZDjIU6YnJkpZVfM7vg9N9+nl8tcriQNVKnHt3OLv6dq1OLyVxbu8YtZzhEqroRzwx7PB9ieA5qzcv6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HKFJ/hTo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28c58e009d1so44088795ad.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732006; x=1761336806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpoVPQkxx65srwzLoEmvKd0scDAwEAjWt5gz2bwW38k=;
        b=HKFJ/hTo6F+wWNxAuovtVScjHMQJ/E70K6XsjdbJ0E7jWOt07UjZ/UTnfWdABcwCPr
         mkZpaXo2l7TuLydjAfaC+FPFAUdyifQB0y2ODo0GtM5yywN72+0lwuR9brhOcYYxrd05
         evoT2WQ/Avu240KGOMJCXGRPr+BJ7LL1QmVa622+mPgNV0u/nTJd1vlXIQ3qT1hWZogh
         zJsZHqM2N8XlqalL1JNQKXDroVeU6b5IeK376ofWT0gDyhU4tmCrDRO3cykconRKgv+y
         28aStQdINN1UK3r8LbvUEICmwGmQKJ9xHt+wBgwPxtbJbWbPEREJC94xHOAioCpxkWUq
         JQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732006; x=1761336806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpoVPQkxx65srwzLoEmvKd0scDAwEAjWt5gz2bwW38k=;
        b=xNThMKJ1uVcA6urTaAFVxUzpp3HjLRM08RYFJuGS86bw4TMO0F/ZR36WgLyFCsTS2Z
         oD0mR3qNhKFpYz/LfOrKzsLctBNYUDsdKlNWVtwKw6VU+989kOlGv/iNo8YRA1xWG3oI
         ozQ1o10HLuIXWoR770EfU2SGRb/fJ0KOzCg1II6WSfjuwtuyMHWRdbPxigRdcoqpxzIp
         +/MxjgIQv+fsRmPl8jpocmM41nAtgvfANtiRSPHMjWLUTYv0OBcTYF65A8uBthNUUpHf
         AGKTdepzmpcxor6ZcqxRkw3bzFZe1Dx1GhhPqiYlKofVrksboe/viKgoUAP5sa69p725
         8tqw==
X-Forwarded-Encrypted: i=1; AJvYcCVkT8w7NfMBZBHKiIi47vrcx1SJM4RGH5vuj/a7XctukmzXIK7SyffJpHj7efa3Glke6xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxooGkTCbX6xOo5krN90UlAFqN6UmxrCr5w1oCtp+rLSBof88G
	3fOJGe7qU9Whl/Zwa3BZBsvTFIZyo6BMC6JGmpAHDn/TN0UnoLP+BUtzM19AWjQlmd66HIdmCJq
	B6KlN3IDRQRN6+cHMecJrPCVxAg==
X-Google-Smtp-Source: AGHT+IHMvWCbFk7zNWAcA3iBXitO6Giz/tz8VDGZaOcvvFaw8VizJhdk71JqmoT94RqN4E0zZSOTnwVxAhEK+wEYkA==
X-Received: from pldr21.prod.google.com ([2002:a17:903:4115:b0:290:a6e2:2006])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e543:b0:269:4741:6d33 with SMTP id d9443c01a7336-290c9d3740dmr58504095ad.23.1760732005539;
 Fri, 17 Oct 2025 13:13:25 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:15 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <4a1ad1015657e90db1e81c1b51dc07f62afe29ea.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 34/37] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Update the private memory conversions selftest to also test conversions
that are done "in-place" via per-guest_memfd memory attributes. In-place
conversions require the host to be able to mmap() the guest_memfd so that
the host and guest can share the same backing physical memory.

This includes several updates, that are conditioned on the system
supporting per-guest_memfd attributes (kvm_has_gmem_attributes):

1. Set up guest_memfd requesting MMAP and INIT_SHARED.

2. With in-place conversions, the host's mapping points directly to the
   guest's memory. When the guest converts a region to private, host access
   to that region is blocked. Update the test to expect a SIGBUS when
   attempting to access the host virtual address (HVA) of private memory.

3. Use vm_mem_set_memory_attributes(), which chooses how to set memory
   attributes based on whether kvm_has_gmem_attributes.

Restrict the test to using VM_MEM_SRC_SHMEM because guest_memfd's required
mmap() flags and page sizes happens to align with those of
VM_MEM_SRC_SHMEM. As long as VM_MEM_SRC_SHMEM is used for src_type,
vm_mem_add() works as intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/private_mem_conversions_test.c    | 44 ++++++++++++++++---
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 814187d06fcca..6730923af830c 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -309,8 +309,8 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
 	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+		vm_mem_set_memory_attributes(vm, gpa, size,
+					     map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
 	run->hypercall.ret = 0;
 }
 
@@ -354,8 +354,20 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				uint8_t *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				/*
+				 * When using per-guest_memfd memory attributes,
+				 * i.e. in-place conversion, host accesses will
+				 * point at guest memory and should SIGBUS when
+				 * guest memory is private.  When using per-VM
+				 * attributes, i.e. separate backing for shared
+				 * vs. private, the host should always observe
+				 * the shared data.
+				 */
+				if (kvm_has_gmem_attributes &&
+				    uc.args[0] == SYNC_PRIVATE)
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
+				else
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -384,6 +396,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
+	uint64_t gmem_flags;
 	struct kvm_vm *vm;
 	int memfd, i;
 
@@ -399,12 +412,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	if (kvm_has_gmem_attributes)
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	else
+		gmem_flags = 0;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -454,17 +472,29 @@ static void usage(const char *cmd)
 
 int main(int argc, char *argv[])
 {
-	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	enum vm_mem_backing_src_type src_type;
 	uint32_t nr_memslots = 1;
 	uint32_t nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
+	src_type = kvm_has_gmem_attributes ? VM_MEM_SRC_SHMEM :
+					     DEFAULT_VM_MEM_SRC;
+
 	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
 			src_type = parse_backing_src_type(optarg);
+			if (kvm_has_gmem_attributes && src_type != VM_MEM_SRC_SHMEM) {
+				printf("Overriding mem_type to %s to test in-place conversions\n",
+				       vm_mem_backing_src_alias(VM_MEM_SRC_SHMEM)->name);
+				/*
+				 * Use VM_MEM_SRC_SHMEM, whose size and mmap flags
+				 * align with those of guest_memfd.
+				 */
+				src_type = VM_MEM_SRC_SHMEM;
+			}
 			break;
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
-- 
2.51.0.858.gf9c4a03a3a-goog


