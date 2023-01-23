Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631F5677C69
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 14:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjAWNZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 08:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjAWNZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 08:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92BB25286
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 05:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674480258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QkQWjDmg+8eb0nfkbYLEWNx2/sDmI9tmTtI2n3HIrJ8=;
        b=bTZs3JUgj4z52lDXN3dDxdgQzEiYvqPcECDTQsmCWCrUnh6U2BNxLFwl1crB9WbuC0rw0i
        aTktJZGDN3n6n2SJyfYjVRNCjer++CIHlG3E9vK5gEoQS+N+QBb5F1QG52GVML6GT5hqXC
        92yO0QYkoPm3uHngd+2LR3zJzNmtK9w=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-V67b1T9IMg-PsSwUOuKasw-1; Mon, 23 Jan 2023 08:24:17 -0500
X-MC-Unique: V67b1T9IMg-PsSwUOuKasw-1
Received: by mail-ej1-f72.google.com with SMTP id sc9-20020a1709078a0900b0086910fdf624so7759063ejc.13
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 05:24:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkQWjDmg+8eb0nfkbYLEWNx2/sDmI9tmTtI2n3HIrJ8=;
        b=go2bWZTQdSnrOFsIlusg7NCtCpKMNxfQ05z/Nz90uB6wKdGQEX+dps6jnb7CYHpZiR
         yQO2qIuAspfoPDJ1c1Ov7DIrx8Sl6OlnhZDLLlo+CJRvK/O1dmx5ap/MDYCgSes9rO54
         Io0zvkz3ei0qR9mn5N5RFe/nns8DbzrVZQOXRV2+8/FUAZYicD9spdCQ3WuSVmAE41Em
         W68Jd4kl774M7rJQDXVqRvR4VPx9KfJD9GCbcTkdSxEbiUPcSLG+AfIGknd1KWVRz9sx
         P0KR2ac10GvTj0dKrwnZabvGDuVmn9RRcUNnNidrMhSMKoKe+04QtlFFkVhM1zUs+yqQ
         pmQw==
X-Gm-Message-State: AFqh2kr3ZkwI3skHtbl1hvnkqfi7F2/4GH+LujqHRc2uZqiBMysp9ptL
        XWHqAIcQZqv/oJ+jgnjaSO9ODUVwECs2IhrtuLnzk2avi6IAwwO1QtHzihYfOqt2IU+2R32XNwN
        DppF9snHgw+Px
X-Received: by 2002:a17:906:fca5:b0:872:a754:da72 with SMTP id qw5-20020a170906fca500b00872a754da72mr23935467ejb.63.1674480256519;
        Mon, 23 Jan 2023 05:24:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvWVESQ6gvIlaZp8UkmIlRfmQGdQ97DfpyOKHldzLENiB6CL/kd0Ra2EwP90IbT3ugk61h1UQ==
X-Received: by 2002:a17:906:fca5:b0:872:a754:da72 with SMTP id qw5-20020a170906fca500b00872a754da72mr23935450ejb.63.1674480256250;
        Mon, 23 Jan 2023 05:24:16 -0800 (PST)
Received: from ovpn-194-126.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p24-20020a17090653d800b008775b8a5a5fsm8287076ejo.198.2023.01.23.05.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 05:24:15 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <20230123124641.4138-1-alexandru.matei@uipath.com>
References: <20230123124641.4138-1-alexandru.matei@uipath.com>
Date:   Mon, 23 Jan 2023 14:24:14 +0100
Message-ID: <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
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
> v2:
>   - pass (e)vmcs01 to evmcs_touch_msr_bitmap
>   - use loaded_vmcs * instead of vcpu_vmx * to avoid
>     including vmx.h which generates circular dependency
>
> v1: https://lore.kernel.org/kvm/20230118141348.828-1-alexandru.matei@uipath.com/
>
>  arch/x86/kvm/vmx/hyperv.h | 16 +++++++++++-----
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 571e7929d14e..132e32e57d2d 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -190,13 +190,19 @@ static inline u16 evmcs_read16(unsigned long field)
>  	return *(u16 *)((char *)current_evmcs + offset);
>  }
>  
> -static inline void evmcs_touch_msr_bitmap(void)
> +static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01)

Personally, I would've followed Sean's suggestion and passed "struct
vcpu_vmx *vmx" as 'loaded_vmcs' here is a bit ambiguos....

>  {
> -	if (unlikely(!current_evmcs))
> +	/*
> +	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
> +	 * always operates on (e)vmcs01
> +	 */
> +	struct hv_enlightened_vmcs* evmcs = (void*)vmcs01->vmcs;

(Nit: a space between "void" and "*")

.. or, alternatively, you can directly pass 
(struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs as e.g. 'current_evmcs'
and avoid the conversion here.

> +
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
> @@ -219,7 +225,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>  static inline void evmcs_load(u64 phys_addr) {}
> -static inline void evmcs_touch_msr_bitmap(void) {}
> +static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  #define EVMPTR_INVALID (-1ULL)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe5615fd8295..2a3be8e8a1bf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	 * bitmap has changed.
>  	 */
>  	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +		evmcs_touch_msr_bitmap(&vmx->vmcs01);
>  
>  	vmx->nested.force_msr_bitmap_recalc = true;
>  }

-- 
Vitaly

