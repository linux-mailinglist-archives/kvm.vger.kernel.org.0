Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAAE155D75
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBGSOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:14:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:39500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbgBGSOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 13:14:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 540E4AD3F;
        Fri,  7 Feb 2020 18:14:12 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     akpm@linux-foundation.org
Cc:     dave@stgolabs.net, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        broonie@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/5] vfio/type1: optimize dma_list tree iterations
Date:   Fri,  7 Feb 2020 10:03:04 -0800
Message-Id: <20200207180305.11092-5-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200207180305.11092-1-dave@stgolabs.net>
References: <20200207180305.11092-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both ->release() and ->attach_group() vfio_iommu driver
callbacks can incur in full in-order iommu->dma_list traversals,
which can be suboptimal under regular rbtree interators. This
patch proposes using the optimized llrbtree interface such that
we always have a branchless O(1) next node available. The cost
is higher memory footprint, mainly enlarging struct vfio_dma
by two pointers. This allows for minimal runtime overhead
when doing tree modifications.

Cc: alex.williamson@redhat.com
Cc: cohuck@redhat.com
Cc: kvm@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/vfio/vfio_iommu_type1.c | 50 +++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..875170fc8515 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/rbtree.h>
+#include <linux/ll_rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
@@ -65,7 +66,7 @@ struct vfio_iommu {
 	struct list_head	iova_list;
 	struct vfio_domain	*external_domain; /* domain for external user */
 	struct mutex		lock;
-	struct rb_root		dma_list;
+	struct llrb_root	dma_list;
 	struct blocking_notifier_head notifier;
 	unsigned int		dma_avail;
 	bool			v2;
@@ -81,7 +82,7 @@ struct vfio_domain {
 };
 
 struct vfio_dma {
-	struct rb_node		node;
+	struct llrb_node	node;
 	dma_addr_t		iova;		/* Device address */
 	unsigned long		vaddr;		/* Process virtual addr */
 	size_t			size;		/* Map size (bytes) */
@@ -134,10 +135,10 @@ static int put_pfn(unsigned long pfn, int prot);
 static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 				      dma_addr_t start, size_t size)
 {
-	struct rb_node *node = iommu->dma_list.rb_node;
+	struct rb_node *node = iommu->dma_list.rb_root.rb_node;
 
 	while (node) {
-		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
+		struct vfio_dma *dma = llrb_entry(node, struct vfio_dma, node);
 
 		if (start + size <= dma->iova)
 			node = node->rb_left;
@@ -152,26 +153,30 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
-	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
+	struct rb_node **link = &iommu->dma_list.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct llrb_node *prev = NULL;
 	struct vfio_dma *dma;
 
 	while (*link) {
 		parent = *link;
-		dma = rb_entry(parent, struct vfio_dma, node);
+		dma = llrb_entry(parent, struct vfio_dma, node);
 
 		if (new->iova + new->size <= dma->iova)
 			link = &(*link)->rb_left;
-		else
+		else {
 			link = &(*link)->rb_right;
+			prev = llrb_from_rb(parent);
+		}
 	}
 
-	rb_link_node(&new->node, parent, link);
-	rb_insert_color(&new->node, &iommu->dma_list);
+	rb_link_node(&new->node.rb_node, parent, link);
+	llrb_insert(&iommu->dma_list, &new->node, prev);
 }
 
 static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
 {
-	rb_erase(&old->node, &iommu->dma_list);
+	llrb_erase(&old->node, &iommu->dma_list);
 }
 
 /*
@@ -1170,15 +1175,15 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
 	struct vfio_domain *d;
-	struct rb_node *n;
+	struct llrb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
 	/* Arbitrarily pick the first domain in the list for lookups */
 	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
-	n = rb_first(&iommu->dma_list);
+	n = llrb_first(&iommu->dma_list);
 
-	for (; n; n = rb_next(n)) {
+	for (; n; n = llrb_next(n)) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
 
@@ -1835,18 +1840,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
 {
-	struct rb_node *node;
+	struct llrb_node *node;
 
-	while ((node = rb_first(&iommu->dma_list)))
+	while ((node = llrb_first(&iommu->dma_list)))
 		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
 }
 
 static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 {
-	struct rb_node *n, *p;
+	struct llrb_node *n;
+	struct rb_node *p;
 
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
+	n = llrb_first(&iommu->dma_list);
+	for (; n; n = llrb_next(n)) {
 		struct vfio_dma *dma;
 		long locked = 0, unlocked = 0;
 
@@ -1866,10 +1872,10 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 
 static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
 {
-	struct rb_node *n;
+	struct llrb_node *n;
 
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
+	n = llrb_first(&iommu->dma_list);
+	for (; n; n = llrb_next(n)) {
 		struct vfio_dma *dma;
 
 		dma = rb_entry(n, struct vfio_dma, node);
@@ -2060,7 +2066,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 
 	INIT_LIST_HEAD(&iommu->domain_list);
 	INIT_LIST_HEAD(&iommu->iova_list);
-	iommu->dma_list = RB_ROOT;
+	iommu->dma_list = LLRB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
-- 
2.16.4

