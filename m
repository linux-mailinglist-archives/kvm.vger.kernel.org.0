Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCB9177C0D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgCCQie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:38:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:35796 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgCCQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:38:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:38:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="274268961"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2020 08:38:33 -0800
Date:   Tue, 3 Mar 2020 08:38:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 0/6] KVM: x86: CPUID emulation and tracing fixes
Message-ID: <20200303163833.GK1439@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <f4a13ce0-1545-4ef7-d95c-2ce2db24a90d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4a13ce0-1545-4ef7-d95c-2ce2db24a90d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 09:48:44AM +0100, Paolo Bonzini wrote:
> On 02/03/20 20:57, Sean Christopherson wrote:
> > Two fixes related to out-of-range CPUID emulation and related cleanup on
> > top.
> > 
> > I have a unit test and also manually verified a few interesting cases.
> > I'm not planning on posting the unit test at this time because I haven't
> > figured out how to avoid false positives, e.g. if a random in-bounds
> > leaf just happens to match the output of a max basic leaf.  It might be
> > doable by hardcoding the cpu model?
> 
> It would be best suited for selftests rather than kvm-unit-tests.  But I 
> don't really see the benefit of anything more than just

Gotta save those stack bytes?

I got a bit confused by the "max" variable; I thought it would hold the
max basic leaf, not CPUID.0x0.  Removing it seemed easier than trying to
come up with a better name :-)
 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..c1abf5de4461 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1001,6 +1001,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  	       u32 *ecx, u32 *edx, bool check_limit)
>  {
>  	u32 function = *eax, index = *ecx;
> +	u32 orig_function = function;
>  	struct kvm_cpuid_entry2 *entry;
>  	struct kvm_cpuid_entry2 *max;
>  	bool found;
> @@ -1049,7 +1050,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  			}
>  		}
>  	}
> -	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
> +	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
>  	return found;
>  }
>  EXPORT_SYMBOL_GPL(kvm_cpuid);
> 
