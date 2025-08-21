Return-Path: <kvm+bounces-55244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2162B2ECDB
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 645983B2B62
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11A72E972B;
	Thu, 21 Aug 2025 04:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Auc1pgo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38082E8DFD
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750578; cv=none; b=oLgt1PEYvrnE9vHnqUaeHI3+XQIfc3UCgizUvZ35E0GrRgHDpFL4wxqwnV7bQxd/BdSuJ84oKW9Iv6BgJKjPZzJNQR/FDKtBAe1fBGjFgDdAp8kwpW6OyjhRIISF1PIXOpNFCZHVPmQ1QUTTDZ0dhqZx0TPRtVtniMNSh8QLIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750578; c=relaxed/simple;
	bh=ZVougY0dY2ceOBEi33N2vgqPtFJB9JaguczwRJ00Jt0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rSyUImRBbz9Kga5YSmcQQphJHIdBYqs/Mea6oN95QtDnN+AHqIEbILRfv9Tm6Kq169+x5m4QGZbXODX3d7UMbcFrHmW6otn/aqEbDNdYyXe+ElS3/H1D+PV2+TINotA3GarjnEEftf9b2om+AqSb6DNRUuljIAowlT/Fq+kKqdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Auc1pgo; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e8e28e1so1849205b3a.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750576; x=1756355376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qxaWAzbRUzLCtzcho8oC+x5AUN01HLmIiDUYO6cqfgU=;
        b=4Auc1pgo2ImEG6nvhTX6Gw5N/JP3kZd3qsWtWLGXe8Q7F4se6mQ6YES/6iMvE4Fovo
         21CPmWBFNDdczswRCLWWW56rKtrOG1Bza/PYLII+An5GbQhetICFgN5o5s2Tozt3mdNK
         z8aAOb6Xca4vYbyHgRSKzHY4+4TURfbR8JjicV7dLMeij8ArP2UvL4WPlRqTL7t44M2I
         vbq7fxXPVqLA59ogOXMG7kK6WpimBsvRz72zsMx/pWGNi6vYJwtU/MeEgxhhuzU5TGYX
         w/vEP4I9Kk+vCROPyW9dGIx/WhCbM9jljC6tDjntPdE7iKrr+A5F/Cg8I+VWHkoM6qLF
         +TtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750576; x=1756355376;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qxaWAzbRUzLCtzcho8oC+x5AUN01HLmIiDUYO6cqfgU=;
        b=n30A5VJ7EjEwaUH+dUbEl+dVunHXA+PSYbhlDALcT1QFSw9quJnvrssXf2xKtpBgIB
         /Q46loEOoY4S4gawoLpO3G//50Yae9xdVjNpKFdr/l9epGjVGL2QVkf9a4wNLi+t4kbG
         ywI2qBQ9bW3KGPpnBQsmBzB2hQp5aMMzPD7Stg13kdJjkvUj/fGLBfoZyqN474c9EJLI
         OcyUhMWBTS89XJTLKRhzVsRvLRyrJNV95ZT/tf9DiO+Wpi4HJCcwu3BW6BfasFbKsaas
         0r0Win1ekSRNZxWGd3fUuVMW6NdeWpFB78rPdR7QmyJ07GLgTFMhkon7nwoUpsti9i7J
         /Ljw==
X-Forwarded-Encrypted: i=1; AJvYcCW2W8zK9+wHNWrFv+76El7CGUj89Ep0QHk32eSMP1Yc8kVPPYO563QNTMhbkpj0CXt1TCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7dpgsHzXe0+zO3Be5ubtProQrRrXRhJHf1MFOujKB0yBik+Lq
	1l+/vYjHok4QD6cvstt/vb+WuZPsqVRTafSqp+iqy40w4b0dCkF97HKmplBsdj5Tfh9/LPko8BW
	Vzw==
X-Google-Smtp-Source: AGHT+IHnjpFoTbfwDN7Mg8/PDSYsq+ZuUsM1vByP70khuw6E+rVAxKF66kUKvJSM3bENe4ub1NMjckWTzQ==
X-Received: from pfuv10.prod.google.com ([2002:a05:6a00:148a:b0:76e:2713:9ad0])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:238c:b0:749:b41:2976
 with SMTP id d2e1a72fcca58-76ea30efd03mr1081092b3a.3.1755750575792; Wed, 20
 Aug 2025 21:29:35 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:01 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-9-sagis@google.com>
Subject: [PATCH v9 08/19] KVM: selftests: Define structs to pass parameters to
 TDX boot code
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

TDX registers are inaccesible to KVM. Therefore we need a different
mechanism to load boot parameters for TDX code. TDX boot code will read
the registers values from memory and set the registers manually.

This patch defines the data structures used to communicate between c
code and the TDX assembly boot code which will be added in a later
patch.

Use kbuild.h to expose the offsets into the structs from c code to
assembly code.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      | 18 +++++
 .../selftests/kvm/include/x86/tdx/td_boot.h   | 76 +++++++++++++++++++
 .../kvm/lib/x86/tdx/td_boot_offsets.c         | 21 +++++
 3 files changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/td_boot_offsets=
.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index f6fe7a07a0a2..f4686445c197 100644
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
@@ -229,6 +231,10 @@ OVERRIDE_TARGETS =3D 1
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
@@ -281,6 +287,7 @@ LIBKVM_S :=3D $(filter %.S,$(LIBKVM))
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
@@ -307,6 +314,7 @@ $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%=
.c
=20
 EXTRA_CLEAN +=3D $(GEN_HDRS) \
 	       $(LIBKVM_OBJS) \
+	       $(LIBKVM_ASM_DEFS_OBJ) \
 	       $(SPLIT_TEST_GEN_OBJ) \
 	       $(TEST_DEP_FILES) \
 	       $(TEST_GEN_OBJ) \
@@ -318,18 +326,28 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
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
index 000000000000..5cce671586e9
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/tdx/td_boot.h
@@ -0,0 +1,76 @@
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
+ * Allows each vCPU to be initialized with different eip and esp.
+ *
+ * __packed is used since the offsets are hardcoded in td_boot.S
+ *
+ * TODO: Replace hardcoded offsets with OFFSET(). This requires getting th=
e
+ * neccesry Kbuild scripts working in KVM selftests.
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
+ *
+ * __packed is used since the offsets are hardcoded in td_boot.S
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
2.51.0.rc1.193.gad69d77794-goog


