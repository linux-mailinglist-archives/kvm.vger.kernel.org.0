Return-Path: <kvm+bounces-61415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC90C1D0C9
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D29B24E11E4
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 19:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D7E35A92C;
	Wed, 29 Oct 2025 19:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lnhLNvxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A73C3559D3;
	Wed, 29 Oct 2025 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761767314; cv=none; b=dMFWcpNXamNorUSGilOgyRHtFNuIXLN8N/hffzcZFXSm0iQ7AMHrnylHPU8S4cMarT15vHjza+Qg+vu82bN7WOkjNcgmH8UKud9Gns1sRPRoEtggzPJ5zqcf0TPyNp8Kxg2KMq+cWhb6ju/fQWW00SOmbcYeHBb8u+w58q8UO/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761767314; c=relaxed/simple;
	bh=AR55SmcxInH1hFzXQ0gFHJEEZbRwB8+9WmoT1FQ5ftU=;
	h=Subject:To:Cc:From:Date:References:In-Reply-To:Message-Id; b=Sa/tPWLjXdydEZoomOVr+m4fb68GfIGS5tUvpaK+TkMmelX8QXb7sxhPQSC+bANN37DzEfUI1i3cjrvuIeSllf446+9fWE9w0yQ0LuJyZVcv9d0LOLTCSod2mqoI58aqW24aBN6tS3xRpWNyIz/8TbgEpzQCL9M6mUF5wFRZ//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lnhLNvxZ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761767312; x=1793303312;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=AR55SmcxInH1hFzXQ0gFHJEEZbRwB8+9WmoT1FQ5ftU=;
  b=lnhLNvxZdULv/N7Fh1yRRCGqSOWI4yVpMqzW/eZ6GXwX/7Rc23fXpqap
   5CqoDHu/+iejOABbYOhpM4gvuzACFH5UgPB+OEEZfR/qoSc2v5mH4t5QJ
   fxkltJHQiLhKbvHMyKym5onyrddW2+lNs3k+/qkBTlHLuLXryC3iIwdni
   pZYdimsk3Q0LIoSwn2r+3KVvaGtguDO2Gq+iBlkCMm1HZeEIVmESQUkWm
   ntRNCPRhwFMjlufLrFCrIpHEGJkizc89Vqdxr8QBty/J70rYJ3wi2a1TQ
   FQp4pDcokDdZYXaPjiVBq7rE60bOSRggRFBRYktFmNAcYmz47sHTyA9JM
   A==;
X-CSE-ConnectionGUID: 3sr32rRASjKlQdz+czN/oA==
X-CSE-MsgGUID: sxYVhi5PR16BEybAA7wfmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63784403"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="63784403"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:48:32 -0700
X-CSE-ConnectionGUID: Z1YrDQY9RTS/iEshx5ngsQ==
X-CSE-MsgGUID: P9iBDSBBQyyQ/7x1o5ExpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="186207812"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa009.fm.intel.com with ESMTP; 29 Oct 2025 12:48:31 -0700
Subject: [PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel pointer
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Oct 2025 12:48:31 -0700
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
In-Reply-To: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
Message-Id: <20251029194831.6819B2E7@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

There are two 'kvm_cpuid2' pointers involved here. There's an "input"
side: 'td_cpuid' which is a normal kernel pointer and an 'output'
side. The output here is userspace and there is an attempt at properly
annotating the variable with __user:

	struct kvm_cpuid2 __user *output, *td_cpuid;

But, alas, this is wrong. The __user in the definition applies to both
'output' and 'td_cpuid'.

Fix it up by completely separating the two definitions so that it is
obviously correct without even having to know what the C syntax rules
even are.

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

 b/arch/x86/kvm/vmx/tdx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3 arch/x86/kvm/vmx/tdx.c
--- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3	2025-10-29 12:10:10.375383704 -0700
+++ b/arch/x86/kvm/vmx/tdx.c	2025-10-29 12:10:10.379384154 -0700
@@ -3054,7 +3054,8 @@ static int tdx_vcpu_get_cpuid_leaf(struc
 
 static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
-	struct kvm_cpuid2 __user *output, *td_cpuid;
+	struct kvm_cpuid2 __user *output;
+	struct kvm_cpuid2 *td_cpuid;
 	int r = 0, i = 0, leaf;
 	u32 level;
 
_

