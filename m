Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C1E6A2600
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 01:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjBYAu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 19:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYAu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 19:50:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6571B2D9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 16:50:26 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s26so3929952edw.11
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 16:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rznQ2Ogm4D33TB32Lv+pmA0yIC9Of9RuAOzuizAtFv4=;
        b=Rr+6dYF3riKD9r0sRAOHImobEYlinle0qvRckkGJ549mYTdkcVZgg/0D09XCsiv5aq
         G8/EV4kPzZLAxDdirBmS8S8vDUGp72l//4wUpHrMtlF8UqO2PuWy6W5P+ycHUDqcMkkq
         gnY/oUveByG76GpK8/M1c+X5wIh2noGzGZWGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rznQ2Ogm4D33TB32Lv+pmA0yIC9Of9RuAOzuizAtFv4=;
        b=IWdbbtZvpimUToCQH9QU0my5QlOWPIYugQbRZroeR2kIdWaani9K6waFKQA+QQCqOn
         vafmSRu4RrMqkgfr/Mftl1SvGcgJHvBi36tIJQZMQxem2mscd8sZ38YaGUb1L3LRSCx2
         yLJ9GG2KvBdZrpmqyDU+HTGdR6XeGLeEd7pJfm+zgtPdXpP9rZ8bCI4LOz7l7/WK3Yc9
         Aq4H2+EhF+7is7auLADT2jXXk4XaP/CGEOUEX84ZnBW20bkneoCBpYKsNogh6POPaZv4
         VEFd+JgMgfce8loaO8EfAAAXTkULY8z/4Hna+nT99RgoXi6qXZDxHp0x6t6PNt89SaNs
         PWgg==
X-Gm-Message-State: AO0yUKVGCq4gJah1pnB2Rw3m/pEVdNTwAQ56NY2mcwevt9klRdLtQY1O
        /YQTPXAxRsXZweVN+gtJAq2lLdO8RLzyvuqUPzkRrw==
X-Google-Smtp-Source: AK7set/C7T1iAOzN8Qg0DajZUfOAHxwXVWkd6WmMixqvRimuJIWnt7sqIa+u5gxKVWxYX3soWu7Qkw==
X-Received: by 2002:aa7:df96:0:b0:4ac:c44e:a493 with SMTP id b22-20020aa7df96000000b004acc44ea493mr20101597edy.2.1677286224351;
        Fri, 24 Feb 2023 16:50:24 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id b27-20020a50ccdb000000b004aef48a8af7sm297250edj.50.2023.02.24.16.50.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 16:50:23 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id i34so4031592eda.7
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 16:50:23 -0800 (PST)
X-Received: by 2002:a17:906:8508:b0:8d0:2c55:1aa with SMTP id
 i8-20020a170906850800b008d02c5501aamr9236553ejx.0.1677286223336; Fri, 24 Feb
 2023 16:50:23 -0800 (PST)
MIME-Version: 1.0
References: <Y/Tlx8j3i17n5bzL@nvidia.com> <CAHk-=wiy2XRdvxchyuVYJJ618sAcGiPPam14z8yAW+kyCzgPmA@mail.gmail.com>
 <Y/lQIwcha1DFq2om@nvidia.com>
In-Reply-To: <Y/lQIwcha1DFq2om@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 16:50:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjM+p5K_MkM6COZou-u3S=6p1U4UsBHCaKximm5tT-Arg@mail.gmail.com>
Message-ID: <CAHk-=wjM+p5K_MkM6COZou-u3S=6p1U4UsBHCaKximm5tT-Arg@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 4:02 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> Do you like this sort of explanation in the email or the tag?

Either works, I really don't have a strong preference. Some people do
one, others do the other. And some people (like Rafael) do both - with
the summary list in the tag (and thus also as part of the pull
request), but an overview at the top of the email.

> Honestly, after 5 years (wow time flies) of sending PRs for rdma I'm
> still a bit unclear on the best way to write the tag message.

Heh. Probably because there isn't any "one correct" way. Whatever
works best for you.

The thing I personally care about is just that there _is_ an
explanation, and that it makes sense in the context of a human reader
who looks at the merge later.

So no automatically generated stuff that you could just get with some
git command anyway, but an actual overview.

And I'll edit things to make sense in a commit message anyway, so I'll
remove language like "This pull request contains.." because that
doesn't make sense once it's just a merge commit and no longer is a
pull request.

So I'll generally edit that kind of laniage down to "This contains.."
instead or something like that.

I also try to *generally* make the merge commit messages look roughly
the same, so that when people use wildly different whitespace (tabs vs
spaces) or use different bullet points - "-" vs "o" vs "*" etc) I
generally try to make those kinds of things also be at least
*somewhat* consistent.

And for that, it can certainly make my life easier if you look at what
merge messages look like, and don't try to make your pull request
message wildly different. But it's really not a big deal - I do that
kind of reformatting as part of simply reading the message, so it's
all fine.

Finally - remember that the merge message is for humans reading it
later, and not everybody necessarily knows the TLA's that may be
obvious to you as a maintainer of that subsystem. So try to make it
somewhat legible to a general (kernel developer) public.

And then if I feel like the message doesn't cover all of the changes,
I'll prod you, like I did in this case.

               Linus
