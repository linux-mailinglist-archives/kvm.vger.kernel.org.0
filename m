Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1F481FD2
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 20:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbhL3TWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 14:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbhL3TWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 14:22:08 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75882C06173E
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:22:08 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r5so22163583pgi.6
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+mUtf+fyGiADPbbqXLfJ2sL02qx3ygRddOMW9sXf8kM=;
        b=qYXQziX8Y4uSkN040i7HBoI+oOa5SoCNkcWtGdUmcaVUSstLVl7gjpPgN9I/OoARfE
         KjkW+I046/rYUv1v3APDx/Orq2Nt9ZeKIp3PRzYwJRd64RpLurzxMkknbVxu0xNDwQDn
         50LTDe0upNYikY2C6vPWerGQDhysdRq+djOm54cB5o4CjtRcotc142F91z0wCYx8bqGk
         XgdYkMz6tAw+U94B+KK7gnXjHlybHc8TRakh8F+8cAd/GXVkXUPLgNxDZ9ZWiwmnlgox
         Hm0QcKqPaNCBggoIZbMN/bpj/y57MIO0Fgkz/Oza03FYClq7Ebcx4RjEeQ0izeTDrPMk
         10Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+mUtf+fyGiADPbbqXLfJ2sL02qx3ygRddOMW9sXf8kM=;
        b=tTrPA9/hlX6epLkdKCROfKiNG84LuKrIZrMVTFrFOQAP4MpRiyVznMX9pVkU0LnW5J
         Tdn1DgbTnI8vPf4ActWs6i6LrXUnyoWdg0BsbpeIJ071wYC7j4e3nN6wkcbrFeadLWkP
         FttbP7QJxGzXRGpp7lu2SfJ53I7qmXBLiMaRLn/nWMiRP0O/Jcuui5zK2TLV+kJycmdw
         9u7q7B+A6z1Z0eBfLuGb+GH/f0cYS0/d1pP1xGn0qKDYDkGTI2PeAXkWyzVTk7ucjPH2
         PpNjQQvR7pPbC1o2R9a/ERSSVQQwX38wAO+AI4JQyI4OjWf+mSUx3gqom577XhSjTfsx
         BE1A==
X-Gm-Message-State: AOAM531o4nQXkjliK7JY3y+oVuJa7QG5uD5FsaZgGm+bQqbYd9byaa8R
        sfnpthShm9EMKE8fhu+28Ulx3w==
X-Google-Smtp-Source: ABdhPJzo2qQot4YYh2sqOX2qDnTi34IfdYiH4bQr7iMKVzwbD0LQ1vHOEabmj42ZSrRvPHU7s6Gubw==
X-Received: by 2002:a62:1dca:0:b0:4ba:cfc4:1af7 with SMTP id d193-20020a621dca000000b004bacfc41af7mr32929296pfd.58.1640892127817;
        Thu, 30 Dec 2021 11:22:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i68sm18735930pfc.151.2021.12.30.11.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 11:22:07 -0800 (PST)
Date:   Thu, 30 Dec 2021 19:22:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <Yc4G23rrSxS59br5@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-5-stevensd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Remove two warnings that require ref counts for pages to be non-zero, as
> mapped pfns from follow_pfn may not have an initialized ref count.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 -------
>  virt/kvm/kvm_main.c    | 2 +-
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0626395ff1d9..7c4c7fededf0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -621,13 +621,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  
>  	pfn = spte_to_pfn(old_spte);
>  
> -	/*
> -	 * KVM does not hold the refcount of the page used by
> -	 * kvm mmu, before reclaiming the page, we should
> -	 * unmap it from mmu first.
> -	 */
> -	WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
> -
>  	if (is_accessed_spte(old_spte))
>  		kvm_set_pfn_accessed(pfn);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 16a8a71f20bf..d81edcb3e107 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -170,7 +170,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
>  	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
>  	 * page_count() is zero to help detect bad usage of this helper.

Stale comment.

>  	 */
> -	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> +	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))

Hrm, I know the whole point of this series is to support pages without an elevated
refcount, but this WARN was extremely helpful in catching several use-after-free
bugs in the TDP MMU.  We talked about burying a slow check behind MMU_WARN_ON, but
that isn't very helpful because no one runs with MMU_WARN_ON, and this is also a
type of check that's most useful if it runs in production.

IIUC, this series explicitly disallows using pfns that have a struct page without
refcounting, and the issue with the WARN here is that kvm_is_zone_device_pfn() is
called by kvm_is_reserved_pfn() before ensure_pfn_ref() rejects problematic pages,
i.e. triggers false positive.

So, can't we preserve the use-after-free benefits of the check by moving it to
where KVM releases the PFN?  I.e.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fbca2e232e94..675b835525fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2904,15 +2904,19 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);

 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
+               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
                SetPageDirty(pfn_to_page(pfn));
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);

 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
+               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
                mark_page_accessed(pfn_to_page(pfn));
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);

In a way, that's even better than the current check as it makes it more obvious
that the WARN is due to a use-after-free.
