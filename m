Return-Path: <kvm+bounces-6808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC99E83A34C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A535E1F2B0CA
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E105917C73;
	Wed, 24 Jan 2024 07:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQeBfOXp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54817C60;
	Wed, 24 Jan 2024 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706082101; cv=none; b=CxtDyvkHBkPjmTR6Q47e1gemKFP7AWmgFCQ6yqLGTXbWE07MCfhwqeL0XYvJ5edmuhqhIXZWE/pZNPkX2VMhc69f5CRtgtatGpVHUsZ9k2nOmonHoO1LEc5PV6ztqoDLrYRJ2z62KErpt/yWRgT80SsdRKsoikD/0l+u93/+3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706082101; c=relaxed/simple;
	bh=SvyQgb7E1GjbbhEZauDFduuMMCCNLr60ulcJzDeIqyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHg54yyecq70Lp31bL/Aw0ig1xUSRivNtNN7HdnOm67TrRPjRVs4k8KQTFfAQaPnwOepDbIDw2CWUPqf6Mg0+Ap+DMnGgm0Qi68SiGrmTqAjQRa77N7hQYUTN/kqvIw2hxh2PH+Mh/nOB5mwJZXApv02xWkPTUgvYVpJzqwOSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQeBfOXp; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706082099; x=1737618099;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SvyQgb7E1GjbbhEZauDFduuMMCCNLr60ulcJzDeIqyo=;
  b=fQeBfOXpgulKL5uuywMmcqcd1ze5YRI7vhFXWBWd+M8kMKU0yEhRUdbc
   v0nH+Wdj94+55J3KiC5PT+3nJdH2h3EZR6QP9AH4SBXmahj26MseVmC3f
   sTrd0ErSXdDaN1rc0TecjMrepoM0VmhUJkfxGt+tE+oVyXJEM/mPrMbc0
   rox1aSI3v98cYtGvnmTKwzoXUcUO9EPrch/UdY8CyE08E8u9ae13ZDj0e
   +rpQMqPWbUOn4BmULmX0PxIv88PTG0vBkFlnSetlq+Y9oZQAwg6+ch0Aq
   2XJ3YM7JAQHP+N7WclzcDxzTNnKgAzN7mlJpN2IFUKq8yacjkcDxrtO7w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="392184505"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="392184505"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 23:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1819066"
Received: from bbaidya-mobl.amr.corp.intel.com (HELO desk) ([10.209.53.134])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 23:41:37 -0800
Date: Tue, 23 Jan 2024 23:41:36 -0800
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
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH  v6 3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <20240123-delay-verw-v6-3-a8206baca7d3@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

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



