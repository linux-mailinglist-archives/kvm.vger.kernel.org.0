Return-Path: <kvm+bounces-64760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 448D0C8C2B1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B06333B34AD
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F7A342523;
	Wed, 26 Nov 2025 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTzOuSZN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79D2335553;
	Wed, 26 Nov 2025 22:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195313; cv=none; b=PmRLynxvD4+H8UqBo8NHMUROT+bt6k7rYFdlkAhlbG3VySUSiAo/DDmbqP5eFzdm08JC+JZaEo/iPW3d1AqjJqcw2kCDluNC011o1bdz3iqyYTDVMTUq8zSwg8oSY3rsQkIywqG/pI1iUFQ8ND004mPXZnCh1swi4IHyYk2tqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195313; c=relaxed/simple;
	bh=uvnGpQRlH4kUe+UMY9Z7043UmlnpQaipVyk2PoJ88MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U40PzXfOsoZVBpOMUi7uurO1hTRYxIKsejC8FeKPT56872JrCRkckYddJ3e/QB9WN+7tz3L5xIdgVrCBSk15jjdFXh1udvujLf3/x+5n2/Jdna7ZxD+OQfM2a7/Kh6Hs3xmbbKOL2z9zgNoFpZYZP2wQnFHKD/2nhngp3g+SNw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTzOuSZN; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195311; x=1795731311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uvnGpQRlH4kUe+UMY9Z7043UmlnpQaipVyk2PoJ88MY=;
  b=YTzOuSZNz0pyMas8n7CMK2TBGe3uQ9OKxhDmCYYN24TTGVnB1qZLftpO
   wWKcRgkGVelZZ3r3jW07kxmIh0JOH1SqgMlrSWeBqvnxYCl+BQi4xyZUU
   jZPS6mZWdd00ONEw3fKt7/7nLb6dhPAafebCyY7Zv0KTVNIr0EldZDDCI
   epqHTwIxJUbxt5Pm4cyi61/r7QL5AmOWSe9LX5MSNgA/2TgWKIqEXECoB
   kqHkQesXeDaHoVobv2cVQX/pwS2SCFslo6zQgmNpHMgOnAASRFECFP3Ez
   Xignm6b4/66dC4ygGC5cCS8rlvcSw3zFyOcLyL2ykCwcqpGo8wNQqudVc
   w==;
X-CSE-ConnectionGUID: zUroRF/qQAC/Uk4lkIoBiQ==
X-CSE-MsgGUID: cB6XhBzSRpGYFtP1aw7cng==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="69865142"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="69865142"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:10 -0800
X-CSE-ConnectionGUID: SBhnNyY9RNa/PelLOXwkaQ==
X-CSE-MsgGUID: a82UF0RmRASvyd4aSApCRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="197217948"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:10 -0800
Date: Wed, 26 Nov 2025 14:15:10 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v5 2/9] x86/bhi: Make clear_bhb_loop() effective on newer CPUs
Message-ID: <20251126-vmscape-bhb-v5-2-02d66e423b00@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>

As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
the Branch History Buffer (BHB). On Alder Lake and newer parts this
sequence is not sufficient because it doesn't clear enough entries. This
was not an issue because these CPUs have a hardware control (BHI_DIS_S)
that mitigates BHI in kernel.

BHI variant of VMSCAPE requires isolating branch history between guests and
userspace. Note that there is no equivalent hardware control for userspace.
To effectively isolate branch history on newer CPUs, clear_bhb_loop()
should execute sufficient number of branches to clear a larger BHB.

Dynamically set the loop count of clear_bhb_loop() such that it is
effective on newer CPUs too. Use the hardware control enumeration
X86_FEATURE_BHI_CTRL to select the appropriate loop count.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 886f86790b4467347031bc27d3d761d5cc286da1..e4863d6d32178f628d994edc06ed6d591916b390 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
-	movl	$5, %ecx
+
+	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
+	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx;",	\
+		    "movl $12, %ecx; movl $7, %edx;", X86_FEATURE_BHI_CTRL
+
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	%edx, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax

-- 
2.34.1



