Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1895D355871
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbhDFPse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhDFPsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 11:48:33 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A2C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 08:48:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso2984188pje.0
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 08:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=laZeNbGTjzk/8Smqz2d9x68PxPq/3zkf2RQckeInUrc=;
        b=vaMCcVuQU+xkQ7vHYGIarFeeBeCCKzlrZ2nfM2VXj9I8Wes92nRodmUF/F8HuSmt/H
         tW1vk3pFAT1FlHDOHXUDwDiRE5ITDEGp7r+aajfeqwbNU4PkwLyasn2DyVjmM+vtupZD
         CV1+/Xh4tC++VDO1/lTkzJm1uzOOWc4VhqSRtLFPcN/wlbNM+DxgPClNn4ejUTB0Vcwe
         6lgph+AXHd/y5KuQY8hO+vUgDkknPqrfRj8Ljgq+aNOrZ0/BS/tCIAX21j0nwB9KYsNl
         o0p1zpKo8npjiBSMfdbR2QhIVXuS2Keoaf4af47/Mv2fcTk3FUkfGc0OoYzrgkOafpih
         7pcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=laZeNbGTjzk/8Smqz2d9x68PxPq/3zkf2RQckeInUrc=;
        b=AkHRFiCr2pD4Te58aVETRyVIf9dPb+yiyMCDmkTycjXkK7/89h4fz3MyCufuhcpXe0
         kj70TYsrNRKWXrb095kNiCmesZT+co0k5LXN38oeTioFbUFKaY9jUIA3KphdYPy8xUt/
         yGxATs3WN+M/VkpXOBLStGSrFxtzi3xnzprMm0BgLPTuyLCLUWJTuwPe2/D9eFZNWjes
         1y7RbqYkMcBz4ELuffJtvoSbFatO45tFdzkjz9kg4fxdsMn0Bjj7e8yRWwRuaYoCL9zc
         0h03JYrYmeLds6EN3Jl27NnI/bfB7qyOSyaF08rG/Rcqz8fy+O4UCTDNY/8agB/oY+nF
         cLNw==
X-Gm-Message-State: AOAM533XP0sL5PCx27mF098pgruPMNIilDzVZb818p1E2VT8eXWX3Ujz
        w4SXBEa5/KzLiSuFJbI6NtR1hjzl2TnKdw==
X-Google-Smtp-Source: ABdhPJzchvT4Z6SPilEJJK9qhUx/vsuSORYI0NpUvl8rZ2/gXSA8UroDZbeLwaLtfX9hyyufQRDCkg==
X-Received: by 2002:a17:90a:5106:: with SMTP id t6mr5058538pjh.177.1617724104889;
        Tue, 06 Apr 2021 08:48:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u14sm2817113pji.15.2021.04.06.08.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:48:24 -0700 (PDT)
Date:   Tue, 6 Apr 2021 15:48:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com, will@kernel.org,
        maz@kernel.org, qperret@google.com
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YGyCxGsC2+GAtJxy@google.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 05, 2021, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..78284ebbbee7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>  
>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +	int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> +				  unsigned long sz, unsigned long mode);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c9795a22e502..fb3a315e5827 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->run->exit_reason = 0;
> +	kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> +	++vcpu->stat.hypercalls;
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +
> +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> +			   unsigned long npages, unsigned long enc)
> +{
> +	kvm_pfn_t pfn_start, pfn_end;
> +	struct kvm *kvm = vcpu->kvm;
> +	gfn_t gfn_start, gfn_end;
> +
> +	if (!sev_guest(kvm))
> +		return -EINVAL;
> +
> +	if (!npages)
> +		return 0;

Parth of me thinks passing a zero size should be an error not a nop.  Either way
works, just feels a bit weird to allow this to be a nop.

> +
> +	gfn_start = gpa_to_gfn(gpa);

This should check that @gpa is aligned.

> +	gfn_end = gfn_start + npages;
> +
> +	/* out of bound access error check */
> +	if (gfn_end <= gfn_start)
> +		return -EINVAL;
> +
> +	/* lets make sure that gpa exist in our memslot */
> +	pfn_start = gfn_to_pfn(kvm, gfn_start);
> +	pfn_end = gfn_to_pfn(kvm, gfn_end);
> +
> +	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> +		/*
> +		 * Allow guest MMIO range(s) to be added
> +		 * to the shared pages list.
> +		 */
> +		return -EINVAL;
> +	}
> +
> +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> +		/*
> +		 * Allow guest MMIO range(s) to be added
> +		 * to the shared pages list.
> +		 */
> +		return -EINVAL;
> +	}

I don't think KVM should do any checks beyond gfn_end <= gfn_start.  Just punt
to userspace and give userspace full say over what is/isn't legal.

> +
> +	if (enc)
> +		vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> +	else
> +		vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;

Use a single exit and pass "enc" via kvm_run.  I also strongly dislike "DMA",
there's no guarantee the guest is sharing memory for DMA.

I think we can usurp KVM_EXIT_HYPERCALL for this?  E.g.

	vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
	vcpu->run->hypercall.args[0]  = gfn_start << PAGE_SHIFT;
	vcpu->run->hypercall.args[1]  = npages * PAGE_SIZE;
	vcpu->run->hypercall.args[2]  = enc;
	vcpu->run->hypercall.longmode = is_64_bit_mode(vcpu);

> +
> +	vcpu->run->dma_sharing.addr = gfn_start;

Addresses and pfns are not the same thing.  If you're passing the size in bytes,
then it's probably best to pass the gpa, not the gfn.  Same for the params from
the guest, they should be in the same "domain".

> +	vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> +	vcpu->arch.complete_userspace_io =
> +		sev_complete_userspace_page_enc_status_hc;

I vote to drop the "userspace" part, it's already quite verbose.

	vcpu->arch.complete_userspace_io = sev_complete_page_enc_status_hc;

> +
> +	return 0;
> +}
> +

..

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7d12fca397b..ef5c77d59651 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_PAGE_ENC_STATUS: {
> +		int r;
> +
> +		ret = -KVM_ENOSYS;
> +		if (kvm_x86_ops.page_enc_status_hc) {
> +			r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);

Use static_call().

> +			if (r >= 0)
> +				return r;
> +			ret = r;
> +		}

Hmm, an alternative to adding a kvm_x86_ops hook would be to tag the VM as
supporting/allowing the hypercall.  That would clean up this code, ensure VMX
and SVM don't end up creating a different userspace ABI, and make it easier to
reuse the hypercall in the future (I'm still hopeful :-) ).  E.g.

	case KVM_HC_PAGE_ENC_STATUS: {
		u64 gpa = a0, nr_bytes = a1;

		if (!vcpu->kvm->arch.page_enc_hc_enable)
			break;

		if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(nr_bytes) ||
		    !nr_bytes || gpa + nr_bytes <= gpa)) {
			ret = -EINVAL;
			break;
		}

	        vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL; 
        	vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS; 
	        vcpu->run->hypercall.args[0]  = gpa;
        	vcpu->run->hypercall.args[1]  = nr_bytes;
	        vcpu->run->hypercall.args[2]  = enc;                                    
        	vcpu->run->hypercall.longmode = op_64_bit;
		vcpu->arch.complete_userspace_io = complete_page_enc_hc;
		return 0;
	}


> +		break;
> +	}
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
