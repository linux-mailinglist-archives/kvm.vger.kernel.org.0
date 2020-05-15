Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D471D5B03
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 22:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgEOUxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 16:53:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:56975 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgEOUxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 16:53:25 -0400
IronPort-SDR: J7SGBl2TzjLYIVDcqHF0maJXasVq3PnmAFNXvxSSMgqvRpWWrOS8WOrBI4QB7tbYJi/CLGk3W4
 xa9T4bcoZnrg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 13:53:25 -0700
IronPort-SDR: C95Rn81/ebN/JuIa+TmgAU88CFYBuDbTazAR2EdLVuXxAV20KTsFp8hGgUbfhNNzT4zTx58pux
 tErfs3B52l+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="253889602"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 15 May 2020 13:53:24 -0700
Date:   Fri, 15 May 2020 13:53:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20200515205323.GG17572@linux.intel.com>
References: <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com>
 <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
 <20200515203352.GC235744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515203352.GC235744@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 04:33:52PM -0400, Vivek Goyal wrote:
> On Fri, May 15, 2020 at 09:18:07PM +0200, Paolo Bonzini wrote:
> > On 15/05/20 20:46, Sean Christopherson wrote:
> > >> The new one using #VE is not coming very soon (we need to emulate it for
> > >> <Broadwell and AMD processors, so it's not entirely trivial) so we are
> > >> going to keep "page not ready" delivery using #PF for some time or even
> > >> forever.  However, page ready notification as #PF is going away for good.
> > > 
> > > And isn't hardware based EPT Violation #VE going to require a completely
> > > different protocol than what is implemented today?  For hardware based #VE,
> > > KVM won't intercept the fault, i.e. the guest will need to make an explicit
> > > hypercall to request the page.
> > 
> > Yes, but it's a fairly simple hypercall to implement.
> > 
> > >> That said, type1/type2 is quite bad. :)  Let's change that to page not
> > >> present / page ready.
> > > 
> > > Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
> > > only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
> > > can (ab)use the error code to indicate an async #PF by setting it to an
> > > impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
> > > is even enforced by the SDM, which states:
> > 
> > Possibly, but it's water under the bridge now.
> > And the #PF mechanism also has the problem with NMIs that happen before
> > the error code is read
> > and page faults happening in the handler (you may connect some dots now).
> 
> I understood that following was racy.
> 
> do_async_page_fault <--- kvm injected async page fault
>   NMI happens (Before kvm_read_and_reset_pf_reason() is done)
>    ->do_async_page_fault() (This is regular page fault but it will read
>    			    reason from shared area and will treat itself
> 			    as async page fault)
> 
> So this is racy.
> 
> But if we get rid of the notion of reading from shared region in page
> fault handler, will we not get rid of this race.
> 
> I am assuming that error_code is not racy as it is pushed on stack.
> What am I missing.

Nothing, AFAICT.  As I mentioned in a different mail, CR2 can be squished,
but I don't see how error code can be lost.

But, because CR2 can be squished, there still needs to be an in-memory busy
flag even if error code is used as the host #PF indicator, otherwise the
guest could lose one of the tokens.
