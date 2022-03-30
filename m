Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE164EB775
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 02:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241459AbiC3A3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 20:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiC3A3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 20:29:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6168B6E76
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:28:00 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x2so19085958plm.7
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4jVwb2dMkJltILuhJbsIA7P6kB3yDQfE9kNIJQ3/0AI=;
        b=SXTF5kqDkZCyMRflakBrSGUVgl1RehL2zWwt73HiPVstorAmHpQlTZf+Kz2NFYWkuh
         2MkTGvcCFDXN+zRFtv0I5zq5PBtVOrh09JvO4kNYkwAlVnEBpLvoCGOmos/OKVPNtiEK
         PdbsmJZwkc+ctu2ynNFoB5kHEUlHA/dMbxJ1LvLsum6MRkwLgyBkUl9ZjmQmJmsWBFNl
         jFIVOxd+Uvjs+J0EA0bo5k01UyMky/fynlPyK2iKsxHUEfkB8+gWH68b52ulnuipH/25
         MpPBWR9DwxVJvF6YKcIdhBQhOrysMQ3faalNRXiN1uurZrvx+4lfN/GOWhv8s1Hbc1nu
         JxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4jVwb2dMkJltILuhJbsIA7P6kB3yDQfE9kNIJQ3/0AI=;
        b=MfVeCKCHeSc4Gqty94hjZw3QY8fAH/JyO0fCVelCjJ7ZTCOPY++DPp6390ND3JjZf6
         MkHQYoMRZF1Fkp9gRZGgtCQASM5nirYKgF11NeQjLjdLDwEKYARTDPnep5QrCpugZaxQ
         x6EVopKjVPVG9ciSSBNdMq7THQkOlCjys03vA6l2x1mY/QLI0JcGUVnmoq9NWJ6k0qGC
         4SDsaJ8LiWk85bDBZwwoQodJffzk4kNWpxBBMQ31UsOB/mxH7R8Yq2dGgvoUKQLS3r3J
         cRRB5Fb7juJA9Gxprhn72pM/RTUO5Tzpb+RODrV/NJJXduD7FNAmWHYp/R2ZkqiHo80y
         QZrg==
X-Gm-Message-State: AOAM5338A/BN7cOGoaeBJFx1I4a1nB5POK9LfvMCGrqAkkkMrxb9keed
        o5gN8Tg9cPrXTy42zg80ymyjdF90PqmV0g==
X-Google-Smtp-Source: ABdhPJxDPnfSqa9sBDhByFovj/J1uemrROzh2kfeBrgzuY7bYXwESTYg4EJbiz9+kfcJEGHP1dWz3Q==
X-Received: by 2002:a17:90a:8c8e:b0:1c9:c81d:9e13 with SMTP id b14-20020a17090a8c8e00b001c9c81d9e13mr1845431pjo.123.1648600079890;
        Tue, 29 Mar 2022 17:27:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm16520437pgf.31.2022.03.29.17.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:27:59 -0700 (PDT)
Date:   Wed, 30 Mar 2022 00:27:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: x86: avoid loading a vCPU after .vm_destroy was
 called
Message-ID: <YkOkCwUgMD1SVfaD@google.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322172449.235575-2-mlevitsk@redhat.com>
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

On Tue, Mar 22, 2022, Maxim Levitsky wrote:
> This can cause various unexpected issues, since VM is partially
> destroyed at that point.
> 
> For example when AVIC is enabled, this causes avic_vcpu_load to
> access physical id page entry which is already freed by .vm_destroy.

Hmm, the SEV unbinding of ASIDs should be done after MMU teardown too (which your
patch also does).

> 
> Fixes: 8221c1370056 ("svm: Manage vcpu load/unload when enable AVIC")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3a9ce07a565..ba920e537ddf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11759,20 +11759,15 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>  	vcpu_put(vcpu);
>  }
>  
> -static void kvm_free_vcpus(struct kvm *kvm)
> +static void kvm_unload_vcpu_mmus(struct kvm *kvm)
>  {
>  	unsigned long i;
>  	struct kvm_vcpu *vcpu;
>  
> -	/*
> -	 * Unpin any mmu pages first.
> -	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
>  		kvm_unload_vcpu_mmu(vcpu);
>  	}
> -
> -	kvm_destroy_vcpus(kvm);
>  }
>  
>  void kvm_arch_sync_events(struct kvm *kvm)
> @@ -11878,11 +11873,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
>  		mutex_unlock(&kvm->slots_lock);
>  	}
> +	kvm_unload_vcpu_mmus(kvm);
>  	static_call_cond(kvm_x86_vm_destroy)(kvm);
>  	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
>  	kvm_pic_destroy(kvm);
>  	kvm_ioapic_destroy(kvm);
> -	kvm_free_vcpus(kvm);
> +	kvm_destroy_vcpus(kvm);

Rather than split kvm_free_vcpus(), can we instead move the call to svm_vm_destroy()
by adding a second hook, .vm_teardown(), which is needed for TDX?  I.e. keep VMX
where it is by using vm_teardown, but effectively move SVM?

https://lore.kernel.org/all/1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com

>  	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
>  	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
>  	kvm_mmu_uninit_vm(kvm);
> -- 
> 2.26.3
> 
