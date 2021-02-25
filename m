Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19286324831
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhBYBBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:01:39 -0500
Received: from foss.arm.com ([217.140.110.172]:58270 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236574AbhBYBBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:01:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA100113E;
        Wed, 24 Feb 2021 17:00:30 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B99A3F73B;
        Wed, 24 Feb 2021 17:00:29 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 03/22] ioport: Retire .generate_fdt_node functionality
Date:   Thu, 25 Feb 2021 00:58:56 +0000
Message-Id: <20210225005915.26423-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ioport routines support a special way of registering FDT node
generator functions. There is no reason to have this separate from the
already existing way via the device header.

Now that the only user of this special ioport variety has been
transferred, we can retire this code, to simplify ioport handling.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/ioport.h |  4 ----
 ioport.c             | 34 ----------------------------------
 2 files changed, 38 deletions(-)

diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index d0213541..a61038e2 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -29,10 +29,6 @@ struct ioport {
 struct ioport_operations {
 	bool (*io_in)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
 	bool (*io_out)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
-	void (*generate_fdt_node)(struct ioport *ioport, void *fdt,
-				  void (*generate_irq_prop)(void *fdt,
-							    u8 irq,
-							    enum irq_type));
 };
 
 void ioport__map_irq(u8 *irq);
diff --git a/ioport.c b/ioport.c
index a6972179..e0123f27 100644
--- a/ioport.c
+++ b/ioport.c
@@ -56,7 +56,6 @@ static struct ioport *ioport_get(struct rb_root *root, u64 addr)
 /* Called with ioport_lock held. */
 static void ioport_unregister(struct rb_root *root, struct ioport *data)
 {
-	device__unregister(&data->dev_hdr);
 	ioport_remove(root, data);
 	free(data);
 }
@@ -70,30 +69,6 @@ static void ioport_put(struct rb_root *root, struct ioport *data)
 	mutex_unlock(&ioport_lock);
 }
 
-#ifdef CONFIG_HAS_LIBFDT
-static void generate_ioport_fdt_node(void *fdt,
-				     struct device_header *dev_hdr,
-				     void (*generate_irq_prop)(void *fdt,
-							       u8 irq,
-							       enum irq_type))
-{
-	struct ioport *ioport = container_of(dev_hdr, struct ioport, dev_hdr);
-	struct ioport_operations *ops = ioport->ops;
-
-	if (ops->generate_fdt_node)
-		ops->generate_fdt_node(ioport, fdt, generate_irq_prop);
-}
-#else
-static void generate_ioport_fdt_node(void *fdt,
-				     struct device_header *dev_hdr,
-				     void (*generate_irq_prop)(void *fdt,
-							       u8 irq,
-							       enum irq_type))
-{
-	die("Unable to generate device tree nodes without libfdt\n");
-}
-#endif
-
 int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, int count, void *param)
 {
 	struct ioport *entry;
@@ -107,10 +82,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 		.node		= RB_INT_INIT(port, port + count),
 		.ops		= ops,
 		.priv		= param,
-		.dev_hdr	= (struct device_header) {
-			.bus_type	= DEVICE_BUS_IOPORT,
-			.data		= generate_ioport_fdt_node,
-		},
 		/*
 		 * Start from 0 because ioport__unregister() doesn't decrement
 		 * the reference count.
@@ -123,15 +94,10 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0)
 		goto out_free;
-	r = device__register(&entry->dev_hdr);
-	if (r < 0)
-		goto out_remove;
 	mutex_unlock(&ioport_lock);
 
 	return port;
 
-out_remove:
-	ioport_remove(&ioport_tree, entry);
 out_free:
 	free(entry);
 	mutex_unlock(&ioport_lock);
-- 
2.17.5

