Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B2BCE72E
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfJGPSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 11:18:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:5538 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfJGPSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 11:18:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 08:18:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="199543022"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Oct 2019 08:18:30 -0700
Date:   Mon, 7 Oct 2019 08:18:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Dan Cross <dcross@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
Message-ID: <20191007151829.GC18016@linux.intel.com>
References: <20191004175203.145954-1-jmattson@google.com>
 <a4570ffc-fa77-bc18-66cb-b08205c237b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4570ffc-fa77-bc18-66cb-b08205c237b1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 07, 2019 at 12:07:03PM +0200, Paolo Bonzini wrote:
> As usual, nothing to say about the behavior, just about the code...
> 
> On 04/10/19 19:52, Jim Mattson wrote:
> > + * Returns:
> > + *   0 - success, i.e. proceed with actual VMEnter
> > + *  -EFAULT - consistency check VMExit
> > + *  -EINVAL - consistency check VMFail
> > + *  -ENOTSUPP - kvm internal error
> >   */
> 
> ... the error codes do not mean much here.  Can you define an enum instead?

Agreed.  Liran also suggested an enum.

> (I also thought about passing the exit reason, where bit 31 could be
> used to distinguish VMX instruction failure from an entry failure
> VMexit, which sounds cleaner if you just look at the prototype but
> becomes messy fairly quickly because you have to pass back the exit
> qualification too.  The from_vmentry argument could become u32
> *p_exit_qual and be NULL if not called from VMentry, but it doesn't seem
> worthwhile at all).

Ya.  I also tried (and failed) to find a clever solution that didn't
require a multi-state return value.  As much as I dislike returning an
enum, it's the lesser of all evils.
