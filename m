Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602924168C2
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 02:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbhIXAMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 20:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243647AbhIXAMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 20:12:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC58C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:10:37 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so33236413lfu.2
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VxZeFbR4E7xxPJCmTTyjYQKyIz5peux0bk1U/xy3G6I=;
        b=l+AunnTgJrQqJkKsILPKbax24xaGk0dIslYaSBTg0MSiwnIfTGn/sFyPZx1A6uYQlc
         oouqtsvvmdVQLni8Wwnz+mN7Z5nlf9bSQmQgzM7jXncTdwTcbLM5HvLC4scq/2tqE2pT
         wyzpEYtDJGmw69mfPtldn3shuvRrFLVsz67+nw9nroJbapyT1ACRqW1Gg/mhOd7Joe57
         u4SLavD9gqSYYuf2YGc+fswPti1Qo7i1Ct3z28ySHyr67morY8UaxoPeXCQV8Utv5z94
         boG6d1YT93QdiMcJIkR53+gpWVqvOgfQBxW8Rk4mOD6dz1wVyaCH6KYJjKuvMmsGkUQT
         v9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VxZeFbR4E7xxPJCmTTyjYQKyIz5peux0bk1U/xy3G6I=;
        b=grNVMPhMfgJsLcJvMFJiyZqkdr/Fb+w8VOfSMLfqqzKnjOZKg+lJfVZnsRMdolcuuT
         KxICctQppvDPY3EMIJy4fhpASqmknEX6nFgHx8tKO1jbHq/ZaKjh5A/q/fXQUslyhtKZ
         JDiTnEUdYTqJEq299GfkKY2zrEyYpxq6+nBcM9Q/kLpRV5D8TWJGgERw+HgdQ1eKX1hr
         pRvgBM+yGtGdHMcAJXAa7OTbKHLNgEBFl9rxVtXUPqi2FD5snOmWJOZErSxsQy2XZ/HY
         MRohj37gRK4aDP/SJrWrXKi0ZVE4q9DU1P49xgIc9qYEtN6S1GSbcR74GvBrRgseRKGc
         DfIA==
X-Gm-Message-State: AOAM530ey2hpisbs0wzdmf17iJStOU6/IXTlLdrwaQuMo6Da0dZnHPRo
        055Bt1iEzXPraYQuF4fIyATg+MRSZOfZNTVdwqhk84DBNmzD2A==
X-Google-Smtp-Source: ABdhPJwNJGRAfmMrQR4DFQ6LLjl4z3IwJ+nmfkcZS2ytMg1WLwXuftcrJlYDFN+Ld3LoJBq/yOXW7gjRs4KlLHvUbjY=
X-Received: by 2002:ac2:488f:: with SMTP id x15mr501645lfc.553.1632442235973;
 Thu, 23 Sep 2021 17:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210923220033.4172362-1-oupton@google.com> <YU0XIoeYpfm1Oy0j@google.com>
In-Reply-To: <YU0XIoeYpfm1Oy0j@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 23 Sep 2021 17:10:24 -0700
Message-ID: <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in rseq_test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 5:09 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 23, 2021, Oliver Upton wrote:
> > While x86 does not require any additional setup to use the ucall
> > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > ucall to userspace. rseq_test does not initialize the MMIO address,
> > resulting in the test spinning indefinitely.
> >
> > Fix the issue by calling ucall_init() during setup.
> >
> > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > index 060538bd405a..c5e0dd664a7b 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> >        * CPU affinity.
> >        */
> >       vm = vm_create_default(VCPU_ID, 0, guest_code);
> > +     ucall_init(vm, NULL);
>
> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> going to remember to add this next time I write a common selftest, arm64 is the
> oddball here.

I think that is best, I was planning on sending out a fix that does
this later on. Just wanted to stop the bleeding with a minimal patch
first.

--
Thanks,
Oliver
