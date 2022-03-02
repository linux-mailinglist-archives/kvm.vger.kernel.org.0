Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A43F4CAF0B
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiCBTu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiCBTu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:50:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3366D887B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:50:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e2so2478670pls.10
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lKk3x8uXXjQyBVKUKuzhJBJZvtvNO106582p6u2NXrQ=;
        b=qPmZtH8mC9Mer8Naw7XSShiYWujI0J3vVPBJ/6dwQB4LyhA5u35peVR+FBq1ELY2IR
         +Cx++8ZLYtMKXKQV14ldIpbynCLAsbmV8Ru+4d1aoZBUgXHe2xLI32h1Y1K7od2DdCRx
         u13TXaE4PIa8dFW7h+dBaan/ZeioxcWzhKQpw3rfBXqZmM6KtqkVNliFjl4MNz8iVbU4
         qCvIVARH1cn29hoc6QbH6OfEOnVtNoSiWX2jCnc0iNY2U/V0hvV831YnCUMqCkLBMijz
         z4Br0RgRDOdtR7P2N5CpVkuozPQisNtcpoQ5NS/xKwSdJHpGmCqK9qnOqpRyafP5kNuX
         5keA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lKk3x8uXXjQyBVKUKuzhJBJZvtvNO106582p6u2NXrQ=;
        b=vJH7Sc7fI9ezNBTK92bAXtnghZWNBkgAAEgLXRqhQ9l8xv8EPxddwG5lSaZS6SOG3o
         CVVx8CVee/5IxCLjLx8Mifr06OqmPEdjIZtQwF5PyAafe/+K/GxbksH/yJ6H3EEuoG4A
         HuyMm7jQAAMfS/gVIvT8/NdPB1bZdLCeR+hdjLhHSsy8mRgbGJNpa1nmkawUrRD8P3i9
         DjFbnfrtQJztD0vgRJfQisamFx+Ofak3apEtYUJq9NLwuFeF/LTktpjmr+weypHsyIUX
         gKW1EVZrNtRzDhiA4nZMizDkDQr0lna7rATYCrTs3BeMF2wC3SqFlZVPtRKkIO5gtBmd
         1GCA==
X-Gm-Message-State: AOAM531aFqGkJWmMQAh43DmdZg2QEEu7KuK1fLIbPyFu+lOzzk6uhbXh
        2m7SHSiMlLj82pFhDk1ZVeVnZNTW+otor47Q
X-Google-Smtp-Source: ABdhPJyYNWFPT4igHZjd7zFnxDV0bSj59lBtVcBFxUip3++YhrRSCJhw3q9qoiVR+tVlOgLjHQ9VGA==
X-Received: by 2002:a17:90a:6508:b0:1be:d59c:1f10 with SMTP id i8-20020a17090a650800b001bed59c1f10mr1412919pjj.229.1646250613939;
        Wed, 02 Mar 2022 11:50:13 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00170200b004e0f0c0e13esm21500641pfc.66.2022.03.02.11.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:50:13 -0800 (PST)
Date:   Wed, 2 Mar 2022 19:50:09 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 02/28] KVM: x86/mmu: Check for present SPTE when
 clearing dirty bit in TDP MMU
Message-ID: <Yh/Kcawg0NIjUA+5@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-3-seanjc@google.com>
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

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Explicitly check for present SPTEs when clearing dirty bits in the TDP
> MMU.  This isn't strictly required for correctness, as setting the dirty
> bit in a defunct SPTE will not change the SPTE from !PRESENT to PRESENT.
> However, the guarded MMU_WARN_ON() in spte_ad_need_write_protect() would
> complain if anyone actually turned on KVM's MMU debugging.
> 
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 25148e8b711d..9357780ec28f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1446,6 +1446,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
>  
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
>  		if (spte_ad_need_write_protect(iter.old_spte)) {
>  			if (is_writable_pte(iter.old_spte))
>  				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
