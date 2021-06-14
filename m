Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55F63A7178
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 23:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhFNVl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 17:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhFNVl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 17:41:56 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58205C061574
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:39:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u18so11606606pfk.11
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tybQ7fPyX9YXs0RaWwpbxRg8ocDRYrukQdGqGZvprw4=;
        b=obwgvgEN6RrO7L5+AWSJODfG77uGizueDzf19g/NItebLp9nrPy8EDpB849D8ADjcu
         IahinGxojOgV5W88OL+sV5fQYJu2CKk28/fmWXskIT3+q0tikJaYmh+t6oT824X+pZne
         BiTaOApF0VXcIUsVdTBmjQfBDBhscRa5kfJ8LmVto6zlB5jtC6GvpiFWQHyUxYd8YkEf
         wOxFT14GBfUQkMp0vhGGsp728xTs+AWI3M0bXYiRNBmCllqpVMw++d/BUkbSGR75iK96
         t9FVo1BxjmjJt3ka9ZGov/ZdJn6A+kJFX3GambF2fbhRCN/A2VW7qhCgNp+pkEAa/8v/
         jChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tybQ7fPyX9YXs0RaWwpbxRg8ocDRYrukQdGqGZvprw4=;
        b=YYFod46hJ2GP7IRClGWJmVROYtbvvthJEmK8kQdGEVBukmQMAzeWSS2QyaicK5jNC+
         FH6zfSCsE97Z/MyBxivKDrwUqz5lCNQxs0HevyQqFQj6DOqsQb8ey8B8mhGPs6bWwTu7
         odpWOxRlzWKG8zntOcgpCSnC6pWYGBK9MBtLmBdl9Yo9cbLBaSkKhV04rMt3MvkXIYNN
         V44fPnbpipnkjF5y8J5QMmi7eMxdXMTFC9AA+g6tUMWg0rtn0zBwODybK/7+GcvlBDA1
         F08y7PCcrs490/1ngc/swDOTwzQdY4qPAVRcAqcV5TonDHnZOiS3FQqPXxH5Z7YR//tz
         O/7A==
X-Gm-Message-State: AOAM531tk7xSypSjSCX+Jsv9XwXlRYA6iORlh1MC/L7K7kg+RJbLEVLa
        Idu4YSaVXs6pLGAzf1Y+a/GO/g==
X-Google-Smtp-Source: ABdhPJwjKgDzy4Vh0BPHIPICu7JNb7NWegrftESMvue3SNLOwbl5PYX83qmt4Akbkv3qDluer0UXzg==
X-Received: by 2002:a05:6a00:1825:b029:2ed:7930:cdad with SMTP id y37-20020a056a001825b02902ed7930cdadmr1128000pfa.18.1623706777749;
        Mon, 14 Jun 2021 14:39:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r135sm14054875pfc.184.2021.06.14.14.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:39:37 -0700 (PDT)
Date:   Mon, 14 Jun 2021 21:39:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Refactor is_tdp_mmu_root()
Message-ID: <YMfMlZDzOatTYfH2@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-2-dmatlack@google.com>
 <YMepDK40DLkD4DSy@google.com>
 <YMfIw3Evf6JK78JR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMfIw3Evf6JK78JR@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021, David Matlack wrote:
> On Mon, Jun 14, 2021 at 07:07:56PM +0000, Sean Christopherson wrote:
> > On Fri, Jun 11, 2021, David Matlack wrote:
> > > Refactor is_tdp_mmu_root() into is_vcpu_using_tdp_mmu() to reduce
> > > duplicated code at call sites and make the code more readable.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c     | 10 +++++-----
> > >  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
> > >  arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++---
> > >  3 files changed, 11 insertions(+), 9 deletions(-)
> > > 
> > 
> > ...
> 
> I'm not sure how to interpret this.

Ha!  It took me a second to figure out what "this" was.  The ellipsis is just a
way of saying that I trimmed a chunk of text.  I throw it in specifically when
I'm trimming part of a patch to try to make it clear that my response is jumping
to a new context.

> > E.g. achieve this over 2-4 patches:
> 
> Thanks for the suggestions, I'll take a look at cleaning that up. I am
> thinking of making that a separate patch series (including removing this
> patch from this series) as the interaction between the two is entirely
> superficial. Let me know if that makes sense.

Hmm, make 'em a separate series unless there a semantic conflicts, e.g. if you
want to cache the result of in get_mmio_spte() or something.
