Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8DFF0A29
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 00:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfKEXZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 18:25:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:54702 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfKEXZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 18:25:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 15:25:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="226251719"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Nov 2019 15:25:00 -0800
Date:   Tue, 5 Nov 2019 15:25:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191105232500.GA25887@linux.intel.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105193749.GA20225@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105193749.GA20225@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 11:37:50AM -0800, Sean Christopherson wrote:
> On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> > Virtualized guests may pick a different strategy to mitigate hardware
> > vulnerabilities when it comes to hyper-threading: disable SMT completely,
> > use core scheduling, or, for example, opt in for STIBP. Making the
> > decision, however, requires an extra bit of information which is currently
> > missing: does the topology the guest see match hardware or if it is 'fake'
> > and two vCPUs which look like different cores from guest's perspective can
> > actually be scheduled on the same physical core. Disabling SMT or doing
> > core scheduling only makes sense when the topology is trustworthy.
> > 
> > Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> > that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> > topology is actually trustworthy. It would, of course, be possible to get
> > away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> > compatibility but the current approach looks more straightforward.
> 
> I'd stay away from "trustworthy", especially if this is controlled by
> userspace.  Whether or not the hint is trustworthy is purely up to the
> guest.  Right now it doesn't really matter, but that will change as we
> start moving pieces of the host out of the guest's TCB.
> 
> It may make sense to split the two (or even three?) cases, e.g.
> KVM_FEATURE_NO_SMT and KVM_FEATURE_ACCURATE_TOPOLOGY.  KVM can easily
> enforce NO_SMT _today_, i.e. allow it to be set if and only if SMT is
> truly disabled.  Verifying that the topology exposed to the guest is legit
> is a completely different beast.

Scratch the ACCURATE_TOPOLOGY idea, I doubt there's a real use case for
setting ACCURATE_TOPOLOGY and not KVM_HINTS_REALTIME.  A feature flag to
state that SMT is disabled seems simple and useful.
