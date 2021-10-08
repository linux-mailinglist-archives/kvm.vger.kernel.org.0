Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61EF427467
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 01:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhJHX4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 19:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243798AbhJHX4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 19:56:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB8AC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 16:54:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q19so8954952pfl.4
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 16:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PmBMkf/9MZygw8Ouxh+j3hhE+5/43pTB38Kda0mWNWk=;
        b=Q8+7oCfDRKyVdU+VWTY4DGVlelzEpUO576a488pAZuBDyvKQ2jt66NRvKJ2w/7C/OU
         7eYMe4aQa6LzT+CJ5azuMdAf8HlGeJPYlZxe2cHRHvovOiqXGen5NBxB2UciexWuKAAM
         7YzG8hOfoF5vttQ8N9pXyHBIOsrZVqrwMTO0Te3GQyWDTaDL5n7FuVufW1Zp6KDueQjD
         kVXea3sEewOg6KkQVGQDiDImLphgkIkPJpKFqM6Dt6riFthcuPkxDfDdPBSGfR/j7dwj
         hqL5Mwok31auNybg9V/xQ17BAMtG5322AUhMxs3ZE0l/JjgDqwbxGW/DDMS82YgE0g9L
         0UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PmBMkf/9MZygw8Ouxh+j3hhE+5/43pTB38Kda0mWNWk=;
        b=XZ8a4+Y/Z4gYcqslLBVeGU9lYh+GDvXF/4KHuWNLOBsb1C6yKuUjzN3QBI5r5YeM2r
         WVhrKHs2Vw09MdSkQdZ5egPsKyTDc4jKFDLkjMk6Rl89O6Rf0BqYbTkiSqxIKcdG1ysr
         aA0a2qs6RhyMkySktDjrqI66sCt5GJqbX0V7qD46sEhvPpZhv7+Elab8NXAg/xMyhbyo
         xKm4zbKjk5Gp9EttoYUGkahwGTgJumWLcr/nErMVUtb4oPbNNCq77sRs8KsyS+Hc7pPX
         32jVbwTth/xjTWDac1aSBYCSmVP13SD/Aen8ZkP570Y22c27hqP6eZU9lww+mzXahiaX
         IB+g==
X-Gm-Message-State: AOAM532owXveUU110AX7dGsUX8mjufZBZp48fNY/JCIVxwuBP0zZASTQ
        NggRtStM8nswHUzsNgJHL0zRPQ==
X-Google-Smtp-Source: ABdhPJzTO5dzrqoKxYIAgLORXxVoCs/hswW5V+qdRbtzVa1AywA2Mc6hF2P8Y2NMkbNFKLtRna+ilw==
X-Received: by 2002:a05:6a00:1a02:b0:446:d18c:8e7e with SMTP id g2-20020a056a001a0200b00446d18c8e7emr12873540pfv.46.1633737277253;
        Fri, 08 Oct 2021 16:54:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p21sm12455665pjo.26.2021.10.08.16.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 16:54:36 -0700 (PDT)
Date:   Fri, 8 Oct 2021 23:54:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: nVMX: Track whether changes in L0 require
 MSR bitmap for L2 to be rebuilt
Message-ID: <YWDaOf/10znebx5S@google.com>
References: <20211004161029.641155-1-vkuznets@redhat.com>
 <20211004161029.641155-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004161029.641155-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021, Vitaly Kuznetsov wrote:
> Introduce a flag to keep track of whether MSR bitmap for L2 needs to be
> rebuilt due to changes in MSR bitmap for L1 or switching to a different
> L2. This information will be used for Enlightened MSR Bitmap feature for
> Hyper-V guests.
> 
> Note, setting msr_bitmap_changed to 'true' from set_current_vmptr() is
> not really needed for Enlightened MSR Bitmap as the feature can only
> be used in conjunction with Enlightened VMCS but let's keep tracking
> information complete, it's cheap and in the future similar PV feature can
> easily be implemented for KVM on KVM too.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 592217fd7d92..eb7a1697bec2 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -148,6 +148,12 @@ struct nested_vmx {
>  	bool need_vmcs12_to_shadow_sync;
>  	bool dirty_vmcs12;
>  
> +	/*
> +	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
> +	 * changes in MSR bitmap for L1 or switching to a different L2.
> +	 */
> +	bool msr_bitmap_changed;

This is misleading, and arguably wrong.  It's only accurate when used in conjuction
with a paravirt L1 that states if a VMCS has a dirty MSR bitmap.  E.g. this flag
will be wrong if L1 changes the address of the bitmap in the VMCS, and it's
obviously wrong if L1 changes the MSR bitmap itself.

The changelog kind of covers that, but those details will be completely lost to
readers of the code.

Would it be illegal from KVM to simply clear the CLEAN bit in the eVMCS at the
appropriate points?

> +
>  	/*
>  	 * Indicates lazily loaded guest state has not yet been decached from
>  	 * vmcs02.
> -- 
> 2.31.1
> 
