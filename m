Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C426A318F52
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 17:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhBKQAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 11:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhBKP6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 10:58:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31323C061574
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 07:58:01 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m2so4182638pgq.5
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 07:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HeDDVNwJvE2yrKMWyL0hMeAKpq/juTb4nf0aTQ3YIII=;
        b=fH0h91CR7DhcS+JEg8iSiuH+N9x4F/WdXKyPq5PAwBKI7LgvuJUkYbHy7G0NKYvcb8
         icBiIuA7sZJ21p0T6EESdBWVxtplnyjpJLaMzvY2e7LpJLbF/fGxE7Gv4P+fz216xcaQ
         IV5P4qNNp3yCGZA93RPxQTwKrGNn6+3F8frCvuOMyFEmo+hkVhlwWNDR6GO5TP/gDaG9
         VK6Y0jx1edOGRq3et9wCvW+9RUzEtYy5DGo+1JFJVAAaE2wu7k9R+sz9y7mAyuH0QCRe
         Kwvvw1Gdy202iKkkvHP26NJJJeNMfUQwXZmj5H8n88cJ5LFSCidwarEUauZjAfAXyllr
         k1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HeDDVNwJvE2yrKMWyL0hMeAKpq/juTb4nf0aTQ3YIII=;
        b=ZN/Rx7QcRPj2sghbCWM44ssyZylGFZ4wjIX7AUTtdFdpKFgfRb4aSTiZFm9axN6STG
         RbM4Bz8iILQQiGX6LHkYlt+sU5LVOiJQHXX7auG3jVrvZ9gErwAhflhFFlp65f79UqiQ
         Z4X0rdXQOYJUo7m6Ox5YNOJwei0WTLR8QZrQTZ47hysfivCrNgwFnOSLF04vawBC9YAW
         9Q9lAfE4WyBQd8bBvkQfipwQZp2qNVl5eYMp2RaRra+yoRGJZmZJH/M6DfQV6Arf9scu
         JwjyXyFFimmj+ogQjLzOq0IUy6eXQ0dilqcJDwAS8UiekkaSw8gfxQdwZFjIxGDBUU4n
         yXbw==
X-Gm-Message-State: AOAM530LXPZMd4y6fd09e+85F4x1VtLVs9r6GVE8yVImT981CUphKiB6
        Kzwt6MYCgDbIFBtqybBhYAibGsEA24hZ/g==
X-Google-Smtp-Source: ABdhPJwwt6iZiYg/YWGFpf7hhe0xQPXn47jDmvogtEKQdTJszmGhYKWm4muvrz1JXSo51238bX6Jrg==
X-Received: by 2002:a63:e108:: with SMTP id z8mr8565022pgh.363.1613059080521;
        Thu, 11 Feb 2021 07:58:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id c18sm6061906pfi.167.2021.02.11.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 07:58:00 -0800 (PST)
Date:   Thu, 11 Feb 2021 07:57:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 09/15] KVM: selftests: Move per-VM GPA into perf_test_args
Message-ID: <YCVUAdx3DYLPNwJU@google.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-10-seanjc@google.com>
 <CANgfPd8itawTsza-SPSMehUEAAJ4DWtSQX4QRbHg1kX4c6VRBg@mail.gmail.com>
 <YCSOtMzs9OWO2AsR@google.com>
 <756fed52-8151-97ee-11f2-91f150afab42@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756fed52-8151-97ee-11f2-91f150afab42@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021, Paolo Bonzini wrote:
> On 11/02/21 02:56, Sean Christopherson wrote:
> > > > +       pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
> > > > +       pta->gpa &= ~(pta->host_page_size - 1);
> > > Also not related to this patch, but another case for align.
> > > 
> > > >          if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
> > > >              backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
> > > > -               guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
> > > > -
> > > > +               pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
> > > also align
> > > 
> > > >   #ifdef __s390x__
> > > >          /* Align to 1M (segment size) */
> > > > -       guest_test_phys_mem &= ~((1 << 20) - 1);
> > > > +       pta->gpa &= ~((1 << 20) - 1);
> > > And here again (oof)
> > 
> > Yep, I'll fix all these and the align() comment in v2.
> 
> This is not exactly align in fact; it is x & ~y rather than (x + y) & ~y.
> Are you going to introduce a round-down macro or is it a bug?  (I am
> lazy...).

Good question.  I, too, was lazy.  I didn't look at the guts of align() when I
moved it, and I didn't look closely at Ben's suggestion.  I'll take a closer
look today and make sure everything is doing what it's supposed to do.
