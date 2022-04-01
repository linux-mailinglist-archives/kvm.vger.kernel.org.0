Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D6E4EEEC3
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346268AbiDAOGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346503AbiDAOGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:06:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E7492D1F
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:04:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f10so2542939plr.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ucv1GhW8n0nffIVAqwQW+4kQjGqiGk4YkR9GX1DvEsc=;
        b=MIrHnCeFbGOfpivtgisoY5HXpgz6Q5VL9xHBd/dPaYsRwhrs50kmiCRdY89OdvBYRZ
         F3V8IKQQyIeBrypQXH5M0QoXaTdSSKWUBc++Iy9beGHg807nb9pdvncodhoQBonOhPDb
         9yIf1S5eW+PrU7/pB+Wt7kjfFKYCCtYFNX6t/tikx0W89iGIsCgwELEU9YPoKMLHuE1U
         HEQQgMdXcMkmkg79835gk0gaX/ZuFy6zCKw5p7Kz7TxrSeDIz1BUrFfMSlgEkJH1JDYI
         yiqGVXlaiem5BE2UfJBdAX7NprjiKvBz6/0ZmKfIsotOF2o0SDDhSg+rPA9br5/m/1/c
         c93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ucv1GhW8n0nffIVAqwQW+4kQjGqiGk4YkR9GX1DvEsc=;
        b=hLRB0AWY4xw3W1anzdBULXRG5lz2ScNs14vhvzQhZ56GQXk1xRK9gIvCO1s5Lb/+Ya
         kCmhovbyDjXPq8uImQk7wkLtmmSbcUNh1pq0667qeFCmxuE6lzCGJOuIrL/7gEyl187X
         5omP/d5f44RQAaC4HBmYRKFIo8rsirkICmkgRlYK8jiicoMpeanlKTilPmXeOSJ6mSwt
         rwy5PoLjwEn572h2Q8sXERap/8nynZ8eNWLsstzu0KFr6xFq83frSzH5/vaf87ejksI3
         zOYj672iELoWEKVt44VkyMdg+soDdcqKMuYMoKfqzZK/1NyKlC0yTuBPgzd2BrGy0T/W
         EAEQ==
X-Gm-Message-State: AOAM531ui7VlP0I6Pri+icG/HPTn2n+ZYvyTToaeastjR82JsQSJYiUw
        gjpGYhX+cpmzqVND0XOC4wkGKg==
X-Google-Smtp-Source: ABdhPJwESG5OVr0BG3gSD4dSk1bo0d33fp8l727aMxWsQBm5ROkAmBlmQGdAK9cq3ps2vPOHpYgn3w==
X-Received: by 2002:a17:90a:628b:b0:1c6:a410:d73f with SMTP id d11-20020a17090a628b00b001c6a410d73fmr12299042pjj.96.1648821888825;
        Fri, 01 Apr 2022 07:04:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y11-20020aa793cb000000b004fb597d85b2sm3225176pff.160.2022.04.01.07.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:04:48 -0700 (PDT)
Date:   Fri, 1 Apr 2022 14:04:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: fix an IS_ERR() vs NULL bug
Message-ID: <YkcGfMNjaayttqtC@google.com>
References: <20220401100147.GA29786@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401100147.GA29786@kili>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, Dan Carpenter wrote:
> The alloc_workqueue() function does not return error pointers, it
> returns NULL on error.  Update the check accordingly.
> 
> Fixes: 1a3320dd2939 ("KVM: MMU: propagate alloc_workqueue failure")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Obviously, I noticed that the patch says "propagate alloc_workqueue
> failure" so that's a puzzling thing.  Merge issue perhaps?  In
> linux-next it alloc_workqueue() returns NULL.

No merge issue, just a goof.  The "propagate" patch was added because KVM neglected
to check for allocation failure, so at least it was a step in the right direction :-)

>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a2f9a34a0168..d71d177ae6b8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -22,8 +22,8 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  		return 0;
>  
>  	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> -	if (IS_ERR(wq))
> -		return PTR_ERR(wq);
> +	if (!wq)
> +		return -ENOMEM;
>  
>  	/* This should not be changed for the lifetime of the VM. */
>  	kvm->arch.tdp_mmu_enabled = true;
> -- 

Paolo, any objection to also returning '0' in all non-error paths?  There's no
need to return whether or not the TDP MMU is enabled since that's handled locally,
and the "return 1" is rather odd.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dbf46dd98618..dec32b4a13aa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5779,7 +5779,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
        spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);

        r = kvm_mmu_init_tdp_mmu(kvm);
-       if (r < 0)
+       if (r)
                return r;

        node->track_write = kvm_mmu_pte_write;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2f9a34a0168..3a60b999e1aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -31,7 +31,7 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
        spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
        INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
        kvm->arch.tdp_mmu_zap_wq = wq;
-       return 1;
+       return 0;
 }

 /* Arbitrarily returns true so that this may be used in if statements. */
