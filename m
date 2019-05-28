Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD432D136
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 23:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfE1Vwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 17:52:53 -0400
Received: from 8.mo69.mail-out.ovh.net ([46.105.56.233]:50023 "EHLO
        8.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfE1Vwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 17:52:53 -0400
X-Greylist: delayed 2347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2019 17:52:52 EDT
Received: from player759.ha.ovh.net (unknown [10.108.57.72])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 81A465A6CD
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 23:13:44 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id 87EC864DFDC2;
        Tue, 28 May 2019 21:13:32 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Paul Mackerras <paulus@samba.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: fix page offset when clearing ESB pages
Date:   Tue, 28 May 2019 23:13:24 +0200
Message-Id: <20190528211324.18656-1-clg@kaod.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11855726020037741428
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgudehkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under XIVE, the ESB pages of an interrupt are used for interrupt
management (EOI) and triggering. They are made available to guests
through a mapping of the XIVE KVM device.

When a device is passed-through, the passthru_irq helpers,
kvmppc_xive_set_mapped() and kvmppc_xive_clr_mapped(), clear the ESB
pages of the guest IRQ number being mapped and let the VM fault
handler repopulate with the correct page.

The ESB pages are mapped at offset 4 (KVM_XIVE_ESB_PAGE_OFFSET) in the
KVM device mapping. Unfortunately, this offset was not taken into
account when clearing the pages. This lead to issues with the
passthrough devices for which the interrupts were not functional under
some guest configuration (tg3 and single CPU) or in any configuration
(e1000e adapter).

Signed-off-by: Cédric Le Goater <clg@kaod.org>
---

 if unmap_mapping_pages() could be called from a module, we would
 simplify a bit this code.

 arch/powerpc/kvm/book3s_xive_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 8b762e3ebbc5..5596c8ec221a 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -172,6 +172,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 static int kvmppc_xive_native_reset_mapped(struct kvm *kvm, unsigned long irq)
 {
 	struct kvmppc_xive *xive = kvm->arch.xive;
+	pgoff_t esb_pgoff = KVM_XIVE_ESB_PAGE_OFFSET + irq * 2;
 
 	if (irq >= KVMPPC_XIVE_NR_IRQS)
 		return -EINVAL;
@@ -185,7 +186,7 @@ static int kvmppc_xive_native_reset_mapped(struct kvm *kvm, unsigned long irq)
 	mutex_lock(&xive->mapping_lock);
 	if (xive->mapping)
 		unmap_mapping_range(xive->mapping,
-				    irq * (2ull << PAGE_SHIFT),
+				    esb_pgoff << PAGE_SHIFT,
 				    2ull << PAGE_SHIFT, 1);
 	mutex_unlock(&xive->mapping_lock);
 	return 0;
-- 
2.21.0

