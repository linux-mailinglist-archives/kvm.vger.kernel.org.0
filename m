Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F182EC285
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbhAFRkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbhAFRkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:40:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58401C061357
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 09:39:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m5so1960121pjv.5
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 09:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JB9eBKwugieyvVYnROgQV33nRx5Ezd0zGuWZ1MxZ+00=;
        b=M7F6iPMRv7yQVRaqHighcWPIyU+EJ4RvBfdtC/zzG6nvOHBiHYsv0dcOKk8SE68gVl
         GaBELTp9c1IyXpwUhj1Mm0I2v1v1lSetjca/CKIu3+q8gIFM0f8Ycv4Isp13SKYV0Zr3
         6asTFSK2rrteBl9vCahuobDbDU+3ersgm1O0/41FSjJzLI4ZuF5P5hkXGp71bzbOYld+
         OidJWoUJW8dt9KDiFcrmSHR5Aq3LL59i0Upk1lyapqu/7C7TbGK3gUi16Jti1TQc5nWS
         7b0Zpek1Gb4cpd3UzDkJa/Jt/Fhl3JBrmsFpE893uVD/2DLbL9DJrT4cCuTiRzdoh/cG
         4bcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JB9eBKwugieyvVYnROgQV33nRx5Ezd0zGuWZ1MxZ+00=;
        b=U/N7SUhsFGjl7KLJTEs9WvxTJ2KblouCQDHUxPJlOxwMx4LO8jQNswOnlGZjnxxP42
         2RMi0Fu08fJtDEXggMPIfhRBfT86GH+EQgWsoIH1uNW+y+RvcKEOzd5hnYTcvbfT8BtV
         guapIwYFe+nhDsbAo1UZ7nO5m9lbgO0VNabHnB8MHasDJaRRbnrsSchjsqlKj5F5UVG+
         v1yQdVoyGDtU/pDs8aH7ymQJSpG1pi6M4xOCUtfJm8HojhS06C8ToC0qLu8VyTQNhhBc
         UOWpUr7gzZoWHaeGFug/4h6JsTztBiYUwbgJ6nB9r4jVfmC3IPhI1UNsmczDQO3JY+tC
         ixBw==
X-Gm-Message-State: AOAM53241MilF79i2/mVA06e4a0bRvrKPyiWkFYCjqsPwZ2Ki+l6U0y8
        dSjdAeKbcUOd4uzmswMEvTXa/kK0UNjKfw==
X-Google-Smtp-Source: ABdhPJyT2Va77bLKQa4ople2oKSi6VdtXGUHflfljgDURhltLU4au73sQMMdf6yt7uGjKFLcjvZ2QA==
X-Received: by 2002:a17:90a:454e:: with SMTP id r14mr5397851pjm.194.1609954790483;
        Wed, 06 Jan 2021 09:39:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id cl23sm2702244pjb.23.2021.01.06.09.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:39:49 -0800 (PST)
Date:   Wed, 6 Jan 2021 09:39:43 -0800
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
Subject: Re: [PATCH 5/6] KVM: nSVM: always leave the nested state first on
 KVM_SET_NESTED_STATE
Message-ID: <X/X13wD58Oi/0XpX@google.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
 <20210106105001.449974-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106105001.449974-6-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> This should prevent bad things from happening if the user calls the
> KVM_SET_NESTED_STATE twice.

This doesn't exactly inspire confidence, nor does it provide much help to
readers that don't already know why KVM should "leave nested" before processing
the rest of kvm_state.

> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c1a3d0e996add..3aa18016832d0 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1154,8 +1154,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
>  		return -EINVAL;
>  
> +	svm_leave_nested(svm);

nVMX sets a really bad example in that it does vmx_leave_nested(), and many
other things, long before it has vetted the incoming state.  That's not the end
of the word as the caller is likely going to exit if this ioctl() fails, but it
would be nice to avoid such behavior with nSVM, especially since it appears to
be trivially easy to do svm_leave_nested() iff the ioctl() will succeed.

> +
>  	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
> -		svm_leave_nested(svm);
>  		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>  		return 0;
>  	}
> -- 
> 2.26.2
> 
