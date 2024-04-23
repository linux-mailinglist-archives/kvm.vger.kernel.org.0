Return-Path: <kvm+bounces-15698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 642928AF5A0
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 878831C23DCD
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957F713FD9E;
	Tue, 23 Apr 2024 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="loj5h8/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899413E40C;
	Tue, 23 Apr 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893805; cv=none; b=ABBdNSF4TFWHrqQ2avWB2RDz/Hp8V2nDdzsP9oRprC3nSobfO6RrNGzYiqpt1ZcJTv9pAPjP87ulrBmDLXnVg95JUTqZNgWeSuYo8oKoha2QYuiunx+TkKNOi3eIEkzZ8QJCbfmYCujz/PD+km5YwU3exQz/bJ3WKQjf2bBY4so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893805; c=relaxed/simple;
	bh=6yjwWPDloLSOwspFuMqKfAPj6l9B58uYecA9box1OgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mXUTybVUo13pfuDI8LUdrW9TkjV6KrzjaU+XsZW1205m7GckkMHs7AWuV78gifB4L2/YF68IhoR7waMHEttu/gijPX250YmOxXfr3fq03nxKH6yP5v0mijISIkIWcujX2UXK26LvDnRV+jduHndt0NRLN0ZrgFKn8VSH7rW4Qj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=loj5h8/W; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893804; x=1745429804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6yjwWPDloLSOwspFuMqKfAPj6l9B58uYecA9box1OgU=;
  b=loj5h8/WF92boN0+FfgBRX0gjY2tZYUMkjOjbgrluA+1yTUOIa7ILnrZ
   Jki8YkZkjMGryOiFKkoTZWLoCY1kKn6fjYVkuW1Oo2a3gh3/P/mxe69xP
   iYLqaknxKFwcMN/HGL55B/Tzeau0juHM1H3+hEXeHI8v3mtAyj8RA/Ipq
   0abl+Crk9xlQgqYDO4xYl/VKXlB17MG8zaYJFCgh+l5Mj8VXAzYube7QZ
   nHS7NkpMfgV+43ugU2F9B+6GNiHgx+umdZDg1xWo+lzj4IjHXRIxpV84l
   GDPDdFxbik9WS5VVHMxPU6VoB9o9IUCwfOVUfmntbJDkr+lkjqlqy4TDR
   Q==;
X-CSE-ConnectionGUID: igE39grWRUKSrbIywerZRQ==
X-CSE-MsgGUID: qAhvR12wRn+/iI89zViQ4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712333"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712333"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:41 -0700
X-CSE-ConnectionGUID: TJmBlUKoRAKomR/09kCoXg==
X-CSE-MsgGUID: PgW7PlEhQjWiohrokkV+uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097391"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:40 -0700
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
Subject: [PATCH v3  03/12] x86/irq: Remove bitfields in posted interrupt descriptor
Date: Tue, 23 Apr 2024 10:41:05 -0700
Message-Id: <20240423174114.526704-4-jacob.jun.pan@linux.intel.com>
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

Mixture of bitfields and types is weird and really not intuitive, remove
bitfields and use typed data exclusively. Bitfields often result in
inferior machine code.

Link: https://lore.kernel.org/all/20240404101735.402feec8@jacob-builder/T/#mf66e34a82a48f4d8e2926b5581eff59a122de53a
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v3:
	- Fix a bug where SN bit position was used as the mask, reported by
	  Oliver Sang.
	- Add and use non-atomic helpers to manipulate SN bit
	- Use pi_test_sn() instead of open coding
v2:
	- Replace bitfields, no more mix.
---
 arch/x86/include/asm/posted_intr.h | 21 ++++++++++++---------
 arch/x86/kvm/vmx/posted_intr.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c             |  2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index acf237b2882e..20e31891de15 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -15,17 +15,9 @@ struct pi_desc {
 	};
 	union {
 		struct {
-				/* bit 256 - Outstanding Notification */
-			u16	on	: 1,
-				/* bit 257 - Suppress Notification */
-				sn	: 1,
-				/* bit 271:258 - Reserved */
-				rsvd_1	: 14;
-				/* bit 279:272 - Notification Vector */
+			u16	notifications; /* Suppress and outstanding bits */
 			u8	nv;
-				/* bit 287:280 - Reserved */
 			u8	rsvd_2;
-				/* bit 319:288 - Notification Destination */
 			u32	ndst;
 		};
 		u64 control;
@@ -88,4 +80,15 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
 }
 
+/* Non-atomic helpers */
+static inline void __pi_set_sn(struct pi_desc *pi_desc)
+{
+	pi_desc->notifications |= BIT(POSTED_INTR_SN);
+}
+
+static inline void __pi_clear_sn(struct pi_desc *pi_desc)
+{
+	pi_desc->notifications &= ~BIT(POSTED_INTR_SN);
+}
+
 #endif /* _X86_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index af662312fd07..ec08fa3caf43 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		 * handle task migration (@cpu != vcpu->cpu).
 		 */
 		new.ndst = dest;
-		new.sn = 0;
+		__pi_clear_sn(&new);
 
 		/*
 		 * Restore the notification vector; in the blocking case, the
@@ -157,7 +157,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
-	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
+	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking");
 
 	old.control = READ_ONCE(pi_desc->control);
 	do {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d94bb069bac9..f505745913c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4843,7 +4843,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * or POSTED_INTR_WAKEUP_VECTOR.
 	 */
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
-	vmx->pi_desc.sn = 1;
+	__pi_set_sn(&vmx->pi_desc);
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.25.1


