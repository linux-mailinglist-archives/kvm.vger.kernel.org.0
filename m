Return-Path: <kvm+bounces-61334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2248AC16F38
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACDC11C617BF
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE33A3570B5;
	Tue, 28 Oct 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rkYqs5Jh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CAE3563D9
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686467; cv=none; b=qktymJbtGtzifLdyD4/9Edemq3uoZOdknt9X/TJqiwoJoRL6xExQ8h6ffa3FwI6e9Q52V5zCidC874UPtScToayf4qyHo5GG8mOz2/Cs/lrpZbSR2qbwzPQFk0Qwax/0ez7GlNnyXdqNH2GTc1RgI+rskJmWYuIrO5aLLpuGUww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686467; c=relaxed/simple;
	bh=x85AGbqMQuM30E7OfpbcHxj2rx11JgYx/dEG7Zx7ZSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sGil7TAZwl21KkvelR+PD0jKW5YjvxACOEDBB1KRHL596AhIMg9cmV2bUkMzp/U2+avCeIhej3n6ZQt/jI6TYUIGRnONMBkP6cNmPJVVeKRlWTZvu0efGwDf5Q8hox4999hlEvj9D7BHo7jdexprR1zmsoVs/bdoEIK68VuD7xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rkYqs5Jh; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-940d88b8c15so616320239f.2
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686465; x=1762291265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aol8JWbhvHQ0Y4NMgOYcXnVqKUY49+8bce+pOQJ30aM=;
        b=rkYqs5Jhb6wqBDgs/FR66erImpSJTxlM3HEW1yRUsw376tuFGYkZ80cQjvujeKc1HS
         wt1zV7y8Kk0ailb39l+0mkVl/40PweK2Fh3OxabnsFP9WhFEKWK0d0Hl6L42Bru7DSoA
         t3nXZFo5VCHGb84pvvg4HG8O4FXOkVOIZJzIHEp6rQ1SnTjwGkfFX+88rinSOGAHUNrz
         lcztbcuvAVaNJyimy4aDaAypnGH8FJhde+gNupNw+lwDuMcSF9EXzs7dw1/+FqAXYMwj
         lZ3cFW88G5Oy49aHkPyGSAvHFIi6/v1hHk5/xS5fAql7dZWzW0BL1BoAiU1g/Ivk1sy5
         6J7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686465; x=1762291265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aol8JWbhvHQ0Y4NMgOYcXnVqKUY49+8bce+pOQJ30aM=;
        b=XXblXk+6IiIe3UkWcpjrNfUj3WgPkOW2OZ7TZ07/i6KsxfBkuowfFyXTT5UZ0vkkeb
         vA52LxdC1bOvP8PfR6xZ2lPzGHQPkYDFXizM7F29wxLqNjaIQSS0ACBuutBnp9n1UKQe
         Xw19Joj1K7KXQ2spEiGWUmxMIqe5nlGGwszYHT+ECPur+mKAU3dqJi+ik+k8iiPFSYBy
         EY4kwY5VojAAv8OKA3vG/m7g+Jyhh+iAWt8QZaZK4Ql5yRDwl6zXcPe1G4YXDimwwJiz
         10O72iX4WjSWMBHKFRB8TJ47opH1Mtmr7WAgOl+8i3cRR+c4g6oKxEi68Ixf6vJLMFaN
         xAfw==
X-Forwarded-Encrypted: i=1; AJvYcCVbQdiV0HJg34HQwFV7agedGtikfhcnJAt68c+8K9iju+r768FIyvi/pDxGJUfYJzuxSiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgDWrDpaEjuB2YQ6AYdJ43e6A4J8AT35WR+LOg6XkwRZ8eLbpj
	QVKr5BxAiiagnVgZ4vnX4GuJakIlxKKGO3uBdFYwki6T+24/1D5l0RH9AIbfHXWMp87/uxLipvS
	KFQ==
X-Google-Smtp-Source: AGHT+IEVLrCWBvCq+ZZnFLKxmdhDBAGkMvknZeQQTQOQUQehd1xeQRu0DtZg6MjC1npOpKY5i2fK+0sdsA==
X-Received: from iloz9.prod.google.com ([2002:a92:cb89:0:b0:42f:7f5b:11a6])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:154a:b0:431:d951:ab97
 with SMTP id e9e14a558f8ab-432f9028812mr9611735ab.15.1761686464982; Tue, 28
 Oct 2025 14:21:04 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:36 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-11-sagis@google.com>
Subject: [PATCH v12 10/23] KVM: selftests: Set up TDX boot code region
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add memory for TDX boot code in a separate memslot.

Use virt_map() to get identity map in this memory region to allow for
seamless transition from paging disabled to paging enabled code.

Copy the boot code into the memory region and set up the reset vector
at this point. While it's possible to separate the memory allocation and
boot code initialization into separate functions, having all the
calculations for memory size and offsets in one place simplifies the
code and avoids duplications.

Handcode the reset vector as suggested by Sean Christopherson.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |  2 +
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 54 +++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5c94e3afcd3a..86fe629f2e81 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -31,6 +31,7 @@ LIBKVM_x86 += lib/x86/sev.c
 LIBKVM_x86 += lib/x86/svm.c
 LIBKVM_x86 += lib/x86/ucall.c
 LIBKVM_x86 += lib/x86/vmx.c
+LIBKVM_x86 += lib/x86/tdx/tdx_util.c
 LIBKVM_x86 += lib/x86/tdx/td_boot.S
 
 LIBKVM_arm64 += lib/arm64/gic.c
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index 286d5e3c24b1..ec05bcd59145 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -11,4 +11,6 @@ static inline bool is_tdx_vm(struct kvm_vm *vm)
 	return vm->type == KVM_X86_TDX_VM;
 }
 
+void vm_tdx_setup_boot_code_region(struct kvm_vm *vm);
+
 #endif // SELFTESTS_TDX_TDX_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
new file mode 100644
index 000000000000..a1cf12de9d56
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <stdint.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "tdx/td_boot.h"
+#include "tdx/tdx_util.h"
+
+/* Arbitrarily selected to avoid overlaps with anything else */
+#define TD_BOOT_CODE_SLOT	20
+
+#define X86_RESET_VECTOR	0xfffffff0ul
+#define X86_RESET_VECTOR_SIZE	16
+
+void vm_tdx_setup_boot_code_region(struct kvm_vm *vm)
+{
+	size_t total_code_size = TD_BOOT_CODE_SIZE + X86_RESET_VECTOR_SIZE;
+	vm_paddr_t boot_code_gpa = X86_RESET_VECTOR - TD_BOOT_CODE_SIZE;
+	vm_paddr_t alloc_gpa = round_down(boot_code_gpa, PAGE_SIZE);
+	size_t nr_pages = DIV_ROUND_UP(total_code_size, PAGE_SIZE);
+	vm_paddr_t gpa;
+	uint8_t *hva;
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    alloc_gpa,
+				    TD_BOOT_CODE_SLOT, nr_pages,
+				    KVM_MEM_GUEST_MEMFD);
+
+	gpa = vm_phy_pages_alloc(vm, nr_pages, alloc_gpa, TD_BOOT_CODE_SLOT);
+	TEST_ASSERT(gpa == alloc_gpa, "Failed vm_phy_pages_alloc\n");
+
+	virt_map(vm, alloc_gpa, alloc_gpa, nr_pages);
+	hva = addr_gpa2hva(vm, boot_code_gpa);
+	memcpy(hva, td_boot, TD_BOOT_CODE_SIZE);
+
+	hva += TD_BOOT_CODE_SIZE;
+	TEST_ASSERT(hva == addr_gpa2hva(vm, X86_RESET_VECTOR),
+		    "Expected RESET vector at hva 0x%lx, got %lx",
+		    (unsigned long)addr_gpa2hva(vm, X86_RESET_VECTOR), (unsigned long)hva);
+
+	/*
+	 * Handcode "JMP rel8" at the RESET vector to jump back to the TD boot
+	 * code, as there are only 16 bytes at the RESET vector before RIP will
+	 * wrap back to zero.  Insert a trailing int3 so that the vCPU crashes
+	 * in case the JMP somehow falls through.  Note!  The target address is
+	 * relative to the end of the instruction!
+	 */
+	TEST_ASSERT(TD_BOOT_CODE_SIZE + 2 <= 128,
+		    "TD boot code not addressable by 'JMP rel8'");
+	hva[0] = 0xeb;
+	hva[1] = 256 - 2 - TD_BOOT_CODE_SIZE;
+	hva[2] = 0xcc;
+}
-- 
2.51.1.851.g4ebd6896fd-goog


