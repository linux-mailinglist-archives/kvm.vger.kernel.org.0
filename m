Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8C45D2DE
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhKYCHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbhKYCDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A246C0619F8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:36:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso4385662pjb.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HOt85BfxSlV5GXvxKtcWgjD3gRgwpXfjtS+6ThmOzHE=;
        b=O6w66VyVhk+zXXkMfKfH8NisEYSJodgEssOfSkIpDEA72SfnpwuEgftePGmP0Kk33t
         xSGsG3IvcDv4t7JJjfzX4H8wT3l48Shf2HuAXijDTyZEo7I6UAZQdD9sUMwJN9ZnSbU6
         /vmUxbmlwCXtDHoQ9dz88xb3ytwkCBrnHqBEp4I2h1U3Sqssch8hwSS+aBoBtlDICqTa
         JbRJUL2eqf+YHP1vvU2v/zpRHO0tLWdhre0oNtGkGXLwYqvrs28vkm8hQutjmo3oxGWc
         bwZmNtI7RQDDaNEorrI8LfsUv59DVMcZ/h04/Lr0e0r3pIs4tQybq6E/wXc4sEi5G/K2
         3I3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HOt85BfxSlV5GXvxKtcWgjD3gRgwpXfjtS+6ThmOzHE=;
        b=DHlPsSkm6bSjhGTFK5MusEFm1hVrehyu5nv9jD3Xbk1BQejwpzMHeVaykFAwGti0+b
         xFYP7yLgYS8CR0vCQuK2NyWs8dKnngMxh1QNblgjeaosPUgf+52VnWiwWlsSmRZB7wDM
         i/KA3pktGTsUvvvbghhQGfDoNXjYwQJiiM9QzvHP+aEHfHRhXI8+FZXdmFe0AUjyeQFN
         egRnuFtOXBOMW0jI50Ek18nwT6XPiAuiw+Ki+1tC+JfkfeQmIYqV5gjLp5zz/K6I0l9k
         Ph72DNTAgX3HuzI8uxOFEStpU0oIYxPrhKzJCu/NqmkoI7ofr6afTutJv+RqBF591r6q
         8E/Q==
X-Gm-Message-State: AOAM532TQkK7ABtFj7XMsi9XiAOgvc4MHpS/7pqK7KyUNjXoWJbox0vD
        mSvjELC6FRKPQByIrmS+CwK6M/UAmY53+g==
X-Google-Smtp-Source: ABdhPJxVjY+RWIfwp+ii6F+rHTlVxmUNKTiBOlfJ3A9CQO/FbiXZ56+mX/vGQqSpGvlIzvS3bYE1/w==
X-Received: by 2002:a17:90b:3b83:: with SMTP id pc3mr2249963pjb.106.1637804218645;
        Wed, 24 Nov 2021 17:36:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q6sm1041434pfk.144.2021.11.24.17.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:36:58 -0800 (PST)
Date:   Thu, 25 Nov 2021 01:36:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: ignore APICv if LAPIC is not enabled
Message-ID: <YZ7otljGYQ/4UP99@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> Synchronize the condition for the two calls to kvm_x86_sync_pir_to_irr.
> The one in the reenter-guest fast path invoked the callback
> unconditionally even if LAPIC is disabled.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a403d92833f..441f4769173e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9849,7 +9849,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;
>  
> -		if (vcpu->arch.apicv_active)
> +		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)

Ooooh, lapic _enabled_, not just present.  That took me far too long to read...

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
> -- 
> 2.27.0
> 
> 
