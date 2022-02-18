Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754F54BC179
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 22:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiBRVAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 16:00:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiBRVAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 16:00:33 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD03928B601
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 13:00:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x18so3268608pfh.5
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 13:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ppc9rsVLzqVWtK070SvGtZchGh4xpXqU4H0M4qURuO0=;
        b=jkjcJyTXKrFG7Cfpf1oJxu4akk3Y8QK6woOEI7qAS1nykAWpR41q5LM89ZMeQV9k+D
         bi6nfMYXMACrxCGTeZttsnt4hqECI8/N7eSmdIwMBU+8YQ/km4TGdKcy23WSwtw0uEYO
         +8EUrTaNN+hvkPeN3B6Y8784ufGzwgkq2K0L2/+KSYJ4cgVQzMDPDAzJhERmaGUWZVEG
         6qDQ0VTcxMbnDbxrQ5sZtzLqxYNHVhFRPP88x/mmucTHHCWzPXKTWHWxFClFouoqmVjd
         4dxrNHE7nOxuTbKKBbOLKvqxiZbdMpCzX3gMajs7ychKZg4V9U3llxCQh1Hv0OrNavtf
         vs5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ppc9rsVLzqVWtK070SvGtZchGh4xpXqU4H0M4qURuO0=;
        b=EIhhO5re4on6ZVCGXKAPNlL6cCVQQwmdw6a2uS87V6vlDRwaZabhYVP8F5nxk4d87t
         Y+xsqBfn92iMHZ/xu1lyJ5UQw4U6UAQSUMIMNWzFOc6cNGngQPDNY7AXX8wSbAmCnWdR
         zlPq/dwNhBHOZnTXmoL9XGksksc5nSSLEj5hxn0XPRCDeM9IdY72VwrHmGoqv1LwPHwr
         +zfVqRiADdIHwFxptG087Ci+H6Yh7f4kibyP9z73fEWbUBUim14deWcdAHIb8rGOvqGr
         23d8UvPPpcEv3X7awIUeWpre5bLwqyso6p6aqhxTc0zgIWLNSG/2KdMDIxp6NHdgS3Dq
         2RsQ==
X-Gm-Message-State: AOAM532E/H3mdtSzYgiS/u+fgBLTbeTmx+9SWPYsQYrondkX9ChEi4+y
        33n5DJCRwi6dV3EWojnQFK+mWA==
X-Google-Smtp-Source: ABdhPJxFVgpb8w4kSbkk18MqG/QeUI7RyHLKeNkLntUZ/rgT0cBwGdk+DZCu5bMdZoXPiohswop1PQ==
X-Received: by 2002:a05:6a00:218a:b0:4e1:9ed6:c399 with SMTP id h10-20020a056a00218a00b004e19ed6c399mr9276500pfi.8.1645218015002;
        Fri, 18 Feb 2022 13:00:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y23sm3840220pfa.67.2022.02.18.13.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 13:00:14 -0800 (PST)
Date:   Fri, 18 Feb 2022 21:00:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 15/18] KVM: x86/mmu: rename kvm_mmu_new_pgd, introduce
 variant that calls get_guest_pgd
Message-ID: <YhAI2rq9ms+rhFy5@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-16-pbonzini@redhat.com>
 <ae3002da-e931-1e08-7a23-8cd296bf8313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3002da-e931-1e08-7a23-8cd296bf8313@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> On 2/17/22 22:03, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index adcee7c305ca..9800c8883a48 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >   		return 1;
> >   	if (cr3 != kvm_read_cr3(vcpu))
> > -		kvm_mmu_new_pgd(vcpu, cr3);
> > +		kvm_mmu_update_root(vcpu);
> >   	vcpu->arch.cr3 = cr3;
> >   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 
> Uh-oh, this has to become:
> 
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 	if (!is_pae_paging(vcpu))
> 		kvm_mmu_update_root(vcpu);
> 
> The regression would go away after patch 16, but this is more tidy apart
> from having to check is_pae_paging *again*.
> 
> Incremental patch:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index adcee7c305ca..0085e9fba372 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1188,11 +1189,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>  		return 1;
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_update_root(vcpu);
> -
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> +	if (!is_pae_paging(vcpu))
> +		kvm_mmu_update_root(vcpu);
> +
>  	/* Do not call post_set_cr3, we do not get here for confidential guests.  */
> 
> An alternative is to move the vcpu->arch.cr3 update in load_pdptrs.
> Reviewers, let me know if you prefer that, then I'll send v3.

  c) None of the above.

MOV CR3 never requires a new root if TDP is enabled, and the guest_mmu is used if
and only if TDP is enabled.  Even when KVM intercepts CR3 when EPT=1 && URG=0, it
does so only to snapshot vcpu->arch.cr3, there's no need to get a new PGD.

Unless I'm missing something, your original suggestion of checking tdp_enabled is
the way to go.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e0f7f22c6a7..2b02029c63d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1187,7 +1187,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
        if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
                return 1;

-       if (cr3 != kvm_read_cr3(vcpu))
+       if (!tdp_enabled && cr3 != kvm_read_cr3(vcpu))
                kvm_mmu_new_pgd(vcpu, cr3);

        vcpu->arch.cr3 = cr3;


