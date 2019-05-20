Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6A22CBF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfETHPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 03:15:40 -0400
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:39861 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730058AbfETHPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 03:15:40 -0400
Received: from player158.ha.ovh.net (unknown [10.108.42.215])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id C11AE12E5FF
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:15:37 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player158.ha.ovh.net (Postfix) with ESMTPSA id C16205D36025;
        Mon, 20 May 2019 07:15:30 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Subject: [PATCH 2/3] KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when resetting
Date:   Mon, 20 May 2019 09:15:13 +0200
Message-Id: <20190520071514.9308-3-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520071514.9308-1-clg@kaod.org>
References: <20190520071514.9308-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6059874777678253015
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtjedguddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a CPU is hot-unplugged, the EQ is deconfigured using a zero size
and a zero address. In this case, there is no need to check the flag
and queue size validity. Move the checks after the queue reset code
section to fix CPU hot-unplug.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 36 +++++++++++++--------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 796d86549cfe..3fdea6bf4e97 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -565,24 +565,6 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 		 __func__, server, priority, kvm_eq.flags,
 		 kvm_eq.qshift, kvm_eq.qaddr, kvm_eq.qtoggle, kvm_eq.qindex);
 
-	/*
-	 * sPAPR specifies a "Unconditional Notify (n) flag" for the
-	 * H_INT_SET_QUEUE_CONFIG hcall which forces notification
-	 * without using the coalescing mechanisms provided by the
-	 * XIVE END ESBs. This is required on KVM as notification
-	 * using the END ESBs is not supported.
-	 */
-	if (kvm_eq.flags != KVM_XIVE_EQ_ALWAYS_NOTIFY) {
-		pr_err("invalid flags %d\n", kvm_eq.flags);
-		return -EINVAL;
-	}
-
-	rc = xive_native_validate_queue_size(kvm_eq.qshift);
-	if (rc) {
-		pr_err("invalid queue size %d\n", kvm_eq.qshift);
-		return rc;
-	}
-
 	/* reset queue and disable queueing */
 	if (!kvm_eq.qshift) {
 		q->guest_qaddr  = 0;
@@ -604,6 +586,24 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 		return 0;
 	}
 
+	/*
+	 * sPAPR specifies a "Unconditional Notify (n) flag" for the
+	 * H_INT_SET_QUEUE_CONFIG hcall which forces notification
+	 * without using the coalescing mechanisms provided by the
+	 * XIVE END ESBs. This is required on KVM as notification
+	 * using the END ESBs is not supported.
+	 */
+	if (kvm_eq.flags != KVM_XIVE_EQ_ALWAYS_NOTIFY) {
+		pr_err("invalid flags %d\n", kvm_eq.flags);
+		return -EINVAL;
+	}
+
+	rc = xive_native_validate_queue_size(kvm_eq.qshift);
+	if (rc) {
+		pr_err("invalid queue size %d\n", kvm_eq.qshift);
+		return rc;
+	}
+
 	if (kvm_eq.qaddr & ((1ull << kvm_eq.qshift) - 1)) {
 		pr_err("queue page is not aligned %llx/%llx\n", kvm_eq.qaddr,
 		       1ull << kvm_eq.qshift);
-- 
2.20.1

