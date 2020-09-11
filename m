Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE4265911
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKGEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 02:04:04 -0400
Received: from regular1.263xmail.com ([211.150.70.206]:45482 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgIKGED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 02:04:03 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2020 02:04:02 EDT
Received: from localhost (unknown [192.168.167.69])
        by regular1.263xmail.com (Postfix) with ESMTP id 0FD7049A;
        Fri, 11 Sep 2020 13:57:13 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [125.88.171.115])
        by smtp.263.net (postfix) whith ESMTP id P25136T140525459982080S1599803826185079_;
        Fri, 11 Sep 2020 13:57:12 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <6aaa4e79d86ee4d5edf8d473087f072a>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: pbonzini@redhat.com
X-SENDER-IP: 125.88.171.115
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     pbonzini@redhat.com
Cc:     yilikernel@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Yi Li <yili@winhong.com>
Subject: [PATCH] kvm/eventfd:do wildcard calculation before list_for_each_entry_safe
Date:   Fri, 11 Sep 2020 13:56:52 +0800
Message-Id: <20200911055652.3041762-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to calculate wildcard in each loop
since wildcard is not changed.

Signed-off-by: Yi Li <yili@winhong.com>
---
 virt/kvm/eventfd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index d6408bb497dc..c2323c27a28b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -853,15 +853,17 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 	struct eventfd_ctx       *eventfd;
 	struct kvm_io_bus	 *bus;
 	int                       ret = -ENOENT;
+	bool                      wildcard;
 
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
+	wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
+
 	mutex_lock(&kvm->slots_lock);
 
 	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
-		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
 
 		if (p->bus_idx != bus_idx ||
 		    p->eventfd != eventfd  ||
-- 
2.25.3



