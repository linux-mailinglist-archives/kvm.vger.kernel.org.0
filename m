Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1595E30C764
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbhBBRUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237428AbhBBRSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294A364ECE;
        Tue,  2 Feb 2021 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612286283;
        bh=ztqEUDdfJBfqYT57dN3W7l+zECPHVQXnH/jA6zkc4p0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cylXdh1Eu27aP2lkBXxgtPD3DlueNwoqbrqdB127wJT5y4a7j0EtUu/d6xFZrnCLu
         gBdu/hZP+n4XQ8W2nJBRIZjro6dD8K4IBDKXcmPAUUD5dc/3v7WmctCRtsQLPTS1qc
         KhBJu2dpq/OafhsmHbsixvTHYZqiORGuVh3fsEdjSD23Hw/s4eR2viF426jK5vtIz3
         /Mi/AZRILkP2yyZT8nfHx0Cc++2uC6u8V4EuGCKLgfb0FQrOxQUAa7ZQWHB8/5z0zy
         hvt/6p1ES0ONpY82WdkKotNrHRqCB2ayI6PXRmtmmO/MpV2jlT1ByQN67qCcoHT5CJ
         DjfCSvqK/EpsQ==
Date:   Tue, 2 Feb 2021 19:17:56 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YBmJRKRcg8gvxW1O@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 01:01:51PM +1300, Kai Huang wrote:
> On Sat, 30 Jan 2021 15:20:54 +0200 Jarkko Sakkinen wrote:
> > On Wed, Jan 27, 2021 at 12:18:32PM +1300, Kai Huang wrote:
> > > On Tue, 2021-01-26 at 07:34 -0800, Dave Hansen wrote:
> > > > On 1/26/21 1:30 AM, Kai Huang wrote:
> > > > > From: Sean Christopherson <seanjc@google.com>
> > > > > 
> > > > > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > > > > features, since adding a new leaf for only two bits would be wasteful.
> > > > > As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> > > > > guest, and to do so correctly needs to query hardware and kernel support
> > > > > for SGX1 and SGX2.
> > > > 
> > > > It's also not _just_ exposing the CPUID leaves.  There are some checks
> > > > here when KVM is emulating some SGX instructions too, right?
> > > 
> > > I would say trapping instead of emulating, but yes KVM will do more. However those
> > > are quite details, and I don't think we should put lots of details here. Or perhaps
> > > we can use 'for instance' as brief description:
> > > 
> > > As part of virtualizing SGX, KVM will need to use the two flags, for instance, to
> > > expose them to guest.
> > > 
> > > ?
> > > 
> > > > 
> > > > > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > > > > index 84b887825f12..18b2d0c8bbbe 100644
> > > > > --- a/arch/x86/include/asm/cpufeatures.h
> > > > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > > > @@ -292,6 +292,8 @@
> > > > >  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
> > > > >  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
> > > > >  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> > > > > +#define X86_FEATURE_SGX1		(11*32+ 8) /* Software Guard Extensions sub-feature SGX1 */
> > > > > +#define X86_FEATURE_SGX2        	(11*32+ 9) /* Software Guard Extensions sub-feature SGX2 */
> > > > 
> > > > FWIW, I'm not sure how valuable it is to spell the SGX acronym out three
> > > > times.  Can't we use those bytes to put something more useful in that
> > > > comment?
> > > 
> > > I think we can remove comment for SGX1, since it is basically SGX.
> > > 
> > > For SGX2, how about below?
> > > 
> > > /* SGX Enclave Dynamic Memory Management */
> > 
> > (EDMM)
> 
> Does EDMM obvious to everyone, instead of explicitly saying Enclave Dynamic
> Memory Management?
> 
> Also do you think we need a comment for SGX1 bit? I can add /* Basic SGX */,
> but I am not sure whether it is required.

I would put write the whole thing down and put EDMM to parentheses.

For SGX1 I would put "Basic SGX features for enclave construction".

/Jarkko
