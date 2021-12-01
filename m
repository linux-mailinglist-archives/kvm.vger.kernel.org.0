Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEB4656F8
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 21:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352920AbhLAUUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 15:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352921AbhLAUUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 15:20:24 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC10C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:17:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b13so18602582plg.2
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 12:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oxe9/TSVu6V7Nxp9vuY7vKO8sJu+J+68IwlCkOcIOoM=;
        b=hrA6yCB+jCTivvnoNrJz+OU9DlB9MNQhMH/2SZpjtuf7mZUmOREuchOO33vSXiIWOi
         xdNQaL7wZLr8squyH2h3s6L5Brc5NDAxOE/314OP8K0DspINdhvN/Gu7HDLrZlUHiJL+
         dQxcnNBdSprzSi7/ZzKjx7LKCZVWTArkPdlkmJ+VqnVo8oJkiKHfiwMOvifyZ/i8WyOX
         snaOBFOQtYDMPRJIvjdsFr58NzPwiaYhnynU26V01gtSd3WfKloTga51GG4/LltrUX8Z
         QQFgZCHVgCfOmhh082ZzSPKjcOE0+g5d6hIIm3W0MuGFResQ1A7ulRmKG0gugsuvOaIr
         X1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oxe9/TSVu6V7Nxp9vuY7vKO8sJu+J+68IwlCkOcIOoM=;
        b=E7gXgDdM9ADdMmioF4t27q3WiYPaK9DQQSdPkP9ppP0SxK9jp7hJzTQsxMU56iASHi
         VVJXwjLm0uDNghH9zwtJuyshg9CLytrWC1DF43Je5n+D+7es4aVrDg3t7+cas+bUZwfN
         QZLPqya8+oDkqb2oZkRSSZrccgSXaj/EUJgPofb6m5kKxCxjQmsiIWkD2cnLUorNzkNw
         iDz5gu/7Vir/Nx7WfvXWHPhXkZo60XrjzOOcUDPMBV3pA1MF0xIn92s1MsDLoAsIC7I3
         nNFkmIL8/y11OJrpQQG4I84Ikf/LkvKYp2QLv4y03ar2DoYlng0PsedjxCQDXQbi0DEg
         1giQ==
X-Gm-Message-State: AOAM5308DELHPm/GwwMPHaGpirBohGSJ3X9AVzVOyDOuYZTmKI//wkO5
        ljz8hHUT2qjytxXQEeiwoHUI7w==
X-Google-Smtp-Source: ABdhPJwvIs1G/smkDDu8bqp58NCas7vWbMshtA/JXJVWg6ZDcOHgxt0wtNaFAbtSQt1xr3e65AGCcA==
X-Received: by 2002:a17:90a:c08a:: with SMTP id o10mr586638pjs.44.1638389821865;
        Wed, 01 Dec 2021 12:17:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d17sm646427pfo.40.2021.12.01.12.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 12:17:01 -0800 (PST)
Date:   Wed, 1 Dec 2021 20:16:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during
 CLEAR_DIRTY_LOG
Message-ID: <YafYOYdMqxzWiHRL@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-14-dmatlack@google.com>
 <YafLdpkoTrtyoEjy@google.com>
 <CANgfPd_K9kBu9Fd83wx0heMiWziLthg9tXD=6GsvLsFd0GapYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_K9kBu9Fd83wx0heMiWziLthg9tXD=6GsvLsFd0GapYA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Ben Gardon wrote:
> On Wed, Dec 1, 2021 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
> > I would prefer we use hugepage when possible, mostly because that's the terminology
> > used by the kernel.  KVM is comically inconsistent, but if we make an effort to use
> > hugepage when adding new code, hopefully someday we'll have enough inertia to commit
> > fully to hugepage.
> 
> In my mind "huge page" implies 2M and "large page" is generic to 2m
> and 1g. (IDK if we settled on a name for 1G pages)

What about 4m PSE pages?  :-)

I'm mostly joking, but it does raise the point that trying to provide unique names
for each size is a bit of a fools errand, especially on non-x86 architectures that
support a broader variety of hugepage sizes.  IMO, the least ambiguous way to refer
to hugepages is to say that everything that isn't a 4k page (or whatever PAGE_SIZE
is on the architecture) is a hugepage, and then explicitly state the size of the
page if it matters.

> I've definitely been guilty of reinforcing this inconsistent
> terminology. (Though it was consistent in my head, of course.) If we
> want to pick one and use it everywhere, I'm happy to get onboard with
> a standard terminology.

I hear you on using "large page", I've had to undo a solid decade of "large page"
terminology from my pre-Linux days.  But for better or worse, the kernel uses
hugepage, e.g. hugetlbfs supports 1gb and 2mb pages.  I think we should follow
the kernel, especially since we have aspirations of unifying more of KVM's MMU
across multiple architectures.
