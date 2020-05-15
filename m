Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF501D5AD1
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgEOUnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 16:43:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:54172 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgEOUnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 16:43:43 -0400
IronPort-SDR: mNCkszfwk4KQHK2Lz6zEGNhkiVKp+GSUZjs+ja2ronjKAYmgvG47Xs+T8HdUjtLVDRCoDSwdqm
 xhbELYhOGfNg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 13:43:42 -0700
IronPort-SDR: C/gpw8Hg3aXmhOkQDX7IUHG1v0S+g5qIRBnJsr7Y+/NmNAq9VKvrzCW5T1qa5mt+WqpIHY8BJc
 Q0RPRwBIrFSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="372798275"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 15 May 2020 13:43:41 -0700
Date:   Fri, 15 May 2020 13:43:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200515204341.GF17572@linux.intel.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com>
 <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 09:18:07PM +0200, Paolo Bonzini wrote:
> On 15/05/20 20:46, Sean Christopherson wrote:
> > Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
> > only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
> > can (ab)use the error code to indicate an async #PF by setting it to an
> > impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
> > is even enforced by the SDM, which states:
> 
> Possibly, but it's water under the bridge now.

Why is that?  I thought we were redoing the entire thing because the current
ABI is unfixably broken?  In other words, since the guest needs to change,
why are we keeping any of the current async #PF pieces?  E.g. why keep using
#PF instead of usurping something like #NP?

> And the #PF mechanism also has the problem with NMIs that happen before the
> error code is read and page faults happening in the handler.

Hrm, I think there's no unfixable problem except for a pathological
#PF->NMI->#DB->#PF scenario.  But it is a problem :-(

FWIW, the error code isn't a problem, CR2 is the killer.  The issue Andy
originally pointed out is

  #PF: async page fault (KVM_PV_REASON_PAGE_NOT_PRESENT)
     NMI: before CR2 or KVM_PF_REASON_PAGE_NOT_PRESENT
       #PF: normal page fault (NMI handler accesses user memory, e.g. perf)

With current async #PF, the problem is that CR2 and apf_reason are out of
sync, not that CR2 or the error code are lost.  E.g. the above could also
happen with a regular #PF on both ends, and obviously that works just fine.

In other words, the error code doesn't suffer the same problem because it's
pushed on the stack, not shoved into a static memory location.

CR2 is the real problem, even though it's saved by the NMI handler.  The
simple case where the NMI handler hits an async #PF before it can save CR2
is avoidable by KVM not injecting #PF if NMIs are blocked.  The pathological
case would be if there's a #DB at the beginning of the NMI handler; the IRET
from the #DB would unblock NMIs and then open up the guest to hitting an
async #PF on the NMI handler before CR2 is saved by the guest. :-(
