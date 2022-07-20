Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7AC57B3BA
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbiGTJXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiGTJXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:31 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11592474D3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bNDYP+zMLkm/SvPhmbgPaXAopB57bjy/6FavpFfvnA=;
        b=l5SaWFyKDdpWI/Gz/juazLApjOXfo9Pp0HzhdgjyaKUMFapHBM7/+hQDjmUPr8ZrU7st9w
        3CUgc6FxR9A/XoKGct88YPZWoBpNBQ4f+J3VZw0wY6tz0+NFNKwYMDSPWtJy8q7PJHqrBL
        ulisPrXhEaKamVRPe374uWKLvevvN9M=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 4/6] KVM: Pass the name of the VM fd to kvm_create_vm_debugfs()
Date:   Wed, 20 Jul 2022 09:22:50 +0000
Message-Id: <20220720092259.3491733-5-oliver.upton@linux.dev>
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

At the time the VM fd is used in kvm_create_vm_debugfs(), the fd has
been allocated but not yet installed. It is only really useful as an
identifier in strings for the VM (such as debugfs).

Treat it exactly as such by passing the string name of the fd to
kvm_create_vm_debugfs(), futureproofing against possible misuse of the
VM fd.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e270cff3c9f4..1e7f780a357b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1021,7 +1021,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	}
 }
 
-static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
+static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
 	static DEFINE_MUTEX(kvm_debugfs_lock);
 	struct dentry *dent;
@@ -1035,7 +1035,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	if (!debugfs_initialized())
 		return 0;
 
-	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
+	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
@@ -4889,6 +4889,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
+	char fdname[ITOA_MAX_LEN + 1];
 	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
@@ -4897,6 +4898,8 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (fd < 0)
 		return fd;
 
+	snprintf(fdname, sizeof(fdname), "%d", fd);
+
 	kvm = kvm_create_vm(type);
 	if (IS_ERR(kvm)) {
 		r = PTR_ERR(kvm);
@@ -4920,7 +4923,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * cases it will be called by the final fput(file) and will take
 	 * care of doing kvm_put_kvm(kvm).
 	 */
-	if (kvm_create_vm_debugfs(kvm, fd) < 0) {
+	if (kvm_create_vm_debugfs(kvm, fdname) < 0) {
 		fput(file);
 		r = -ENOMEM;
 		goto put_fd;
-- 
2.37.0.170.g444d1eabd0-goog

