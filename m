Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CFA114B44
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 03:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfLFCyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 21:54:09 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6759 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfLFCyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 21:54:09 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B083F64EF77D563497E7;
        Fri,  6 Dec 2019 10:54:07 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Dec 2019
 10:53:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] KVM: lib: use jump label to handle resource release in irq_bypass_register_consumer()
Date:   Fri, 6 Dec 2019 10:53:52 +0800
Message-ID: <1575600833-12839-2-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575600833-12839-1-git-send-email-linmiaohe@huawei.com>
References: <1575600833-12839-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use out_err jump label to handle resource release. It's a
good practice to release resource in one place and help
eliminate some duplicated code.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/lib/irqbypass.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 43de8ae78fa1..cb0c801b3bc2 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -179,6 +179,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 {
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
+	int ret;
 
 	if (!consumer->token ||
 	    !consumer->add_producer || !consumer->del_producer)
@@ -193,20 +194,16 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 
 	list_for_each_entry(tmp, &consumers, node) {
 		if (tmp->token == consumer->token || tmp == consumer) {
-			mutex_unlock(&lock);
-			module_put(THIS_MODULE);
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out_err;
 		}
 	}
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == consumer->token) {
-			int ret = __connect(producer, consumer);
-			if (ret) {
-				mutex_unlock(&lock);
-				module_put(THIS_MODULE);
-				return ret;
-			}
+			ret = __connect(producer, consumer);
+			if (ret)
+				goto out_err;
 			break;
 		}
 	}
@@ -216,6 +213,10 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 	mutex_unlock(&lock);
 
 	return 0;
+out_err:
+	mutex_unlock(&lock);
+	module_put(THIS_MODULE);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
 
-- 
2.19.1

