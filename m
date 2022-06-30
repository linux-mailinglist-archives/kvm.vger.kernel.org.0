Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B7E56147B
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiF3ILv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 04:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiF3IKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 04:10:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2DF142ED7
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656576567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJMm74XNeXoDnGMBSkrb0S3b3+IGUy5MPHzLIOgf8fw=;
        b=HMBZBgpH+d0nIhoh7hvKYgDm4ziQT7iQpMhpljrOWp9Uc1dyiorPkgas02gWoOba73n8f8
        GwwI73Mqj7+4f6tQq9VftvkbqFsuG1vQuvoRc+ZAVFZ5NCmQYo9rencDEM163G5smp7fOO
        tPPTYtdSLtoLAggZk74qWd6axua5LmE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-_0VYmVqENxW4JVdo9PVuYw-1; Thu, 30 Jun 2022 04:09:26 -0400
X-MC-Unique: _0VYmVqENxW4JVdo9PVuYw-1
Received: by mail-wm1-f71.google.com with SMTP id j35-20020a05600c1c2300b003a167dfa0ecso1121648wms.5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yJMm74XNeXoDnGMBSkrb0S3b3+IGUy5MPHzLIOgf8fw=;
        b=tOe7GhVMmZCzIw0WV05mClnGbxtxs89vuU6JuMX93hYWaFOw5ROwkY1cFU327X+7/J
         W5QdQZxksc05D7uKNOpcuwZsu0DQkQYJrdxs/2CKHrBNfKIS4D0fwGwFw8+U9eOI0WHs
         S0yK2ges89c3ZTR4bBWJS3zKjx+mkhYjGGnWc8shZmcXtPdJh92RDu+ui9Fm3BXDk4w0
         E+22z9h/K1dK6KsojOM40Wgj32aYBRfZguMIUdIlpyJ0kxLAnNiXRINp61ZGcJbVZh1A
         MsiN/rB/vuIUyVRO3p1108tshMvRTOPEpuSiPxpovy5Ei4/iqzxMqExmvz2Da/BXXXfd
         nVGg==
X-Gm-Message-State: AJIora/8coAIBpOVjqC5Ybiv+EUPgEbGPoiQRnT0qGcd7Gm3N/+Ccy3m
        kEEvO1woo9mygAeSQn3GMzzb/K4eDNFJM03eurFaNC0ZkLIBA1JtiyeUEV0wTN0ujFgbuQGARl3
        XC/k6mka0r4GU
X-Received: by 2002:a05:6000:1e0f:b0:21b:b032:6b3d with SMTP id bj15-20020a0560001e0f00b0021bb0326b3dmr7360559wrb.337.1656576565142;
        Thu, 30 Jun 2022 01:09:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uldQJFFmxV97Ms2m2sDGC2wzCFyTwHde5QJwVU6Vsq02EfCZd31KlUasOvbUtCvITFdTfi+g==
X-Received: by 2002:a05:6000:1e0f:b0:21b:b032:6b3d with SMTP id bj15-20020a0560001e0f00b0021bb0326b3dmr7360528wrb.337.1656576564920;
        Thu, 30 Jun 2022 01:09:24 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x1-20020a1c7c01000000b003a02b135747sm5868744wmc.46.2022.06.30.01.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 01:09:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Kyle Meyer <kyle.meyer@hpe.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, dmatlack@google.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, kyle.meyer@hpe.com, mingo@redhat.com,
        payton@hpe.com, russ.anderson@hpe.com, steve.wahl@hpe.com,
        tglx@linutronix.de, wanpengli@tencent.com, x86@kernel.org,
        seanjc@google.com
Subject: Re: [PATCH v2] KVM: x86: Increase KVM_MAX_VCPUS to 4096
In-Reply-To: <20220629203824.150259-1-kyle.meyer@hpe.com>
References: <YqthQ6QmK43ZPfkM@google.com>
 <20220629203824.150259-1-kyle.meyer@hpe.com>
Date:   Thu, 30 Jun 2022 10:09:23 +0200
Message-ID: <87r136shcc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kyle Meyer <kyle.meyer@hpe.com> writes:

> Increase KVM_MAX_VCPUS to 4096 when the maximum number of supported CPUs
> (NR_CPUS) is greater than 1024.
>
> The Hyper-V TLFS doesn't allow more than 64 sparse banks, which allows a
> maximum of 4096 virtual CPUs. Limit KVM's maximum number of virtual CPUs
> to 4096 to avoid exceeding that limit.

In theory, it's just TLB flush and IPI hypercalls which have this
limitation. Strictly speaking, guest can have more than 4096 vCPUs,
it'll just have to do IPIs/TLB flush in a different way.

>
> Notable changes:
>
> * KVM_MAX_VCPU_IDS will increase from 4096 to 16384.
> * KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 64.
>
> * CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX will now be 4096.

	redundant leading zero		 ^^

>
> * struct kvm will increase from 40336 B to 40720 B.
> * struct kvm_ioapic will increase from 5240 B to 19064 B.
>
> * vcpu_mask in kvm_hv_flush_tlb will increase from 128 B to 512 B.
> * vcpu_bitmap in ioapic_write_indirect will increase from 128 B to 512 B.
> * vp_bitmap in sparse_set_to_vcpu_mask will increase from 128 B to 512 B.
>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9217bd6cf0d1..867a945f0152 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -38,7 +38,11 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> +#if NR_CPUS < 1024
>  #define KVM_MAX_VCPUS 1024
> +#else
> +#define KVM_MAX_VCPUS 4096
> +#endif
>  
>  /*
>   * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs

-- 
Vitaly

