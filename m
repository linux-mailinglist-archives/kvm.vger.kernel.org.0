Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C36F5B2A3C
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiIHX0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiIHX03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA2AF1F15;
        Thu,  8 Sep 2022 16:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679572; x=1694215572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zkkuRo7b1Y9KCKWZAKJpBJHGXbxql5InDVr+q8N93Wk=;
  b=ImxduLUmlX1+X6DMEu7wswtJHV66xbSvgcAcX9FwWAi8ekyt13eo8toR
   Pjj6XSNl69Xl+0rBmCSCMpjKLngN4U4UwcqWKfRCcdkq3Gqk+T8guZvMg
   vd1Yfq10fCrnC7Y0txDlRGpa87Vele+FIL0yH7GyIY9mt9P1Stco6YSnW
   6V5P2QxAOFBG3uHChfTN43ZEWZ4xigtQEBXAVXi4fWlc6NbTixT6yTWh8
   Wt223WilOP9T8pp36GEb/VbB+55r+liYH62hwhfiewl1Gew+KyOAOqFAJ
   QkvedRdwF2cnN/xFYE2zUOUyVGrgn1lWtJjvm/bnN647DRDhtsTo4nLTR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687009"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687009"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863217"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:09 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 13/26] KVM: Add arch hook when VM is added/deleted
Date:   Thu,  8 Sep 2022 16:25:29 -0700
Message-Id: <acc9a44a5626fa8d64690f3f6fcca6e85f6536cb.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

and pass kvm_usage_count with kvm_lock.  Move kvm_arch_post_init_vm() under
kvm_arch_add_vm().  Later kvm_arch_post_init_vm() is deleted once x86
overrides kvm_arch_add_vm().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_arch.c      | 12 +++++++++++-
 virt/kvm/kvm_main.c      | 21 +++++++++++++++++----
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dd2a6d98d4de..f78364e01ca9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1445,6 +1445,8 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
+int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
+int kvm_arch_del_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 4748a76bcb03..0eac996f4981 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -10,11 +10,21 @@
 
 #include <linux/kvm_host.h>
 
+__weak int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return 0;
+}
+
 /*
  * Called after the VM is otherwise initialized, but just before adding it to
  * the vm_list.
  */
-__weak int kvm_arch_post_init_vm(struct kvm *kvm)
+__weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
+{
+	return kvm_arch_post_init_vm(kvm);
+}
+
+__weak int kvm_arch_del_vm(int usage_count)
 {
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 951f853f6ac9..7acc35e279ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -145,6 +145,7 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 static int hardware_enable_all(void);
 static void hardware_disable_all(void);
 static void hardware_disable_nolock(void *junk);
+static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1215,11 +1216,12 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
 
-	r = kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err;
-
 	mutex_lock(&kvm_lock);
+	r = kvm_arch_add_vm(kvm, kvm_usage_count);
+	if (r) {
+		mutex_unlock(&kvm_lock);
+		goto out_err;
+	}
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
 
@@ -1239,6 +1241,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 #endif
 out_err_no_mmu_notifier:
 	hardware_disable_all();
+	kvm_del_vm();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1319,6 +1322,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
 	hardware_disable_all();
+	kvm_del_vm();
 	mmdrop(mm);
 	module_put(kvm_chardev_ops.owner);
 }
@@ -5096,6 +5100,15 @@ static void hardware_disable_all(void)
 	cpus_read_unlock();
 }
 
+static void kvm_del_vm(void)
+{
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
+	kvm_arch_del_vm(kvm_usage_count);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
+}
+
 static int hardware_enable_all(void)
 {
 	int r = 0;
-- 
2.25.1

