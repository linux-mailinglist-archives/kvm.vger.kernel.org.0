Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6276267826F
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 18:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjAWRBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 12:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjAWRBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 12:01:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BF310C8
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 09:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674493232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l3Bgd2ctzZypb/34SS3GJAMXgv6ozYZWIGEoO2UVerg=;
        b=bvHBBL/HFVCJHYRYADdRKjL/J3z95NgEXrSyRO3yVY+mTARLvmYn+wV6nAtyk0r1G6ZWXC
        I82juAvBDsGhtUqrdeTN/dlmnTnNjNa+3lwSGCiAzCI2/nMNUhTXfz/EYJZifrLJ5h2ewr
        +AeDGdtPKYXai2mfjlEjl/WAjVMrJtM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-9w38KQMhMzmQ6Va_6Di6kg-1; Mon, 23 Jan 2023 12:00:31 -0500
X-MC-Unique: 9w38KQMhMzmQ6Va_6Di6kg-1
Received: by mail-qt1-f198.google.com with SMTP id ga12-20020a05622a590c00b003b62b38e077so4745914qtb.7
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 09:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3Bgd2ctzZypb/34SS3GJAMXgv6ozYZWIGEoO2UVerg=;
        b=sCsXY/7DmQbHk8mZwZn5HwuK/sI50nQsWHC26G5Cd1kXIlTqxAZLu/S3RLn14fxoLN
         H+9eDkbKiB1Ccb91QX0hDCOnea0qiqa/fyR8hxtkHm9UDc0ja8uiydCpYdWENvR7mzXl
         8v9IHIXSuj1zilLIIlZmvyBJglhCf4aKpfI10H5DuLlox6hDaA6RizOZO2Vn3GcQgXtl
         LwpaYNRd2Zy/7vNOXFhDuo3yMbsmkoMEfsjOG2XckWZpOqY9enCO9SvHmNWQikkhq14/
         oeS1GEBs7GuHB8ZdT1miFzpzuwSQuE03Xp+Z/TYkz4hXwNMVf+0vF46u7MnWMaBN18Gz
         Cabg==
X-Gm-Message-State: AFqh2kpfwCDhNW4Zg+wwEaHAVkqMdpSfn2qfyPnVy7Aa+XGVU0hpDmeX
        NgC8s2SX/q30WXyT6KbxsLun6cfna0nlFAE+CflO+gTJLaxfSdDu0yzPKkKPTCCnTBo+R+Huj6H
        bJJukdpBx0Jgn
X-Received: by 2002:ad4:5306:0:b0:532:caf:e90e with SMTP id y6-20020ad45306000000b005320cafe90emr38486351qvr.35.1674493230759;
        Mon, 23 Jan 2023 09:00:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXukVGZRV8cgd+paIDhGlY4N38Q0Qzd08Av8vzt3lGS16MD8ulDmGRE2zadgGrfZguHTDmLNcg==
X-Received: by 2002:ad4:5306:0:b0:532:caf:e90e with SMTP id y6-20020ad45306000000b005320cafe90emr38486316qvr.35.1674493230464;
        Mon, 23 Jan 2023 09:00:30 -0800 (PST)
Received: from ovpn-194-126.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u2-20020a05620a0c4200b006f9f3c0c63csm32398763qki.32.2023.01.23.09.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:00:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v3] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <20230123162929.9773-1-alexandru.matei@uipath.com>
References: <20230123162929.9773-1-alexandru.matei@uipath.com>
Date:   Mon, 23 Jan 2023 18:00:27 +0100
Message-ID: <878rhtchjo.fsf@ovpn-194-126.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexandru Matei <alexandru.matei@uipath.com> writes:

> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> that the msr bitmap was changed.
>
> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> function checks for current_vmcs if it is null but the check is
> insufficient because current_vmcs is not initialized. Because of this, the
> code might incorrectly write to the structure pointed by current_vmcs value
> left by another task. Preemption is not disabled, the current task can be
> preempted and moved to another CPU while current_vmcs is accessed multiple
> times from evmcs_touch_msr_bitmap() which leads to crash.
>
> The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
> solution is to use vmx->vmcs01.vmcs instead of current_vmcs.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000338
> PGD 4e1775067 P4D 0
> Oops: 0002 [#1] PREEMPT SMP NOPTI
> ...
> RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
> ...
> Call Trace:
>  vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
>  vmx_vcpu_create+0xe6/0x540 [kvm_intel]
>  ? __vmalloc_node+0x4a/0x70
>  kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
>  kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
>  ? __handle_mm_fault+0x3cb/0x750
>  kvm_vm_ioctl+0x53f/0x790 [kvm]
>  ? syscall_exit_work+0x11a/0x150
>  ? syscall_exit_to_user_mode+0x12/0x30
>  ? do_syscall_64+0x69/0x90
>  ? handle_mm_fault+0xc5/0x2a0
>  __x64_sys_ioctl+0x8a/0xc0
>  do_syscall_64+0x5c/0x90
>  ? exc_page_fault+0x62/0x150
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
> ---
> v3:
>   - pass hv_enlightened_vmcs * directly
>
> v2:
>   - pass (e)vmcs01 to evmcs_touch_msr_bitmap
>   - use loaded_vmcs * instead of vcpu_vmx * to avoid
>     including vmx.h which generates circular dependency
>
>  arch/x86/kvm/vmx/hyperv.h | 14 +++++++++-----
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 571e7929d14e..4ca6606e7a3b 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -190,13 +190,17 @@ static inline u16 evmcs_read16(unsigned long field)
>  	return *(u16 *)((char *)current_evmcs + offset);
>  }
>  
> -static inline void evmcs_touch_msr_bitmap(void)
> +static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs)
>  {
> -	if (unlikely(!current_evmcs))
> +	/*
> +	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
> +	 * always operates on evmcs01
> +	 */
> +	if (WARN_ON_ONCE(!evmcs))
>  		return;
>  
> -	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
> -		current_evmcs->hv_clean_fields &=
> +	if (evmcs->hv_enlightenments_control.msr_bitmap)
> +		evmcs->hv_clean_fields &=
>  			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
>  }
>  
> @@ -219,7 +223,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>  static inline void evmcs_load(u64 phys_addr) {}
> -static inline void evmcs_touch_msr_bitmap(void) {}
> +static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  #define EVMPTR_INVALID (-1ULL)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe5615fd8295..1d482a80bca8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	 * bitmap has changed.
>  	 */
>  	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +		evmcs_touch_msr_bitmap((struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs);
>  
>  	vmx->nested.force_msr_bitmap_recalc = true;
>  }

Just in case we decide to follow this path and not merge
evmcs_touch_msr_bitmap() into vmx_msr_bitmap_l01_changed():

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

