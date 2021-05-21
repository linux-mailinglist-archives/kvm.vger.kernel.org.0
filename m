Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91038CCB0
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhEURvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:51:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238824AbhEURux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 13:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621619369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eCxGfuMnfQDDRkSgoJFFHxNWdySUYed2Pe05f2luAA0=;
        b=aE9Sc92hXStN9ZqL4gRhzkm+G8kJ15IhSfpZLMkD3rSX5ioz/SeXekAaGD3fSdiaTj62A/
        +JNZqwNYlrKAtR/zETxaoa2v5Y1HfqUdjmGgkE4quO6BjdbfjmgO+upi7Y+DtH2I3b1+r0
        G0SyMLyNdEMvUUYGD1LMmZ93esgV8zY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-VK99emozMOi3f4VMr68mkg-1; Fri, 21 May 2021 13:49:27 -0400
X-MC-Unique: VK99emozMOi3f4VMr68mkg-1
Received: by mail-qt1-f197.google.com with SMTP id j12-20020ac8550c0000b02901dae492d1f2so16152740qtq.0
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eCxGfuMnfQDDRkSgoJFFHxNWdySUYed2Pe05f2luAA0=;
        b=gNqX9X2aiOJ6QfPs4HYF35ZR2H8YYXr4E8pIa/7MBnO8h/GNMvcjwecd8dkgldKnZV
         szEHTFuUVsrwj4D7JOGSovvhaPnSg8AceINPEVQ70lR9bT7dB24dDGK4o1/4EIaP6uy9
         pTpr91/8hBx44jkrW6m5mfyS6xYyQpwp5QMwpx6K/skTc3ZQmf0eoLqiOKz16d0unQqW
         VfCtQjE4SniOFIce31frzJom8nXAl6/DfTX/tIJKA2oSThgsE9RdTEzoJXBdmjtPymDx
         jLhsVN6wF6xxQnufIy0DPEPWEmWqPxFkbQ8exDyAJJktmKyaQ6H0CJ3OWigdixbZGvu2
         Vfxg==
X-Gm-Message-State: AOAM530NYecA1cd0hsvvCpoDqEoLF4qb6hdU86gD96MhHhq3p2FULDAp
        l5U0vxstEkTgluqopuUI2uNxvKi5B17gNi9zkX/NiQgeBkQrKUZgmJmF4Fqmw5ennFry1wfT5eq
        J/NnjNQBmWtse
X-Received: by 2002:a05:620a:208a:: with SMTP id e10mr13819708qka.112.1621619367404;
        Fri, 21 May 2021 10:49:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIWrFiYBNV1lMWqMFypLd73cRUR7XXcI8n00vyqQX8k2WQLOZv+V4f4cwC6ev7eFBBG1MJxQ==
X-Received: by 2002:a05:620a:208a:: with SMTP id e10mr13819684qka.112.1621619367136;
        Fri, 21 May 2021 10:49:27 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id g1sm4791195qtr.32.2021.05.21.10.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:49:26 -0700 (PDT)
Date:   Fri, 21 May 2021 13:49:25 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix 32-bit truncation of
 vm_get_max_gfn()
Message-ID: <YKfypTYnITl76o/L@t490s>
References: <20210521173828.1180619-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210521173828.1180619-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:38:28PM +0000, David Matlack wrote:
> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> which causes the upper 32-bits of the max_gfn to get truncated.
> 
> Nobody noticed until now likely because vm_get_max_gfn() is only used
> as a mechanism to create a memslot in an unused region of the guest
> physical address space (the top), and the top of the 32-bit physical
> address space was always good enough.
> 
> This fix reveals a bug in memslot_modification_stress_test which was
> trying to create a dummy memslot past the end of guest physical memory.
> Fix that by moving the dummy memslot lower.
> 
> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

