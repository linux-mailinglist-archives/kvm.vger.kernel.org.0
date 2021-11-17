Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A341453D5A
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 01:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhKQA6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 19:58:50 -0500
Received: from smtpbg704.qq.com ([203.205.195.105]:40383 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229543AbhKQA6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 19:58:50 -0500
X-QQ-mid: bizesmtp40t1637110549tkx47bnw
Received: from localhost.localdomain (unknown [111.207.172.18])
        by esmtp6.qq.com (ESMTP) with 
        id ; Wed, 17 Nov 2021 08:55:48 +0800 (CST)
X-QQ-SSF: 01400000002000B0G000B00A0000000
X-QQ-FEAT: BkiXUYEaZw9T7YFjlVGVw/NJzjl94e87aUc9PaP+VruuTW2E2ZHCa78zJSGkB
        tP5R2MU6no91SuGiDEOrkexfYwbSBR+k2AWSZ7Sr8lsnd9uw7xHT9wAQi+cK4AP2U+SQnIn
        Jgfsh9flL7qIuj+LNrxM15sWy2CvDgyHTbK4szJkkLF2/jRQmxJxplH+fq+44wLKzbnqJ6Q
        rFO9qe03IRylaUn5v6eSVgLfi1AZ7g/2W2mwqOgyQmAbl4A7vhDCLwHrevOElMqG40ttQv0
        c69rCglP1JhA0ioSdXSdIzKTX85Z82ErS3f6C3yNnWQZ4kzAAexgTMe1+9coND9V1Fr74Cj
        GFqWT3OQSwvXSP6H5Q=
X-QQ-GoodBg: 2
From:   zhaoxiao <zhaoxiao@uniontech.com>
To:     kvm@vger.kernel.org
Cc:     zhaoxiao <zhaoxiao@uniontech.com>
Subject: [PATCH] KVM: Fix the warning by the min()
Date:   Wed, 17 Nov 2021 08:55:45 +0800
Message-Id: <20211117005545.26214-1-zhaoxiao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix following coccicheck warning:
virt/kvm/kvm_main.c:4995:10-11: WARNING opportunity for min()
virt/kvm/kvm_main.c:4924:10-11: WARNING opportunity for min()

Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d31724500501..bd646c64722d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4910,7 +4910,6 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 {
 	struct kvm_io_bus *bus;
 	struct kvm_io_range range;
-	int r;
 
 	range = (struct kvm_io_range) {
 		.addr = addr,
@@ -4920,8 +4919,8 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
 	if (!bus)
 		return -ENOMEM;
-	r = __kvm_io_bus_write(vcpu, bus, &range, val);
-	return r < 0 ? r : 0;
+
+	return min(__kvm_io_bus_write(vcpu, bus, &range, val), 0);
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
@@ -4981,7 +4980,6 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 {
 	struct kvm_io_bus *bus;
 	struct kvm_io_range range;
-	int r;
 
 	range = (struct kvm_io_range) {
 		.addr = addr,
@@ -4991,8 +4989,8 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
 	if (!bus)
 		return -ENOMEM;
-	r = __kvm_io_bus_read(vcpu, bus, &range, val);
-	return r < 0 ? r : 0;
+
+	return min(__kvm_io_bus_read(vcpu, bus, &range, val), 0);
 }
 
 /* Caller must hold slots_lock. */
-- 
2.20.1



