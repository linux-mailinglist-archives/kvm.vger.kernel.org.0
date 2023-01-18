Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD78E672140
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjARP15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjARP1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:27:25 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C37C212F;
        Wed, 18 Jan 2023 07:27:22 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id B06F020E09F3; Wed, 18 Jan 2023 07:27:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B06F020E09F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1674055641;
        bh=nyM2Q/9B+FBlb3H/YYpaI5gb/MfRcINPjbbYDRtXRvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4qKpnRqJ7WP304w/B16ae2Q649R06mFxTS7U97Kex+JcUGcCcovw8E04oBMJ3hyA
         wYOYr4TT92Y/UV6eOljcJ1Gg2ah8qaVp3BvZRT+4wLybZD4TxUG8uTXl8mO846sa8H
         NdAMJP3V0PzHbjg/PQZCf9vZONzArtpPyWj2EmZQ=
Date:   Wed, 18 Jan 2023 07:27:21 -0800
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
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 44/64] KVM: SVM: Remove the long-lived GHCB host
 map
Message-ID: <20230118152721.GA24742@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-45-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-45-michael.roth@amd.com>
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

On Wed, Dec 14, 2022 at 01:40:36PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB GPA,
> and unmaps it just before VM-entry. This long-lived GHCB map is used by
> the VMGEXIT handler through accessors such as ghcb_{set_get}_xxx().
> 
> A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
> SEV-SNP is enabled the mapped GPA needs to be protected against a page
> state change.
> 
> To eliminate the long-lived GHCB mapping, update the GHCB sync operations
> to explicitly map the GHCB before access and unmap it after access is
> complete. This requires that the setting of the GHCBs sw_exit_info_{1,2}
> fields be done during sev_es_sync_to_ghcb(), so create two new fields in
> the vcpu_svm struct to hold these values when required to be set outside
> of the GHCB mapping.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: defer per_cpu() assignment and order it with barrier() to fix case
>       where kvm_vcpu_map() causes reschedule on different CPU]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 131 ++++++++++++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.c |  18 +++---
>  arch/x86/kvm/svm/svm.h |  24 +++++++-
>  3 files changed, 116 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d5c6e48055fb..6ac0cb6e3484 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2921,15 +2921,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>  	kvfree(svm->sev_es.ghcb_sa);
>  }
>  
> +static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
> +{
> +	struct vmcb_control_area *control = &svm->vmcb->control;
> +	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
> +
> +	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
> +		/* Unable to map GHCB from guest */
> +		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
> +{
> +	kvm_vcpu_unmap(&svm->vcpu, map, true);
> +}
> +
>  static void dump_ghcb(struct vcpu_svm *svm)
>  {
> -	struct ghcb *ghcb = svm->sev_es.ghcb;
> +	struct kvm_host_map map;
>  	unsigned int nbits;
> +	struct ghcb *ghcb;
> +
> +	if (svm_map_ghcb(svm, &map))
> +		return;
> +
> +	ghcb = map.hva;

dump_ghcb() is called from sev_es_validate_vmgexit() with the ghcb already
mapped. How about passing 'struct kvm_host_map *' (or struct ghcb *) as a
param to avoid double mapping?

>  
>  	/* Re-use the dump_invalid_vmcb module parameter */
>  	if (!dump_invalid_vmcb) {
>  		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
> -		return;
> +		goto e_unmap;
>  	}
>  
>  	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
> @@ -2944,12 +2969,21 @@ static void dump_ghcb(struct vcpu_svm *svm)
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
>  	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
>  	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
> +
> +e_unmap:
> +	svm_unmap_ghcb(svm, &map);
>  }
>  
> -static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
> +static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct ghcb *ghcb = svm->sev_es.ghcb;
> +	struct kvm_host_map map;
> +	struct ghcb *ghcb;
> +
> +	if (svm_map_ghcb(svm, &map))
> +		return false;
> +
> +	ghcb = map.hva;
>  
>  	/*
>  	 * The GHCB protocol so far allows for the following data
> @@ -2963,13 +2997,24 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
>  	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
>  	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
>  	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
> +
> +	/*
> +	 * Copy the return values from the exit_info_{1,2}.
> +	 */
> +	ghcb_set_sw_exit_info_1(ghcb, svm->sev_es.ghcb_sw_exit_info_1);
> +	ghcb_set_sw_exit_info_2(ghcb, svm->sev_es.ghcb_sw_exit_info_2);
> +
> +	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
> +
> +	svm_unmap_ghcb(svm, &map);
> +
> +	return true;
>  }
>  
> -static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> +static void sev_es_sync_from_ghcb(struct vcpu_svm *svm, struct ghcb *ghcb)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct ghcb *ghcb = svm->sev_es.ghcb;
>  	u64 exit_code;
>  
>  	/*
> @@ -3013,20 +3058,25 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>  }
>  
> -static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
> +static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
>  {
> -	struct kvm_vcpu *vcpu;
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm_host_map map;
>  	struct ghcb *ghcb;
> -	u64 exit_code;
>  	u64 reason;
>  
> -	ghcb = svm->sev_es.ghcb;
> +	if (svm_map_ghcb(svm, &map))
> +		return -EFAULT;
> +
> +	ghcb = map.hva;
> +
> +	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
>  
>  	/*
>  	 * Retrieve the exit code now even though it may not be marked valid
>  	 * as it could help with debugging.
>  	 */
> -	exit_code = ghcb_get_sw_exit_code(ghcb);
> +	*exit_code = ghcb_get_sw_exit_code(ghcb);
>  
>  	/* Only GHCB Usage code 0 is supported */
>  	if (ghcb->ghcb_usage) {
> @@ -3119,6 +3169,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		goto vmgexit_err;
>  	}
>  
> +	sev_es_sync_from_ghcb(svm, ghcb);
> +
> +	svm_unmap_ghcb(svm, &map);
>  	return 0;
>  
>  vmgexit_err:
> @@ -3129,10 +3182,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  			    ghcb->ghcb_usage);
>  	} else if (reason == GHCB_ERR_INVALID_EVENT) {
>  		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
> -			    exit_code);
> +			    *exit_code);
>  	} else {
>  		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
> -			    exit_code);
> +			    *exit_code);
>  		dump_ghcb(svm);
>  	}
>  
> @@ -3142,6 +3195,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	ghcb_set_sw_exit_info_1(ghcb, 2);
>  	ghcb_set_sw_exit_info_2(ghcb, reason);
>  
> +	svm_unmap_ghcb(svm, &map);
> +
>  	/* Resume the guest to "return" the error code. */
>  	return 1;
>  }
