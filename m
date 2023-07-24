Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0192475EC14
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 08:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjGXG5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 02:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjGXG5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 02:57:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1837F107;
        Sun, 23 Jul 2023 23:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690181841; x=1721717841;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hzgW3XbMQhympMgtkpz/hErFuxbnJHXnsA77Dv1eAbE=;
  b=EDLGaSdoMipzSSWjT3QLSsG2BVCXIuFiwxp0pWoWXkxqW8oC2qN0tfTm
   4W7N5LdR/KCsBIJvqKRmYFiGpfQf/59hsDJhoF5vAvIL4dCwH1mD6LZED
   6ejzE8Cn4s2eU8NRlLVLI46tlF/fik0uQ0hGXn0Wagg48Dh/Mq9DwDvSe
   AlgSY2RDJdRhseeE+fFKMgqbi2W6cPAtbyWxuzT4lp110H96b9fpwXeHC
   +8M6UU+gwTdXv8j1wmRJn0Q15GdUhVcSKexDISLARQm/6lTDlFcW9NkS1
   qBRU6V6U6VRFZBuewI7MptPxGeXPiIiSdZHnzvIANe+xc+ReqtwFralDL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="347647622"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="347647622"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:57:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="675728766"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="675728766"
Received: from gchen17-mobl1.ccr.corp.intel.com (HELO localhost) ([10.254.212.12])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:57:17 -0700
Date:   Mon, 24 Jul 2023 14:57:14 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: VMX: Drop manual TLB flush when migrating
 vmcs.APIC_ACCESS_ADDR
Message-ID: <20230724065714.myht27z6uno2zmva@linux.intel.com>
References: <20230721233858.2343941-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230721233858.2343941-1-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 04:38:58PM -0700, Sean Christopherson wrote:
> Remove the superfluous flush of the current TLB in VMX's handling of
> migration of the APIC-access page, as a full TLB flush on all vCPUs will
> have already been performed in response to kvm_unmap_gfn_range() *if*
> there were SPTEs pointing at the APIC-access page.  And if there were no
> valid SPTEs, then there can't possibly be TLB entries to flush.
> 
> The extra flush was added by commit fb6c81984313 ("kvm: vmx: Flush TLB
> when the APIC-access address changes"), with the justification of "because
> the SDM says so".  The SDM said, and still says:
> 
>  As detailed in Section xx.x.x, an access to the APIC-access page might
>  not cause an APIC-access VM exit if software does not properly invalidate
>  information that may be cached from the EPT paging structures. If EPT was
>  in use on a logical processor at one time with EPTP X, it is recommended
>  that software use the INVEPT instruction with the “single-context” INVEPT
>  type and with EPTP X in the INVEPT descriptor before a VM entry on the
>  same logical processor that enables EPT with EPTP X and either (a) the
>  "virtualize APIC accesses" VM- execution control was changed from 0 to 1;
>  or (b) the value of the APIC-access address was changed.
> 
> But the "recommendation" for (b) is predicated on there actually being
> a valid EPT translation *and* possible TLB entries for the GPA (or guest
> VA when using shadow paging).  It's possible that a different vCPU has
> established a mapping for the new page, but the current vCPU can't have
> entered the guest, i.e. can't have created a TLB entry, between flushing
> the old mappings and changing its vmcs.APIC_ACCESS_ADDR.
> 
> kvm_unmap_gfn_range() waits for all vCPUs to ack KVM_REQ_APIC_PAGE_RELOAD,
> and then flushes remote TLBs (which may or may not also pend a request).
> Thus the vCPU is guaranteed to update vmcs.APIC_ACCESS_ADDR before
> re-entering the guest and before it can possibly create new TLB entries.
> 
> In other words, KVM does flush in this case, it just does so earlier
> on while handling the page migration.
> 
> Note, VMX also flushes if the vCPU is migrated to a new pCPU, i.e. if
> the vCPU is migrated to a pCPU that entered the guest for a different
> vCPU.
> 
> Suggested-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ecf4be2c6af..3f868826db7d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6767,8 +6767,10 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
>  	read_unlock(&vcpu->kvm->mmu_lock);
>  
> -	vmx_flush_tlb_current(vcpu);
> -
> +	/*
> +	 * No need for a manual TLB flush at this point, KVM has already done a
> +	 * flush if there were SPTEs pointing at the previous page.
> +	 */
>  out:
>  	/*
>  	 * Do not pin apic access page in memory, the MMU notifier
> 

Reviewed-by: Yu Zhang <yu.c.zhang@linux.intel.com>

