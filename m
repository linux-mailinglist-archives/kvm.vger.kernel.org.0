Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFD3C650D
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGLUk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 16:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhGLUky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 16:40:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB94C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:38:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j3so7963126plx.7
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fNMr/yrOHQY7jjxJpQ0RVW33vo4pEDNx34eavU3PIlg=;
        b=EPCJA+5EoTiQyNlpJ1a5iaYZUfKugBxZE46noGw501Ezfyh/7pC5a1sw5neRrAUcnC
         MbGv2WGQUs5Dlwqi3dw7qzwcI0ZhyTFA4lPkIB2IH0kPT75FiRUQCkbWspo8W1NDj3LK
         cpIOTUiwqg4chHsjr6TM2OBx5LxSEfHjJpSloy47AL2LulfVImUdcf4L+o2hUd6zJQzc
         njIfzsDfMPwwktcErhfLD3qBnkilzestub2Pi014mvPV3lRfXqc06SGZf8kdIzbJBeFH
         bCQQGiBPHCzkhIvQS9/CKT1vjcS58lU6uVW3qjS4mLwwER63z+itisM2INeszuj3gvY4
         83Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fNMr/yrOHQY7jjxJpQ0RVW33vo4pEDNx34eavU3PIlg=;
        b=ZLf0T0/xzJrp6ulXSfSElBphKQcS6jJ3ihoLhEVXO0A5X2dbsHLkUYGTAT1LvVhPXA
         fq9Hm5I3DCp7ZKAeSbxGKUKECFER4nrxwttuD83XwHPVdxXaotcDLm3yT+FNCdYJvLn8
         5OqNYcTGroIc7VzIP0V7MipP4NMTJkvnd/CiLUcOVDxFBGKdQPB3AhCoa7u2LSAXLgai
         6IMzwOyc6tksD+XO5SaQVdacqcHDL7O8wRgCkFvrs5rElHjuw7ZT/RGzEY17fpk/88hH
         QL7q4zOFPtTuHYzd/Xtpijmm7/ANkETNMrC2LSHL2hubVGIv2CrvqhBYerifE9mYgwml
         2cwA==
X-Gm-Message-State: AOAM5319UVaPN51jx84rV/pf2OetSJSgrvN8FKEiFV6w2b8m9ZEZ4x7D
        CXauyEfm/Qh4thOnet9rL+y2Ww==
X-Google-Smtp-Source: ABdhPJwltdZ/KpokzOzMv6eE28iQ6WLcJDCozePTMOoKErPxEeKChv5F0rMkbL/Fp5++VhnGPXodPQ==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr699974pju.205.1626122284449;
        Mon, 12 Jul 2021 13:38:04 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d3sm14007327pjo.31.2021.07.12.13.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:38:03 -0700 (PDT)
Date:   Mon, 12 Jul 2021 20:38:00 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Fix use of enums in
 trace_fast_page_fault
Message-ID: <YOyoKFr+Vt+ITYpv@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-3-dmatlack@google.com>
 <CANgfPd8zqOKjLeFCcYR-waHhDxb_6LX113o6Dv5uip8R_G3e8g@mail.gmail.com>
 <YOyF3fZY8mXk/3+6@google.com>
 <YOyd063LlhGUFjWD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOyd063LlhGUFjWD@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 07:53:55PM +0000, Sean Christopherson wrote:
> On Mon, Jul 12, 2021, David Matlack wrote:
> > On Mon, Jul 12, 2021 at 09:14:01AM -0700, Ben Gardon wrote:
> > > On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > Enum values have to be exported to userspace since the formatting is not
> > > > done in the kernel. Without doing this perf maps RET_PF_FIXED and
> > > > RET_PF_SPURIOUS to 0, which results in incorrect output:
> 
> Oof, that's brutal.
> 
> > > >   $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
> > > >   $ perf script | head -1
> > > >    [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1
> > > >
> > > > Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.
> > > >
> > > > Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmutrace.h | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> > > > index efbad33a0645..55c7e0fcda52 100644
> > > > --- a/arch/x86/kvm/mmu/mmutrace.h
> > > > +++ b/arch/x86/kvm/mmu/mmutrace.h
> > > > @@ -244,6 +244,9 @@ TRACE_EVENT(
> > > >                   __entry->access)
> > > >  );
> > > >
> > > > +TRACE_DEFINE_ENUM(RET_PF_FIXED);
> > > > +TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> > > > +
> > > 
> > > If you're planning to send out a v3 anyway, it might be worth adding
> > > all the PF return code enums:
> > > 
> > > enum {
> > > RET_PF_RETRY = 0,
> > > RET_PF_EMULATE,
> > > RET_PF_INVALID,
> > > RET_PF_FIXED,
> > > RET_PF_SPURIOUS,
> > > };
> > > 
> > > Just so that no one has to worry about this in the future.
> 
> Until someone adds a new enum :-/
> 
> > Will do in v3. Thanks.
> 
> What about converting the enums to #defines, with a blurb in the comment
> explaining that the values are arbitrary but aren't enums purely to avoid this
> tracepoint issue?

That will make it possible for someone to accidentally introduce a new
RET_PF symbol with a duplicate value which will result in incorrect
behavior. I am leaning towards keeping it as an enum but adding a
comment that any new enums should be reexported in mmutrace.h.
