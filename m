Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E007667B83
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjALQnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240210AbjALQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B718E2E;
        Thu, 12 Jan 2023 08:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541243; x=1705077243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EmTv5XiJwZuMygaDWk3VHaVPEXVos26L4MeM0btkIs0=;
  b=iGT90T0yxXuB48HWoJY9wF5QW1IS393FdtUdu0+7STxy1/vu1hc2rVkw
   +OGhMN4dM8wBMySngPER29O+rqp7KIA0Ji2Tg6ZBM8Bom9PGTZYiWT/2z
   3Am6emRZ/G/I03ji4e7Ddg2aZhdqVhcEc6X0Ea+N0sqE9+XlR6FhyF82H
   e6SJXTSR+/taAw0OlO0eJsocrFXBD/60VmLotzTSvgQWbWNpAVcx/f9uJ
   Kt9uo2nBrUtpXM5MNAXD/WgkICWz9EwLJp3JTvWXINJfsxbzjl8IKYN0s
   kwKVOEDj3Q/VI9EAtOtU2UZjz31zSN0n3t7Ml+nxPd8KlVf4pSnuKfjQl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811886"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811886"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151801"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151801"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 048/113] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Thu, 12 Jan 2023 08:31:56 -0800
Message-Id: <6480f2d4cccf6408f24d6f7d73927e092d8186e3.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a8b555935fd8..5b4d5f8128a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13498,6 +13498,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
index 0c3b9cf0a731..d6e4da96130f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1476,6 +1476,7 @@ int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 bool kvm_arch_has_private_mem(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db04c57acf77..251bb7c59c88 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1664,10 +1664,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
 	}
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
 
 	if (kvm_arch_has_private_mem(kvm))
 		valid_flags |= KVM_MEM_PRIVATE;
-- 
2.25.1

