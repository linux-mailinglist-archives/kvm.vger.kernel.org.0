Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F281035D2FA
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbhDLWVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343679AbhDLWVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:21:17 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FB6C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:59 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id p5so8900607qvr.4
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AiiJgkOyq0rWpmswuec6JylDPoH1QjeGXsG4T5RZ06k=;
        b=uszHBCBaNHKQP1m7HiJLFD+M4wLkbuFcN+V2jwDIwZ0mf4GCldT0h15Eeg49qi+EYm
         8ntYGr+G1VBZUnuioRQqsH3QZGHHW6qo5fjyEST1bxDMO5dIYe5JOFV+EN6TqZRTRW1X
         NDfAjH6lNpKE73C/Q+vxZUAMjTgIQQmx5wHz7vAb97lPssVQ+hGC7DmatcUZFl9Vm8Mq
         31x2jxE3nvkMb7FbNYkQT4h92ApQ2+56XkNMk9V3EnL058CCIfabZBS3ZEaLUgN0+HI4
         YRNteG5zWfNQy08jlwDLNcCmMKcCcV6tOLd1G5thZye92Uyvh0wIG7MvqlHrr8cFQM/p
         oAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AiiJgkOyq0rWpmswuec6JylDPoH1QjeGXsG4T5RZ06k=;
        b=dQZb3nSqn+rOmgd8Xkyoq7JmBVWq/KUp1dsQ98N2jAaZte0crxVj0VhzR1G5JpC3xz
         mYVlepr2OChfOSRZrT+w92cLvmvW8a1y5HvSVjvJt1mg4XX3F9A+2XFqjnXCFHr92N2s
         esG7WNnPe9d/kwmwG638y6fqonmJZRSR0y7Uxi9YCyYhGZMvkjBslzoBljwFbcdO3JIN
         P9mfK+Y5Ol6P/rLDrp6VbWyX8xx8mU7lDbugnWuuV36yCRh4KWTKic0+BPv3f7OOblCB
         gancS5H141tnevpHtIwC+2bWYHV4io1Dp3LLGBtRLjky1AfUdIgfFb4OdYKcL3AhhLhI
         aQaQ==
X-Gm-Message-State: AOAM531lzlEM5elys/LHXrOfWNjn0rEovMSxm4gG9QjjjTNcsjskDkFl
        1KYr2wJm39aHtVW9hfcdZWYEsNirT58=
X-Google-Smtp-Source: ABdhPJy6M0pK2CZO3TBQvo0iOU9v0K7uinLll0rrP/TGV+6xSj/uck/oQM941PvaLNuNP+/ZmswYP/1PxXU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a0c:9b82:: with SMTP id o2mr30338012qve.47.1618266058587;
 Mon, 12 Apr 2021 15:20:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 12 Apr 2021 15:20:49 -0700
In-Reply-To: <20210412222050.876100-1-seanjc@google.com>
Message-Id: <20210412222050.876100-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210412222050.876100-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH 2/3] KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abort the walk of coalesced MMIO zones if kvm_io_bus_unregister_dev()
fails to allocate memory for the new instance of the bus.  If it can't
instantiate a new bus, unregister_dev() destroys all devices _except_ the
target device.   But, it doesn't tell the caller that it obliterated the
bus and invoked the destructor for all devices that were on the bus.  In
the coalesced MMIO case, this can result in a deleted list entry
dereference due to attempting to continue iterating on coalesced_zones
after future entries (in the walk) have been deleted.

Opportunistically add curly braces to the for-loop, which encompasses
many lines but sneaks by without braces due to the guts being a single
if statement.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h  |  4 ++--
 virt/kvm/coalesced_mmio.c | 19 +++++++++++++++++--
 virt/kvm/kvm_main.c       | 10 +++++-----
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1b65e7204344..99dccea4293c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -192,8 +192,8 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val);
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev);
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev);
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev);
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 					 gpa_t addr);
 
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 62bd908ecd58..f08f5e82460b 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -174,21 +174,36 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 					   struct kvm_coalesced_mmio_zone *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev, *tmp;
+	int r;
 
 	if (zone->pio != 1 && zone->pio != 0)
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
 
-	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list)
+	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list) {
 		if (zone->pio == dev->zone.pio &&
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
-			kvm_io_bus_unregister_dev(kvm,
+			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 			kvm_iodevice_destructor(&dev->dev);
+
+			/*
+			 * On failure, unregister destroys all devices on the
+			 * bus _except_ the target device, i.e. coalesced_zones
+			 * has been modified.  No need to restart the walk as
+			 * there aren't any zones left.
+			 */
+			if (r)
+				break;
 		}
+	}
 
 	mutex_unlock(&kvm->slots_lock);
 
+	/*
+	 * Ignore the result of kvm_io_bus_unregister_dev(), from userspace's
+	 * perspective, the coalesced MMIO is most definitely unregistered.
+	 */
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6e2b570e430..ab1fa6f92c82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4486,15 +4486,15 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 }
 
 /* Caller must hold slots_lock. */
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev)
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev)
 {
 	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
 	if (!bus)
-		return;
+		return 0;
 
 	for (i = 0; i < bus->dev_count; i++)
 		if (bus->range[i].dev == dev) {
@@ -4502,7 +4502,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		}
 
 	if (i == bus->dev_count)
-		return;
+		return 0;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
@@ -4527,7 +4527,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	}
 
 	kfree(bus);
-	return;
+	return new_bus ? 0 : -ENOMEM;
 }
 
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-- 
2.31.1.295.g9ea45b61b8-goog

