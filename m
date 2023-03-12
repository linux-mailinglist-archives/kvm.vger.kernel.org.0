Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501E26B6485
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCLJ7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCLJ6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1504FF0A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615065; x=1710151065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=slVPLvKC8AM8OoFImglfcIlUdtipykfchewhuHyr1w0=;
  b=S7wu+GwWrik4y2rgtQFpzztmghSKE03V+fepxWVfJcJGHU6EnGWGnDzl
   NZWUAb2TVuVHS6GWtFLQHtZAbVNBNQEdtG+BLtvyMS0XTQfNLX7TYz/6o
   IHzQL1SyBjev81hGNXnA0nbXcHilOaN5yTxkboihSqDeCsRdKHo/NDUba
   /ahnVFLkFzRGo2+h+Zl649P3dMFwP9nBcQrfhhnic+1lTTsnwPkd6au6H
   zLqiBeFFRzarnA33QChBNUILt+fpMh7ydWiqsJeIUPo+EWnvY1yK0Z9Rn
   OpfUgfeh9k4Szml6hdfFhmTSgyJHwjNrDsP5dMIKr6Jc7apz5qgrMFUBj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998108"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998108"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677696"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677696"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:17 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 08/22] pkvm: x86: Add hash table mapping for shadow vcpu based on vmcs12_pa
Date:   Mon, 13 Mar 2023 02:02:49 +0800
Message-Id: <20230312180303.1778492-9-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host VM execute vmptrld(vmcs12) then vmlaunch to launch its guest, while
pKVM need to get corresponding shadow_vcpu_state based on vmcs12 to do
vmptrld emulation (real vmcs page of guest - vmcs02 shall be kept in
shadow_vcpu_state - it will be added in the following patches).

Take use of hash table shadow_vcpu_table to build the mapping between
vmcs12_pa and shadow_vcpu_state. Then pKVM is able to quick find out
shadow_vcpu_state from vmcs12_pa when emulating vmptrld.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c     | 47 +++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |  4 +++
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index b110ac43a792..9efedba2b3c9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2022 Intel Corporation
  */
 
+#include <linux/hashtable.h>
 #include <pkvm.h>
 
 #include "pkvm_hyp.h"
@@ -26,6 +27,10 @@ static struct shadow_vm_ref shadow_vms_ref[MAX_SHADOW_VMS];
 #define SHADOW_VCPU_ARRAY(vm) \
 	((struct shadow_vcpu_array *)((void *)(vm) + sizeof(struct pkvm_shadow_vm)))
 
+#define SHADOW_VCPU_HASH_BITS		10
+DEFINE_HASHTABLE(shadow_vcpu_table, SHADOW_VCPU_HASH_BITS);
+static pkvm_spinlock_t shadow_vcpu_table_lock = __PKVM_SPINLOCK_UNLOCKED;
+
 static int allocate_shadow_vm_handle(struct pkvm_shadow_vm *vm)
 {
 	struct shadow_vm_ref *vm_ref;
@@ -133,6 +138,37 @@ static void put_shadow_vm(int shadow_vm_handle)
 	WARN_ON(atomic_dec_if_positive(&vm_ref->refcount) <= 0);
 }
 
+static void add_shadow_vcpu_vmcs12_map(struct shadow_vcpu_state *vcpu)
+{
+	pkvm_spin_lock(&shadow_vcpu_table_lock);
+	hash_add(shadow_vcpu_table, &vcpu->hnode, vcpu->vmcs12_pa);
+	pkvm_spin_unlock(&shadow_vcpu_table_lock);
+}
+
+static void remove_shadow_vcpu_vmcs12_map(struct shadow_vcpu_state *vcpu)
+{
+	pkvm_spin_lock(&shadow_vcpu_table_lock);
+	hash_del(&vcpu->hnode);
+	pkvm_spin_unlock(&shadow_vcpu_table_lock);
+}
+
+s64 find_shadow_vcpu_handle_by_vmcs(unsigned long vmcs12_pa)
+{
+	struct shadow_vcpu_state *shadow_vcpu;
+	s64 handle = -1;
+
+	pkvm_spin_lock(&shadow_vcpu_table_lock);
+	hash_for_each_possible(shadow_vcpu_table, shadow_vcpu, hnode, vmcs12_pa) {
+		if (shadow_vcpu->vmcs12_pa == vmcs12_pa) {
+			handle = shadow_vcpu->shadow_vcpu_handle;
+			break;
+		}
+	}
+	pkvm_spin_unlock(&shadow_vcpu_table_lock);
+
+	return handle;
+}
+
 struct shadow_vcpu_state *get_shadow_vcpu(s64 shadow_vcpu_handle)
 {
 	int shadow_vm_handle = to_shadow_vm_handle(shadow_vcpu_handle);
@@ -197,6 +233,8 @@ static s64 attach_shadow_vcpu_to_vm(struct pkvm_shadow_vm *vm,
 	if (!shadow_vcpu->vm)
 		return -EINVAL;
 
+	add_shadow_vcpu_vmcs12_map(shadow_vcpu);
+
 	pkvm_spin_lock(&vm->lock);
 
 	if (vm->created_vcpus == KVM_MAX_VCPUS) {
@@ -241,12 +279,14 @@ detach_shadow_vcpu_from_vm(struct pkvm_shadow_vm *vm, s64 shadow_vcpu_handle)
 
 	pkvm_spin_unlock(&vm->lock);
 
-	if (shadow_vcpu)
+	if (shadow_vcpu) {
+		remove_shadow_vcpu_vmcs12_map(shadow_vcpu);
 		/*
 		 * Paired with the get_shadow_vm when saving the shadow_vm pointer
 		 * during attaching shadow_vcpu.
 		 */
 		put_shadow_vm(shadow_vcpu->vm->shadow_vm_handle);
+	}
 
 	return shadow_vcpu;
 }
@@ -258,6 +298,7 @@ s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
 	struct pkvm_shadow_vm *vm;
 	struct shadow_vcpu_state *shadow_vcpu;
 	struct x86_exception e;
+	unsigned long vmcs12_va;
 	s64 shadow_vcpu_handle;
 	int ret;
 
@@ -273,6 +314,10 @@ s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
 	if (ret < 0)
 		return -EINVAL;
 
+	vmcs12_va = (unsigned long)shadow_vcpu->vmx.vmcs01.vmcs;
+	if (gva2gpa(hvcpu, vmcs12_va, (gpa_t *)&shadow_vcpu->vmcs12_pa, 0, &e))
+		return -EINVAL;
+
 	vm = get_shadow_vm(shadow_vm_handle);
 	if (!vm)
 		return -EINVAL;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index f15a49b3be5d..c574831c6d18 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -21,6 +21,9 @@ struct shadow_vcpu_state {
 
 	struct pkvm_shadow_vm *vm;
 
+	struct hlist_node hnode;
+	unsigned long vmcs12_pa;
+
 	struct vcpu_vmx vmx;
 } __aligned(PAGE_SIZE);
 
@@ -74,6 +77,7 @@ s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
 unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle);
 struct shadow_vcpu_state *get_shadow_vcpu(s64 shadow_vcpu_handle);
 void put_shadow_vcpu(s64 shadow_vcpu_handle);
+s64 find_shadow_vcpu_handle_by_vmcs(unsigned long vmcs12_pa);
 
 extern struct pkvm_hyp *pkvm_hyp;
 
-- 
2.25.1

