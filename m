Return-Path: <kvm+bounces-6807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2370C83A345
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4860C1C26560
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E96217BB7;
	Wed, 24 Jan 2024 07:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKZM/FvW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEFB17BA3;
	Wed, 24 Jan 2024 07:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706082084; cv=none; b=r+mxDwKkP/f6oSd8QT1reuB5qcBobaDa0rIDD3hkkoPp272QyJ5spKOfhWkjc1nmtdnO9ppCd4xIqOIVf7/4O9wEp25n4DHRBkOdKaAKpgeLvhsPWLSxo9wkX70hjw5QRXu7kMDOO3h8YKE1xmQXPLa9kEDSOGZP4YypoMmBnNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706082084; c=relaxed/simple;
	bh=u0ACNJnmCWkNPcbKiCWkDdCakrm+/qCMT4yvny0P32Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnyNIY57o3VTHu3pxATcr+AaksFF8jd7OHH7IQCLRQEP3Rv8S4A6bkh95s/KiE2KvktngPeDT3//UXZBpvlZ5iwv5jhSQdSGGHf9X0zrqAKHHfCNbhc9E09iEhqMDOV8zuCulIaSgBSuC+Y9rzY+KmawR7PyZ6YGmQt77oX/W0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKZM/FvW; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706082083; x=1737618083;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u0ACNJnmCWkNPcbKiCWkDdCakrm+/qCMT4yvny0P32Q=;
  b=cKZM/FvWr4tmH2AYAFE7/g3eMWmAPLBfiQEYtiK+JBGjQylCFmyMV+A/
   6OVAQ1KSK2kEeUOFRoEontXuB3bRrMe+OB2yHL38EVvGZofIIIUonyIFO
   sHq9363a7yDlLMWp+FFlNlznDuzyG7xAMmHiJCiP1e5kn8W/cRx6kPeYC
   d9Ql3gLdGklg2gOvs6KRax54fhXoL0gtSOLOKOBJPpkk9vyljFfCeYmWM
   oPJJCpOokPV80N0N57p1xqXZi3tclvhFW6ApkRN/++bZd+9Nx8/YFQmlv
   1Se8yFVQuEvuJ51hby3hNP17Q4zsot8vnMpzk6uUZPN37TrORilhq56ql
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9156924"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9156924"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 23:41:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="905514749"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="905514749"
Received: from bbaidya-mobl.amr.corp.intel.com (HELO desk) ([10.209.53.134])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 23:41:18 -0800
Date: Tue, 23 Jan 2024 23:41:17 -0800
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
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH  v6 2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20240123-delay-verw-v6-2-a8206baca7d3@linux.intel.com>
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

Mitigation for MDS is to use VERW instruction to clear any secrets in
CPU Buffers. Any memory accesses after VERW execution can still remain
in CPU buffers. It is safer to execute VERW late in return to user path
to minimize the window in which kernel data can end up in CPU buffers.
There are not many kernel secrets to be had after SWITCH_TO_USER_CR3.

Add support for deploying VERW mitigation after user register state is
restored. This helps minimize the chances of kernel data ending up into
CPU buffers after executing VERW.

Note that the mitigation at the new location is not yet enabled.

  Corner case not handled
  =======================
  Interrupts returning to kernel don't clear CPUs buffers since the
  exit-to-user path is expected to do that anyways. But, there could be
  a case when an NMI is generated in kernel after the exit-to-user path
  has cleared the buffers. This case is not handled and NMI returning to
  kernel don't clear CPU buffers because:

  1. It is rare to get an NMI after VERW, but before returning to userspace.
  2. For an unprivileged user, there is no known way to make that NMI
     less rare or target it.
  3. It would take a large number of these precisely-timed NMIs to mount
     an actual attack.  There's presumably not enough bandwidth.
  4. The NMI in question occurs after a VERW, i.e. when user state is
     restored and most interesting data is already scrubbed. Whats left
     is only the data that NMI touches, and that may or may not be of
     any interest.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S        | 11 +++++++++++
 arch/x86/entry/entry_64_compat.S |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index de6469dffe3a..bdb17fad5d04 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -161,6 +161,7 @@ syscall_return_via_sysret:
 SYM_INNER_LABEL(entry_SYSRETQ_unsafe_stack, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
 	swapgs
+	CLEAR_CPU_BUFFERS
 	sysretq
 SYM_INNER_LABEL(entry_SYSRETQ_end, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
@@ -601,6 +602,7 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 	/* Restore RDI. */
 	popq	%rdi
 	swapgs
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnative_iret
 
 
@@ -712,6 +714,8 @@ native_irq_return_ldt:
 	 */
 	popq	%rax				/* Restore user RAX */
 
+	CLEAR_CPU_BUFFERS
+
 	/*
 	 * RSP now points to an ordinary IRET frame, except that the page
 	 * is read-only and RSP[31:16] are preloaded with the userspace
@@ -1438,6 +1442,12 @@ nmi_restore:
 	std
 	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
 
+	/*
+	 * Skip CLEAR_CPU_BUFFERS here, since it only helps in rare cases like
+	 * NMI in kernel after user state is restored. For an unprivileged user
+	 * these conditions are hard to meet.
+	 */
+
 	/*
 	 * iretq reads the "iret" frame and exits the NMI stack in a
 	 * single instruction.  We are returning to kernel mode, so this
@@ -1455,6 +1465,7 @@ SYM_CODE_START(entry_SYSCALL32_ignore)
 	UNWIND_HINT_END_OF_STACK
 	ENDBR
 	mov	$-ENOSYS, %eax
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_CODE_END(entry_SYSCALL32_ignore)
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index de94e2e84ecc..eabf48c4d4b4 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -270,6 +270,7 @@ SYM_INNER_LABEL(entry_SYSRETL_compat_unsafe_stack, SYM_L_GLOBAL)
 	xorl	%r9d, %r9d
 	xorl	%r10d, %r10d
 	swapgs
+	CLEAR_CPU_BUFFERS
 	sysretl
 SYM_INNER_LABEL(entry_SYSRETL_compat_end, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR

-- 
2.34.1



