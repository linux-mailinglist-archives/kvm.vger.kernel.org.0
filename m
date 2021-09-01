Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87303FE50C
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhIAVqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhIAVqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:46:36 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD8C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:45:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 7so875013pfl.10
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSXGTY+JbdvvDZ3iVz3szNk7yWsQ5juNTM8UNa0I5HY=;
        b=iOJguTgfI7Y49ou+2QSfxVWUN+qUbZM92T5KJprLmUT4JRcQ2B5ZhNYeLVK+IFiGce
         sbP3YMsWrEa1x3ld+0Rx3FSshNhBfLH7h8SY5rMBiJDwIokFG1EFgzr3NcxRx+nCBkE3
         Ddt1oYGbHz4rd/fQjglwD2b9q3GhebLWG0hvfQD07Kice4+fegC2IUhMH5g0QSjvrpy2
         ky/UvghuauKjYtifOSlOmh+ewCdQYr/CFoOEgRwFoYgRmDseGePyfGnpmcA5yAnvSbxP
         AVRoPW3l5P6iSuWRGym8l54imtxxiJB8JHokCmsjBi4l1SXKa3EywK/fbLO6hMpBHPR3
         fivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSXGTY+JbdvvDZ3iVz3szNk7yWsQ5juNTM8UNa0I5HY=;
        b=aSomXsouPIhEMXAXoOMHFZP1RgifLBF1oyYEtxNmHil8fAoeAB9fb6mQSWCrJYZyHC
         IJ8KEpBL36/vg3gO+UVi3wotst38nke3JMCiZQlCY66hR+TbkHsrt59N0/szLYHm2VN/
         Vw5yiUPcaTPOP/uNrkd7PqO8DmsGsYV/ijE/IVlj0sihd3aA/3dSX/ePoyh/xj/DpI8j
         yNKGTjH4ZIxeOBHimkildH0+TKSr/J2CJHk4pk2J5kNB1MGW7Rfrt6Q52KvDVQkY+xDL
         DlT4tP9nVIlWw9gBt7/2LFemGBREpyWcz1bGOylMdq1Hq5KB6xLjvowg7hAQbaY/gRuh
         ztGw==
X-Gm-Message-State: AOAM533V5kyuu18KyUFYuo/gxlkMYWi1AD+9R49cPkO/2fPMKTpikbMI
        Y4NvEXcFeI0nWdPCqDFvra+ZiA==
X-Google-Smtp-Source: ABdhPJxqCPYMnf14dYD413H0wg7Hve3pCUiL5XI0sQEuitsB8Jjel3mMPEsoPu0r2pA+On6512q4Zg==
X-Received: by 2002:a62:a20d:0:b029:35b:73da:dc8d with SMTP id m13-20020a62a20d0000b029035b73dadc8dmr31695pff.54.1630532738568;
        Wed, 01 Sep 2021 14:45:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m21sm387659pfa.137.2021.09.01.14.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:45:37 -0700 (PDT)
Date:   Wed, 1 Sep 2021 21:45:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2 2/4] KVM: SVM: Add support to handle AP reset MSR
 protocol
Message-ID: <YS/0fnLXTPDnRfVQ@google.com>
References: <20210722115245.16084-1-joro@8bytes.org>
 <20210722115245.16084-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722115245.16084-3-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021, Joerg Roedel wrote:
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 8540972cad04..04470aab421b 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -11,6 +11,7 @@
>  #define GHCB_MSR_INFO_POS		0
>  #define GHCB_DATA_LOW			12
>  #define GHCB_MSR_INFO_MASK		(BIT_ULL(GHCB_DATA_LOW) - 1)
> +#define GHCB_DATA_MASK			GENMASK_ULL(51, 0)

Note used in this patch, not sure if it's intended to be used in GHCB_DATA below?

>  #define GHCB_DATA(v)			\
>  	(((unsigned long)(v) & ~GHCB_MSR_INFO_MASK) >> GHCB_DATA_LOW)
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e322676039f4..5a28f223a9a8 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -164,7 +164,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u8 reserved_sw[32];
>  };
>  
> -

Unrelated whitespace change.

>  #define TLB_CONTROL_DO_NOTHING 0
>  #define TLB_CONTROL_FLUSH_ALL_ASID 1
>  #define TLB_CONTROL_FLUSH_ASID 3
