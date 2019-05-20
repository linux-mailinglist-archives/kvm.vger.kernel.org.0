Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C15C22CD1
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 09:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbfETHUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 03:20:55 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:44604 "EHLO
        6.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfETHUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 03:20:54 -0400
Received: from player158.ha.ovh.net (unknown [10.109.160.239])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 197E517929E
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:15:43 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player158.ha.ovh.net (Postfix) with ESMTPSA id A3F765D360B7;
        Mon, 20 May 2019 07:15:37 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Subject: [PATCH 3/3] KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU identifier
Date:   Mon, 20 May 2019 09:15:14 +0200
Message-Id: <20190520071514.9308-4-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520071514.9308-1-clg@kaod.org>
References: <20190520071514.9308-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6061563625976531927
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtjedguddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vCPU is connected to the KVM device, it is done using its vCPU
identifier in the guest. Fix the enforced limit on the vCPU identifier
by taking into account the SMT mode.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 3fdea6bf4e97..25b6b0e2d02a 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -109,7 +109,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 		return -EPERM;
 	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
 		return -EBUSY;
-	if (server_num >= KVM_MAX_VCPUS) {
+	if (server_num >= (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
 		pr_devel("Out of bounds !\n");
 		return -EINVAL;
 	}
-- 
2.20.1

