Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35AE50023D
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 01:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbiDMXG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 19:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiDMXGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 19:06:25 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF20A424B3
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 16:04:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id n22so2941113pfa.0
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 16:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2X3uicfOLSBUBzVzdE5/oWfcLTIRlhFHODXMCALg0vU=;
        b=Hntq20sATPLdJyU/h7Ttcsthca71JopiVmru2qp5Pz1Iydac/eHjcTEuqaAadrjVwR
         VxblHLjHcgFpGinccN+V9JEncr6KbwQHvQV1jiboVzjIIlcrWX3V5Ce8ouosHlvAwOon
         NBactZtCPJIMIqIsH0S71j0QdhVsnVvg0lqPJtql+HXtAiI41ghYXBTbig2IdrP5mGwR
         p92Qaw+N2NH0OQ9LPtNmyqbL+ZuqbRyeZMq6sNUyZktzAH3SWu/od9znpRAR35/EK3p3
         8dpoJOiV2nzGwPaq7YoS81ZLzj28tstEEEiWVN2hTN26nSYhRcvPcZQDll5E8EN8O5hH
         rw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2X3uicfOLSBUBzVzdE5/oWfcLTIRlhFHODXMCALg0vU=;
        b=mJcAZh3XNBWL45/cxD/t84a41fCFYucdtZtPq8MoiIfN/nCX1/YpvbML9lrDLrv+6m
         cyHqzeBkZQvzlSLw2oFN0Iyx84E9FxUoi1Mh2bwQH6Rwc8YzD8my7o9OMGgZEsA1y6Fj
         ozRhfs+rSg3t+8+JBWdjsRu6VfeWUHim4+pv+uVwglBkwerghE/yRkILKD2jbA2SZ0P/
         1+HvWvbBfuEMpVnWuYffml92+cK38N0tH1eo9PXArO5jsXfNGRrlWTZGK10fifOCplVT
         9LqCfcWrcbW06JTdqYzTanU6jsrbc9qDuTdNzcfcjgt191doR/xbLTN0jcLjvGJLe9ET
         f56g==
X-Gm-Message-State: AOAM531fIVl+vjWUTr56Vv0fvmrRGK5cPopMwrpECOjTEdTYJccB+VlN
        1ddN7qQ/zUUhF4si1yswCzE3Qw==
X-Google-Smtp-Source: ABdhPJxQYGGnjFJ+ZjvyFpvXZEf+aUEKJKt8206pLdDz3t1VHzuoYNDdbMCmJ/KRmyO9i2QRxzLE4Q==
X-Received: by 2002:a63:5d4c:0:b0:39d:5470:efc7 with SMTP id o12-20020a635d4c000000b0039d5470efc7mr14682488pgm.27.1649891042130;
        Wed, 13 Apr 2022 16:04:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a621b0b000000b00505c6892effsm141831pfb.26.2022.04.13.16.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 16:04:01 -0700 (PDT)
Date:   Wed, 13 Apr 2022 23:03:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v5 08/10] KVM: x86/MMU: Allow NX huge pages to be
 disabled on a per-vm basis
Message-ID: <YldW3QEDM5Z0Y5Mn@google.com>
References: <20220413175944.71705-1-bgardon@google.com>
 <20220413175944.71705-9-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413175944.71705-9-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022, Ben Gardon wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 72183ae628f7..021452a9fa91 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7855,6 +7855,19 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
>  this capability will disable PMU virtualization for that VM.  Usermode
>  should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  
> +8.36 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
> +---------------------------
> +
> +:Capability KVM_CAP_PMU_CAPABILITY
> +:Architectures: x86
> +:Type: vm
> +:Returns 0 on success, -EPERM if the userspace process does not
> +	 have CAP_SYS_BOOT

Needs to document the -EINVAL cases, especially the requirement that this be
called before VMs are created.  The 

> +This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
> +
> +The capability has no effect if the nx_huge_pages module parameter is not set.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c20f715f009..b8ab4fa7d4b2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1240,6 +1240,8 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +
> +	bool disable_nx_huge_pages;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 671cfeccf04e..148f630af78a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -173,9 +173,10 @@ struct kvm_page_fault {
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
>  extern int nx_huge_pages;
> -static inline bool is_nx_huge_page_enabled(void)
> +static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(nx_huge_pages);
> +	return READ_ONCE(nx_huge_pages) &&
> +	       !kvm->arch.disable_nx_huge_pages;

No need for a newline, that fits on a single line.

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 566548a3efa7..03aa1e0f60e2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1469,7 +1469,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * not been linked in yet and thus is not reachable from any other CPU.
>  	 */
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte,
> +						       level, i);

Just let this poke past 80 chars.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 665c1fa8bb57..27631c3b53c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4286,6 +4286,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SYS_ATTRIBUTES:
>  	case KVM_CAP_VAPIC:
>  	case KVM_CAP_ENABLE_CAP:
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -6079,6 +6080,28 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		r = -EINVAL;
> +		if (cap->args[0])
> +			break;
> +
> +		/*
> +		 * Since the risk of disabling NX hugepages is a guest crashing
> +		 * the system, ensure the userspace process has permission to
> +		 * reboot the system.

Since I'm nitpicking already and there's also a comment...

Can you call out that, unlike the actual reboot() syscall, the process needs the
capability in the init? namespace (I don't actual know the terminology) because
exposing /dev/kvm into a container doesn't magically limit the iTLB multihit bug
to that container.  I.e. that this _must_ use capable(), not ns_capable().	

Amusingly, someone could subvert the selftest's SYS_reboot heuristic by running
the test in a container :-)
