Return-Path: <kvm+bounces-61336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F71C16F4C
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C28B11883056
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C79A355818;
	Tue, 28 Oct 2025 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4tCOWyxM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA063570D5
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686469; cv=none; b=F1DINfO2ugyPm5iECOqweOp+PEZaB1LRwN+JYDLeihclR4vcF5j2CE559jW3PGb2eJMyMN4wxufA6fb+GRKVZaTBpKQ0s5uzwarZC3d8m3scmPXcT+tVaKCDN9W9e4zabLIPE5o215If9qXeX8ztgrnfv7cSVB7AYcOD0M7UDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686469; c=relaxed/simple;
	bh=Gi7/8z3siwhpfL7OyMvxvnm6KsYsxHzKCabFXuLvNuw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VL34B9ZILcVhe4SpYmDqazTt3g5M1K+w2VbBxpgIyIGvNVfkLw0A8ocZ7eVlOWHVIfCLXYxxUKpQYNzOQS4d01/n4GH1qrl261WqzQM0Q27T/Cm0MOwuDHqIvTXWTRREPGN1SnsfVXn4lhjSQU7lDP/A3tHvJ0JQWB/ZqAiIEfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4tCOWyxM; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-93e8092427aso695902539f.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686467; x=1762291267; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ulPvgfG0Y+r+D5t//1kV8qb0CClUAPZGriJ9NB4m8w=;
        b=4tCOWyxMPuYBhACKjabPmkHlqzypuX3jMMS8fF7cn98AYBkMGxCtseC3xcHt0OzpP2
         UqdhjcB2w/jY42XkwJh269t+zhytYbXYS/xCizwZhTSlusQJKM0oJ7aJ67v07w4aHYjX
         q/LXwe16osjR99Gg4SwQCv/kGZ9xsm1C7dOjz/b5ilfipNtR98QlQ/8+HzKajFimbU+y
         tCAl7+cXW/QKiMXw/MbrJfqgZ9qXDM/Pb3Fctl1ASD/Yds9uZKq+PEkR7HNTRT946idt
         EqsLWHnJQ524rfhcNox4qmy9kYcaFlMOJjc2HHh/L/vcBDSNFg9OI4XbLJQG7Fjh7syr
         j1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686467; x=1762291267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ulPvgfG0Y+r+D5t//1kV8qb0CClUAPZGriJ9NB4m8w=;
        b=cSncsurudjr8//zj6HTsZGrNyy1B58iDWpAiZAu0Ie0ohQtFn1oeTsKY+3jDoVE3qI
         KlmHgQLStLN/ng5k7ukUIavpoyRqtCDQp+EwMiyo0e9iCfITuKE5CV9CWzN5iuHHRMSy
         wmoDCNbiCDURIx9YkmncxFFhCJrlOCxSQkjsP3GwkjuB1iixkAao+ZDMDd9HJXMsAldr
         qjQMiHzuga2dqHbcblmWoPHgx+T6m/Poz11ljkf9FFrK2IBnh8iGDwh1rS7fMYIKmPS1
         nBgWP0+TSKAAyoC19PkbkYXrRXXaxD3UtPqokRVK9MFZrkAoU1Lrj8TwSQqp4XeNo99p
         Mcrg==
X-Forwarded-Encrypted: i=1; AJvYcCWL0voYReGScKs3CzeqWAd9Tciy0QcqDKQc1ICGo5zuaDytiBdz+QrtEp6kb7IZI/yTke8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3JDE6Kc+73HJL5P7e+i2xK7S5NweZ8H654I0Uee1k0AKJoqHn
	CrGCk5gmtb1ZwDmkZab4ivZ34ZmMXvz2rrwrevBiMOorsw3FSllK/hT7zLPfcDVYCKfOdZNEY9M
	lFA==
X-Google-Smtp-Source: AGHT+IH+cljlkfIMY+ND7OCx0HPVgq0VipHvvwULcrZ0s3vwVUVzWtYvXfFkzzQNpiZK5iMW2kmPhZIX5Q==
X-Received: from iobbl14.prod.google.com ([2002:a05:6602:408e:b0:943:59e0:6b22])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:608c:b0:945:adeb:f245
 with SMTP id ca18e2360f4ac-945c969a9c6mr129595639f.1.1761686466981; Tue, 28
 Oct 2025 14:21:06 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:38 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-13-sagis@google.com>
Subject: [PATCH v12 12/23] KVM: selftests: Add helper to initialize TDX VM
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
2.51.1.851.g4ebd6896fd-goog


