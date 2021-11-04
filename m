Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31CA445462
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 14:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhKDOAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 10:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhKDOAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 10:00:40 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D85C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 06:58:02 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id p17so5495878pgj.2
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 06:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J6SQdi7s3E5H+vjXCs1YEcND+ZzSy2UU02yujcY6scI=;
        b=f58CavIyrr1D8YaqKFXLcAEyOCA/u9zOjAozKpMPMggBTHgJd9TBxrLqKrJLrAcT0k
         ddBFw9ZKO8mJuQ/sLjbuENiR+uLPKbWwwo4ylv/b4QDTBZ0HL+P3nV9XD21iUmRD0gV2
         c29Kl050tjsTBeYASnCeaoPOj80ZjOL2eI4vPbKJZvNfpPqgGt23IxBACH6Scc650Mps
         bojPWb0ibVrkQa6F0kW1Qsh50WGHtdSZ2+ybc45RFZc+pQ0Fvzg0TEsvWm1Yl4Z0cNej
         yLrKEnrCIGr12Ru+SLf+GYSYAFuy4EOA2IYy70mg32jBhuO2Hw+EWlvn4w8SlTrrLkDt
         01mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J6SQdi7s3E5H+vjXCs1YEcND+ZzSy2UU02yujcY6scI=;
        b=2UcxLHH5ugUVqUw8gSyTfqCJ3t8+7QtuL38I87kBEgpZAsWwmCNYQz9A+q18FJftVz
         4VAURqSrLXdOCudozkngPRIpvSUGUDbTRk7Lr4wD1op6CxZETSuwjq/ba6rcLDekT5OV
         kIch4dLJWfGUNUrv6pPlNi5BwcOMguC7bAbPuM6UdmlIrmDl1A6daAh/k+p70RdmFG5r
         VPpvABtHp07bQ0FuExlx6ejb4wyY+1C4iHbd7YRxNvCKKm8umg6oyxVoAUqzhQvh0RAa
         QF6FenV7KIyYEVPlK+zVw98Rvs0zEU+njr8xVc2LG3fYEYnW3fYZI4hrxdWhyVCSsQNt
         JIpQ==
X-Gm-Message-State: AOAM532P1tjJY2dYSyyMkSfWkuLE1w0B+Ckfp153CI4xFmRo9RQ4yXoj
        WFtziNtw+6jEt4qo8120VRhTEg==
X-Google-Smtp-Source: ABdhPJyzkYr/yQgMwXyO/ROZ3931wThHZNOvnagfd1BHgc6gzK3Y76yRyb6ViaO5gg3NqkHVJsxFTg==
X-Received: by 2002:aa7:8755:0:b0:494:67a6:1c84 with SMTP id g21-20020aa78755000000b0049467a61c84mr3223903pfo.26.1636034281752;
        Thu, 04 Nov 2021 06:58:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v12sm4109756pjs.0.2021.11.04.06.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:58:01 -0700 (PDT)
Date:   Thu, 4 Nov 2021 13:57:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: Move INVPCID type check from vmx and svm to
 the common kvm_handle_invpcid()
Message-ID: <YYPm5eann2hCAryi@google.com>
References: <20211103205911.1253463-1-vipinsh@google.com>
 <20211103205911.1253463-3-vipinsh@google.com>
 <YYMZPKPkk5dVJ6nZ@google.com>
 <CAHVum0eFwgM-Pj6xHt0gkFCf1OZGjYD7K0xttswbAaGMo6zpJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eFwgM-Pj6xHt0gkFCf1OZGjYD7K0xttswbAaGMo6zpJQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Vipin Sharma wrote:
> On Wed, Nov 3, 2021 at 4:20 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Nov 03, 2021, Vipin Sharma wrote:
> > > Handle #GP on INVPCID due to an invalid type in the common switch
> > > statement instead of relying on the callers (VMX and SVM) to manually
> > > validate the type.
> > >
> > > Unlike INVVPID and INVEPT, INVPCID is not explicitly documented to check
> > > the type before reading the operand from memory, so deferring the
> > > type validity check until after that point is architecturally allowed.
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> >
> > For future reference, a R-b that comes with qualifiers can be carried so long as
> > the issues raised by the reviewer are addressed.  Obviously it can be somewhat
> > subjective, but common sense usually goes a long ways, and most reviewers won't
> > be too grumpy about mistakes so long as you had good intentions and remedy any
> > mistakes.  And if you're in doubt, you can always add a blurb in the cover letter
> > or ignored part of the patch to explicitly confirm that it was ok to add the tag,
> > e.g. "Sean, I added your Reviewed-by in patch 02 after fixing the changelog, let
> > me know if that's not what you intended".
> >
> > Thanks!
> >
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> I was not sure if I can add R-b as it was only for the code and not
> changelog. Good to know that I can ask such things in the cover letter
> or the ignored part of the patch.

Ah, that's my bad, that was indeed a very confusing way to phrase my contingent
review.
