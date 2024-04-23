Return-Path: <kvm+bounces-15696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A65608AF59C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BC1E1F2554E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F02D13E02B;
	Tue, 23 Apr 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwVaoooG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C613DDD4;
	Tue, 23 Apr 2024 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893803; cv=none; b=oS+6z86IBYDZetqhhWx1TkhF86MwX0KqHK8GbVG9zFjZjiDVviBkKzT6miK0dnG4VpAC7EiwI5XIe0cV1OawwgutUw2UY7tR2yhbDtHht/CSVbAgaUL1taY6F1gEdVZhJMg3GP16ghWbBiQNA8WI71b+a5qsCM2Cgos6XhKRfKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893803; c=relaxed/simple;
	bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CuWon4luK7JRiOgqo/uYhfgHRqZPnPAjMJahjvSSCGc3Px6+QWTb5EMlv/Ir69CKVnqYeTm3rJPQyuk+M4YK978XbGAU5K/gGK6bZmJscPYTXqZgcSR1Mui+xCw0pm2w9Cd5hCM5XY76BBCAx4R7hWsrNJI+UntU9S/If15h1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwVaoooG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893803; x=1745429803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
  b=CwVaoooG56FuJnEgd2lSdWMHHkjj3UTX48xCzVZlI+bqqXLy25QBlHJ+
   yDj3n9c3bQrqkGVovTFZGFZ0Nph7kk/f15cB3YGUNP7eYqlbdTjNdv5lb
   /ogse5j+dV4vDsCCjCh/+s6NznEbGJNOMo8PCPmyOMn40jzu0NY3W45HR
   agH6vblLeb2g8Dk5cQgpGoitUPbwgkwzOKehCBos6uFaFuSxljNbvvuA7
   oe3AoJxh1fL4LSltz0Aq4JA5tx/pkZQD69qmyP4uOCJuSIdH7gBID/WkN
   Se0VNl+6x6mxvUWgjxSYeTSL2txs5oQpt6pdGW4EpevYSCxMfKKlCLs++
   Q==;
X-CSE-ConnectionGUID: lJp+rtJURkWP1Ry4MqOeJw==
X-CSE-MsgGUID: vE9bghDSQ+aGbFrI3lS/4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712310"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712310"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:40 -0700
X-CSE-ConnectionGUID: 1XBh1OYvTD60c3BFWsG2bA==
X-CSE-MsgGUID: hdr0CBwaTRaCrNAxFNyDQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097381"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:39 -0700
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
Subject: [PATCH v3  02/12] x86/irq: Unionize PID.PIR for 64bit access w/o casting
Date: Tue, 23 Apr 2024 10:41:04 -0700
Message-Id: <20240423174114.526704-3-jacob.jun.pan@linux.intel.com>
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

Make PIR field into u64 such that atomic xchg64 can be used without ugly
casting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index f0324c56f7af..acf237b2882e 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -9,7 +9,10 @@
 
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
-	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		u32 pir[8];     /* Posted interrupt requested */
+		u64 pir64[4];
+	};
 	union {
 		struct {
 				/* bit 256 - Outstanding Notification */
-- 
2.25.1


