Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7241AC78
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbhI1J6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 05:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240063AbhI1J6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 05:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632823002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Ac1KzapFbm3DrLpJhS8RPsZYRZpeFigmvf6S+kYg10=;
        b=eJ5y8nRaNyADvgFwx4dt07Jh58Dij5voS6ZYdygh+PZAwfMYZzEWk1ZfLKfkOu7tlx7Siu
        Tsn8S4r4VQkbaKodcAnDyDVw3b0yCXVqTwruCmevIHm/wqzHgLYGn+oE+XB1LQXE5M6PjP
        o2mKSFUakaUsAAXekX3QnFmLGJJ5TVM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-Ae_dxL_yNuqPqzDRBQK7jQ-1; Tue, 28 Sep 2021 05:56:40 -0400
X-MC-Unique: Ae_dxL_yNuqPqzDRBQK7jQ-1
Received: by mail-wr1-f70.google.com with SMTP id w2-20020a5d5442000000b0016061c95fb7so4168887wrv.12
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 02:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Ac1KzapFbm3DrLpJhS8RPsZYRZpeFigmvf6S+kYg10=;
        b=o0LXLVlj3K7SPp+sX6NZIF7vqhj8Fet17MlujljdcZvy/jQfSwW3HEnni1rgf9UKrZ
         cndwwYTN34IWU+YZ8JbndyLP+TlDNKiHR/ZezmHo1dHWBDUozBkyTwuTWdRWR99RTngH
         SjyOmRYYDToxJ5bbKaa2/V5DyQOy27x0CVj3KRtBEFaL6nKgZwqN9Q620WQK7vp/rUjs
         QFuawHNoqK/DbRIAodXNp+onmD96dnNwR0z2fESXbkeuwsIFoJ/nlb2pZHmDmQb4H8B+
         iIjEJtJKZN8+E5y0y48E2zLJsLAqm+ltR4uAMP2lsK3tb0ykDrx3PGal8OqsOAY/iCcK
         UEQQ==
X-Gm-Message-State: AOAM531mQIqdjPOs5tMOQ1WmEA7g93Y1Ije6HaBqlSmrk3yY7+CwUqN9
        lv9D21Ejw7SB6tVySTUqaBO5o2Y7ypAYkse6Me/V81heHPacrryFI4gYl4YA3H4RR/m4S6AeQjN
        9lj20Z2Bvmhoq
X-Received: by 2002:a5d:6343:: with SMTP id b3mr5205734wrw.124.1632822999509;
        Tue, 28 Sep 2021 02:56:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLOJkdLvKu+9MFHMG+herne+2M1V/vkdbPksCq7GDCqPbAQQGDN7120pkvAGNUeduom1Kn2w==
X-Received: by 2002:a5d:6343:: with SMTP id b3mr5205710wrw.124.1632822999284;
        Tue, 28 Sep 2021 02:56:39 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id l11sm2420077wms.45.2021.09.28.02.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 02:56:38 -0700 (PDT)
Date:   Tue, 28 Sep 2021 10:56:35 +0100
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
Subject: Re: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <YVLm0/8F8CDLEPXe@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-38-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-38-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> table to be private or shared using the Page State Change MSR protocol
> as defined in the GHCB specification.
> 
> Before changing the page state in the RMP entry, lookup the page in the
> NPT to make sure that there is a valid mapping for it. If the mapping
> exist then try to find a workable page level between the NPT and RMP for
> the page. If the page is not mapped in the NPT, then create a fault such
> that it gets mapped before we change the page state in the RMP entry.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |   9 ++
>  arch/x86/kvm/svm/sev.c            | 197 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/trace.h              |  34 ++++++
>  arch/x86/kvm/x86.c                |   1 +
>  4 files changed, 241 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 91089967ab09..4980f77aa1d5 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -89,6 +89,10 @@ enum psc_op {
>  };
>  
>  #define GHCB_MSR_PSC_REQ		0x014
> +#define GHCB_MSR_PSC_GFN_POS		12
> +#define GHCB_MSR_PSC_GFN_MASK		GENMASK_ULL(39, 0)
> +#define GHCB_MSR_PSC_OP_POS		52
> +#define GHCB_MSR_PSC_OP_MASK		0xf
>  #define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
>  	/* GHCBData[55:52] */				\
>  	(((u64)((op) & 0xf) << 52) |			\
> @@ -98,6 +102,11 @@ enum psc_op {
>  	GHCB_MSR_PSC_REQ)
>  
>  #define GHCB_MSR_PSC_RESP		0x015
> +#define GHCB_MSR_PSC_ERROR_POS		32
> +#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
> +#define GHCB_MSR_PSC_ERROR		GENMASK_ULL(31, 0)
> +#define GHCB_MSR_PSC_RSVD_POS		12
> +#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
>  #define GHCB_MSR_PSC_RESP_VAL(val)			\
>  	/* GHCBData[63:32] */				\
>  	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 991b8c996fc1..6d9483ec91ab 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -31,6 +31,7 @@
>  #include "svm_ops.h"
>  #include "cpuid.h"
>  #include "trace.h"
> +#include "mmu.h"
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> @@ -2905,6 +2906,181 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
>  	svm->vmcb->control.ghcb_gpa = value;
>  }
>  
> +static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +
> +	return psmash(pfn);
> +}
> +
> +static int snp_make_page_shared(struct kvm *kvm, gpa_t gpa, kvm_pfn_t pfn, int level)

....

> +
> +			/*
> +			 * Mark the userspace range unmerable before adding the pages

                                                    ^^^^^^^^^ typo

> +			 * in the RMP table.
> +			 */
> +			mmap_write_lock(kvm->mm);
> +			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
> +			mmap_write_unlock(kvm->mm);
> +			if (rc)
> +				return -EINVAL;
> +		}
> +
> +		write_lock(&kvm->mmu_lock);
> +
> +		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> +		if (!rc) {
> +			/*
> +			 * This may happen if another vCPU unmapped the page
> +			 * before we acquire the lock. Retry the PSC.
> +			 */
> +			write_unlock(&kvm->mmu_lock);
> +			return 0;
> +		}
> +
> +		/*
> +		 * Adjust the level so that we don't go higher than the backing
> +		 * page level.
> +		 */
> +		level = min_t(size_t, level, npt_level);
> +
> +		trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
> +
> +		switch (op) {
> +		case SNP_PAGE_STATE_SHARED:
> +			rc = snp_make_page_shared(kvm, gpa, pfn, level);
> +			break;
> +		case SNP_PAGE_STATE_PRIVATE:
> +			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);

Minor nit; it seems a shame that snp_make_page_shared and
rmp_make_private  both take gpa, pfn, level - in different orders.

Dave

> +			break;
> +		default:
> +			rc = -EINVAL;
> +			break;
> +		}
> +
> +		write_unlock(&kvm->mmu_lock);
> +
> +		if (rc) {
> +			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
> +					   op, gpa, pfn, level, rc);
> +			return rc;
> +		}
> +
> +		gpa = gpa + page_level_size(level);
> +	}
> +
> +	return 0;
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3005,6 +3181,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_PSC_REQ: {
> +		gfn_t gfn;
> +		int ret;
> +		enum psc_op op;
> +
> +		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_GFN_MASK, GHCB_MSR_PSC_GFN_POS);
> +		op = get_ghcb_msr_bits(svm, GHCB_MSR_PSC_OP_MASK, GHCB_MSR_PSC_OP_POS);
> +
> +		ret = __snp_handle_page_state_change(vcpu, op, gfn_to_gpa(gfn), PG_LEVEL_4K);
> +
> +		if (ret)
> +			set_ghcb_msr_bits(svm, GHCB_MSR_PSC_ERROR,
> +					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
> +		else
> +			set_ghcb_msr_bits(svm, 0,
> +					  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
> +
> +		set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
> +		break;
> +	}
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 1c360e07856f..35ca1cf8440a 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -7,6 +7,7 @@
>  #include <asm/svm.h>
>  #include <asm/clocksource.h>
>  #include <asm/pvclock-abi.h>
> +#include <asm/sev-common.h>
>  
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kvm
> @@ -1711,6 +1712,39 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
>  		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
>  );
>  
> +/*
> + * Tracepoint for the SEV-SNP page state change processing
> + */
> +#define psc_operation					\
> +	{SNP_PAGE_STATE_PRIVATE, "private"},		\
> +	{SNP_PAGE_STATE_SHARED,  "shared"}		\
> +
> +TRACE_EVENT(kvm_snp_psc,
> +	TP_PROTO(unsigned int vcpu_id, u64 pfn, u64 gpa, u8 op, int level),
> +	TP_ARGS(vcpu_id, pfn, gpa, op, level),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u64, pfn)
> +		__field(u64, gpa)
> +		__field(u8, op)
> +		__field(int, level)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id = vcpu_id;
> +		__entry->pfn = pfn;
> +		__entry->gpa = gpa;
> +		__entry->op = op;
> +		__entry->level = level;
> +	),
> +
> +	TP_printk("vcpu %u, pfn %llx, gpa %llx, op %s, level %d",
> +		  __entry->vcpu_id, __entry->pfn, __entry->gpa,
> +		  __print_symbolic(__entry->op, psc_operation),
> +		  __entry->level)
> +);
> +
>  #endif /* _TRACE_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..afcdc75a99f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12371,3 +12371,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

