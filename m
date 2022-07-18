Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9022577A70
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 07:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiGRFaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 01:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiGRFaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 01:30:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8B9DF85
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 22:30:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 72so9665258pge.0
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 22:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3rPSqyZCvcUyzHN9ra5fCExOPk8KP5mvJg/MF40JO4=;
        b=pJrkw0w0wfx9IJzlhXxXwjTHqRRFFJMUI1k9FUjgKtHXjoYJZ5EVlh93iN0UFMDAb7
         2l8fExGjnXw28RCa7leChjpIYiAEcdvpGmUCfnVrrojy2jvQL9EPWG1D9150C8Ph3zHP
         b5TFcGASf09a6yvGDyZVgxafYQSeIU+zUiFd/knIxpOlsBIKVvtsdy9nlqcuIDu5+f5d
         QSAMrOvyJEnDPUygWqj/24XIwfgctGYnGaBVufpa6RYsCl1busFSvi5px9X8pXwXwCVy
         XwZuTOsNjNevh/Amq5tdWE4Ee6Bzq7MEZVtWxl6SCqUa7bY2N3GYuxWjjMSyNTnsGuZ6
         53qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3rPSqyZCvcUyzHN9ra5fCExOPk8KP5mvJg/MF40JO4=;
        b=xRL6qS587tEj8im6ns1nIErBnXQ97MmfMZ66e1TgjOWtp4F9CsyggYRb3IfuwMRwAz
         Bhu3Y+Jx7VS4/TeFGu50g+XqaT2KwVkOh7YuheDxBlxx7WlAuKRmLcNLCtkhh0Udu11z
         SohajX1AZwJ6w52QOpGSqiyUhTZ3WWp2PyOaxUEkAzKOZL+WxhWzWVBFi+rY2BesNGo2
         DUJvK4JnDG8QkVj38pCnY0faQYeHxHHqpLsSlt0eA3RS5a0Fc1g+hbsW6cLUfszlJtU+
         TYyQbelaOWytXiGXaIYJje4S5GWQHV1qm0s2rzuhx1dkizYfPtNOe/jj7CP9RERbErZP
         ck8g==
X-Gm-Message-State: AJIora+93scK3ChjI2Y7qZUqMHZ4KgTqz7qRbfKusyRodjGa1WU2U7u/
        L9emzDBlJOtyvPfhq2uKiiJ+wg==
X-Google-Smtp-Source: AGRyM1smWiOj3KxSI0FjEWFwTm69u4p2Y4DvrX0eOSFM9rIHF23q01Vjf7gO/IR1+rmM+5ODge9lVg==
X-Received: by 2002:a63:310c:0:b0:415:368b:fd0a with SMTP id x12-20020a63310c000000b00415368bfd0amr23215021pgx.218.1658122204586;
        Sun, 17 Jul 2022 22:30:04 -0700 (PDT)
Received: from google.com (59.39.145.34.bc.googleusercontent.com. [34.145.39.59])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79490000000b0052512fdaa43sm8147472pfk.163.2022.07.17.22.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 22:30:03 -0700 (PDT)
Date:   Mon, 18 Jul 2022 05:30:00 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: Apply NX mitigation more precisely
Message-ID: <YtTv2EK4wJDjhjSj@google.com>
References: <20220409003847.819686-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
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

On Sat, Apr 09, 2022, Sean Christopherson wrote:
> This is just the kernel (NX) side of Mingwei's series "Verify dirty
> logging works properly with page stats".  Relatively to v3 of Mingwei's
> series[*], this fixes accounting (and tracking in the nonpaging case)
> of disallowed NX huge pages.
> 
> I left off the selftests because I disagree with the "Dump stats" change,
> and this has snowballed enough.

Hi Sean,

Ping on this one? This series might need a rebase and I can quickly
provide the review, since several issues are blocked by this. Or if you
are busy, I can help driving it.

Thanks.
-Mingwei

> 
> https://lore.kernel.org/all/20220401063636.2414200-1-mizhang@google.com
> 
> Mingwei Zhang (1):
>   KVM: x86/mmu: explicitly check nx_hugepage in
>     disallowed_hugepage_adjust()
> 
> Sean Christopherson (5):
>   KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
>   KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
>     MMUs
>   KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
>     SPTE
>   KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
>     pages
>   KVM: x86/mmu: Add helper to convert SPTE value to its shadow page
> 
>  arch/x86/include/asm/kvm_host.h |  17 ++----
>  arch/x86/kvm/mmu.h              |   9 +++
>  arch/x86/kvm/mmu/mmu.c          | 104 ++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/mmu_internal.h |  33 +++++-----
>  arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
>  arch/x86/kvm/mmu/spte.c         |  11 ++++
>  arch/x86/kvm/mmu/spte.h         |  17 ++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
>  9 files changed, 167 insertions(+), 81 deletions(-)
> 
> 
> base-commit: 6521e072010d10380eca3d8a2203990e61e16ae0
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
