Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48F449A36
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhKHQtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 11:49:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241375AbhKHQs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 11:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636389972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1ltadtEx7jvb3qLinyURJu824CaztEEWY3x8pCyubw=;
        b=TDDf/Nu0V2NGdQHhw6U+mg368wK/xO0TfF43m+P28ZaLiOB0uzzThOnpX7IGiuxt54VZS6
        47IwkMIgV2rUdQsTunekXyW1qPo/wcIeLpZ6QMGuQsiVssi8qNDTaXAei4MCvA5VVbBrG6
        LveMwsKDY6UF8AwTEZ2Cn83V/TGjNRA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-yf1Yfnt1NJqDSGdrO-7ycw-1; Mon, 08 Nov 2021 11:46:11 -0500
X-MC-Unique: yf1Yfnt1NJqDSGdrO-7ycw-1
Received: by mail-wm1-f71.google.com with SMTP id c185-20020a1c35c2000000b003331dc61c6cso4863737wma.6
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 08:46:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=E1ltadtEx7jvb3qLinyURJu824CaztEEWY3x8pCyubw=;
        b=t4eBswhVv11gViapWMh/bzu67bBIl6jNDB99bhKX7Vbd8W2N1VqkLN607fvx32uEFX
         k+6sjZDQ8lIzDBd/EhfHzFzJIWs8qXQfpd8QR4DqBy8dHERQ6Vp6JuQN/mwW4TIvTcta
         H1AgtPrMNm6Zup5KTOtbq8QwDB/9WLcGqyym9qTJRbA7auALb78Mvaj0ixPqjiTWhDaN
         EhY8aCz0cTiWd/n4EoP2s8RkoysBRCuFLXUZfbaidl4EcDJgYX+3PJicZ2pTPeM6P3iH
         tggaAuVx90SISTQ16NaRSUyZhm/OEmSzlR9rHP97o9PKmclgZJ6oDe7m+mcBErveXMDq
         M1Ww==
X-Gm-Message-State: AOAM530Q6cc4cZew9MkPLVOJj+nYlbZ2Qh7KZhwIRWmYNampKwOrYEz0
        iqO04I/cWloexpDPVGehPBpyS4hFhCziN7f/bcEf6xK+KG9Ua8AVvgvfpuG8Sx7xirT9JLlzNR7
        USwjvvEMwBSE9
X-Received: by 2002:a05:6000:1b8f:: with SMTP id r15mr603338wru.27.1636389970548;
        Mon, 08 Nov 2021 08:46:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztSWWasOeF193GU4qII35pVBv5TUKgbjRjteT1t0G5DV6G8jUQZxBZEtHOeLqu7RIN0j0BqQ==
X-Received: by 2002:a05:6000:1b8f:: with SMTP id r15mr603289wru.27.1636389970222;
        Mon, 08 Nov 2021 08:46:10 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z135sm24310972wmc.45.2021.11.08.08.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 08:46:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Handle dynamic MSR intercept toggling
In-Reply-To: <20210924204907.1111817-2-seanjc@google.com>
References: <20210924204907.1111817-1-seanjc@google.com>
 <20210924204907.1111817-2-seanjc@google.com>
Date:   Mon, 08 Nov 2021 17:46:08 +0100
Message-ID: <87k0hioasv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

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
> Move the various accessor/mutators that are currently buried in vmx.c
> into vmx.h so that they can be shared by the nested code.
>
> Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
> Fixes: d69129b4e46a ("KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible")
> Cc: stable@vger.kernel.org
> Cc: Alexander Graf <graf@amazon.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 111 +++++++++++++++++---------------------
>  arch/x86/kvm/vmx/vmx.c    |  67 ++---------------------
>  arch/x86/kvm/vmx/vmx.h    |  63 ++++++++++++++++++++++
>  3 files changed, 116 insertions(+), 125 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index eedcebf58004..3c9657f6923e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -523,29 +523,6 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
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
>  /*
>   * If a msr is allowed by L0, we should check whether it is allowed by L1.
>   * The corresponding bit will be cleared unless both of L0 and L1 allow it.
> @@ -599,6 +576,34 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
>  	}
>  }
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
>  /*
>   * Merge L0's and L1's MSR bitmap, return false to indicate that
>   * we do not use the hardware.
> @@ -606,10 +611,11 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
>  static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  						 struct vmcs12 *vmcs12)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	int msr;
>  	unsigned long *msr_bitmap_l1;
> -	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
> -	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
> +	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
> +	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
>  
>  	/* Nothing to do if the MSR bitmap is not in use.  */
>  	if (!cpu_has_vmx_msr_bitmap() ||
> @@ -660,44 +666,27 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> -	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
> -#ifdef CONFIG_X86_64
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_FS_BASE, MSR_TYPE_RW);
> -
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_GS_BASE, MSR_TYPE_RW);
> -
> -	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> -					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> -#endif
> -
>  	/*
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
>  	 */
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
> +#ifdef CONFIG_X86_64
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_FS_BASE, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_GS_BASE, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +#endif
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
> +
> +	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>  
>  	return true;
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d118daed0530..86a8c2713039 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -766,29 +766,6 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
>  	vmcs_write32(EXCEPTION_BITMAP, eb);
>  }
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
>  static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  		unsigned long entry, unsigned long exit)
>  {
> @@ -3695,46 +3672,6 @@ void free_vpid(int vpid)
>  	spin_unlock(&vmx_vpid_lock);
>  }
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
>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6749,7 +6686,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>  	 * save it.
>  	 */
> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> +	if (unlikely(cpu_has_vmx_msr_bitmap() &&
> +		     vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
> +					       MSR_IA32_SPEC_CTRL)))
>  		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

I smoke-tested this patch by running (unrelated) selftests when I tried
to put in into my 'Enlightened MSR Bitmap v4' series and my dmesg got
flooded with:

[   87.210214] unchecked MSR access error: RDMSR from 0x48 at rIP: 0xffffffffc04e0284 (native_read_msr+0x4/0x30 [kvm_intel])
[   87.210325] Call Trace:
[   87.210355]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
[   87.210405]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
[   87.210466]  vcpu_enter_guest+0x98c/0x1380 [kvm]
[   87.210631]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
[   87.210678]  ? vmx_vcpu_load+0x21/0x60 [kvm_intel]
[   87.210729]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
[   87.210844]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
[   87.210950]  __x64_sys_ioctl+0x83/0xb0
[   87.210996]  do_syscall_64+0x3b/0x90
[   87.211039]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   87.211093] RIP: 0033:0x7f6ef7f9a307
[   87.211134] Code: 44 00 00 48 8b 05 69 1b 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 1b 2d 00 f7 d8 64 89 01 48
[   87.211293] RSP: 002b:00007ffcacfb3b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   87.211367] RAX: ffffffffffffffda RBX: 0000000000a2f300 RCX: 00007f6ef7f9a307
[   87.211434] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
[   87.211500] RBP: 0000000000000000 R08: 000000000040e769 R09: 0000000000000000
[   87.211559] R10: 0000000000a2f001 R11: 0000000000000246 R12: 0000000000a2d010
[   87.211622] R13: 0000000000a2d010 R14: 0000000000402a15 R15: 00000000ffff0ff0
[   87.212520] Call Trace:
[   87.212597]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
[   87.212683]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
[   87.212789]  vcpu_enter_guest+0x98c/0x1380 [kvm]
[   87.213059]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
[   87.213141]  ? schedule+0x44/0xa0
[   87.213200]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
[   87.213428]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
[   87.213633]  __x64_sys_ioctl+0x83/0xb0
[   87.213705]  do_syscall_64+0x3b/0x90
[   87.213766]  entry_SYSCALL_64_after_hwframe+0x44/0xae
...

this was an old 'E5-2603 v3' CPU. Any idea what's wrong?

>  
>  	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 592217fd7d92..3f9c8548625d 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -400,6 +400,69 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>  
>  void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
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
>  static inline u8 vmx_get_rvi(void)
>  {
>  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;

-- 
Vitaly

