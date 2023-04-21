Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867366EAFE2
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjDUQ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDUQ7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:59:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB3315A14
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:58:38 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2f55ffdbaedso1269848f8f.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682096252; x=1684688252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m546At0nD6pKDP8+3gdJork4T/9dujMuRMZk6oGg9Oc=;
        b=CAqWPQhc3hGehCZZMAS1sECP4Os78QovGVWHT4D7ykTcTRnkN7yGcu/E07HzbxMYlL
         zZeNVGdL3f7cmTT/5QtST5ZQw1PMtEVblFV+//bdPL09iukRIb08TUFiNN7rUgpFaMhp
         /onZxlqi5oGEtGvBj2hQ18bLf1R0+1HPUIESw8/gV3RYCzU4+BeOeALGy6B+wpfysQED
         vo5huF2rkH3gMz/7MMRk1ECP/N9yKUFd7JVHVnXm4g+E/zyfBQiWeysqe7MWEhWfan3Q
         Q9ZhZyiMX2N9kUpQlpm/R95xkXCrpcaVMLNodVSBpzIl3h///1p0tWcCaakK3Nh1CYdf
         W3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096252; x=1684688252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m546At0nD6pKDP8+3gdJork4T/9dujMuRMZk6oGg9Oc=;
        b=MEEEUFZ8A12ref0Cxtf2ZwIHylWZ66H/AJytobp4kmjqWsyTF93+gTKQ8+HDOY+Ux5
         NKGcsrnSayRz3qLhr0BIZzzI1fwKeFh2T9maU5K3EQ4M3DqLT2b7yR1crtW03qzozFq/
         TGIcU7PpnA0w18MtFgktLyX4/vE+MM/ZU1MZOvoe2qQI+mWvThId3e9wZlEhJUN9w94q
         snhvZiZZBBT79bPd3XNUKEVDhK999wYMYMKZYBkkK3Qwf9Z70dukKt/kFqYQ9IUVU3H3
         d+qNSJw7+Pc79SUkpRuXVLIYqGz9k76nAuBGHkTvrz2MB7u/eOMj+1Dsb0XfrmlkARiJ
         cjHg==
X-Gm-Message-State: AAQBX9cGRznNQOzuUp06ayrbWmXZVSF8NwlFEbsFWUUbCNVODP0se96H
        TabeqLm2XEvICtJWY5OiX4Lhco7wXlwPr4nU2rc=
X-Google-Smtp-Source: AKy350bSl1VVrgEmzob3nB90BOf+tiOZD7jrNWOjsjxlIyXT9Ve4JLsvnLQxnUeSVnpQD7mAjlhR2w==
X-Received: by 2002:adf:fc11:0:b0:2f9:95b4:450a with SMTP id i17-20020adffc11000000b002f995b4450amr4471333wrr.25.1682096252411;
        Fri, 21 Apr 2023 09:57:32 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id s1-20020adff801000000b00300aee6c9cesm4813369wrp.20.2023.04.21.09.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 09:57:32 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, danielhb413@gmail.com,
        clg@kaod.org, david@gibson.dropbear.id.au, groug@kaod.org,
        peter.maydell@linaro.org, chenhuacai@kernel.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] kvm: Merge kvm_check_extension() and kvm_vm_check_extension()
Date:   Fri, 21 Apr 2023 17:38:23 +0100
Message-Id: <20230421163822.839167-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_CHECK_EXTENSION ioctl can be issued either on the global fd
(/dev/kvm), or on the VM fd obtained with KVM_CREATE_VM. For most
extensions, KVM returns the same value with either method, but for some
of them it can refine the returned value depending on the VM type. The
KVM documentation [1] advises to use the VM fd:

  Based on their initialization different VMs may have different
  capabilities. It is thus encouraged to use the vm ioctl to query for
  capabilities (available with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)

Ongoing work on Arm confidential VMs confirms this, as some capabilities
become unavailable to confidential VMs, requiring changes in QEMU to use
kvm_vm_check_extension() instead of kvm_check_extension() [2]. Rather
than changing each check one by one, change kvm_check_extension() to
always issue the ioctl on the VM fd when available, and remove
kvm_vm_check_extension().

Fall back to the global fd when the VM check is unavailable:

* Ancient kernels do not support KVM_CHECK_EXTENSION on the VM fd, since
  it was added by commit 92b591a4c46b ("KVM: Allow KVM_CHECK_EXTENSION
  on the vm fd") in Linux 3.17 [3]. Support for Linux 3.16 ended only in
  June 2020, but there may still be old images around.

* A couple of calls must be issued before the VM fd is available, since
  they determine the VM type: KVM_CAP_MIPS_VZ and KVM_CAP_ARM_VM_IPA_SIZE

Does any user actually depend on the check being done on the global fd
instead of the VM fd?  I surveyed all cases where KVM can return
different values depending on the query method. Luckily QEMU already
calls kvm_vm_check_extension() for most of those. Only three of them are
ambiguous, because currently done on the global fd:

* KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID on Arm, changes value if the
  user requests a vGIC different from the default. But QEMU queries this
  before vGIC configuration, so the reported value will be the same.

* KVM_CAP_SW_TLB on PPC. When issued on the global fd, returns false if
  the kvm-hv module is loaded; when issued on the VM fd, returns false
  only if the VM type is HV instead of PR. If this returns false, then
  QEMU will fail to initialize a BOOKE206 MMU model.

  So this patch supposedly improves things, as it allows to run this
  type of vCPU even when both KVM modules are loaded.

* KVM_CAP_PPC_SECURE_GUEST. Similarly, doing this check on a VM fd
  refines the returned value, and ensures that SVM is actually
  supported. Since QEMU follows the check with kvm_vm_enable_cap(), this
  patch should only provide better error reporting.

[1] https://www.kernel.org/doc/html/latest/virt/kvm/api.html#kvm-check-extension
[2] https://lore.kernel.org/kvm/875ybi0ytc.fsf@redhat.com/
[3] https://github.com/torvalds/linux/commit/92b591a4c46b

Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/sysemu/kvm.h     |  2 --
 include/sysemu/kvm_int.h |  1 +
 accel/kvm/kvm-all.c      | 26 +++++++++-----------------
 target/i386/kvm/kvm.c    |  6 +++---
 target/ppc/kvm.c         | 34 +++++++++++++++++-----------------
 5 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c8281c07a7..d62054004e 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -438,8 +438,6 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
 
 int kvm_check_extension(KVMState *s, unsigned int extension);
 
-int kvm_vm_check_extension(KVMState *s, unsigned int extension);
-
 #define kvm_vm_enable_cap(s, capability, cap_flags, ...)             \
     ({                                                               \
         struct kvm_enable_cap cap = {                                \
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a641c974ea..f6aa22ea09 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -122,6 +122,7 @@ struct KVMState
     uint32_t xen_caps;
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
+    bool check_extension_vm;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index cf3a88d90e..eca815e763 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1109,22 +1109,13 @@ int kvm_check_extension(KVMState *s, unsigned int extension)
 {
     int ret;
 
-    ret = kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
-    if (ret < 0) {
-        ret = 0;
+    if (!s->check_extension_vm) {
+        ret = kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
+    } else {
+        ret = kvm_vm_ioctl(s, KVM_CHECK_EXTENSION, extension);
     }
-
-    return ret;
-}
-
-int kvm_vm_check_extension(KVMState *s, unsigned int extension)
-{
-    int ret;
-
-    ret = kvm_vm_ioctl(s, KVM_CHECK_EXTENSION, extension);
     if (ret < 0) {
-        /* VM wide version not implemented, use global one instead */
-        ret = kvm_check_extension(s, extension);
+        ret = 0;
     }
 
     return ret;
@@ -2328,7 +2319,7 @@ static void kvm_irqchip_create(KVMState *s)
  */
 static int kvm_recommended_vcpus(KVMState *s)
 {
-    int ret = kvm_vm_check_extension(s, KVM_CAP_NR_VCPUS);
+    int ret = kvm_check_extension(s, KVM_CAP_NR_VCPUS);
     return (ret) ? ret : 4;
 }
 
@@ -2480,6 +2471,7 @@ static int kvm_init(MachineState *ms)
     }
 
     s->vmfd = ret;
+    s->check_extension_vm = kvm_check_extension(s, KVM_CAP_CHECK_EXTENSION_VM);
 
     /* check the vcpu limits */
     soft_vcpus_limit = kvm_recommended_vcpus(s);
@@ -2527,7 +2519,7 @@ static int kvm_init(MachineState *ms)
         ring_bytes = s->kvm_dirty_ring_size * sizeof(struct kvm_dirty_gfn);
 
         /* Read the max supported pages */
-        ret = kvm_vm_check_extension(s, KVM_CAP_DIRTY_LOG_RING);
+        ret = kvm_check_extension(s, KVM_CAP_DIRTY_LOG_RING);
         if (ret > 0) {
             if (ring_bytes > ret) {
                 error_report("KVM dirty ring size %" PRIu32 " too big "
@@ -2680,7 +2672,7 @@ static int kvm_init(MachineState *ms)
 
     s->many_ioeventfds = kvm_check_many_ioeventfds();
 
-    s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
+    s->sync_mmu = !!kvm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
     if (!s->sync_mmu) {
         ret = ram_block_discard_disable(true);
         assert(!ret);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..14f0164fe6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -161,7 +161,7 @@ int kvm_has_pit_state2(void)
 
 bool kvm_has_smm(void)
 {
-    return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
+    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
 }
 
 bool kvm_has_adjust_clock_stable(void)
@@ -2747,7 +2747,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                 return ret;
             }
     }
-    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+    if (kvm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
         bool r;
 
         ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
@@ -5403,7 +5403,7 @@ static bool __kvm_enable_sgx_provisioning(KVMState *s)
 {
     int fd, ret;
 
-    if (!kvm_vm_check_extension(s, KVM_CAP_SGX_ATTRIBUTE)) {
+    if (!kvm_check_extension(s, KVM_CAP_SGX_ATTRIBUTE)) {
         return false;
     }
 
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 78f6fc50cd..055a8acdcd 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -100,7 +100,7 @@ static uint32_t debug_inst_opcode;
 static bool kvmppc_is_pr(KVMState *ks)
 {
     /* Assume KVM-PR if the GET_PVINFO capability is available */
-    return kvm_vm_check_extension(ks, KVM_CAP_PPC_GET_PVINFO) != 0;
+    return kvm_check_extension(ks, KVM_CAP_PPC_GET_PVINFO) != 0;
 }
 
 static int kvm_ppc_register_host_cpu_type(void);
@@ -112,11 +112,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_interrupt_unset = kvm_check_extension(s, KVM_CAP_PPC_UNSET_IRQ);
     cap_segstate = kvm_check_extension(s, KVM_CAP_PPC_SEGSTATE);
     cap_booke_sregs = kvm_check_extension(s, KVM_CAP_PPC_BOOKE_SREGS);
-    cap_ppc_smt_possible = kvm_vm_check_extension(s, KVM_CAP_PPC_SMT_POSSIBLE);
+    cap_ppc_smt_possible = kvm_check_extension(s, KVM_CAP_PPC_SMT_POSSIBLE);
     cap_spapr_tce = kvm_check_extension(s, KVM_CAP_SPAPR_TCE);
     cap_spapr_tce_64 = kvm_check_extension(s, KVM_CAP_SPAPR_TCE_64);
     cap_spapr_multitce = kvm_check_extension(s, KVM_CAP_SPAPR_MULTITCE);
-    cap_spapr_vfio = kvm_vm_check_extension(s, KVM_CAP_SPAPR_TCE_VFIO);
+    cap_spapr_vfio = kvm_check_extension(s, KVM_CAP_SPAPR_TCE_VFIO);
     cap_one_reg = kvm_check_extension(s, KVM_CAP_ONE_REG);
     cap_hior = kvm_check_extension(s, KVM_CAP_PPC_HIOR);
     cap_epr = kvm_check_extension(s, KVM_CAP_PPC_EPR);
@@ -125,23 +125,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      * Note: we don't set cap_papr here, because this capability is
      * only activated after this by kvmppc_set_papr()
      */
-    cap_htab_fd = kvm_vm_check_extension(s, KVM_CAP_PPC_HTAB_FD);
+    cap_htab_fd = kvm_check_extension(s, KVM_CAP_PPC_HTAB_FD);
     cap_fixup_hcalls = kvm_check_extension(s, KVM_CAP_PPC_FIXUP_HCALL);
-    cap_ppc_smt = kvm_vm_check_extension(s, KVM_CAP_PPC_SMT);
-    cap_htm = kvm_vm_check_extension(s, KVM_CAP_PPC_HTM);
-    cap_mmu_radix = kvm_vm_check_extension(s, KVM_CAP_PPC_MMU_RADIX);
-    cap_mmu_hash_v3 = kvm_vm_check_extension(s, KVM_CAP_PPC_MMU_HASH_V3);
-    cap_xive = kvm_vm_check_extension(s, KVM_CAP_PPC_IRQ_XIVE);
-    cap_resize_hpt = kvm_vm_check_extension(s, KVM_CAP_SPAPR_RESIZE_HPT);
+    cap_ppc_smt = kvm_check_extension(s, KVM_CAP_PPC_SMT);
+    cap_htm = kvm_check_extension(s, KVM_CAP_PPC_HTM);
+    cap_mmu_radix = kvm_check_extension(s, KVM_CAP_PPC_MMU_RADIX);
+    cap_mmu_hash_v3 = kvm_check_extension(s, KVM_CAP_PPC_MMU_HASH_V3);
+    cap_xive = kvm_check_extension(s, KVM_CAP_PPC_IRQ_XIVE);
+    cap_resize_hpt = kvm_check_extension(s, KVM_CAP_SPAPR_RESIZE_HPT);
     kvmppc_get_cpu_characteristics(s);
-    cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
+    cap_ppc_nested_kvm_hv = kvm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
     cap_large_decr = kvmppc_get_dec_bits();
-    cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
+    cap_fwnmi = kvm_check_extension(s, KVM_CAP_PPC_FWNMI);
     /*
      * Note: setting it to false because there is not such capability
      * in KVM at this moment.
      *
-     * TODO: call kvm_vm_check_extension() with the right capability
+     * TODO: call kvm_check_extension() with the right capability
      * after the kernel starts implementing it.
      */
     cap_ppc_pvr_compat = false;
@@ -151,7 +151,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         exit(1);
     }
 
-    cap_rpt_invalidate = kvm_vm_check_extension(s, KVM_CAP_PPC_RPT_INVALIDATE);
+    cap_rpt_invalidate = kvm_check_extension(s, KVM_CAP_PPC_RPT_INVALIDATE);
     kvm_ppc_register_host_cpu_type();
 
     return 0;
@@ -1968,7 +1968,7 @@ static int kvmppc_get_pvinfo(CPUPPCState *env, struct kvm_ppc_pvinfo *pvinfo)
 {
     CPUState *cs = env_cpu(env);
 
-    if (kvm_vm_check_extension(cs->kvm_state, KVM_CAP_PPC_GET_PVINFO) &&
+    if (kvm_check_extension(cs->kvm_state, KVM_CAP_PPC_GET_PVINFO) &&
         !kvm_vm_ioctl(cs->kvm_state, KVM_PPC_GET_PVINFO, pvinfo)) {
         return 0;
     }
@@ -2288,7 +2288,7 @@ int kvmppc_reset_htab(int shift_hint)
         /* Full emulation, tell caller to allocate htab itself */
         return 0;
     }
-    if (kvm_vm_check_extension(kvm_state, KVM_CAP_PPC_ALLOC_HTAB)) {
+    if (kvm_check_extension(kvm_state, KVM_CAP_PPC_ALLOC_HTAB)) {
         int ret;
         ret = kvm_vm_ioctl(kvm_state, KVM_PPC_ALLOCATE_HTAB, &shift);
         if (ret == -ENOTTY) {
@@ -2484,7 +2484,7 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
     cap_ppc_safe_bounds_check = 0;
     cap_ppc_safe_indirect_branch = 0;
 
-    ret = kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR);
+    ret = kvm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR);
     if (!ret) {
         return;
     }
-- 
2.40.0

