Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50FE1FF32A
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 15:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgFRNfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 09:35:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:38222 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgFRNfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 09:35:22 -0400
IronPort-SDR: Y1IRtbBG5AmWjoNHKW2jSGzaj6rS+syn2WPrn/dV7THgL7Fskm1icI0Pw3eKVAWqBNYKSqJq0n
 /a6q5kO6eBqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="160666223"
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="160666223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 06:35:22 -0700
IronPort-SDR: dC+UKz9z8EPRe5pE9bo991HFfRGNF1ADcjBGu33/TZvtX24g1aacuLygl1/kwlAWN8EbY8nhny
 MLRZQvUSQ3Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="421500098"
Received: from otcsectest.jf.intel.com (HELO 258ff54ff3c0) ([10.54.30.81])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2020 06:35:22 -0700
Date:   Thu, 18 Jun 2020 13:31:57 +0000
From:   "Andersen, John" <john.s.andersen@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        rick.p.edgecombe@intel.com, kvm <kvm@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
Message-ID: <20200618133157.GA23@258ff54ff3c0>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
 <20200618050834.GA23@0d4958db2004>
 <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 11:59:10PM -0700, Nadav Amit wrote:
> > On Jun 17, 2020, at 10:08 PM, Andersen, John <john.s.andersen@intel.com> wrote:
> > 
> > On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
> >>> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> 
> >>>> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> wrote:
> >>>> 
> >>>> Paravirutalized control register pinning adds MSRs guests can use to
> >>>> discover which bits in CR0/4 they may pin, and MSRs for activating
> >>>> pinning for any of those bits.
> >>> 
> >>> [ sni[
> >>> 
> >>>> +static void vmx_cr_pin_test_guest(void)
> >>>> +{
> >>>> +	unsigned long i, cr0, cr4;
> >>>> +
> >>>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> >>>> +	/* nop */
> >>> 
> >>> I do not quite get this comment. Why do you skip checking whether the
> >>> feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
> >>> runs this test does not support this feature?
> >> 
> >> My bad, I was confused between the nested checks and the non-nested ones.
> >> 
> >> Nevertheless, can we avoid situations in which
> >> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
> >> implemented? Is there some protocol for detection that this feature is
> >> supported by the hypervisor, or do we need something like rdmsr_safe()?
> > 
> > Ah, yes we can. By checking the CPUID for the feature bit. Thanks for pointing
> > this out, I was confused about this. I was operating under the assumption that
> > the unit tests assume the features in the latest kvm/next are present and
> > available when the unit tests are being run.
> > 
> > I'm happy to add the check, but I haven't see anywhere else where a
> > KVM_FEATURE_ was checked for. Which is why it doesn't check in this patch. As
> > soon as I get an answer from you or anyone else as to if the unit tests assume
> > that the features in the latest kvm/next are present and available or not when
> > the unit tests are being run I'll modify if necessary.
> 
> I would appreciate if you add a check of CPUID and not run the test if the 
> feature is not supported.
> 
> I run the tests on bare-metal (and other non-KVM environment) from time to
> time. Doing so allows to find bugs in tests due to wrong assumptions of KVM
> test developers. Liran runs the tests using QEMU/WHPX (non-KVM). So allowing
> the tests to run on non-KVM environments is important, at least for some of
> us, and benefits KVM as well.
> 
> While I can disable this specific test using the test parameters, I prefer
> that the test will first check the environment they run on. Debugging test
> failures on bare-metal is hard enough without the paravirt stuff noise.
> 

Great point! I'll add the check
