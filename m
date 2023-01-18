Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BF06722DC
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjARQVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjARQVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:21:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D469A16ADE
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674058607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I4r8CuW+YnKvqSeeax1QytRlVDAJqyT4u8ebKhPNjo4=;
        b=ao6agEB4PKdmEfALUsiWAYSN+mXIO1mKlr+8PAQ6J3t12FbX4x9w12Fa+xxysanNT3FRtG
        6O3taOiAJtWDfD5tRqLLHcA2Tdu0rCLHka2wadxLpjbqt/s2I8Ea8ga5ZUMcS9Wszz32gf
        IsCwfh1SB1vQI1i6nSbzs+A4Dbsk3U8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-k0Mlo56cOvShHwfLZzPTyw-1; Wed, 18 Jan 2023 11:16:45 -0500
X-MC-Unique: k0Mlo56cOvShHwfLZzPTyw-1
Received: by mail-ed1-f70.google.com with SMTP id z18-20020a05640235d200b0049d84165065so8794167edc.18
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:16:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4r8CuW+YnKvqSeeax1QytRlVDAJqyT4u8ebKhPNjo4=;
        b=Hj3qE1WqxNZBIxXW/nHxahENcHQXDD1SnzkMMumKFqlerggyGdqkkc+AUOO0+kDTWV
         qVEkG06KHwDV4L6bH0/gDSsk+r1Nr5NZMqiuAOP80D9s5Cs53LMI/hFKjoXcTPQF2+tb
         /3ntWP4O63b834k+CbzV/mabMLvJXK3vVV3R3WDDXYKcGdhOKMcKhwhxr78iA4ovV9bf
         TwjEPF3CFrDw/AXsQkcgnZbhGgeCPCz1sFSorUehIh1494l6uNGhuJfcr3me5AgZMO/F
         +zdm7+/22EcPmpESMd1eJ28DzR3Ymgm3bFDLVLz3Ke7TNlL4Y197+DND+hFphOLfDTfO
         GI3w==
X-Gm-Message-State: AFqh2kpHY8tSq5JrE2gN3MysR7d//HZMNeudA8NP6aECBzXqbJahb6h+
        /1boeRFEFJ6Bt5a0CcHga9WibQFm/QhJ7ll5deCMiJWVsZEfF+Es0gyNL43e/Vo1OieA08yIL+L
        U/qoCBCHacY4C
X-Received: by 2002:a50:fe95:0:b0:46c:aa8b:da5c with SMTP id d21-20020a50fe95000000b0046caa8bda5cmr7299738edt.33.1674058604621;
        Wed, 18 Jan 2023 08:16:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv0mzGeCORs+rL+WFHMFaMedZamVs1+tL0AujyQL/Ydr0pFwgWRmY5hC+H2H9tmo/saPRTfYA==
X-Received: by 2002:a50:fe95:0:b0:46c:aa8b:da5c with SMTP id d21-20020a50fe95000000b0046caa8bda5cmr7299730edt.33.1674058604447;
        Wed, 18 Jan 2023 08:16:44 -0800 (PST)
Received: from ovpn-194-7.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v22-20020aa7d816000000b0049dd7eec977sm5638085edq.41.2023.01.18.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:16:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <Y8gT/DNwUvaDjfeW@google.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
 <Y8gT/DNwUvaDjfeW@google.com>
Date:   Wed, 18 Jan 2023 17:16:42 +0100
Message-ID: <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
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

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 18, 2023, Alexandru Matei wrote:
>> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
>> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
>> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
>> that the msr bitmap was changed.
>> 
>> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
>> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
>> function checks for current_vmcs if it is null but the check is
>> insufficient because current_vmcs is not initialized. Because of this, the
>> code might incorrectly write to the structure pointed by current_vmcs value
>> left by another task. Preemption is not disabled so the current task can
>> also be preempted and moved to another CPU while current_vmcs is accessed
>> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
>> 
>> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
>> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
>> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
>> initialized.
>
> IMO, moving the calls is a band-aid and doesn't address the underlying bug.  I
> don't see any reason why the Hyper-V code should use a per-cpu pointer in this
> case.  It makes sense when replacing VMX sequences that operate on the VMCS, e.g.
> VMREAD, VMWRITE, etc., but for operations that aren't direct replacements for VMX
> instructions I think we should have a rule that Hyper-V isn't allowed to touch the
> per-cpu pointer.
>
> E.g. in this case it's trivial to pass down the target (completely untested).
>
> Vitaly?

Mid-air collision detected) I've just suggested a very similar approach
but instead of 'vmx->vmcs01.vmcs' I've suggested using
'vmx->loaded_vmcs->vmcs': in case we're running L2 and loaded VMCS is
'vmcs02', I think we still need to touch the clean field indicating that
MSR-Bitmap has changed. Equally untested :-)

>
>
> ---
>  arch/x86/kvm/vmx/hyperv.h | 12 +++++++-----
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index ab08a9b9ab7d..ad16b52766bb 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -250,13 +250,15 @@ static inline u16 evmcs_read16(unsigned long field)
>  	return *(u16 *)((char *)current_evmcs + offset);
>  }
>  
> -static inline void evmcs_touch_msr_bitmap(void)
> +static inline void evmcs_touch_msr_bitmap(struct vcpu_vmx *vmx)
>  {
> -	if (unlikely(!current_evmcs))
> +	struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
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
> @@ -280,7 +282,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>  static inline void evmcs_load(u64 phys_addr) {}
> -static inline void evmcs_touch_msr_bitmap(void) {}
> +static inline void evmcs_touch_msr_bitmap(struct vcpu_vmx *vmx) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  #define EVMPTR_INVALID (-1ULL)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..6ed6f52aad0c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3937,7 +3937,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	 * bitmap has changed.
>  	 */
>  	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +		evmcs_touch_msr_bitmap(vmx);
>  
>  	vmx->nested.force_msr_bitmap_recalc = true;
>  }
>
> base-commit: 6e9a476ea49d43a27b42004cfd7283f128494d1d

-- 
Vitaly

