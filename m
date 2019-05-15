Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487651F8E2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfEOQph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 12:45:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:17738 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfEOQph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 12:45:37 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 09:45:36 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 15 May 2019 09:45:36 -0700
Date:   Wed, 15 May 2019 09:45:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Dynamically calculate and
 check max VMCS field encoding index
Message-ID: <20190515164536.GC5875@linux.intel.com>
References: <20190416013832.11697-1-sean.j.christopherson@intel.com>
 <04F148C8-5E44-4195-97E7-35A428E36983@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04F148C8-5E44-4195-97E7-35A428E36983@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 03:43:18PM -0700, Nadav Amit wrote:
> > On Apr 15, 2019, at 6:38 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Per Intel's SDM:
> > 
> >  IA32_VMX_VMCS_ENUM indicates to software the highest index value used
> >  in the encoding of any field supported by the processor:
> >    - Bits 9:1 contain the highest index value used for any VMCS encoding.
> >    - Bit 0 and bits 63:10 are reserved and are read as 0
> > 
> > KVM correctly emulates this behavior, in no small part due to the VMX
> > preemption timer being unconditionally emulated *and* having the highest
> > index of any field supported in vmcs12.  Given that the maximum control
> > field index is already above the VMX preemption timer (0x32 vs 0x2E),
> > odds are good that the max index supported in vmcs12 will change in the
> > not-too-distant future.
> > 
> > Unfortunately, the only unit test coverage for IA32_VMX_VMCS_ENUM is in
> > test_vmx_caps(), which simply checks that the max index is >= 0x2a, i.e.
> > won't catch any future breakage of KVM's IA32_VMX_VMCS_ENUM emulation,
> > especially if the max index depends on underlying hardware support.
> > 
> > Instead of playing whack-a-mole with a hardcoded max index test,
> > piggyback the exhaustive VMWRITE/VMREAD test and dynamically calculate
> > the max index based on which fields can be VMREAD.  Leave the existing
> > hardcoded check in place as it won't hurt anything and test_vmx_caps()
> > is a better location for checking the reserved bits of the MSR.
> 
> [ Yes, I know this patch was already accepted. ]
> 
> This patch causes me problems.
> 
> I think that probing using the known VMCS fields gives you a minimum for the
> maximum index. There might be VMCS fields that the test does not know about.
> Otherwise it would require to update kvm-unit-tests for every fields that is
> added to kvm.
> 
> One option is just to change the max index, as determined by the probing to
> be required to smaller or equal to IA32_VMX_VMCS_ENUM.MAX_INDEX. A second
> option is to run additional probing, using IA32_VMX_VMCS_ENUM.MAX_INDEX and
> see if it is supported.
> 
> What do you say?

Argh, I thought the test I was piggybacking was exhaustively probing all
theoretically possible fields, but that's the VMCS shadowing test.  That
was my intent: probe all possible fields to find the max index and compare
it against IA32_VMX_VMCS_ENUM.MAX_INDEX.

To fix the immediate issue, going with the "smaller or equal" check makes
sense.  To get the coverage I originally intended, I'll work on a test to
find the max non-failing field and compare it against MAX_INDEX.
