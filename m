Return-Path: <kvm+bounces-15702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 614548AF5AB
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 935E71C243CC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C36142E6D;
	Tue, 23 Apr 2024 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HI8YBru8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE65142651;
	Tue, 23 Apr 2024 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893813; cv=none; b=ZoHxO4q9n7g7fefZ8o0gJfLcG0tCRtQmwsNNnJTfsis7Q+IvN7LpMhJVTVV20zd8N4wis/C4ERJOVwzSxeIi6mEX73c56OWO7qU5fPIBqa3kLEu5ESGXLm76TnH7hIrfJy0zaPFT+uwmGCXP0mtlXOdoa1oizyKT8WFuXndXebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893813; c=relaxed/simple;
	bh=vHveCBoYcLQh8NROkIMdspOYAm2kEY1xSagTRG3zNfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hO4NkxVFKUzX1ln9Sgt1tVrcoObDz+PXIJvn8ctnrjoTLdDI/Nm6ncAfcToeNi6KQ0RErZQEXIW0LoO/MDTiOh/11Vqho/FspB0WJ/c4ow3UoWORm77P56FfU66xYpYu1A3YsA03Q9NniLUtGnKIh+QaOr8EsLECNhWQXClnios=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HI8YBru8; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893813; x=1745429813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vHveCBoYcLQh8NROkIMdspOYAm2kEY1xSagTRG3zNfk=;
  b=HI8YBru8XwiX9DokqoirXJ8QHiBFGTHr8uNqh8VNqLy4kNZUjaRXBI2/
   tUwTDVSkc3HE9IIvdijqoY8u3MrBIwUkYHkdbkKNIvx5wxNsginesHoEA
   aAV8sOzEXOvsBn6gCnm75QXNzk4m9mERdDujEKpne0nH6kVYyxzUH46Jh
   yRkpMogMUSkU349pb6228N6/7aZQLgpV0rbzC5fIcnpfPdy6fEah1Rue4
   Xf388wvRY3a16fvIbLYAfOfpvf33WKeZjUEimm83lny+HaC6+LLxZx8u3
   RsP8NTWILD+pscb5NnzgagBm/+aLwfqIvkbJ9R78Ukr/r+JP8zwuGYvgb
   g==;
X-CSE-ConnectionGUID: Ljro6GvHTrqzFmy0ShV9Bw==
X-CSE-MsgGUID: yC7P864iQs+qKrg5fbzDxw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712424"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712424"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:44 -0700
X-CSE-ConnectionGUID: 6813K98VTTKaYFVGkrcS0w==
X-CSE-MsgGUID: jJuW4cXiQbOaxBaDu9DBsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097428"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:43 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  07/12] x86/irq: Factor out calling ISR from common_interrupt
Date: Tue, 23 Apr 2024 10:41:09 -0700
Message-Id: <20240423174114.526704-8-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare for calling external IRQ handlers directly from the posted MSI
demultiplexing loop. Extract the common code with common interrupt to
avoid code duplication.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/irq.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index dbb3a19b3004..d652b0481899 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -242,18 +242,10 @@ static __always_inline void handle_irq(struct irq_desc *desc,
 		__handle_irq(desc, regs);
 }
 
-/*
- * common_interrupt() handles all normal device IRQ's (the special SMP
- * cross-CPU interrupts have their own entry points).
- */
-DEFINE_IDTENTRY_IRQ(common_interrupt)
+static __always_inline void call_irq_handler(int vector, struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct irq_desc *desc;
 
-	/* entry code tells RCU that we're not quiescent.  Check it. */
-	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
-
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
@@ -268,7 +260,20 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 			__this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
 		}
 	}
+}
+
+/*
+ * common_interrupt() handles all normal device IRQ's (the special SMP
+ * cross-CPU interrupts have their own entry points).
+ */
+DEFINE_IDTENTRY_IRQ(common_interrupt)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/* entry code tells RCU that we're not quiescent.  Check it. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
 
+	call_irq_handler(vector, regs);
 	set_irq_regs(old_regs);
 }
 
-- 
2.25.1


