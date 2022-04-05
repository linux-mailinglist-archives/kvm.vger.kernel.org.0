Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7F4F3FB9
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiDEOte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389674AbiDENeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 386D6137B2E
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649162396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ye4ZaW/ItY5DViRmitahbrOWzYkgcy+w01IKjssfwqM=;
        b=UC7CzFRdqPiVfNP1mBWdachWCSTUtmEHlmiOP9b2Z8n9C19m16QBWgFsQJqTU0meT5GWL9
        Cd6pHHvW7lDf/FYQ//cwgJkny5JlGD6PpGqv9ovl7W7DYbiebwnD1SCG4hW3IAt0pg2A2K
        d9y00tzND9PyhK0RbMhLzqEJRmtqTho=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-9BOLJxxDM4KSuBaUEAFqqA-1; Tue, 05 Apr 2022 08:39:55 -0400
X-MC-Unique: 9BOLJxxDM4KSuBaUEAFqqA-1
Received: by mail-wm1-f70.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so1213571wmj.0
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ye4ZaW/ItY5DViRmitahbrOWzYkgcy+w01IKjssfwqM=;
        b=J8e6Ap4u3YPYFukePaUuw/pM8XaUajj9n316f4rA4Q+Wu5vR8tXX2vwzBnaj5KzRt4
         Fqn26tw1ldncVTYNysBPniRmaaJLWXA/FEykPmRm+hkPKQxZUEK1XbxZl7A188syfFrX
         zOPNbqXbpYmKE7t0jXjXoF4mUppoZqvALDflfkJR9Y7tE/aJpc8BHlXeJ44d7Z4MdVGE
         MzorDAm0rvIqBKIhn0vCpxaqZa6Ki02eJ0FZ1UxSU2Bh7WYbP+iv6jtbxYMmoRxGhjNd
         aTzjCOQJmX28Uadjw2jhEFeRsIRMe0oj7F8QE77PsIdF7K98VhyQWbdPpKNbKy3EqDdj
         cnFw==
X-Gm-Message-State: AOAM533yHiyTcviZFnVkdY7KfnAUhmy0m26acGuU2+Pxx1NdN2LM0N+T
        FZozHI910klOkI/xRyM4IZMk+X/gpsBWeLmrj+xl8ca4Ab8bCP+m2KT0RVclfApxTviXu/NEu/j
        TfksTG1W9N/03
X-Received: by 2002:adf:e582:0:b0:206:fcf:8eb3 with SMTP id l2-20020adfe582000000b002060fcf8eb3mr2720021wrm.517.1649162393891;
        Tue, 05 Apr 2022 05:39:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlo0bj2jutu52YWf8gdKhedE/z/VWmesp/G1YrMVbP8ucNmMKxfYc9MxKHXr/mNZGwYksxog==
X-Received: by 2002:adf:e582:0:b0:206:fcf:8eb3 with SMTP id l2-20020adfe582000000b002060fcf8eb3mr2720009wrm.517.1649162393651;
        Tue, 05 Apr 2022 05:39:53 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id y7-20020adfdf07000000b0020609f6b386sm8537167wrl.37.2022.04.05.05.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:39:52 -0700 (PDT)
Message-ID: <25257849-8e1a-17ff-5008-bb2d1efecf80@redhat.com>
Date:   Tue, 5 Apr 2022 14:39:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 020/104] KVM: TDX: allocate per-package mutex
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <f7b44d1d5a61f788294c399b63b505b3ff4d301b.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f7b44d1d5a61f788294c399b63b505b3ff4d301b.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Several TDX SEAMCALLs are per-package scope (concretely per memory
> controller) and they need to be serialized per-package.  Allocate mutex for
> it.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    |  8 +++++++-
>   arch/x86/kvm/vmx/tdx.c     | 18 ++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  2 ++
>   3 files changed, 27 insertions(+), 1 deletion(-)

Please define here the lock/unlock functions as well:

static inline int tdx_mng_key_lock(void)
{
	int cpu = get_cpu();
	cur_pkg = topology_physical_package_id(cpu);

	mutex_lock(&tdx_mng_key_config_lock[cur_pkg]);
	return cur_pkg;
}

static inline void tdx_mng_key_unlock(int cur_pkg)
{
	mutex_unlock(&tdx_mng_key_config_lock[cur_pkg]);
	put_cpu();
}

Thanks,

Paolo


> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 8103d1c32cc9..6111c6485d8e 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -25,6 +25,12 @@ static __init int vt_hardware_setup(void)
>   	return 0;
>   }
>   
> +static void vt_hardware_unsetup(void)
> +{
> +	tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>   static int vt_vm_init(struct kvm *kvm)
>   {
>   	int ret;
> @@ -42,7 +48,7 @@ static int vt_vm_init(struct kvm *kvm)
>   struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>   
>   	.hardware_enable = vmx_hardware_enable,
>   	.hardware_disable = vmx_hardware_disable,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e8d293a3c11c..1c8222f54764 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -34,6 +34,8 @@ struct tdx_capabilities {
>   /* Capabilities of KVM + the TDX module. */
>   struct tdx_capabilities tdx_caps;
>   
> +static struct mutex *tdx_mng_key_config_lock;
> +
>   static u64 hkid_mask __ro_after_init;
>   static u8 hkid_start_pos __ro_after_init;
>   
> @@ -112,7 +114,9 @@ bool tdx_is_vm_type_supported(unsigned long type)
>   
>   static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   {
> +	int max_pkgs;
>   	u32 max_pa;
> +	int i;
>   
>   	if (!enable_ept) {
>   		pr_warn("Cannot enable TDX with EPT disabled\n");
> @@ -127,6 +131,14 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
>   		return -EIO;
>   
> +	max_pkgs = topology_max_packages();
> +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> +				   GFP_KERNEL);
> +	if (!tdx_mng_key_config_lock)
> +		return -ENOMEM;
> +	for (i = 0; i < max_pkgs; i++)
> +		mutex_init(&tdx_mng_key_config_lock[i]);
> +
>   	max_pa = cpuid_eax(0x80000008) & 0xff;
>   	hkid_start_pos = boot_cpu_data.x86_phys_bits;
>   	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
> @@ -147,6 +159,12 @@ void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   		enable_tdx = false;
>   }
>   
> +void tdx_hardware_unsetup(void)
> +{
> +	/* kfree accepts NULL. */
> +	kfree(tdx_mng_key_config_lock);
> +}
> +
>   void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
>   			unsigned int *vcpu_align, unsigned int *vm_size)
>   {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 78331dbc29f7..da32b4b86b19 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -131,11 +131,13 @@ void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
>   			unsigned int *vcpu_align, unsigned int *vm_size);
>   bool tdx_is_vm_type_supported(unsigned long type);
>   void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +void tdx_hardware_unsetup(void);
>   #else
>   static inline void tdx_pre_kvm_init(
>   	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
> +static inline void tdx_hardware_unsetup(void) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */

