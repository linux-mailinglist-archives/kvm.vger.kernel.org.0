Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E9B3C6276
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 20:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbhGLSOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 14:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGLSOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 14:14:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FF0C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:11:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t9so19126391pgn.4
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BVMqKJgQYY2UUy+riFV/F7sbRvAH1m7qGJyCKXwou0E=;
        b=VcDyBFYXpjCSlMcg0Rbb6LfnDFjJyL6uu3Tn0gTZKbx8xIK+HiMljJCGMkL/rLkpOF
         2CLkZVLK+TdIfrq8SZtf4qmDVIIEMPGqP0FhOcVUfPeSOzotBlFLEkNqf2Kc70hDqpz1
         jQwZDBwEoE7qg7nHH5xFDEVdVrlCdAdP0RX3IWyaIeSMtEi17lQ8VZfqWn9WDcVFT/mw
         Sq62OuM2m757PmvzdX11cyPhZd9EHQ1OU8PD2fQ1u0ThjVi+xRDwqOoB8YOeSU3X8FyP
         zKOzmoYHgF7Qqee00XGyWxoSXyHgKG5GqUE9IFwJOqw5CRm7tUZzb4yZwIyAJFpSluCW
         frGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BVMqKJgQYY2UUy+riFV/F7sbRvAH1m7qGJyCKXwou0E=;
        b=B0wZRTmlpV2Ik4VVQbNOn0H+lS4BaegxUBg0OTslJ3TjTnMday9JjgNAG400BQBBea
         nv0ihvnQ4cJNARRClc8gRivCOWHYbj5ReYyn7NKb/LXfn5XTihpz2CqgKxighYBlWdFC
         LhT0GvOFq+mF4872aHxZ0NQVntzqDaU8MB+Ihbsn472FRKqPlAdZuMqP5TT4NYxYm+29
         tv9qwp0NSzDhl6PAT3d+qhm63wx7T+UYrTTIpzbboRmy+zDNu/UyXEBW+6zwpkoLsbHH
         rMXHx4tQaMmjyv3CH1BOWdJ2/73DOcLJ0IrHt2I7W8NFI3LHjF6xfI9c9UH31rF6cY7l
         ao6w==
X-Gm-Message-State: AOAM531f541G8fSP2y+5ogXoFdAOhWzAmaksVjK+WYG1MJIYWTEp+oBl
        8LIiIoDtQkyFWC58Hr0kjg3y0Q==
X-Google-Smtp-Source: ABdhPJx5C1Nzyz1otcugjU4BdGOIxvKqePb+0/MXOn0Ybm/M8TwWC5PmzD1BmUJ+IhgcJOEq2em5Ow==
X-Received: by 2002:a05:6a00:1822:b029:32b:cf78:405 with SMTP id y34-20020a056a001822b029032bcf780405mr309265pfa.80.1626113505443;
        Mon, 12 Jul 2021 11:11:45 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z15sm18416797pgu.71.2021.07.12.11.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:11:44 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:11:41 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Fix use of enums in
 trace_fast_page_fault
Message-ID: <YOyF3fZY8mXk/3+6@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-3-dmatlack@google.com>
 <CANgfPd8zqOKjLeFCcYR-waHhDxb_6LX113o6Dv5uip8R_G3e8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8zqOKjLeFCcYR-waHhDxb_6LX113o6Dv5uip8R_G3e8g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 09:14:01AM -0700, Ben Gardon wrote:
> On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Enum values have to be exported to userspace since the formatting is not
> > done in the kernel. Without doing this perf maps RET_PF_FIXED and
> > RET_PF_SPURIOUS to 0, which results in incorrect output:
> >
> >   $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
> >   $ perf script | head -1
> >    [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1
> >
> > Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.
> >
> > Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmutrace.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> > index efbad33a0645..55c7e0fcda52 100644
> > --- a/arch/x86/kvm/mmu/mmutrace.h
> > +++ b/arch/x86/kvm/mmu/mmutrace.h
> > @@ -244,6 +244,9 @@ TRACE_EVENT(
> >                   __entry->access)
> >  );
> >
> > +TRACE_DEFINE_ENUM(RET_PF_FIXED);
> > +TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> > +
> 
> If you're planning to send out a v3 anyway, it might be worth adding
> all the PF return code enums:
> 
> enum {
> RET_PF_RETRY = 0,
> RET_PF_EMULATE,
> RET_PF_INVALID,
> RET_PF_FIXED,
> RET_PF_SPURIOUS,
> };
> 
> Just so that no one has to worry about this in the future.

Will do in v3. Thanks.

> 
> >  TRACE_EVENT(
> >         fast_page_fault,
> >         TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
> > --
> > 2.32.0.93.g670b81a890-goog
> >
