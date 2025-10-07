Return-Path: <kvm+bounces-59569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C33AFBC167C
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 14:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 743F94E751F
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 12:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0492DF6FF;
	Tue,  7 Oct 2025 12:48:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50FF2AD2F;
	Tue,  7 Oct 2025 12:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759841331; cv=none; b=V1jb7e6kXhirIlGasa6isON410eAZxR7MFMJeNP5KiAXNqSENuYCYmYIyQReATdJ0pLZtNKbyGbbBwp7otXmbRaIzD5b5ti0VVhfnBQhowLCl53L7cPbcNZTRZ+Za1ThexVKRtypkzMGB5Riw7iEBOgX5pPjP9o3RFBTK+riqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759841331; c=relaxed/simple;
	bh=/+lawd4CjpTfUD3/n0BGr4AZmlHdIk7S/ZqLXTelGDg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I/QwgKg3451nqu54racj5wr9H9v0oZS0YK2GzmQ2FA654z6NUCatZytP/k+LeEY6U0teOiFGp8zfb2NIQR+1kWkepHREpwQwd8aq16bVESqLEBr2bbPEJokQVwtcWF4r5uYnAfQ8cQvV1hyVjZKo3OuI2Fqp2l88ydSr20VEMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: use call_rcu instead of synchronize_srcu_expedited() for MMIO unregistration
Date: Tue, 7 Oct 2025 20:48:29 +0800
Message-ID: <20251007124829.2051-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc13.internal.baidu.com (172.31.51.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

During VM reboot/shutdown, device MMIO unregistration maybe occurs
frequently. The current use of synchronize_srcu_expedited() introduces
measurable latency in these operations. Replace with call_rcu to defer
cleanup asynchronously, speed up VM reboot/shutdown.

Add a 'dev' field to struct kvm_io_bus to hold the device being
unregistered for the RCU callback. Adjust related code to ensure
proper list management before unregistration.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/kvm_host.h  |  1 +
 virt/kvm/coalesced_mmio.c |  2 +-
 virt/kvm/eventfd.c        |  2 +-
 virt/kvm/kvm_main.c       | 13 ++++++++-----
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19b8c4b..38498d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -208,6 +208,7 @@ struct kvm_io_bus {
 	int dev_count;
 	int ioeventfd_count;
 	struct rcu_head rcu;
+	struct kvm_io_device *dev;
 	struct kvm_io_range range[];
 };
 
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 375d628..0db6af2 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -82,7 +82,6 @@ static void coalesced_mmio_destructor(struct kvm_io_device *this)
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 
-	list_del(&dev->list);
 
 	kfree(dev);
 }
@@ -169,6 +168,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list) {
 		if (zone->pio == dev->zone.pio &&
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
+			list_del(&dev->list);
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 			/*
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 6b1133a..8a2f0e0 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -750,7 +750,6 @@ static void
 ioeventfd_release(struct _ioeventfd *p)
 {
 	eventfd_ctx_put(p->eventfd);
-	list_del(&p->list);
 	kfree(p);
 }
 
@@ -949,6 +948,7 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 		if (!p->wildcard && p->datamatch != args->datamatch)
 			continue;
 
+		list_del(&p->list);
 		kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
 		bus = kvm_get_bus(kvm, bus_idx);
 		if (bus)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f2e77eb..3ddad34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5955,10 +5955,12 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
-static void __free_bus(struct rcu_head *rcu)
+static void __free_bus_dev(struct rcu_head *rcu)
 {
 	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
 
+	if (bus->dev)
+		kvm_iodevice_destructor(bus->dev);
 	kfree(bus);
 }
 
@@ -6000,7 +6002,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
+	bus->dev = NULL;
+	call_srcu(&kvm->srcu, &bus->rcu, __free_bus_dev);
 
 	return 0;
 }
@@ -6036,20 +6039,20 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	}
 
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
 	 * If NULL bus is installed, destroy the old bus, including all the
 	 * attached devices. Otherwise, destroy the caller's device only.
 	 */
 	if (!new_bus) {
+		synchronize_srcu_expedited(&kvm->srcu);
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
 		kvm_io_bus_destroy(bus);
 		return -ENOMEM;
 	}
 
-	kvm_iodevice_destructor(dev);
-	kfree(bus);
+	bus->dev = dev;
+	call_srcu(&kvm->srcu, &bus->rcu, __free_bus_dev);
 	return 0;
 }
 
-- 
2.9.4


