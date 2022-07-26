Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA31E580ADB
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 07:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbiGZFhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 01:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiGZFhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 01:37:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D545E27CDE
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 22:37:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id jw17so57804pjb.0
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 22:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSJ2gSZEB95hQy+fBPJ2b6XGNWJqJmog2/ljhs0mKjk=;
        b=Tni2yj0/pL2Jpa8ecAowM1kwFjFqP1gjp4Pwvvksw8y6+kamiIiCbiK8LMkZy7tv3l
         eCz53si26zG3SIFgWxMoLX1OWgY3g92VLYPoz06MadIQFIM6U+QGv2n925Diti5NOn7K
         2gDDCp419O+bMCh6SplghILz6okQcoBGnApd5QXxL62BmRimZ6mhqUcCfvzH4JT1aIVA
         IwmvKKLyIWfgqMJ3J3AeWRyYKJhqTuC8Y2/5XY+EdgTeDMUsxO0cQudUwkWSzQvmtNBW
         j2SBzu5/z4zrjac5sUzfrrQQYuFyyjYJrQeB4k0ZcZIGAH3NRoPQRyCh/VBwTHrX4fv+
         U3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cSJ2gSZEB95hQy+fBPJ2b6XGNWJqJmog2/ljhs0mKjk=;
        b=kqtAkOKrHRerr8ETMXAxXUkSAxOB9OcgtCXKkzviH2rnammly2RYQif90JPLkl3YgG
         o0ArOdNH9wESfV+Lf7no3B+Ob2476aQHucSKH5df+t4EG7iiiIMBSJRWguVDOxnfEtOF
         lfyXf63yNW+BMnB/DzGO5QZ208kaHsKg1Eq+3XmHOQ5QEXAmUtZom4nYAc7UlSA4aq2Y
         8+8BuDj5fa/d9nV+3d974Ao1G9s3K/w+EFFcewuKN0XSdEIW/a3vR6hxEtGb0eFAHN1v
         +QpfxKIOsC0z6gdjqr7q5Kr2Du4vpbTjWocKkwAb2LyV4qgwSLlmx2AClJ0UzZFIQz9v
         p8Nw==
X-Gm-Message-State: AJIora8+YfHRDlEw0Tlhmt3qBYQRNqN8jtv21OCOr70FyUjGQQ7UC2Jc
        fsfbRhcaPVxGBePE4qTI0TdwFhu20pUVMQ==
X-Google-Smtp-Source: AGRyM1tW8LiEDIBONgwUmkjln3quZm/8MKljtCsacOKwijdmvK0Yjxw2u6ulUGjMINFD4v5vRms0Og==
X-Received: by 2002:a17:902:d64a:b0:16c:2755:428d with SMTP id y10-20020a170902d64a00b0016c2755428dmr15805492plh.79.1658813843096;
        Mon, 25 Jul 2022 22:37:23 -0700 (PDT)
Received: from google.com (59.39.145.34.bc.googleusercontent.com. [34.145.39.59])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902680d00b00168c52319c3sm10429459plk.149.2022.07.25.22.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 22:37:22 -0700 (PDT)
Date:   Tue, 26 Jul 2022 05:37:18 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
Message-ID: <Yt99jpf5l/cInivs@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 23, 2022, Sean Christopherson wrote:
> Patch 6 from Mingwei is the end goal of the series.  KVM incorrectly
> assumes that the NX huge page mitigation is the only scenario where KVM
> will create a non-leaf page instead of a huge page.   Precisely track
> (via kvm_mmu_page) if a non-huge page is being forced and use that info
> to avoid unnecessarily forcing smaller page sizes in
> disallowed_hugepage_adjust().
> 
> v2: Rebase, tweak a changelog accordingly.

hmm, I applied this patch set (v2) on top of kvm/queue (HEAD:
1a4d88a361af) and it seems kvm-unit-tests/vmx failed on both ept=1 and
ept=0. And it did not work on our internel kernel either (kernel
crashed).

Maybe there is still minor issues?

> 
> v1: https://lore.kernel.org/all/20220409003847.819686-1-seanjc@google.com
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
>  arch/x86/include/asm/kvm_host.h |  17 ++---
>  arch/x86/kvm/mmu/mmu.c          | 107 ++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/mmu_internal.h |  41 +++++++-----
>  arch/x86/kvm/mmu/paging_tmpl.h  |   6 +-
>  arch/x86/kvm/mmu/spte.c         |  11 ++++
>  arch/x86/kvm/mmu/spte.h         |  17 +++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h      |   2 +
>  8 files changed, 167 insertions(+), 83 deletions(-)
> 
> 
> base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
