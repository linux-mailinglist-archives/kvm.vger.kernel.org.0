Return-Path: <kvm+bounces-61906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 101F7C2DAD1
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 19:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EC021882A7C
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 18:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662A128CF4A;
	Mon,  3 Nov 2025 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m3545L7D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21450288C25;
	Mon,  3 Nov 2025 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762194407; cv=none; b=ZFrIkvZ8UyvtP64bfglhhvmmDmoY6V0sMt/Ul6ZgKKaHeRiEaL2HJP1DeE6gWJPjBPWc8Y44WXQAoYP3Fepefli4cA8WC1RZOo8ZhJ9LGHg61JOp3BZwLSd4F3Mu8zsRUBw7LaCOIzV21I0JRs8+BxWUhFAX08oW5jAiZ0jMpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762194407; c=relaxed/simple;
	bh=Tc6CfAFmd8BcAhsq22LZ+5CZ9tMw6kSfG7lamss8Vs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXEDnUVpH1LYZ6PzjuARpEY4UMlR0H0imxO0+INKQjt7z6qmJY6z3KT0sqwBe8CYcx7rdMwMfr4TYK80sxjsOEE6IIwTIy4C9gtgHIc5PmDFTwrmCH09Q/D33+TTchCmxwONE5/3jyO4W98BDt4+LKwGZYX6Od67zSuyG6Vj7fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m3545L7D; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762194405; x=1793730405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tc6CfAFmd8BcAhsq22LZ+5CZ9tMw6kSfG7lamss8Vs4=;
  b=m3545L7DMqVJftZ/Zk9KeQCiXqUotM6oHbJSSfl96VFUMWcC7hYzOkvR
   7tOnV2finyiPPP3mVNz0rz82zw1w6X8qb8ZJBOotUU2xmujg58qzoJi0Y
   bsEXdC8SddLkzJ5CNTXS331L97IQ2g2luXZEeqKKZvqxxZKxv7H/wSKyI
   hPYCM617+2qTsHf8RWuHuekBAOUbrm7aV+QBTvbGQYdb7nevU6iAqTmik
   Ee4D5nZMzT0qzR3B5XAL2Wg4r0ID0pxKwqz0rBJZT0mwzM0f4PTdW79qv
   Emok4/MThRRBka7qweUKOD2J2ps8IvZImFnbspW1pleWnrnLXFzYU5XRp
   A==;
X-CSE-ConnectionGUID: QZq4/W7LQGevr8QYUEX0NQ==
X-CSE-MsgGUID: KJkF/VtTR1mJkGRvLQn3Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74569331"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="74569331"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:26:45 -0800
X-CSE-ConnectionGUID: +YzdhGnqRwacooQpPvLOag==
X-CSE-MsgGUID: scUMybvGRBy8h/qCawvLHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="224185573"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:26:44 -0800
Date: Mon, 3 Nov 2025 10:26:38 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 6/8] KVM: VMX: Bundle all L1 data cache flush
 mitigation code together
Message-ID: <20251103182638.y7np5zuccmca6n7f@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-7-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:38PM -0700, Sean Christopherson wrote:
> Move vmx_l1d_flush(), vmx_cleanup_l1d_flush(), and the vmentry_l1d_flush
> param code up in vmx.c so that all of the L1 data cache flushing code is
> bundled together.  This will allow conditioning the mitigation code on
> CONFIG_CPU_MITIGATIONS=y with minimal #ifdefs.
> 
> No functional change intended.
> 
> Reviewed-by: Brendan Jackman <jackmanb@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

