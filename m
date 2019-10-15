Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEBD7DDC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 19:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfJORcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 13:32:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:37927 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbfJORcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 13:32:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 10:32:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201822715"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 10:32:17 -0700
Date:   Tue, 15 Oct 2019 10:32:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Subject: Re: [PATCH v4] KVM: nVMX: Don't leak L1 MMIO regions to L2
Message-ID: <20191015173217.GH15015@linux.intel.com>
References: <20191015001304.2304-1-jmattson@google.com>
 <20191015010740.GA24895@linux.intel.com>
 <CALMp9eQ-xcQSESs7et3voPU7-Jbs6X14S1U74_izYCSpyNbstg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ-xcQSESs7et3voPU7-Jbs6X14S1U74_izYCSpyNbstg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 10:13:06AM -0700, Jim Mattson wrote:
> On Mon, Oct 14, 2019 at 6:07 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > KVM doesn't usually add (un)likely annotations for things that are under
> > L1's control.  The "unlikely(vmx->fail)" in nested_vmx_exit_reflected() is
> > there because it's true iff KVM missed a VM-Fail condition that was caught
> > by hardware.
> 
> I would argue that it makes sense to optimize for the success path in
> this case. If L1 is taking the failure path more frequently than the
> success path, something is wrong. Moreover, you have already indicated
> that the success path should be statically predicted taken by asking
> me to move the failure path out-of-line. (Forward conditional branches
> are statically predicted not taken, per section 3.4.1.3 of the Intel
> 64 and IA-32 Architectures Optimization Reference Manual.) I'm just
> asking the compiler not to undo that hint.

Fair enough.
