Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E6854D130
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 20:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358141AbiFOSwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 14:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357844AbiFOSwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 14:52:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B1CBC88
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 11:52:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso2897590pjk.0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 11:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ip6O/g5R03OCVltlbCtU+5cNEdXFPPe5H228MiaYA54=;
        b=lOk5DXWpZ/5yg/QJeC1fv4OQ+BlA5jw4LoBTEhsvILo+7JcOiIR9HM4x8sIlgpwGgq
         Ov4JFYoP/vAK2N5ObPEQsaXgKv52yMz8RjdnJGXTqfNKFiwSCXhzGAJPpVxanddGWhDK
         H9DgpK242qy6TXGFZtQ0cIQWQawJ6FdP5cJoihcYmpxivo3cmDOqrREg817DgxnspZfF
         EuKR0Kja2TEHOL+nLbcdDumqSjLW3eUTSCRL2c6bH4fEDABBQviTt4zTyBaSCVSToFJ5
         3fUAlQaXuybCF8/E9JxFJWTZ+IGL6ZavRwa4NT1uyWM6YqSDD88vMTlPMfYPlVsCl1Oz
         7u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ip6O/g5R03OCVltlbCtU+5cNEdXFPPe5H228MiaYA54=;
        b=eKz0YtdOj1oV2SPCk+hEMbD4jJR4dBI6xfMj+qmcJpFOsNp1di271cZIepfx+w4OZC
         tRLSBCQfkaZs+amNnJyHMD7CAncr0QUhp/+fTmZK163zbHp6DvdmzmHGiYSOQM4vl2W3
         ML6c/vigaPLLPwyoKnSDFTZ0PjonqjkfIkx/E19t0o7SQZSLEohN3L9TGRvHgLP5+rs7
         g5dkAUNvRAZipT0z0iRT73UCbC6idBKnq406n/FYLwv0DCEFeNhk4O6StLbdyoBGS4JM
         dxaRB52jyvLEFvvKxlGTdzgD83Z8jaaW5FJcSSilw7aUbUlRltmExK9LaU7FTZtvpDth
         PxMQ==
X-Gm-Message-State: AJIora8CNfWN1XS/p6KMT68Y3vEa8fbCZLT87QtZz+Q8kONUKi/RcTt+
        5OSbCq2TPLAxqudYIFbsTiJccQ==
X-Google-Smtp-Source: AGRyM1utEtd0UqhSJPN62EAFwSGgD1yGz0iJFyjfshJNTVSgJkkmGTW9enltsodEoMPCbOR6dbx+ww==
X-Received: by 2002:a17:902:ed53:b0:166:3e43:7522 with SMTP id y19-20020a170902ed5300b001663e437522mr1145403plb.170.1655319147675;
        Wed, 15 Jun 2022 11:52:27 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b00163f7935772sm9707823plb.46.2022.06.15.11.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 11:52:27 -0700 (PDT)
Date:   Wed, 15 Jun 2022 18:52:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Message-ID: <YqoqZjH+yjYJTxmT@google.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com>
 <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
 <YpeWPAHNhQQ/lRKF@google.com>
 <cbb9a8b5-f31f-dd3b-3278-01f12d935ebe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbb9a8b5-f31f-dd3b-3278-01f12d935ebe@gmail.com>
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

On Thu, Jun 02, 2022, Like Xu wrote:
> Thanks for your sincerity, always.
> 
> On 2/6/2022 12:39 am, Sean Christopherson wrote:
> > On Wed, Jun 01, 2022, Like Xu wrote:
> > > On 1/6/2022 2:37 am, Sean Christopherson wrote:
> > > > Can we just punt this out of kvm/queue until its been properly reviewed?  At the
> > > > barest of glances, there are multiple flaws that should block this from being
> > > 
> > > TBH, our reviewers' attention could not be focused on these patches until the
> > > day it was ready to be ravaged. "Try to accept" is a good thing, and things need
> > > to move forward, not simply be abandoned to the side.
> > 
> > I strongly disagree, to put it mildly.  Accepting flawed, buggy code because
> > reviewers and maintainers are overloaded does not solve anything, it only makes
> > the problem worse.  More than likely, the submitter(s) has moved on to writing
> > the next pile of patches, while the same set of people that are trying to review
> > submissions are left to pick up the pieces.  There are numerous examples of
> > accepting code without (IMO) proper review and tests costing us dearly in the
> > long run.
> 
> I actually agree and understand the situation of maintainers/reviewers.
> No one wants to maintain flawed code, especially in this community
> where the majority of previous contributors disappeared after the code
> was merged in. The existing heavy maintenance burden is already visible.
> 
> Thus we may have a maintainer/reviewers scalability issue. Due to missing
> trust, competence or mastery of rules, most of the patches sent to the list
> have no one to point out their flaws.

Then write tests and run the ones that already exist.  Relying purely on reviewers
to detect flaws does not and cannot scale.  I agree that we currently have a
scalability issue, but I have different views on how to improve things.

> I have privately received many complaints about the indifference of our
> community, which is distressing.
> 
> To improve that, I propose to add "let's try to accept" before "queued, thanks".
> 
> Obviously, "try to accept" is not a 100% commitment and it will fail with high
> probability, but such a stance (along with standard clarifications and requirements)
> from reviewers and maintainers will make the contributors more concerned,
> attract potential volunteers, and focus the efforts of our nominated reviewers.
> 
> Such moves include explicit acceptance or rejection, a "try to accept" response
> from some key persons (even if it ends up being a failure), or a separate
> git branch,
> but please, don't leave a lasting silence, especially for those big series.

I completely agree on needing better transparency for the lifecycle of patches  
going through the KVM tree.  First and foremost, there need to be formal, documented 
rules for the "official" kvm/* branches, e.g. everything in kvm/queue passes ABC
tests, everything in kvm/next also passes XYZ tests.  That would also be a good 
place to document expectations, how things works, etc...

At that point, I think we could add e.g. kvm/pending to hold patches that have  
gotten the "queued, thanks" but haven't yet passed testing to get all the way to
kvm/queue.  In theory, that would eliminate, or at least significantly reduce, the
non-trivial time gap between applying them locally and actually pushing to kvm/queue.

I'll work on writing rules+documentation and getting buy-in from Paolo.

That said, I'm still opposed to pivoting to a "let's try to accept" approach.
IMO, a major part of the problem is lack of testcases and lack of _running_ what
tests we do have.  To be blunt, it's beyond frustrating infuriating that a series
that's at v12 breaks _existing_ KVM-Unit-Tests on any AMD host.  And that same
series wasn't accompanied by any new testcases.

Yes, a kvm/pending or whatever would help mitigate such issues, but that doesn't
fundamentally reduce the burden put on maintainers/reviewers.  Basic issues such
as breaking KUT should be caught before a series is posted.  I realize there are
exceptions, e.g. folks from Intel and AMD may not have access to the right
hardware, but given that you're also posting AMD specific patches, I don't think
that exception applies here.  And yes, mistakes will happen, I've certainly been
guilty of my share, but I fully expect any such mistakes to be caught well before
getting to v12.

The other way to reduce maintainer/reviewer burden is by writing thorough testcases.
A thorough, well-documented test not only proves that the code works, it also shows
to reviewiers that the developer actually considered edge cases and helps expedite
the process of thinking through such edge cases.  E.g. taking arch LBRs as an
example, a test that actually visited every edge in KVM's state machine for enabling
and disabling MSR intercepts would improve confidence that the code is correct and
would greatly help reviewers understand the various combinations and transitions.

I fully realize that writing tests is not glamorous, and that some of KVM's tooling
and infrastructure is lacking, but IMO having contributors truly buy-in to writing
tests for testing's sake instead of viewing writing tests as a necessary evil to get
accepted upstream would go a long, long way to helping improve the overall velocity
of KVM development.

> Similar moves will increase transparency in decision making to reward and
> attract a steady stream of high quality trusted contributors to do more and more
> for our community and their employers (if any).
> 
> > 
> > If people want their code to be merged more quickly, then they can do so by
> > helping address the underlying problems, e.g. write tests that actually try to
> > break their feature instead of doing the bare minimum, review each others code,
> > clean up the existing code (and tests!), etc...  There's a reason vPMU features
> > tend to not get a lot of reviews; KVM doesn't even get the basics right, so there's
> > not a lot of interest in trying to enable fancy, complex features.
> 
> I'd like know more about "KVM doesn't even get the basics right" on vPMU. :D

https://lore.kernel.org/all/CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com
https://lore.kernel.org/all/YofCfNsl6O45hYr0@google.com
