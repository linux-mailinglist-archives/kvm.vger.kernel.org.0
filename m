Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E3029918
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 15:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403894AbfEXNg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 09:36:58 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:32960 "EHLO
        6.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403891AbfEXNg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 09:36:57 -0400
Received: from player737.ha.ovh.net (unknown [10.108.42.239])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 0FA3923A38A
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 15:20:41 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player737.ha.ovh.net (Postfix) with ESMTPSA id 00A0F64074C1;
        Fri, 24 May 2019 13:20:34 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Paul Mackerras <paulus@samba.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
Date:   Fri, 24 May 2019 15:20:30 +0200
Message-Id: <20190524132030.6349-1-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17269334246588713844
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedgieehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
priority is used by the OS. This is referred as EQ provisioning and it
is done under the hood when :

  1. a CPU is hot-plugged in the VM
  2. the "set-xive" is called at VM startup
  3. sources are restored at VM restore

The kvm->lock mutex is used to protect the different XIVE structures
being modified but in some contextes, kvm->lock is taken under the
vcpu->mutex which is a forbidden sequence by KVM.

Introduce a new mutex 'lock' for the KVM devices for them to
synchronize accesses to the XIVE device structures.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive.h        |  1 +
 arch/powerpc/kvm/book3s_xive.c        | 23 +++++++++++++----------
 arch/powerpc/kvm/book3s_xive_native.c | 15 ++++++++-------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 426146332984..862c2c9650ae 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -141,6 +141,7 @@ struct kvmppc_xive {
 	struct kvmppc_xive_ops *ops;
 	struct address_space   *mapping;
 	struct mutex mapping_lock;
+	struct mutex lock;
 };
 
 #define KVMPPC_XIVE_Q_COUNT	8
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index f623451ec0a3..12c8a36dd980 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -271,14 +271,14 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
 	return rc;
 }
 
-/* Called with kvm_lock held */
+/* Called with xive->lock held */
 static int xive_check_provisioning(struct kvm *kvm, u8 prio)
 {
 	struct kvmppc_xive *xive = kvm->arch.xive;
 	struct kvm_vcpu *vcpu;
 	int i, rc;
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&xive->lock);
 
 	/* Already provisioned ? */
 	if (xive->qmap & (1 << prio))
@@ -621,9 +621,12 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
 		 irq, server, priority);
 
 	/* First, check provisioning of queues */
-	if (priority != MASKED)
+	if (priority != MASKED) {
+		mutex_lock(&xive->lock);
 		rc = xive_check_provisioning(xive->kvm,
 			      xive_prio_from_guest(priority));
+		mutex_unlock(&xive->lock);
+	}
 	if (rc) {
 		pr_devel("  provisioning failure %d !\n", rc);
 		return rc;
@@ -1199,7 +1202,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 		return -ENOMEM;
 
 	/* We need to synchronize with queue provisioning */
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&xive->lock);
 	vcpu->arch.xive_vcpu = xc;
 	xc->xive = xive;
 	xc->vcpu = vcpu;
@@ -1283,7 +1286,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 		xive_vm_esb_load(&xc->vp_ipi_data, XIVE_ESB_SET_PQ_00);
 
 bail:
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&xive->lock);
 	if (r) {
 		kvmppc_xive_cleanup_vcpu(vcpu);
 		return r;
@@ -1527,13 +1530,12 @@ static int xive_get_source(struct kvmppc_xive *xive, long irq, u64 addr)
 struct kvmppc_xive_src_block *kvmppc_xive_create_src_block(
 	struct kvmppc_xive *xive, int irq)
 {
-	struct kvm *kvm = xive->kvm;
 	struct kvmppc_xive_src_block *sb;
 	int i, bid;
 
 	bid = irq >> KVMPPC_XICS_ICS_SHIFT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&xive->lock);
 
 	/* block already exists - somebody else got here first */
 	if (xive->src_blocks[bid])
@@ -1560,7 +1562,7 @@ struct kvmppc_xive_src_block *kvmppc_xive_create_src_block(
 		xive->max_sbid = bid;
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&xive->lock);
 	return xive->src_blocks[bid];
 }
 
@@ -1670,9 +1672,9 @@ static int xive_set_source(struct kvmppc_xive *xive, long irq, u64 addr)
 	/* If we have a priority target the interrupt */
 	if (act_prio != MASKED) {
 		/* First, check provisioning of queues */
-		mutex_lock(&xive->kvm->lock);
+		mutex_lock(&xive->lock);
 		rc = xive_check_provisioning(xive->kvm, act_prio);
-		mutex_unlock(&xive->kvm->lock);
+		mutex_unlock(&xive->lock);
 
 		/* Target interrupt */
 		if (rc == 0)
@@ -1963,6 +1965,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	dev->private = xive;
 	xive->dev = dev;
 	xive->kvm = kvm;
+	mutex_init(&xive->lock);
 
 	/* Already there ? */
 	if (kvm->arch.xive)
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index cdce9f94738e..684619517d67 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -114,7 +114,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 		return -EINVAL;
 	}
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&xive->lock);
 
 	if (kvmppc_xive_find_server(vcpu->kvm, server_num)) {
 		pr_devel("Duplicate !\n");
@@ -159,7 +159,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 
 	/* TODO: reset all queues to a clean state ? */
 bail:
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&xive->lock);
 	if (rc)
 		kvmppc_xive_native_cleanup_vcpu(vcpu);
 
@@ -772,7 +772,7 @@ static int kvmppc_xive_reset(struct kvmppc_xive *xive)
 
 	pr_devel("%s\n", __func__);
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&xive->lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
@@ -810,7 +810,7 @@ static int kvmppc_xive_reset(struct kvmppc_xive *xive)
 		}
 	}
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&xive->lock);
 
 	return 0;
 }
@@ -878,7 +878,7 @@ static int kvmppc_xive_native_eq_sync(struct kvmppc_xive *xive)
 
 	pr_devel("%s\n", __func__);
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&xive->lock);
 	for (i = 0; i <= xive->max_sbid; i++) {
 		struct kvmppc_xive_src_block *sb = xive->src_blocks[i];
 
@@ -892,7 +892,7 @@ static int kvmppc_xive_native_eq_sync(struct kvmppc_xive *xive)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvmppc_xive_native_vcpu_eq_sync(vcpu);
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&xive->lock);
 
 	return 0;
 }
@@ -965,7 +965,7 @@ static int kvmppc_xive_native_has_attr(struct kvm_device *dev,
 }
 
 /*
- * Called when device fd is closed
+ * Called when device fd is closed.  kvm->lock is held.
  */
 static void kvmppc_xive_native_release(struct kvm_device *dev)
 {
@@ -1064,6 +1064,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	xive->kvm = kvm;
 	kvm->arch.xive = xive;
 	mutex_init(&xive->mapping_lock);
+	mutex_init(&xive->lock);
 
 	/*
 	 * Allocate a bunch of VPs. KVM_MAX_VCPUS is a large value for
-- 
2.20.1

