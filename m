Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C03D12F5
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhGUPPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239930AbhGUPPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:15:38 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C14C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:56:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id i16so2288927pgi.9
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z/3hbAsJ6hHRh2rV5PKBBKqWA8JlmZPRUnge7XIh/YQ=;
        b=ehQoWoN4b32AKEfbvzq/TqZJcLxqy2qFsIQziLzJY6uB8BoZ6VYVXo7jbfZA7sVLhS
         8fwH8/fgfuxwV65KU8TnaTBtuJkomxvtsAn2CLr52BuqX6i4x557dh/zFbderYhUX1Df
         QDSSRw1+j/NyTogqgIsTFijnm02thPGW7FqPn2BBof24v+z2kXpV5f9hFCwJS0L1kAGk
         Y3/u7w7mpkBuq+fL9JkzBCLDmamQVNFhqZ+b/ZCY/RJgbAxBX/Zpy9smexy1YOE1lTZF
         9OkteuG+A1w/N40tI8fQh95DzeFnb5Qg8mvr19ukAQtdgJtNvytkN1HA+jZWxrIVQU+/
         +Pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z/3hbAsJ6hHRh2rV5PKBBKqWA8JlmZPRUnge7XIh/YQ=;
        b=amvRLu9uVezdI7V9LLeBzjYdFE+S7haR/vx3dGEMKlRAYGgEn226srUKfg5+TWr1cX
         sn+boGmKYM2F+YTtyA8Ivu7mEunXYWqxAdNMB3QtdGyglAjyxT1lPt0vcO6n7ayG0Z5V
         aq0TOfmkHdtQrTlociLuw2Sv44l5aY5tj4dKxr8HXGkGP1TmHSVzYz2hEYKCxW/JUUjw
         W/OXm3Yf0mZ/qQ2sNfD4PbzH1l8mEL2IGyNOmFvzeWNKXDi01g7fbinRWjyNNB20bxHc
         rYaucmS7Vg40dluj8AUsR9+Q9Vmd+VU+hWPRSeH9MSODKk2PNlJ9lsaDJMeCx7JZ+KTG
         M/bQ==
X-Gm-Message-State: AOAM533eBaGVBf+iyI7RCXkEGol5s0vG1ZG9vag3rJG9+SnvLwvtZNwt
        vrcVlPFK5NBM7I0M0TyVbPTPgA==
X-Google-Smtp-Source: ABdhPJyQd9ZxyuvcAtcCKZ9XQkD55IW0oavb0JRtrpoVXiY7PwyAKlaBAOyUgIFyn8iBMuitZ9cxjA==
X-Received: by 2002:aa7:8d10:0:b029:303:8d17:7b8d with SMTP id j16-20020aa78d100000b02903038d177b8dmr36719282pfe.26.1626882973209;
        Wed, 21 Jul 2021 08:56:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e23sm26592454pfd.26.2021.07.21.08.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:56:12 -0700 (PDT)
Date:   Wed, 21 Jul 2021 15:56:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute
 the THP mapping size
Message-ID: <YPhDmZya2Up7fYNN@google.com>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
 <YPczKoLqlKElLxzb@google.com>
 <20210721145828.GA11003@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721145828.GA11003@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021, Will Deacon wrote:
> > For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
> > invoked at the beginning of exit_mmap(), before the page tables are freed.  In
> > its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
> > the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
> > also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
> > guaranteed to run with live userspace tables.
> 
> Unless I missed a case, exit_mmap() only runs when mm_struct::mm_users drops
> to zero, right?

Yep.

> The vCPU tasks should hold references to that afaict, so I don't think it
> should be possible for exit_mmap() to run while there are vCPUs running with
> the corresponding page-table.

Ah, right, I was thinking of non-KVM code that operated on the page tables without
holding a reference to mm_users.

> > Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
> > handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
> > still be called, so userspace page tables aren't a problem, but
> > kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
> > any additional notifications that I see.  x86 deals with this by ensuring its
> > top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
> > running.
> 
> But the fact that x86 handles this race has me worried. What am I missing?

I don't think you're missing anything.  I forgot that KVM_RUN would require an
elevated mm_users.  x86 does handle the impossible race, but that's coincidental.
The extra protections in x86 are to deal with other cases where a vCPU's top-level
SPTE can be invalidated while the vCPU is running.
