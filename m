Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A71F2341BA
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 10:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgGaI7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 04:59:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732002AbgGaI7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 04:59:54 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8D30C5935469A8C5426D;
        Fri, 31 Jul 2020 16:59:51 +0800 (CST)
Received: from DESKTOP-KKJBAGG.china.huawei.com (10.174.186.173) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 16:59:43 +0800
From:   Zhenyu Ye <yezhenyu2@huawei.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yezhenyu2@huawei.com>, <xiexiangyou@huawei.com>
Subject: [PATCH v1] ioeventfd: introduce get_ioeventfd()
Date:   Fri, 31 Jul 2020 16:59:39 +0800
Message-ID: <20200731085939.629-1-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get corresponding ioeventfd from kvm->ioeventfds. If no match
is found, return NULL.  This is used in kvm_assign_ioeventfd_idx()
and kvm_deassign_ioeventfd_idx().

Signed-off-by: Zhenyu Ye <yezhenyu2@huawei.com>
---
 virt/kvm/eventfd.c | 53 ++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index ef7ed916ad4a..77f7d81c1138 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,6 +28,11 @@
 
 #include <kvm/iodev.h>
 
+#define warn_if(expr, msg) do {				\
+	if (expr)					\
+		pr_warn("ioeventfd: %s\n", msg);	\
+} while (0)
+
 #ifdef CONFIG_HAVE_KVM_IRQFD
 
 static struct workqueue_struct *irqfd_cleanup_wq;
@@ -756,21 +761,23 @@ static const struct kvm_io_device_ops ioeventfd_ops = {
 };
 
 /* assumes kvm->slots_lock held */
-static bool
-ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
+static inline struct _ioeventfd *
+get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
+	      struct kvm_ioeventfd *args)
 {
-	struct _ioeventfd *_p;
+	static struct _ioeventfd *_p;
+	bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
 
 	list_for_each_entry(_p, &kvm->ioeventfds, list)
-		if (_p->bus_idx == p->bus_idx &&
-		    _p->addr == p->addr &&
-		    (!_p->length || !p->length ||
-		     (_p->length == p->length &&
-		      (_p->wildcard || p->wildcard ||
-		       _p->datamatch == p->datamatch))))
-			return true;
+		if (_p->bus_idx == bus_idx &&
+		    _p->addr == args->addr &&
+		    (!_p->length || !args->len ||
+		     (_p->length == args->len &&
+		      (_p->wildcard || wildcard ||
+		       _p->datamatch == args->datamatch))))
+			return _p;
 
-	return false;
+	return NULL;
 }
 
 static enum kvm_bus ioeventfd_bus_from_flags(__u32 flags)
@@ -816,7 +823,7 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Verify that there isn't a match already */
-	if (ioeventfd_check_collision(kvm, p)) {
+	if (get_ioeventfd(kvm, bus_idx, args)) {
 		ret = -EEXIST;
 		goto unlock_fail;
 	}
@@ -849,7 +856,7 @@ static int
 kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 			   struct kvm_ioeventfd *args)
 {
-	struct _ioeventfd        *p, *tmp;
+	struct _ioeventfd        *p;
 	struct eventfd_ctx       *eventfd;
 	struct kvm_io_bus	 *bus;
 	int                       ret = -ENOENT;
@@ -860,18 +867,15 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	mutex_lock(&kvm->slots_lock);
 
-	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
+	p = get_ioeventfd(kvm, bus_idx, args);
+	if (p) {
 		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
-
-		if (p->bus_idx != bus_idx ||
-		    p->eventfd != eventfd  ||
-		    p->addr != args->addr  ||
-		    p->length != args->len ||
-		    p->wildcard != wildcard)
-			continue;
-
-		if (!p->wildcard && p->datamatch != args->datamatch)
-			continue;
+		warn_if(p->eventfd != eventfd, "eventfd should be the same!");
+		warn_if(p->length != args->len,	"length should be the same!");
+		warn_if(p->length && p->wildcard != wildcard,
+				"wildcard should be the same!");
+		warn_if(p->length && !p->wildcard && p->datamatch != args->datamatch,
+				"datamatch should be the same!");
 
 		kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
 		bus = kvm_get_bus(kvm, bus_idx);
@@ -879,7 +883,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 			bus->ioeventfd_count--;
 		ioeventfd_release(p);
 		ret = 0;
-		break;
 	}
 
 	mutex_unlock(&kvm->slots_lock);
-- 
2.19.1


