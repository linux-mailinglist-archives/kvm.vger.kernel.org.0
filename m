Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C28E1797D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfEHMbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:31:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43965 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbfEHMbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:31:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id r4so11673275wro.10
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BgIIgUo8SNujj25JLnLQhi2lKd0zr0m85elohA1jRVQ=;
        b=S3b5TLVN+DK5/zDEQWd0rnjCC6d1ipYnvtGC3We1ZUsi0+2SEfPBNuXLTcnuajmm4w
         35WqEb21qq+OctDErGxkNxO0dIIyHrth9TKvgg35bAqnZe+/Bv/i6uZKMkFLD+e9rpow
         RGmKW42oCfWpKG0ozOoTNV4Bb+fbWm9LiLbu118pJAD4tkC4XhMOh8xQJF2o8ftzQerM
         nuB4LCbQEA/PtsSqFNruceTu08qbn0L1hQ9JIhhirOYo+/1lEz9Qk3CUljfICLiIGjkK
         IhKe0IYKSLfOt0eNepr/0O1yL+/kpYqw9/FN8AF0FfXlAC7x3dZ6K6F9fLQvReCNRHmv
         uKkw==
X-Gm-Message-State: APjAAAWDXgR3U9aWrxJPjk//94gbflPJEnhAhKXUZSe9NASzaDRSMIyt
        fNVS+P6XaJLiaIdmufT/CcEwJQ==
X-Google-Smtp-Source: APXvYqwBMYQ7YCc0YwVJn89R/5hmILedssPCeUlYac5IiEvt4iI1qcSpu6743IWhLrfBKhSYItDV+g==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr10686885wrx.136.1557318663418;
        Wed, 08 May 2019 05:31:03 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id o4sm2920575wmo.20.2019.05.08.05.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:31:02 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: Disable intercept for *_BASE MSR in vmcs02
 when possible
To:     Jintack Lim <jintack@cs.columbia.edu>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
References: <1557158359-6865-1-git-send-email-jintack@cs.columbia.edu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f6e474db-e40a-20cc-951e-2386a11a6ef8@redhat.com>
Date:   Wed, 8 May 2019 14:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557158359-6865-1-git-send-email-jintack@cs.columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/19 10:59, Jintack Lim wrote:
> Even when neither L0 nor L1 configured to trap *_BASE MSR accesses from
> its own VMs, the current KVM L0 always traps *_BASE MSR accesses from
> L2.  Let's check if both L0 and L1 disabled trap for *_BASE MSR for its
> VMs respectively, and let L2 access to*_BASE MSR without trap if that's
> the case.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> 
> ---
> 
> Changes since v1:
> - Added GS_BASE and KENREL_GS_BASE (Jim, Sean)
> - Changed to allow reads as well as writes (Sean)
> ---
>  arch/x86/kvm/vmx/nested.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c601d0..d167bb6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -537,6 +537,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	 */
>  	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
>  	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
> +	bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);
> +	bool gs_base = !msr_write_intercepted_l01(vcpu, MSR_GS_BASE);
> +	bool kernel_gs_base = !msr_write_intercepted_l01(vcpu,
> +							 MSR_KERNEL_GS_BASE);
>  
>  	/* Nothing to do if the MSR bitmap is not in use.  */
>  	if (!cpu_has_vmx_msr_bitmap() ||
> @@ -544,7 +548,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  		return false;
>  
>  	if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
> -	    !pred_cmd && !spec_ctrl)
> +	    !pred_cmd && !spec_ctrl && !fs_base && !gs_base && !kernel_gs_base)
>  		return false;
>  
>  	page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->msr_bitmap);
> @@ -592,6 +596,24 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> +	if (fs_base)
> +		nested_vmx_disable_intercept_for_msr(
> +					msr_bitmap_l1, msr_bitmap_l0,
> +					MSR_FS_BASE,
> +					MSR_TYPE_RW);
> +
> +	if (gs_base)
> +		nested_vmx_disable_intercept_for_msr(
> +					msr_bitmap_l1, msr_bitmap_l0,
> +					MSR_GS_BASE,
> +					MSR_TYPE_RW);
> +
> +	if (kernel_gs_base)
> +		nested_vmx_disable_intercept_for_msr(
> +					msr_bitmap_l1, msr_bitmap_l0,
> +					MSR_KERNEL_GS_BASE,
> +					MSR_TYPE_RW);
> +
>  	if (spec_ctrl)
>  		nested_vmx_disable_intercept_for_msr(
>  					msr_bitmap_l1, msr_bitmap_l0,
> 

Queued, thanks.  (It may take a couple days until I finish testing
everything for the merge window, but it will be in 5.2).

Paolo
