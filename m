Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0765D201
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbjADMEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbjADMED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502A034773;
        Wed,  4 Jan 2023 04:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E24916142A;
        Wed,  4 Jan 2023 12:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AD8C433F0;
        Wed,  4 Jan 2023 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672833827;
        bh=dwb9nRq7i7xao4WnNre+ZkAiKphG8Sf61V8egDiQSkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptJuLWEO5+ZH8Z34rp3mWYaIa1E5FrsTjCXPoMDhzg1KPRLppvkrKzxe0XrcWTwQa
         d7Ljp7HsN3XNJ48fmiSkr5rXDCc3Wa/dMgg113HQfCAFwOoZVArXj9E8GpD3r1J9gz
         KCXF8XQXXf6XEALwBFRN2UHVyKdiWsxqewFk8moSfRzeIdVhc3WzWfrW3J6SFC8dbv
         oJiWX5hcVPWroD6DWOuqk4Uog9K2Bvgdr+DBbsgKfm3ToPuaHCMwpybaNF+pQ/jOZY
         99N0vbCMHZfRWhjNqPM49+7zcQVDIMj+eMCL789Ct9HAC5yK3zVrmQxkHyE3LDsdzw
         s1QoWyK5lCPBg==
Date:   Wed, 4 Jan 2023 12:03:44 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
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
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 02/64] KVM: x86: Add
 KVM_CAP_UNMAPPED_PRIVATE_MEMORY
Message-ID: <Y7VrIDfNmhG+BVQ9@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-3-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-3-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:54PM -0600, Michael Roth wrote:
> This mainly indicates to KVM that it should expect all private guest
> memory to be backed by private memslots. Ideally this would work
> similarly for others archs, give or take a few additional flags, but
> for now it's a simple boolean indicator for x86.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/x86.c              | 10 ++++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 27ef31133352..2b6244525107 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1438,6 +1438,9 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	/* Use/enforce unmapped private memory. */
> +	bool upm_mode;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c67e22f3e2ee..99ecf99bc4d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4421,6 +4421,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_EXIT_HYPERCALL:
>  		r = KVM_EXIT_HYPERCALL_VALID_MASK;
>  		break;
> +#ifdef CONFIG_HAVE_KVM_MEMORY_ATTRIBUTES
> +	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
> +		r = 1;
> +		break;
> +#endif
>  	case KVM_CAP_SET_GUEST_DEBUG2:
>  		return KVM_GUESTDBG_VALID_MASK;
>  #ifdef CONFIG_KVM_XEN
> @@ -6382,6 +6387,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
> +		kvm->arch.upm_mode = true;
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -12128,6 +12137,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  	kvm->arch.enable_pmu = enable_pmu;
> +	kvm->arch.upm_mode = false;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c7e9d375a902..cc9424ccf9b2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>  #define KVM_CAP_MEMORY_ATTRIBUTES 225
> +#define KVM_CAP_UNMAPPED_PRIVATE_MEM 240
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.25.1
> 

Why we want to carry non-UPM support still?

BR, Jarkko
