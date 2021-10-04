Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F14219FD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhJDW2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:28:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhJDW2x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 18:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633386423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=go//iVwtY7zZIP/QH6T/mRZIb51VgkEaG2XcNzZciIo=;
        b=A7ApVUJTu7MXBRX90hxsI1VAvPYTNG/l3lW2b/+DCsFbYcRPMFly+4ySRUfxTkADxm/7uA
        VkHi3JtTil//fenHG3FxoeTgRqiBZmBbvlL4l1NfbVl7ISeT/JlYG4d79L8AXSbAWUJqML
        hAH5qWechxVWdYmFRkwo7zubYpCTWc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-bw0XuvdjPN2hgzVz5wjh_Q-1; Mon, 04 Oct 2021 18:27:02 -0400
X-MC-Unique: bw0XuvdjPN2hgzVz5wjh_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 268E28145E6;
        Mon,  4 Oct 2021 22:27:01 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4291618B5E;
        Mon,  4 Oct 2021 22:27:00 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        mtosatti@redhat.com, tglx@linutronix.de, frederic@kernel.org,
        mingo@kernel.org, nilal@redhat.com
Subject: [PATCH v1] KVM: isolation: retain initial mask for kthread VM worker
Date:   Mon,  4 Oct 2021 18:26:39 -0400
Message-Id: <20211004222639.239209-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_vm_worker_thread() creates a kthread VM worker and migrates it
to the parent cgroup using cgroup_attach_task_all() based on its
effective cpumask.

In an environment that is booted with the nohz_full kernel option, cgroup's
effective cpumask can also include CPUs running in nohz_full mode. These
CPUs often run SCHED_FIFO tasks which may result in the starvation of the
VM worker if it has been migrated to one of these CPUs.

Since unbounded kernel threads allowed CPU mask already respects nohz_full
CPUs at the time of their setup (because of 9cc5b8656892: "isolcpus: Affine
unbound kernel threads to housekeeping cpus"), retain the initial CPU mask
for the kthread by stopping its migration to the parent cgroup's effective
CPUs.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..87bc193fd020 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -56,6 +56,7 @@
 #include <asm/processor.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
+#include <linux/sched/isolation.h>
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
@@ -5634,11 +5635,20 @@ static int kvm_vm_worker_thread(void *context)
 	if (err)
 		goto init_complete;
 
-	err = cgroup_attach_task_all(init_context->parent, current);
-	if (err) {
-		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
-			__func__, err);
-		goto init_complete;
+	/*
+	 * For nohz_full enabled environments, don't migrate the worker thread
+	 * to parent cgroup as its effective mask may have a CPU running in
+	 * nohz_full mode. nohz_full CPUs often run SCHED_FIFO task which could
+	 * result in starvation of the worker thread if it is pinned on the same
+	 * CPU.
+	 */
+	if (!housekeeping_enabled(HK_FLAG_KTHREAD)) {
+		err = cgroup_attach_task_all(init_context->parent, current);
+		if (err) {
+			kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
+				__func__, err);
+			goto init_complete;
+		}
 	}
 
 	set_user_nice(current, task_nice(init_context->parent));
-- 
2.27.0

