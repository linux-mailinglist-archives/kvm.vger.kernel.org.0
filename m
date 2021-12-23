Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE647DD69
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 02:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbhLWBeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 20:34:19 -0500
Received: from smtpbg604.qq.com ([59.36.128.82]:38235 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238646AbhLWBeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 20:34:18 -0500
X-QQ-mid: bizesmtp43t1640223251t5bblo38
Received: from localhost.localdomain (unknown [111.30.215.244])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 23 Dec 2021 09:34:10 +0800 (CST)
X-QQ-SSF: 01000000002000506000B00A0000000
X-QQ-FEAT: YOSTkFbe9CQ7ZJ8ETrL1TY+91SqTY9TBZZOGZEIQvJKIuMvDCmRQRHVRmSMzw
        40cW2NZVEe6U0ynE/4V79ScufjQVIcV++5+zAw8GcAaDsUN8KCP48wBWzxNPZA4RVEWW1PY
        EYpYkn7yLaNWmFFMJIpiCiH1PUkxMygr/r5eE7pSPgBZoT8/piNOXylwYXlSkCwpMtGfxGk
        0nMIGRL7r3UDlDK97z/8qViCYu0jDpgQeDQ9WHLO0sIom1iwA1Fd3H05AQQU5gHQkJPE9Vz
        38OMR7SvkzfFkZ0XabMrcKX+Ugli5ZM2S24GZP9b+IOPpFuiIcBMRh0AE=
X-QQ-GoodBg: 0
From:   gchen@itskywalker.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Gang <gchen@itskywalker.com>
Subject: [PATCH] KVM: return the error code from kvm_arch_create_vm_debugfs when it fails
Date:   Thu, 23 Dec 2021 09:34:08 +0800
Message-Id: <20211223013408.153595-1-gchen@itskywalker.com>
X-Mailer: git-send-email 2.24.0.308.g228f53135a
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:itskywalker.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chen Gang <gchen@itskywalker.com>

At present, kvm_arch_create_vm_debugfs is a new interface for arch, and
it assumes return an none-zero error code, so the caller need check it
and return it to the user mode.

Signed-off-by: Chen Gang <gchen@itskywalker.com>
---
 virt/kvm/kvm_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8a1a17bcb7e..b2de428bd4c7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1015,7 +1015,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	ret = kvm_arch_create_vm_debugfs(kvm);
 	if (ret) {
 		kvm_destroy_vm_debugfs(kvm);
-		return i;
+		return ret;
 	}
 
 	return 0;
@@ -4727,7 +4727,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
-	int r;
+	int r, ret;
 	struct kvm *kvm;
 	struct file *file;
 
@@ -4759,10 +4759,11 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * cases it will be called by the final fput(file) and will take
 	 * care of doing kvm_put_kvm(kvm).
 	 */
-	if (kvm_create_vm_debugfs(kvm, r) < 0) {
+	ret = kvm_create_vm_debugfs(kvm, r);
+	if (ret) {
 		put_unused_fd(r);
 		fput(file);
-		return -ENOMEM;
+		return ret;
 	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
-- 
2.24.0.308.g228f53135a

