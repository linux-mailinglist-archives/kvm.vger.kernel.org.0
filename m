Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5632F59AB9F
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245002AbiHTGBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiHTGAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B26A2628;
        Fri, 19 Aug 2022 23:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975250; x=1692511250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tr3yA3TW4wQhy3y6XXgJ33VEExdUImA9iqqmlfQuqZk=;
  b=MguFDtAoF5mgYdt08wAuTqFALgCIMUvbKPa+KP5emjVHtzaBqDHbrIPl
   HGrg+9yekHSbELGsu08YTUY/gK/AecWZ3o0ZqdKIZO74VuArW9CFBBJJ2
   3JhLZe+lL0KA7wE9g4MCn6kPZRqofIvjpBnYr4BxaRpYeRkisSydG8TOi
   UQ3MmyldxmsN3gfZjHpnKjTP4tYIkmQ8WkjXrhjmDoZ2mJQxKZPPfOR+R
   eV0Dkdz0PwCrCaK/ViA+TYOwqRXUHzukuFrLetf24tXR116qAZPj6UZcM
   xPb7MgqkiJSo19AzJAZfWidxhQp/unMDNP/mq4TGuzHy4qRJH5JKPzUyf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448972"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448972"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857527"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 06/18] KVM: Add arch hook when VM is added/deleted
Date:   Fri, 19 Aug 2022 23:00:12 -0700
Message-Id: <ccbd4117278ae973617918f4adb029d648deb8f3.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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
index c38f382f3808..5ae66062620c 100644
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
index 8d08126e6c74..0ba370acff8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -144,6 +144,7 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #endif
 static int hardware_enable_all(void);
 static void hardware_disable_all(void);
+static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1201,11 +1202,12 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_mmu_notifier;
 
-	r = kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err_mmu_notifier;
-
 	mutex_lock(&kvm_lock);
+	r = kvm_arch_add_vm(kvm, kvm_usage_count);
+	if (r) {
+		mutex_unlock(&kvm_lock);
+		goto out_err_mmu_notifier;
+	}
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
 
@@ -1237,6 +1239,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 #endif
 out_err_no_mmu_notifier:
 	hardware_disable_all();
+	kvm_del_vm();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1316,6 +1319,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
 	hardware_disable_all();
+	kvm_del_vm();
 	mmdrop(mm);
 	module_put(kvm_chardev_ops.owner);
 }
@@ -5055,6 +5059,15 @@ static void hardware_disable_all(void)
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

