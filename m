Return-Path: <kvm+bounces-58800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1E1BA0DDF
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 399FC7BF263
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFE431D396;
	Thu, 25 Sep 2025 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlTPIlYz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5431A576
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821360; cv=none; b=r0zbWoYVYqSefAtbDUk/gkpk71VpI1Y8y2Vblu4mqTndGC0h2iqXFA5E6gTac6sglBzihbP4t1ZzWWtaZu2C5xMuDuy+A+TmCPplTf6JZAAFnilW6miKOqCbriBzs/6yI47QsqK1pzyXpim8Mjwt8/fno/Uv9QhqIRC4FXhag0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821360; c=relaxed/simple;
	bh=vTy30/tQgLN9RDnh25oE90h3VeWiHnYTSMLkxhXis7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PVMDygjxYoOWtQw3tYbsbgaKy8DkPEp3ZCTpjl3fm3XHqoFf6et3JN1P5u6Bem2kr1Gs0yrZFRVhhq/Elgr/eOSkKI2EDCAM8FQKPOnHIOIDH4OrOeutwmlyXuAR413MCTJWNb/w4dlGFxPTIyxOcNaXM0EsxKQxSKUp1SVlMlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlTPIlYz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77e7808cf4bso878511b3a.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821357; x=1759426157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jq32N4zQdZvpB3KBOjRNfMvgxoaP6cr0TCKHzbKZPoI=;
        b=QlTPIlYz1A+ijur5228q73au+L0dIo5UtEf4DyDP4AWDVLDEKX5cKwFLcTSG/YOSNU
         h/rIRO/yY6Bc+npWpM3xP3xoTS949WZEFvN0gNqtJdBiybON93MfixKRmxfpHeJtId5C
         NwP9KXNKw+94/rUMQcWqrO4609h5U3/VoT40zhYlxeMY67jd3ysfVa/okl6ASUN8zJfN
         xs9VZHhy2OrsikCqlggIaIUL4LQFfmZpWuR2gAA7JBmJTrayZYe4nWYHD+Jeh3G79cn4
         Dol7IGqegCugDZAV0Gm56bbUMpxbsBvKJniHYLvKA8yWovNlZXdtywtjoVtMv7ZmtQTh
         hhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821357; x=1759426157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jq32N4zQdZvpB3KBOjRNfMvgxoaP6cr0TCKHzbKZPoI=;
        b=PaoljYn9Tn0IaAzF6zgAC7acCNm7nvb9LOBPkiMtT/hOaWd0D4NjmYuCfzA5m9AkZY
         anwyJWxraoh+BAj53RZWWOJX6DI/VNkNVI1OderdGlkZPxFb8zR+NjFp0QkROeXbY2p4
         eoRPYsvxjlYY88RQBdEXfJbzlCd8/7yl29wAKNm39ooICpfgy37PpvRU3K7+LrofbQjm
         Am4JgPpb4rw2lPfQ0mWO3MFP94QuUxthMEn1kuQcOqbHMY7hCJ+4HyDfbjRHjFTxz/sE
         0wkuCInCyxPBtniLpPV76FMIbeQx9ceTJLcJMFunA5WXdahPlyrTLMq429khKFMoiAJZ
         kNcg==
X-Forwarded-Encrypted: i=1; AJvYcCVjJCVXBYK5ph8yepF9eBttII2cRXRxzs0O6DVDG9/JzRJzKxGOPU5gGvJhySoqxpVAC6U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw6Ss3vtHAI1JiCDsA9FmfKTC1zCl3f2m6aEOTojjo9s8YrkSp
	5IcD4LcH1nM8sGANLBzSnYnPzfUwgD9qnV5e4sEHkt1nWin/9vE3GQuhASRfp6TG1025fC3AHWN
	W9A==
X-Google-Smtp-Source: AGHT+IGwifTeRKj3uUJwXuvkE8D4Y4qWQNpxH/T52DC7hpr054BQxhka4L8X920sPMemfC+xK1McRF26FQ==
X-Received: from pfbkx21.prod.google.com ([2002:a05:6a00:6f15:b0:77c:7706:8702])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928b:b0:77f:366b:b711
 with SMTP id d2e1a72fcca58-780fce1dd3amr5135005b3a.6.1758821357465; Thu, 25
 Sep 2025 10:29:17 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:39 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-12-sagis@google.com>
Subject: [PATCH v11 11/21] KVM: selftests: Add helper to initialize TDX VM
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

KVM_TDX_INIT_VM needs to be called after KVM_CREATE_VM and before
creating any VCPUs, thus before KVM_SET_CPUID2. KVM_TDX_INIT_VM accepts
the CPUID values directly.

Since KVM_GET_CPUID2 can't be used at this point, calculate the CPUID
values manually by using kvm_get_supported_cpuid() and filter the
returned CPUIDs against the supported CPUID values read from the TDX
module.

Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |  54 +++++++
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 132 ++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index dafdc7e46abe..a2509959c7ce 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -11,6 +11,60 @@ static inline bool is_tdx_vm(struct kvm_vm *vm)
 	return vm->type == KVM_X86_TDX_VM;
 }
 
+/*
+ * TDX ioctls
+ */
+
+#define __vm_tdx_vm_ioctl(vm, cmd, metadata, arg)			\
+({									\
+	int r;								\
+									\
+	union {								\
+		struct kvm_tdx_cmd c;					\
+		unsigned long raw;					\
+	} tdx_cmd = { .c = {						\
+		.id = (cmd),						\
+		.flags = (uint32_t)(metadata),				\
+		.data = (uint64_t)(arg),				\
+	} };								\
+									\
+	r = __vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd.raw);	\
+	r ?: tdx_cmd.c.hw_error;					\
+})
+
+#define vm_tdx_vm_ioctl(vm, cmd, flags, arg)				\
+({									\
+	int ret = __vm_tdx_vm_ioctl(vm, cmd, flags, arg);		\
+									\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd,	ret, vm);		\
+})
+
+#define __vm_tdx_vcpu_ioctl(vcpu, cmd, metadata, arg)			\
+({									\
+	int r;								\
+									\
+	union {								\
+		struct kvm_tdx_cmd c;					\
+		unsigned long raw;					\
+	} tdx_cmd = { .c = {						\
+		.id = (cmd),						\
+		.flags = (uint32_t)(metadata),				\
+		.data = (uint64_t)(arg),				\
+	} };								\
+									\
+	r = __vcpu_ioctl(vcpu, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd.raw);	\
+	r ?: tdx_cmd.c.hw_error;					\
+})
+
+#define vm_tdx_vcpu_ioctl(vcpu, cmd, flags, arg)			\
+({									\
+	int ret = __vm_tdx_vcpu_ioctl(vcpu, cmd, flags, arg);		\
+									\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
+})
+
+void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes);
+
 void vm_tdx_setup_boot_code_region(struct kvm_vm *vm);
 void vm_tdx_setup_boot_parameters_region(struct kvm_vm *vm, uint32_t nr_runnable_vcpus);
 void vm_tdx_load_common_boot_parameters(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index f3b69923e928..7a622b4810b1 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -124,3 +124,135 @@ void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 
 	vcpu_params->guest_code = (uint64_t)guest_code;
 }
+
+static struct kvm_tdx_capabilities *tdx_read_capabilities(struct kvm_vm *vm)
+{
+	struct kvm_tdx_capabilities *tdx_cap = NULL;
+	int nr_cpuid_configs = 4;
+	int rc = -1;
+	int i;
+
+	do {
+		nr_cpuid_configs *= 2;
+
+		tdx_cap = realloc(tdx_cap, sizeof(*tdx_cap) +
+					   sizeof(tdx_cap->cpuid) +
+					   (sizeof(struct kvm_cpuid_entry2) * nr_cpuid_configs));
+		TEST_ASSERT(tdx_cap,
+			    "Could not allocate memory for tdx capability nr_cpuid_configs %d\n",
+			    nr_cpuid_configs);
+
+		tdx_cap->cpuid.nent = nr_cpuid_configs;
+		rc = __vm_tdx_vm_ioctl(vm, KVM_TDX_CAPABILITIES, 0, tdx_cap);
+	} while (rc < 0 && errno == E2BIG);
+
+	TEST_ASSERT(rc == 0, "KVM_TDX_CAPABILITIES failed: %d %d",
+		    rc, errno);
+
+	pr_debug("tdx_cap: supported_attrs: 0x%016llx\n"
+		 "tdx_cap: supported_xfam 0x%016llx\n",
+		 tdx_cap->supported_attrs, tdx_cap->supported_xfam);
+
+	for (i = 0; i < tdx_cap->cpuid.nent; i++) {
+		const struct kvm_cpuid_entry2 *config = &tdx_cap->cpuid.entries[i];
+
+		pr_debug("cpuid config[%d]: leaf 0x%x sub_leaf 0x%x eax 0x%08x ebx 0x%08x ecx 0x%08x edx 0x%08x\n",
+			 i, config->function, config->index,
+			 config->eax, config->ebx, config->ecx, config->edx);
+	}
+
+	return tdx_cap;
+}
+
+static struct kvm_cpuid_entry2 *tdx_find_cpuid_config(struct kvm_tdx_capabilities *cap,
+						      uint32_t leaf, uint32_t sub_leaf)
+{
+	struct kvm_cpuid_entry2 *config;
+	uint32_t i;
+
+	for (i = 0; i < cap->cpuid.nent; i++) {
+		config = &cap->cpuid.entries[i];
+
+		if (config->function == leaf && config->index == sub_leaf)
+			return config;
+	}
+
+	return NULL;
+}
+
+/*
+ * Filter CPUID based on TDX supported capabilities
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   cpuid_data - CPUID fileds to filter
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * For each CPUID leaf, filter out non-supported bits based on the capabilities reported
+ * by the TDX module
+ */
+static void vm_tdx_filter_cpuid(struct kvm_vm *vm,
+				struct kvm_cpuid2 *cpuid_data)
+{
+	struct kvm_tdx_capabilities *tdx_cap;
+	struct kvm_cpuid_entry2 *config;
+	struct kvm_cpuid_entry2 *e;
+	int i;
+
+	tdx_cap = tdx_read_capabilities(vm);
+
+	i = 0;
+	while (i < cpuid_data->nent) {
+		e = cpuid_data->entries + i;
+		config = tdx_find_cpuid_config(tdx_cap, e->function, e->index);
+
+		if (!config) {
+			int left = cpuid_data->nent - i - 1;
+
+			if (left > 0)
+				memmove(cpuid_data->entries + i,
+					cpuid_data->entries + i + 1,
+					sizeof(*cpuid_data->entries) * left);
+			cpuid_data->nent--;
+			continue;
+		}
+
+		e->eax &= config->eax;
+		e->ebx &= config->ebx;
+		e->ecx &= config->ecx;
+		e->edx &= config->edx;
+
+		i++;
+	}
+
+	free(tdx_cap);
+}
+
+void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
+{
+	struct kvm_tdx_init_vm *init_vm;
+	const struct kvm_cpuid2 *tmp;
+	struct kvm_cpuid2 *cpuid;
+
+	tmp = kvm_get_supported_cpuid();
+
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	memcpy(cpuid, tmp, kvm_cpuid2_size(tmp->nent));
+	vm_tdx_filter_cpuid(vm, cpuid);
+
+	init_vm = calloc(1, sizeof(*init_vm) +
+			 sizeof(init_vm->cpuid.entries[0]) * cpuid->nent);
+	TEST_ASSERT(init_vm, "init_vm allocation failed");
+
+	memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
+	free(cpuid);
+
+	init_vm->attributes = attributes;
+
+	vm_tdx_vm_ioctl(vm, KVM_TDX_INIT_VM, 0, init_vm);
+
+	free(init_vm);
+}
-- 
2.51.0.536.g15c5d4f767-goog


