Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BB8309F9C
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 01:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhBAACt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 31 Jan 2021 19:02:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:55767 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhBAACj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 19:02:39 -0500
IronPort-SDR: TTEULFyxmkvaPzWUqKEyYYLFzYhM7HbDVGzLzqlQd3QVK3Z2GU5d7AvNFwfTPj0JLd5ONAu7+k
 fjKI1w0NGTAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="242134595"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="242134595"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:01:56 -0800
IronPort-SDR: vKIEfUNSmCzp8znaWhMQRy+fuFvwffEDgPWAONK+FMH5FUkONRgx7SqLcd3wmwS5ICwpaCnKVM
 wk2BvG53fhcw==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390408021"
Received: from kpeng-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.130.129])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:01:53 -0800
Date:   Mon, 1 Feb 2021 13:01:51 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
In-Reply-To: <YBVdNl+pTBBm6igw@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
        <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
        <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
        <YBVdNl+pTBBm6igw@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 15:20:54 +0200 Jarkko Sakkinen wrote:
> On Wed, Jan 27, 2021 at 12:18:32PM +1300, Kai Huang wrote:
> > On Tue, 2021-01-26 at 07:34 -0800, Dave Hansen wrote:
> > > On 1/26/21 1:30 AM, Kai Huang wrote:
> > > > From: Sean Christopherson <seanjc@google.com>
> > > > 
> > > > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > > > features, since adding a new leaf for only two bits would be wasteful.
> > > > As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> > > > guest, and to do so correctly needs to query hardware and kernel support
> > > > for SGX1 and SGX2.
> > > 
> > > It's also not _just_ exposing the CPUID leaves.  There are some checks
> > > here when KVM is emulating some SGX instructions too, right?
> > 
> > I would say trapping instead of emulating, but yes KVM will do more. However those
> > are quite details, and I don't think we should put lots of details here. Or perhaps
> > we can use 'for instance' as brief description:
> > 
> > As part of virtualizing SGX, KVM will need to use the two flags, for instance, to
> > expose them to guest.
> > 
> > ?
> > 
> > > 
> > > > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > > > index 84b887825f12..18b2d0c8bbbe 100644
> > > > --- a/arch/x86/include/asm/cpufeatures.h
> > > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > > @@ -292,6 +292,8 @@
> > > >  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
> > > >  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
> > > >  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> > > > +#define X86_FEATURE_SGX1		(11*32+ 8) /* Software Guard Extensions sub-feature SGX1 */
> > > > +#define X86_FEATURE_SGX2        	(11*32+ 9) /* Software Guard Extensions sub-feature SGX2 */
> > > 
> > > FWIW, I'm not sure how valuable it is to spell the SGX acronym out three
> > > times.  Can't we use those bytes to put something more useful in that
> > > comment?
> > 
> > I think we can remove comment for SGX1, since it is basically SGX.
> > 
> > For SGX2, how about below?
> > 
> > /* SGX Enclave Dynamic Memory Management */
> 
> (EDMM)

Does EDMM obvious to everyone, instead of explicitly saying Enclave Dynamic
Memory Management?

Also do you think we need a comment for SGX1 bit? I can add /* Basic SGX */,
but I am not sure whether it is required.
