Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E0F51052F
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiDZRXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiDZRXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:23:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42394BB85
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:20:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y38so2820173pfa.6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4FZja9WudcKens4azldCUmjh2etbVq0EGH84l7RjgU=;
        b=gcOCeXEtfA5bcZ/0OV4XMefXitjP6xuTILazvyaC+XU0gpaBiM0Dlgq0QSn5nnYeDu
         hhDibZtZpYTsaYC0GBYi9E4xYXa1QxVYXJPTKhW5jEogY9D7brvG/037iX8URKn16x/Y
         a45/RuOD/U5pb9Hj6+uANTPMZDlDhiPvLhJUfjpngUdOCiueITld9oB5KmFW6mJiK1+S
         N76z7OfUxd1I62SO1Fu0ejnC4zUVdviKqwRlQv0tkpyGOXmistKqH7Bnmmdly65qfeU7
         Gnq6Sbk7uyoGGHhUYla7OHHq8l+ncuWcUxttGrpEjVKb9jBI5znDmgB8HDYwHZMvbBfy
         +6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4FZja9WudcKens4azldCUmjh2etbVq0EGH84l7RjgU=;
        b=tYd3koQ0BFUVWeN8O/+w7NYQ3Yav1ZLZed8MC+JRXvOk6iIS8wJEYo9h6+krEL8YdY
         Gkl006qozrgKIVRc8WvotP49JF50w4+IM1vpqH8TgwmOsAWJ1RaSzKI79UhZjutyNXPO
         8Mr2ynWm7Wck8wJFBqRYxQMAXGqUTLeXa62sXjc36G8gYrJF4fHtgFGeipChRHilK68C
         FuI1PtTmmRQDN8q3zgR40eG9aHcbm6Ou7huEIBKimIhy+/id6PaVBukssJtuhfAcEZY5
         I1fpW+Gk07TXzYznS+L39MMkQuo4timp4On5qj2J76waxfS7h1ILFCEKQIhIKlN4KaCs
         gicA==
X-Gm-Message-State: AOAM532AV6cVUcYalNaMTRxqBeDeLwvHsXzrjI1XdIO6KSDkgrfh6sIS
        fqorWrMLQl3A80oQGeRzNQ2u6WC6LCi3pvaTgIyMG3RF7hJG+Q==
X-Google-Smtp-Source: ABdhPJw41MD54CZn3iFTHAqU/4zXInNZxrbaKEbgqHdskaF06GdYcfMFMso5Ak25IGKvB9HSfzmpK89B5hdyIBaBt1M=
X-Received: by 2002:a63:8ac7:0:b0:3aa:fa62:5a28 with SMTP id
 y190-20020a638ac7000000b003aafa625a28mr14854945pgd.400.1650993600084; Tue, 26
 Apr 2022 10:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220327205803.739336-1-mizhang@google.com> <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com> <YkH7KZbamhKpCidK@google.com>
In-Reply-To: <YkH7KZbamhKpCidK@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 26 Apr 2022 10:19:49 -0700
Message-ID: <CAL715W+6UwO2zgoSLUeTmBHRo1HMSGshA6YMhvBiqfJrejhwFQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 11:15 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 28, 2022, Mingwei Zhang wrote:
> > With that, I start to feel this is a bug. The issue is just so rare
> > that it has never triggered a problem.
> >
> > lookup_address_in_mm() walks the host page table as if it is a
> > sequence of _static_ memory chunks. This is clearly dangerous.
>
> Yeah, it's broken.  The proper fix is do something like what perf uses, or maybe
> just genericize and reuse the code from commit 8af26be06272
> ("perf/core: Fix arch_perf_get_page_size()).

hmm, I am thinking about this. We clearly need an adaptor layer if we
choose to use this function, e.g., size -> layer change; using irq or
not. Alternatively, I am wondering if we can just modify
lookup_address_in_mm() to make the code compatible with "lockless"
walk?

On top of that, since kvm_mmu_max_mapping_level() is used in two
places: 1) ept violation and 2) disabling dirty logging. The former
does not require disable/enable irq since it is safe. So maybe add a
parameter in this function and plumb through towards
host_pfn_mapping_level()?
>
> > But right now,  kvm_mmu_max_mapping_level() are used in other places
> > as well: kvm_mmu_zap_collapsible_spte(), which does not satisfy the
> > strict requirement of walking the host page table.
>
> The host pfn size is used only as a hueristic, so false postives/negatives are
> ok, the only race that needs to be avoided is dereferencing freed page table
> memory.  lookup_address_in_pgd() is really broken because it doesn't even ensure
> a given PxE is READ_ONCE().  I suppose one could argue the caller is broken, but
> I doubt KVM is the only user that doesn't provide the necessary protections.

right. since lookup_address_in_pgd() is so broken. I am thinking about
just fix it in place instead of switching to a different function.
