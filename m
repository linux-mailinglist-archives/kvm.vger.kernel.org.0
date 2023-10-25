Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151A77D6656
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 11:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjJYJLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 05:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbjJYJLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 05:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D2A134
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698225036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FytEg3M9eI+HiGC4+Q1c4/7OpeWyHjtYgtZUMsVmeo=;
        b=gvp0wj3J90Ny4dmkeLCk+uWOsm/CT+IlHTGcSBH1PxXdEryqYLn8YvGFTLDk/iz/fAavwH
        KLcZZASQvTr5m7bdVYGsUtOVCD1qin6FIpQQ2MZuYz78yQr3ssfYANjNmV8WVckycJb0qv
        jqUyNP8ASoGLjms+RE8oDOtD7zQCYII=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-pTRDTazfNyGQLA3Z-SLijw-1; Wed, 25 Oct 2023 05:10:35 -0400
X-MC-Unique: pTRDTazfNyGQLA3Z-SLijw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-53e3120ae44so3749181a12.2
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 02:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698225034; x=1698829834;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FytEg3M9eI+HiGC4+Q1c4/7OpeWyHjtYgtZUMsVmeo=;
        b=xIu3z9Yocg3pyKNYM5DL093Z4G+JKPMkN3L8g7e9ptlGjy3sAkg/8QxUxHTlM+Rn9v
         I0w8oCSoCjjiCfO4Ff0TCw8F45iwTCMJW9ht/8QqIxOzToAzvvSbzWvh4lY0jCMQuzU3
         TrUIgULkul3PSuE1IVS4CMdAagm5otBlHeDS+jvE5xdtQaangnR9B+62X3XXqad4XQjy
         xnpO/0b6xhIDSc76sdHwe1T5SuKo0/30pqccS2cxeTZBRguoLyvuv69HwLZUlTHmv52X
         OyTJaryOPsh1igwCcb6JMo6qnjFo6ZASI5lFoGe3XIRk9hLZ6BJNDNu4Ez7gopUa9kDx
         Zxrg==
X-Gm-Message-State: AOJu0YxtCSnPqMzuGkoDS8mjkOw7c4Jgcj06l8H8OyVri8kkKZsjRehs
        KdUlGmrQWW/iYJg1lNFY3jD7Yd2Cv6+xyUs6lGFOUrv2VD1LEnlfAi6hVw6DjNZLG3z7nEWngbU
        K6/b01/FKIPE3
X-Received: by 2002:a05:6402:5202:b0:53e:21f6:d784 with SMTP id s2-20020a056402520200b0053e21f6d784mr14486019edd.8.1698225034066;
        Wed, 25 Oct 2023 02:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFD80j3WcFfiUdgylUIgLspDEpIABd2HeAzpTH/p0Oax+3buRNAhbLFsOGTIWHvTHnr2BaSA==
X-Received: by 2002:a05:6402:5202:b0:53e:21f6:d784 with SMTP id s2-20020a056402520200b0053e21f6d784mr14485999edd.8.1698225033756;
        Wed, 25 Oct 2023 02:10:33 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id d8-20020a05640208c800b0053e5a1bf77dsm9103868edz.88.2023.10.25.02.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 02:10:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 1/2] x86/kvm/async_pf: Use separate percpu variable
 to track the enabling of asyncpf
In-Reply-To: <20231025055914.1201792-2-xiaoyao.li@intel.com>
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
 <20231025055914.1201792-2-xiaoyao.li@intel.com>
Date:   Wed, 25 Oct 2023 11:10:32 +0200
Message-ID: <87a5s73w53.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Refer to commit fd10cde9294f ("KVM paravirt: Add async PF initialization
> to PV guest") and commit 344d9588a9df ("KVM: Add PV MSR to enable
> asynchronous page faults delivery"). It turns out that at the time when
> asyncpf was introduced, the purpose was defining the shared PV data 'struct
> kvm_vcpu_pv_apf_data' with the size of 64 bytes. However, it made a mistake
> and defined the size to 68 bytes, which failed to make fit in a cache line
> and made the code inconsistent with the documentation.

Oh, I actually though it was done on purpose :-) 'enabled' is not
accessed by the host, it's only purpose is to cache MSR_KVM_ASYNC_PF_EN.

>
> Below justification quoted from Sean[*]
>
>   KVM (the host side) has *never* read kvm_vcpu_pv_apf_data.enabled, and
>   the documentation clearly states that enabling is based solely on the
>   bit in the synthetic MSR.
>
>   So rather than update the documentation, fix the goof by removing the
>   enabled filed and use the separate percpu variable instread.
>   KVM-as-a-host obviously doesn't enforce anything or consume the size,
>   and changing the header will only affect guests that are rebuilt against
>   the new header, so there's no chance of ABI breakage between KVM and its
>   guests. The only possible breakage is if some other hypervisor is
>   emulating KVM's async #PF (LOL) and relies on the guest to set
>   kvm_vcpu_pv_apf_data.enabled. But (a) I highly doubt such a hypervisor
>   exists, (b) that would arguably be a violation of KVM's "spec", and
>   (c) the worst case scenario is that the guest would simply lose async
>   #PF functionality.
>
> [*] https://lore.kernel.org/all/ZS7ERnnRqs8Fl0ZF@google.com/T/#u
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  Documentation/virt/kvm/x86/msr.rst   |  1 -
>  arch/x86/include/uapi/asm/kvm_para.h |  1 -
>  arch/x86/kernel/kvm.c                | 11 ++++++-----
>  3 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
> index 9315fc385fb0..f6d70f99a1a7 100644
> --- a/Documentation/virt/kvm/x86/msr.rst
> +++ b/Documentation/virt/kvm/x86/msr.rst
> @@ -204,7 +204,6 @@ data:
>  		__u32 token;
>  
>  		__u8 pad[56];
> -		__u32 enabled;
>  	  };
>  
>  	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..605899594ebb 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -142,7 +142,6 @@ struct kvm_vcpu_pv_apf_data {
>  	__u32 token;
>  
>  	__u8 pad[56];
> -	__u32 enabled;
>  };
>  
>  #define KVM_PV_EOI_BIT 0
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b8ab9ee5896c..388a3fdd3cad 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
>  
>  early_param("no-steal-acc", parse_no_stealacc);
>  
> +static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);

Would it make a difference is we replace this with a cpumask? I realize
that we need to access it on all CPUs from hotpaths but this mask will
rarely change so maybe there's no real perfomance hit?

>  static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>  DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>  static int has_steal_clock = 0;
> @@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
>  {
>  	u32 flags = 0;
>  
> -	if (__this_cpu_read(apf_reason.enabled)) {
> +	if (__this_cpu_read(async_pf_enabled)) {
>  		flags = __this_cpu_read(apf_reason.flags);
>  		__this_cpu_write(apf_reason.flags, 0);
>  	}
> @@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>  
>  	inc_irq_stat(irq_hv_callback_count);
>  
> -	if (__this_cpu_read(apf_reason.enabled)) {
> +	if (__this_cpu_read(async_pf_enabled)) {
>  		token = __this_cpu_read(apf_reason.token);
>  		kvm_async_pf_task_wake(token);
>  		__this_cpu_write(apf_reason.token, 0);
> @@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
>  		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
>  
>  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
> -		__this_cpu_write(apf_reason.enabled, 1);
> +		__this_cpu_write(async_pf_enabled, 1);

As 'async_pf_enabled' is bool, it would probably be more natural to
write

	__this_cpu_write(async_pf_enabled, true);

>  		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
>  	}
>  
> @@ -383,11 +384,11 @@ static void kvm_guest_cpu_init(void)
>  
>  static void kvm_pv_disable_apf(void)
>  {
> -	if (!__this_cpu_read(apf_reason.enabled))
> +	if (!__this_cpu_read(async_pf_enabled))
>  		return;
>  
>  	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
> -	__this_cpu_write(apf_reason.enabled, 0);
> +	__this_cpu_write(async_pf_enabled, 0);

... and 'false' here.

>  
>  	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
>  }

-- 
Vitaly

