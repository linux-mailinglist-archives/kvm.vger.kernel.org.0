Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33317EEF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfEHRPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:15:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:35640 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbfEHRPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:15:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 10:15:41 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 10:15:40 -0700
Date:   Wed, 8 May 2019 10:15:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
Message-ID: <20190508171540.GB19656@linux.intel.com>
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
 <EF5B3191-09E8-488E-8748-CA9F6FAC9D7A@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EF5B3191-09E8-488E-8748-CA9F6FAC9D7A@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 07:55:13PM +0300, Liran Alon wrote:
> 
> 
> > On 8 May 2019, at 19:08, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > The RDPMC-exiting control is dependent on the existence of the RDPMC
> > instruction itself, i.e. is not tied to the "Architectural Performance
> > Monitoring" feature.  For all intents and purposes, the control exists
> > on all CPUs with VMX support since RDPMC also exists on all VCPUs with
> > VMX supported.  Per Intel's SDM:
> > 
> > The RDPMC instruction was introduced into the IA-32 Architecture in
> > the Pentium Pro processor and the Pentium processor with MMX technology.
> > The earlier Pentium processors have performance-monitoring counters, but
> > they must be read with the RDMSR instruction.
> > 
> > Because RDPMC-exiting always exists, KVM requires the control and refuses
> > to load if it's not available.  As a result, hiding the PMU from a guest
> > breaks nested virtualization if the guest attemts to use KVM.
> > 
> 
> If I understand correctly, you mean that there were CPUs at the past that had
> performance-counters but without PMU and could have been read by RDMSR
> instead of RDPMC?

That's a true statement, but not what I meant.  To try and reword, there
are CPUs that have a PMU and RDPMC, and thus RDPMC-exiting, but do NOT
report their PMU capabilities via CPUID 0xA.  The kernel code to init the
PMU is probably the best example (X86_FEATURE_ARCH_PERFMON is effectively
a reflection of the existence of CPUID 0xA).

__init int intel_pmu_init(void)
{
	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
		switch (boot_cpu_data.x86) {
		case 0x6:
			return p6_pmu_init();
		case 0xb:
			return knc_pmu_init();
		case 0xf:
			return p4_pmu_init();
		}
		return -ENODEV;
	}
} 

> And there is no CPUID bit that expose if performance-counters even exists?
> You just need to try to RDPMC and see if it #GP?

AFAIK the non-architectural perfmons aren't enumerated via CPUID.  I'm
pretty most of them don't have any enumeration beyond the CPU model,
i.e. software needs to essentially hardcode support based on the CPU model
and maybe some topology info.

So from a unit test perspective, the most compatible approach is to just
eat the #GP, but I think it's also completely reasonable to test RDPMC
without interception if and only if architectural perfmons are supported.

> If the answer to all above questions is “yes” to all questions above then I’m
> sorry for my misunderstanding with this original commit and: Reviewed-by:
> Liran Alon <liran.alon@oracle.com>
