Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18699181C42
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgCKPZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 11:25:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:27521 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgCKPZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 11:25:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 08:25:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,541,1574150400"; 
   d="scan'208";a="289415272"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Mar 2020 08:25:00 -0700
Date:   Wed, 11 Mar 2020 08:24:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment registers
Message-ID: <20200311152459.GD21852@linux.intel.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <CALMp9eR9hL9OQPBfekDbRAFHx5j-wgBcijjAV0T22NGoSpxpdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR9hL9OQPBfekDbRAFHx5j-wgBcijjAV0T22NGoSpxpdA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 04:51:40PM -0700, Jim Mattson wrote:
> On Tue, Mar 10, 2020 at 4:29 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> > Even thought today's x86 hardware uses paging and not segmentation for memory
> > management, it is still good to have some tests that can verify the sanity of
> > the segment register fields on vmentry of nested guests.
> >
> > The test on SS Selector field is failing because the hardware (I am using
> > Intel Xeon Platinum 8167M 2.00GHz) doesn't raise any error even if the
> > prescribed bit pattern is not set and as a result vmentry succeeds.
> 
> Are you sure this isn't just an L0 bug? For instance, does your L0 set
> "unrestricted guest" in vmcs02, even when L1 doesn't set it in vmcs12?


I assume this is the check being discussed?  The code is flawed, if CS=3
and SS=3, "sel = sel_saved | (~cs_rpl_bits & 0x3)" will yield SS=3 and pass.

I think you wanted something like:

  sel = (sel_saved & ~0x3) | (~cs_rpl_bits & 0x3);


> +	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
> +	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
> +		u16 cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
> +		sel_saved = vmcs_read(GUEST_SEL_SS);
> +		sel = sel_saved | (~cs_rpl_bits & 0x3);
> +		TEST_SEGMENT_SEL(GUEST_SEL_SS, "GUEST_SEL_SS", sel, sel_saved);
> +	}
> +}

