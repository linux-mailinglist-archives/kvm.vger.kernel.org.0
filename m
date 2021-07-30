Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8A3DB26B
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 06:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhG3Ejl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 00:39:41 -0400
Received: from ozlabs.ru ([107.174.27.60]:39584 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhG3Ejl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 00:39:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2021 00:39:41 EDT
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 37EE5AE80062;
        Fri, 30 Jul 2021 00:32:21 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
Date:   Fri, 30 Jul 2021 14:32:17 +1000
Message-Id: <20210730043217.953384-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The debugfs folder name is made of a supposedly unique pair of
the process pid and a VM fd. However it is possible to get a race here
which manifests in these messages:

[  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!

debugfs_create_dir() returns an error which is handled correctly
everywhere except kvm_create_vm_debugfs() where the code allocates
stat data structs and overwrites the older values regardless.

Spotted by syzkaller. This slow memory leak produces way too many
OOM reports.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

I am pretty sure we better fix the race but I am not quite sure what
lock is appropriate here, ideas?

---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 986959833d70..89496fd8127a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -904,6 +904,10 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 
 	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
 	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
+	if (IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
+		pr_err("Failed to create %s\n", dir_name);
+		return 0;
+	}
 
 	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
 					 sizeof(*kvm->debugfs_stat_data),
-- 
2.30.2

