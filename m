Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D32F2EC236
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbhAFR2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbhAFR2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:28:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D02C06134C
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 09:27:41 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a188so2071455pfa.11
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 09:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ddIsLnymnErAx74Eb0083K50LpcPXAZmPlKKKyZRFNc=;
        b=sYp3yeJ/vECyORk4qtnuBtIuz3Q25kiLlBv1sr+EGYBTh/19P+hiNN1thnm1XAeuuY
         DTHz8arumfVh3C1LT2ooxMJBnQXbD1hZtFDpnGlPxf2M3J6RFt/WZvCDcJA2Aq1OwUQj
         oBvxjeMPYYhhESk1TsnKHfXgkivrkIiKcrB4hIG9VNklb1oM6nWJRMSp9QAdskZ1iPxn
         jpic2qd/+/Rer+YR5klM2JxYCDin3ZRjRicVJPznUy6NfNXbYUHbDc9ViRzwOKc3RaoU
         nPKaR3s3r285CyaQO/pVBFE2VkJNoo1FLXaA/Z418G55dKWdGxsmnhrQcRerWHxDI0J2
         OWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ddIsLnymnErAx74Eb0083K50LpcPXAZmPlKKKyZRFNc=;
        b=K6t82iAQYPJ5SQuz7hEbRbPGUuYK+24XiN+iuwlSL2bpuiL2Q2kd3eFZIjhvoneZHK
         lDmICnjyUn7gS9lNgxLWbqXeB5PBrS14vKV43sciB0bv/jME2PHxT6QsIpmz9T8vKkd8
         9WNF0B8YCpIXcckccmMZxr6+0ObiExu7x5CGFnEEGcFp0RC+7/2ts6q9q9lNgdivgnvV
         HlLz+R4o+/39Ssd9gNT+pJiOyxi9vU8m1KxfmpZcAlmLupbMZfEkYlFRt8iJqmAoUC9R
         TtRMUEBgBvnoKkK77S0h3qP5Demr8UZ92SM7dVXagO4zCHhuV0QFZlAaGiDM1Kz0pGlo
         rXzA==
X-Gm-Message-State: AOAM5303PpWHENUgFjhkbb2X8tH/qCDFwYSzNetT2qmL2SkHeN0QgFPq
        qhD9owp2Ha3iYioE8EDq7Nah6w==
X-Google-Smtp-Source: ABdhPJztuC6feaacDs75zozia7HHmTRPpVZ/wT2H7Hsr86n5N+EoNkgPtNLkirgB6ZJXropuOTHO6w==
X-Received: by 2002:a62:fc4f:0:b029:19d:d060:27ca with SMTP id e76-20020a62fc4f0000b029019dd06027camr4767377pfh.66.1609954060855;
        Wed, 06 Jan 2021 09:27:40 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id mr7sm2742201pjb.31.2021.01.06.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:27:40 -0800 (PST)
Date:   Wed, 6 Jan 2021 09:27:33 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 4/6] KVM: nSVM: correctly restore nested_run_pending on
 migration
Message-ID: <X/XzBUTPRhwVPCGx@google.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
 <20210106105001.449974-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106105001.449974-5-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> The code to store it on the migration exists, but no code was restoring it.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6208d3a5a3fdb..c1a3d0e996add 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1203,6 +1203,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * in the registers, the save area of the nested state instead
>  	 * contains saved L1 state.
>  	 */
> +
> +	if (kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING)
> +		svm->nested.nested_run_pending = true;

This should be:

	svm->nested.nested_run_pending =
		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);

> +
>  	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
>  	hsave->save = *save;
>  
> -- 
> 2.26.2
> 
