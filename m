Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707A0474C37
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 20:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhLNTpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 14:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhLNTpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 14:45:44 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBD0C06173F
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 11:45:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u80so18697669pfc.9
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 11:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Z3UBTl7jPBQ/S77snk8IVzLmGP+ErnAZOzUMW8UTq8=;
        b=HQyBo4dU6xQwWMptNtxQhOBNd3KOQMO22T5cBp/sfKJbYIQ9b8TBYWqzbVJw2pktXI
         XnGx9xoczWwZeflQyEUu39rb0VKEd0dCI9sCtuq/ixotURahbkMmD4kNyDMXITI+As1K
         DEkxXv+26zNmoCDE6LqJ1do2FaTZzV7Wz0MIe1Jg0xbjB1o0eDKTsJl6rt8mZra40ExO
         KJ8yEhFbJIiRSD7xletEENNaa2fzadQNjli1rlMb1xr73q3rVyCf09n1gI7S40fr3o6R
         +VAbhaBId1qZnyEsB0n+GqhwBu1UcpPVmrbon5mJfUWmKsMiFrSj052g5HoLNQUGPER3
         iSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Z3UBTl7jPBQ/S77snk8IVzLmGP+ErnAZOzUMW8UTq8=;
        b=CnBLhB9fSV5Onn3BO0e0x7Z4yP3tP/7H73xqNib9MMij7zyuRw21+MXA3y1FqIvzSP
         6dRFOJY0FvCS6+iRPE7/AJVbwhTfgz3HcDqHpPV9kX62qX5DXIlU53NHVTOIZQeH2HaR
         zRJxDDEqLLMqXxNofuMgV9Z1HwAIOBodZGyS0jTg4QbyZVyUqom+GH44uQIPk0V0OmLw
         GKXYAS4Cfp5hEtk/u6GbtH/qHQoWOgc/YWl205cG6oNsmYHYs2lIhvAZ9sNdvWA15FhA
         5KQAKJS++jJMrSjh9E/muMa800w3VDuI8clqLdsKB+2lqWKiyAv1RTnzOxJXV3BG61cL
         eRRw==
X-Gm-Message-State: AOAM531ZN7jeXDKf2vlJ2BuV0UeH4uWSylJX6ZCOCEZ/23sFyyFRwvme
        biGh2ozF08x+24guEjQdDwnHMA==
X-Google-Smtp-Source: ABdhPJx8bDekdaRVb6HNjxh3olkWUHPaGJdisWXeDRilvZ4B6gdcgX6jH46fsqkDStdycbDbM0C9tg==
X-Received: by 2002:a63:4559:: with SMTP id u25mr5012691pgk.15.1639511143347;
        Tue, 14 Dec 2021 11:45:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m15sm3126304pjc.35.2021.12.14.11.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 11:45:42 -0800 (PST)
Date:   Tue, 14 Dec 2021 19:45:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ignat@cloudflare.com, bgardon@google.com, dmatlack@google.com,
        stevensd@chromium.org, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: zap invalid roots in kvm_tdp_mmu_zap_all
Message-ID: <Ybj0Yx17u0MmiOdi@google.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <20211213112514.78552-3-pbonzini@redhat.com>
 <Ybd2cEqUnxiy/JBd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybd2cEqUnxiy/JBd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Paolo Bonzini wrote:
> > kvm_tdp_mmu_zap_all is intended to visit all roots and zap their page
> > tables, which flushes the accessed and dirty bits out to the Linux
> > "struct page"s.  Missing some of the roots has catastrophic effects,
> > because kvm_tdp_mmu_zap_all is called when the MMU notifier is being
> > removed and any PTEs left behind might become dangling by the time
> > kvm-arch_destroy_vm tears down the roots for good.
> > 
> > Unfortunately that is exactly what kvm_tdp_mmu_zap_all is doing: it
> > visits all roots via for_each_tdp_mmu_root_yield_safe, which in turn
> > uses kvm_tdp_mmu_get_root to skip invalid roots.  If the current root is
> > invalid at the time of kvm_tdp_mmu_zap_all, its page tables will remain
> > in place but will later be zapped during kvm_arch_destroy_vm.
> 
> As stated in the bug report thread[*], it should be impossible as for the MMU
> notifier to be unregistered while kvm_mmu_zap_all_fast() is running.
> 
> I do believe there's a race between set_nx_huge_pages() and kvm_mmu_notifier_release(),
> but that would result in the use-after-free kvm_set_pfn_dirty() tracing back to
> set_nx_huge_pages(), not kvm_destroy_vm().  And for that, I would much prefer we
> elevant mm->users while changing the NX hugepage setting.

Mwhahaha, race confirmed with a bit of hacking to force the issue.  I'll get a
patch out.
