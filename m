Return-Path: <kvm+bounces-6914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F7B83B7DA
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E05DD1F24F20
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A887462;
	Thu, 25 Jan 2024 03:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heRvmlxy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D111198
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153298; cv=none; b=Q7/4KSdfyyy2XVj+JLta386rYraFAUmAjvFc5WEhMhD1ZcUm0jOzJ2NHYQEYkOLrt1qiqDpz6Jc2vXOCJouiZzKsgQnb7aXo38DBnnGV/V7ZSqGV+sn8DT5WDkO0YS2kjwoTJUd2AbTeZMhW99Il02Tl7BPO9c4gtG9xGyGpa9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153298; c=relaxed/simple;
	bh=qWOj2eQbQqTTvHD6HtJwRO1jTfYXQp1i9dIrNkCuZCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B6hTrI1P1ubbG+y51ICrvrD1baf+YZXw+a2ZaJJQ+36erAnvVV1tdukw9yRtFVie2ASonSKkRuBZoNGqpEheeC8G+XMsuGwQ3A9naIBQXpY2YbVhQ5xDUjaPoJ8laCZvCYJRcnkhN5aLH3iv+pOUuTGbpVVlQuhcqqSvMked4uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heRvmlxy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153296; x=1737689296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qWOj2eQbQqTTvHD6HtJwRO1jTfYXQp1i9dIrNkCuZCA=;
  b=heRvmlxyFD/Qo35rAjafADwvqXtvRIR9LACjuDjuw3RIGw2FGgsvN0yE
   vGK5cxUfCVhSpBwDQ/APVIlIEjf/SKP0UryqHApVKepXHZeCBOxnQ3wkP
   I3RhiqziZJha7/hTB1t5ZPxyEfF9eAw07pQgG2jK+k5wgknFXkYZT3qEz
   d+ufUsCsv85hrlyuA453eKPkOESh/UXpxMLZHirBn+anLavyDDJXQ1EiA
   542A6lTaP803HqhZFhfYezivm839W9ctqqJrLgXAkeuKyUbpy8wcGTrpY
   XxFOCHbK6lzWV/oPulwYs+HgVav4o4rsBZOSKB5LTBCyMCNNrNurbtcsc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428195"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428195"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084870"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:38 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 12/66] target/i386: Implement mc->kvm_type() to get VM type
Date: Wed, 24 Jan 2024 22:22:34 -0500
Message-Id: <20240125032328.2522472-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX VM requires VM type KVM_X86_TDX_VM to be passed to
kvm_ioctl(KVM_CREATE_VM). Hence implement mc->kvm_type() for i386
architecture.

If tdx-guest object is specified to confidential-guest-support, like,

  qemu -machine ...,confidential-guest-support=tdx0 \
       -object tdx-guest,id=tdx0,...

it parses VM type as KVM_X86_TDX_VM. Otherwise, it's KVM_X86_DEFAULT_VM.

Also store the vm_type in MachineState for other code to query what the
VM type is.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v4:
 - fix the build error of kvm_get_vm_type() when --disable-kvm;
---
 hw/i386/x86.c              | 12 ++++++++++++
 include/hw/i386/x86.h      |  1 +
 target/i386/kvm/kvm.c      | 30 ++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 4 files changed, 44 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 2b6291ad8d5f..f66a92f6c9cc 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1386,6 +1386,17 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static int x86_kvm_type(MachineState *ms, const char *vm_type)
+{
+    X86MachineState *x86ms = X86_MACHINE(ms);
+    int kvm_type;
+
+    kvm_type = kvm_enabled() ? kvm_get_vm_type(ms, vm_type) : 0;
+    x86ms->vm_type = kvm_type;
+
+    return kvm_type;
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1410,6 +1421,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->kvm_type = x86_kvm_type;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index da19ae15463a..ab1d38569019 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -41,6 +41,7 @@ struct X86MachineState {
     MachineState parent;
 
     /*< public >*/
+    unsigned int vm_type;
 
     /* Pointers to devices and objects: */
     ISADevice *rtc;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 42970ab046fa..c961846777cc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -32,6 +32,7 @@
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
 #include "sev.h"
+#include "tdx.h"
 #include "xen-emu.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
@@ -161,6 +162,35 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
+static const char *vm_type_name[] = {
+    [KVM_X86_DEFAULT_VM] = "default",
+    [KVM_X86_TDX_VM] = "tdx",
+};
+
+int kvm_get_vm_type(MachineState *ms, const char *vm_type)
+{
+    int kvm_type = KVM_X86_DEFAULT_VM;
+
+    if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
+        kvm_type = KVM_X86_TDX_VM;
+    }
+
+    /*
+     * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
+     * is always supported
+     */
+    if (kvm_type == KVM_X86_DEFAULT_VM) {
+        return kvm_type;
+    }
+
+    if (!(kvm_check_extension(KVM_STATE(ms->accelerator), KVM_CAP_VM_TYPES) & BIT(kvm_type))) {
+        error_report("vm-type %s not supported by KVM", vm_type_name[kvm_type]);
+        exit(1);
+    }
+
+    return kvm_type;
+}
+
 bool kvm_has_smm(void)
 {
     return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 30fedcffea3e..55fb25fa8e2e 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -37,6 +37,7 @@ bool kvm_hv_vpindex_settable(void);
 bool kvm_enable_sgx_provisioning(KVMState *s);
 bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
 
+int kvm_get_vm_type(MachineState *ms, const char *vm_type);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
-- 
2.34.1


