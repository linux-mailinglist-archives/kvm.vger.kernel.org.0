Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8843B52C1D2
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbiERR7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241263AbiERR7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:17 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AE8CB3E
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z1-20020a170902ee0100b00161cf3e64c4so592643plb.11
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QhLBePrrsUfJqUjAdy8m5ffbR0ZWKR+39fgcfWSusVo=;
        b=M1C+Zm9YUdMgkVq8XYmwYRC/KYqLg/NSip/HcNoOJY1mDd5E2Jy8OI7YZq2oDN/+E1
         zIaq/Y2usPhok+ry9KUReOq2l6U9UEwcQZv4Vsxy/96n/5JuS7zq+DwXH0tdwVEkFvoM
         o4RjLgi0hzah9zAMybpZHDzc3/RCmQleOfpe8WymoN3YZk9lLikWwQi6L3hlq8i3/pNZ
         2pHx/VO3hyKIKxkG3Hwz0lfWh16djOs/FiDEEkFncRzI4c2eHmAj2JnhUBtXr3ThlPvl
         6XZrYi9hBBEXn8ergX/MD3mzshT5mymTVLRYZHdWKduiTpnuhWaIkFvTIBNIaUizt0So
         k1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QhLBePrrsUfJqUjAdy8m5ffbR0ZWKR+39fgcfWSusVo=;
        b=px9Y7gumpJGgSQy26f9rRu9ngqk8NlvEgRCfOaRxs2nCAX4lyRbHwpxuI/tcJGVr5g
         /I7f5o7Fnubg7cENObqjCncD2/A02mMzYknkC7MBaVp2hinB9iXu+WWpR3mxzOYtY/M1
         S6Nw79DIiNM5WMU+y8UUPsqh/rjEFgcqdYqDkJUBkqGJamKaiT8pLA6T/VHsRNLDbW9D
         N9eHWyzdT+Un8J1xpytw/6uG9nvtEgV5wZgETsyF5LVtZa3WaoloNJcrShU8fJrLCH7q
         zn/MUqRY6f0+ibPH4nV3xDhKJVf10ng8O31JvdrWd/LQfZBUXLVoPuVcQQY8BIQvZiFY
         hSdw==
X-Gm-Message-State: AOAM530A5OVH30QkqoD+7IkLkKccquFs6TT7oPo8JeAxmVylIEcTs2ud
        Ar1oQ1tuxiq+gbZAdbC5NCLSiI3mVTtu9C6MKCyv0TTfaEjgOPj3kxX7uj+3kl8VA9D8NwWBvNP
        ZlEmB6QBR+nfS/SlsKZnvFQCped+fuGi77YELc0eMPntRQjNhQla/kulk3g==
X-Google-Smtp-Source: ABdhPJyftOKTs4TW1CVxNNaLvjfHTVmTnPth5OjQSvoYn6Q6fNGvLzKQEtpspBNEgoT6+jWO02KU1CIE+rk=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a63:2209:0:b0:3ab:113b:9a2b with SMTP id
 i9-20020a632209000000b003ab113b9a2bmr524140pgi.235.1652896755458; Wed, 18 May
 2022 10:59:15 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:10 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-5-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 4/5] KVM: Actually create debugfs in kvm_create_vm()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
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
headaches. Pass around the fd number as a string, as poking at the fd in
any other way is nonsensical.

Note the fix for a benign mistake in error handling for calls to
kvm_arch_create_vm_debugfs() rolled in. Since all implementations of
the function return 0 unconditionally it isn't actually a bug at
the moment.

Lastly, tear down debugfs/stats data in the kvm_create_vm_debugfs()
error path. Previously it was safe to assume that kvm_destroy_vm() would
take out the garbage, that is no longer the case.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 87ccab74dc80..aaa7213b34dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -968,21 +968,21 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	}
 }
 
-static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
+static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
 	static DEFINE_MUTEX(kvm_debugfs_lock);
 	struct dentry *dent;
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
-	int i, ret;
+	int i, ret = -ENOMEM;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
 	if (!debugfs_initialized())
 		return 0;
 
-	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
+	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
@@ -1001,13 +1001,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
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
@@ -1022,7 +1022,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 		pdesc = &kvm_vcpu_stats_desc[i];
 		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
 		if (!stat_data)
-			return -ENOMEM;
+			goto out_err;
 
 		stat_data->kvm = kvm;
 		stat_data->desc = pdesc;
@@ -1034,12 +1034,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
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
@@ -1070,7 +1071,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	return 0;
 }
 
-static struct kvm *kvm_create_vm(unsigned long type)
+static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	struct kvm_memslots *slots;
@@ -1158,7 +1159,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_arch_post_init_vm(kvm);
 	if (r)
-		goto out_err;
+		goto out_err_mmu_notifier;
 
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -1174,12 +1175,18 @@ static struct kvm *kvm_create_vm(unsigned long type)
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
@@ -4774,6 +4781,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
+	char fdname[ITOA_MAX_LEN + 1];
 	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
@@ -4782,7 +4790,8 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (fd < 0)
 		return fd;
 
-	kvm = kvm_create_vm(type);
+	snprintf(fdname, sizeof(fdname), "%d", fd);
+	kvm = kvm_create_vm(type, fdname);
 	if (IS_ERR(kvm)) {
 		r = PTR_ERR(kvm);
 		goto put_fd;
@@ -4799,17 +4808,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
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
2.36.1.124.g0e6072fb45-goog

