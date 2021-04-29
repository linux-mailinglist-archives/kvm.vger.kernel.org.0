Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2332036EE62
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbhD2QuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhD2QuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:50:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AC7C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:49:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e2so30756659plh.8
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t7wrCkg5HzcpryaSEY8CDFceJToXQ1Z7NajGX4H6Qvs=;
        b=DVWO+c+DRCdT+xgySkQyrrUeVdkg5lBQIomJGZyyLPXiFiM6g2ZGls9Zvf+QBfamZ9
         OUo/OLAWe2ZBkGvQZHyo/qR14GvWrZ9/oH7wEaTqEmtnFHcnF01rsHDHL5CzhsQiGd/v
         qiamOHcTLEn+gW6uzWCYq5Vb/HvJHs4Fb+IGdM16jfz54KaKFujHv4n2F4TRV4zi26cz
         zmmtxYxkpVR9T2jnib5zPmGpKfHyns4bKbydHRcf0IrFlo9iXMlAhAvXndAk+A7E1Tcq
         o1zkUGGQY9b3Cwlfd7CKS8moi5OMkqLHeuslUO1dmapvt9Zqv/dq0wXuZM8uqNoTztUG
         g03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t7wrCkg5HzcpryaSEY8CDFceJToXQ1Z7NajGX4H6Qvs=;
        b=YlywvcJ0xvtljVSNDucAkTDUGtsy3u368UHjEEm4Rc77xPo0jwsA+RyobxJkLB/DaB
         /Z4zEze/D6Nf3h0BujqTHJSkIt5KDtJl/vZl4zhhnfsDEKizlJIDH/FZnr7P5C4daHbm
         fr0sFQUAYggpGKst3YzehgiI0UEK+hb2zOeScoi/sTfmWAVYWdCnLHzzv+G68wFSvt4z
         stWKxylcREYDBxlA+n2D0mgz+MiXHhZ858OwmwaY6KnGiLN0lA0yBjH89/LdkMLe/YR+
         djg5544yBJX4ioZIqkMZjURyGotHqgXXrDDGH+La2ztYQICwIkOmY4sF1eGTE6LUaOW3
         aqgA==
X-Gm-Message-State: AOAM531pQ6WGCreCFsrsA4p3x5vLykU2MQwo/eunvjVoKNNkdVo9uEOb
        xDIXiYWiycmu8NXq5Ne4G2/nNu91hECPdQ==
X-Google-Smtp-Source: ABdhPJzHQAAP8FLIwNhJZWsPjs5hoRIVnncHAndcMvMe2Z6Y8mNKECypv4RRdm0Mag16K7dAbs5tpg==
X-Received: by 2002:a17:902:c3ca:b029:ea:fc69:b6ed with SMTP id j10-20020a170902c3cab02900eafc69b6edmr522207plj.80.1619714957365;
        Thu, 29 Apr 2021 09:49:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k4sm423627pgm.73.2021.04.29.09.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 09:49:16 -0700 (PDT)
Date:   Thu, 29 Apr 2021 16:49:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Szczepanek, Bartosz" <bsz@amazon.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Message-ID: <YIrjiXja3/5e6frs@google.com>
References: <1619700409955.15104@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619700409955.15104@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Shahin, Md Shahadat Hossain wrote:
> Large pages not being created properly may result in increased memory
> access time. The 'lpages' kvm stat used to keep track of the current
> number of large pages in the system, but with TDP MMU enabled the stat
> is not showing the correct number.
> 
> This patch extends the lpages counter to cover the TDP case.
> 
> Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
> Cc: Bartosz Szczepanek <bsz@amazon.de>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 34207b874886..1e2a3cb33568 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -425,6 +425,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  
>  	if (old_spte == new_spte)
>  		return;
> +	
> +	if (is_large_pte(old_spte))
> +		--kvm->stat.lpages;
> +	
> +	if (is_large_pte(new_spte))
> +		++kvm->stat.lpages;

Hrm, kvm->stat.lpages could get corrupted when __handle_changed_spte() is called
under read lock, e.g. if multiple vCPUs are faulting in memory.
