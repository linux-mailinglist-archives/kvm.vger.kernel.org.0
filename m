Return-Path: <kvm+bounces-61416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88FE6C1D0DB
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1818426DD5
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 19:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A4E35A926;
	Wed, 29 Oct 2025 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kEYFrZTB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE5535A152;
	Wed, 29 Oct 2025 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761767316; cv=none; b=kKokHtmuq2EjV7yb/YdniA0Oi69eMVORiGGO1YMLOn309LgdwKS1qaPRXNEGQ+niatt/kVjSH8IcCmJnH8MYFUpVac1VJR6h5GVZHcJ4VnpDPcYis5l6OeK0Fg/RjgeKDQLDCmbIxK3x+keOe7HmFHyFZuLMR2gYh3eyaQuLqE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761767316; c=relaxed/simple;
	bh=kbxokVom77TxD0XZvHYT3zU97pIM2xz5qGfZI3N3A/g=;
	h=Subject:To:Cc:From:Date:References:In-Reply-To:Message-Id; b=Bwcebe53PVx6sKCUunkvZ1Po6YrUl/C+3KO1a3IYbavumgKF/C0s5HFxevJ+17ZSkPvTyj9Q4Kx/fYdOIE7ke1Q61jY98gBA0dI85AhPJIr7noHe46qBRHtJvgjwHEB9xPDdll4L0wlEb3VKeyPA9BZsV1jldiSmKCAB8mfOAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kEYFrZTB; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761767315; x=1793303315;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=kbxokVom77TxD0XZvHYT3zU97pIM2xz5qGfZI3N3A/g=;
  b=kEYFrZTBJfslZAa+BVoBJi22aQKYQmxLQWxFo/buivS1ZEan8rP6qnRx
   sxJn+YsJW5mjzyPJq1vSFCYFh36sOWxqhCyCQHUPONk+dLmjEbtn8R1Sw
   ZSnQ4IFEKvEmL8x5+Nz1J4oXbZU+kbnq4y1PxrF69cn98iPfmG4wBra8f
   e8GeuzZ8Og8Aq4Z02ryqgWZsAh2yYbcIKzaLkzknt1H2PGMUYd0yXE7Ch
   C154ZT3aYbUtCkbCEef6OllD7mgw5SQIN+Lzu+0vBnN4Aqevbj3UIZpVJ
   L8Y56W/4Hgoj7tZO4SzIYNe5sjuJqWPIs+wuRiMJadXrfvfJhFvXkwj70
   w==;
X-CSE-ConnectionGUID: N5x7wBx9RJO6e7zsGsK40Q==
X-CSE-MsgGUID: qzO7W9hIS0CLfHzgGOa9/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="66516736"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="66516736"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:48:34 -0700
X-CSE-ConnectionGUID: HjafAFvfTvKn3A+bYU81ZA==
X-CSE-MsgGUID: k+90iyK5QROiFxD5DP/7iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="186500562"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa010.fm.intel.com with ESMTP; 29 Oct 2025 12:48:34 -0700
Subject: [PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0 for NULL
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Oct 2025 12:48:33 -0700
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
In-Reply-To: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
Message-Id: <20251029194833.A20A7907@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

sparse moans:

	... arch/x86/kvm/vmx/tdx.c:859:38: warning: Using plain integer as NULL pointer

for several TDX pointer initializations. While I love a good ptr=0
now and then, it's good to have quiet sparse builds.

Fix the sites up.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

 b/arch/x86/kvm/vmx/tdx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1 arch/x86/kvm/vmx/tdx.c
--- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1	2025-10-29 12:10:11.114466713 -0700
+++ b/arch/x86/kvm/vmx/tdx.c	2025-10-29 12:10:11.119467274 -0700
@@ -856,7 +856,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu
 	}
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
-		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_page = NULL;
 		tdx->vp.tdvpr_pa = 0;
 	}
 
@@ -2642,7 +2642,7 @@ free_tdcs:
 free_tdr:
 	if (tdr_page)
 		__free_page(tdr_page);
-	kvm_tdx->td.tdr_page = 0;
+	kvm_tdx->td.tdr_page = NULL;
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -3016,7 +3016,7 @@ free_tdcx:
 free_tdvpr:
 	if (tdx->vp.tdvpr_page)
 		__free_page(tdx->vp.tdvpr_page);
-	tdx->vp.tdvpr_page = 0;
+	tdx->vp.tdvpr_page = NULL;
 	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
_

