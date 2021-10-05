Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF5423258
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 22:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhJEUwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhJEUwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 16:52:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83986C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 13:50:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w11so231322plz.13
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 13:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufDynw4w9jyskv/P+HbPa9cXwzI1YknB6kHVhHr9BcA=;
        b=ZWil7ceXnpZ+DmjivDzOEafE2JD5EeD+5HFPPT/JyujSL7n+m1Tp3bUJ0oK8uD+Eus
         MS69xg+3ic7saoEA8J/XQdhDNQfL9lsyBzwZ85V/Gj2XuuHeLKZ2WgYFWPtZmneU7bf5
         hIncfqontJdsy24RauTotr5yc4vLRJAaAbjLik9Qa3qbi4z+p4TgYot/7aM3nDdCd504
         muk0mqKohgCEa3sm/RTWm57TdQA9s6iz5+aFu/RskPK99ae+Bd/JAJKuMwMSYrFqHrJv
         hMl/sMvBE/S00BNmXG3eEZN64k9Nro16KWOlwBuaaRF9P3Hwi68gm9Te2o1polpCcmeU
         gvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufDynw4w9jyskv/P+HbPa9cXwzI1YknB6kHVhHr9BcA=;
        b=UIGpR74Dr3swOkgkZ9XeoszDCYILyf2mIdyZbousFPz91D/WPTeBnLA9+NxlDFDVPW
         Z10443gfsqic7g5gLQVve1NpabvmLsmtqNaFHfzfpF7zAB3agixe36TBVrrQZMTt+a6a
         PKDAeUnS/P+YSfct7UuIKVcqmWN9bkeeoc+fsBduSsaB1CeephGPUIMXXol9gkQT6SeQ
         J5hXM5oMEpyQzxzokDOVfMVPWfWE+S2AVBVCRLjn0MaJ9z7vT9V5C1PlyjXHpko6jLgt
         AUZoFvZkAjuik1aPijTnOGjFGktpKOhJDspErh4zf9GgwqtBVBYX1OA1OO0fSsPTQqLo
         1tmQ==
X-Gm-Message-State: AOAM532R8yja9zGNjFV+tlRMXz5afZPEDRNd80g/wyZQYjLnoZKfRP4a
        LTllOT8C+1XjBAM2QyrG39giFQ==
X-Google-Smtp-Source: ABdhPJxQqHmZCBy0xRrqRwn66T8/aCk72AIJ61vDGCVP8vzG48JUja0UbgSO1Wn77hEt+EH2sB8B2A==
X-Received: by 2002:a17:90a:5a86:: with SMTP id n6mr6293342pji.3.1633467014750;
        Tue, 05 Oct 2021 13:50:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g19sm2975497pjl.25.2021.10.05.13.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 13:50:14 -0700 (PDT)
Date:   Tue, 5 Oct 2021 20:50:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YVy6gj2+XsghsP3j@google.com>
References: <YR2Tf9WPNEzrE7Xg@google.com>
 <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com>
 <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com>
 <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com>
 <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com>
 <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021, Jim Mattson wrote:
> On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > > > >       You also said, "This is quite the complicated mess for
> > > > > something I'm guessing no one actually cares about.  At what point do
> > > > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > > > -- I couldn't agree more.
> > > >
> > > > ...
> > > >
> > > > > So, Sean, can you help converge our discussion and settle next step?
> > > >
> > > > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > > > the proverbial rug?
> > >
> > > Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> > > hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> > > unreasonable for VM-exit statistics, so maybe I've got a warped
> > > perspective. I'm all for pedantic adherence to the specification, but
> > > I have to admit that no actual hypervisor is likely to care (or ever
> > > will).
> >
> > It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
> > working correctly, both now and in the future.
> 
> As far as CPU feature virtualization goes, this one doesn't seem that
> complex to me. It's not anywhere near as complex as virtualizing MTF,
> for instance, and KVM *claims* to do that! :-)

There aren't many things as complex as MTF.  But unlike MTF, this behavior doesn't
have a concrete use case to justify the risk vs. reward.  IMO the odds of us breaking
something in KVM for "normal" use cases are higher than the odds of an L1 VMM breaking
because a VMREAD/VMWRITE didn't fail when it technically should have failed.
