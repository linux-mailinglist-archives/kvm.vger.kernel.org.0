Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB233F0FC
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 14:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCQNRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 09:17:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhCQNRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 09:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615987059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Re55l15tAzqIwgbcPGT5mg08j9IQc5Vt795kkC6STmU=;
        b=VY0jmqM+v0RQPrrijgsHz0WSxmc/ljDWlRTUonS93TPz771TIYGMXbB/HwZxygS6ABOlZF
        a6Y5OB04rZ2av+fe8RLKS74t349wOfMNDAw0arvuNGrMq8mV0qKAuq1H/bFgIOwgqfglm1
        ZashLht2vikOkGNm/CXmkiyQeQ0h32A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-c4A1-NzvO56VhEvpWm_W_Q-1; Wed, 17 Mar 2021 09:17:37 -0400
X-MC-Unique: c4A1-NzvO56VhEvpWm_W_Q-1
Received: by mail-wr1-f70.google.com with SMTP id z6so18361446wrh.11
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Re55l15tAzqIwgbcPGT5mg08j9IQc5Vt795kkC6STmU=;
        b=B8vJy0hansfsNd/XP9qpcXM+tB7+5AKQPxHCvEy4sVMGcwncxsrekKPgJKPJvkWYKp
         8Ag45mZdmadhNhAWkbFUNYHoRV0GlAV/Vu5yVE8n1soKpNQ6d50XxUb/r+NhNQzIfUtj
         UKGf/2FvYYwdKWbrOoMbh0tt7EtrVPTdL8lWmehjx9BrJMD+o0EmWQmWhuqHzZ3pIzH3
         /r7XasjC9TcSyTInOgARsq2NaQlUplouvG2hF8C/DxTE2zDpF1h5gY+vgtymb7lcSFW0
         yODmPsG2taCCtWN/m48SxmN4jb7PWNCAA/buKa4tDWTjSK+JZQPTOqDk3VXihS68Nyv+
         puJg==
X-Gm-Message-State: AOAM531r165DcdOE2u9JoQS8judboCUiYJJZqIQOn0VkW3PMu6YOMgqR
        biNb1+AQBVSu1+K9Z63mvXckTtli/Wxc1rzVsJON42LBlPlGJP2AqUwJ3wv7+k5u0lntZyIVI5W
        pqd71j59yVC9j
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr3674536wmf.136.1615987056653;
        Wed, 17 Mar 2021 06:17:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnMgtlXJkpLBs3ujd4ADqeIXJIIf4RKhRMtfQQ6mbPNllFwEs4kSZuQmcCVjXNxMWuy2nb6w==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr3674514wmf.136.1615987056410;
        Wed, 17 Mar 2021 06:17:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n6sm29845402wrw.63.2021.03.17.06.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 06:17:35 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: nVMX: Handle dynamic MSR intercept toggling
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66bc75f6-58c5-c67f-f268-220d371022a2@redhat.com>
Date:   Wed, 17 Mar 2021 14:17:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210316184436.2544875-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 19:44, Sean Christopherson wrote:
> Always check vmcs01's MSR bitmap when merging L0 and L1 bitmaps for L2,
> and always update the relevant bits in vmcs02.  This fixes two distinct,
> but intertwined bugs related to dynamic MSR bitmap modifications.
> 
> The first issue is that KVM fails to enable MSR interception in vmcs02
> for the FS/GS base MSRs if L1 first runs L2 with interception disabled,
> and later enables interception.
> 
> The second issue is that KVM fails to honor userspace MSR filtering when
> preparing vmcs02.
> 
> Fix both issues simultaneous as fixing only one of the issues (doesn't
> matter which) would create a mess that no one should have to bisect.
> Fixing only the first bug would exacerbate the MSR filtering issue as
> userspace would see inconsistent behavior depending on the whims of L1.
> Fixing only the second bug (MSR filtering) effectively requires fixing
> the first, as the nVMX code only knows how to transition vmcs02's
> bitmap from 1->0.
> 
> Move the various accessor/mutators buried in vmx.c into vmx.h so that
> they can be shared by the nested code.
> 
> Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
> Fixes: d69129b4e46a ("KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible")
> Cc: stable@vger.kernel.org
> Cc: Alexander Graf <graf@amazon.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 108 +++++++++++++++++---------------------
>   arch/x86/kvm/vmx/vmx.c    |  67 ++---------------------
>   arch/x86/kvm/vmx/vmx.h    |  63 ++++++++++++++++++++++
>   3 files changed, 115 insertions(+), 123 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fd334e4aa6db..aff41a432a56 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -475,29 +475,6 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
>   	return 0;
>   }
>   
> -/*
> - * Check if MSR is intercepted for L01 MSR bitmap.
> - */
> -static bool msr_write_intercepted_l01(struct kvm_vcpu *vcpu, u32 msr)
> -{
> -	unsigned long *msr_bitmap;
> -	int f = sizeof(unsigned long);
> -
> -	if (!cpu_has_vmx_msr_bitmap())
> -		return true;
> -
> -	msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
> -
> -	if (msr <= 0x1fff) {
> -		return !!test_bit(msr, msr_bitmap + 0x800 / f);
> -	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
> -		msr &= 0x1fff;
> -		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
> -	}
> -
> -	return true;
> -}
> -
>   /*
>    * If a msr is allowed by L0, we should check whether it is allowed by L1.
>    * The corresponding bit will be cleared unless both of L0 and L1 allow it.
> @@ -551,6 +528,34 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
>   	}
>   }
>   
> +#define BUILD_NVMX_MSR_INTERCEPT_HELPER(rw)					\
> +static inline									\
> +void nested_vmx_set_msr_##rw##_intercept(struct vcpu_vmx *vmx,			\
> +					 unsigned long *msr_bitmap_l1,		\
> +					 unsigned long *msr_bitmap_l0, u32 msr)	\
> +{										\
> +	if (vmx_test_msr_bitmap_##rw(vmx->vmcs01.msr_bitmap, msr) ||		\
> +	    vmx_test_msr_bitmap_##rw(msr_bitmap_l1, msr))			\
> +		vmx_set_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
> +	else									\
> +		vmx_clear_msr_bitmap_##rw(msr_bitmap_l0, msr);			\
> +}
> +BUILD_NVMX_MSR_INTERCEPT_HELPER(read)
> +BUILD_NVMX_MSR_INTERCEPT_HELPER(write)
> +
> +static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
> +						    unsigned long *msr_bitmap_l1,
> +						    unsigned long *msr_bitmap_l0,
> +						    u32 msr, int types)
> +{
> +	if (types & MSR_TYPE_R)
> +		nested_vmx_set_msr_read_intercept(vmx, msr_bitmap_l1,
> +						  msr_bitmap_l0, msr);
> +	if (types & MSR_TYPE_W)
> +		nested_vmx_set_msr_write_intercept(vmx, msr_bitmap_l1,
> +						   msr_bitmap_l0, msr);
> +}
> +
>   /*
>    * Merge L0's and L1's MSR bitmap, return false to indicate that
>    * we do not use the hardware.
> @@ -558,10 +563,11 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
>   static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>   						 struct vmcs12 *vmcs12)
>   {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	int msr;
>   	unsigned long *msr_bitmap_l1;
> -	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
> -	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
> +	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
> +	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
>   
>   	/* Nothing to do if the MSR bitmap is not in use.  */
>   	if (!cpu_has_vmx_msr_bitmap() ||
> @@ -612,42 +618,26 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>   		}
>   	}
>   
> -	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_FS_BASE, MSR_TYPE_RW);
> -
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_GS_BASE, MSR_TYPE_RW);
> -
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> -
>   	/*
> -	 * Checking the L0->L1 bitmap is trying to verify two things:
> -	 *
> -	 * 1. L0 gave a permission to L1 to actually passthrough the MSR. This
> -	 *    ensures that we do not accidentally generate an L02 MSR bitmap
> -	 *    from the L12 MSR bitmap that is too permissive.
> -	 * 2. That L1 or L2s have actually used the MSR. This avoids
> -	 *    unnecessarily merging of the bitmap if the MSR is unused. This
> -	 *    works properly because we only update the L01 MSR bitmap lazily.
> -	 *    So even if L0 should pass L1 these MSRs, the L01 bitmap is only
> -	 *    updated to reflect this when L1 (or its L2s) actually write to
> -	 *    the MSR.
> +	 * Always check vmcs01's bitmap to honor userspace MSR filters and any
> +	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
>   	 */
> -	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL))
> -		nested_vmx_disable_intercept_for_msr(
> -					msr_bitmap_l1, msr_bitmap_l0,
> -					MSR_IA32_SPEC_CTRL,
> -					MSR_TYPE_R | MSR_TYPE_W);
> -
> -	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD))
> -		nested_vmx_disable_intercept_for_msr(
> -					msr_bitmap_l1, msr_bitmap_l0,
> -					MSR_IA32_PRED_CMD,
> -					MSR_TYPE_W);
> -
> -	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_FS_BASE, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_GS_BASE, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
> +
> +	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>   
>   	return true;
>   }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c8a4a548e96b..9972e5d1c44e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -879,29 +879,6 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
>   	vmcs_write32(EXCEPTION_BITMAP, eb);
>   }
>   
> -/*
> - * Check if MSR is intercepted for currently loaded MSR bitmap.
> - */
> -static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> -{
> -	unsigned long *msr_bitmap;
> -	int f = sizeof(unsigned long);
> -
> -	if (!cpu_has_vmx_msr_bitmap())
> -		return true;
> -
> -	msr_bitmap = to_vmx(vcpu)->loaded_vmcs->msr_bitmap;
> -
> -	if (msr <= 0x1fff) {
> -		return !!test_bit(msr, msr_bitmap + 0x800 / f);
> -	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
> -		msr &= 0x1fff;
> -		return !!test_bit(msr, msr_bitmap + 0xc00 / f);
> -	}
> -
> -	return true;
> -}
> -
>   static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>   		unsigned long entry, unsigned long exit)
>   {
> @@ -3709,46 +3686,6 @@ void free_vpid(int vpid)
>   	spin_unlock(&vmx_vpid_lock);
>   }
>   
> -static void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
> -{
> -	int f = sizeof(unsigned long);
> -
> -	if (msr <= 0x1fff)
> -		__clear_bit(msr, msr_bitmap + 0x000 / f);
> -	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> -		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
> -}
> -
> -static void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
> -{
> -	int f = sizeof(unsigned long);
> -
> -	if (msr <= 0x1fff)
> -		__clear_bit(msr, msr_bitmap + 0x800 / f);
> -	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> -		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
> -}
> -
> -static void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
> -{
> -	int f = sizeof(unsigned long);
> -
> -	if (msr <= 0x1fff)
> -		__set_bit(msr, msr_bitmap + 0x000 / f);
> -	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> -		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
> -}
> -
> -static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
> -{
> -	int f = sizeof(unsigned long);
> -
> -	if (msr <= 0x1fff)
> -		__set_bit(msr, msr_bitmap + 0x800 / f);
> -	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> -		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
> -}
> -
>   static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
>   							  u32 msr, int type)
>   {
> @@ -6722,7 +6659,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>   	 * save it.
>   	 */
> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> +	if (unlikely(cpu_has_vmx_msr_bitmap() &&
> +		     vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
> +					       MSR_IA32_SPEC_CTRL)))
>   		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
>   
>   	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 0fb3236b0283..a6000c91b897 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -393,6 +393,69 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
>   	u32 msr, int type, bool value);
>   void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>   
> +static inline bool vmx_test_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		return test_bit(msr, msr_bitmap + 0x000 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		return test_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
> +	return true;
> +}
> +
> +static inline bool vmx_test_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		return test_bit(msr, msr_bitmap + 0x800 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		return test_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
> +	return true;
> +}
> +
> +static inline void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		__clear_bit(msr, msr_bitmap + 0x000 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
> +}
> +
> +static inline void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		__clear_bit(msr, msr_bitmap + 0x800 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
> +}
> +
> +static inline void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		__set_bit(msr, msr_bitmap + 0x000 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
> +}
> +
> +static inline void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
> +{
> +	int f = sizeof(unsigned long);
> +
> +	if (msr <= 0x1fff)
> +		__set_bit(msr, msr_bitmap + 0x800 / f);
> +	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
> +		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
> +}
> +
> +
>   static inline u8 vmx_get_rvi(void)
>   {
>   	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
> 

Feel free to squash patch 3 in this one or reorder it before; it makes 
sense to make them macros when you go from 4 to 6 functions.

Paolo

