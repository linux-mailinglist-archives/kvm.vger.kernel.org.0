Return-Path: <kvm+bounces-13755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4136589A728
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 726C91C21D6A
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBAC1779BD;
	Fri,  5 Apr 2024 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Obop4Ugm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229B1175571;
	Fri,  5 Apr 2024 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356010; cv=none; b=C70Bm2wHgJPChmxKm7yKsRh10FXooRisMGSWiV6XHm4A6jZNRL6FJXkqPJKfQrKV77vJM5/eEetU1TYChpUs9l2AIiTt1xJk+K5N9EB6WAQqLixiNfh2+cbj6wT5AXPDluhvCI+Ik/hbgwe/QlBKH5uDeIZYwu5zmuxmrEtnVFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356010; c=relaxed/simple;
	bh=Okro4Kem0N9Ie4cgbPOty9xrwMq2Uzf6Zhnd6S3vbE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qvu09/oPyU5TfpzqSqDjGcsT3oQ8LqRjWmwBO+9QIn7+xE9o1SNLX0kEZmhbV0G5ntRXqbUgDyg7A/jtXQFN4kfkFEoVxTq+kA7xk5JIjS6p56Keai9DwTgDhJrwlTQFSBYT4RSmluKGwjjfZ9DSMy/onkyxl4+VMtaUznGGLxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Obop4Ugm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356009; x=1743892009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Okro4Kem0N9Ie4cgbPOty9xrwMq2Uzf6Zhnd6S3vbE4=;
  b=Obop4UgmoyuCCkt9SxoQAgSnEiP80nVl2lGiOn55W4uJkVD6cqTiLLvo
   Qd1bwYwhiX8zaWeezOIbUjDK71HzEOSwB2rRc3iP7PPPIKEAWPz7CGDMn
   ICxWn+91TK+bl/igKwuPiFEhBcOql3Fce4Ypi5XWpKmHOijv47IwIPAM8
   SfCAPS4R2wRwlk4+PLPP1gz9cPkZf5DrT9ycoa9n453yGrLG/zy+hixYD
   jjCR4EGISJ8sP/y0zDXEzzUfGZC/C1ZaBuBI6o/gw8ti8Wrn+LZkBWkEO
   Lz/ZNgLh3917mq6QTgr7nDq998zP/JMO8F06UK7CQMcDpbsYJ2HT2JNJ9
   A==;
X-CSE-ConnectionGUID: l6Pnn+JBTlS6bBEc2rPKdw==
X-CSE-MsgGUID: gdWwNhilRsev0DBlM/2O7w==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062702"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062702"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:47 -0700
X-CSE-ConnectionGUID: 1HXxumqzT42vJ5sjlMnWsg==
X-CSE-MsgGUID: zUxrBdZ5ReSw612yNtf9Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928314"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:46 -0700
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
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 03/13] x86/irq: Remove bitfields in posted interrupt descriptor
Date: Fri,  5 Apr 2024 15:31:00 -0700
Message-Id: <20240405223110.1609888-4-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mixture of bitfields and types is weird and really not intuitive, remove
bitfields and use typed data exclusively.

Link: https://lore.kernel.org/all/20240404101735.402feec8@jacob-builder/T/#mf66e34a82a48f4d8e2926b5581eff59a122de53a
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2:
	- Replace bitfields, no more mix.
---
 arch/x86/include/asm/posted_intr.h | 10 +---------
 arch/x86/kvm/vmx/posted_intr.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c             |  2 +-
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index acf237b2882e..c682c41d4e44 100644
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
+			u16	notif_ctrl; /* Suppress and outstanding bits */
 			u8	nv;
-				/* bit 287:280 - Reserved */
 			u8	rsvd_2;
-				/* bit 319:288 - Notification Destination */
 			u32	ndst;
 		};
 		u64 control;
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index af662312fd07..592dbb765675 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		 * handle task migration (@cpu != vcpu->cpu).
 		 */
 		new.ndst = dest;
-		new.sn = 0;
+		new.notif_ctrl &= ~POSTED_INTR_SN;
 
 		/*
 		 * Restore the notification vector; in the blocking case, the
@@ -157,7 +157,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
-	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
+	WARN(pi_desc->notif_ctrl & POSTED_INTR_SN, "PI descriptor SN field set before blocking");
 
 	old.control = READ_ONCE(pi_desc->control);
 	do {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d94bb069bac9..50580bbfba5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4843,7 +4843,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * or POSTED_INTR_WAKEUP_VECTOR.
 	 */
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
-	vmx->pi_desc.sn = 1;
+	vmx->pi_desc.notif_ctrl |= POSTED_INTR_SN;
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.25.1


