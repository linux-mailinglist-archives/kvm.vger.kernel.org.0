Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48F68D6E2
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 13:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjBGMhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 07:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjBGMhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 07:37:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24D31E5EA;
        Tue,  7 Feb 2023 04:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675773441; x=1707309441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBpTrUqylWiKPxKvun97ZAjRbNqQZ6n5ryRa2OISY5U=;
  b=aY4C1MVB9TthPTPwXni1IVx+qumO4wfTi1+6rapVQkTrjEDw4wjQKCFt
   msDr2Iop/dZkQV3ju6RXWy1/IybpWa/VY9S7cjmYs4ALo5eYhuUMWLM0q
   9a+Ud6p7VbTmS82EZ/m8YerG/JWewrw5440iDjXzTIbxnnXiLtnH+IXUO
   Oi/2PuZKTkOof++fsXkUBAELpPLv6L45O9hFa5SGlzdKhaYt/Cr3+Hz4t
   0Hka8P55Ash9MZguJo0RauvYJws/PTjwJyWPBz5Jf5NiXPu89aQVtygQa
   3OFL0Nb81tQx4id+ki93hveNYTAxSHG8fAF+2FSO7jCHiCOX2lwRFJ/7I
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309140920"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="309140920"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="697267994"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="697267994"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 04:37:19 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, mhal@rbox.co
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 1/2] KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
Date:   Tue,  7 Feb 2023 20:37:12 +0800
Message-Id: <20230207123713.3905-2-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230207123713.3905-1-wei.w.wang@intel.com>
References: <20230207123713.3905-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current usage of kvm_io_device requires users to destruct it with an extra
call of kvm_iodevice_destructor after the device gets unregistered from
kvm_io_bus. This is not necessary and can cause errors if a user forgot
to make the extra call.

Simplify the usage by combining kvm_iodevice_destructor into
kvm_io_bus_unregister_dev. This reduces LOCs a bit for users and can
avoid the leakage of destructing the device explicitly.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 include/kvm/iodev.h       |  6 ------
 virt/kvm/coalesced_mmio.c |  9 ++-------
 virt/kvm/eventfd.c        |  1 -
 virt/kvm/kvm_main.c       | 23 +++++++++++++++--------
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
index d75fc4365746..56619e33251e 100644
--- a/include/kvm/iodev.h
+++ b/include/kvm/iodev.h
@@ -55,10 +55,4 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
 				 : -EOPNOTSUPP;
 }
 
-static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
-{
-	if (dev->ops->destructor)
-		dev->ops->destructor(dev);
-}
-
 #endif /* __KVM_IODEV_H__ */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5ef88f5a0864..1b90acb6e3fe 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -186,15 +186,10 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
-
-			kvm_iodevice_destructor(&dev->dev);
-
 			/*
 			 * On failure, unregister destroys all devices on the
-			 * bus _except_ the target device, i.e. coalesced_zones
-			 * has been modified.  Bail after destroying the target
-			 * device, there's no need to restart the walk as there
-			 * aren't any zones left.
+			 * bus, including the target device. There's no need
+			 * to restart the walk as there aren't any zones left.
 			 */
 			if (r)
 				break;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..1b277afb545b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 		bus = kvm_get_bus(kvm, bus_idx);
 		if (bus)
 			bus->ioeventfd_count--;
-		ioeventfd_release(p);
 		ret = 0;
 		break;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 71cc63640173..ce1f2c5b7c87 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5275,6 +5275,12 @@ static void hardware_disable_all(void)
 }
 #endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 
+static void kvm_iodevice_destructor(struct kvm_io_device *dev)
+{
+	if (dev->ops->destructor)
+		dev->ops->destructor(dev);
+}
+
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
@@ -5498,7 +5504,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			      struct kvm_io_device *dev)
 {
-	int i, j;
+	int i;
 	struct kvm_io_bus *new_bus, *bus;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -5528,18 +5534,19 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);
 
-	/* Destroy the old bus _after_ installing the (null) bus. */
+	/*
+	 * If NULL bus is installed, destroy the old bus, including all the
+	 * attached devices. Otherwise, destroy the caller's device only.
+	 */
 	if (!new_bus) {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
-		for (j = 0; j < bus->dev_count; j++) {
-			if (j == i)
-				continue;
-			kvm_iodevice_destructor(bus->range[j].dev);
-		}
+		kvm_io_bus_destroy(bus);
+		return -ENOMEM;
 	}
 
+	kvm_iodevice_destructor(dev);
 	kfree(bus);
-	return new_bus ? 0 : -ENOMEM;
+	return 0;
 }
 
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-- 
2.27.0

