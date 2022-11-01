Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3780F614500
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 08:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKAHZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 03:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAHZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 03:25:18 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06A13F9D;
        Tue,  1 Nov 2022 00:25:17 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id VIA00014;
        Tue, 01 Nov 2022 15:25:14 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201603.home.langchao.com (10.100.2.3) with Microsoft SMTP Server id
 15.1.2507.12; Tue, 1 Nov 2022 15:25:15 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: replace ternary operator with min()
Date:   Tue, 1 Nov 2022 03:25:13 -0400
Message-ID: <20221101072513.7364-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20221101152514d0c097bb1529cad842e2e8cbee1e17ca
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warning:

virt/kvm/kvm_main.c:5289:10-11: WARNING opportunity for min()
virt/kvm/kvm_main.c:5218:10-11: WARNING opportunity for min()

min() macro is defined in include/linux/minmax.h. It avoids
multiple evaluations of the arguments when non-constant and
performs strict type-checking.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f383f27d3d7..45a56a9600e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5215,7 +5215,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_write(vcpu, bus, &range, val);
-	return r < 0 ? r : 0;
+	return min(r, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
@@ -5286,7 +5286,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
-	return r < 0 ? r : 0;
+	return min(r, 0);
 }
 
 /* Caller must hold slots_lock. */
-- 
2.27.0

