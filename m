Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A8C3A71B8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 00:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFNWEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 18:04:52 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:45584 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhFNWEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 18:04:51 -0400
Received: by mail-pl1-f179.google.com with SMTP id 11so7361221plk.12
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 15:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uuIQ9mFudkBQV6iPxAmTE5dkyJPW7bJYeIudcHLaAQw=;
        b=PguiUnKMJudKIwAkkrmeeYYBtuALaEnWZhKDXxZoyJ41IepmCSRkQ9dzD0P3SIMMHb
         twUYV9Z8YLSYyaXfXCoVJ8O3ayySrs1lSMy77ZXQ1P+kP8bLz4VRNMAZuWkPGlSxjlfo
         1OYupyLtvyqW1whlprQ0nXKwcA3enOQLMN2LSZ7Tcvnvv/5yO/3KjxqLW33QTCb2emr/
         R/dPUWRDWWYzTwxOq1DCWXz2t6ulnxbFvNgHvcmut3vipn+TjOFyyEXs+KniIdY/v+by
         KVknPzx4TueDLIqAA4N/Zy8fmlHe2mqwuRnMN0Hj4TY1qUGvLOaHCFvKWhda9LkS4jd+
         b80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uuIQ9mFudkBQV6iPxAmTE5dkyJPW7bJYeIudcHLaAQw=;
        b=Qvjax6ZWsvJ83KwprvIah+dzVgxgKmZpJhnG1mOXdfePbhoDdwylMs2WILcEc+DOZ0
         Y4Oq9e9SygTYZBEhWHikKob4aBxB+1pVkXOZ76g6lCVItNypjkwa623vnKRCF3Xn/bTx
         lQ8v74fSjCI6CyygAp9MaiDfOxWNJwaFm7PcYkiPwNIvWMQwXVrClv5+ZtgKbYy1MMlM
         3EkjnUPhAdst05rKxcsfYOwgpGKqyURRxKo5d1yXMwSa4M2fyYICnwkl7reZqkGuYUJA
         FxxJKGcanzikjiCOXdvtrfxQLTJD3jNpj4dOtY3cbm8d+6dkz4S2yvO1Njzx4rlOxat3
         6U1w==
X-Gm-Message-State: AOAM531CSdIh37SyWJoEitJhvSstUkU3i6mxtL4z15hcxmEoyPjDGOSR
        wa9xdsmogIkAoLWTsQHlcPOnFQ==
X-Google-Smtp-Source: ABdhPJwMDEqRhEIQ0twUY0AJ4udwm89dH6Q1wMKkgwKjW1CdLvKXMYEIGDCtMihRPkgO/vFLteunxw==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr21812238pjg.193.1623708097285;
        Mon, 14 Jun 2021 15:01:37 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v9sm13129498pfn.22.2021.06.14.15.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:01:36 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:01:32 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Refactor is_tdp_mmu_root()
Message-ID: <YMfRvKrLSpm5hfHo@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-2-dmatlack@google.com>
 <YMepDK40DLkD4DSy@google.com>
 <YMfIw3Evf6JK78JR@google.com>
 <YMfMlZDzOatTYfH2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMfMlZDzOatTYfH2@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 09:39:33PM +0000, Sean Christopherson wrote:
> On Mon, Jun 14, 2021, David Matlack wrote:
> > On Mon, Jun 14, 2021 at 07:07:56PM +0000, Sean Christopherson wrote:
> > > On Fri, Jun 11, 2021, David Matlack wrote:
> > > > Refactor is_tdp_mmu_root() into is_vcpu_using_tdp_mmu() to reduce
> > > > duplicated code at call sites and make the code more readable.
> > > > 
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c     | 10 +++++-----
> > > >  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
> > > >  arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++---
> > > >  3 files changed, 11 insertions(+), 9 deletions(-)
> > > > 
> > > 
> > > ...
> > 
> > I'm not sure how to interpret this.
> 
> Ha!  It took me a second to figure out what "this" was.  The ellipsis is just a
> way of saying that I trimmed a chunk of text.  I throw it in specifically when
> I'm trimming part of a patch to try to make it clear that my response is jumping
> to a new context.

Ohhh, that makes sense. Thanks.

> 
> > > E.g. achieve this over 2-4 patches:
> > 
> > Thanks for the suggestions, I'll take a look at cleaning that up. I am
> > thinking of making that a separate patch series (including removing this
> > patch from this series) as the interaction between the two is entirely
> > superficial. Let me know if that makes sense.
> 
> Hmm, make 'em a separate series unless there a semantic conflicts, e.g. if you
> want to cache the result of in get_mmio_spte() or something.

Ack, will do.
