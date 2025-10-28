Return-Path: <kvm+bounces-61333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F223C16F34
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 546071C6109D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6B8357705;
	Tue, 28 Oct 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="suTK4rMd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1148355818
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686467; cv=none; b=Bop8KtgoIJHPELElw7ReQSIn5ICv5dGxQBWqvt3q0i1tDDsXcKKFIJLkGQxbtTATTM7iVZQ9jNZl+l7GXrLWT/7Y0rE1PXvAbo8ic5ConDOZmk+AHyZXHmhpEHtf+hItLjPDtBmHqBI7z66+8kajPbusEtse2E+zS23APp8MSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686467; c=relaxed/simple;
	bh=voe8DXuHKE9cE7MWV2sCFTdDE9fpRk6WUVa5YwQQKXk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fDQz/UbVpoKRnURrge43w5c4fT6KUAlZsJgPrNgYNo8aTnqHinQG9BVDPufslXmco3ShTJ3lhH6Zhirahws4SyUk6vcOLxOEbebdQ6tPZeY6+640SuiETXw8Wq+OidRZAgp/4tzNMyaXijxOPKMXtbTvKGZgmvLPejtjq2G0ijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=suTK4rMd; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-927b19c5023so589778839f.1
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686464; x=1762291264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kIU4cueO192T/pB64Yc16iN1G4DGUXeOkWT12niAWVM=;
        b=suTK4rMd0CuZEAafne5YQ3RaFUa3qIr11euwutSLTeV6a0aJZUVfuvUtEZYiMhRzpd
         kDop/tBKYTDK9hYS386CfXb4n9wt3Nfme5+JTuxN8hz9cwTuAWPz4PAipWsdfOlXTRAK
         kjzkb8Z0GA8GKpiO8IKqNqT5ZhZ1ejSvo2HnUjUwOHAYEkFF9UN74QYfpBNTFoE1T5+v
         5CDtysz5f1EFEETchdM4V1R8WE2nsHs4ET3iE2AM3rxe81/CxBnWgLUx4pIka12XyCjV
         bMXvsd3rbjJiEpP3M1Gu7hf/nUCQ0QSZIvb75ZfVmESuaxpc8CMoHxw/f/Mj0O5MYS7T
         Expw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686464; x=1762291264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kIU4cueO192T/pB64Yc16iN1G4DGUXeOkWT12niAWVM=;
        b=hHq1ksGbK1XvjyweBC3HTNZv1BfR3gpf0afGRlLGzRFqJ05uYtHx4Jfhx+k2Scoo4g
         84jLf74baviAOLeKTIWMUWHqjsouy9MZ6DnJVPzO8BuRdR7AYMNX98klr5MwJHRhF8Yk
         DBivFyWRAPkAt5kRUv6Fqoh3GeI9BcC/Le0AyonIeQOm2j/9eB6GM1OoXybK/ONiN1ZP
         rz2TiZk7l3uSRMjP0ZcqCGVsne/HzTUdaeFIkTw68ad9K/ATlTLjaeZkNJ2GoaJ6vYcA
         gCpa0P2Tz4Kn+0X7d4JSirTHe1sHQAIdSa34QcpRW7O54A+v/9Bkk1Wd8C+BvFCd0Xcy
         zr9A==
X-Forwarded-Encrypted: i=1; AJvYcCV0B7F8cy6u5nbOTxD3GuXAlGwXimhcfQWn85Hp4ZFAUZFSmGzvs7YYnxq0ABp8Av7hXO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV+VY7S2SygQl0ioAyNWrDHWLmElkxxlSa+0UmAdj8wktwHj1U
	KU/ux9zsz90Tfeor2xOWtMZynvA78y2fJaoC+ixsuM/DPkkMlM+SWnAMRDKiUJXbF2xrAgaA51X
	ymg==
X-Google-Smtp-Source: AGHT+IEJybJXoSWfIBh9ze8mWyE1ogXIiAlaHqhgCpX9fGOHL/bHgNXJ06h84BI23sTfLe26Wq4/Osd1jg==
X-Received: from iobjj10.prod.google.com ([2002:a05:6602:6cca:b0:93e:7268:9432])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:15c3:b0:945:cbd9:55cc
 with SMTP id ca18e2360f4ac-945cbd956e3mr61054939f.15.1761686463904; Tue, 28
 Oct 2025 14:21:03 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:35 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-10-sagis@google.com>
Subject: [PATCH v12 09/23] KVM: selftests: Add TDX boot code
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

From: Erdem Aktas <erdemaktas@google.com>

Add code to boot a TDX test VM. Since TDX registers are inaccessible to
KVM, the boot code loads the relevant values from memory into the
registers before jumping to the guest code.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  3 +
 .../selftests/kvm/include/x86/tdx/td_boot.h   |  5 ++
 .../kvm/include/x86/tdx/td_boot_asm.h         | 16 +++++
 .../selftests/kvm/lib/x86/tdx/td_boot.S       | 60 +++++++++++++++++++
 4 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/td_boot_asm.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/td_boot.S

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5e809064ff1c..5c94e3afcd3a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -31,6 +31,7 @@ LIBKVM_x86 += lib/x86/sev.c
 LIBKVM_x86 += lib/x86/svm.c
 LIBKVM_x86 += lib/x86/ucall.c
 LIBKVM_x86 += lib/x86/vmx.c
+LIBKVM_x86 += lib/x86/tdx/td_boot.S
 
 LIBKVM_arm64 += lib/arm64/gic.c
 LIBKVM_arm64 += lib/arm64/gic_v3.c
@@ -345,6 +346,8 @@ $(LIBKVM_ASM_DEFS_OBJ): $(OUTPUT)/%.s: %.c FORCE
 $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
+$(OUTPUT)/lib/x86/tdx/td_boot.o: $(OUTPUT)/include/x86/tdx/td_boot_offsets.h
+
 $(OUTPUT)/include/x86/tdx/td_boot_offsets.h: $(OUTPUT)/lib/x86/tdx/td_boot_offsets.s FORCE
 	$(call filechk,offsets,__TDX_BOOT_OFFSETS_H__)
 
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h b/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
index 32631645fe13..a590516dd83c 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
@@ -66,4 +66,9 @@ struct td_boot_parameters {
 	struct td_per_vcpu_parameters per_vcpu[];
 };
 
+void td_boot(void);
+void td_boot_code_end(void);
+
+#define TD_BOOT_CODE_SIZE (td_boot_code_end - td_boot)
+
 #endif /* SELFTEST_TDX_TD_BOOT_H */
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/td_boot_asm.h b/tools/testing/selftests/kvm/include/x86/tdx/td_boot_asm.h
new file mode 100644
index 000000000000..10b4b527595c
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/tdx/td_boot_asm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_TDX_TD_BOOT_ASM_H
+#define SELFTEST_TDX_TD_BOOT_ASM_H
+
+/*
+ * GPA where TD boot parameters will be loaded.
+ *
+ * TD_BOOT_PARAMETERS_GPA is arbitrarily chosen to
+ *
+ * + be within the 4GB address space
+ * + provide enough contiguous memory for the struct td_boot_parameters such
+ *   that there is one struct td_per_vcpu_parameters for KVM_MAX_VCPUS
+ */
+#define TD_BOOT_PARAMETERS_GPA 0xffff0000
+
+#endif  // SELFTEST_TDX_TD_BOOT_ASM_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/td_boot.S b/tools/testing/selftests/kvm/lib/x86/tdx/td_boot.S
new file mode 100644
index 000000000000..7aa33caa9a78
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/td_boot.S
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include "tdx/td_boot_asm.h"
+#include "tdx/td_boot_offsets.h"
+#include "processor_asm.h"
+
+.code32
+
+.globl td_boot
+td_boot:
+	/* In this procedure, edi is used as a temporary register. */
+	cli
+
+	/* Paging is off. */
+
+	movl $TD_BOOT_PARAMETERS_GPA, %ebx
+
+	/*
+	 * Find the address of struct td_per_vcpu_parameters for this
+	 * vCPU based on esi (TDX spec: initialized with vCPU id). Put
+	 * struct address into register for indirect addressing.
+	 */
+	movl $SIZEOF_TD_PER_VCPU_PARAMETERS, %eax
+	mul %esi
+	leal TD_BOOT_PARAMETERS_PER_VCPU(%ebx), %edi
+	addl %edi, %eax
+
+	/* Setup stack. */
+	movl TD_PER_VCPU_PARAMETERS_ESP_GVA(%eax), %esp
+
+	/* Setup GDT. */
+	leal TD_BOOT_PARAMETERS_GDT(%ebx), %edi
+	lgdt (%edi)
+
+	/* Setup IDT. */
+	leal TD_BOOT_PARAMETERS_IDT(%ebx), %edi
+	lidt (%edi)
+
+	/*
+	 * Set up control registers (There are no instructions to mov from
+	 * memory to control registers, hence use edi as a scratch register).
+	 */
+	movl TD_BOOT_PARAMETERS_CR4(%ebx), %edi
+	movl %edi, %cr4
+	movl TD_BOOT_PARAMETERS_CR3(%ebx), %edi
+	movl %edi, %cr3
+	movl TD_BOOT_PARAMETERS_CR0(%ebx), %edi
+	movl %edi, %cr0
+
+	/* Switching to 64bit mode after ljmp and then jump to guest code */
+	ljmp $(KERNEL_CS),$1f
+1:
+	jmp *TD_PER_VCPU_PARAMETERS_GUEST_CODE(%eax)
+
+/* Leave marker so size of td_boot code can be computed. */
+.globl td_boot_code_end
+td_boot_code_end:
+
+/* Disable executable stack. */
+.section .note.GNU-stack,"",%progbits
-- 
2.51.1.851.g4ebd6896fd-goog


