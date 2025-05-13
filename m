Return-Path: <kvm+bounces-46293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A92EBAB4C9E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40BE617F048
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5361F12F4;
	Tue, 13 May 2025 07:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvIbtQWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632091EFF89
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120988; cv=none; b=WWBZH0846w0cBfFdvC3kw8O6vN8mwl9eU/B9gF92MgjjDxZe71biObYSAmSylqPS9ejM+hKEDG4gpz08adZXvONg/C8DcvPDuCljBCXxPOSmjj9z+46w1stgjnSlrelqZGl6Yg/T15DoMsVYJ/dDAZ+XlSrYRPSU7l/6gJ1S4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120988; c=relaxed/simple;
	bh=V7PpJ4+zGbCZLMzELm1q6RPA4Fy/29Sz6RKz7+vfTm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb3FfQqEaqF7x1r3jsnB62Z7tuqqqyqGxXjYYqIrXommbQU08UthmL0v29cArfnQtm2iC0bTzGjTdszCgXUqqJF0m3rarIGK/tWsxIn+Bffz7+bi4po/pgPoFv1u1U3WopdaKUrv7sGkFBUFPBmYP/XLorDhGZPOajZsGDEBYyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvIbtQWZ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120986; x=1778656986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V7PpJ4+zGbCZLMzELm1q6RPA4Fy/29Sz6RKz7+vfTm0=;
  b=gvIbtQWZMf9LimXhgskWvf8fRP5chk/y2wHOALXByFe4ojq+ukGHHSGp
   96aLws79BpTqz47pLbnYZ7VlMNAyZ6Z54J1AMtHhQ/BuQWe/HpAFzi8Bt
   WYp7/3OgrcRKJIF7Wz3EO/Kbm7Qu3glVbYMlgEq9nWKatg68a/O7shvLW
   Pnt/xxdAr2xf2pEHGr97GU9rfKXuqk3s41vDhU2F89vQ5FMNUbJJimYPn
   uB7cxj7EVpu31Fo9ooD7+OZr34a3fjlAavHjDO/AvZw8pogxFQCWU2RCR
   UwdJq1AAvmdhPl6M8+MnbSZ9Sw4WBpNspRxN5LGR2Odm7iacQVqvc89Tk
   Q==;
X-CSE-ConnectionGUID: +FPajxAZQYSwNzwbJmSCOw==
X-CSE-MsgGUID: MZ25GEgAR6GboiogP70eHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941003"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941003"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: 7b7Owt5yQZSwsLDhsiD8iQ==
X-CSE-MsgGUID: KKDUJo8tQW2m/I+5vUuM4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740601"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Yang Weijiang <weijiang.yang@intel.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 1/8] x86: cet: Pass virtual addresses to invlpg
Date: Tue, 13 May 2025 00:22:43 -0700
Message-ID: <20250513072250.568180-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Correct the parameter passed to invlpg.

The invlpg instruction should take a virtual address instead of a physical
address when flushing TLBs. Using shstk_phys results in TLBs associated
with the virtual address (shstk_virt) not being flushed, and the virtual
address may not be treated as a shadow stack address if there is a stale
TLB. So, subsequent shadow stack accesses to shstk_virt may cause a #PF,
which terminates the test unexpectedly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc..51a54a50 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -100,7 +100,7 @@ int main(int ac, char **av)
 	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
-	invlpg((void *)shstk_phys);
+	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.47.1


