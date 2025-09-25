Return-Path: <kvm+bounces-58798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2EEBA0DD6
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 747007BF1C1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD2631BCAF;
	Thu, 25 Sep 2025 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r60fY2Fk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3853191C8
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821358; cv=none; b=rJ3VfZhJjGx5aqpn+pVAIrLoQfbr02uJ7izjJcJT4go53N8fOaW3tAb2AceYjLHcOEzFiRdkO69aYJ8Y6S8VznmlkWQYxPxM35iTtcGOPY/Rk2PsgTOLDPIDir0CO19uqnbzSQQr18WdUHe4nderYQaHgKOPSXHYfXnowT++tqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821358; c=relaxed/simple;
	bh=vcPa/8+T0B4Q4SJqZzrdtuLDEPV0mlJUVpPCGNb8pyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H7XDMWqUGusO68de4qkurJiyrBj0VLra5XZ/nZtDCtnZahm7Q3EUP1sFQ0sggB+wpzBkBk1TNPVpdbGHadn5DkfyJYJUr+FtffZjc8AavZAkURxGbdN36x8GthDUyGgMv6joXQpyIcbEvxyZy3X8B4AbmV/T8dsY/E9SRn8PIss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r60fY2Fk; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f2d29dc2aso1036870b3a.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821354; x=1759426154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RfWoG7IZp/a/xEpP5J49/+hi6ZM0bSO6oF7v+4iZmqY=;
        b=r60fY2FkLAB8lL2hJ3FBh0aCFVl1wBl8KDX2oxSjwYxpwpdNjtgvrU4HTL5DLmc3hd
         Z96ZERuzvWTRImcchhMPgdGWAne9vtP8VUwF/Zx3z/QL74ADMP+c0VcgNYcIW9k6XMF6
         0GZ0VjdzxyWVq8e0NgDlZEMXvpGtO+Ne2gOpLJJSlEY6hTe8EIqdTWFoR+YtzireRoTq
         lGKS5hvPO7TCOe83//pXdaQTYrEy++a478fxZ5QnOT84Cn48p4Kf694kNhWOqleXHzEc
         J8T4e5aieLEQVD26EGw8N+OPDUjxgc4D+97YCgc7zm6rk4PlmyJqAhoIccTyKHu6/o2J
         oO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821354; x=1759426154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RfWoG7IZp/a/xEpP5J49/+hi6ZM0bSO6oF7v+4iZmqY=;
        b=Q9ZiscWdGer9aN0NKelEmT5wCFI/S2O9wzFlqECiMNg0Lx811JKLnaZx3oSJojs5Z7
         DdHB9rWEEal3rdwf3eGqPsGghLACVYG46k3mTXTaniM2ZtooXbW1z9Oo9Oqqq7vU8zHj
         T/xwZqVY7ABKyvoZD4TTylCX7DxkveXt9O0rpQ9p2AEnFrz2ke4T1/xhn6qZQfBqpPMc
         O4UvjMcW6zsVxieZ0mOOlO0Fx6Tf0ulSh7JUCMed+OYLO7XwjbZCTSXx/3ZDcR3PTlOs
         Zx61m5biRwst5Exd5vXN/AccYSQQWtA5PlSqlVSuMrQEv9A+i6uriY1vstFtTZ1DsTh2
         mgFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVue/7h7jROhtFORVa++aw/OOafovPy25DG/URKhVODPi9BSunGX4Jhp0AGPuuZbHujlSU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy89D4l8t5038DwEWGqWXUOjmH29z13L1cp/Sz+Dv4IddoIEpGZ
	/KIpMKEHdqbeDNAG1R4MCVTQ9ZUfcFp4NzqMOXyQZvt6CM6Z8mOQ7Ve6d3UO2vc8HQ2VM4MCfdC
	uuw==
X-Google-Smtp-Source: AGHT+IHyFyTl9WiREscF9Z1dQpnxV0cKGlLGeahIiAvSF2f2lAo5MVyaathSymz4Yh0PWTdHib8siPrddA==
X-Received: from pfbei28.prod.google.com ([2002:a05:6a00:80dc:b0:77f:33ea:96e9])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1250:b0:77f:24b0:1f58
 with SMTP id d2e1a72fcca58-780fce2cc1bmr4989505b3a.14.1758821354431; Thu, 25
 Sep 2025 10:29:14 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:37 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-10-sagis@google.com>
Subject: [PATCH v11 09/21] KVM: selftests: Set up TDX boot code region
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
index d11d02e17cc5..52c90f1c0484 100644
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
2.51.0.536.g15c5d4f767-goog


