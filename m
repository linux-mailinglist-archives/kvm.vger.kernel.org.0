Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9341ACC3
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 12:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbhI1KSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 06:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240148AbhI1KSx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 06:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632824233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5uEz0zMzLI3u5SmcZkNM4/r8rAoFXUcwaUNur87ZOg=;
        b=LkoG9XukneGodjIKelr5XPdaThNAXzYB79P61YrXtUv2ecs1biUbcfYp6rfbpL9SnHpoQM
        Z8PbbmKpA09GxPoPJNYoIDvmqpfzRKWtLd2wNH0DgZTiZJ4Rh5kh25o0+eooASkMD1zsrS
        eLgsl1chEjG+MddqIxL99YSnLqMwVaU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-S5_CdorKP_SN-va1-AOY_g-1; Tue, 28 Sep 2021 06:17:12 -0400
X-MC-Unique: S5_CdorKP_SN-va1-AOY_g-1
Received: by mail-wm1-f72.google.com with SMTP id m2-20020a05600c3b0200b0030cd1310631so858338wms.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 03:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u5uEz0zMzLI3u5SmcZkNM4/r8rAoFXUcwaUNur87ZOg=;
        b=f23vxgpMba4odHJWR6Ti0SEAon4uu2nVdbzCvmJSYfiIGnrDG9Q3/GteL5+uRs2cdn
         JeQBFOXsHHQlaWWX2MD/kjDCJGnltgKs+pzKPURMVSq6wljcvafI/7GOAzOwya1Q1l/z
         nVUByTwGVJ6pDDGW8v2Z4HTAuxvb2ovUUxBQH/9d2hZaeOBlCSWmGNPKk04hY5AAPVgk
         MYmZ8sqMtYqB5W2RAqEwjm4+5BcpazqB3VmEUXhUZgXQyviYtkFJmT+Uycj28zjFBy77
         hjGVMBE+rI7BlLvs3alp67lCktEHKEVvB/1RLHYU6kqefGaZ/Jq46DPDfFSFXW4fsNoz
         l1Lw==
X-Gm-Message-State: AOAM533q6sZv0D33hD4Ko2IuBoWOuTrLSX3qZgpS//mQfJUAmNndhFnh
        PGo9uUkNbmt1ZNjlb1wsKbZsCo4xHIO2J3v6PCkx5obJlKRYdKJVIIPkChCJZXbZ4kDxUm/WD9w
        4H538N/GFRh7K
X-Received: by 2002:adf:a31a:: with SMTP id c26mr5544751wrb.307.1632824230963;
        Tue, 28 Sep 2021 03:17:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4oa2QFDFT6mx4r+tUchUFwttcM/2HMYFvdFMw6kKwLAjsy87wwmmIvXC04Mrykyg6n6P2kg==
X-Received: by 2002:adf:a31a:: with SMTP id c26mr5544717wrb.307.1632824230752;
        Tue, 28 Sep 2021 03:17:10 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id v17sm9829732wro.34.2021.09.28.03.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 03:17:09 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:17:07 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 38/45] KVM: SVM: Add support to handle Page
 State Change VMGEXIT
Message-ID: <YVLro9lWPguN7Wkv@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-39-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-39-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> table to be private or shared using the Page State Change NAE event
> as defined in the GHCB specification version 2.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  7 +++
>  arch/x86/kvm/svm/sev.c            | 82 +++++++++++++++++++++++++++++--
>  2 files changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 4980f77aa1d5..5ee30bb2cdb8 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -126,6 +126,13 @@ enum psc_op {
>  /* SNP Page State Change NAE event */
>  #define VMGEXIT_PSC_MAX_ENTRY		253
>  
> +/* The page state change hdr structure in not valid */
> +#define PSC_INVALID_HDR			1
> +/* The hdr.cur_entry or hdr.end_entry is not valid */
> +#define PSC_INVALID_ENTRY		2
> +/* Page state change encountered undefined error */
> +#define PSC_UNDEF_ERR			3
> +
>  struct psc_hdr {
>  	u16 cur_entry;
>  	u16 end_entry;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6d9483ec91ab..0de85ed63e9b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2731,6 +2731,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
>  	case SVM_VMGEXIT_AP_JUMP_TABLE:
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  	case SVM_VMGEXIT_HV_FEATURES:
> +	case SVM_VMGEXIT_PSC:
>  		break;
>  	default:
>  		goto vmgexit_err;
> @@ -3004,13 +3005,13 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>  		 */
>  		rc = snp_check_and_build_npt(vcpu, gpa, level);
>  		if (rc)
> -			return -EINVAL;
> +			return PSC_UNDEF_ERR;
>  
>  		if (op == SNP_PAGE_STATE_PRIVATE) {
>  			hva_t hva;
>  
>  			if (snp_gpa_to_hva(kvm, gpa, &hva))
> -				return -EINVAL;
> +				return PSC_UNDEF_ERR;
>  
>  			/*
>  			 * Verify that the hva range is registered. This enforcement is
> @@ -3022,7 +3023,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>  			rc = is_hva_registered(kvm, hva, page_level_size(level));
>  			mutex_unlock(&kvm->lock);
>  			if (!rc)
> -				return -EINVAL;
> +				return PSC_UNDEF_ERR;
>  
>  			/*
>  			 * Mark the userspace range unmerable before adding the pages
> @@ -3032,7 +3033,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>  			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
>  			mmap_write_unlock(kvm->mm);
>  			if (rc)
> -				return -EINVAL;
> +				return PSC_UNDEF_ERR;
>  		}
>  
>  		write_lock(&kvm->mmu_lock);
> @@ -3062,8 +3063,11 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>  		case SNP_PAGE_STATE_PRIVATE:
>  			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
>  			break;
> +		case SNP_PAGE_STATE_PSMASH:
> +		case SNP_PAGE_STATE_UNSMASH:
> +			/* TODO: Add support to handle it */
>  		default:
> -			rc = -EINVAL;
> +			rc = PSC_INVALID_ENTRY;
>  			break;
>  		}
>  
> @@ -3081,6 +3085,65 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>  	return 0;
>  }
>  
> +static inline unsigned long map_to_psc_vmgexit_code(int rc)
> +{
> +	switch (rc) {
> +	case PSC_INVALID_HDR:
> +		return ((1ul << 32) | 1);
> +	case PSC_INVALID_ENTRY:
> +		return ((1ul << 32) | 2);
> +	case RMPUPDATE_FAIL_OVERLAP:
> +		return ((3ul << 32) | 2);
> +	default: return (4ul << 32);
> +	}

Are these the values defined in 56421 section 4.1.6 ?
If so, that says:
  SW_EXITINFO2[63:32] == 0x00000100
      The hypervisor encountered some other error situation and was not able to complete the
      request identified by page_state_change_header.cur_entry. It is left to the guest to decide how
      to proceed in this situation.

so it looks like the default should be 0x100 rather than 4?

(It's a shame they're all magical constants, it would be nice if the
standard have them names)

Dave


> +}
> +
> +static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	int level, op, rc = PSC_UNDEF_ERR;
> +	struct snp_psc_desc *info;
> +	struct psc_entry *entry;
> +	u16 cur, end;
> +	gpa_t gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm))
> +		return PSC_INVALID_HDR;
> +
> +	if (!setup_vmgexit_scratch(svm, true, sizeof(*info))) {
> +		pr_err("vmgexit: scratch area is not setup.\n");
> +		return PSC_INVALID_HDR;
> +	}
> +
> +	info = (struct snp_psc_desc *)svm->ghcb_sa;
> +	cur = info->hdr.cur_entry;
> +	end = info->hdr.end_entry;
> +
> +	if (cur >= VMGEXIT_PSC_MAX_ENTRY ||
> +	    end >= VMGEXIT_PSC_MAX_ENTRY || cur > end)
> +		return PSC_INVALID_ENTRY;
> +
> +	for (; cur <= end; cur++) {
> +		entry = &info->entries[cur];
> +		gpa = gfn_to_gpa(entry->gfn);
> +		level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
> +		op = entry->operation;
> +
> +		if (!IS_ALIGNED(gpa, page_level_size(level))) {
> +			rc = PSC_INVALID_ENTRY;
> +			goto out;
> +		}
> +
> +		rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
> +		if (rc)
> +			goto out;
> +	}
> +
> +out:
> +	info->hdr.cur_entry = cur;
> +	return rc ? map_to_psc_vmgexit_code(rc) : 0;
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3315,6 +3378,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = 1;
>  		break;
>  	}
> +	case SVM_VMGEXIT_PSC: {
> +		unsigned long rc;
> +
> +		ret = 1;
> +
> +		rc = snp_handle_page_state_change(svm);
> +		svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +		break;
> +	}
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  		vcpu_unimpl(vcpu,
>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

