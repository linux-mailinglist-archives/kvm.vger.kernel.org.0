Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEDE275E7D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIWRUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:20:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWRUX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600881622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZFvXxnOLhEH+5dxb25balw/PWjti1ehR7buvEyRBXk=;
        b=bVDCRf/ATx0vbQgQ173qoB6NfOvKPiAlH5dXT53JaheHDw1pgjHKhphX0XK9Aw8NRq49sx
        mmnfVxfxX6/sO9ZmiXWaRYqVJ3KU09a5F5igLE8BcakB7N1dKGizpY3ePPG4S3u+UI47iZ
        /xpD9UZmhfOeMrllL5pEU9i9b2Ev0XM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-zI9Xkug-PWapAWkUltGeRQ-1; Wed, 23 Sep 2020 13:20:20 -0400
X-MC-Unique: zI9Xkug-PWapAWkUltGeRQ-1
Received: by mail-wr1-f71.google.com with SMTP id a12so102328wrg.13
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZFvXxnOLhEH+5dxb25balw/PWjti1ehR7buvEyRBXk=;
        b=DWBycYPhCpmapUuC6czT3FXlewWhgzKM00cF+uvool03guKZ9gjVWOPdqq+JcsFOjd
         FtxX5aRDrb5YlipKY4lrBM2zg6Fg/bA7cMdwviLtCvJAbILp5/+ViwpcyhLY9DH2vkNG
         iy2Imrb/YlYk2uDUxCqawQWrfEUqykLeTDMCEDUZ9YNF4Mgz4WDG+d8s2K6MCCrE65WY
         vJeDfbtb92EnmuCOsgs3FDliGOsfwZOQFFF8rT7zvBy/TuraaAPQLkZZuo03aIaalLWQ
         6f7vGMmSyHPsCO91aEbRf6bn02kHWMS/7AeyyB0feB0Tz87fQwcihyo/jtb6dJE/iQNM
         1M0w==
X-Gm-Message-State: AOAM530rq9JkpJfUjMU6/NdZJjuqiNf0Cjr1lROMXiW3r2f7BoDxHE/D
        XgbxYhJKLI2+5UDWGHYJZvjadXT0zSMvtP0152RxJK5p3aYOoi5v+HQmFVcrKdiXrJvA928xBna
        1w0eqdlBlykN+
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr584137wma.132.1600881619288;
        Wed, 23 Sep 2020 10:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+BW+6WpVYdCqI1KtCMdlHEnNs6/D6BI9+kloY8rGnumiArlM+N7mI2f0/xlcRsDUXMEuowA==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr584116wma.132.1600881618990;
        Wed, 23 Sep 2020 10:20:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id 97sm538185wrm.15.2020.09.23.10.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:20:17 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: VMX: Add a helper and macros to reduce
 boilerplate for sec exec ctls
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
 <20200923165048.20486-5-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <784480fd-3aeb-6c08-30f9-ac474bb23b6c@redhat.com>
Date:   Wed, 23 Sep 2020 19:20:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923165048.20486-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 18:50, Sean Christopherson wrote:
> Add a helper function and several wrapping macros to consolidate the
> copy-paste code in vmx_compute_secondary_exec_control() for adjusting
> controls that are dependent on guest CPUID bits.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 128 +++++++++++++----------------------------
>  1 file changed, 41 insertions(+), 87 deletions(-)

The diffstat is enticing but the code a little less so...  Can you just
add documentation above vmx_adjust_secondary_exec_control that explains
the how/why?

Paolo

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5180529f6531..b786cfb74f4f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4073,6 +4073,38 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  }
>  
>  
> +static inline void
> +vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
> +				  u32 control, bool enabled, bool exiting)
> +{
> +	if (enabled == exiting)
> +		*exec_control &= ~control;
> +	if (nested) {
> +		if (enabled)
> +			vmx->nested.msrs.secondary_ctls_high |= control;
> +		else
> +			vmx->nested.msrs.secondary_ctls_high &= ~control;
> +	}
> +}
> +
> +#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
> +({									 \
> +	bool __enabled;							 \
> +									 \
> +	if (cpu_has_vmx_##name()) {					 \
> +		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
> +					    X86_FEATURE_##feat_name);	 \
> +		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
> +			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
> +	}								 \
> +})
> +
> +#define vmx_adjust_sec_exec_feature(vmx, exec_control, lname, uname) \
> +	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, ENABLE_##uname, false)
> +
> +#define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
> +	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
> +
>  static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  {

