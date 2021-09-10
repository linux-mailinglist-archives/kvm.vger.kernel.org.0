Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B144072FF
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 23:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhIJVhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 17:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhIJVhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 17:37:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DF0C061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 14:36:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v123so3021701pfb.11
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 14:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=osMYYNGSd/Wjj+GEQ9AnjZzDNQa5kCk+UK3hUXrWsLk=;
        b=IXUbRyP+p3BXmkawxfs/aq7YDdpzZnyWexYE0UEPyjiWqxO3uGv9NI9++wqMbnMmdH
         3URAQ0FTb3EoySjHEvif6yG26N0NTBuDCOa0+xUMSoL1kD8TWU+Cvqyf8ztuC8N+f2TB
         EGHCxLcoAtBYIBEsTVA6wx+OPCFIWJzjQgsQEeIAqAXb0WPjXJVNzmcFkrBbEqAQguNF
         VRrrFmw43kb02a+KMCmooXTiiOhguXeBswP4JApCFDBI1lH40MlwzKc+OGWsuMJgK+or
         jUGOgbz+BaUESiviGAL6LjfDuVwnplOX94CrlNPxus1lFxQudezL9FmIk0zlXa/v58sV
         q1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=osMYYNGSd/Wjj+GEQ9AnjZzDNQa5kCk+UK3hUXrWsLk=;
        b=Yykp82yORSpYfEW/IWlWG14PKfClOlORzbpmRgFGMm+fTwvltaZA92bOJqMS+EDXul
         cEcUeiD3vG6qqzsJrPUvb042G3H4rcdF003I5x+BPdjYmwa62G1hN4hzkqYLHK66hKIB
         F+AxsG1oxhCb90ugLh4rI99pMY5hmcHOJgFQNFBE+OTzXBkunzaAsqIoVluIJprgksFa
         wgnP1povA+RBCYc7Nx3E4EG/YgTdRHwqcQpSkvA8QvbCRQyLocv4B5aaxW8/LSq85NJW
         XWkaOK00YImJA6IeCcm5bf3JCjEYFJxoF5QsTjvuJ+7Py0CJ1xM6hUkzduO4Mx/G8HcM
         2x+Q==
X-Gm-Message-State: AOAM530s/w8sIbHbQl6v1udvU3xiOFLDR6znUtlT57RyfcscDaTW87Ji
        UWsFh7+ImiMXQA27mOQSHpZ5ZQ==
X-Google-Smtp-Source: ABdhPJyFM/PKYPzNQH2Lo5rKS4cW/OJY1IuedAKl7NpJWa9TgpNuFMv10CRgNkyrPf1xFt2BAAReVQ==
X-Received: by 2002:a05:6a00:814:b0:40d:563a:a7ce with SMTP id m20-20020a056a00081400b0040d563aa7cemr10118324pfk.60.1631309759677;
        Fri, 10 Sep 2021 14:35:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h16sm5826014pfn.215.2021.09.10.14.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 14:35:59 -0700 (PDT)
Date:   Fri, 10 Sep 2021 21:35:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v4 3/6] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
Message-ID: <YTvPu0REr+Wg3/s3@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-4-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809032925.3548-4-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Zeng Guang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..ee8c5664dc95 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2391,6 +2391,23 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  	return 0;
>  }
>  
> +static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
> +					 u32 msr, u64 *result)
> +{
> +	u64 vmx_msr;
> +	u64 ctl = ctl_min | ctl_opt;
> +
> +	rdmsrl(msr, vmx_msr);
> +	ctl &= vmx_msr; /* bit == 1 means it can be set */
> +
> +	/* Ensure minimum (required) set of control bits are supported. */
> +	if (ctl_min & ~ctl)
> +		return -EIO;
> +
> +	*result = ctl;
> +	return 0;
> +}

More succinctly, since we don't need to force-set bits in the final value:

	u64 allowed1;

	rdmsrl(msr, allowed1);

	/* Ensure minimum (required) set of control bits are supported. */
	if (ctl_min & ~allowed1)
		return -EIO;

	*result = (ctl_min | ctl_opt) & allowed1;
	return 0;

>  static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  				    struct vmx_capability *vmx_cap)
>  {

