Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715F153AB21
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356165AbiFAQjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356158AbiFAQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:39:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F396984A0B
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:39:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so3643443pjm.2
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wK7IQvCXp2ZCJCGEGfLT3eYpmPsVYsXObUJzOzw7FAk=;
        b=OveyVZHY0lWABqK7bwx0PA2MLG0OmZwoUbW7hNm0PSnDl3K8aOIy1JhvBr7UzUuQgy
         LLxrvdvNQBca3DVVXPKahA7f2ubtZDX83G/w0umL5ECtE1yWtM43++kt3J3dPcW8gTPv
         SXVhiA5Cm+L6PkWXcY7itDEQgUsrrv8FXvP60RnyEJkhARYWm7La2GkIwMiN5NVuXYeW
         KhZtCiv1LTE5eCJpShHoNEB0LWfY9gMAler2hlZWDF2mCBsW6RNKBjGiBYfsZC9NSiuq
         I2CN8+ckNrUwWd4j+IVbwMdHg8z+k8rNAWZiP74w7xY46v4SRj0VgopaUdIFkIYBlvj5
         EjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wK7IQvCXp2ZCJCGEGfLT3eYpmPsVYsXObUJzOzw7FAk=;
        b=LJxJrr4scKb8ZEqhCIYlW2tN4oBT3dg5PVEEMwkOWbVxTz/HB3QDR466N/5LI+jDgJ
         Y/7l3Kn6AEeBRHv4H/bO9MsWbjStnl2TrHBHVosdpIripyB/0eEHJLd+rLWdsZXa+vtn
         OK26MkORK5ESsIuZenGTcQlMFCcmPWPoZc6z5dR5KlTRJcSyXQpjnpmqpUgmNCCmjAHa
         1+06qaBVHJOMmT/QZKyLOp3/KcrExjRtPCe8i6VzcZ+wzmzsQ6qH+nmHjP8ftjOPpAnb
         iMd4L4VeFiLdOblIbvoi6MqypttqKBmoGDccMsIc5NgQPHltoHa+i1HucgirEAMu0oki
         xUWQ==
X-Gm-Message-State: AOAM5330bel0sXUsk1Y/SaeUBYJ+kcVLDnpVuIPYVb3S05R9jPxgDctN
        b4Ub4S+bGkCowWviuD9Gc6ZnDw==
X-Google-Smtp-Source: ABdhPJxPJXaiXKIePh05lDxQOEUCaz2E+Dhu8dQKM4GGQVF3tZL8FFbz+1CVgr3F2eaAh4v2bR8PTQ==
X-Received: by 2002:a17:902:7c03:b0:162:1a2d:5b2c with SMTP id x3-20020a1709027c0300b001621a2d5b2cmr314685pll.107.1654101568218;
        Wed, 01 Jun 2022 09:39:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902bf4a00b00163fa4b7c12sm1789725pls.34.2022.06.01.09.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 09:39:27 -0700 (PDT)
Date:   Wed, 1 Jun 2022 16:39:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Message-ID: <YpeWPAHNhQQ/lRKF@google.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com>
 <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022, Like Xu wrote:
> On 1/6/2022 2:37 am, Sean Christopherson wrote:
> > Can we just punt this out of kvm/queue until its been properly reviewed?  At the
> > barest of glances, there are multiple flaws that should block this from being
> 
> TBH, our reviewers' attention could not be focused on these patches until the
> day it was ready to be ravaged. "Try to accept" is a good thing, and things need
> to move forward, not simply be abandoned to the side.

I strongly disagree, to put it mildly.  Accepting flawed, buggy code because
reviewers and maintainers are overloaded does not solve anything, it only makes
the problem worse.  More than likely, the submitter(s) has moved on to writing
the next pile of patches, while the same set of people that are trying to review
submissions are left to pick up the pieces.  There are numerous examples of
accepting code without (IMO) proper review and tests costing us dearly in the
long run.

If people want their code to be merged more quickly, then they can do so by
helping address the underlying problems, e.g. write tests that actually try to
break their feature instead of doing the bare minimum, review each others code,
clean up the existing code (and tests!), etc...  There's a reason vPMU features
tend to not get a lot of reviews; KVM doesn't even get the basics right, so there's
not a lot of interest in trying to enable fancy, complex features.

Merging patches/series because they _haven't_ gotten reviews is all kinds of
backwards.  In addition to creating _more_ work for reviewers and maintainers,
it effectively penalizes teams/companies for reviewing each other's code, which
is seriously fubar and again exacerbates the problem of reviewers being overloaded.
