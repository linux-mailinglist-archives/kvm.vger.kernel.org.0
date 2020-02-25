Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2A16C3BF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgBYOVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:21:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730478AbgBYOVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:21:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582640510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hVSqx3EzAvWE7ZUmVL6oGFZVbwypZGJIj1KXOM4Izws=;
        b=aQkzqVrGK6RBFDyZ2Vtzz6n3AxKchTg0PpkbTlFyFfHpIoaACIKRiPK5WH2bztRK2xu8C0
        dkPQ+BCqN0AMBC26LXvIRvkor6lg/ay4rnuKPXNm0/eAYE7N5LhqFMwq7iEmDYwbQ3+GbA
        qCRLL8sITgdzSE4JocmE+CMyHExU70U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-_P_9tnyOOdi4JyswXvXyDA-1; Tue, 25 Feb 2020 09:21:48 -0500
X-MC-Unique: _P_9tnyOOdi4JyswXvXyDA-1
Received: by mail-wm1-f71.google.com with SMTP id n17so1101625wmk.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:21:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hVSqx3EzAvWE7ZUmVL6oGFZVbwypZGJIj1KXOM4Izws=;
        b=VzEII7g17Z3ymEeM5IJmesjsN3X5sU/DQHA6VpTRjnIMqdEF6fOg2PS2hH+2goRXCc
         1ILdK4mbffeU3eF4ss/z3FpenCfSJhhiW052d3tyNqNWYkLva2zM6kAtZ/6tDucublMo
         nPyeqs4TPKJY8dj7SHlOMm2JdV0g186a0tIfD6fT2Imf3P8bHOktcCQETlTMcI5N+Rx3
         to/r7jGSRZznqHHSDHyrguUCVCOIaWrTOO7qgfL2nzfXG8AUljY63fECg4PGscsvoe4I
         mRqY360HzzDVpWTR/lJKO/shu5CA6kqm0GsXNWaKHVt3gNJr5WL1Ya7uGsOeyRpPEnmO
         x7qQ==
X-Gm-Message-State: APjAAAUfmX9mdskx462KmeNWChgZb0442kA1loC0mQa6PhTblofrnwTI
        Ge7Asa97wqvUpDmz6zH6DsOwZXYpX0pQV6HJqaRWMu2b+4RSRkqmVEko2tHz/Rp8AgrZyYBJLGu
        MGaP0h/lL4XCB
X-Received: by 2002:a5d:5347:: with SMTP id t7mr72977038wrv.401.1582640507473;
        Tue, 25 Feb 2020 06:21:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZKH29/qzb/cUfFg4C2u8+Ed5dlfSDFPx6sbZ+diRIwyPfeca/Urx5e36yoK+eLMn+VpDe+Q==
X-Received: by 2002:a5d:5347:: with SMTP id t7mr72977022wrv.401.1582640507243;
        Tue, 25 Feb 2020 06:21:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v131sm4551825wme.23.2020.02.25.06.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:21:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 56/61] KVM: SVM: Refactor logging of NPT enabled/disabled
In-Reply-To: <20200201185218.24473-57-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-57-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 15:21:45 +0100
Message-ID: <87h7zelpc6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Tweak SVM's logging of NPT enabled/disabled to handle the logging in a
> single pr_info() in preparation for merging kvm_enable_tdp() and
> kvm_disable_tdp() into a single function.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a27f83f7521c..80962c1eea8f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1440,16 +1440,14 @@ static __init int svm_hardware_setup(void)
>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>  		npt_enabled = false;
>  
> -	if (npt_enabled && !npt) {
> -		printk(KERN_INFO "kvm: Nested Paging disabled\n");
> +	if (npt_enabled && !npt)
>  		npt_enabled = false;
> -	}
>  
> -	if (npt_enabled) {
> -		printk(KERN_INFO "kvm: Nested Paging enabled\n");
> +	if (npt_enabled)
>  		kvm_enable_tdp();
> -	} else
> +	else
>  		kvm_disable_tdp();
> +	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
>  	if (nrips) {
>  		if (!boot_cpu_has(X86_FEATURE_NRIPS))

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

