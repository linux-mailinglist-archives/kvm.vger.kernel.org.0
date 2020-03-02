Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A3E176503
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBUfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:35:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:12716 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgCBUfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:35:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 12:35:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="233495414"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 12:35:10 -0800
Date:   Mon, 2 Mar 2020 12:35:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 5/6] KVM: x86: Rename "found" variable in kvm_cpuid() to
 "exact_entry_exists"
Message-ID: <20200302203510.GF6244@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-6-sean.j.christopherson@intel.com>
 <680d85ee-948c-6968-2d1a-d563d4863140@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680d85ee-948c-6968-2d1a-d563d4863140@siemens.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 09:20:52PM +0100, Jan Kiszka wrote:
> On 02.03.20 20:57, Sean Christopherson wrote:
> >Rename "found" in kvm_cpuid() to "exact_entry_exists" to better convey
> >that the intent of the tracepoint's "found/not found" output is to trace
> >whether the output values are for the actual requested leaf or for some
> >other (likely unrelated) leaf that was found while processing entries to
> >emulate funky CPU behavior, e.g. the max basic leaf on Intel CPUs when
> >the requested CPUID leaf is out of range.
> >
> >Suggested-by: Jan Kiszka <jan.kiszka@siemens.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kvm/cpuid.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >index 869526930cf7..b0a4f3c17932 100644
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -1002,10 +1002,10 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >  {
> >  	const u32 function = *eax, index = *ecx;
> >  	struct kvm_cpuid_entry2 *entry;
> >-	bool found;
> >+	bool exact_entry_exists;
> >  	entry = kvm_find_cpuid_entry(vcpu, function, index);
> >-	found = entry;
> >+	exact_entry_exists = !!entry;
> >  	/*
> >  	 * Intel CPUID semantics treats any query for an out-of-range
> >  	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> >@@ -1047,7 +1047,7 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >  			}
> >  		}
> >  	}
> >-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
> >+	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
> 
> Actually, I think we also what to change output in the tracepoint.

Oh, I definitely want to change it, but AIUI it's ABI and shouldn't be
changed.  Paolo?
