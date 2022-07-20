Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4F157B3B9
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiGTJXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbiGTJXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:30 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0737474E8
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUmZqZ/F2bxgn//UZkaUGqQltni3LqAraqqZ2/Z94Fg=;
        b=K7VFQGQNdMHHbcjcFrQVbzj4MClBuyucTHJZOx2JawBKJDuRfGQpOd31HL1drB/pA4+D2G
        qe77HYu7agyilcPaAN1MSP0zDgqELChX6qfjwqhHKiAikrhroNafUSiwLFDMAvgKcX9P6l
        UitedxrD7bsH9iBAbewqyavnfBb8f9o=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 3/6] KVM: Get an fd before creating the VM
Date:   Wed, 20 Jul 2022 09:22:49 +0000
Message-Id: <20220720092259.3491733-4-oliver.upton@linux.dev>
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

Allocate a VM's fd at the very beginning of kvm_dev_ioctl_create_vm() so
that KVM can use the fd value to generate strigns, e.g. for debugfs,
when creating and initializing the VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1f78b7ad5430..e270cff3c9f4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4889,25 +4889,27 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
-	int r;
+	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
 
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
 	kvm = kvm_create_vm(type);
-	if (IS_ERR(kvm))
-		return PTR_ERR(kvm);
+	if (IS_ERR(kvm)) {
+		r = PTR_ERR(kvm);
+		goto put_fd;
+	}
+
 #ifdef CONFIG_KVM_MMIO
 	r = kvm_coalesced_mmio_init(kvm);
 	if (r < 0)
 		goto put_kvm;
 #endif
-	r = get_unused_fd_flags(O_CLOEXEC);
-	if (r < 0)
-		goto put_kvm;
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
-		put_unused_fd(r);
 		r = PTR_ERR(file);
 		goto put_kvm;
 	}
@@ -4918,18 +4920,20 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * cases it will be called by the final fput(file) and will take
 	 * care of doing kvm_put_kvm(kvm).
 	 */
-	if (kvm_create_vm_debugfs(kvm, r) < 0) {
-		put_unused_fd(r);
+	if (kvm_create_vm_debugfs(kvm, fd) < 0) {
 		fput(file);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto put_fd;
 	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
-	fd_install(r, file);
-	return r;
+	fd_install(fd, file);
+	return fd;
 
 put_kvm:
 	kvm_put_kvm(kvm);
+put_fd:
+	put_unused_fd(fd);
 	return r;
 }
 
-- 
2.37.0.170.g444d1eabd0-goog

