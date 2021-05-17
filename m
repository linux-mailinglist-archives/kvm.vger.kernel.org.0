Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5363E386DE8
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 01:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbhEQXw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 19:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344597AbhEQXwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 19:52:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65A7C061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 16:51:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k5so4542779pjj.1
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 16:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8p080PXTTnw/mGJdgaG2dRlb1VLC74jwJ4oms85ovM=;
        b=BJBxNVCnYLqjeBb2TLEgklDLswSa1dsafY3bTgcKnVrup8QGT5m+TmEtllrZ795rw6
         aTxT/UiSeqTuy/Np2IeXbxGsifga/wEo07a/3wu7K3/HHzHKqWounuEOoSZPzQrgNJIs
         KZ2rRzFf4Kor+Q5Zgq9OivlQjAQSgHIv/OQJJbefoLtRWQ98YzalqUYURo63Yb4lcx/+
         T67dkr6RCm/gVpXKKzRZGVpdZqWNAA7gXHiBA/2AhCTnWP36L2bKTNMW1t/xAcNS4gQ1
         0i4RyHECIh2yHR2wgnQAmS/iJOlCjt5D/OENmgPgnxqBRcxIB7PGvpLeY2az30vzleUW
         /6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8p080PXTTnw/mGJdgaG2dRlb1VLC74jwJ4oms85ovM=;
        b=HrRBR7i426lrJfpnt/AxrK82qJ1jB/drNxUD8iwuFypp9u11Bp9uomhGBovljguWM9
         fAvR4CHP3OgV8yJalTm9UQHUUEyLHYCPxo4G0o5oydTlRKCqXzM+SET6xykyftZOzo6V
         zOo7v4ElnPwI55L08rS5FC9UgbcsaDC3qY42jIBeWIUeyUvDun1hyyRCt5ia5Zc9VYzA
         tiWXP+AhtZLgRQ3mEtDjltRHQXcY4UszSici8HGAjisOesihic6V0dItdlzmt466i36C
         0gX3fErtb2J1SxmnbC8F58N10Lg7/qv5+iQruc1bmrK15Bhpf8azVrootqjiHaTY6yRw
         J7Ww==
X-Gm-Message-State: AOAM533Mre5T11hyANDoKiagSaSkSXbGYFE9uf33xjOeetteUbzpTbO3
        OvsLRyFHrU7bj3K1nxtgM4/iXQ==
X-Google-Smtp-Source: ABdhPJy8M5KJcW4TRV2dftH65iRsAgNwKFLBhhOCVmnyCTlC+Arb4tKW4flEnKoQ6PD5dAYF65aeBw==
X-Received: by 2002:a17:902:7144:b029:f0:d8e7:95a3 with SMTP id u4-20020a1709027144b02900f0d8e795a3mr1191431plm.52.1621295468069;
        Mon, 17 May 2021 16:51:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v6sm2731806pgk.33.2021.05.17.16.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:51:07 -0700 (PDT)
Date:   Mon, 17 May 2021 23:51:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Yao Yuan <yuan.yao@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
Message-ID: <YKMBZ5cs2siTorf1@google.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com>
 <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
 <YJvx4tr2iXo4bQ/d@google.com>
 <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
 <YKLdETM7NgjKEa6z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKLdETM7NgjKEa6z@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Sean Christopherson wrote:
> On Thu, May 13, 2021, Xu, Like wrote:
> > On 2021/5/12 23:18, Sean Christopherson wrote:
> > > On Wed, May 12, 2021, Xu, Like wrote:
> > > > Hi Venkatesh Srinivas,
> > > > 
> > > > On 2021/5/12 9:58, Venkatesh Srinivas wrote:
> > > > > On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
> > > > > > On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> > > > > > detect whether the processor supports performance monitoring facility.
> > > > > > 
> > > > > > It depends on the PMU is enabled for the guest, and a software write
> > > > > > operation to this available bit will be ignored.
> > > > > Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
> > > > > documented someplace?
> > > > The bit[7] behavior of the real hardware on the native host is quite
> > > > suspicious.
> > > Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
> > > current phrasing is a mess:
> > > 
> > >    Performance Monitoring Available (R)
> > >    1 = Performance monitoring enabled.
> > >    0 = Performance monitoring disabled.
> > > 
> > > The (R) is ambiguous because most other entries that are read-only use (RO), and
> > > the "enabled vs. disabled" implies the bit is writable and really does control
> > > the PMU.  But on my Haswell system, it's read-only.
> > 
> > On your Haswell system, does it cause #GP or just silent if you change this
> > bit ?
> 
> Attempting to clear the bit generates a #GP.

*sigh*

Venkatesh and I are exhausting our brown paper bag supply.

Attempting to clear bit 7 is ignored on both Haswell and Goldmont.  This _no_ #GP,
the toggle is simply ignored.  I forgot to specify hex format (multiple times),
and Venkatesh accessed the wrong MSR (0x10a instead of 0x1a0).

So your proposal to ignore the toggle in KVM is the way to go, but please
document in the changelog that that behavior matches bare metal.

It would be nice to get the SDM cleaned up to use "supported/unsupported", and to
pick one of (R), (RO), and (R/O) for all MSRs entries for consistency, but that
may be a pipe dream.

Sorry for the run-around :-/
