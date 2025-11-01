Return-Path: <kvm+bounces-61744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDD2C275A2
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 02:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 988C91895870
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 01:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFF1241CB2;
	Sat,  1 Nov 2025 01:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bC33zfeB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D9410A1E;
	Sat,  1 Nov 2025 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761961614; cv=none; b=mgrJqLkA3bFIN8c0BwLbTi5Ag5SLy0J+RkeZny3UN07Y3tslbXevfI87iFpaaf36IvBfnhMuwkOH6ViSlsUyWigvIeMG9st9CRD5v5uID84CZG+ap3BCCRwlUqUesxE8Me9T922YIAx/Ovt4ZSqDYYfsLm52jfotcoOglGr0h5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761961614; c=relaxed/simple;
	bh=Jd502uUjv/RJWG2sMVW2q/oJJ7wzKyGk1f0HmnYlbKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geGP+Yv4HRx6Ez2BIUr40nXjuZY6/PpOkVEalthNhhjdm2Iolek34GlYkjmndH9h2grLyQarUK0tacbK9SdigDW4jExxGGqYPrzSFgcbVG8dWVTofQIAS6qHEhO3uCX6rqfo2V4wAG8MNKyrH11ktE5KXtJTMtsrPdxTYaGVzK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bC33zfeB; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761961612; x=1793497612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jd502uUjv/RJWG2sMVW2q/oJJ7wzKyGk1f0HmnYlbKE=;
  b=bC33zfeBFSbGA3MwK3rvEkM+3CCY6MA96+MOAabWremelMDLvIGiGiEw
   RTluvD0ax1HclXXzIKRy08DUVtQAV6PrE3xoprN+ob/KunB74dtJ4Ouno
   hbkopI089aDubX3YclXVIEBgr/Nb82XPlv1pDQtkJbfDD7UcSuxUsr+A4
   wBMVHTTfr8h47mCPju+7OAAJuDSGkBkibUBQsV6M9nqzLG+tObnfscWDN
   nHVwtPqwdBvta1P6lLUxAZ9y3NJ4BugP323Vuw89U6pQVdXjr5u+5pKZF
   UZSLoRfztq6pJMA/0YLrG+5aKzHkowhLsDdZO6tjaDE5fWxfTXojfXc/Z
   A==;
X-CSE-ConnectionGUID: pUahbzcmTNKyxqpBu+JYyg==
X-CSE-MsgGUID: rb4jC1U9QrK9UNNz7SNBhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="51699567"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="51699567"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 18:46:51 -0700
X-CSE-ConnectionGUID: hgK2MmTvQOOWNS1ck2Wvmw==
X-CSE-MsgGUID: PiqNC3HsT2qfHEjZzw4wMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186829879"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 18:46:50 -0700
Date: Fri, 31 Oct 2025 18:46:44 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251101014644.7hys77jw64ynewwu@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <DDWH24WOQG3F.1VS7MT0SKPWIL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDWH24WOQG3F.1VS7MT0SKPWIL@google.com>

On Fri, Oct 31, 2025 at 11:30:54AM +0000, Brendan Jackman wrote:
> Rewording my comments from:
> https://lore.kernel.org/all/20251029-verw-vm-v1-1-babf9b961519@linux.intel.com/
> 
> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> >
> > TSA mitigation:
> >
> >   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
> >
> > introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> > CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> > (kernel->user also).
> >
> > Make mitigations on Intel consistent with TSA. This would help handling the
> > guest-only mitigations better in future.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > [sean: make CLEAR_CPU_BUF_VM mutually exclusive with the MMIO mitigation]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> I think this is a clear improvement. Now that X86_FEATURE_CLEAR_CPU_BUF
> has a clear scope, can we also update the comment on its definition in
> cpufeatures.h? I.e. say that it's specifically about exit to user.

Does this suffice?

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5..e842f27a1108 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -321,6 +321,7 @@
 #endif
 .endm
 
+/* Primarily used in exit-to-userspace path */
 #define CLEAR_CPU_BUFFERS \
 	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
 

> This also seems like a good moment to update the comment on
> verw_clear_cpu_buf_mitigation_selected to mention the _VM flag too.

As we have 3 different flags, referring them with X86_FEATURE_CLEAR_CPU_*
should be okay?

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 723666a1357e..51dec95a9af5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -490,7 +490,7 @@ static enum rfds_mitigations rfds_mitigation __ro_after_init =
 
 /*
  * Set if any of MDS/TAA/MMIO/RFDS are going to enable VERW clearing
- * through X86_FEATURE_CLEAR_CPU_BUF on kernel and guest entry.
+ * through X86_FEATURE_CLEAR_CPU_* on kernel and guest entry.
  */
 static bool verw_clear_cpu_buf_mitigation_selected __ro_after_init;
 

> Also, where we set vmx->disable_fb_clear in vmx_update_fb_clear_dis(),
> it still refers to X86_FEATURE_CLEAR_CPU_BUF, is that wrong?

It looks correct to me. The only reason X86_FEATURE_CLEAR_CPU_BUF is used
in vmx_update_fb_clear_dis() is to check if host has enabled its
exit-to-userspace mitigation for some reason, and allow guest to also use
VERW.

