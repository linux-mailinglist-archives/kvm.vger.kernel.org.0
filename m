Return-Path: <kvm+bounces-7968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4268849459
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22244B23A52
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FE910965;
	Mon,  5 Feb 2024 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X2U5DYlS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C80112E67;
	Mon,  5 Feb 2024 07:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707117576; cv=none; b=Ax5CNt98txIAcQquYJTdwr4E6cUWFxFGwTslySLpm6BXb2/Ncrw3tBWyTrNs6kk1zBwGTa0t/cP4OxxfcJX8er2xNZdHlz+bMHJJFwM5+Y5nsjZFUhSYXIXbFwVupVMcWryjkriWoISAteZgWp8JBn/LW+PF/JTG82DglwUPrQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707117576; c=relaxed/simple;
	bh=dzS0jKsh4MjJhp4dlQ/PUGxlDxqVg59HNWjd5mlmtng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kw7HMHBLDyGUQYKGr277sC6c0AVlAfoDXkZVofcg14ZhfFojW4OmeE7kBcZiZNkjUgK6/6g4EL+G8eZTHdA02pGw1y3G4wOvi//grMTZmPMMNTTeX3tN9+iC1zmUVnbIeTMUq0W5IVOLuYf8ilMFuEcQaUQJ7j+XdJtAhMVa5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X2U5DYlS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707117575; x=1738653575;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dzS0jKsh4MjJhp4dlQ/PUGxlDxqVg59HNWjd5mlmtng=;
  b=X2U5DYlSVRrpIiW8SBbfsD6e6/u2ABLPRUu5SJxlxGW1/ztuECSuMBJV
   ljjvGjecqWY8S6F2sHInMcrxYVx5PRRi03aNYHzvPgwE4wRqqJUiTXUIv
   f05HOf7Iaj/fAKv6FoERFVP29nHktqhJP9OX+w4frhMIls2YFlY3vYEhk
   a8SRgfvwqYC4uCg9AEX+4dLvaxf2BfBceN0T6IORsKty57ygvxhkGbeGq
   euFVKYNpW0DiVZUfqLmmom9qENUHWLUXAdhAHUBNp2DWV9LmBH1ZgXt/t
   2hSFrkFhn4QGqChuHErfOmzAOe7JiYECBz1DOou97Oe+xr6cVnI0MRNXI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11823041"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11823041"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:19:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="31442994"
Received: from tdspence-mobl1.amr.corp.intel.com (HELO desk) ([10.251.0.86])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:19:33 -0800
Date: Sun, 4 Feb 2024 23:19:33 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, stable@kernel.org
Subject: [PATCH  v7 3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <20240204-delay-verw-v7-3-59be2d704cb2@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Cc: stable@kernel.org
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_32.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index c73047bf9f4b..fba427646805 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -885,6 +885,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -954,6 +955,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1146,6 +1148,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:

-- 
2.34.1



