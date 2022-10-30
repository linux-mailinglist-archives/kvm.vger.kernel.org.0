Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ECF6127F2
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJ3GZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJ3GY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3739188;
        Sat, 29 Oct 2022 23:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111051; x=1698647051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8q0Zi89k4Pljz6j6YFmcZyhYRvEh99WoaA0AWQJmknA=;
  b=XtcnInG+kF2woEhjxgCvQ4kqmAk0Z9Ro3cUatmdo9CMSzTABTrXkzD4X
   m7Zpmdp9EmDitb+D8MDhHh6DumjYv767b3oS+uHw/s51cgPSd2p9wzEaB
   cvkfLBYIQ++8IJqKOp40iHvPgntqotbVAqiFOQYmYmBIgkgWn8/Afmg7F
   gH7K0dgpPkvn5VmqJ9OGLtjwR1a0mhx7fP0eoELzbjGBJixzgZJ0cMXuN
   Ld4p25gvYLKBES/OxQEnRRXQx4rGJbeXE9LD3B+iz9ZKg+2+8IAQ+Uwmx
   sC6agb6rsaEKquQTDTufPMgbJMFgUrnr6zJCgdfpuELVVhkP4ZQTUT70j
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037163"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037163"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393010"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393010"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:05 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v10 051/108] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Sat, 29 Oct 2022 23:22:52 -0700
Message-Id: <4873c5af293116df92eb8da5e1ba4e76df081682.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't support dirty logging.  Report dirty logging isn't supported so
that device model, for example qemu, can properly handle it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  5 +++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 +++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba4a9ce0ee80..24d9bfd4c582 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13862,6 +13862,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type != KVM_X86_TDX_VM;
+}
+
 bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b658803ea2c7..a0b64308d240 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1477,6 +1477,7 @@ int kvm_arch_drop_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 bool kvm_arch_has_private_mem(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c996f40b544..9f82b03a8118 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1869,10 +1869,18 @@ bool __weak kvm_arch_has_private_mem(struct kvm *kvm)
 	return false;
 }
 
+bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return true;
+}
+
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_user_mem_region *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = 0;
+
+	if (kvm_arch_dirty_log_supported(kvm))
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
 	if (kvm_arch_has_private_mem(kvm))
-- 
2.25.1

