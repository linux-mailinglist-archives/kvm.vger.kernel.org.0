Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664D3050B3
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbhA0EWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:22:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:37060 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbhAZXUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 18:20:32 -0500
IronPort-SDR: FvSb8HqeuE7rULHCiHbHIY6HiDMn27xiXvdKn/Cu2PdsyrWvQKvAMNYHuh5sBSC24nf+ycBMNx
 5kKrUNmL9rJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="176478212"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="176478212"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:18:37 -0800
IronPort-SDR: TB0ILoE4neBV5jpHdaXohUbBOuzfJmaZ8dPlKgnyb/UBhFWYhJd2zIaahMJExqSqxxJGvHfwQh
 An5bBX40KOKQ==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="574196941"
Received: from rsperry-desk.amr.corp.intel.com ([10.251.7.187])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:18:34 -0800
Message-ID: <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 27 Jan 2021 12:18:32 +1300
In-Reply-To: <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
         <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 07:34 -0800, Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > features, since adding a new leaf for only two bits would be wasteful.
> > As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> > guest, and to do so correctly needs to query hardware and kernel support
> > for SGX1 and SGX2.
> 
> It's also not _just_ exposing the CPUID leaves.  There are some checks
> here when KVM is emulating some SGX instructions too, right?

I would say trapping instead of emulating, but yes KVM will do more. However those
are quite details, and I don't think we should put lots of details here. Or perhaps
we can use 'for instance' as brief description:

As part of virtualizing SGX, KVM will need to use the two flags, for instance, to
expose them to guest.

?

> 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 84b887825f12..18b2d0c8bbbe 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -292,6 +292,8 @@
> >  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
> >  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
> >  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> > +#define X86_FEATURE_SGX1		(11*32+ 8) /* Software Guard Extensions sub-feature SGX1 */
> > +#define X86_FEATURE_SGX2        	(11*32+ 9) /* Software Guard Extensions sub-feature SGX2 */
> 
> FWIW, I'm not sure how valuable it is to spell the SGX acronym out three
> times.  Can't we use those bytes to put something more useful in that
> comment?

I think we can remove comment for SGX1, since it is basically SGX.

For SGX2, how about below?

/* SGX Enclave Dynamic Memory Management */


