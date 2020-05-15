Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361DD1D5965
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 20:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgEOSqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 14:46:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:21894 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbgEOSqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 14:46:47 -0400
IronPort-SDR: i3/ge2RAF+xNKhm6D8+xDGinQBkDxH/wavun5MkdP9n6FWxwyvo+1B9kRdpAw2nyiHl564Fut5
 Bb68AbU72tOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 11:46:46 -0700
IronPort-SDR: 3nFF7Vdveb0kAvH6CP5v3LJy6xFk/DYCbDl/wBEvvs7oko3gF2NS+Wzm9kfH2kVBksHuuF94k0
 dK+Lb67/9vQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="299130175"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 May 2020 11:46:46 -0700
Date:   Fri, 15 May 2020 11:46:46 -0700
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
Message-ID: <20200515184646.GD17572@linux.intel.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com>
 <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 05:59:43PM +0200, Paolo Bonzini wrote:
> On 13/05/20 14:52, Vivek Goyal wrote:
> >>> Also, type of event should not necessarily be tied to delivery method.
> >>> For example if we end up introducing say, "KVM_PV_REASON_PAGE_ERROR", then
> >>> I would think that event can be injected both using exception (#PF or #VE)
> >>> as well as interrupt (depending on state of system).
> >> Why bother preserving backwards compatibility?
> > New machanism does not have to support old guests but old mechanism
> > should probably continue to work and deprecated slowly, IMHO. Otherwise
> > guests which were receiving async page faults will suddenly stop getting
> > it over hypervisor upgrade and possibly see drop in performance.
> 
> Unfortunately, the old mechanism was broken enough, and in enough
> different ways, that it's better to just drop it.
> 
> The new one using #VE is not coming very soon (we need to emulate it for
> <Broadwell and AMD processors, so it's not entirely trivial) so we are
> going to keep "page not ready" delivery using #PF for some time or even
> forever.  However, page ready notification as #PF is going away for good.

And isn't hardware based EPT Violation #VE going to require a completely
different protocol than what is implemented today?  For hardware based #VE,
KVM won't intercept the fault, i.e. the guest will need to make an explicit
hypercall to request the page.  That seems like it'll be as time consuming
to implement as emulating EPT Violation #VE in KVM.

> That said, type1/type2 is quite bad. :)  Let's change that to page not
> present / page ready.

Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
can (ab)use the error code to indicate an async #PF by setting it to an
impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
is even enforced by the SDM, which states:

  [SGX] this flag is set only if the P flag (bit 0) is 1 and the RSVD flag
  (bit 3) and the PK flag (bit 5) are both 0.

I.e. we've got bigger problems if hardware generates a !PRESENT, WRITE, RSVD,
PK, SGX page fault :-)

Then the page ready becomes the only guest-side consumer of the in-memory
struct, e.g. it can be renamed to something like kvm_vcpu_pv_apf_ready and
doesn't need a reason field (though it still needs a "busy" bit) as written.
It'd also eliminate the apf_put_user() in kvm_arch_async_page_not_present().

I believe it would also allow implementing (in the future) "async #PF ready"
as a ring buffer, i.e. allow kvm_check_async_pf_completion() to coalesce all
ready pages into a single injected interrupt.
