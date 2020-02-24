Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB4F16B55A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 00:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgBXXZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 18:25:58 -0500
Received: from mga17.intel.com ([192.55.52.151]:27462 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgBXXZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 18:25:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 15:25:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="410040498"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2020 15:25:54 -0800
Date:   Mon, 24 Feb 2020 15:25:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/61] KVM: x86: Introduce kvm_cpu_caps to replace
 runtime CPUID masking
Message-ID: <20200224232554.GR29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-39-sean.j.christopherson@intel.com>
 <87h7zgndxl.fsf@vitty.brq.redhat.com>
 <20200224225743.GP29865@linux.intel.com>
 <87ftezmv30.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftezmv30.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 12:20:03AM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Feb 24, 2020 at 05:32:54PM +0100, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> 
> 
> ...
> 
> >
> >> > +
> >> > +	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
> >> > +		     sizeof(boot_cpu_data.x86_capability));
> >> > +
> >> > +	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
> >> > +	       sizeof(kvm_cpu_caps));
> >> > +
> >> > +	kvm_cpu_cap_mask(CPUID_1_EDX,
> >> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> >> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> >> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> >> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> >> > +		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
> >> > +		0 /* Reserved, DS, ACPI */ | F(MMX) |
> >> > +		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
> >> > +		0 /* HTT, TM, Reserved, PBE */
> >> > +	);
> >> > +
> >> > +	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> >> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> >> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> >> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> >> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> >> > +		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> >> > +		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> >> > +		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
> >> > +		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
> >> > +	);
> >> > +
> >> > +	kvm_cpu_cap_mask(CPUID_1_ECX,
> >> > +		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
> >> > +		 * but *not* advertised to guests via CPUID ! */
> >> > +		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
> >> > +		0 /* DS-CPL, VMX, SMX, EST */ |
> >> > +		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> >> > +		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
> >> > +		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> >> > +		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
> >> > +		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> >> > +		F(F16C) | F(RDRAND)
> >> > +	);
> >> 
> >> I would suggest we order things by CPUID_NUM here, i.e.
> >> 
> >> CPUID_1_ECX
> >> CPUID_1_EDX
> >> CPUID_7_1_EAX
> >> CPUID_7_0_EBX
> >> CPUID_7_ECX
> >> CPUID_7_EDX
> >> CPUID_D_1_EAX
> >> ...
> >
> > Hmm, generally speaking I agree, but I didn't want to change the ordering
> > in this patch when moving the code.  Throw a patch on top?  Leave as is?
> > Something else?
> 
> My line of thought was: it's not a mechanical "s,const u32
> xxx_x86_features =,kvm_cpu_cap_mask...," change, things get moved from
> do_cpuid_7_mask() and __do_cpuid_func() so we may as well re-order them,
> reviewing-wise it's more or less the same. But honestly, this is very
> minor, feel free to leave as-is.

Fair enough, I'll throw it into this patch.
