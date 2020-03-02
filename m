Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CB11761A5
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgCBRzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:55:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:19322 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBRzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:55:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 09:55:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,507,1574150400"; 
   d="scan'208";a="233446855"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 09:55:38 -0800
Date:   Mon, 2 Mar 2020 09:55:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
Message-ID: <20200302175539.GB6244@linux.intel.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
 <688edd4d-81ad-bb6b-f166-4fb26a90bb9e@redhat.com>
 <20200302163834.GA6244@linux.intel.com>
 <27b0a092-dae4-157b-7c56-7a757a680217@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27b0a092-dae4-157b-7c56-7a757a680217@siemens.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 05:46:01PM +0100, Jan Kiszka wrote:
> On 02.03.20 17:38, Sean Christopherson wrote:
> >On Mon, Mar 02, 2020 at 05:11:57PM +0100, Paolo Bonzini wrote:
> >>Queued, thanks.
> >
> >Too fast, too fast!
> >
> >On Sun, Mar 01, 2020 at 11:47:20AM +0100, Jan Kiszka wrote:
> >>From: Jan Kiszka <jan.kiszka@siemens.com>
> >>
> >>After 43561123ab37, found is not set correctly in case of leaves 0BH,
> >>1FH, or anything out-of-range.
> >
> >No, found is set correctly, kvm_cpuid() should return true if and only if
> >an exact match for the requested function is found, and that's the original
> >tracing behavior of "found" (pre-43561123ab37).
> >
> >>This is currently harmless for the return value because the only caller
> >>evaluating it passes leaf 0x80000008.
> >
> >No, it's 100% correct.  Well, technically it's irrelevant because the only
> >caller, check_cr_write(), passes %false for check_limit, i.e. found will be
> >true if and only if entry 0x80000008 exists.  But, in a purely hypothetical
> >scenario where the emulator passed check_limit=%true, the intent of "found"
> >is to report that the exact leaf was found, not if some random entry was
> >found.
> 
> Nicely non-intuitive semantics. Should definitely be documented.
> 
> And then it's questionable to me what value tracing such a return code has.

There's value in knowing the the output came from the actual requested leaf
as opposed to the max basic leaf, e.g. if the guest is seeing weird CPUID
output in the guest, knowing whether it was explicitly configured by the
userspace VMM versus coming from KVM's emulation of Intel's wonderful CPUID
behavior.

> At the bare minimum, "found" should be renamed to something like
> "exact_match".

I can do something along these lines.  kvm_cpuid() really doesn't need to
be returning a value, i.e. the emulator shouldn't be manually calculating
maxphyaddr anyways.
