Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42EC4FE89C
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345882AbiDLT3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbiDLT3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 15:29:11 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DE03466B
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:26:51 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s13so25366342ljd.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uhp2gyxJXafqQhufiyepsQB0fVUjcBdyLXTovCl6zhk=;
        b=5r3BqAvHHqrB2sxGTnYHVAS69nI4KU7prcQCYLC+0giVYjXTuDzbhcWunmrmixMgiI
         l6KAoj+O6vndDV8nCt3/S5YfZKl20CFaNrJbcc41X99anlIpoxpW/y7x7Y1M8Moxl+/V
         1/swlz2HX63Q+NBEhUfmJQEpWAJDocdiEL2YUckMfpe3C8nZcla3i0xFsf7D/9DkQ9ru
         eAJG41WiqDv83Av6IuPIHFgdRnfdlNyaK+rskTFa67tR2m82ZCspiqGtd/RBP6s+qYm3
         8gfkf6bS7/JwsfLxy6EmCDw65cudX7DLbyf2e7vFavB5H90QMXcKGJMnj7FuirippGU7
         eNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uhp2gyxJXafqQhufiyepsQB0fVUjcBdyLXTovCl6zhk=;
        b=14Gy6wMPL5rJGDgEapNJLtYypoCXP+rTOHiwmDd0LYn1wN7nuckpjs2ZhFRSW81sgY
         p0raLkhaRWFZJppi+9enoy6Jem5ihuxU7QRNiO9fAlYSmidlIOctVvuHfuNwm11f2aOs
         X1tlAPkyTJldaANB+KQ65MLBBZIETga9Xsf2wwHJvUaagTYDNDRYlG09g2rTi5jkWxZ3
         7RDhMia2Odwatk9RiYho6YI7+cQ3nZHO15piTRuTNndJ6TldU4qKY4cdfOMwPVa+McwZ
         JG4AeOo6awr5Ax9tsbcPgNbgOoOTSngOmEl4LyKHuPYlUyWXCFSsa/hcDqE624ZRsOUD
         821A==
X-Gm-Message-State: AOAM531IAutiSla9FHfC9yJQAahdg5o1pxb8ldVEIxssjV+vlKqyeUcG
        aW6llCeOkVmHyNn0DRP5otXyCw==
X-Google-Smtp-Source: ABdhPJzNqQFsr22ki1Pj8rD15MClx6e4/Y9XgiO6Rr06pMklFiRq4YmMNE+KUcyBNh7zLIW+Z44IOA==
X-Received: by 2002:a05:651c:1a09:b0:24a:c7df:339c with SMTP id by9-20020a05651c1a0900b0024ac7df339cmr25219403ljb.298.1649791610046;
        Tue, 12 Apr 2022 12:26:50 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id h19-20020a056512055300b0046bb9a59e13sm309392lfl.56.2022.04.12.12.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:26:49 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 72EEB1030D2; Tue, 12 Apr 2022 22:28:21 +0300 (+03)
Date:   Tue, 12 Apr 2022 22:28:21 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com
Subject: Re: [PATCH v5 04/13] mm/shmem: Restrict MFD_INACCESSIBLE memory
 against RLIMIT_MEMLOCK
Message-ID: <20220412192821.xliop57sblvjx4t4@box.shutemov.name>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <20220310140911.50924-5-chao.p.peng@linux.intel.com>
 <Yk8L0CwKpTrv3Rg3@google.com>
 <20220411153233.54ljmi7zgqovhgsn@box.shutemov.name>
 <20220412133925.GG8013@chaop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412133925.GG8013@chaop.bj.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 09:39:25PM +0800, Chao Peng wrote:
> On Mon, Apr 11, 2022 at 06:32:33PM +0300, Kirill A. Shutemov wrote:
> > On Thu, Apr 07, 2022 at 04:05:36PM +0000, Sean Christopherson wrote:
> > > Hmm, shmem_writepage() already handles SHM_F_INACCESSIBLE by rejecting the swap, so
> > > maybe it's just the page migration path that needs to be updated?
> > 
> > My early version prevented migration with -ENOTSUPP for
> > address_space_operations::migratepage().
> > 
> > What's wrong with that approach?
> 
> I previously thought migratepage will not be called since we already
> marked the pages as UNMOVABLE, sounds not correct?

Do you mean missing __GFP_MOVABLE? I can be wrong, but I don't see that it
direclty affects if the page is migratable. It is a hint to page allocator
to group unmovable pages to separate page block and impove availablity of
higher order pages this way. Page allocator tries to allocate unmovable
pages from pages blocks that already have unmovable pages.

-- 
 Kirill A. Shutemov
