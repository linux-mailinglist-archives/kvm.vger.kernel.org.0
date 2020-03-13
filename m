Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D9C183F98
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCMDWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:22:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:6766 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:22:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 20:22:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="278066137"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 20:22:02 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 7/7] drm/i915/gvt: rw more pages a time for shadow context
Date:   Thu, 12 Mar 2020 23:12:33 -0400
Message-Id: <20200313031233.8094-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313030548.7705-1-yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1. as shadow context is pinned in intel_vgpu_setup_submission() and
unpinned in intel_vgpu_clean_submission(), its base virtual address of
is safely obtained from lrc_reg_state. no need to call kmap()/kunmap()
repeatedly.

2. IOVA(GPA)s of context pages are checked in this patch and if they are
consecutive, read/write them together in one
intel_gvt_hypervisor_read_gpa() / intel_gvt_hypervisor_write_gpa().

after the two changes in this patch,
average cycles for populate_shadow_context() and update_guest_context()
are reduced by ~10000-20000 cycles, depending on the average number of
consecutive pages in each read/write.

(1) comparison of cycles of
populate_shadow_context() + update_guest_context() when executing
different benchmarks
 -------------------------------------------------------------
|       cycles      | glmark2     | lightsmark  | openarena   |
|-------------------------------------------------------------|
| before this patch | 65968       | 97852       | 61373       |
|  after this patch | 56017 (85%) | 73862 (75%) | 47463 (77%) |
 -------------------------------------------------------------

(2) average count of pages read/written a time in
populate_shadow_context() and update_guest_context()
for each benchmark

 -----------------------------------------------------------
|     page cnt      | glmark2     | lightsmark  | openarena |
|-----------------------------------------------------------|
| before this patch |    1        |      1      |    1      |
|  after this patch |    5.25     |     19.99   |   20      |
 ------------------------------------------------------------

(3) comparison of benchmarks scores
 ---------------------------------------------------------------------
|      score        | glmark2       | lightsmark     | openarena      |
|---------------------------------------------------------------------|
| before this patch | 1244          | 222.18         | 114.4          |
|  after this patch | 1248 (100.3%) | 225.8 (101.6%) | 115.0 (100.9%) |
 ---------------------------------------------------------------------

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 95 ++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 1c95bf8cbed0..852d924f6abc 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -128,16 +128,21 @@ static int populate_shadow_context(struct intel_vgpu_workload *workload)
 {
 	struct intel_vgpu *vgpu = workload->vgpu;
 	struct intel_gvt *gvt = vgpu->gvt;
-	struct drm_i915_gem_object *ctx_obj =
-		workload->req->context->state->obj;
+	struct intel_context *ctx = workload->req->context;
 	struct execlist_ring_context *shadow_ring_context;
-	struct page *page;
 	void *dst;
+	void *context_base;
 	unsigned long context_gpa, context_page_num;
+	unsigned long gpa_base; /* first gpa of consecutive GPAs */
+	unsigned long gpa_size; /* size of consecutive GPAs */
 	int i;
 
-	page = i915_gem_object_get_page(ctx_obj, LRC_STATE_PN);
-	shadow_ring_context = kmap(page);
+	GEM_BUG_ON(!intel_context_is_pinned(ctx));
+
+	context_base = (void *) ctx->lrc_reg_state -
+				(LRC_STATE_PN << I915_GTT_PAGE_SHIFT);
+
+	shadow_ring_context = (void *) ctx->lrc_reg_state;
 
 	sr_oa_regs(workload, (u32 *)shadow_ring_context, true);
 #define COPY_REG(name) \
@@ -169,7 +174,6 @@ static int populate_shadow_context(struct intel_vgpu_workload *workload)
 			I915_GTT_PAGE_SIZE - sizeof(*shadow_ring_context));
 
 	sr_oa_regs(workload, (u32 *)shadow_ring_context, false);
-	kunmap(page);
 
 	if (IS_RESTORE_INHIBIT(shadow_ring_context->ctx_ctrl.val))
 		return 0;
@@ -184,8 +188,12 @@ static int populate_shadow_context(struct intel_vgpu_workload *workload)
 	if (IS_BROADWELL(gvt->gt->i915) && workload->engine->id == RCS0)
 		context_page_num = 19;
 
-	i = 2;
-	while (i < context_page_num) {
+
+	/* find consecutive GPAs from gma until the first inconsecutive GPA.
+	 * read from the continuous GPAs into dst virtual address
+	 */
+	gpa_size = 0;
+	for (i = 2; i < context_page_num; i++) {
 		context_gpa = intel_vgpu_gma_to_gpa(vgpu->gtt.ggtt_mm,
 				(u32)((workload->ctx_desc.lrca + i) <<
 				I915_GTT_PAGE_SHIFT));
@@ -194,12 +202,24 @@ static int populate_shadow_context(struct intel_vgpu_workload *workload)
 			return -EFAULT;
 		}
 
-		page = i915_gem_object_get_page(ctx_obj, i);
-		dst = kmap(page);
-		intel_gvt_hypervisor_read_gpa(vgpu, context_gpa, dst,
-				I915_GTT_PAGE_SIZE);
-		kunmap(page);
-		i++;
+		if (gpa_size == 0) {
+			gpa_base = context_gpa;
+			dst = context_base + (i << I915_GTT_PAGE_SHIFT);
+		} else if (context_gpa != gpa_base + gpa_size)
+			goto read;
+
+		gpa_size += I915_GTT_PAGE_SIZE;
+
+		if (i == context_page_num - 1)
+			goto read;
+
+		continue;
+
+read:
+		intel_gvt_hypervisor_read_gpa(vgpu, gpa_base, dst, gpa_size);
+		gpa_base = context_gpa;
+		gpa_size = I915_GTT_PAGE_SIZE;
+		dst = context_base + (i << I915_GTT_PAGE_SHIFT);
 	}
 	return 0;
 }
@@ -784,19 +804,23 @@ static void update_guest_context(struct intel_vgpu_workload *workload)
 {
 	struct i915_request *rq = workload->req;
 	struct intel_vgpu *vgpu = workload->vgpu;
-	struct drm_i915_gem_object *ctx_obj = rq->context->state->obj;
+	struct intel_context *ctx = workload->req->context;
 	struct execlist_ring_context *shadow_ring_context;
-	struct page *page;
-	void *src;
 	unsigned long context_gpa, context_page_num;
+	unsigned long gpa_base; /* first gpa of consecutive GPAs */
+	unsigned long gpa_size; /* size of consecutive GPAs*/
 	int i;
 	u32 ring_base;
 	u32 head, tail;
 	u16 wrap_count;
+	void *src;
+	void *context_base;
 
 	gvt_dbg_sched("ring id %d workload lrca %x\n", rq->engine->id,
 		      workload->ctx_desc.lrca);
 
+	GEM_BUG_ON(!intel_context_is_pinned(ctx));
+
 	head = workload->rb_head;
 	tail = workload->rb_tail;
 	wrap_count = workload->guest_rb_head >> RB_HEAD_WRAP_CNT_OFF;
@@ -820,9 +844,14 @@ static void update_guest_context(struct intel_vgpu_workload *workload)
 	if (IS_BROADWELL(rq->i915) && rq->engine->id == RCS0)
 		context_page_num = 19;
 
-	i = 2;
+	context_base = (void *) ctx->lrc_reg_state -
+			(LRC_STATE_PN << I915_GTT_PAGE_SHIFT);
 
-	while (i < context_page_num) {
+	/* find consecutive GPAs from gma until the first inconsecutive GPA.
+	 * write to the consecutive GPAs from src virtual address
+	 */
+	gpa_size = 0;
+	for (i = 2; i < context_page_num; i++) {
 		context_gpa = intel_vgpu_gma_to_gpa(vgpu->gtt.ggtt_mm,
 				(u32)((workload->ctx_desc.lrca + i) <<
 					I915_GTT_PAGE_SHIFT));
@@ -831,19 +860,30 @@ static void update_guest_context(struct intel_vgpu_workload *workload)
 			return;
 		}
 
-		page = i915_gem_object_get_page(ctx_obj, i);
-		src = kmap(page);
-		intel_gvt_hypervisor_write_gpa(vgpu, context_gpa, src,
-				I915_GTT_PAGE_SIZE);
-		kunmap(page);
-		i++;
+		if (gpa_size == 0) {
+			gpa_base = context_gpa;
+			src = context_base + (i << I915_GTT_PAGE_SHIFT);
+		} else if (context_gpa != gpa_base + gpa_size)
+			goto write;
+
+		gpa_size += I915_GTT_PAGE_SIZE;
+
+		if (i == context_page_num - 1)
+			goto write;
+
+		continue;
+
+write:
+		intel_gvt_hypervisor_write_gpa(vgpu, gpa_base, src, gpa_size);
+		gpa_base = context_gpa;
+		gpa_size = I915_GTT_PAGE_SIZE;
+		src = context_base + (i << I915_GTT_PAGE_SHIFT);
 	}
 
 	intel_gvt_hypervisor_write_gpa(vgpu, workload->ring_context_gpa +
 		RING_CTX_OFF(ring_header.val), &workload->rb_tail, 4);
 
-	page = i915_gem_object_get_page(ctx_obj, LRC_STATE_PN);
-	shadow_ring_context = kmap(page);
+	shadow_ring_context = (void *) ctx->lrc_reg_state;
 
 #define COPY_REG(name) \
 	intel_gvt_hypervisor_write_gpa(vgpu, workload->ring_context_gpa + \
@@ -861,7 +901,6 @@ static void update_guest_context(struct intel_vgpu_workload *workload)
 			sizeof(*shadow_ring_context),
 			I915_GTT_PAGE_SIZE - sizeof(*shadow_ring_context));
 
-	kunmap(page);
 }
 
 void intel_vgpu_clean_workloads(struct intel_vgpu *vgpu,
-- 
2.17.1

