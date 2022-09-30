Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DBF5F08B7
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiI3KWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiI3KTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541371E277F;
        Fri, 30 Sep 2022 03:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533148; x=1696069148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5DLqEFdfqIeSaEHQvz+gl/qfG8aUT9uYuqDM4eiTlLk=;
  b=b7035/QRN1Nm0r1t9AnNJvo0tVzxZU5VyXE97uUWExOlykJOv/eVyyia
   XJYRTPfIvXlLkkO8ONQVRP2vRCRDARpre5P5t1nKkp2Omev79occ7vzDt
   yaE3WztAU0IsaYXhzTFSmTKdh7CBxuWZO37oG7NI6X+yb12ftbwaOEPa6
   TM2Rh1nz7aVAlcBsOBoeafgLWqasDHXlteEZTNUxI767QM2rWSuM7jT1O
   93zGrZV2b4eQSLMvUbEsF2T1CZ1IMZ1Oc0u4kQx1dtFKCTN/gjON83z3U
   qb48AxxAxRkZkG7IZpMkaqwhHsoj0Xji86k/CD5hetR+I7rt3u6Lechlp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870108"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870108"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807655"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807655"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 048/105] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Fri, 30 Sep 2022 03:17:42 -0700
Message-Id: <0dc5022c7e7c5f55f3ed490acfc855776fa662b2.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 5006ff5d9f5e..c8b129cb772e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13588,6 +13588,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
index f5df5f97b477..eca3ca116412 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1477,6 +1477,7 @@ int kvm_arch_del_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 bool kvm_arch_has_private_mem(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 263885cd97c1..0dbd1734a246 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1654,10 +1654,18 @@ bool __weak kvm_arch_has_private_mem(struct kvm *kvm)
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
 
 #ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
 	if (kvm_arch_has_private_mem(kvm))
-- 
2.25.1

