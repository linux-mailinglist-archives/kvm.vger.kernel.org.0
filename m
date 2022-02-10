Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64E4B1925
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345484AbiBJXLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:11:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345439AbiBJXLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:11:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101EB266C
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:11:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id l9so1577111plg.0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G6h4BaCdrqdbFhFcxIl9IdHmu9enCO1yunXO86W7eOE=;
        b=fgUXjVCC65eMisH+QxSH8aEPf5l9+N39zoxRgxP323KCp0K/cN4FZ6k3tr5ZsSh+gY
         qvRCe1oJbD2vEsRKFX+72ZgpgcM8cejJ16Ux6tPK0Nq74ZJABFaDqqLRtnedeXXuGfLp
         nWj+Kxy0oRzjwL4GHw1oPgh3yrzqk0SGp3PIOUQezPUEHiOmWRbmQs7VhmN+HKSF+wSO
         LYBRr9Mi2q18uxKppIR7mfX0oDxaHBBivZy6pj6OQGLuieVwdhd0l2QeMrinP+0eF7l4
         5F34wcao4dDvj4NMhQns/WvRgc1Oei4MMJwaKKqk3PjqSRQZ5JrI6LvfYtoUmy7NQ4+5
         dyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G6h4BaCdrqdbFhFcxIl9IdHmu9enCO1yunXO86W7eOE=;
        b=TP1ysEJ1iqsJLcHfflr/5wMn+EQ116+HWpc+9PTpbbsKkCCu5PHc2XXnNDb1WyUPip
         Yiribnd+mmqroYD1/5Z3A8eaTwOpjtGYvqOx4Xq1nXZPYSokuSqYEj1Fi8hFwiR+G0ac
         iaC4JiYhg4g7VvXVVrmzUnGo5tTrGl++UnmvXkBwzYMGNnuKh9OJGBXD2HZwtIE4Vcx8
         DmN1/vTwisKrTKXQZbrUiid+OlA1G+/OV4RyxDC8IXDZorOzBd/wGwPjudVBLZ5lBq7q
         +N0HRxGNjR+5T8NmOO0RktqtYeXd/IlyomYhcftKskQ8aYJCoETkWO2AcLMpjgpLlhM0
         +6Iw==
X-Gm-Message-State: AOAM533W91943O6En16b8rAAYxE42MClHiRi/7mC1QKyHZ6sE0d9dueg
        UYD+uMzLv3N8C1DIxaRVolioVUPjBTX+8g==
X-Google-Smtp-Source: ABdhPJz/EaccljVntzlr26C+gJqik/vn3hF52wWE4j4iG6jH0Zzf1GrlbXsuwbU+8ODnz0gG3JAWhg==
X-Received: by 2002:a17:902:680f:: with SMTP id h15mr9858207plk.17.1644534661358;
        Thu, 10 Feb 2022 15:11:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q21sm25673162pfu.104.2022.02.10.15.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:11:00 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:10:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 03/12] KVM: x86: do not deliver asynchronous page faults
 if CR0.PG=0
Message-ID: <YgWbgfSrzAhd97LG@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-4-pbonzini@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> Enabling async page faults is nonsensical if paging is disabled, but
> it is allowed because CR0.PG=0 does not clear the async page fault
> MSR.  Just ignore them and only use the artificial halt state,
> similar to what happens in guest mode if async #PF vmexits are disabled.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e1298aef9e2..98aca0f2af12 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12272,7 +12272,9 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
>  
>  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  {
> -	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> +	if (is_guest_mode(vcpu)
> +	    ? !vcpu->arch.apf.delivery_as_pf_vmexit
> +	    : !is_cr0_pg(vcpu->arch.mmu))

As suggested in the previous patch, is_paging(vcpu).

I find a more tradition if-elif marginally easier to understand the implication
that CR0.PG is L2's CR0 and thus irrelevant if is_guest_mode()==true.  Not a big
deal though.

	if (is_guest_mode(vcpu)) {
		if (!vcpu->arch.apf.delivery_as_pf_vmexit)
			return false;
	} else if (!is_paging(vcpu)) {
		return false;
	}

>  		return false;
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu) ||
> -- 
> 2.31.1
> 
> 
