Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7C1CE26C
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 20:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgEKSRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 14:17:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:53739 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbgEKSRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 14:17:45 -0400
IronPort-SDR: SjcOT8Syf+YMgUMB6EuYVtTFHC0yTl+hxCHpBth3WoRzNP6OeS973hPtOPXr+Yc1sYP1cXqUKF
 pqWyTlPNTRug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 11:17:44 -0700
IronPort-SDR: S4r1fZ5oBzH+5W8qh1aHRie2tfvQereT2aab4/Wgzm9tNyHvCxkt3Xv6ofnbGa2wlWF1R1+Whq
 X9YSTU8ZOJJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="261849896"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2020 11:17:44 -0700
Date:   Mon, 11 May 2020 11:17:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v9 3/8] x86/split_lock: Introduce flag
 X86_FEATURE_SLD_FATAL and drop sld_state
Message-ID: <20200511181744.GF24052@linux.intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
 <20200509110542.8159-4-xiaoyao.li@intel.com>
 <CALCETrXwtj5rhVM6YYNEDeDqT3eKFNkGFCgSB_hUd7aOYBFXmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXwtj5rhVM6YYNEDeDqT3eKFNkGFCgSB_hUd7aOYBFXmw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 09, 2020 at 10:14:02PM -0700, Andy Lutomirski wrote:
> On Fri, May 8, 2020 at 8:03 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >
> > Introduce a synthetic feature flag X86_FEATURE_SLD_FATAL, which means
> > kernel is in sld_fatal mode if set.
> >
> > Now sld_state is not needed any more that the state of SLD can be
> > inferred from X86_FEATURE_SPLIT_LOCK_DETECT and X86_FEATURE_SLD_FATAL.
> 
> Is it too much to ask for Intel to actually allocate and define a
> CPUID bit that means "this CPU *always* sends #AC on a split lock"?
> This would be a pure documentation change, but it would make this
> architectural rather than something that each hypervisor needs to hack
> up.

The original plan was to request a bit in MSR_TEST_CTRL be documented as
such.  Then we discovered that defining IA32_CORE_CAPABILITIES enumeration
as architectural was an SDM bug[*].  At that point, enumerating SLD to a
KVM guest through a KVM CPUID leaf is the least awful option.  Emulating the
model specific behavior doesn't provide userspace with a sane way to disable
SLD for a guest, and emulating IA32_CORE_CAPABILITIES behavior would be
tantamount to emulating model specific behavior.

Once paravirt is required for basic SLD enumeration, tacking on the "fatal"
indicator is a minor blip.

I agree that having to reinvent the wheel for every hypervisor is completely
ridiculous, but it provides well defined and controllable behavior.  We
could try to get two CPUID bits defined in the SDM, but pushing through all
the bureaucracy that gates SDM changes means we wouldn't have a resolution
for at least multiple months, assuming the proposal was even accepted.

[*] https://lkml.kernel.org/r/20200416205754.21177-3-tony.luck@intel.com
 
> Meanwhile, I don't see why adding a cpufeature flag is worthwhile to
> avoid a less bizarre global variable.  There's no performance issue
> here, and the old code looked a lot more comprehensible than the new
> code.

The flag has two main advantages:

  - Automatically available to modules, i.e. KVM.
  - Visible to userspace in /proc/cpuinfo.

Making the global variable available to KVM is ugly because it either
requires exporting the variable and the enums (which gets especially nasty
because kvm_intel can be built with CONFIG_CPU_SUP_INTEL=n), or requires
adding a dedicated is_sld_fatal() wrapper and thus more exported crud.

And IMO, the feature flag is the less bizarre option once it's "public"
knowledge, e.g. more in line with features that enumerate both basic support
and sub-features via CPUID bits.
