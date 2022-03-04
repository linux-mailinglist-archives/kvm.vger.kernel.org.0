Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB94CCB3F
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 02:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbiCDBU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 20:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbiCDBU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 20:20:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000E817B0F6
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 17:19:39 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so9334242pjb.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 17:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zEb5gJN0p3jp2prcQ3AxOX7oDu5JWoQts+UVDKAduE4=;
        b=W2B6Ck7YTcny7/5+zKdTiimZp2p9fdpezDQbNjt0oIfSoVxXTpdJGnk8L8e9MTUqwB
         3gFzJjDJjyvW2GKsZLjwiGCrBbmfaPJzyEcPvhTDp7L4tTWEZc+Df7uC/yQtRkjyShLW
         GdTEGLqtdP/Zf5dDDhAD0FueSuMAFNJgd/bOtzE8daeam60uok4eGAeMZmEjuB355hZQ
         8zS94v/ZFNklD/gVc6M870bWsiv8VzGlsHoDBc/YhrwWUGj6g2/3JIzDx8qGt+UCGaW2
         Zr7h3T0vDzCJyckeMysXYMQt8cSKIyGAE0zqVkRIjtJX6byDEsp1GdloqwxcEs8wT+j6
         b4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zEb5gJN0p3jp2prcQ3AxOX7oDu5JWoQts+UVDKAduE4=;
        b=SfRvc5iHhJo1O6pty5pCiQ0Y7QUD54e0eczCi06t1mg3EqmEy0nH0Xirq3hW/j45dl
         2IA0P094zAaMfDYwT+Avv5ANbpVviYDLxJ8M+YgOn3rrNGgqGXvs3d9uNbmqtow/WKeG
         A2dV+vHOtnVvoHosCYH5Xboh+9FjfaPKkXsu6N9+My/73VmqfqSoNxfNdzki2KOaoQ19
         i1OqmbphWO3E+tp30XiZx2jJEN/oX9IM2q9VK3sH97HFZeuKCy18ijpAxcWHVW9IOgQU
         Sk6Zt9G5Uz6bWVyj5gIGbxBh8ATADiF/sVqPXFjeOeSRu/ufsFCYkMj6+YvuJxOjxEQX
         E5Zw==
X-Gm-Message-State: AOAM533v3nQamJLjAPZMNB1JAR90uY0L5SLyRVTKlIndUggyb6zMJsdA
        Bu7DL2N3TzWv4by7kcZC1k/Hjg==
X-Google-Smtp-Source: ABdhPJxzTz4pCEAh/l2V8XyzIwJXG5GRoE/ggM+ag3wUzlFXLIMu8qRnbVsUEia+MJuDOCYwqazwzg==
X-Received: by 2002:a17:902:e889:b0:14f:c4bc:677b with SMTP id w9-20020a170902e88900b0014fc4bc677bmr39377392plg.68.1646356779252;
        Thu, 03 Mar 2022 17:19:39 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id k17-20020a056a00135100b004f3a9a477d0sm3709376pfu.110.2022.03.03.17.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 17:19:38 -0800 (PST)
Date:   Fri, 4 Mar 2022 01:19:35 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 19/30] KVM: x86/mmu: Do remote TLB flush before
 dropping RCU in TDP MMU resched
Message-ID: <YiFpJ8+fNtfEu3oO@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-20-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-20-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When yielding in the TDP MMU iterator, service any pending TLB flush
> before dropping RCU protections in anticipation of using the caller's RCU
> "lock" as a proxy for vCPUs in the guest.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-19-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c71debdbc732..3a866fcb5ea9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -716,11 +716,11 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
>  		return false;
>  
>  	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> -		rcu_read_unlock();
> -
>  		if (flush)
>  			kvm_flush_remote_tlbs(kvm);
>  
> +		rcu_read_unlock();
> +
>  		if (shared)
>  			cond_resched_rwlock_read(&kvm->mmu_lock);
>  		else
> -- 
> 2.31.1
> 
> 
