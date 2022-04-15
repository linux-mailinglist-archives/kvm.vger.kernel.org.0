Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45D7502B97
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354347AbiDOOR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354356AbiDOORS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5F4B255A5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650032088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDzhabKGf8eK/udzJEHxzD5ALoVxgv4JOTpWaJ3vp2o=;
        b=BjrHxlR9D1pxWIhM68ZD7vOaVcgAb1oajuXaNLChscgqszdcKvmnTVFEGZ2TsmVz0OJ2vP
        +MpMXPpygdhNwrVPXKPWjo0JsxZk3XsliqooAWIf25fOZzf/fV1Biwo9H8sFkAr0/JNQpv
        /TzOiQ1W7eAtGJkABNnLJW+N9dmQVTs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-4mpRQUFwOWuIt-I5Cohotg-1; Fri, 15 Apr 2022 10:14:47 -0400
X-MC-Unique: 4mpRQUFwOWuIt-I5Cohotg-1
Received: by mail-ej1-f69.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso3207339eje.13
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:14:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NDzhabKGf8eK/udzJEHxzD5ALoVxgv4JOTpWaJ3vp2o=;
        b=DPf4uh5PU1Upa7tYaqPJGkCe0m5yk2H128wjPNLWTTbm4tnRwOQpmj7LnCl8q9kRIm
         0cknmceR8yKB0/igYl6LjYTzRsdX8+WzeI/ATtBuUUY1LWpwFI0w/Kubz2NM/3cC+Jyv
         ILEHKi0Vbg5nk/ZVUCt3OHDfUgQGQxoAjwyi8LXfjmY/9gkCohUuAh+/kiYtMozN388b
         Uk21nCyzz3V+E9WaaVGEx05C927Rg3+EitCpbc6ebbsUm2VECOtsY6NYYJPoZJzAsOxe
         GFGWSQreu9mr9RrpNxxnaLjzXefirc+y/6qly5Ig2kgye/Assv/cfwLeWI+KGCMDjKX2
         cmuA==
X-Gm-Message-State: AOAM530YwEGhf+8n9ajwlUss0xDpsistrg1CPzvfF8SnAsKvycOry3x7
        08IX1o+jFFNQnm2qYPz8L2e4jFyewegAUiUgBqNIkLPQNX4++PedIDg5xbVqBTuNxvepFAfTYJK
        ca+SiGSad25b6
X-Received: by 2002:a17:907:3397:b0:6e8:d608:bdab with SMTP id zj23-20020a170907339700b006e8d608bdabmr6518802ejb.556.1650032084968;
        Fri, 15 Apr 2022 07:14:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0jn0chNTS4vN4sFhLHUj58m3uk4gy4F/TUvtQ/jbqK6aFxDFwC9KPYU5Ed2wXiTJtk09/0Q==
X-Received: by 2002:a17:907:3397:b0:6e8:d608:bdab with SMTP id zj23-20020a170907339700b006e8d608bdabmr6518632ejb.556.1650032082465;
        Fri, 15 Apr 2022 07:14:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id c13-20020a17090654cd00b006e0db351d01sm1730182ejp.124.2022.04.15.07.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:14:41 -0700 (PDT)
Message-ID: <3846c1be-73cd-17d6-5e2a-9f7edde2ef9c@redhat.com>
Date:   Fri, 15 Apr 2022 16:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 072/104] KVM: TDX: handle vcpu migration over
 logical processor
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <3dd2729b27d1db696c61c7f7acf5a2c8ecaa1502.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3dd2729b27d1db696c61c7f7acf5a2c8ecaa1502.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For vcpu migration, in the case of VMX, VCMS is flushed on the source pcpu,
> and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> call them on vcpu migration.  The logic is mostly same as VMX except the
> TDX SEAMCALLs are used.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 20 +++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 51 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  2 ++
>   3 files changed, 71 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index f9d43f2de145..2cd5ba0e8788 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -121,6 +121,14 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
>   	return vmx_vcpu_run(vcpu);
>   }
>   
> +static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_load(vcpu, cpu);
> +
> +	return vmx_vcpu_load(vcpu, cpu);
> +}
> +
>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -162,6 +170,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>   }
>   
> +static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_sched_in(vcpu, cpu);
> +}
> +
>   static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -199,7 +215,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_guest_switch = vt_prepare_switch_to_guest,
> -	.vcpu_load = vmx_vcpu_load,
> +	.vcpu_load = vt_vcpu_load,
>   	.vcpu_put = vt_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
> @@ -285,7 +301,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.request_immediate_exit = vmx_request_immediate_exit,
>   
> -	.sched_in = vmx_sched_in,
> +	.sched_in = vt_sched_in,
>   
>   	.cpu_dirty_log_size = PML_ENTITY_NUM,
>   	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 37cf7d43435d..a6b1a8ce888d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -85,6 +85,18 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
>   	return kvm_tdx->finalized;
>   }
>   
> +static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
> +	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
> +	 * to its list before its deleted from this CPUs list.
> +	 */
> +	smp_wmb();
> +
> +	vcpu->cpu = -1;
> +}
> +
>   static void tdx_clear_page(unsigned long page)
>   {
>   	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -155,6 +167,39 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
>   	free_page(page->va);
>   }
>   
> +static void tdx_flush_vp(void *arg)
> +{
> +	struct kvm_vcpu *vcpu = arg;
> +	u64 err;
> +
> +	/* Task migration can race with CPU offlining. */
> +	if (vcpu->cpu != raw_smp_processor_id())
> +		return;
> +
> +	/*
> +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> +	 * list tracking still needs to be updated so that it's correct if/when
> +	 * the vCPU does get initialized.
> +	 */
> +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> +		err = tdh_vp_flush(to_tdx(vcpu)->tdvpr.pa);
> +		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
> +			if (WARN_ON_ONCE(err))
> +				pr_tdx_error(TDH_VP_FLUSH, err, NULL);
> +		}
> +	}
> +
> +	tdx_disassociate_vp(vcpu);
> +}
> +
> +static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
> +{
> +	if (unlikely(vcpu->cpu == -1))
> +		return;
> +
> +	smp_call_function_single(vcpu->cpu, tdx_flush_vp, vcpu, 1);
> +}
> +
>   static int tdx_do_tdh_phymem_cache_wb(void *param)
>   {
>   	u64 err = 0;
> @@ -425,6 +470,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	if (vcpu->cpu != cpu)
> +		tdx_flush_vp_on_cpu(vcpu);
> +}
> +
>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 8b871c5f52cf..ceafd6e18f4e 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -143,6 +143,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_put(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -166,6 +167,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
>   static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }

This patch and the next one might even be squashed together.

Otherwise

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

