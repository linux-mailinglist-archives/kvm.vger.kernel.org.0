Return-Path: <kvm+bounces-1741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507A37EBD8A
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8D15B20E98
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95B64C8C;
	Wed, 15 Nov 2023 07:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RX4VwJXT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDAD4683
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:17:14 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF9BD1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032633; x=1731568633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOwzZJlAAZ+Bk0Bo77WW3UNqdbmFwdaTLljNrwycifs=;
  b=RX4VwJXTuwzqcbIPcM1B+DmFotmW8jZeSi14cVBaypzjahH0ydSmaOfp
   CiGQpsWSK9CG4vqVbq6H0OkLJXVkJT4485RIdoe+AIDVzYScvUnszD6vN
   FWBJm4cXzzg3jVdCjgld3d6mBZEvisETBtF4jEbkd4fqaCsBhLV9qObMy
   tL/59qOr8s2j8KcQXwdoLv//cDV1cjQ4w2svyigYMggLU3OpDszfU+xlW
   LthjierE4zOfUgjHYfPI4y29V2o337BxCvfHenppSeTFEgpti30df8d0R
   WKCcSgPk3QYkwsWJ9En0zfqdjCLSlgoO1U6poeEYfxWsifJS5vcoLQgHS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622376"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622376"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:17:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797587"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797587"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:17:05 -0800
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
Subject: [PATCH v3 14/70] target/i386: Implement mc->kvm_type() to get VM type
Date: Wed, 15 Nov 2023 02:14:23 -0500
Message-Id: <20231115071519.2864957-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement mc->kvm_type() for i386 machines. It provides a way for user
to create SW_PROTECTE_VM.

Also store the vm_type in machinestate to other code to query what the
VM type is.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c              | 12 ++++++++++++
 include/hw/i386/x86.h      |  1 +
 target/i386/kvm/kvm.c      | 25 +++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 4 files changed, 39 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index b3d054889bba..55678279bf3b 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1377,6 +1377,17 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static int x86_kvm_type(MachineState *ms, const char *vm_type)
+{
+    X86MachineState *x86ms = X86_MACHINE(ms);
+    int kvm_type;
+
+    kvm_type = kvm_get_vm_type(ms, vm_type);
+    x86ms->vm_type = kvm_type;
+
+    return kvm_type;
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1401,6 +1412,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
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
index b4b9ce89842f..2e47fda25f95 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -161,6 +161,31 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
+static const char* vm_type_name[] = {
+    [KVM_X86_DEFAULT_VM] = "default",
+    [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
+};
+
+int kvm_get_vm_type(MachineState *ms, const char *vm_type)
+{
+    int kvm_type = KVM_X86_DEFAULT_VM;
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


