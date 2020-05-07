Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B861C9B0A
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 21:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgEGT2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 15:28:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47502 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGT2P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 15:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588879694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9obrI+I5ySmag9Pa2ybFm1Lh3tAlP9Wg1QXo7JHVYM=;
        b=Y3o3rbnzf7mPu1EQGYeWPRg1C8Qgz/rSHXPkgwL7jAj31/VK0oZmaqzU5MjekJi4vJNXVq
        tt7WX+7kF+bIZL/Z1OlkeJenZibv4kW9AVA3HClgbaLfUfNS2PIdJa4UvaYaqfwJnO4boX
        C0W2QQaqUE+Bl+EJqrHw0kHN/uh3WYw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-4nUX-NZFPX6Q-IpIkK96Gw-1; Thu, 07 May 2020 15:28:12 -0400
X-MC-Unique: 4nUX-NZFPX6Q-IpIkK96Gw-1
Received: by mail-qv1-f71.google.com with SMTP id fe18so6882511qvb.11
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 12:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t9obrI+I5ySmag9Pa2ybFm1Lh3tAlP9Wg1QXo7JHVYM=;
        b=HnA9OUZcMn8V1Winx9BOYdkYtctR7cfUb0CuFz//B4COuYXGdrH6Ezcbp1MNgLDXFA
         PLQbWVTiaxQDgWKVlbc8GGcvFBj8FE7M6/y0btyOjFZhQpykvg4ncXS2CquAlhyQZ3QS
         X0UF5kirR23rWlJi2XL9r5O291AgDpMDqzlaU29lGCl/laLiVGDw3tcSPw0qK3XqTTeT
         7aCiq4AS/Tc+ZshQu7M4ROxnTniAsgKWOCMXpQrBCJSQqRLlNa8Yc90I7QKSiPw+sQqD
         O6SgcF/uxQJJOfUBirr6xA76t1gR4HeMpOZTP2Cz8j1GyXYlXkjbK5g7GUpaYXrjlXLr
         6l6g==
X-Gm-Message-State: AGi0Puav/OdP4VVwNrX/WuFJFvlxdYtY+b7gmBMNC4OY5JBbG7LRmXi9
        BKfl/FClDBC0+RO/4y89AlJv9y7woSJdceUXceOyhmJXFI3fnk7zkXEOhfbNLGIUSzGPbRpfu+U
        itj7+q/78VrOt
X-Received: by 2002:ac8:27b4:: with SMTP id w49mr11286825qtw.111.1588879691165;
        Thu, 07 May 2020 12:28:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypJpH33jmgoLRBXKHI5mRYHl+RR5ikyN0bvOn1bz5L/I4wON5UkdlgUfdaK8Jrk2hZUurzzYGQ==
X-Received: by 2002:ac8:27b4:: with SMTP id w49mr11286802qtw.111.1588879690866;
        Thu, 07 May 2020 12:28:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id q6sm5111564qte.72.2020.05.07.12.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 12:28:09 -0700 (PDT)
Date:   Thu, 7 May 2020 15:28:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from
 vmcb->save.dr6
Message-ID: <20200507192808.GK228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507115011.494562-9-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 07:50:10AM -0400, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 1a547e3ac0e5..9a2a62e5afeb 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -633,10 +633,18 @@ static int nested_svm_intercept_db(struct vcpu_svm *svm)
>  
>  reflected_db:
>  	/*
> -	 * Synchronize guest DR6 here just like in db_interception; it will
> -	 * be moved into the nested VMCB by nested_svm_vmexit.
> +	 * Synchronize guest DR6 here just like in kvm_deliver_exception_payload;
> +	 * it will be moved into the nested VMCB by nested_svm_vmexit.  Once
> +	 * exceptions will be moved to svm_check_nested_events, all this stuff
> +	 * will just go away and we could just return NESTED_EXIT_HOST
> +	 * unconditionally.  db_interception will queue the exception, which
> +	 * will be processed by svm_check_nested_events if a nested vmexit is
> +	 * required, and we will just use kvm_deliver_exception_payload to copy
> +	 * the payload to DR6 before vmexit.
>  	 */
> -	svm->vcpu.arch.dr6 = dr6;
> +	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
> +	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
> +	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;

I failed to figure out what the above calculation is going to do...  E.g., I
think the old "BT|BS|BD" bits in the old arch.dr6 cache will be leftover even
if none of them is set in save.dr6, while we shouldn't?

Thanks,

-- 
Peter Xu

