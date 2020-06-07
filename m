Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E013D1F0D45
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgFGRGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 13:06:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:10691 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgFGRGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 13:06:47 -0400
IronPort-SDR: s0hGtRTdLwe4l5pdhypfts7/GG4frbT5PMeR49SlEMg3vBOXRVy5+nttmJI+ezvJlFPUPfvBSs
 AGrgbfxH3N/A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2020 10:06:46 -0700
IronPort-SDR: uUzlo3huFi1ThPCjSgzE0xHNrO0RN1kM5QO4+J/yTdEihKjOtn3uwokhHmbD3lcM/SHP6umQ2H
 uCTpIq/gMdoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,485,1583222400"; 
   d="scan'208";a="273992627"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2020 10:06:46 -0700
Date:   Sun, 7 Jun 2020 10:06:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that
 aren't whitelisted
Message-ID: <20200607170646.GD24576@linux.intel.com>
References: <20200605192605.7439-1-sean.j.christopherson@intel.com>
 <985fb434-523d-3fa0-072c-c039d532bbb0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985fb434-523d-3fa0-072c-c039d532bbb0@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 06, 2020 at 10:51:06AM +0800, Xiaoyao Li wrote:
> On 6/6/2020 3:26 AM, Sean Christopherson wrote:
> >Choo! Choo!  All aboard the Split Lock Express, with direct service to
> >Wreckage!
> >
> >Skip split_lock_verify_msr() if the CPU isn't whitelisted as a possible
> >SLD-enabled CPU model to avoid writing MSR_TEST_CTRL.  MSR_TEST_CTRL
> >exists, and is writable, on many generations of CPUs.  Writing the MSR,
> >even with '0', can result in bizarre, undocumented behavior.
> >
> >This fixes a crash on Haswell when resuming from suspend with a live KVM
> >guest.  Because APs use the standard SMP boot flow for resume, they will
> >go through split_lock_init() and the subsequent RDMSR/WRMSR sequence,
> >which runs even when sld_state==sld_off to ensure SLD is disabled.  On
> >Haswell (at least, my Haswell), writing MSR_TEST_CTRL with '0' will
> >succeed and _may_ take the SMT _sibling_ out of VMX root mode.
> >
> >When KVM has an active guest, KVM performs VMXON as part of CPU onlining
> >(see kvm_starting_cpu()).  Because SMP boot is serialized, the resulting
> >flow is effectively:
> >
> >   on_each_ap_cpu() {
> >      WRMSR(MSR_TEST_CTRL, 0)
> >      VMXON
> >   }
> >
> >As a result, the WRMSR can disable VMX on a different CPU that has
> >already done VMXON.  This ultimately results in a #UD on VMPTRLD when
> >KVM regains control and attempt run its vCPUs.
> >
> >The above voodoo was confirmed by reworking KVM's VMXON flow to write
> >MSR_TEST_CTRL prior to VMXON, and to serialize the sequence as above.
> >Further verification of the insanity was done by redoing VMXON on all
> >APs after the initial WRMSR->VMXON sequence.  The additional VMXON,
> >which should VM-Fail, occasionally succeeded, and also eliminated the
> >unexpected #UD on VMPTRLD.
> >
> >The damage done by writing MSR_TEST_CTRL doesn't appear to be limited
> >to VMX, e.g. after suspend with an active KVM guest, subsequent reboots
> >almost always hang (even when fudging VMXON), a #UD on a random Jcc was
> >observed, suspend/resume stability is qualitatively poor, and so on and
> >so forth.
> >
> 
> I'm wondering if all those side-effects of MSR_TEST_CTRL exist on CPUs have
> SLD feature, have you ever tested on a SLD capable CPU?

No, I'll poke at it on ICX tomorrow.
