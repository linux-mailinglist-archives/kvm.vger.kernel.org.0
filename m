Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E47CED5A
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 22:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfJGUUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 16:20:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:33229 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGUUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 16:20:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 13:20:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="196399003"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 07 Oct 2019 13:20:50 -0700
Date:   Mon, 7 Oct 2019 13:20:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: Determining whether LVT_CMCI is supported
Message-ID: <20191007202050.GH18016@linux.intel.com>
References: <2CF61715-CA79-4578-BD09-A0B6E2B2222F@gmail.com>
 <223C58D0-2AF4-4397-BDFF-3DD134E5B52A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223C58D0-2AF4-4397-BDFF-3DD134E5B52A@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies, completely lost this in my inbox.

On Mon, Oct 07, 2019 at 12:58:16PM -0700, Nadav Amit wrote:
> > On Oct 2, 2019, at 6:22 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> > Hello Sean,
> > 
> > Sorry for keep bothering you, but I am a bit stuck with fixing one
> > kvm-unit-tests that fails on Skylake bare-metal.
> > 
> > The reason for the failure is that I assumed that APIC_CMCI (MSR 0x82f)
> > support is reported in MSR_IA32_MCG_CAP[10].
> > 
> > However, on my machine, I get:  MSR_IA32_MCG_CAP (0x179) = 0x7000816
> > 
> > And although MSR_IA32_MCG_CAP[10] is clear, APIC_CMCI is still accessible.
> > 
> > Is there a way to determine whether LVT_CMCI is supported on a CPU?

Bits 23:16 of the APIC's version register (LVR, MMIO 0x30, MSR 0x803)
report the maximum number of LVT registers, minus 1.

  Max LVT Entry Shows the number of LVT entries minus 1. For the Pentium 4 and
  Intel Xeon processors (which have 6 LVT entries), the value returned in the Max
  LVT field is 5; for the P6 family processors (which have 5 LVT entries), the
  value returned is 4; for the Pentium processor (which has 4 LVT entries), the
  value returned is 3. For processors based on the Intel microarchitecture code
  name Nehalem (which has 7 LVT entries) and onward, the value returned is 6.

I haven't found anything in the SDM that states which LVT entries are 3rd,
4th, 5th, etc..., but based on kernel code, LVT_CMCI is the 7th, i.e.
exists if APIC_LVR[23:16] >= 6.

> Sean, anyone?
> 
> Otherwise, I would just disable this test on bare-metal, which might hide
> bugs.
