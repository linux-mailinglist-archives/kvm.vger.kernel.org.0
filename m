Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A4A5E6A9A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiIVSVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiIVSVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9227910AB28;
        Thu, 22 Sep 2022 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870886; x=1695406886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GoKHDbGSJCgFZPsDUaLsLiErz0a2t6BkzruRG0eeWc=;
  b=LhQl73/wWhsg06MUqd/9wDNzWGsiRRwUyMNJ3U2wXiNjiPKkAgeFhbKX
   DOo+uRE7BYbLxDhnqFDrJNkPNnilsuIyFa0RyfkPo9WIxhe99tYdcIL1w
   kuGx/qAYu7KoIrfduESyVTjC8XMS49Q2bHNQA7yYfEyjdB/t1FtD85cNA
   Kg+nuuuREqVWYijDe8EsjF6Bi2NGgO0ONb9EL8vYlcVSJtN9Zv8b3MP8r
   ntV9dYeWbvyYjZ0D0yCM5jcxoVzdWrHrZXjXONLrKyAgHRFoRZB/NbUPN
   +pfQHyBvXFVRxq39s83ely0pgYT4RR7Ow+5V148Ic4b9gAK/QQeJvNPua
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675987"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675987"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086722"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:18 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 11/30] KVM: Add arch hook for reboot event
Date:   Thu, 22 Sep 2022 11:20:40 -0700
Message-Id: <61dcd6722743bf221f6c612e120a9e2350d5a72f.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
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

Factor out the logic on reboot event as arch hook.  Later kvm/x86 overrides
it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3fbb01bbac98..084ee8a13e9f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,6 +1434,8 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
+int kvm_arch_reboot(int val);
+
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e2c8823786ff..58385000b73f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1142,6 +1142,12 @@ int __weak kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
+int __weak kvm_arch_reboot(int val)
+{
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	return NOTIFY_OK;
+}
+
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -5135,6 +5141,8 @@ static void kvm_del_vm(void)
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
+	int r;
+
 	/*
 	 * Some (well, at least mine) BIOSes hang on reboot if
 	 * in vmx root mode.
@@ -5143,8 +5151,14 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return NOTIFY_OK;
+
+	/* This hook is called without cpuhotplug disabled.  */
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
+	r = kvm_arch_reboot(val);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
+	return r;
 }
 
 static struct notifier_block kvm_reboot_notifier = {
-- 
2.25.1

