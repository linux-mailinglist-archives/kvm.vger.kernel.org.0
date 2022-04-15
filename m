Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C12502FA5
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351153AbiDOUSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351314AbiDOUSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:23 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7DF3B287
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:53 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id h1-20020a056e021b8100b002cbec2c4261so2642112ili.16
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TP+Vw2YmOyLMd/0Sd7/tEhTMR//dkU6blEXQoP9cxUM=;
        b=fom0iclVJ707UMdJtlbHG3VB4+v16ns5IL6h+9f1nm/Tm5tNfdaRwcdxTUphO4o00/
         K4BcufuuO7NAdrk7BVvEgq1JG/Yk7lJT1x+z+0VxL0wYp++6C8iX4YASCruPmLQUJO77
         63E2xE/paqGMpfImD7Wofj5Frq92t+DRdR7a1Gw8OIEHI5YaxzT+U5n0lmR0M3BEldwb
         yBh8Jm+sLIsaExIOezOQSDcyT5/mI+SlxXUVcujdALzvwa38mUR5LSxRi3s5+SE7+171
         R2ZzpyTG7o9JzBNvhlZRLVl+Ih4o50be6U83qHi8bLdJ16LC1p11VDmJ9whPHnq/FIrf
         TsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TP+Vw2YmOyLMd/0Sd7/tEhTMR//dkU6blEXQoP9cxUM=;
        b=JENWx6FWnk/rNzEUyRzuYX0GGQUo8u2viRDOT8QUSnObnHSYdBlLHscObVctSx4iPM
         fNC203fESpkXKO1gQCr1uFzWx+H1sAVhLEW2d/E5FLvS/gxP6UyJGyDfDQBd1de6KSs1
         Rbvl9vR575VOAiMRWgNaT8ldZ/+SiQtR78W+RAxp5Z65bNjdNpQHSmRh0AAD/3lNViwM
         Mhh+q3XpnCBl4zDO5yVA/YPRnPydbYiMmZ944sb/t2H+KTOMIT/BiCRSWt9ZIt4Tzbs7
         fYmtdieQwVe9U7O1bA/GtUFrkKNP5a4L5YJMLVZQWmMPp9p6is1C/y+ejZfVzW+8f1hL
         KmVw==
X-Gm-Message-State: AOAM5318735cvwA8crKyWBpI7fLDYiR8Zlx1+5csJYmktN5l9dTOZlVw
        b8xmzylAf+nty0PqbMpfMqbMv/ADnenyk5tlEUeSchouhxMqp2z5pCF9cagcAFOxKMFfQIp7LSg
        f5Xmh8RJsOZw3cN2jJUGIORutfCP3CAuJOKXb6XbhqVS6QJgSoTAzcP1Hqw==
X-Google-Smtp-Source: ABdhPJxSjjZ2alPFCRYbFvOAZLQqJNDqV9QtONmMd0c5KpJXRj8/jvnflAIZTQZYKnr+LN2LzqIt2l1ZLeY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:130b:0:b0:2c5:66a6:cad8 with SMTP id
 11-20020a92130b000000b002c566a6cad8mr180991ilt.285.1650053752602; Fri, 15 Apr
 2022 13:15:52 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:41 +0000
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
Message-Id: <20220415201542.1496582-5-oupton@google.com>
Mime-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 4/5] KVM: Actually create debugfs in kvm_create_vm()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 virt/kvm/kvm_main.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1abbc6b07c19..54793de42d14 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -951,7 +951,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
-	int i, ret;
+	int i, ret = -ENOMEM;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
@@ -980,13 +980,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
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
@@ -1001,7 +1001,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 		pdesc = &kvm_vcpu_stats_desc[i];
 		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
 		if (!stat_data)
-			return -ENOMEM;
+			goto out_err;
 
 		stat_data->kvm = kvm;
 		stat_data->desc = pdesc;
@@ -1013,12 +1013,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
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
@@ -1049,7 +1050,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	return 0;
 }
 
-static struct kvm *kvm_create_vm(unsigned long type)
+static struct kvm *kvm_create_vm(unsigned long type, int fd)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	struct kvm_memslots *slots;
@@ -1134,7 +1135,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_arch_post_init_vm(kvm);
 	if (r)
-		goto out_err;
+		goto out_err_mmu_notifier;
 
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -1150,12 +1151,18 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	 */
 	if (!try_module_get(kvm_chardev_ops.owner)) {
 		r = -ENODEV;
-		goto out_err;
+		goto out_err_mmu_notifier;
 	}
 
+	r = kvm_create_vm_debugfs(kvm, fd);
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
@@ -4760,7 +4767,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (fd < 0)
 		return fd;
 
-	kvm = kvm_create_vm(type);
+	kvm = kvm_create_vm(type, fd);
 	if (IS_ERR(kvm)) {
 		r = PTR_ERR(kvm);
 		goto put_fd;
@@ -4777,17 +4784,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 		goto put_kvm;
 	}
 
-	/*
-	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
-	 * already set, with ->release() being kvm_vm_release().  In error
-	 * cases it will be called by the final fput(file) and will take
-	 * care of doing kvm_put_kvm(kvm).
-	 */
-	if (kvm_create_vm_debugfs(kvm, r) < 0) {
-		fput(file);
-		r = -ENOMEM;
-		goto put_fd;
-	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
 	fd_install(fd, file);
-- 
2.36.0.rc0.470.gd361397f0d-goog

