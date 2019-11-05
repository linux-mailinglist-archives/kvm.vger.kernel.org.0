Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39DDF0A2C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 00:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfKEXZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 18:25:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:5100 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfKEXZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 18:25:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 15:25:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="285479561"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 05 Nov 2019 15:25:28 -0800
Date:   Tue, 5 Nov 2019 15:25:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191105232528.GF23297@linux.intel.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105200218.GF3079@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105200218.GF3079@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 09:02:18PM +0100, Peter Zijlstra wrote:
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
> The only way virt topology can make any sense what so ever is if the
> vcpus are pinned to physical CPUs.
>
> And I was under the impression we already had a bit for that (isn't it
> used to disable paravirt spinlocks and the like?). But I cannot seem to
> find it in a hurry.

Yep, KVM_HINTS_REALTIME does what you describe.

> So I would much rather you have a bit that indicates the 1:1 vcpu/cpu
> mapping and if that is set accept the topology information and otherwise
> completely ignore it.

