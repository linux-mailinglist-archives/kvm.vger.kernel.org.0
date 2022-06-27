Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABCF55CC8F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbiF0V4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbiF0Vz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20D65B4;
        Mon, 27 Jun 2022 14:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366899; x=1687902899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Xl4GSkEm1UhNCYDSsYhWJHWueUQ4Wh6xbEP4MdBrPE=;
  b=l1kaVmXCUs9/9mCreOdioC0HSRUJ/FPgxgBlAH0HKtBNB2chQxdZM3Q6
   liRimcYP8VnCzdsTIiPA3jpIWORCoUXeDNfCOxfkg5eNxrSCU4PVp2Oxj
   /bZ2yVPJ5GTeBvUgqLjmQcxk2Ka4Qv1lRXRKWFAUd23tfPuH3lB0fK0lc
   R+GgzAdTnVpWdgSKwcrQ2BtA7FeBZDSO9MyoN/u6/Qjq4VvL33Et1JIIj
   e1FMz2YhKSyvokVtRmbt6XoqkwJBQPhQP3V1rkTrvbDSfz71bhX7sApjX
   v/p0yIufGeqTQpH+YHS27Aa8qVwJcABSdVQBy7DtF8WI4zQX6oedoYpG9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609571"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609571"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863591"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 048/102] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Mon, 27 Jun 2022 14:53:40 -0700
Message-Id: <eb806a989cd77021f38bb83fdb8c081d1379c9e5.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX doesn't support dirty logging.  Report dirty logging isn't supported so
that device model, for example qemu, can properly handle it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  5 +++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 15 ++++++++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4309ef0ade21..dcd1f5e2ba05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13164,6 +13164,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type != KVM_X86_TDX_VM;
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a4988fd51f..6fd8ec297236 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1452,6 +1452,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7a5261eb7eb8..703c1d0c98da 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1467,9 +1467,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
 	}
 }
 
-static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
+bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	return true;
+}
+
+static int check_memory_region_flags(struct kvm *kvm,
+				     const struct kvm_userspace_memory_region *mem)
+{
+	u32 valid_flags = 0;
+
+	if (kvm_arch_dirty_log_supported(kvm))
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 #ifdef __KVM_HAVE_READONLY_MEM
 	valid_flags |= KVM_MEM_READONLY;
@@ -1871,7 +1880,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
-	r = check_memory_region_flags(mem);
+	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
 
-- 
2.25.1

