Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECACE4BC319
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiBRX5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 18:57:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiBRX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 18:57:42 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8395A8A305
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:57:25 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s16so9140323pgs.13
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RDMp4k3c0UgW7Xo+ygoRLLYEkiKw3xZ8wcdtVyJ0vL4=;
        b=aLwMZPFKdGqQqiVIoUumDK/EfPQcSCX0ubaVlaDy+i8xaLI8jwmhPi8oKXzG/HRo6/
         uTtDas0XVNazaKieivDWatWIrHVsRM7qY2zgKVy0M7hmmI35w8ME10D+lAW7qhBhgGWP
         m+Dxvh9JAYfefpU8QTlZLwRIQzg+Zqk6WfUILdcrnePSxhuIw7Wuu3BzQuqdZj2soCxT
         le2wK7AQWoZCB1thij/Uvz/M1nKCdVCj3UmXrDJncVU8hP2APjZg9vH2EXUGShQt1+G7
         yXD5IzD/ksPazA7+ePtbV2DiU1zEG9t3ITh9g1CRkPlQSe7xemzEN/853j5Vhgzi4+rC
         gEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RDMp4k3c0UgW7Xo+ygoRLLYEkiKw3xZ8wcdtVyJ0vL4=;
        b=ajrJhMhbcu7iTJ64smV1KOH96bXbExZ6cpfXOrDCeKTvwK4IOSAhZW+RWgT80MGZ15
         9nzBlEbYfbnDivtkitRwUmjgcedWp6Ze1EJfHq4rsrZC5U7uC/lbtF8nAcHBtDZqpw/t
         XXN4WcI2O53oElp5wLtMAiEDxdqQ3v6zoL8Nrp/ijmscJVn03r1BbdtymE5rqBuMw/le
         pJCtGez/cNfSGyGubOZWP57YGfGD5hj5cipN1Mn6TlJm6Zy9PG/lionSi5fGOsTu4W54
         QdPIyHIeAZKEmYBGW0UxTEpUN4xfDGubK4EKa5Zu3sR56Jg6nyz/bnPrlFZN0AWl6fAn
         gfnA==
X-Gm-Message-State: AOAM532g/yh7ZDJnJ5naMJZvp1t6GtoLw29Plr68Hikfp2U6gsanoipO
        O6TBPXL61HxaB2YRim39pVdmVg==
X-Google-Smtp-Source: ABdhPJwmiG0Fo0cO3tyL7yYnQBUJyceU6pggtmEI9bajV5eb9gMQ2wDCIYtv2DhRFZL26muKP4+sVg==
X-Received: by 2002:a63:ce44:0:b0:36c:d02:1f52 with SMTP id r4-20020a63ce44000000b0036c0d021f52mr8132996pgi.142.1645228644714;
        Fri, 18 Feb 2022 15:57:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j12sm11424343pgf.63.2022.02.18.15.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:57:23 -0800 (PST)
Date:   Fri, 18 Feb 2022 23:57:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 17/18] KVM: x86: flush TLB separately from MMU reset
Message-ID: <YhAyX+Bc3x4+ZMTG@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-18-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-18-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> For both CR0 and CR4, disassociate the TLB flush logic from the
> MMU role logic.  Instead  of relying on kvm_mmu_reset_context() being
> a superset of various TLB flushes (which is not necessarily going to
> be the case in the future), always call it if the role changes
> but also set the various TLB flush requests according to what is
> in the manual.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Code is good, a few nits on comments.

Reviewed-by: Sean Christopherson <seanjc@google.com>

> @@ -1057,28 +1064,41 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
>  
>  void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
>  {
> +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> +		kvm_mmu_reset_context(vcpu);
> +
>  	/*
> -	 * If any role bit is changed, the MMU needs to be reset.
> -	 *
> -	 * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
>  	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
>  	 * according to the SDM; however, stale prev_roots could be reused
>  	 * incorrectly in the future after a MOV to CR3 with NOFLUSH=1, so we
> -	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
> -	 * is slow, but changing CR4.PCIDE is a rare case.
> -	 *
> -	 * If CR4.PGE is changed, the guest TLB must be flushed.
> -	 *
> -	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
> -	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
> -	 * the usage of "else if".
> +	 * free them all.  This is *not* a superset of KVM_REQ_TLB_FLUSH_GUEST
> +	 * or KVM_REQ_TLB_FLUSH_CURRENT, because the hardware TLB is not flushed,
> +	 * so fall through.
>  	 */
> -	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> -		kvm_mmu_reset_context(vcpu);
> -	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
> +	if (!tdp_enabled &&
> +	    (cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE))
>  		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> -	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
> -		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +
> +	/*
> +	 * The TLB has to be flushed for all PCIDs on:
> +	 * - CR4.PCIDE changed from 1 to 0

Uber nit, grammatically this should use "a ... change", not "changed".  And I
think it's worth calling out that the flush is architecturally required.
Something like this, though I don't like using "conditions" to describe the
cases (can't think of a bette word, obviously).

	/*
	 * A TLB flush for all PCIDs is architecturally required if any of the
	 * following conditions is true:
	 * - CR4.PCIDE is changed from 1 to 0
	 * - CR4.PGE is toggled
	 */

> +	 * - any change to CR4.PGE
> +	 *
> +	 * This is a superset of KVM_REQ_TLB_FLUSH_CURRENT.
> +	 */
> +	if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
> +	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> +		 kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +
> +	/*
> +	 * The TLB has to be flushed for the current PCID on:
> +	 * - CR4.SMEP changed from 0 to 1
> +	 * - any change to CR4.PAE
> +	 */

Same nit plus "architecturally required" feedback fo rthis one.

> +	else if (((cr4 ^ old_cr4) & X86_CR4_PAE) ||
> +		 ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP)))
> +		 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +
>  }
>  EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
>  
> @@ -11323,15 +11343,17 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	static_call(kvm_x86_update_exception_bitmap)(vcpu);
>  
>  	/*
> -	 * Reset the MMU context if paging was enabled prior to INIT (which is
> +	 * A TLB flush is needed if paging was enabled prior to INIT (which is

I appreciate the cleverness in changing only a single like, but I think both
pieces warrant a mention.  How 'bout this, to squeak by with two lines?

	/*
	 * Reset the MMU and flush the TLB if paging was enabled (INIT only, as
	 * CR0 is currently guaranteed to be '0' prior to RESET).  Unlike the

>  	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
>  	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
>  	 * checked because it is unconditionally cleared on INIT and all other
>  	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
>  	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
>  	 */
> -	if (old_cr0 & X86_CR0_PG)
> +	if (old_cr0 & X86_CR0_PG) {
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  		kvm_mmu_reset_context(vcpu);
> +	}
>  
>  	/*
>  	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
> -- 
> 2.31.1
