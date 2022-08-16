Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66854596623
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 01:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiHPXpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 19:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236643AbiHPXpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 19:45:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0533291D0F
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 16:45:15 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so2178849pjz.1
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 16:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=T8Wd5ecB9QDTm6Zwnt9WBgEsFx0O5umnw625jWHrX/M=;
        b=jumeSEYxVa1d9kq7i5FFS4qyMGOZkNP0043rIjIqRE3Vugi8nADSvyvpmv3f1SvV5Y
         eIWNRT4/oHQZ8V9HHSEjEBd/Sui40yeXHtlb5JS5tB2nCSB2F6r+pVMiXXXXHulkDarn
         Z4rsOg7u4h/dG6fFXX9RtjtI40Slm6UulsbB/8Z6IYqv2gNOez8PhJ4G10/WdyrK+7yK
         25juHiVzZNSBYfzjdikFcVDPhGAaQs/KVum4Rco1DRXvx2x1vj09a1TQfRl6WIMNbznT
         FrkKJpxO8r+ywD5UC4+KWiYIoqJhc8i1SaN1burCu2r/nCF0IoEq366ud58eY3AueX7l
         3cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=T8Wd5ecB9QDTm6Zwnt9WBgEsFx0O5umnw625jWHrX/M=;
        b=qPpP+mHfWwSSX4vmXWBnHW5DKM/O/Gr1TDRn40F5K5FYErW2J0KM8lI+Yek/mJjtvF
         iOm1UIpHt6tB4753c7g5ADdTg1ynUnaZcuHcTYg3y5AJuRN6nOKyFVE3ueDHDmgWWHaz
         tk5vgBriPfiaEClPMPugqH7BsKtGhr4T3LJyfgSS6uuAXk/T9Djrpk2hOnAntmyLu2v5
         r2+dCXQ5nlG26RttiMqqE48TaRy6frrzG+EhYdcnIvo4HW1AWrwPeYiip2Mx5g0sxlC+
         PHJHq4KLBIHpfsxlYpJQRNW7sAwUzdgfKiEs9wxMmrp5GT9epeKn9L23F6YwWBHdyMag
         B3Qw==
X-Gm-Message-State: ACgBeo2b2tpaRkoqDSgaMG8n3ZI0f3MBmhaXiGWn1HeLJqdw9NiN+dnQ
        sRCB8o8LEBm57ibZUhoX7Rod4d1tZS3WaQ==
X-Google-Smtp-Source: AA6agR76/9iHZUvxlYJRUAl4HHUCIQebjkGRgwgIoQ3QmecE2Cr0/B8jZ0or2nfgmiWsyUzwV3wXNQ==
X-Received: by 2002:a17:902:f68f:b0:171:55f0:9062 with SMTP id l15-20020a170902f68f00b0017155f09062mr23600649plg.18.1660693512929;
        Tue, 16 Aug 2022 16:45:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x29-20020aa7941d000000b00525343b5047sm8971175pfo.76.2022.08.16.16.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 16:45:12 -0700 (PDT)
Date:   Tue, 16 Aug 2022 23:45:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 9/9] KVM: x86: never write to memory from
 kvm_vcpu_check_block
Message-ID: <YvwsBC2HqodxaYRJ@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811210605.402337-10-pbonzini@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
> it cannot sleep.  Writing to guest memory is therefore forbidden, but it
> can happen on AMD processors if kvm_check_nested_events() causes a vmexit.
> 
> Fortunately, all events that are caught by kvm_check_nested_events() are
> also recognized by kvm_vcpu_has_events() through vendor callbacks such as
> kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
> remove the call and postpone the actual processing to vcpu_block().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e9358ea112b..9226fd536783 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10639,6 +10639,17 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  			return 1;
>  	}
>  
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * Evaluate nested events before exiting the halted state.
> +		 * This allows the halt state to be recorded properly in
> +		 * the VMCS12's activity state field (AMD does not have
> +		 * a similar field and a vmexit always causes a spurious
> +		 * wakeup from HLT).
> +		 */
> +		kvm_check_nested_events(vcpu);

Formatting nit, I'd prefer the block comment go above the if-statement, that way
we avoiding debating whether or not the technically-unnecessary braces align with
kernel/KVM style, and it doesn't have to wrap as aggressively.

And s/vmexit/VM-Exit while I'm nitpicking.

	/*
	 * Evaluate nested events before exiting the halted state.  This allows
	 * the halt state to be recorded properly in the VMCS12's activity
	 * state field (AMD does not have a similar field and a VM-Exit always
	 * causes a spurious wakeup from HLT).
	 */
	if (is_guest_mode(vcpu))
		kvm_check_nested_events(vcpu);

Side topic, the AMD behavior is a bug report waiting to happen.  I know of at least
one customer failure that was root caused to a KVM bug where KVM caused a spurious
wakeup.  To be fair, the guest workload was being stupid (execute HLT on vCPU and
then effectively unmap its code by doing kexec), but it's still an unpleasant gap :-(
