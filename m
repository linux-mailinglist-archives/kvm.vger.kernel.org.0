Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DCE1FEAAE
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 07:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgFRFL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 01:11:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:25216 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgFRFL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 01:11:59 -0400
IronPort-SDR: EdaQjeqOYXcZ2RBy86wtRCZK755YtRsQQ08pATSJ2xU/dZ3Ute86TzPH8wkzkzWUcXirG1eqPp
 k3V+8giSsrJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142377850"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142377850"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:11:58 -0700
IronPort-SDR: OXb5NSzxB72WuZdRrvbctj70C73fuOeVrJ6QxUt24UBMGvFTvMuuEJ1flE6DRi0OJkAkchjRd8
 K2gj1Lab20dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="277506375"
Received: from otcsectest.jf.intel.com (HELO 0d4958db2004) ([10.54.30.81])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2020 22:11:58 -0700
Date:   Thu, 18 Jun 2020 05:08:34 +0000
From:   "Andersen, John" <john.s.andersen@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
        sean.j.christopherson@intel.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
Message-ID: <20200618050834.GA23@0d4958db2004>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
> > On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> >> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> wrote:
> >> 
> >> Paravirutalized control register pinning adds MSRs guests can use to
> >> discover which bits in CR0/4 they may pin, and MSRs for activating
> >> pinning for any of those bits.
> > 
> > [ sni[
> > 
> >> +static void vmx_cr_pin_test_guest(void)
> >> +{
> >> +	unsigned long i, cr0, cr4;
> >> +
> >> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> >> +	/* nop */
> > 
> > I do not quite get this comment. Why do you skip checking whether the
> > feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
> > runs this test does not support this feature?
> 
> My bad, I was confused between the nested checks and the non-nested ones.
> 
> Nevertheless, can we avoid situations in which
> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
> implemented? Is there some protocol for detection that this feature is
> supported by the hypervisor, or do we need something like rdmsr_safe()?
> 

Ah, yes we can. By checking the CPUID for the feature bit. Thanks for pointing
this out, I was confused about this. I was operating under the assumption that
the unit tests assume the features in the latest kvm/next are present and
available when the unit tests are being run.

I'm happy to add the check, but I haven't see anywhere else where a
KVM_FEATURE_ was checked for. Which is why it doesn't check in this patch. As
soon as I get an answer from you or anyone else as to if the unit tests assume
that the features in the latest kvm/next are present and available or not when
the unit tests are being run I'll modify if necessary.

Thanks,
John
