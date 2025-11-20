Return-Path: <kvm+bounces-63768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DB1C72364
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 05:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 522C4350886
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 04:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF034305946;
	Thu, 20 Nov 2025 04:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ESre/qzY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32532D9EF3;
	Thu, 20 Nov 2025 04:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763613960; cv=none; b=sRdUzLqAgdZKrsG4jxejI6GZ1rluDBkvtd4G8JoX5NAhX7opFUO0vN9FfnXGNyyxKjRK8qLKKJHUptoqhMssJYukb+LSUUBWFYI+tfaat/R6c+f8nNuRA8rDOcmB+uDxv0UzmzKySL0lZaFVts3Szm5gLBB4ak7X6YMUoBH/uMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763613960; c=relaxed/simple;
	bh=w8Tu4inGfpwswUZgjcbvB2Bnrfq+GXEbO3XQOBEJAd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cXGlKcjH+Hk+JhDtamppweoFj2+1DKbpE79E9BbovvXxqsSEwvmJHH6pXjIbrOOGjBW0MkOcuvUO1F9+Zoy8hh6zaC/c6/1bPHSRnljHOCd+Ju0mmBJCpdIFoXoV9ga3txd0WzGayQhPuX1BAN83fwIyZTleA1/6TGY90cVbzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ESre/qzY; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763613959; x=1795149959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w8Tu4inGfpwswUZgjcbvB2Bnrfq+GXEbO3XQOBEJAd8=;
  b=ESre/qzY1wPi/z3cP6Ih6xMdNxhlhdoqnKg7zGAEoHPhAE6O781tyVWL
   EwLh8biFosP7U1zQsXZnQELUV3sFCBwcPKEptNp30/sMlFAcuavQMPaga
   v5WTp8+Amhe9mCON01Ug5R8dK4noGHPr3s3JdOTyFZ+pcBk7IOVjPVVxW
   Zr4Yqk0GSrNN8WVbcX0ShC+8TIJm8qrNFMb3FxwzfeGQE2kf8oxN/1i3M
   5zcrzYhAwEWiv47Sxx9fFLlMT4ZOvNm9UoWbukK7a1vyMClERR0SVQMo5
   c2cXnLmbUTw+sZY3cfA+TMc3ZcSUGF2LdHZ2MfeOXcfufeg0nLq7DYI4t
   g==;
X-CSE-ConnectionGUID: s49qjLa4SmOK4DoEGyaYkg==
X-CSE-MsgGUID: Y2f+wu39S4axiOq/Ts08dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65602274"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65602274"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 20:45:58 -0800
X-CSE-ConnectionGUID: U/LEDpKfQV6kXFqClgHJvg==
X-CSE-MsgGUID: Y+Zu6GKOTcKGSOI8bGo0Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196380889"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 19 Nov 2025 20:45:55 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 3/4] KVM: x86: Advertise AVX10.2 CPUID to userspace
Date: Thu, 20 Nov 2025 13:07:19 +0800
Message-Id: <20251120050720.931449-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bump up the maximum supported AVX10 version and pass AVX10.2 through to
the guest.

Intel AVX10 Version 2 (Intel AVX10.2) includes a suite of new
instructions delivering new AI features and performance, accelerated
media processing, expanded Web Assembly, and Cryptography support, along
with enhancements to existing legacy instructions for completeness and
efficiency, and it is enumerated as version 2 in CPUID 0x24.0x0.EBX[bits
0-7] [1].

AVX10.2 has no current kernel usage and requires no additional host
kernel enabling work (based on AVX10.1 support) and provides no new
VMX controls [2]. Moreover, since AVX10.2 is the superset of AVX10.1,
there's no need to worry about AVX10.1 and AVX10.2 compatibility issues
in KVM.

Therefore, it's safe to advertise AVX10.2 version to userspace directly
if host supports AVX10.2.

[1]: Intel Advanced Vector Extensions 10.2 Architecture Specification
     (rev 5.0).
[2]: Note: Since AVX10.2 spec (rev 4.0), it has been declared "AVX10/512
     will be used in all Intel products, supporting vector lengths of
     128, 256, and 512 in all product lines", and the VMX support (in
     earlier revisions) for AVX10/256 guest on AVX10/512 host has been
     dropped.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Reference link: https://cdrdv2.intel.com/v1/dl/getContent/856721
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0795c9ecfd4b..984fbee2795e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1655,7 +1655,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * is guaranteed to be >=1 if AVX10 is supported.  Note #2, the
 		 * version needs to be captured before overriding EBX features!
 		 */
-		avx10_version = min_t(u8, entry->ebx & 0xff, 1);
+		avx10_version = min_t(u8, entry->ebx & 0xff, 2);
 		cpuid_entry_override(entry, CPUID_24_0_EBX);
 		entry->ebx |= avx10_version;
 
-- 
2.34.1


