Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267DF17EF84
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 05:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgCJEAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 00:00:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:30242 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgCJEAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 00:00:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 21:00:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,535,1574150400"; 
   d="scan'208";a="276786041"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 09 Mar 2020 21:00:23 -0700
Date:   Mon, 9 Mar 2020 21:00:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 6/6] KVM: x86: Add requested index to the CPUID tracepoint
Message-ID: <20200310040023.GF19235@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-7-sean.j.christopherson@intel.com>
 <00827dc7-3338-ce1a-923a-784284cb26db@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00827dc7-3338-ce1a-923a-784284cb26db@web.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 07, 2020 at 10:48:25AM +0100, Jan Kiszka wrote:
> On 02.03.20 20:57, Sean Christopherson wrote:
> >Output the requested index when tracing CPUID emulation; it's basically
> >mandatory for leafs where the index is meaningful, and is helpful for
> >verifying KVM correctness even when the index isn't meaningful, e.g. the
> >trace for a Linux guest's hypervisor_cpuid_base() probing appears to
> >be broken (returns all zeroes) at first glance, but is correct because
> >the index is non-zero, i.e. the output values correspond to random index
> >in the maximum basic leaf.
> >
> >Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >Cc: Jan Kiszka <jan.kiszka@siemens.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kvm/cpuid.c |  3 ++-
> >  arch/x86/kvm/trace.h | 13 ++++++++-----
> >  2 files changed, 10 insertions(+), 6 deletions(-)
> >
> >diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >index b0a4f3c17932..a3c9f6bf43f3 100644
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -1047,7 +1047,8 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >  			}
> >  		}
> >  	}
> >-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
> >+	trace_kvm_cpuid(function, index, *eax, *ebx, *ecx, *edx,
> >+			exact_entry_exists);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_cpuid);
> >
> >diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> >index f194dd058470..aa372d0119f0 100644
> >--- a/arch/x86/kvm/trace.h
> >+++ b/arch/x86/kvm/trace.h
> >@@ -151,12 +151,14 @@ TRACE_EVENT(kvm_fast_mmio,
> >   * Tracepoint for cpuid.
> >   */
> >  TRACE_EVENT(kvm_cpuid,
> >-	TP_PROTO(unsigned int function, unsigned long rax, unsigned long rbx,
> >-		 unsigned long rcx, unsigned long rdx, bool found),
> >-	TP_ARGS(function, rax, rbx, rcx, rdx, found),
> >+	TP_PROTO(unsigned int function, unsigned int index, unsigned long rax,
> >+		 unsigned long rbx, unsigned long rcx, unsigned long rdx,
> >+		 bool found),
> >+	TP_ARGS(function, index, rax, rbx, rcx, rdx, found),
> >
> >  	TP_STRUCT__entry(
> >  		__field(	unsigned int,	function	)
> >+		__field(	unsigned int,	index		)
> >  		__field(	unsigned long,	rax		)
> >  		__field(	unsigned long,	rbx		)
> >  		__field(	unsigned long,	rcx		)
> >@@ -166,6 +168,7 @@ TRACE_EVENT(kvm_cpuid,
> >
> >  	TP_fast_assign(
> >  		__entry->function	= function;
> >+		__entry->index		= index;
> >  		__entry->rax		= rax;
> >  		__entry->rbx		= rbx;
> >  		__entry->rcx		= rcx;
> >@@ -173,8 +176,8 @@ TRACE_EVENT(kvm_cpuid,
> >  		__entry->found		= found;
> >  	),
> >
> >-	TP_printk("func %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
> >-		  __entry->function, __entry->rax,
> >+	TP_printk("func %x idx %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
> >+		  __entry->function, __entry->index, __entry->rax,
> >  		  __entry->rbx, __entry->rcx, __entry->rdx,
> >  		  __entry->found ? "found" : "not found")
> >  );
> >
> 
> What happened to this patch in your v2 round?

I completely forgot about it...
