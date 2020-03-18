Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBA18A10F
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCRRCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:02:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:13839 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgCRRCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 13:02:48 -0400
IronPort-SDR: GW29u5MqL4Q8TtV2DWHAvHtSWbFdDCJfe1XKgdYVSbJN22Yc/+XM7KNr8Dm4aXAINDi256qQpf
 Dxz2kSePep/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 10:02:41 -0700
IronPort-SDR: lvUm8X+7IdYPGh9PtUcxWuWLT07MuzXrRMbkxoFh+siGmQn+69FHUjG/Eogg9Axe8F5cIsxP9w
 y4hOLekTV9tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="244885698"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 18 Mar 2020 10:02:41 -0700
Date:   Wed, 18 Mar 2020 10:02:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM
 transition with EPT enabled
Message-ID: <20200318170241.GJ24357@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-32-sean.j.christopherson@intel.com>
 <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
 <20200317182251.GD12959@linux.intel.com>
 <218d4dbd-20f1-5bf8-ca44-c53dd9345dab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <218d4dbd-20f1-5bf8-ca44-c53dd9345dab@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 11:36:04AM +0100, Paolo Bonzini wrote:
> On 17/03/20 19:22, Sean Christopherson wrote:
> > On Tue, Mar 17, 2020 at 06:18:37PM +0100, Paolo Bonzini wrote:
> >> On 17/03/20 05:52, Sean Christopherson wrote:
> >>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >>> index d816f1366943..a77eab5b0e8a 100644
> >>> --- a/arch/x86/kvm/vmx/nested.c
> >>> +++ b/arch/x86/kvm/vmx/nested.c
> >>> @@ -1123,7 +1123,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
> >>>  	}
> >>>  
> >>>  	if (!nested_ept)
> >>> -		kvm_mmu_new_cr3(vcpu, cr3, false);
> >>> +		kvm_mmu_new_cr3(vcpu, cr3, enable_ept);
> >>
> >> Even if enable_ept == false, we could have already scheduled or flushed
> >> the TLB soon due to one of 1) nested_vmx_transition_tlb_flush 2)
> >> vpid_sync_context in prepare_vmcs02 3) the processor doing it for
> >> !enable_vpid.
> >>
> >> So for !enable_ept only KVM_REQ_MMU_SYNC is needed, not
> >> KVM_REQ_TLB_FLUSH_CURRENT I think.  Worth adding a TODO?
> > 
> > Now that you point it out, I think it makes sense to unconditionally pass
> > %true here, i.e. rely 100% on nested_vmx_transition_tlb_flush() to do the
> > right thing.
> 
> Why doesn't it need KVM_REQ_MMU_SYNC either?

Hmm, so if L1 is using VPID, we're ok without a sync.  Junaid's INVVPID
patch earlier in this series ensures cached roots won't retain unsync'd
SPTEs when L1 does INVVPID.  If L1 doesn't flush L2's TLB on VM-Entry, it
can't expect L2 to recognize changes in the PTEs since the last INVVPID.

Per Intel's SDM, INVLPG (and INVPCID) are only required to invalidate
entries for the current VPID, i.e. virtual VPID=0 when executed by L1.

  Operations that architecturally invalidate entries in the TLBs or
  paging-structure caches independent of VMX operation (e.g., the INVLPG and
  INVPCID instructions) invalidate linear mappings and combined mappings.
  They are required to do so only for the current VPID.
                             ^^^^^^^^^^^^^^^^^^^^^^^^^

If L1 isn't using VPID and L0 isn't using EPT, then a sync is required as
L1 would expect PTE changes to be recognized without an explicit INVLPG
prior to VM-Ennter.

So something like this?

	if (!nested_ept)
		kvm_mmu_new_cr3(vcpu, cr3, enable_ept ||
					   nested_cpu_has_vpid(vmcs12));

The KVM_REQ_TLB_FLUSH_CURRENT request would be redundant with
nested_vmx_transition_tlb_flush() when VPID is enabled, and is a (big) nop
when VPID is disabled.  In either case the overhead is negligible.  Ideally
this logic would tie into nested_vmx_transition_tlb_flush() in some way,
but making that happen may be wishful thinking.

> All this should be in a comment as well, of course.

Heh, in hindsight that's painfully obvious.
