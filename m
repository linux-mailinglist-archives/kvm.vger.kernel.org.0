Return-Path: <kvm+bounces-8649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CDB985417D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 03:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A43F28DC4C
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 02:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024A0C2D0;
	Wed, 14 Feb 2024 02:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnH/c9o+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B061DBE48;
	Wed, 14 Feb 2024 02:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707877331; cv=none; b=L6RPPfyEKyyxisMyZ6TDq8BEd9gcEpPadF0Eog3LEjURMEmU/cMhntNn6hscf+MY0rqzl3XnupREWEgF3nXbWQO6etO/jFYoNlMQy84QsR8ezxWm4ZCvjykAMG5MQmnsRL19KaqS1AZ/iNnGTYdMbjZ7+KTk6WZoLz1AMkCmtw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707877331; c=relaxed/simple;
	bh=rWRFdEOwJ9VATethxyyPtZVSQTxJREjdJD4RCKAgKSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNMg+Ej8CI0aR33ibC975oAtR89WI25qAEzAcP3iRLW7ZGvK8chfpeyKsdaDa+zVclEU15FMlG3OYWttlx1joHmzs+hPSar/0zF34KNNI2g67ZZJzLHmACzjfSAwJrghe5FnUOPXi2LlWa3oL65ROt/hXNxhbzc/nNo1aV60vIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnH/c9o+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707877329; x=1739413329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rWRFdEOwJ9VATethxyyPtZVSQTxJREjdJD4RCKAgKSo=;
  b=BnH/c9o+sfWSpPjiF3oHxAALqjiHB9jrBK0zzE6sNT6HgguYNHq0kYRT
   Wm2FUQ8WP7rEPnHNe8XtT0BB+1Vtb2o4KdhafcDL1k74p/GarmjLfCvCy
   gzGabcGNq0CR3btwz9jPFDz6VzxdPWt6Pjnv4GRLQRY7m+O6zvOwMC89X
   z3UWmFqFiKge1RO+xU7TepYBZgx8mU/K0bZ8cLNMMh1/Sh6YeiQGLqjWs
   QhoqFrvaGCUDvPX/NsyL9txFH0irdEDwMi2tisHyjq6S6Zny1FrMwcM9M
   ZNldme6qpIk7Dnasbx+8NEE5RN4NEkQagMoH8Mln8sYXHrubcQnQJyPa4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="2058739"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="2058739"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 18:22:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="3417034"
Received: from diegoavi-mobl.amr.corp.intel.com (HELO desk) ([10.255.230.185])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 18:22:08 -0800
Date: Tue, 13 Feb 2024 18:22:08 -0800
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
	antonio.gomez.iglesias@linux.intel.com
Subject: [PATCH  v8 3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <20240213-delay-verw-v8-3-a6216d83edb7@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20240213-delay-verw-v8-0-a6216d83edb7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213-delay-verw-v8-0-a6216d83edb7@linux.intel.com>

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Cc: stable@kernel.org
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_32.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 1b0fe4b49ea0..d3a814efbff6 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -881,6 +881,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -950,6 +951,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1142,6 +1144,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:

-- 
2.34.1



