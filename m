Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453764F4378
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiDEOsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357284AbiDEOVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:21:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D480D657B8
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649164175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juDmRm7zJOFlw90DcOSf1yX4bMFhv58WyLq8A0PPfCA=;
        b=J+4VEVF5mPLGVngBQFBJjJz4JaWhvNtAapu0TTRtCeZQlSy529dzUAGndu80m9ltwMWZ1+
        crtLux03FiznSwFsjI5On3uyjdN73esxpOz27XN24K7lOzTKqjHACvL2srh3iJ4oZRpktg
        PqgKkOKhsEz78gCq4JUhUsj9nOQBc6w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-h4iRKXs6PNCCvPbwKvXuhA-1; Tue, 05 Apr 2022 09:09:34 -0400
X-MC-Unique: h4iRKXs6PNCCvPbwKvXuhA-1
Received: by mail-wr1-f70.google.com with SMTP id d29-20020adfa35d000000b002060fd92b14so1319885wrb.23
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=juDmRm7zJOFlw90DcOSf1yX4bMFhv58WyLq8A0PPfCA=;
        b=eMwyDnX4f1AEuIupsNFSfMIuJlzOc7lz3YY73hjrq38FKinyUobrkB31tyRtD3F8Rh
         w4UalrN9Si4n+NF58N7wnDk7TOmjD6C4gJYmDI6M9rjxDr28gyP8xR8ZvlIUPwxWXuZl
         kuVYMUVV+Iy71MrM57x4XE1jXu/fvS027w7nQWATck1N3RxIOCJLF2VVQZ+cQbjSXy7q
         ScGLm3pa6SiTv/B8jW7AGKt4HjB/sSBFjuisi+/EBdD+HF06iTyxvIVTyWHC6Muu9oXa
         +ldtgE7mE3cSWgG6gTzTyVyOhLrlNr5FRFUqefQ1EuC3AP38qNt7+ClwUqFHJHASvir6
         uJow==
X-Gm-Message-State: AOAM531v4CeyNlvx33Xhj5bcTmCiNuNF4DExD443bAlKya2Mdy9igogP
        u11fGH2ZMlpxUBbJr2fC+BKnHwTLaRvlmnHlLPmElOvg9shy7R8L2SNnnv6Eze7u2VF5jQ66zi0
        NJyngmuG31oq+
X-Received: by 2002:a05:600c:1c8d:b0:38c:db69:5759 with SMTP id k13-20020a05600c1c8d00b0038cdb695759mr3169256wms.204.1649164173336;
        Tue, 05 Apr 2022 06:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQb4YX6vjMDcck9TM03kOzNX3H4wUUBF2Ny8Ep2yAZ7gRh5xIBWLLBVUEbOwcA0mBjaLrgUA==
X-Received: by 2002:a05:600c:1c8d:b0:38c:db69:5759 with SMTP id k13-20020a05600c1c8d00b0038cdb695759mr3169222wms.204.1649164173010;
        Tue, 05 Apr 2022 06:09:33 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id 3-20020a5d47a3000000b0020412ba45f6sm14282576wrb.8.2022.04.05.06.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:09:32 -0700 (PDT)
Message-ID: <8ad49e0e-91ea-8dd9-0725-e263fae45a91@redhat.com>
Date:   Tue, 5 Apr 2022 15:09:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 035/104] KVM: x86/mmu: Disallow dirty logging for
 x86 TDX
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7fe3a6d75d0ad6469c97e2edf34a1886ff7be7be.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7fe3a6d75d0ad6469c97e2edf34a1886ff7be7be.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX doesn't support dirty logging.  Report dirty logging isn't supported so
> that device model, for example qemu, can properly handle it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/x86.c       |  5 +++++
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 15 ++++++++++++---
>   3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c52a052e208c..da411bcd8cbc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12876,6 +12876,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>   }
>   EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>   
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type != KVM_X86_TDX_VM;
> +}
> +
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a56044a31bc6..86f984e0c93f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1423,6 +1423,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   int kvm_arch_post_init_vm(struct kvm *kvm);
>   void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>   int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm);
>   
>   #ifndef __KVM_HAVE_ARCH_VM_ALLOC
>   /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3adee9c6b370..ae3bf553f215 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1423,9 +1423,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
>   	}
>   }
>   
> -static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
> +bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
>   {
> -	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> +	return true;
> +}
> +
> +static int check_memory_region_flags(struct kvm *kvm,
> +				     const struct kvm_userspace_memory_region *mem)
> +{
> +	u32 valid_flags = 0;
> +
> +	if (kvm_arch_dirty_log_supported(kvm))
> +		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
>   
>   #ifdef __KVM_HAVE_READONLY_MEM
>   	valid_flags |= KVM_MEM_READONLY;
> @@ -1826,7 +1835,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	int as_id, id;
>   	int r;
>   
> -	r = check_memory_region_flags(mem);
> +	r = check_memory_region_flags(kvm, mem);
>   	if (r)
>   		return r;
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

