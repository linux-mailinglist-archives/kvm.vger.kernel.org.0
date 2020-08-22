Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644DB24E4CC
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 05:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHVDZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 23:25:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:35172 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgHVDZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 23:25:21 -0400
IronPort-SDR: tDz4iyuN6wrVnbpBrg0njlvLaYf0MjvZRfVIBtFran2O5HTIEt8ZBxGeIba7NhoWVmQL/ivwMD
 GJUnB5pAIouw==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="173712830"
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="173712830"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:25:20 -0700
IronPort-SDR: tAW8mPvqo4dg2FCWdB2tTGhwBD7f2IaISnCLzRUVVi0qIzDl/eroheG5lqajt7zFuXPvRJP9jd
 V0Q0nojDVnYA==
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="280417718"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:25:19 -0700
Date:   Fri, 21 Aug 2020 20:25:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Shier <pshier@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates
 detected
Message-ID: <20200822032518.GB4769@sjchrist-ice>
References: <20200820230545.2411347-1-pshier@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820230545.2411347-1-pshier@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 04:05:45PM -0700, Peter Shier wrote:
> When L2 uses PAE, L0 intercepts of L2 writes to CR0/CR3/CR4 call
> load_pdptrs to read the possibly updated PDPTEs from the guest
> physical address referenced by CR3.  It loads them into
> vcpu->arch.walk_mmu->pdptrs and sets VCPU_EXREG_PDPTR in
> vcpu->arch.regs_dirty.
> 
> At the subsequent assumed reentry into L2, the mmu will call
> vmx_load_mmu_pgd which calls ept_load_pdptrs. ept_load_pdptrs sees
> VCPU_EXREG_PDPTR set in vcpu->arch.regs_dirty and loads
> VMCS02.GUEST_PDPTRn from vcpu->arch.walk_mmu->pdptrs[]. This all works
> if the L2 CRn write intercept always resumes L2.
> 
> The resume path calls vmx_check_nested_events which checks for
> exceptions, MTF, and expired VMX preemption timers. If
> vmx_check_nested_events finds any of these conditions pending it will
> reflect the corresponding exit into L1. Live migration at this point
> would also cause a missed immediate reentry into L2.
> 
> After L1 exits, vmx_vcpu_run calls vmx_register_cache_reset which
> clears VCPU_EXREG_PDPTR in vcpu->arch.regs_dirty.  When L2 next
> resumes, ept_load_pdptrs finds VCPU_EXREG_PDPTR clear in
> vcpu->arch.regs_dirty and does not load VMCS02.GUEST_PDPTRn from
> vcpu->arch.walk_mmu->pdptrs[]. prepare_vmcs02 will then load
> VMCS02.GUEST_PDPTRn from vmcs12->pdptr0/1/2/3 which contain the stale
> values stored at last L2 exit. A repro of this bug showed L2 entering
> triple fault immediately due to the bad VMCS02.GUEST_PDPTRn values.
> 
> When L2 is in PAE paging mode add a call to ept_load_pdptrs before
> leaving L2. This will update VMCS02.GUEST_PDPTRn if they are dirty in
> vcpu->arch.walk_mmu->pdptrs[].
> 
> Tested:
> kvm-unit-tests with new directed test: vmx_mtf_pdpte_test.
> Verified that test fails without the fix.
> 
> Also ran Google internal VMM with an Ubuntu 16.04 4.4.0-83 guest running a
> custom hypervisor with a 32-bit Windows XP L2 guest using PAE. Prior to fix
> would repro readily. Ran 14 simultaneous L2s for 140 iterations with no
> failures.
> 
> Signed-off-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
