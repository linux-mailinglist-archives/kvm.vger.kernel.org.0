Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC103C6447
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 21:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhGLT4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 15:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbhGLT4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 15:56:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EDBC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 12:54:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so13430259pjl.5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 12:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2kC3AHKI2Vk5PRS2CAxKTbgNaJgBm0j6weWq6g2m3m0=;
        b=vpx2SexthTwMylSDnAqIkDUNtE1o4HAgBL1emnxO6KoMj0XzDeLGUQd85Nd/+a/B42
         SZy+M4+okIA5gdT4mI0keWh/fboj9FQIkYE62pXciWOa8oYgHb7xt5RySdUTu7C4Chld
         ZjY56Ls1eodbcfzS3zQMc6/IpLmwI0iMOrcVTW6BylGMOEXm0ZoLtJ2S7mDpJZeb5nXg
         DpDPCjaFb38PrlCFWlIBM9XvxLCaKDnpn96JgKNGIoSjmRR1xjZrRmCStUtoWTYrEmga
         iTaw4C37wFhvQ411OnlW1QSunF+A0Y9rmgudBflJ3I8hsivPasB8bgAa5APVdJHPse+V
         hrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kC3AHKI2Vk5PRS2CAxKTbgNaJgBm0j6weWq6g2m3m0=;
        b=Eovw/Lh3Ki/kMDSmCKkMEkG18sjH1cWOaHW/qp56mKUJVelTL1fnlieQ1aA2bLWTuD
         EKqIt4l16Md8c/wlpfM4u/iYfiA4nUIUZBP5nXEDEDamuh1AXaFPEGir3PXlnQpE9wVI
         aT+UEPi5uv1oXguDiyTUFKgOCMKyL7h1z0xifBFXBQqRHaamm1AskRe69d9LyZRZ92YX
         RFfq1KKwrQxVKSF8tnAPSUnbbU72vQKHWoVjUXzgWTmAcAHzPz+vEWpEyB3Fiz3iLcTz
         MLR6Gr4uEarW/9U6D26whsG2tYXKpJhRxao31pCKPTsADw7SP/93nxAUEAyHuqN+AGXj
         ws2A==
X-Gm-Message-State: AOAM530guUHAqxICzzAYODKMsiSsugKFkncjhndBLpypy7Fvx2fsltFS
        9eE2/a0yoslDRM9ZPsMMruzvpg==
X-Google-Smtp-Source: ABdhPJxOfVhBcFvILQC5DUEbSzKzMqBd2T1Sp5F1eS+amV5DNuP97Sri1ecYC8+U49pQBSN9CH22mA==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr15611494pjg.183.1626119639555;
        Mon, 12 Jul 2021 12:53:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5sm12821292pfv.145.2021.07.12.12.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:53:59 -0700 (PDT)
Date:   Mon, 12 Jul 2021 19:53:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Fix use of enums in
 trace_fast_page_fault
Message-ID: <YOyd063LlhGUFjWD@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-3-dmatlack@google.com>
 <CANgfPd8zqOKjLeFCcYR-waHhDxb_6LX113o6Dv5uip8R_G3e8g@mail.gmail.com>
 <YOyF3fZY8mXk/3+6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOyF3fZY8mXk/3+6@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021, David Matlack wrote:
> On Mon, Jul 12, 2021 at 09:14:01AM -0700, Ben Gardon wrote:
> > On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > Enum values have to be exported to userspace since the formatting is not
> > > done in the kernel. Without doing this perf maps RET_PF_FIXED and
> > > RET_PF_SPURIOUS to 0, which results in incorrect output:

Oof, that's brutal.

> > >   $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
> > >   $ perf script | head -1
> > >    [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1
> > >
> > > Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.
> > >
> > > Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmutrace.h | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> > > index efbad33a0645..55c7e0fcda52 100644
> > > --- a/arch/x86/kvm/mmu/mmutrace.h
> > > +++ b/arch/x86/kvm/mmu/mmutrace.h
> > > @@ -244,6 +244,9 @@ TRACE_EVENT(
> > >                   __entry->access)
> > >  );
> > >
> > > +TRACE_DEFINE_ENUM(RET_PF_FIXED);
> > > +TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> > > +
> > 
> > If you're planning to send out a v3 anyway, it might be worth adding
> > all the PF return code enums:
> > 
> > enum {
> > RET_PF_RETRY = 0,
> > RET_PF_EMULATE,
> > RET_PF_INVALID,
> > RET_PF_FIXED,
> > RET_PF_SPURIOUS,
> > };
> > 
> > Just so that no one has to worry about this in the future.

Until someone adds a new enum :-/

> Will do in v3. Thanks.

What about converting the enums to #defines, with a blurb in the comment
explaining that the values are arbitrary but aren't enums purely to avoid this
tracepoint issue?
