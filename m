Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6557B3BE
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbiGTJXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiGTJXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:33 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E12474D3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:32 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPC65f+/SpKvE1qabwWtUjvFps/u8ooCGD/VYWnw8co=;
        b=I/71aFwYyNmnMBIh+PDUiVtVlTAnj7MQecccPvdHsgM1u81u0LbwnsLiOARWufwAdTFwmH
        ejF+sNZ65HjDRWGVWUtgnO0hesimHZYLJqCvzNErJhpjDbvysbFtt+hRFDkkOJW5MkZ2ud
        OlJM8Bfxc/PQyIyhZEqU62iuq7k9vbM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 5/6] KVM: Actually create debugfs in kvm_create_vm()
Date:   Wed, 20 Jul 2022 09:22:51 +0000
Message-Id: <20220720092259.3491733-6-oliver.upton@linux.dev>
In-Reply-To: <20220720092259.3491733-1-oliver.upton@linux.dev>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

Doing debugfs creation after vm creation leaves things in a
quasi-initialized state for a while. This is further complicated by the
fact that we tear down debugfs from kvm_destroy_vm(). Align debugfs and
stats init/destroy with the vm init/destroy pattern to avoid any
headaches.

Note the fix for a benign mistake in error handling for calls to
kvm_arch_create_vm_debugfs() rolled in. Since all implementations of
the function return 0 unconditionally it isn't actually a bug at
the moment.

Lastly, tear down debugfs/stats data in the kvm_create_vm_debugfs()
error path. Previously it was safe to assume that kvm_destroy_vm() would
take out the garbage, that is no longer the case.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1e7f780a357b..609f49a133f8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1028,7 +1028,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
-	int i, ret;
+	int i, ret = -ENOMEM;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
@@ -1054,13 +1054,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 					 sizeof(*kvm->debugfs_stat_data),
 					 GFP_KERNEL_ACCOUNT);
 	if (!kvm->debugfs_stat_data)
-		return -ENOMEM;
+		goto out_err;
 
 	for (i = 0; i < kvm_vm_stats_header.num_desc; ++i) {
 		pdesc = &kvm_vm_stats_desc[i];
 		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
 		if (!stat_data)
-			return -ENOMEM;
+			goto out_err;
 
 		stat_data->kvm = kvm;
 		stat_data->desc = pdesc;
@@ -1075,7 +1075,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 		pdesc = &kvm_vcpu_stats_desc[i];
 		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
 		if (!stat_data)
-			return -ENOMEM;
+			goto out_err;
 
 		stat_data->kvm = kvm;
 		stat_data->desc = pdesc;
@@ -1087,12 +1087,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	}
 
 	ret = kvm_arch_create_vm_debugfs(kvm);
-	if (ret) {
-		kvm_destroy_vm_debugfs(kvm);
-		return i;
-	}
+	if (ret)
+		goto out_err;
 
 	return 0;
+out_err:
+	kvm_destroy_vm_debugfs(kvm);
+	return ret;
 }
 
 /*
@@ -1123,7 +1124,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	return 0;
 }
 
-static struct kvm *kvm_create_vm(unsigned long type)
+static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	struct kvm_memslots *slots;
@@ -1212,7 +1213,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_arch_post_init_vm(kvm);
 	if (r)
-		goto out_err;
+		goto out_err_mmu_notifier;
 
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -1228,12 +1229,18 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	 */
 	if (!try_module_get(kvm_chardev_ops.owner)) {
 		r = -ENODEV;
-		goto out_err;
+		goto out_err_mmu_notifier;
 	}
 
+	r = kvm_create_vm_debugfs(kvm, fdname);
+	if (r)
+		goto out_err;
+
 	return kvm;
 
 out_err:
+	module_put(kvm_chardev_ops.owner);
+out_err_mmu_notifier:
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	if (kvm->mmu_notifier.ops)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
@@ -4900,7 +4907,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 
 	snprintf(fdname, sizeof(fdname), "%d", fd);
 
-	kvm = kvm_create_vm(type);
+	kvm = kvm_create_vm(type, fdname);
 	if (IS_ERR(kvm)) {
 		r = PTR_ERR(kvm);
 		goto put_fd;
@@ -4923,11 +4930,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * cases it will be called by the final fput(file) and will take
 	 * care of doing kvm_put_kvm(kvm).
 	 */
-	if (kvm_create_vm_debugfs(kvm, fdname) < 0) {
-		fput(file);
-		r = -ENOMEM;
-		goto put_fd;
-	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
 	fd_install(fd, file);
-- 
2.37.0.170.g444d1eabd0-goog

