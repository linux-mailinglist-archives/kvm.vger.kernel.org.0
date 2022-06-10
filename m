Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2E545A06
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 04:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiFJCYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 22:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiFJCYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 22:24:35 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7201C590D
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 19:24:34 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c3-20020a9d6843000000b0060c2c63c337so1605083oto.5
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 19:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l+sjJxNdsKADQ/J8eNaTnZSw0i6Oxiv2jiRlZ9i5+Zk=;
        b=ZsH5x+IOk166EWG8Xe0O2cOPHhbPWCexYSwfVbwEwVsESVZvW60NaLXUtbzur0ToQZ
         d15269fk2EIl5E+wO/ni2SJff33zw3i/TQM9osjrTkjqCySxyp0r6+RyjUnWzxH0kGzb
         lAMZAvuzjPXLLP6jnbirAHy0e/UZ3t2mUh4gq72gxyIzJBPQykWkO84smFCc6vOzt17U
         eO9WEp+BE4f5lpr+u6dRyTyrlWvgBg97BL4iWGgfAgy7Xv4JU5YGV8QqHPM+3HKynKYl
         6pXcjUUTIj5FP0nryM3R4k1uX0uIwaBUkrpfQ15kkqhXdVm7xczL4MGF+SHIOnSgv2CI
         asDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l+sjJxNdsKADQ/J8eNaTnZSw0i6Oxiv2jiRlZ9i5+Zk=;
        b=I+Xs34f+6k1Zitx7f9h+5ibHc6dfslr/IgS7FsQ1/6PmYz7Z2uYiwSd4FzzW0b3ahy
         0JthRYGJxR1eouOr20BlQ0lR4ng41O4usfFW6Wq3WXyc4fl5mNC+UWxiM9rgVJjBi1s2
         +aeeRbp11c9avp1X8QV41Df1ya/HfPO13KWq595IvGV51qAtxmFnmooixjSZjb8lyUcM
         vmnUTj2nCS4cyH1jA839bsh0QiMAWNRQvmo9PdTg7IekL/6SwgG+2yba/6MdWWtBqYk4
         oOb10WkxYIW17pdis+DgB4HNQWF72URrqv131BCZYYBRFyHpFcHgRs+sy+kb4ZvyqrC8
         vp5A==
X-Gm-Message-State: AOAM530TC6Z0PQjzr7Rkwn5oue1cLWAkfNNAfxKftCEC3QnH/IuPhM9M
        LSAoD5S82vdLlcPKJP9aGulGq9wqHz8bDdTGzDu5A8gcGSLhOg==
X-Google-Smtp-Source: ABdhPJyPdj7yv+TYWYrC9Aq8JF7kMhBoHUwIUHIHiIqL7GiSvenXXYDvwPauN7mt9SsRFO7yy29jOPtj+v3O6ZB2u1M=
X-Received: by 2002:a9d:808:0:b0:60c:37:6fcf with SMTP id 8-20020a9d0808000000b0060c00376fcfmr9285717oty.75.1654827873692;
 Thu, 09 Jun 2022 19:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com> <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
In-Reply-To: <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jun 2022 19:24:22 -0700
Message-ID: <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jun 9, 2022 at 6:47 PM Yang, Weijiang <weijiang.yang@intel.com> wro=
te:
>
>
> On 6/10/2022 8:14 AM, Like Xu wrote:
> > On 9/6/2022 4:39 pm, Yang Weijiang wrote:
> >> executing rdpmc leads to #GP,
> >
> > RDPMC still works on processors that do not support architectural
> > performance monitoring.
> >
> > The #GP will violate ISA, and try to treat it as NOP (plus EAX=3DEDX=3D=
0)
> > if !enable_pmu.
>
> After a quick check in SDM, I cannot find wordings supporting your above
> comments, can you
>
> point me to it?

In volume 2,  under RDPMC...

o  If the processor does not support architectural performance
monitoring (CPUID.0AH:EAX[7:0]=3D0), ECX[30:0] specifies the index of
the PMC to be read. Setting ECX[31] selects =E2=80=9Cfast=E2=80=9D read mod=
e if
supported. In this mode, RDPMC returns bits 31:0 of the PMC in EAX
while clearing EDX to zero.

For more details, see the following sections of volume 3:
19.6.3 Performance Monitoring (Processors Based on Intel NetBurst
Microarchitecture)
19.6.8 Performance Monitoring (P6 Family Processor)
19.6.9 Performance Monitoring (Pentium Processors)

> Another concern is, when !enable_pmu, should we make RDPMC "work" with
> returning EAX=3DEDX=3D0?
>
> Or just simply inject #GP to VM in this case?

Unless KVM is running on a Prescott, it's going to be very difficult
to emulate one of these three pre-architectural performance monitoring
PMUs. There certainly isn't any code to do it today. In fact, there is
no code in KVM to virtualize the NetBurst PMU, even on Prescott.

I think Like is being overly pedantic (which is usually my role).
RDPMC should behave exactly the same way that RDMSR behaves when
accessing the same counter. The last time I looked, RDMSR synthesizes
#GP for PMC accesses when !enable_pmu.
