Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2580481FD8
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 20:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhL3T04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 14:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhL3T0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 14:26:54 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5576EC06173E
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:26:54 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so28768377pjo.5
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZUph+1LIEWHwkUrkggqde2R87m4Flj/r9dmdwLX5Gk=;
        b=YjPirROoPg13DarDjbdzx+b6JXQsjXJAroXjMUwNDC76kjIF6C1cS8keBNKHMwtVRz
         ISz7aWmvSYfhUT0/mv+fQimuFcM7IpQYiGSj5GneQoSRXJf27E+/a7kX/zz7OILY+ohR
         KvvILQ1tJEBcxhfEfb4Sze3gNLGOdNBvx2AM7nRMVaOKJ6zXjhHHSmfR5Ea/RkSYkONc
         Vv5TuUD92KHd0ioNQnac3ovtQjfZUOUlYaj5MyVEagQy5v7ICbkHPQwcB/friSppUclP
         moI5YE9d9gjNvOeLdaVxqsBZYX+6aAerSR+/sdxPKQZlefucqnMpLtkqSkdgP7uOLynp
         C4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZUph+1LIEWHwkUrkggqde2R87m4Flj/r9dmdwLX5Gk=;
        b=opraKhi1efJc1dXzHjIWLWrQmELQtMggKCx9jQuJPtksMN+UXK6E/PXsfkiOYbGunH
         jVw6pzhZZq8O5DiTxDPboJxzQxIXWHlhjTEy++wQzUVgpeEXlPL8bWcNhnZHsr1eREOQ
         6jkjaRySwhlSGvzNMj8ETx6iGJhjk+rIxdR6BxPQc6J1Rit+Eek8dseZJ9HK0XzSX1w4
         kzrfeg65ME/kUe099j5bTvuk5jNBVVePPX61be/3L2p+92PCWyt+8jPyLipFGk+Axdgb
         +QlJbedroY0o7D/um9OInXN6glQ1TlaMkqVyN/PXQ1u05ypR4ZHomWSUDkctMpKdFoDU
         NE6A==
X-Gm-Message-State: AOAM530RTjt+ZR0KEaUnDIFuXa6j3Iew9MESqWaJyCmc+cug6VhFiK6T
        Klz/JxZPCKJfEnZxVknzS1VQoA==
X-Google-Smtp-Source: ABdhPJy75H5vqTjoxkUn2lk86SVP6fu7EF2sx90j7RLzIByICIqLM9zp/fNPB/CyaOJtZQ2wXQ2z2A==
X-Received: by 2002:a17:902:ab53:b0:149:7902:bc8f with SMTP id ij19-20020a170902ab5300b001497902bc8fmr22576921plb.85.1640892413370;
        Thu, 30 Dec 2021 11:26:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u71sm23209813pgd.68.2021.12.30.11.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 11:26:52 -0800 (PST)
Date:   Thu, 30 Dec 2021 19:26:49 +0000
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
Subject: Re: [PATCH v5 1/4] KVM: mmu: introduce new gfn_to_pfn_page functions
Message-ID: <Yc4H+dGfK83BaGpC@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-2-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-2-stevensd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, David Stevens wrote:
> +static kvm_pfn_t ensure_pfn_ref(struct page *page, kvm_pfn_t pfn)

"ensure" is rather misleading as that implies this is _just_ an assertion, but
that's not true since it elevates the refcount.  Maybe kvm_try_get_page_ref()?

> +{
> +	if (page || is_error_pfn(pfn))

A comment above here would be very helpful.  It's easy to overlook the "page"
check and think that KVM is double-counting pages.  E.g.

	/* If @page is valid, KVM already has a reference to the pfn/page. */

That would tie in nicely with the kvm_try_get_page_ref() name too.

> +		return pfn;
> +
> +	/*
> +	 * If we're here, a pfn resolved by hva_to_pfn_remapped is
> +	 * going to be returned to something that ultimately calls
> +	 * kvm_release_pfn_clean, so the refcount needs to be bumped if
> +	 * the pfn isn't a reserved pfn.
> +	 *
> +	 * Whoever called remap_pfn_range is also going to call e.g.
> +	 * unmap_mapping_range before the underlying pages are freed,
> +	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
> +	 */
> +	if (kvm_is_reserved_pfn(pfn) ||
> +	    get_page_unless_zero(pfn_to_page(pfn)))
> +		return pfn;
> +
> +	return KVM_PFN_ERR_FAULT;
> +}
