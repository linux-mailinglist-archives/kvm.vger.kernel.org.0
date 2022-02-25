Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82FA4C4E10
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiBYSxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiBYSxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:53:07 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA3328984
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:52:33 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e13so5567510plh.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7dNTJr5q++G+HEI8xxfjALjTub5ZXLo8DVC3Ljh+kyE=;
        b=NSDOuFp2RoBhAYqmgYPIBl/sqN0WzIMaNQnUJ/j912ElTGwDdxn+ONMwQRoT4jGjm7
         ANyokD8T1yBD7YZtI2i/sI7mKNs1OQEAWtHRGO5NfawcfXeW+9B5N2dzioGeh/6zq7Z2
         ANDM0HjWo/bHKifNrA/bySKjQ/lAWQ9v+JAYIJVhFc8DcMuAxh7nKQPjnwO0XckwAkJx
         pPx+D+GBgvy11kuxiVF/O88tQQWzCaeqRt6hJUPJn2GEwlPVBHMCuuSDbtZorJD+y0py
         O6QhpxhBDOJlV9ImAOzYEkh9tfSQhfNPiYgo2EWZFRYIJa8M+Qo2Zpk8Rqdp5pLLfyJ8
         7tcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7dNTJr5q++G+HEI8xxfjALjTub5ZXLo8DVC3Ljh+kyE=;
        b=6yMNYTuIfXWwxBS5oPCr5e6tT0LR/VGozdVUq+pKD6Opl7H/+qheU+z768TvWrTNVD
         N+wK0nGUXlc/1+3rAPk4KVtEjQ/GBTtJgIDuSHRMsIuKKsSphv3YZizdsrriEU+VyKsO
         Tk4oDnP+jNa5W+9+BLHCm+Z7a2619nai8Tv3UcYESfxV7HML/VqzrTR46U/71gMXgK/U
         4esoq1jXOKNYV5bEX6UjrKQB7u4FN78hn/5NPQxf6c5QCHeqwIk5tJxiRHrMA1T4OCUN
         0w/Q2rWeRbX/G0KWFlfNuU+8kFu4ib8xYg49ReqfmT6Sx21v8dFFI+kWd7YN24hjVseX
         95fA==
X-Gm-Message-State: AOAM532qQ5r2yK7NtnNEoj8dg0jqKViBe+Up5xKnH8z3zsf9IPFV0mBc
        0B1jskzVEhad94u6nBv5T0+o5g==
X-Google-Smtp-Source: ABdhPJwTfmdcyRiooN9YFNYHZwz54lNVcDJAqspFOY1cX7PJohuNNKI7950leqwKyvZvysW9mb124Q==
X-Received: by 2002:a17:90b:1104:b0:1b8:b90b:22c7 with SMTP id gi4-20020a17090b110400b001b8b90b22c7mr4522553pjb.45.1645815152764;
        Fri, 25 Feb 2022 10:52:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u19-20020a056a00159300b004e1590f88c1sm4319237pfk.220.2022.02.25.10.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 10:52:32 -0800 (PST)
Date:   Fri, 25 Feb 2022 18:52:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] [PATCH v2] KVM: Don't actually set a request when
 evicting vCPUs for GFN cache invd
Message-ID: <YhklbH6ZyYrZmmGw@google.com>
References: <20220223165302.3205276-1-seanjc@google.com>
 <2547e9675d855449bc5cc7efb97251d6286a377c.camel@amazon.co.uk>
 <YhkAJ+nw2lCzRxsg@google.com>
 <915ddc7327585bbe8587b91b8cd208520d684db1.camel@infradead.org>
 <YhkRcK64Jya6YpA9@google.com>
 <550e1d7ef2b2f7f666e5b60e9bb855a8ccc0fb14.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550e1d7ef2b2f7f666e5b60e9bb855a8ccc0fb14.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022, David Woodhouse wrote:
> On Fri, 2022-02-25 at 17:27 +0000, Sean Christopherson wrote:
> > On Fri, Feb 25, 2022, David Woodhouse wrote:
> > > On Fri, 2022-02-25 at 16:13 +0000, Sean Christopherson wrote:
> > > > On Fri, Feb 25, 2022, Woodhouse, David wrote:
> > > > > Since we need an active vCPU context to do dirty logging (thanks, dirty
> > > > > ring)... and since any time vcpu_run exits to userspace for any reason
> > > > > might be the last time we ever get an active vCPU context... I think
> > > > > that kind of fundamentally means that we must flush dirty state to the
> > > > > log on *every* return to userspace, doesn't it?
> > > > 
> > > > I would rather add a variant of mark_page_dirty_in_slot() that takes a vCPU, which
> > > > we whould have in all cases.  I see no reason to require use of kvm_get_running_vcpu().
> > > 
> > > We already have kvm_vcpu_mark_page_dirty(), but it can't use just 'some
> > > vcpu' because the dirty ring is lockless. So if you're ever going to
> > > use anything other than kvm_get_running_vcpu() we need to add locks.
> > 
> > Heh, actually, scratch my previous comment.  I was going to respond that
> > kvm_get_running_vcpu() is mutually exclusive with all other ioctls() on the same
> > vCPU by virtue of vcpu->mutex, but I had forgotten that kvm_get_running_vcpu()
> > really should be "kvm_get_loaded_vcpu()".  I.e. as long as KVM is in a vCPU-ioctl
> > path, kvm_get_running_vcpu() will be non-null.
> > 
> > > And while we *could* do that, I don't think it would negate the
> > > fundamental observation that *any* time we return from vcpu_run to
> > > userspace, that could be the last time. Userspace might read the dirty
> > > log for the *last* time, and any internally-cached "oh, at some point
> > > we need to mark <this> page dirty" is lost because by the time the vCPU
> > > is finally destroyed, it's too late.
> > 
> > Hmm, isn't that an existing bug?  I think the correct fix would be to flush all
> > dirty vmcs12 pages to the memslot in vmx_get_nested_state().  Userspace _must_
> > invoke that if it wants to migrated a nested vCPU.
> 
> Yes, AFAICT it's an existing bug in the way the kvm_host_map code works
> today. Your suggestion makes sense as *long* as we consider it OK to
> retrospectively document that userspace must extract the nested state
> *before* doing the final read of the dirty log.
> 
> I am not aware that we have a clearly documented "the dirty log may
> keep changing until XXX" anyway. But you're proposing that we change
> it, I think. There may well be VMMs which assume that no pages will be
> dirtied unless they are actually *running* a vCPU.
> 
> Which is why I was proposing that we flush the dirty status to the log
> *every* time we leave vcpu_run back to userspace. But I'll not die on
> that hill, if you make a good case for your proposal being OK.

Drat, I didn't consider the ABI aspect.  Flushing on every exit to userspace would
indeed be more robust.

> > > I think I'm going to rip out the 'dirty' flag from the gfn_to_pfn_cache
> > > completely and add a function (to be called with an active vCPU
> > > context) which marks the page dirty *now*.
> > 
> > Hrm, something like?
> > 
> >   1. Drop @dirty from kvm_gfn_to_pfn_cache_init()
> >   2. Rename @dirty => @old_dirty in kvm_gfn_to_pfn_cache_refresh()
> >   3. Add an API to mark the associated slot dirty without unmapping
> > 
> > I think that makes sense.
> 
> Except I'll drop 'dirty' from kvm_gfn_to_pfn_cache_refresh() too.
> There's no scope for a deferred "oh, I meant to tell you that was
> dirty" even in that case, is there? Use the API we add in your #3.

But won't we end up with a bunch of call sites that attempt to determine whether
not the dirty status needs to be flushed?  I'm specifically thinking of scenarios
where the status needs to be conditionally flushed, e.g. if the backing pfn doesn't
change, then it's ok to not mark the page dirty.  Not handling that in the refresh
helper will either lead to unnecessary dirtying or duplicate code/work.
