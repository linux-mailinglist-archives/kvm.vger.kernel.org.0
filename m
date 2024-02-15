Return-Path: <kvm+bounces-8845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0539685720D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98613286DCC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E721482EF;
	Thu, 15 Feb 2024 23:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="idLq/jo3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B6145FEF
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041268; cv=none; b=UrvAvl6HWoaTiDXZzG/RwnoTGnK+Ky5MGWTHdGtpUhcXI7G5bKWHOhl5MD7VEYt6GIpMX8Ur6P6qyxGqsgjR9cFtNSjOyQpgK/qsystSpkoxE/FOZ4weibyLAYxWpTf8TShd9sF1WA4giOmGf1qNXnsJ4AaMAptA88cXA2e/E+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041268; c=relaxed/simple;
	bh=7F0hdUQkgcbLnNEOLN45aw7eBCRbULVKfec0j/XaDOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYYUjD1+Ac3G5GVWiRMIPT+tSRsMBGAm+uQgIkGaSBtzkwpPoLYssAFXpbm159r1l0ag6fnbuD+CBDFHfaaikbb1NSWfRmDv9JrmGTmvp+4dVneb2+CQL+y2RAyGgYqZZnWdfvKcWzvxyTF8KEK7RzcJRJqvJaLC0ePXLY+gC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=idLq/jo3; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so1969468276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041265; x=1708646065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ3z5wuWWtoz1ZMhcdaCZuytQaO+bHVR4Pertr9jsQQ=;
        b=idLq/jo3wTOfhzmYljHB5ByPoQVemZkQFFbDoxsa0awJN1SqIiMYnRFzRoe/QIlw0a
         WA+CMaVFhyx7HZlk6AWuNTilPUkX5SH3fAo93vRpiedHOkULGdlBbeL+Jtc1fbhOiHOl
         8OOBDFLPWhS+k6u2HmzQTH+tL2u9PfGBR5o1O8+ZKMzuLVTSJ4I3jFhYuGfZ0VjSp2tq
         PHVliXsnanVBH1woWqacKqr05oFYZmF+JdrHTU/9HAZ9/Q1rKwxSE+K5W9u8jL/nw7cM
         8M2nFJNUP2f0Le/IpT6e18KBoRPk4wdqacAQpXZFXaYRgA7zDpjFH1x8BiLufkgKdsK2
         gWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041265; x=1708646065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ3z5wuWWtoz1ZMhcdaCZuytQaO+bHVR4Pertr9jsQQ=;
        b=AoONFH2Pyyj2jzKH+NcaGY9XYeOp24cJgOGSfG/W6ufzvOg7+S+A28dsWhQb4NOiDj
         K87rrIzBr8jq4HGhiuPDsTf0xHme/K9vBmmyqVAp/o8QOUwx6OgvGNWwpAXfnG1MjPhV
         VW//wr16LMToaAD3mJYKR8PzRT0QxW+KhL75cTiCFMPabFXFKyi4qo0InFD8g1ZA6eWy
         mT91v3TYSUrZ0T0fJzT3gJyYFsWahjNqwZI/1xlQvfYQX9N+zj4VBgX9fA6bnd7a95Wa
         A/DLGAo6pNSU27+k0CWPWb/8S0H8cMhxXovXYuQGeRajANUsgn+yh/AlkZFoCEUSI0Mm
         PduQ==
X-Forwarded-Encrypted: i=1; AJvYcCW92ZvbZ+0Yznrwt62aM+eLYDPuFT9Avscce6hJIme8aI4se1qog2WMl7aiXEuYJBuujM6UKhi8zskDK0kXSnlqd+JG
X-Gm-Message-State: AOJu0YxjBdDKuI6tYAUlv9M0W3K9YsRQaStAHKTRymqZS7W1eTVX+OG/
	QyZpvwjD0Cr4JuVnaA0Tgj+d+2F9E3NtMp4LrFArcDA9kahQCaFVUh5LgUp7XTGuBTLr1Q3CbHX
	BQZ7NxtDmIg==
X-Google-Smtp-Source: AGHT+IEUZwP+LJ+E+jxNEEZlreKraG2jY/8zcXTmmfUSkAeCJVN8Cnv8dxS1QjyGU3QmLdYMdQnNWZ+EgajasA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9846:0:b0:dcd:c091:e86 with SMTP id
 k6-20020a259846000000b00dcdc0910e86mr128874ybo.13.1708041265304; Thu, 15 Feb
 2024 15:54:25 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:04 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-14-amoorthy@google.com>
Subject: [PATCH v7 13/14] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Memslot flags aren't currently exposed to the tests, and are just always
set to 0. Add a parameter to allow tests to manually set those flags.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 2 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c             | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 .../selftests/kvm/x86_64/dirty_log_page_splitting_test.c      | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..b51656b408b8 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -306,7 +306,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;
 
-	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1, 0,
 				 params->backing_src, !overlap_memory_access);
 
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0455347f932a..61bb2e23bef0 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -163,7 +163,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	double vcpu_paging_rate;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..8b1a84a4db3b 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -153,7 +153,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src,
+				 p->slots, 0, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Random seed: %u\n", p->random_seed);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index ce4e603050ea..8be9609d3ca0 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -56,7 +56,7 @@ struct memstress_args {
 extern struct memstress_args memstress_args;
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d05487e5a371..e74b09f39769 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -123,7 +123,7 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
@@ -212,7 +212,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+					    region_pages, slot_flags);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..0b19ec3ecc9c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..a770d7fa469a 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -100,7 +100,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	struct kvm_page_stats stats_dirty_logging_disabled;
 	struct kvm_page_stats stats_repopulated;
 
-	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size,
+	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size, 0,
 				 SLOTS, backing_src, false);
 
 	guest_num_pages = (VCPUS * guest_percpu_mem_size) >> vm->page_shift;
-- 
2.44.0.rc0.258.g7320e95886-goog


