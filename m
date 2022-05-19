Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F08652DA7C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiESQoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiESQn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:43:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABE15AEC9
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:43:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m12so5300691plb.4
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=221Yw0kf0kWHOuKCBmfC/ycEQMuPJsFgC9zSqVTAwSA=;
        b=bu8vQ+GWvqJrRdEuq8YVrsfud1b3bQhlBNIuRQm9N4t2Lj3E7ojrr5du8GpLJyVQpt
         zI6LAgP0cWVNyhkC2dx8jWx3d1dzS6qKn2apfQz90gm0zn8LV2J6jLUuu+darR0d5jp1
         LpTWI9ig8g7I0oCfkW8terjt+U3QuRwraIIgfyUbQlX7hnu3WzrJLPVhPL16qrotB7X8
         X0sGHQiLnxPwCuwzmOoubt1yCoAYcRgt5bbtFh+Kh0gFthhZS04NdGml6wCRoLPw4YTT
         8exX0VVLnNWqt0NnU9LMNUK3s3E1Z3IQqSxPNndBTJ1hO64zu+VRfQofIL4ohxv4FNRK
         FrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=221Yw0kf0kWHOuKCBmfC/ycEQMuPJsFgC9zSqVTAwSA=;
        b=VOyIO+t0zNgGBFqMwYIiAV941b6flxwHdn+ZSwfmWcJxs7Qzbq2JyeIO1Duv8QaHm+
         8pvMAOdGNqofPrZh5APVBadiYZddh8ovN07OG2dKGzcD4euVejvFTI6vOIZU2w288dau
         aqVLYURz5x0YwThxEAbzl88DP22ySbbW7HNlGy+620poZ9oZ/n2TKkkoc4PZxuu3zVFy
         Q7mZ9CbfnX4Azpxoti8mk3XnSa3MYH5dMNtx1vjYfSPtDIZaTo8KXf5Edrczp73LqT4v
         5zHqSGNK+HAb+tJteDURVWHIT3UYBozgzkNjYuOoebZW3gM9tYdHd31iknJFtZBouNRo
         Ti8A==
X-Gm-Message-State: AOAM531fd70nauXIN3+9EkBo6L1EcoX3gviC45lGasbG61v/A96Ej9s7
        VVnP4GDGNVE0bB4idjwt0Dlg1XxLyangVw==
X-Google-Smtp-Source: ABdhPJw2CROjZjF/tfI3pH/231wqbGMtrzoTlXEZCDadRe7+Y7fJupSq7bjozl06CSrvxLG1Gs7+EA==
X-Received: by 2002:a17:902:b289:b0:161:872d:6f03 with SMTP id u9-20020a170902b28900b00161872d6f03mr5698065plr.30.1652978635790;
        Thu, 19 May 2022 09:43:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id jh9-20020a170903328900b0015e8d4eb1f8sm4027559plb.66.2022.05.19.09.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:43:55 -0700 (PDT)
Date:   Thu, 19 May 2022 16:43:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 06/19] KVM: x86: mmu: add gfn_in_memslot helper
Message-ID: <YoZzx6f1XBWL3i8F@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-7-mlevitsk@redhat.com>
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

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> This is a tiny refactoring, and can be useful to check
> if a GPA/GFN is within a memslot a bit more cleanly.

This doesn't explain the actual motivation, which is to use the new helper from
arch code.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  include/linux/kvm_host.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 252ee4a61b58b..12e261559070b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1580,6 +1580,13 @@ int kvm_request_irq_source_id(struct kvm *kvm);
>  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
>  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>  
> +
> +static inline bool gfn_in_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	return (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages);
> +}
> +

Spurious newline.

> +
>  /*
>   * Returns a pointer to the memslot if it contains gfn.
>   * Otherwise returns NULL.
> @@ -1590,12 +1597,13 @@ try_get_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
>  	if (!slot)
>  		return NULL;
>  
> -	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
> +	if (gfn_in_memslot(slot, gfn))
>  		return slot;
>  	else
>  		return NULL;

At this point, maybe:

	if (!slot || !gfn_in_memslot(slot, gfn))
		return NULL;

	return slot;

>  }
>  
> +
>  /*
>   * Returns a pointer to the memslot that contains gfn. Otherwise returns NULL.
>   *
> -- 
> 2.26.3
> 
