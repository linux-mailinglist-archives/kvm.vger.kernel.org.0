Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF8388310
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 01:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhERXWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 19:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhERXWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 19:22:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BFFC06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 16:21:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t4so5980031plc.6
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 16:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hYL+358IhI3tVTeCOMkAFDGsvVMfIWEEDq9FAjlWNsI=;
        b=G05ALZwBC8OER4y93Cxsb1V2n1jBmq0a+hWE20woRj7at5rNdMkAt1LDwtfJ+heUHz
         mU8RtN+czeqCKgM+55iS4wV2u+jigli7M5UJV6qHuHwasfT3ryIBkeRd2bL/IfX9h6/8
         VX1OL+JW5V/YHTp8IgSEFotSDsttOSnMyK2MDBv85Sd1YbNn2lfC1c2RuLej3t58+RK1
         54/GzaItxqcm5SSyJ2J5cSfvdrR2/nTiyrgyMIpFEqj8CZeRWG7CL/OctdRtpRVxioJq
         M6Y7T+uRCLH5pEC9uxociGyj7y4tSMGRMcSsE7oWvtdTAzdEWx/VXMS/G7//agb8kneA
         hHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hYL+358IhI3tVTeCOMkAFDGsvVMfIWEEDq9FAjlWNsI=;
        b=VW396r545BweCclk9cncdkDwP4iMZPpQifvqXJ/4bvKALWMDhQqu6FTG8i7Cr+RZIV
         ytH7FehdXPgKebHKiLbxEYPwNmKzZtL2HK/uKXKeppr4yqh7KPINcEkMxYgq+YRj6P2d
         xV3Y1BZNMdlwSXGOHbS/qCsaBU4ZhdibLvPWyCu/lc+R/sbSn9+KmdKPEeFHYccvPLN+
         tTWYEMzS8dwAW4H7mnGOw0jGRB+ycmJ3ohvsc2y4ZB2esJ4JFLHRMwdRhD/+i/1Fjkwp
         BY4n0NLLNZXn/lM5Z6v2hwHeSGn9SIVT+Y2VApXReEkzZoHE9CP06lWp2Si3/sbvPogn
         RFcA==
X-Gm-Message-State: AOAM530YjVOLUOBINxBd091xQzkTpgw+nqRXxT+zub2J7hCdEzYu/tce
        Z6lz1GvmYMnMu3rA3YPcloDHsQ==
X-Google-Smtp-Source: ABdhPJyRBWd4yS3Fm7iLljS3W27F3CMUk0k4SoCrldCrjAgtfaQZ2Ue2iJGoXZavy9weZXNh/rAFUw==
X-Received: by 2002:a17:90a:1b45:: with SMTP id q63mr8089839pjq.195.1621380088510;
        Tue, 18 May 2021 16:21:28 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a190sm12167908pfb.185.2021.05.18.16.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 16:21:27 -0700 (PDT)
Date:   Tue, 18 May 2021 23:21:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v2 06/10] KVM: X86: Add functions that calculate the 02
 TSC offset and multiplier
Message-ID: <YKRL9PPklYCFy43n@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-7-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512150945.4591-7-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ilias Stamatis wrote:
> When L2 is entered we need to "merge" the TSC multiplier and TSC offset
> values of 01 and 12 together.
> 
> The merging is done using the following equations:
>   offset_02 = ((offset_01 * mult_12) >> shift_bits) + offset_12
>   mult_02 = (mult_01 * mult_12) >> shift_bits
> 
> Where shift_bits is kvm_tsc_scaling_ratio_frac_bits.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4c4a3fefff57..57a25d8e8b0f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1793,6 +1793,8 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
>  u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
> +void kvm_set_02_tsc_offset(struct kvm_vcpu *vcpu);
> +void kvm_set_02_tsc_multiplier(struct kvm_vcpu *vcpu);
>  
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
>  bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 84af1af7a2cc..1db6cfc2079f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2346,6 +2346,35 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
> +void kvm_set_02_tsc_offset(struct kvm_vcpu *vcpu)

I dislike like the "02" nomenclature.  "02" is used specifically to refer to
vmcs02 and vmcb02, whereas these helpers touch KVM's software model, not the CPU
struct.  Can't this simply be "l2"?

> +{
> +	u64 l2_offset = static_call(kvm_x86_get_l2_tsc_offset)(vcpu);
> +	u64 l2_multiplier = static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu);
> +
> +	if (l2_multiplier != kvm_default_tsc_scaling_ratio) {
> +		vcpu->arch.tsc_offset = mul_s64_u64_shr(
> +				(s64) vcpu->arch.l1_tsc_offset,
> +				l2_multiplier,
> +				kvm_tsc_scaling_ratio_frac_bits);
> +	}
> +
> +	vcpu->arch.tsc_offset += l2_offset;
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_02_tsc_offset);
> +
> +void kvm_set_02_tsc_multiplier(struct kvm_vcpu *vcpu)

I normally like splitting patches gratuitously, but in this case I think it would
be better to combine this with the VMX usage in patch 08.  It's impossible to
properly review this patch without looking at its callers.

> +{
> +	u64 l2_multiplier = static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu);

Case in point, calling back into vendor code to get the L2 multiplier is silly,
just have the caller provide it explicitly.

> +	if (l2_multiplier != kvm_default_tsc_scaling_ratio) {

Why does this check against the default ratio instead of L1's ratio?  If L1 is
running a non-default ratio, but L2 is running a default ratio, won't this result
in KVM leaving vcpu->arch.tsc_scaling_ratio at L1's ratio?  Or is there scaling
ratio magic I don't understand (which is likely...)?  If there's magic, can you
add a comment?

Same feedback for the check in the offset version.

> +		vcpu->arch.tsc_scaling_ratio = mul_u64_u64_shr(
> +				vcpu->arch.l1_tsc_scaling_ratio,
> +				l2_multiplier,
> +				kvm_tsc_scaling_ratio_frac_bits);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_02_tsc_multiplier);
> +
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	vcpu->arch.l1_tsc_offset = offset;
> -- 
> 2.17.1
> 
