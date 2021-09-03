Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770CB400394
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350112AbhICQlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350071AbhICQle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 12:41:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3AFC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 09:40:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j2so3638528pll.1
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 09:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5OTz7CnUkUM4eY5RTrhL/SW/NS0L0zb0w5yqF65JVM=;
        b=TPqUlE4vsj+zKa7HaWHKFrNz4FHIDAn1VSWdoDtvPEYoXf8j3FIgsnR9twTb/N5pvj
         hochQfiLmdYN9NkKeXN4J5YW4AwswTucve/tJoQVMtSdc6n+ApiJjtY9Stv1H5QKuwMl
         DRyAt5+yL8yNcb2k/HwRTL2qQuQAJt12PxlkYk9V599GuhEM2h0sIpDsW5qn5UOVrr7a
         JAUb+3M0HiCXbmMG42WsDG5DEAaRt09k0ej41GT+dO3gP0YGIBJysnKpAsZbif1xSX9m
         6knaPBoT/qU9Z0sqi7JvzIcCHgFHwroV+8FKRN8opAhREhMw/zdgbmTFH+SDkWDIMqCR
         YlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v5OTz7CnUkUM4eY5RTrhL/SW/NS0L0zb0w5yqF65JVM=;
        b=bBSmGc1HnA00c1fopnmTkUYKyXcrmt1WCdgZ8SvssL7vXc4HnqqItyte6YmwgGxyxN
         3Ne+LCyb+jZKgss/T9An9xZeTAjNdh5+Lm3Lt0HWyrNd3LdDfqYLkdXaKWsiT+QJo6ha
         pTC7UVOr/g+ukDls60P1vw3wc+sZLvL46AUwSlHv3cNgbyXhorClqhSAe+l5d38i8ENh
         U3VKhpas9jyb4xeg9LVPJBg5Eh7/dhmsKjmMmdRochXuCq6td48/jSQ3FMZ4hsweMcmD
         Pot30VvqtX9N8VYkPbmG7y6MdU05jH8EHGzY7paGdHSFE2cNZbxtSfgEOgVuFpZdDfTr
         lS6w==
X-Gm-Message-State: AOAM531VlJ1rcQP3GeXWIS1q0mEbsLGOWPEwEyrSxnTpkn6tef1BgwXy
        at9r4mZ6KoLhpfchGelltaVtuw==
X-Google-Smtp-Source: ABdhPJxsfc197jHbkx9JBnIoZeZb7rt2Q3NxA6CZylwJ388qYtxJuIhXoOH46UfW/xmk11ye2Ag/Sg==
X-Received: by 2002:a17:90a:55cb:: with SMTP id o11mr1730087pjm.244.1630687233610;
        Fri, 03 Sep 2021 09:40:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gd14sm5751960pjb.49.2021.09.03.09.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:40:32 -0700 (PDT)
Date:   Fri, 3 Sep 2021 16:40:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
Message-ID: <YTJP/Ys8Fdxdm/Qk@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com>
 <YTFhCt87vzo4xDrc@google.com>
 <YTFkMvdGug3uS2e4@google.com>
 <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
 <YTJIBr/lm5QU/Z3W@google.com>
 <7067bec0-8a15-1a18-481e-e2ea79575dcf@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7067bec0-8a15-1a18-481e-e2ea79575dcf@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 04, 2021, Lai Jiangshan wrote:
> 
> On 2021/9/4 00:06, Sean Christopherson wrote:
> 
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 50ade6450ace..2ff123ec0d64 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -704,6 +704,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >   			access = gw->pt_access[it.level - 2];
> >   			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
> >   					      it.level-1, false, access);
> > +			if (sp->unsync_children &&
> > +			    mmu_sync_children(vcpu, sp, false))
> > +				return RET_PF_RETRY;
> 
> It was like my first (unsent) fix.  Just return RET_PF_RETRY when break.
> 
> And then I thought that it'd be better to retry fetching directly rather than
> retry guest when the conditions are still valid/unchanged to avoid all the
> next guest page walking and GUP().  Although the code does not check all
> conditions such as interrupt event pending. (we can add that too)

But not in a bug fix that needs to go to stable branches.  
 
> I think it is a good design to allow break mmu_lock when mmu is handling
> heavy work.

I don't disagree in principle, but I question the relevance/need.  I doubt this
code is relevant to nested TDP performance as hypervisors generally don't do the
type of PTE manipulations that would lead to linking an existing unsync sp.  And
for legacy shadow paging, my preference would be to put it into maintenance-only
mode as much as possible.  I'm not dead set against new features/functionality
for shadow paging, but for something like dropping mmu_lock in the page fault path,
IMO there needs to be performance numbers to justify such a change.
