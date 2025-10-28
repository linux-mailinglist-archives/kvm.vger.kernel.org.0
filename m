Return-Path: <kvm+bounces-61332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EC8C16F21
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D01F3506635
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3573570C9;
	Tue, 28 Oct 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HN76BPW4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123613557FC
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686466; cv=none; b=OZHlo1ru93RHNeotLxB0I+S5DD2wmoiQxBzyjJFjkybeGPNjFaMdd1/I10hRz1GCqQSrM7/TASnCJWWicQL3s7Ht7s+I4vlwl8Dvx9tg0rhuJQGHlaEnUWyAfNWws/QYViYpTfHQzAoks61tMYPfR3NYEgcN4XocWzuDqxWobYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686466; c=relaxed/simple;
	bh=1pFhFcxcWb6H73VV7nWvHIQIecGrbGn1xVkopoQFDws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCoMog7F6jMx1Bei3Tm6RleXCf/Ns6YuYtqEnHrhE1XHEyJp0Y+01Kl8sOrDPLRjzvfHAaKxpxybsXUIBmswAtOpKMRjOBB0f9T2FpdnrKWHtjWHuQDUyhbogNEeQnlWduGo4QMOgOmd/13Gxb9tTZ0ZpX5COs/0AYJdtc+bxJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HN76BPW4; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-444126342a1so12401965b6e.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686463; x=1762291263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9afY0QTIDk71MMQfwJiwQWcpoO0hDRu8Jah9GndkX2I=;
        b=HN76BPW4MsyvwV29yjqtwtsky0Ht9BERVKpoAQJ42oabUxIw0JWZS38ayl/bTHphxb
         NF6e3v4se1vBpPVd/+Bsnz/dYKkfUO9XnpoouvWJlYmRS0uSG5eHZSgBiIG99yi1HwdH
         3bh1DZqFq5uMYmQ5ZuzLxYurxTzI5kKh1RwueOpjHvYDZkxYHJ2JIvapYYgWWcs5SRd/
         WLXLbhkU7AKWee10I5lFQIzzy18HY058N8zdGagstQ7nWHaWW9MAUW0LvTv1R75+49Ue
         kbDBaWzuSFiupfXLTitHB0GsHueygAuOcYek9zDEwz2kZ+rGnCfruhyQ07djaTk2S10F
         XdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686463; x=1762291263;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9afY0QTIDk71MMQfwJiwQWcpoO0hDRu8Jah9GndkX2I=;
        b=XA0Rp7ssv1ywL+5F1SjCJqG9RFHa2hPI8P2sA2nLGkpjuDK94dnwU1AmcHOr7o2bx/
         zuWnNt0lCmZST1b7SZh0T5aAGG3VDVq8c2MLnSncSc4a7GWixNdL+0JHlJFfHF6Ihvag
         42lxtLalKfELf0ble6N7Y9dK1I82yx3Jp8o9pcxGFKg6KxsfUaOF2tfD46/Cn3wrzPiC
         ZThM357SWZE2j3U2btOQzH1NP73zCHyWCJLSwxWpqtYcwZ/4y0VPwVeBOKusK4G620QY
         mfQTQimlQQvWVURw+9prvPnRJAdv0nEtwNjtcqzaNxcsy7jZaz/EuYMfZMA+ejO0g8+i
         zyhg==
X-Forwarded-Encrypted: i=1; AJvYcCUWTDM9qFDrzseXJFe/AMxyHlbdscjgny0215pD0gIpSEuort3r/a6/VkGvYas24bC0LWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkngCASG5RDChXDKN7RtAIwYbj11+QtG7F57h18yk/JD8K91BQ
	UYzaPAH7dN/FjL755NLOYj/CGp43cNcytgZWHqAUxVIEYeMrDZmeY2bIoSMOrD6nXHKFkGkCaEJ
	flA==
X-Google-Smtp-Source: AGHT+IHl/b16hj3J2TqA3wFZ2Y7a2bBoYwoEq0S++TA6ohiqPUzOF/4wHSzUC2JZ+xQVjNTQKb+DTE0UQg==
X-Received: from oiky14.prod.google.com ([2002:a05:6808:c08e:b0:44d:bb41:de3f])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:1829:b0:44f:6d6e:14af
 with SMTP id 5614622812f47-44f7a420012mr525641b6e.12.1761686463193; Tue, 28
 Oct 2025 14:21:03 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:34 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-9-sagis@google.com>
Subject: [PATCH v12 08/23] KVM: selftests: Define structs to pass parameters
 to TDX boot code
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
Content-Transfer-Encoding: quoted-printable

TDX registers are inaccessible to KVM. Therefore we need a different
mechanism to load boot parameters for TDX code. TDX boot code will read
the registers values from memory and set the registers manually.

This patch defines the data structures used to communicate between c
code and the TDX assembly boot code which will be added in a later
patch.

Use kbuild.h to expose the offsets into the structs from c code to
assembly code.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      | 18 +++++
 .../selftests/kvm/include/x86/tdx/td_boot.h   | 69 +++++++++++++++++++
 .../kvm/lib/x86/tdx/td_boot_offsets.c         | 21 ++++++
 3 files changed, 108 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/td_boot_offsets=
.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index 148d427ff24b..5e809064ff1c 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -19,6 +19,8 @@ LIBKVM +=3D lib/userfaultfd_util.c
=20
 LIBKVM_STRING +=3D lib/string_override.c
=20
+LIBKVM_ASM_DEFS +=3D lib/x86/tdx/td_boot_offsets.c
+
 LIBKVM_x86 +=3D lib/x86/apic.c
 LIBKVM_x86 +=3D lib/x86/handlers.S
 LIBKVM_x86 +=3D lib/x86/hyperv.c
@@ -239,6 +241,10 @@ OVERRIDE_TARGETS =3D 1
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
=20
+# Enable Kbuild tools.
+include $(top_srcdir)/scripts/Kbuild.include
+include $(top_srcdir)/scripts/Makefile.lib
+
 INSTALL_HDR_PATH =3D $(top_srcdir)/usr
 LINUX_HDR_PATH =3D $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE =3D $(top_srcdir)/tools/include
@@ -291,6 +297,7 @@ LIBKVM_S :=3D $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ :=3D $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
+LIBKVM_ASM_DEFS_OBJ +=3D $(patsubst %.c, $(OUTPUT)/%.s, $(LIBKVM_ASM_DEFS)=
)
 LIBKVM_OBJS =3D $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIB=
CGROUP_O)
 SPLIT_TEST_GEN_PROGS :=3D $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ :=3D $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS=
))
@@ -317,6 +324,7 @@ $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%=
.c
=20
 EXTRA_CLEAN +=3D $(GEN_HDRS) \
 	       $(LIBKVM_OBJS) \
+	       $(LIBKVM_ASM_DEFS_OBJ) \
 	       $(SPLIT_TEST_GEN_OBJ) \
 	       $(TEST_DEP_FILES) \
 	       $(TEST_GEN_OBJ) \
@@ -328,18 +336,28 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
=20
+$(LIBKVM_ASM_DEFS_OBJ): $(OUTPUT)/%.s: %.c FORCE
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -S $< -o $@
+
 # Compile the string overrides as freestanding to prevent the compiler fro=
m
 # generating self-referential code, e.g. without "freestanding" the compil=
er may
 # "optimize" memcmp() by invoking memcmp(), thus causing infinite recursio=
n.
 $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
=20
+$(OUTPUT)/include/x86/tdx/td_boot_offsets.h: $(OUTPUT)/lib/x86/tdx/td_boot=
_offsets.s FORCE
+	$(call filechk,offsets,__TDX_BOOT_OFFSETS_H__)
+
+EXTRA_CLEAN +=3D $(OUTPUT)/include/x86/tdx/td_boot_offsets.h
+
 $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
 $(TEST_GEN_OBJ): $(GEN_HDRS)
=20
+FORCE:
+
 cscope: include_paths =3D $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include =
lib ..
 cscope:
 	$(RM) cscope.*
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h b/tools/=
testing/selftests/kvm/include/x86/tdx/td_boot.h
new file mode 100644
index 000000000000..32631645fe13
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_TDX_TD_BOOT_H
+#define SELFTEST_TDX_TD_BOOT_H
+
+#include <stdint.h>
+
+#include <linux/compiler.h>
+#include <linux/sizes.h>
+
+/*
+ * Layout for boot section (not to scale)
+ *
+ *                                   GPA
+ * _________________________________ 0x1_0000_0000 (4GB)
+ * |   Boot code trampoline    |
+ * |___________________________|____ 0x0_ffff_fff0: Reset vector (16B belo=
w 4GB)
+ * |   Boot code               |
+ * |___________________________|____ td_boot will be copied here, so that =
the
+ * |                           |     jmp to td_boot is exactly at the rese=
t vector
+ * |   Empty space             |
+ * |                           |
+ * |=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80|
+ * |                           |
+ * |                           |
+ * |   Boot parameters         |
+ * |                           |
+ * |                           |
+ * |___________________________|____ 0x0_ffff_0000: TD_BOOT_PARAMETERS_GPA
+ */
+#define FOUR_GIGABYTES_GPA (SZ_4G)
+
+/*
+ * The exact memory layout for LGDT or LIDT instructions.
+ */
+struct __packed td_boot_parameters_dtr {
+	uint16_t limit;
+	uint32_t base;
+};
+
+/*
+ * Allows each vCPU to be initialized with different rip and esp.
+ */
+struct td_per_vcpu_parameters {
+	uint32_t esp_gva;
+	uint64_t guest_code;
+};
+
+/*
+ * Boot parameters for the TD.
+ *
+ * Unlike a regular VM, KVM cannot set registers such as esp, eip, etc
+ * before boot, so to run selftests, these registers' values have to be
+ * initialized by the TD.
+ *
+ * This struct is loaded in TD private memory at TD_BOOT_PARAMETERS_GPA.
+ *
+ * The TD boot code will read off parameters from this struct and set up t=
he
+ * vCPU for executing selftests.
+ */
+struct td_boot_parameters {
+	uint32_t cr0;
+	uint32_t cr3;
+	uint32_t cr4;
+	struct td_boot_parameters_dtr gdtr;
+	struct td_boot_parameters_dtr idtr;
+	struct td_per_vcpu_parameters per_vcpu[];
+};
+
+#endif /* SELFTEST_TDX_TD_BOOT_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/td_boot_offsets.c b/to=
ols/testing/selftests/kvm/lib/x86/tdx/td_boot_offsets.c
new file mode 100644
index 000000000000..7f76a3585b99
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/td_boot_offsets.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#define COMPILE_OFFSETS
+
+#include <linux/kbuild.h>
+
+#include "tdx/td_boot.h"
+
+static void __attribute__((used)) common(void)
+{
+	OFFSET(TD_BOOT_PARAMETERS_CR0, td_boot_parameters, cr0);
+	OFFSET(TD_BOOT_PARAMETERS_CR3, td_boot_parameters, cr3);
+	OFFSET(TD_BOOT_PARAMETERS_CR4, td_boot_parameters, cr4);
+	OFFSET(TD_BOOT_PARAMETERS_GDT, td_boot_parameters, gdtr);
+	OFFSET(TD_BOOT_PARAMETERS_IDT, td_boot_parameters, idtr);
+	OFFSET(TD_BOOT_PARAMETERS_PER_VCPU, td_boot_parameters, per_vcpu);
+	OFFSET(TD_PER_VCPU_PARAMETERS_ESP_GVA, td_per_vcpu_parameters, esp_gva);
+	OFFSET(TD_PER_VCPU_PARAMETERS_GUEST_CODE, td_per_vcpu_parameters,
+	       guest_code);
+	DEFINE(SIZEOF_TD_PER_VCPU_PARAMETERS,
+	       sizeof(struct td_per_vcpu_parameters));
+}
--=20
2.51.1.851.g4ebd6896fd-goog


