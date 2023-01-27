Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78BE67EB04
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 17:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbjA0QgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 11:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbjA0QgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 11:36:00 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 284FB618E;
        Fri, 27 Jan 2023 08:35:59 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id B0B8420E67B2; Fri, 27 Jan 2023 08:35:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B0B8420E67B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1674837358;
        bh=5mcq7PhD4YcYFiNvlkFyavcQvg058yspKz8CTNW7J0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkRCVg+OBrYhnPug4FolKelm2JCHd7Xe4GUCmlQ6MN+/NXslq8sX7eEt7OHQusJep
         Knu7vIhyveaE3kvQferaAI9ot0U7bu7+1dsz7hVckQoJHcODUeB0IwLHJ9TDz5S2fA
         5mI093Wr1Or0tGtD89BYQ/q5K8uYO00ZrDMJ2pVs=
Date:   Fri, 27 Jan 2023 08:35:58 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 07/64] KVM: SEV: Handle KVM_HC_MAP_GPA_RANGE
 hypercall
Message-ID: <20230127163558.GA22533@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-8-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-8-michael.roth@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:59PM -0600, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> KVM_HC_MAP_GPA_RANGE hypercall is used by the SEV guest to notify a
> change in the page encryption status to the hypervisor.
> 
> The hypercall exits to userspace with KVM_EXIT_HYPERCALL exit code,
> currently this is used for explicit memory conversion between
> shared/private for memfd based private memory.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/x86.c  | 8 ++++++++
>  virt/kvm/kvm_main.c | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bb6adb216054..732f9cbbadb5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9649,6 +9649,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)

Couldn't find a better commit to comment on:
when the guest has the ptp-kvm module, it will issue a KVM_HC_CLOCK_PAIRING
hypercall. This will pass sev_es_validate_vmgexit validation and end up in this
function where kvm_pv_clock_pairing() is called, and that calls
kvm_write_guest(). This results in a CPU soft-lockup, at least in my testing.

Are there any emulated hypercalls that make sense for snp guests? We should
block at least the ones that definitely don't work.

Jeremi

>  		break;
>  	case KVM_HC_MAP_GPA_RANGE: {
>  		u64 gpa = a0, npages = a1, attrs = a2;
> +		struct kvm_memory_slot *slot;
>  
>  		ret = -KVM_ENOSYS;
>  		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
> @@ -9660,6 +9661,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  			break;
>  		}
>  
> +		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> +		if (!vcpu->kvm->arch.upm_mode ||
> +		    !kvm_slot_can_be_private(slot)) {
> +			ret = 0;
> +			break;
> +		}
> +
>  		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
>  		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
>  		vcpu->run->hypercall.args[0]  = gpa;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d2daa049e94a..73bf0bdedb59 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2646,6 +2646,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>  
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
> -- 
> 2.25.1
> 
