Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EABF22CD2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 09:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfETHVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 03:21:33 -0400
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:52072 "EHLO
        6.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfETHVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 03:21:33 -0400
Received: from player158.ha.ovh.net (unknown [10.109.143.249])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id CE2B112E634
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:15:30 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player158.ha.ovh.net (Postfix) with ESMTPSA id 69C8A5D35FA8;
        Mon, 20 May 2019 07:15:24 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 1/3] KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
Date:   Mon, 20 May 2019 09:15:12 +0200
Message-Id: <20190520071514.9308-2-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520071514.9308-1-clg@kaod.org>
References: <20190520071514.9308-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6057904452536732631
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtjedguddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve the release of the XIVE KVM device by clearing the file
address_space which is used to unmap the interrupt ESB pages when a
device is passed-through.

Suggested-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 6a8e698c4b6e..796d86549cfe 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -979,6 +979,14 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 
 	pr_devel("Releasing xive native device\n");
 
+	/*
+	 * Clear the KVM device file address_space which is used to
+	 * unmap the ESB pages when a device is passed-through.
+	 */
+	mutex_lock(&xive->mapping_lock);
+	xive->mapping = NULL;
+	mutex_unlock(&xive->mapping_lock);
+
 	/*
 	 * Clearing mmu_ready temporarily while holding kvm->lock
 	 * is a way of ensuring that no vcpus can enter the guest
-- 
2.20.1

