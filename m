Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07673125371
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 21:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfLRU1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 15:27:04 -0500
Received: from mga06.intel.com ([134.134.136.31]:18174 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfLRU1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 15:27:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 12:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="240909955"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 18 Dec 2019 12:27:02 -0800
Date:   Wed, 18 Dec 2019 12:27:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 1/2] KVM: x86/mmu: Allow for overriding MMIO SPTE mask
Message-ID: <20191218202702.GF25201@linux.intel.com>
References: <cover.1576698347.git.thomas.lendacky@amd.com>
 <10fdb77c9b6795f68137cf4315571ab791ab6feb.1576698347.git.thomas.lendacky@amd.com>
 <f0bc54c8-cea2-e574-6191-5c34d1b504c9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0bc54c8-cea2-e574-6191-5c34d1b504c9@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:51:23PM -0600, Tom Lendacky wrote:
> On 12/18/19 1:45 PM, Tom Lendacky wrote:
> > The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
> > faults when a guest performs MMIO. The AMD memory encryption support uses
> > CPUID functions to define the encryption bit position. Given this, KVM
> > can't assume that bit 51 will be safe all the time.
> > 
> > Add a callback to return a reserved bit(s) mask that can be used for the
> > MMIO pagetable entries. The callback is not responsible for setting the
> > present bit.
> > 
> > If a callback is registered:
> >   - any non-zero mask returned is updated with the present bit and used
> >     as the MMIO SPTE mask.
> >   - a zero mask returned results in a mask with only bit 51 set (i.e. no
> >     present bit) as the MMIO SPTE mask, similar to the way 52-bit physical
> >     addressing is handled.
> > 
> > If no callback is registered, the current method of setting the MMIO SPTE
> > mask is used.
> > 
> > Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++-
> >  arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
> >  arch/x86/kvm/x86.c              |  2 +-
> >  3 files changed, 38 insertions(+), 22 deletions(-)
> 
> This patch has some extra churn because kvm_x86_ops isn't set yet when the
> call to kvm_set_mmio_spte_mask() is made. If it's not a problem to move
> setting kvm_x86_ops just a bit earlier in kvm_arch_init(), some of the
> churn can be avoided.

As a completely different alternative, what about handling this purely
within SVM code by overriding the masks during svm_hardware_setup(),
similar to how VMX handles EPT's custom masks, e.g.:

	/*
	 * Override the MMIO masks if memory encryption support is enabled:
	 *   The physical addressing width is reduced. The first bit above the
	 *   new physical addressing limit will always be reserved.
	 */
	if (cpuid_eax(0x80000000) >= 0x8000001f) {
		rdmsrl(MSR_K8_SYSCFG, msr);
		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT) {
			mask = BIT_ULL(boot_cpu_data.x86_phys_bits) | BIT_ULL(0);
			kvm_mmu_set_mmio_spte_mask(mask, mask,
						   ACC_WRITE_MASK | ACC_USER_MASK);
		}
	}
