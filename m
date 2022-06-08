Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768FF5439ED
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiFHRH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiFHRGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:06:18 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D154A923
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 09:54:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d13so2478245plh.13
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 09:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qUhlFxkf4FTCA0hd/E/IFIYzU/3IteIfnN9Zfy6uBDo=;
        b=Rs2MOPYTAanceRkziSjMlGmUpqE3AWozn8nbw/UVuGWbzCPftzijgOB+SOQREUSaLK
         6Q1cM6JvQOE8y/k1Zf7ukZtM+WI7/Rhue0fxeSYsA43H9cACPEaNdEn/OpdWeFvKbyWi
         oLZlfTYMOpnseFBpBefwD6RRrtb1lhknpMHHI1Qs3EkLRr6kkdlpffcxO6uPHw4L7sIA
         P9K+zLwODAhavfBAluz400XOxUUzXV6Vb8xi7gjXSVQqmpKvX5PNKqloubXV+FQbNdpR
         GR6EjlKGTRtXAwVmm4Flv9WEK0epl6Ai8UptsWi9ZT175UPi6nHMIH++YwMjuPVDfa9d
         E3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qUhlFxkf4FTCA0hd/E/IFIYzU/3IteIfnN9Zfy6uBDo=;
        b=Emmtb59fK1F9dYnuVwaa9WbVHhXxxblVKUfpgV6RR8/8D2huhdWNWTbayZuAAoDfZa
         gA8X6SlK5V76JdfTXb4OSBAbieMeDRRLq4UimsBmie19EzzGpsZ+Dhf/n1Y26BZjSGIm
         vdfqtW6O8BIbCw4egpXyiinbCFF121BLt4X0/Dfp9+tbaGK5VRpYmg/diFqAk088s0nG
         k3CqEMcEOJYt5E2Wtz21mWvQ48Ji48fzaUBBfw2MGInNzeid5c73WT1L75R0uvQycoVt
         G1R/OgdhuFw5Se7yz+aWTV6nmeqO99twdW0XkPq9hxrnHnEgAgX1fEXTC6ht4+yJbL01
         IKpA==
X-Gm-Message-State: AOAM532Jezf6OPvYCWfzzzE/LATIqZ8UGwdRZRjAlJBzWE5EUNuSbFdq
        lLsgwiwj562dtp2OUtbFyqWKdA==
X-Google-Smtp-Source: ABdhPJyFjMfXUGoOZoKmLJ5wqO8GeFGq3wMw+W/wLwiBXlfJ8ZTJFRd7D5ltLo89U+TeOdBFWqHVtA==
X-Received: by 2002:a17:90a:17c9:b0:1e8:5e58:f658 with SMTP id q67-20020a17090a17c900b001e85e58f658mr90177pja.239.1654707271877;
        Wed, 08 Jun 2022 09:54:31 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id fa23-20020a17090af0d700b001e2ff3a1221sm14168627pjb.33.2022.06.08.09.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:54:30 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:54:27 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 6/6] KVM: X86/SVM: Use root_level in svm_load_mmu_pgd()
Message-ID: <YqDUQxnDS+qoaJhH@google.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
 <20220605063417.308311-7-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605063417.308311-7-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022 at 02:34:17PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> The caller always call it with root_level = vcpu->arch.mmu->root_role.level.

It'd be helpful to be more specific about the caller. e.g.

  Use root_level in svm_load_mmu_pg() rather that looking up the root
  level in vcpu->arch.mmu->root_role.level. svm_load_mmu_pgd() has only
  one caller, kvm_mmu_load_pgd(), which always passes
  vcpu->arch.mmu->root_role.level as root_level.

  No functional change intended.

> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3b49337998ec..f45d11739314 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3951,7 +3951,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  		hv_track_root_tdp(vcpu, root_hpa);
>  
>  		cr3 = vcpu->arch.cr3;
> -	} else if (vcpu->arch.mmu->root_role.level >= PT64_ROOT_4LEVEL) {
> +	} else if (root_level >= PT64_ROOT_4LEVEL) {
>  		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
>  	} else {
>  		/* PCID in the guest should be impossible with a 32-bit MMU. */
> -- 
> 2.19.1.6.gb485710b
> 
