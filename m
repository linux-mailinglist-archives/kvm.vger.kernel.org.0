Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2520350A40
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCaW3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 18:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhCaW3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 18:29:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DE0C06175F
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 15:29:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso2033318pjb.4
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQnN7NHkGrBqjYvsj3wUwlnZQNzy2q4PClXlOY6uvRo=;
        b=iMortkY8rwQv5R7gzR0AH0Oxd0HCB4DK5l1TiZ3ve7TnLIFgCiWjIpKP+NloeK+b9O
         zSrISieAwqCV24o3jmvORHzvnF51sh0lGvseB8cKG0ukduU1iViOeOGYm+j8+q7F5Q5g
         tgaOd7p9dRIRqoKb6qQN1etdZwuoSfZZVZmzimuk0ZdUCscdKaJ2Bq7MXY7c12nf+gPg
         uN0Sh1HWip/Zh2/oV3ZFHVciR0KrTXGmPX0BW51K7smQgsodSeA5K4PFuUVMQhicHHhD
         1PO/V6rZhymhCrAU+Sxc/U7WY6h6g4aFVwL5oQdzxtLBBzGAsPrZUPbIoIinHKX44LUt
         he9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQnN7NHkGrBqjYvsj3wUwlnZQNzy2q4PClXlOY6uvRo=;
        b=HMyWELQT6h8sjQS0NdYqXOUwaOW9NYo/llDjbEejeVKaADrtfs0G3lwJMMva1m5JQB
         j85q906fnAwlsYByzdiJeFC75oknMf/XiYp67M9rGywAqb1UHnBMB2Yv1oRJOmds44eN
         1dMYcrhr+4LHvD8NMmZOqFA8bvB6k3dK8QHr65MPUlZ0rrPiMlVBxseA4x4ES3WYN/71
         vkA8W83vBWC03YyXy/KfY0ZsrH2N34wY0InKU/Jm3amtn38eTBWACDIikyzwWPXZUL/U
         lSn/b53NLZFMk8q3stiPb0tEgOdN6agiMuUOO4LvbucjR9c5BrLjYcEfDLCbt3Dog6Vs
         UcPg==
X-Gm-Message-State: AOAM533rA6j3sWO14Z1lGbFwZYsKh6d4eMy15kRPmVLvSEAAsqGXMjTK
        jPoAnjQE1qZTqjunjWAqUqRaZ1Lfz9rrPg==
X-Google-Smtp-Source: ABdhPJyiTBSLw8Alpaud1ZG3omKJVcfMmSNJty1jR3bl8poG6iVDs95yRzpoIBXCxqUqOa62CjHuwQ==
X-Received: by 2002:a17:90a:e656:: with SMTP id ep22mr5325358pjb.60.1617229785114;
        Wed, 31 Mar 2021 15:29:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c6sm3619564pfj.99.2021.03.31.15.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 15:29:44 -0700 (PDT)
Date:   Wed, 31 Mar 2021 22:29:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 13/13] KVM: x86/mmu: Tear down roots in fast invalidation
 thread
Message-ID: <YGT31GoDhVSXlgP4@google.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-14-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331210841.3996155-14-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Ben Gardon wrote:
> ---
>  arch/x86/kvm/mmu/mmu.c     |  6 ++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 74 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.h |  1 +
>  3 files changed, 80 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 49b7097fb55b..22742619698d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5455,6 +5455,12 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	kvm_zap_obsolete_pages(kvm);
>  
>  	write_unlock(&kvm->mmu_lock);
> +
> +	if (is_tdp_mmu_enabled(kvm)) {
> +		read_lock(&kvm->mmu_lock);
> +		kvm_tdp_mmu_zap_all_fast(kvm);

Purely because it exists first, I think we should follow the legacy MMU's
terminology, i.e. kvm_tdp_mmu_zap_obsolete_pages().

> +		read_unlock(&kvm->mmu_lock);
> +	}
>  }
