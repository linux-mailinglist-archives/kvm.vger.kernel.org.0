Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891915322A5
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 07:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiEXFwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 01:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiEXFwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 01:52:18 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 787F7612A1;
        Mon, 23 May 2022 22:52:16 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id B029180560;
        Tue, 24 May 2022 01:52:13 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     kvm@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: Don't null dereference ops->destroy
Date:   Tue, 24 May 2022 15:52:08 +1000
Message-Id: <20220524055208.1269279-1-aik@ozlabs.ru>
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

There are 2 places calling kvm_device_ops::destroy():
1) when creating a KVM device failed;
2) when a VM is destroyed: kvm_destroy_devices() destroys all devices
from &kvm->devices.

All 3 Book3s's interrupt controller KVM devices (XICS, XIVE, XIVE-native)
do not define kvm_device_ops::destroy() and only define release() which
is normally fine as device fds are closed before KVM gets to 2) but
by then the &kvm->devices list is empty.

However Syzkaller manages to trigger 1).

This adds checks in 1) and 2).

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

I could define empty handlers for XICS/XIVE guys but
kvm_ioctl_create_device() already checks for ops->init() so I guess
kvm_device_ops are expected to not have certain handlers.

---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f30bb8c16f26..17f698ccddd1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1205,7 +1205,8 @@ static void kvm_destroy_devices(struct kvm *kvm)
 	 */
 	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
 		list_del(&dev->vm_node);
-		dev->ops->destroy(dev);
+		if (dev->ops->destroy)
+			dev->ops->destroy(dev);
 	}
 }
 
@@ -4300,7 +4301,8 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
 		mutex_unlock(&kvm->lock);
-		ops->destroy(dev);
+		if (ops->destroy)
+			ops->destroy(dev);
 		return ret;
 	}
 
-- 
2.30.2

