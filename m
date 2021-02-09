Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DA0315536
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhBIRhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 12:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhBIRfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 12:35:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB36C06178A
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 09:35:12 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e9so10144768plh.3
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 09:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r47X2ee78t2SLXgVN2ZcRb271S7UdHkQrq/tHAJkSkQ=;
        b=DbdHfvtjdYzkLF7dfWPsMxV4+Rb4sAagbFEZ6H600ZnICjslL0olfmaPh3ikqvt3zz
         IbIaV5p9dBs0iiHwb8hQEyrjqTrSQjZ2CmY1ayRrBl7MB4QIeqclo3xX55n4/5GwN6/U
         oWpwcG/gms/Ddcor+Lj21w1fyMraOH6gTHyPo+mH3N0Wkjl6/bq+DFYHZ72FxKzgbWmw
         prFvhzQQyH5zj2/6QVE48eRs59m2Y2eOvPsbyDSlj7fij30rdic147MB+jqjPrTmG3qU
         8lzeOCzTd8tsOhgld6FHTd7VF915S9PfW1MJAruEwJjjUruv8nfiI/LFbHcgr3cf9Uw8
         K0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r47X2ee78t2SLXgVN2ZcRb271S7UdHkQrq/tHAJkSkQ=;
        b=bYkfEWZo5IVEUq9CQP06mWhN7nud3scjP6efE0LQn+WhQaWYgJQ6hTZSNEknUJtiHH
         gCfj6f63T+w6IMrfX4epXNlNkv2sUuT+IvvQNalsR+FRYzlDw5IOr3AmCbdXESX9djNT
         WRjbXPN0zldwuYRcoTqvQQ6AXWumtNkTQFznBIoE3fIw4hEw8tkxz6ruWrh3lNCeqVt1
         /hq7flcZpmnx0TJ/ugVKBzX9Xid3puCYiVsAf2wCEBjPdP0S+TiyQV/a8CosS+8Ov+2J
         dY855b1ZQk1794xdJzD+qQUgfY6GjlcyYVNJCwrfNniTwQbKUGG40DAP9bZkw/jLQ8I8
         SYkQ==
X-Gm-Message-State: AOAM530z+DAIm5zBlPO3EGpe65AF5QnhYlaYhKJmI4YzcKxWVkIfbVw7
        ZTIjYjNpV7QqAWEvuqIuAvMm+qIizQEmxg==
X-Google-Smtp-Source: ABdhPJyfamXiK8zUBMBE5zvrRwdQMBQci+3Me+rQ9GBv/bbPyR43ucxOUxdQYH5Z5WfghBZ1oaEVyw==
X-Received: by 2002:a17:902:c3c2:b029:e1:74f5:6a65 with SMTP id j2-20020a170902c3c2b02900e174f56a65mr21289693plj.46.1612892111477;
        Tue, 09 Feb 2021 09:35:11 -0800 (PST)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b18sm2065pfb.197.2021.02.09.09.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 09:35:10 -0800 (PST)
Date:   Tue, 9 Feb 2021 17:35:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     "wangyanan (Y)" <wangyanan55@huawei.com>,
        kvm <kvm@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH 1/2] KVM: selftests: Add a macro to get string of
 vm_mem_backing_src_type
Message-ID: <YCLHy82RcATHEDtC@google.com>
References: <20210208090841.333724-1-wangyanan55@huawei.com>
 <20210208090841.333724-2-wangyanan55@huawei.com>
 <CANgfPd967wgLk0tb6mNaWsaAa9Tn0LyecEZ_4-e+nKoa-HkCBg@mail.gmail.com>
 <c9c1207f-09ae-e601-5789-bd39ceb4071e@huawei.com>
 <CANgfPd_u2uGmt645e9mLbBcTOV1mQ_iXjq8h7WwCDKETZJ9GJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_u2uGmt645e9mLbBcTOV1mQ_iXjq8h7WwCDKETZJ9GJg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021, Ben Gardon wrote:
> On Tue, Feb 9, 2021 at 3:21 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
> >
> >
> > On 2021/2/9 2:13, Ben Gardon wrote:
> > > On Mon, Feb 8, 2021 at 1:08 AM Yanan Wang <wangyanan55@huawei.com> wrote:
> > >> Add a macro to get string of the backing source memory type, so that
> > >> application can add choices for source types in the help() function,
> > >> and users can specify which type to use for testing.
> > > Coincidentally, I sent out a change last week to do the same thing:
> > > "KVM: selftests: Add backing src parameter to dirty_log_perf_test"
> > > (https://lkml.org/lkml/2021/2/2/1430)
> > > Whichever way this ends up being implemented, I'm happy to see others
> > > interested in testing different backing source types too.
> >
> > Thanks Ben! I have a little question here.
> >
> > Can we just present three IDs (0/1/2) but not strings for users to
> > choose which backing_src_type to use like the way of guest modes,
> 
> That would be fine with me. The string names are easier for me to read
> than an ID number (especially if you were to add additional options
> e.g. 1G hugetlb or file backed  / shared memory) but it's mostly an
> aesthetic preference, so I don't have strong feelings either way.

I vote to expose/consume strings, being able to do ".dirty_log_perf_test --help"
and understand the backing options without having to dig into source was super
nice.
