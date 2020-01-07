Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B823133774
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 00:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAGXbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 18:31:04 -0500
Received: from mga12.intel.com ([192.55.52.136]:33852 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgAGXbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 18:31:03 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 15:31:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,407,1571727600"; 
   d="scan'208";a="370772634"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 07 Jan 2020 15:31:02 -0800
Date:   Tue, 7 Jan 2020 15:31:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
Message-ID: <20200107233102.GC16987@linux.intel.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
 <298352c6-7670-2929-9621-1124775bfaed@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298352c6-7670-2929-9621-1124775bfaed@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 07, 2020 at 04:54:34PM -0600, Tom Lendacky wrote:
> On 1/7/20 4:28 PM, Sean Christopherson wrote:
> > On Tue, Jan 07, 2020 at 02:16:37PM -0600, Tom Lendacky wrote:
> >> On 1/6/20 5:38 PM, Sean Christopherson wrote:
> >>> On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
> >>>> On 1/6/20 4:49 PM, Sean Christopherson wrote:
> >>>>> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
> >>>>> on a future processor, i.e. x86_phys_bits==52.
> >>>>
> >>>> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
> >>>> always be a reduction in physical addressing (so I'm told).
> >>>
> >>> Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
> >>> that reducing the PA space is optional.  Section 7.10.2 is especially
> >>> clear on this:
> >>>
> >>>   In implementations where the physical address size of the processor is
> >>>   reduced when memory encryption features are enabled, software must
> >>>   ensure it is executing from addresses where these upper physical address
> >>>   bits are 0 prior to setting SYSCFG[MemEncryptionModEn].
> >>
> >> It's probably not likely, but given what is stated, I can modify my patch
> >> to check for a x86_phys_bits == 52 and skip the call to set the mask, eg:
> >>
> >> 	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT &&
> >> 	    boot_cpu_data.x86_phys_bits < 52) {
> >>
> >>>
> >>> But, hopefully the other approach I have in mind actually works, as it's
> >>> significantly less special-case code and would naturally handle either
> >>> case, i.e. make this a moot point.
> >>
> >> I'll hold off on the above and wait for your patch.
> > 
> > Sorry for the delay, this is a bigger mess than originally thought.  Or
> > I'm completely misunderstanding the issue, which is also a distinct
> > possibility :-)
> > 
> > Due to KVM activating its L1TF mitigation irrespective of whether the CPU
> > is whitelisted as not being vulnerable to L1TF, simply using 86_phys_bits
> > to avoid colliding with the C-bit isn't sufficient as the L1TF mitigation
> > uses those first five reserved PA bits to store the MMIO GFN.  Setting
> > BIT(x86_phys_bits) for all MMIO sptes would cause it to be interpreted as
> > a GFN bit when the L1TF mitigation is active and lead to bogus MMIO.
> 
> The L1TF mitigation only gets applied when:
>   boot_cpu_data.x86_cache_bits < 52 - shadow_nonpresent_or_rsvd_mask_len
> 
>   and with shadow_nonpresent_or_rsvd_mask_len = 5, that means that means
>   boot_cpu_data.x86_cache_bits < 47.
> 
> On AMD processors that support memory encryption, the x86_cache_bits value
> is not adjusted, just the x86_phys_bits. So for AMD processors that have
> memory encryption support, this value will be at least 48 and therefore
> not activate the L1TF mitigation.

Ah.  Hrm.  I'd prefer to clean that code up to make the interactions more
explicit, but may be we can separate that out.

> > The only sane approach I can think of is to activate the L1TF mitigation
> > based on whether the CPU is vulnerable to L1TF, as opposed to activating> the mitigation purely based on the max PA of the CPU.  Since all CPUs that
> > support SME/SEV are whitelisted as NO_L1TF, the L1TF mitigation and C-bit
> > should never be active at the same time.
> 
> There is still the issue of setting a single bit that can conflict with
> the C-bit. As it is today, if the C-bit were to be defined as bit 51, then
> KVM would not take a nested page fault and MMIO would be broken.

Wouldn't Paolo's patch to use the raw "cpuid_eax(0x80000008) & 0xff" for
shadow_phys_bits fix that particular collision by causing
kvm_set_mmio_spte_mask() to clear the present bit?  Or am I misundertanding
how the PA reduction interacts with the C-Bit?

AIUI, using phys_bits=48, then the standard scenario is Cbit=47 and some
additional bits 46:M are reserved.  Applying that logic to phys_bits=52,
then Cbit=51 and bits 50:M are reserved, so there's a collision but it's
mostly benign because shadow_phys_bits==52, which triggers this:

	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
		mask &= ~1ull;

In other words, Paolo's patch fixes the fatal bug, but unnecessarily
disables optimized MMIO page faults.  To remedy that, your idea is to rely
on the (undocumented?) behavior that there are always additional reserved
bits between Cbit and the reduced x86_phys_bits.
