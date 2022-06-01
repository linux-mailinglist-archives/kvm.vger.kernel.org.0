Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC6539ADB
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 03:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349013AbiFABnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 21:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245551AbiFABnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 21:43:32 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DDF7819AD;
        Tue, 31 May 2022 18:43:31 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 9588A80531;
        Tue, 31 May 2022 21:43:29 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     kvm@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH kernel v2] KVM: Don't null dereference ops->destroy
Date:   Wed,  1 Jun 2022 11:43:28 +1000
Message-Id: <20220601014328.1444271-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A KVM device cleanup happens in either of two callbacks:
1) destroy() which is called when the VM is being destroyed;
2) release() which is called when a device fd is closed.

Most KVM devices use 1) but Book3s's interrupt controller KVM devices
(XICS, XIVE, XIVE-native) use 2) as they need to close and reopen during
the machine execution. The error handling in kvm_ioctl_create_device()
assumes destroy() is always defined which leads to NULL dereference as
discovered by Syzkaller.

This adds a checks for destroy!=NULL and adds a missing release().

This is not changing kvm_destroy_devices() as devices with defined
release() should have been removed from the KVM devices list by then.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2:
* do not touch kvm_destroy_devices
* call release() in the error path
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f30bb8c16f26..e1c4bca95040 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4299,8 +4299,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		kvm_put_kvm_no_destroy(kvm);
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
+		if (ops->release)
+			ops->release(dev);
 		mutex_unlock(&kvm->lock);
-		ops->destroy(dev);
+		if (ops->destroy)
+			ops->destroy(dev);
 		return ret;
 	}
 
-- 
2.30.2

