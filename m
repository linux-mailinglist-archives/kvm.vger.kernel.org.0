Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1235E32C6A1
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449257AbhCDA3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbhCCR1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:27:22 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF9EC061762
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 09:26:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id ba1so14428167plb.1
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 09:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EK8LKNqmhy5x5LGHLejHKmLyx1MsPWviMZPTqKPSEvc=;
        b=JAljs/qnOK5jykvYwB6CxVcKXYmcriiOHnXg+2p/0p+pr1G9jTezxPcXNnfUkuF0u6
         K/gVGL85aHy4UOB9QVbFAJgBq9wGhyEJjMXDjn1Df1LlYWauOVLOuKG6nuERLGdqtrv2
         2VBT4jEcYz4L1TaZTN0gkWkq9IXNMUX83aTipLspLO2xUxVy6SdyO2uxyzAIpx1W+Gjy
         hmoD8h3c8uNaGjUMGQPyqOxkravbrA43rCMhX8jabm4CDuqT6Pxa3Y2c9CEAONqGI8fz
         A0hibh7eoiujKp4rxdjoJ61sXj9OfgRvu0qgsZe2FwMJSkSBDC4DyZAVPen/txEjeohY
         FE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EK8LKNqmhy5x5LGHLejHKmLyx1MsPWviMZPTqKPSEvc=;
        b=C5Utlppj+068yTfbHeczxJKJV1JTh3HOCGbNH4OW+GfjH8+C98FXZI7d+zg8VTfS7S
         zG9GTCYi+yp/cTZ5hn0i+wcO2MigsaiKF9LF58Qipr/k+ptoHqYceBcCJ2HM5mZ10Wqz
         PJJ/21hr0yTAGjRrS54iXBkuOyrsOAB9UaJYjI/B5VHxm19TSIgNy20fPyDVEbnL9b3X
         asi/h8FIU6uGVhKAMxzyBJ1fA+UuvpTk7VNXsYkbZLXBFG/pfCkDq5vxGeLBlnmFnS24
         exc2Oz3AwFcaXn4TcfmiarZXgjixWJ/RxoFhC5u+qQptIedlVvz4LwAkI1pjLbfak3Yk
         6C8A==
X-Gm-Message-State: AOAM533o+5A6y/SsG22OYfmWO5TRDVekUeXcnaSd0DjxuMYh+/vRU/Za
        F5FDA/Cdo2sPJrmR2HfMyWU1JQ==
X-Google-Smtp-Source: ABdhPJzelju/P4Sadau5toHeUSN3iJ90+g+CrjUu7odQYNHUelH7VSCksC5Fy/t8qpf0EFPUkGkJWg==
X-Received: by 2002:a17:902:f68c:b029:e5:ca30:8657 with SMTP id l12-20020a170902f68cb02900e5ca308657mr251635plg.78.1614792372514;
        Wed, 03 Mar 2021 09:26:12 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id v26sm24500719pff.195.2021.03.03.09.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 09:26:11 -0800 (PST)
Date:   Wed, 3 Mar 2021 09:26:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS
 field
Message-ID: <YD/GrQAl1NMPHXFj@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303135756.1546253-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Like Xu wrote:
> New VMX controls bits for Arch LBR are added. When bit 21 in vmentry_ctrl
> is set, VM entry will write the value from the "Guest IA32_LBR_CTL" guest
> state field to IA32_LBR_CTL. When bit 26 in vmexit_ctrl is set, VM exit
> will clear IA32_LBR_CTL after the value has been saved to the "Guest
> IA32_LBR_CTL" guest state field.

...

> @@ -2529,7 +2532,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_EXIT_LOAD_IA32_EFER |
>  	      VM_EXIT_CLEAR_BNDCFGS |
>  	      VM_EXIT_PT_CONCEAL_PIP |
> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> +	      VM_EXIT_CLEAR_IA32_LBR_CTL;

So, how does MSR_ARCH_LBR_CTL get restored on the host?  What if the host wants
to keep _its_ LBR recording active while the guest is running?

>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>  				&_vmexit_control) < 0)
>  		return -EIO;
> @@ -2553,7 +2557,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_ENTRY_LOAD_IA32_EFER |
>  	      VM_ENTRY_LOAD_BNDCFGS |
>  	      VM_ENTRY_PT_CONCEAL_PIP |
> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
> +	      VM_ENTRY_LOAD_IA32_LBR_CTL;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>  				&_vmentry_control) < 0)
>  		return -EIO;
> -- 
> 2.29.2
> 
