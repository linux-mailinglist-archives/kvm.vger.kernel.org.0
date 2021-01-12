Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464532F2A59
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 09:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbhALIxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 03:53:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:61571 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbhALIxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 03:53:14 -0500
IronPort-SDR: Kjof5TNcM82GbehZZrGCz3wITnQ4zQE8b2TfOL7jXzH263xVcStSa0BjFX+VazXko5Bwhgm9qn
 qIJP1g+hv4mg==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="157783194"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="157783194"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 00:52:33 -0800
IronPort-SDR: f26fNsyodRZXCSfql94HotJYO0/wuJCDnyKEfCWUmUWkzqIzKWnYxb8Azg6RIwGT5i0NF829ap
 8vFHFJT+bmpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="352945168"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2021 00:52:32 -0800
Date:   Tue, 12 Jan 2021 17:04:21 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/access: Fixed test stuck issue on new
 52bit machine
Message-ID: <20210112090421.GA2614@local-michael-cet-test.sh.intel.com>
References: <20210110091942.12835-1-weijiang.yang@intel.com>
 <X/zQdznwyBXHoout@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/zQdznwyBXHoout@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021 at 02:25:59PM -0800, Sean Christopherson wrote:
> On Sun, Jan 10, 2021, Yang Weijiang wrote:
> > When the application is tested on a machine with 52bit-physical-address, the
> > synthesized 52bit GPA triggers EPT(4-Level) fast_page_fault infinitely.
> 
> That doesn't sound right, KVM should use 5-level EPT if guest maxpa > 48.
> Hmm, unless the CPU doesn't support 5-level EPT, but I didn't think such CPUs
> (maxpa=52 w/o 5-level EPT) existed?  Ah, but it would be possible with nested
> VMX, and initial KVM 5-level support didn't allow nested 5-level EPT.  Any
> chance you're running this test in a VM with 5-level EPT disabled, but maxpa=52?
>
Hi, Sean,
Thanks for the reply!
I use default settings of the unit-test + 5.2.0 QEMU + 5.10 kernel, in
this case, QEMU uses cpu->phys_bits==40, so the guest's PA=40bit and
LA=57bit, hence 5-level EPT is not enabled. My physical machine is PA=52
and LA=57 as can checked from cpuid:
cpuid -1r -l 0x80000008 -s 0
CPU:
   0x80000008 0x00: eax=0x00003934 ...
There're two other ways to w/a this issue: 1) change the QEMU params to
to extra_params = -cpu host,host-phys-bits, so guest's PA=52 and LA=57,
this will enable 5-level EPT, meanwhile, it escapes the problematic GPA
by adding AC_*_BIT51_MASK in invalid_mask.

2) add allow_smaller_maxphyaddr=1 to kvm-intel module.

the perf trace looks like this:
12481.879 qemu-system-x8/27004 kvm:kvm_page_fault:address 8000002000000
error_code 181

> > On the other hand, there's no reserved bits in 51:max_physical_address on
> > machines with 52bit-physical-address.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  x86/access.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> > 
> > diff --git a/x86/access.c b/x86/access.c
> > index 7dc9eb6..bec1c4d 100644
> > --- a/x86/access.c
> > +++ b/x86/access.c
> > @@ -15,6 +15,7 @@ static _Bool verbose = false;
> >  typedef unsigned long pt_element_t;
> >  static int invalid_mask;
> >  static int page_table_levels;
> > +static int max_phyaddr;
> >  
> >  #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
> >  #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
> > @@ -394,9 +395,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
> >      if (!F(AC_PDE_ACCESSED))
> >          at->ignore_pde = PT_ACCESSED_MASK;
> >  
> > -    pde_valid = F(AC_PDE_PRESENT)
> > -        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
> > +    pde_valid = F(AC_PDE_PRESENT) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
> >          && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
> > +    if (max_phyaddr < 52)
> > +        pde_valid &= !F(AC_PDE_BIT51);
> >  
> >      if (!pde_valid) {
> >          at->expected_fault = 1;
> > @@ -420,9 +422,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
> >  
> >      at->expected_pde |= PT_ACCESSED_MASK;
> >  
> > -    pte_valid = F(AC_PTE_PRESENT)
> > -        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
> > +    pte_valid = F(AC_PTE_PRESENT) && !F(AC_PTE_BIT36)
> >          && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
> > +    if (max_phyaddr < 52)
> > +        pte_valid &= !F(AC_PTE_BIT51);
> 
> This _should_ be unnecessary.  As below, AC_*_BIT51_MASK will be set in
> invalid_mask, and so ac_test_bump_one() will skip tests that try to set bit 51.
> 
These code is to avoid some "unexpected access" messages on some platforms
if below change is added.

> >      if (!pte_valid) {
> >          at->expected_fault = 1;
> > @@ -964,13 +967,11 @@ static int ac_test_run(void)
> >      shadow_cr4 = read_cr4();
> >      shadow_efer = rdmsr(MSR_EFER);
> >  
> > -    if (cpuid_maxphyaddr() >= 52) {
> > -        invalid_mask |= AC_PDE_BIT51_MASK;
> > -        invalid_mask |= AC_PTE_BIT51_MASK;
> > -    }
> > -    if (cpuid_maxphyaddr() >= 37) {
> > +    if (max_phyaddr  >= 37 && max_phyaddr < 52) {
> >          invalid_mask |= AC_PDE_BIT36_MASK;
> >          invalid_mask |= AC_PTE_BIT36_MASK;
> > +        invalid_mask |= AC_PDE_BIT51_MASK;
> > +        invalid_mask |= AC_PTE_BIT51_MASK;
> >      }
> 
> This change is incorrect.  "invalid_mask" is misleading in this context as it
> means "bits that can't be tested because they're legal".  So setting the bit 51
> flags in invalid_mask if 'maxpa >= 52' is correct, as it states those tests are
> "invalid" because setting bit 51 will not fault.

Maybe I misunderstood the purpose of this test, so I skipped the 
non-fault case, e.g., when maxpa >=52. In guest PA=40 case, AC_*_BIT51_MASK
bits are not added here, then when they're set in guest page_table
entries, does it expect a fault? What's the expected result on a real 52bit
platform?

> All that being said, it's also entirely possible I'm misreading this test, I've
> done it many times before :-)
> 
I found it's hard to pass all the enclosed tests on various platforms :-)

> >      if (this_cpu_has(X86_FEATURE_PKU)) {
> > @@ -1038,6 +1039,7 @@ int main(void)
> >      int r;
> >  
> >      printf("starting test\n\n");
> > +    max_phyaddr = cpuid_maxphyaddr();
> >      page_table_levels = 4;
> >      r = ac_test_run();
> >  
> > -- 
> > 2.17.2
> > 
