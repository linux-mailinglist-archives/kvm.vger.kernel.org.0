Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95C48590C
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 20:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbiAETUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 14:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243499AbiAETTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 14:19:50 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2571C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 11:19:49 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id q3so230105pfs.7
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 11:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qoub34JKMYw80YSVF2J+hWLmoHzppRyhKwTIl4ud58A=;
        b=eJrm9vSQlYbjzA48SXuyQTX4vpv+0waa/m6b4+CGvv+TU/vaqalx+wW2nsSxEQ/9vt
         A1suumBCxyzaCyNgn32IdqREfwZqOk/nXRQaoAh5CC60NGExeXlyi31EGxNmYxTQEX4E
         sQifAS+vZypu+S3JY78d2kp/YnmHYIUm5hak6fwjzowpaKSAXq5lBDIqAjzDrUlgI6lA
         KZYptrb10ts7MYcBXTd91Zphk5IkT12dQBvNVkTmAySlUziWKC75l3HxKYPl617awyGC
         o8+l5yF/ne1DrgpDW61L5Cb9yCX34IVOYNXYh6PnfvMZk7x3F7tG0p/lLsdCZ42dXxXJ
         EFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qoub34JKMYw80YSVF2J+hWLmoHzppRyhKwTIl4ud58A=;
        b=fJPVy5gs6opbqe9HFC32QZepERkPPhcvrbYVNg8xCrarnG314xhzRRXFcIFDEu7/Kk
         jNKfiTmCXChOOQ+8sI07PQzgf5rNPn2ozUuK3zeJDTq/RSniT8i/8zm0F26rb7+DXTSh
         dF7aajX8FcvNJCpvfbcKqTtJYNmkuVTKIJbBz9T9vI0xAHSYmIafaqjA7YK49S6dcl04
         MXyD8secZrJXt0if0q6lEkgUXSI5LtUBl7hAoCJ2tGe7rnYA0S7YZjK+DkHLmqQjB3Wc
         HubHp7u3rzpmj7HJPrEEGGoXnbFusKq/Jp6vPCDauqf3Fkxzd1J9KJ4wZRpY+x+qum6l
         0TmQ==
X-Gm-Message-State: AOAM532gATWB5Ew3yCC+4Yg+Nm5u2HwldcmsaLMxj5zUxjd8zn8S1fz7
        jc7E2Ikpj7KuqvSNyS/5if6CzQ==
X-Google-Smtp-Source: ABdhPJxye1sjvjOvj00utsHDdoqYNY5iCIYZuac2xNc6/XTpseq2jJOALu2rGleR4A8aeXodNqfdiQ==
X-Received: by 2002:a63:1422:: with SMTP id u34mr49958790pgl.135.1641410389102;
        Wed, 05 Jan 2022 11:19:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a17sm3400933pjs.23.2022.01.05.11.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:19:48 -0800 (PST)
Date:   Wed, 5 Jan 2022 19:19:45 +0000
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
Message-ID: <YdXvUaBUvaRPsv6m@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdXrURHO/R82puD4@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Sean Christopherson wrote:
> Ah, I got royally confused by ensure_pfn_ref()'s comment
> 
>   * Certain IO or PFNMAP mappings can be backed with valid
>   * struct pages, but be allocated without refcounting e.g.,
>   * tail pages of non-compound higher order allocations, which
>   * would then underflow the refcount when the caller does the
>   * required put_page. Don't allow those pages here.
>                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> that doesn't apply here because kvm_faultin_pfn() uses the low level
> __gfn_to_pfn_page_memslot().

On fifth thought, I think this is wrong and doomed to fail.  By mapping these pages
into the guest, KVM is effectively saying it supports these pages.  But if the guest
uses the corresponding gfns for an action that requires KVM to access the page,
e.g. via kvm_vcpu_map(), ensure_pfn_ref() will reject the access and all sorts of
bad things will happen to the guest.

So, why not fully reject these types of pages?  If someone is relying on KVM to
support these types of pages, then we'll fail fast and get a bug report letting us
know we need to properly support these types of pages.  And if not, then we reduce
KVM's complexity and I get to keep my precious WARN :-)
