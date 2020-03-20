Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5418C64A
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 05:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCTELD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 00:11:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:8176 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgCTELD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 00:11:03 -0400
IronPort-SDR: nPLQpVSQWslliwwzUsTqjkrtVj+4Qem5kNU8KAPXRbb0v1xZLWbQHvDv0IrcfvQcmaR0HJByJ9
 tc5L2BPXmunQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 21:11:02 -0700
IronPort-SDR: w3bTWbbZ23larvI1SORC8UY+DGaYEWukj8OMaFJtlkwN6+aHD0PU/e1A1LWlFgIdUzLw7U0+On
 RZoOtJ3LqgQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="418586574"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 19 Mar 2020 21:11:02 -0700
Date:   Thu, 19 Mar 2020 21:11:02 -0700
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
Subject: Re: [PATCH v2 04/32] KVM: nVMX: Invalidate all L2 roots when
 emulating INVVPID without EPT
Message-ID: <20200320041102.GG11305@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317045238.30434-5-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 16, 2020 at 09:52:10PM -0700, Sean Christopherson wrote:
> From: Junaid Shahid <junaids@google.com>
> 
> Free all L2 (guest_mmu) roots when emulating INVVPID for L1 and EPT is
> disabled, as outstanding changes to the page tables managed by L1 need
> to be recognized.
> 
> Similar to handle_invpcid() and handle_invept(), rely on
> kvm_mmu_free_roots() to do a remote TLB flush if necessary, e.g. if L1
> has never entered L2 then there is nothing to be done.
> 
> Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
> Signed-off-by: Junaid Shahid <junaids@google.com>
> [sean: ported to upstream KVM, reworded the comment and changelog]
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9624cea4ed9f..50bb7d8862aa 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5250,6 +5250,17 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  		return kvm_skip_emulated_instruction(vcpu);
>  	}
>  
> +	/*
> +	 * Sync L2's shadow page tables if EPT is disabled, L1 is effectively
> +	 * invalidating linear mappings for L2 (tagged with L2's VPID).  Sync
> +	 * all roots as VPIDs are not tracked in the MMU role.
> +	 *
> +	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
> +	 */
> +	if (!enable_ept)
> +		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,

Aha!  This is wrong.  guest_mmu is only used if EPT is enabled.  The silver
lining is that I have confirmed that this code is needed and works as
intended (when the correct mmu is nuked).

> +				   KVM_MMU_ROOTS_ALL);
> +
>  	return nested_vmx_succeed(vcpu);
>  }
>  
> -- 
> 2.24.1
> 
