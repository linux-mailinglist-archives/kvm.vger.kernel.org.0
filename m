Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849604CDDEE
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiCDUGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiCDUG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18955291CE3;
        Fri,  4 Mar 2022 12:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424099; x=1677960099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bqNrTmx/pGbILehdDfcJ8UEk7uMEWH3fJAQefvphR38=;
  b=IWwKTYQT6W6RmSlX6h9GFqxSlYlGHvV2U8Trss8hKk2LWrNCn6mo7QXv
   /pyvC+tltBi8iGAol7t3CWSW5xqeTrlWLYyj4gSpNRGDSjQFUv61ngVFl
   N8EgIYJLxbgpLy1G/laD0K4j8P6x2Z7YOnbFuczXg3hrVWvqJup3Mfe1c
   /vH8+y0lCyqxfIsXd1q+l6VFMQX7eHbAdojh6uUUbhgPng5sdL66qmT6e
   V5rOd5FKIz3E+khLb6iy9rIYgHkHhoypF86fQ90W28WoqJHZlJ0N3zLmF
   7wECsGnuSPL4ns5BtVmiQaJGYW6Y1Pcy2HrtGCBVGNFbFEFvcEAbaHGfZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983381"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983381"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:13 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344231"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:12 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 021/104] KVM: x86: Introduce hooks to free VM callback prezap and vm_free
Date:   Fri,  4 Mar 2022 11:48:37 -0800
Message-Id: <af18a5c763a78af2b7de6e6e0841d9e61a571dc4.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@intel.com>

Before tearing down private page tables, TDX requires some resources of the
guest TD to be destroyed (i.e. keyID must have been reclaimed, etc).  Add
prezap callback before tearing down private page tables for it.

TDX needs to free some resources after other resources (i.e. vcpu related
resources).  Add vm_free callback at the end of kvm_arch_destroy_vm().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 ++
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/x86.c                 | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8125d43d3566..ef48dcc98cfc 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,7 +20,9 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
+KVM_X86_OP_NULL(mmu_prezap)
 KVM_X86_OP_NULL(vm_destroy)
+KVM_X86_OP_NULL(vm_free)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8de357a9ad30..5ff7a0fba311 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1326,7 +1326,9 @@ struct kvm_x86_ops {
 	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
+	void (*mmu_prezap)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
+	void (*vm_free)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
 	int (*vcpu_create)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6438750d190..a48f5c69fadb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11779,6 +11779,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_free)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
@@ -12036,6 +12037,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	/*
+	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
+	 * tearing down private page tables, TDX requires some TD resources to
+	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
+	 * kvm_x86_mmu_prezap() for this.
+	 */
+	static_call_cond(kvm_x86_mmu_prezap)(kvm);
 	kvm_mmu_zap_all(kvm);
 }
 
-- 
2.25.1

