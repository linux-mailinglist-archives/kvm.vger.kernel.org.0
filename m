Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED191D5CB4
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 01:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgEOXRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 19:17:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:24010 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOXRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 19:17:00 -0400
IronPort-SDR: MnN96HectqR7Qc8tYZoXMOyIwn4jPHD//pLJC3Pwjnp3rmnx7NpX1imP2M+gLkwFdFJ2e7CD5J
 PFcGmZqsDnWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 16:16:59 -0700
IronPort-SDR: PHU/VX9vgI/7VIW37J4x5i+7JOJ9G2tdqImmyZ5/EMGp3IeC6e/K7lE9ayaAny0Z+tF2Hvas1n
 m+js3FvpH83A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="263342711"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 15 May 2020 16:16:59 -0700
Date:   Fri, 15 May 2020 16:16:59 -0700
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
        linux-kernel@vger.kernel.org,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200515231659.GM17572@linux.intel.com>
References: <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com>
 <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
 <20200515204341.GF17572@linux.intel.com>
 <943cfc2f-5b18-e00a-f5a2-4577472a1ff5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <943cfc2f-5b18-e00a-f5a2-4577472a1ff5@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 16, 2020 at 12:23:31AM +0200, Paolo Bonzini wrote:
> On 15/05/20 22:43, Sean Christopherson wrote:
> > On Fri, May 15, 2020 at 09:18:07PM +0200, Paolo Bonzini wrote:
> >> On 15/05/20 20:46, Sean Christopherson wrote:
> >>> Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
> >>> only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
> >>> can (ab)use the error code to indicate an async #PF by setting it to an
> >>> impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
> >>> is even enforced by the SDM, which states:
> >>
> >> Possibly, but it's water under the bridge now.
> > 
> > Why is that?  I thought we were redoing the entire thing because the current
> > ABI is unfixably broken?  In other words, since the guest needs to change,
> > why are we keeping any of the current async #PF pieces?  E.g. why keep using
> > #PF instead of usurping something like #NP?
> 
> Because that would be 3 ABIs to support instead of 2.  The #PF solution
> is only broken as long as you allow async PF from ring 0 (which wasn't
> even true except for preemptable kernels) _and_ have NMIs that can
> generate page faults.  We also have the #PF vmexit part for nested
> virtualization.  This adds up and makes a quick fix for 'page not ready'
> notifications not that quick.
> 
> However, interrupts for 'page ready' do have a bunch of advantages (more
> control on what can be preempted by the notification, a saner check for
> new page faults which is effectively a bug fix) so it makes sense to get
> them in more quickly (probably 5.9 at this point due to the massive
> cleanups that are being done around interrupt vectors).

Ah, so the plan is to fix 'page ready' for the current ABI, but keep the
existing 'page not ready' part because it's not thaaaat broken.  Correct?

In that case, is Andy's patch to kill KVM_ASYNC_PF_SEND_ALWAYS in the guest
being picked up?

I'll read through your #VE stuff on Monday :-).
