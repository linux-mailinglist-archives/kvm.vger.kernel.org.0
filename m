Return-Path: <kvm+bounces-51755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D5CAFC826
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC6221726BD
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D58E26A1CC;
	Tue,  8 Jul 2025 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/G4eQ6h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ADF26A1A4;
	Tue,  8 Jul 2025 10:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751969974; cv=none; b=MM4ngw+OfBTDKiYmovpYbvi/KqXd72k7PBH86VYH2+oIJRinjb+hWjq4ktYM8Quo5SsQTrKKo3yfJNtPqCF0dEEBkbo3pKqdad5MjZEWK2rGOvb8YzwaB871bdE4GVRXRwqIJfxN9M+K+Ub4+hMnpe5PglIU6z45xUQTTMs0u0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751969974; c=relaxed/simple;
	bh=nn38075tAi+eJQwAhDFa2ISYv+vJ2ldqeYPIIpu18dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyM8tzg2n9ZwE6VMtqDx3aROpLmM4A3cude9BZPjOeLcfLYqaYZauzP3ilwLebqQflWm4f3AiW9fU9Ii4mzYomprkZ3d+ZZQPi2zR7LlcdRPhikKLTVmk+pUUdinCIcZ8Z7i4/tru36AT/g615TLJkEdQQIfqyJ26/NxWuO+TDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/G4eQ6h; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751969973; x=1783505973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nn38075tAi+eJQwAhDFa2ISYv+vJ2ldqeYPIIpu18dw=;
  b=b/G4eQ6hrdXWF7Im8xG7hyx30FA/clEtr1m8u7Dm6W+mMp2DfFvQ62Gz
   KW7HnHpkMu6WYeGj4x2g+Hp3II7M4y0uMA7RDVvLsd6lVZJwY8poHxa5+
   o/8BNt302injQxul6yahB11QvXDDrErqS+IhNw/VFPlHHhldb6BTbuz7V
   d61hNnzSYfLTLU5xSFXga9R2fGynbM8vwnIdqLox66MjG5n+bFFB9Ep3R
   9NXc3sMqPSP6sCjwW/cshgt+rYheOIhS6RbDCMyGlje0ciNmF+6BXYZNN
   fAOXbIRYF6qfYUbRjKKfALit7fLho2diU6WRzokpAu8XahQDs/inDpeYJ
   g==;
X-CSE-ConnectionGUID: /w5f2oqpQpOX484PbN2fMQ==
X-CSE-MsgGUID: ScXBoL79REeNgStqGrWLmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="76751327"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="76751327"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:19:33 -0700
X-CSE-ConnectionGUID: FcOyMuNXQq2RTSqpkp9aVw==
X-CSE-MsgGUID: vmdEs1iqQB+GoysMHQN7UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="155196379"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa009.jf.intel.com with ESMTP; 08 Jul 2025 03:19:28 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 94A3D92; Tue, 08 Jul 2025 13:19:27 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/3] MAINTAINERS: Update the file list in the TDX entry.
Date: Tue,  8 Jul 2025 13:19:20 +0300
Message-ID: <20250708101922.50560-2-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Include files that were previously missed in the TDX entry file list.
It also includes the recently added KVM enabling.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 MAINTAINERS | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 993ab3d3fde9..8071871ea59c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26952,12 +26952,18 @@ L:	linux-coco@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/tdx
 F:	Documentation/ABI/testing/sysfs-devices-virtual-misc-tdx_guest
+F:	Documentation/arch/x86/tdx.rst
+F:	Documentation/virt/coco/tdx-guest.rst
+F:	Documentation/virt/kvm/x86/intel-tdx.rst
 F:	arch/x86/boot/compressed/tdx*
+F:	arch/x86/boot/compressed/tdcall.S
 F:	arch/x86/coco/tdx/
-F:	arch/x86/include/asm/shared/tdx.h
-F:	arch/x86/include/asm/tdx.h
+F:	arch/x86/include/asm/shared/tdx*
+F:	arch/x86/include/asm/tdx*
+F:	arch/x86/kvm/vmx/tdx*
 F:	arch/x86/virt/vmx/tdx/
-F:	drivers/virt/coco/tdx-guest
+F:	drivers/virt/coco/tdx-guest/
+F:	tools/testing/selftests/tdx/
 
 X86 VDSO
 M:	Andy Lutomirski <luto@kernel.org>
-- 
2.47.2


