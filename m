Return-Path: <kvm+bounces-6116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFAC82B864
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 01:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 010551C234DB
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 00:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE24EC6;
	Fri, 12 Jan 2024 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNitxEDG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D76563F;
	Fri, 12 Jan 2024 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705017739; x=1736553739;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Idr2q7bMY9FM4vtt/eAt2b8/L8zbVhXJW9vHdLjzwjI=;
  b=iNitxEDGNKPLShmRY0MUu1XMoIv/ZOF4oIszuMV3lhg3XZ3NwWwtUXtr
   ZQ299ASUoZMbHriYGnAY3s9k+/qJpnUPSVrj5hCQpo/vybWAUxGSF5lDD
   PHXXgKhdgfJkn6GRI/c8n5BIHnBKsT4Ar2tBuZoSygo6o7nj3kYyuzN/s
   LBRahpFHH9V6jD5Bhap1PCUWD/GwAzjMhZ4TFf9s+Kf8EjlR+sDNS7qtp
   FGwvMJMTjh2OmIKPANYQoAF6Zecyn0YykXoT09w6gVdTloEJbeUttNCxr
   RfHqCc7VgdgH7HBu6f7D3um7DLfUzShp+Oi2N7L5NstYV4LX1s5N2mUjj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="6399394"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="6399394"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 16:02:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="1029737238"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="1029737238"
Received: from tungyenc-mobl.amr.corp.intel.com (HELO desk) ([10.209.69.66])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 16:02:15 -0800
Date: Thu, 11 Jan 2024 16:02:06 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  v5 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20240112000206.ur5ub5bf5noesvc3@desk>
References: <20240111-delay-verw-v5-0-a3b234933ea6@linux.intel.com>
 <20240111-delay-verw-v5-6-a3b234933ea6@linux.intel.com>
 <ZaAbGWFEfUt1PX66@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaAbGWFEfUt1PX66@google.com>

On Thu, Jan 11, 2024 at 08:45:13AM -0800, Sean Christopherson wrote:
> On Thu, Jan 11, 2024, Pawan Gupta wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index bdcf2c041e0c..8defba8e417b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -387,6 +387,17 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
> >  
> >  static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
> >  {
> > +	/*
> > +	 * FB_CLEAR_CTRL is to optimize VERW latency in guests when host is
> > +	 * affected by MMIO Stale Data, but not by MDS/TAA. When
> > +	 * X86_FEATURE_CLEAR_CPU_BUF is enabled, system is likely affected by
> > +	 * MDS/TAA. Skip the optimization for such a case.
> 
> This is unnecessary speculation (ha!), and it'll also be confusing for many readers
> as the code below explicitly checks for MDS/TAA.  We have no idea why the host
> admin forced the mitigation to be enabled, and it doesn't matter.  The important
> thing to capture is that the intent is to keep the mitigation enabled when it
> was forcefully enabled, that should be self-explanatory and doesn't require
> speculating on _why_ the mitigation was forced on.

Agree.

> > +	 */
> > +	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF)) {
> > +		vmx->disable_fb_clear = false;
> > +		return;
> > +	}
> > +
> >  	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
> >  				!boot_cpu_has_bug(X86_BUG_MDS) &&
> >  				!boot_cpu_has_bug(X86_BUG_TAA);
> 
> I would rather include the X86_FEATURE_CLEAR_CPU_BUF check along with all the
> other checks, and then add a common early return. E.g.
> 
> 	/*
> 	 * Disable VERW's behavior of clearing CPU buffers for the guest if the
> 	 * CPU isn't affected MDS/TAA, and the host hasn't forcefully enabled
> 	 * the mitigation.  Disabing the clearing provides a performance boost
> 	 * for guests that aren't aware that manually clearing CPU buffers is
> 	 * unnecessary, at the cost of MSR accesses on VM-Entry and VM-Exit.
> 	 */
> 	vmx->disable_fb_clear = !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
> 				(host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
> 				!boot_cpu_has_bug(X86_BUG_MDS) &&
> 				!boot_cpu_has_bug(X86_BUG_TAA);
> 
> 	if (!vmx->disable_fb_clear)
> 		return;

This is better. Thanks.

