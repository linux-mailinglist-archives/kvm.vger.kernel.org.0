Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB458BD9F
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242033AbiHGWIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiHGWHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79733BC04;
        Sun,  7 Aug 2022 15:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909795; x=1691445795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eMuxnVZWvb8JA13vz4K/7auQXS6AE18TTeNRdKOvB6E=;
  b=C4ogyc+DYwuzyV29kPio1pVf5SunGzqYnQpROSvWallJpagRzw8GvvaD
   Y1srn5Z2dpWlEwCxxW4awew0AygZN4brFkq70TvZ6lZVen5br4WrDFYq7
   sYXCaITdGixxiMXY7UdL7LiUUo8RLDWV6ReUVkAx4oFDFG93dPV7vJoz8
   yVokBh9DGsiZfFs55/+VAOUWs81yWEzCceWL9XsptdBvk0IHX0kBRXn11
   QPZjg6OF7W1EtwUua2Xeb0wpv9MBE6pRf/zk/vh5gRca/lDldnUjmRFsE
   NPYP/8sJYegeIYU6ftHFItxzG7G42ER3umJdM2uM1WDKjW/tJNVeNQVL7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224140"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224140"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682591"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 046/103] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Sun,  7 Aug 2022 15:01:31 -0700
Message-Id: <e44af3e75cde88c828bce875062dee7ab82960a6.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 virt/kvm/kvm_main.c      | 15 ++++++++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 702012f56502..972262ddda5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13356,6 +13356,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
index 63d4e3ce3e53..025251806e70 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1448,6 +1448,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c44e5d7d418f..3cc29fdba562 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1511,9 +1511,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
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
@@ -1915,7 +1924,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
-	r = check_memory_region_flags(mem);
+	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
 
-- 
2.25.1

