Return-Path: <kvm+bounces-4875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FA4819634
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 903651C25359
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED906FA9;
	Wed, 20 Dec 2023 01:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mgR2rS8W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C5567C;
	Wed, 20 Dec 2023 01:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035567; x=1734571567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BB5xrxsz+BnW5YoyU869JFzcyH3wK7pydPymvf+6dm8=;
  b=mgR2rS8W867+Znl9NISgZMQM9uZBiieLYR3b07Ey7INDjUHqQKa0+n5f
   9tGJ+TR5TzyBE8IsRaEFb/iNvTb4KWCHLbUsS4UIgXhEnnOJQFymBPxl6
   gsGlqnOWJHX7nZ3qFaHVYtEsi0CXP5dp+fZxcMfezNaU//30x7vr6WNPT
   fxa+KEGCzYoruxSzenvJTR0CNpUQk3M/2tiNjz3XCgTRLGUf72HqxYKQ3
   BqqjeNlxxpWs4J67ZZ0D0CdzUetSBoETqWWni4opH6N2Aw4qAkjigYW/Z
   wQiYRHpXiBeB9LTsQ+fgNIoWxEL30eFswuApwlqDgMVRW9jX1IMsQs6gI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="9207136"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="9207136"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:26:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="899553838"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="899553838"
Received: from ihur-mobl1.amr.corp.intel.com (HELO desk) ([10.209.1.244])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:26:05 -0800
Date: Tue, 19 Dec 2023 17:25:57 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH  v4 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231220012557.7myc7xy24tveaid6@desk>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-6-9a3622d4bcf7@linux.intel.com>
 <20231201200247.vui6enzdj5nzctf4@treble>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201200247.vui6enzdj5nzctf4@treble>

On Fri, Dec 01, 2023 at 12:02:47PM -0800, Josh Poimboeuf wrote:
> On Fri, Oct 27, 2023 at 07:39:12AM -0700, Pawan Gupta wrote:
> > -	vmx_disable_fb_clear(vmx);
> > +	/*
> > +	 * Optimize the latency of VERW in guests for MMIO mitigation. Skip
> > +	 * the optimization when MDS mitigation(later in asm) is enabled.
> > +	 */
> > +	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> > +		vmx_disable_fb_clear(vmx);
> >  
> >  	if (vcpu->arch.cr2 != native_read_cr2())
> >  		native_write_cr2(vcpu->arch.cr2);
> > @@ -7248,7 +7256,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  
> >  	vmx->idt_vectoring_info = 0;
> >  
> > -	vmx_enable_fb_clear(vmx);
> > +	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> > +		vmx_enable_fb_clear(vmx);
> >  
> 
> It may be cleaner to instead check X86_FEATURE_CLEAR_CPU_BUF when
> setting vmx->disable_fb_clear in the first place, in
> vmx_update_fb_clear_dis().

Right. Thanks for the review.

