Return-Path: <kvm+bounces-55264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C71BBB2F338
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 11:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B719A1C26CAC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 09:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505002D3ED3;
	Thu, 21 Aug 2025 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDUlwJ2E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632832BD031;
	Thu, 21 Aug 2025 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767124; cv=none; b=Mx7zBVxjUqG/BfKpDUxjW26vgiJc5HXNIRBH7LZSUARBc8HrBYSc5/a+tI+rFOwdIhrPWqwxTzMHLlLdKBYKa0FwN7lc/Da68LS5vHVdC69CZh5AP3GNILpc0GnF9ZXndlZ1xzJDBtf1eXmCMAFhsD7UHg89DvAWr1ypBuYj+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767124; c=relaxed/simple;
	bh=6m8VkLTn5CveIiBhG3nSr49Vkn2mPSrdpHQymVKyjFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zbv0CtxIPmrNNIt2dLZ+W+WRkOlSOIkDjiCHERK+BRGxHm8DBJFHagK6TFWkgngxdpAnVI/ufCXzXubXDH8UJ71KComS80eYfMxxNkitvB3l5rsjyUfWvt5F65eewPLMhkVznimTJ6YvtZa/AlXyPIqGkm8+svG7m8/xiP8cB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDUlwJ2E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72135C4CEEB;
	Thu, 21 Aug 2025 09:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755767124;
	bh=6m8VkLTn5CveIiBhG3nSr49Vkn2mPSrdpHQymVKyjFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDUlwJ2EmohArI1fC1Akm4jTOxlqiU+m3pUzPJDD6lNS8l2ua+nD4ooUPnPgIldiU
	 wb5mldq5XbpxigBYnm4tN15EM42gF0So48Q9MrFuEueD4gPCSA/69PewL8SHXa4zpZ
	 YNFzF7uOVqUASZvT7XXrC9OkBVpPqLLdlvdrCkGm0pfvrmwVYAVWmcQ4IEYbC8Dap8
	 ZawdsErTkjlfQyYSJWMWOXvPNOiEk6cJ9/LhBkVODJLt4adKuC9piZ6ko99t2c7YI1
	 3erMd+Mat2qOb319sQHnJpOLVRxk37JU6JnUKiLtplp7HYqs1iMpQuZ4GbEvLOV8/S
	 0F+tnnHXnjXxw==
Date: Thu, 21 Aug 2025 11:05:21 +0200
From: Amit Shah <amit@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
	jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com,
	amit.shah@amd.com
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
Message-ID: <aKbhUcAURkOXIVY-@mun-amitshah-l>
References: <20250515152621.50648-1-amit@kernel.org>
 <20250515152621.50648-2-amit@kernel.org>
 <43bbb306-782b-401d-ac96-cc8ca550af7d@amd.com>
 <c4adbc456e702b6e04b160efb996212fe3ee9d04.camel@kernel.org>
 <aKX1VZ90_wBxMI7l@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKX1VZ90_wBxMI7l@google.com>

On (Wed) 20 Aug 2025 [09:18:29], Sean Christopherson wrote:
> On Wed, May 28, 2025, Amit Shah wrote:
> > On Mon, 2025-05-19 at 16:22 -0500, Tom Lendacky wrote:
> > > > +static inline void vmcb_set_flush_guest_rap(struct vmcb *vmcb)
> > > > +{
> > > > +	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
> > > > +}
> > > > +
> > > > +static inline void vmcb_clr_flush_guest_rap(struct vmcb *vmcb)
> > > > +{
> > > > +	vmcb->control.erap_ctl &= ~ERAP_CONTROL_FLUSH_RAP;
> > > > +}
> > > > +
> > > > +static inline void vmcb_enable_extended_rap(struct vmcb *vmcb)
> > > 
> > > s/extended/larger/ to match the bit name ?
> > 
> > I also prefer it with the "larger" name, but that is a confusing bit
> > name -- so after the last round of review, I renamed the accessor
> > functions to be "better", while leaving the bit defines match what the
> > CPU has.
> > 
> > I don't mind switching this back - anyone else have any other opinions?
> 
> They both suck equally?  :-)
> 
> My dislike of "larger" is that it's a relative and intermediate term.  What is
> the "smaller" size?  Is there an "even larger" or "largest size"?
> 
> "extended" doesn't help in any way, because that simply "solves" the problem of
> size ambiguity by saying absolutely nothing about the size.

I agree with that; but it's just how the bit is named in the APM, so...

> I also dislike "allow", because in virtualization context, "allow" usually refers
> to what the _guest_ can do, but in this case "allow" refers to what the CPU can
> do.

(same as above)

> If we want to diverge from the APM, my vote would be for something like
> 
>   ERAP_CONTROL_FULL_SIZE_RAP

Oh I def didn't want to diverge from the APM (for the name of the bit).  I
only wnat to check what's palatable for the accessors -- but a quick read of
the followup reply shows you're asking to drop them and just use the checks
directly, that's fine - no need for these accessors and this renaming.

	  	 Amit

