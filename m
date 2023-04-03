Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001C66D54E3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjDCWvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 18:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjDCWvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 18:51:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B464692
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 15:51:30 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5445009c26bso580893747b3.8
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 15:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680562290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+d5RZv/1MjrzRAjFcndjoUDKp9kKn03je3UOpUA/r8=;
        b=LF24+RFcNljooDefFdnbVos4FnIwnYU75Bjm2cJB6Get7nfXG9Xb8PemM27rZk6q8f
         2obG1OX8qMezb6ko6SAjxiFc9ipvmLqnMowuIOdnkmYp2QkbRXJtmt0eh6iyPxJ50W8S
         pFvtmdXOMITV44rvsngfETR1b+1J43FV0OlNpXtxy5aSzzIuzyxjWJIjstL2KU0S3fvI
         RThNpKyWbM0IH390JKxq/MH02tXdm9dcN+PzY3FSzD4gjYBPiJt769vDehE2Ql09E8uf
         9NzSBWd5afIrwTNwlgWdDsvYgNav0DRcEuDjGYPMh834NmEV1oVTMWoXSLyMJpZD2yz9
         IFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+d5RZv/1MjrzRAjFcndjoUDKp9kKn03je3UOpUA/r8=;
        b=6tHjPZlwpKK3tu71fJG12SSIesmQl+pCOExD0R31XE3cx4mx3EN6cgMj6lv4l6kb9A
         ZDC696JtdgNKIZ20LlPI7G9b65ZuJjESl7kZdympTqJVqOt5Q6aHltWO23FMufNWRi5g
         0dy66oqk4Yv8jQSbOI1cfhq1cL1O+Yfp3c1rnUMrxDsJOOQ9jKjjVxSkLXBEa2JpOdcR
         Micje0LA2zwiouYoGwYWpIPae48K7WbHI5ka7u65b0MeXxx15y5cpFh6gkpQjJidj2oh
         JNzSxuddLzTz+3cE0kft9IEIUdDz87htN2GoUbg4PhgTFtHcws64Xt1U/G3JUPbfLWf2
         ORHw==
X-Gm-Message-State: AAQBX9fbCXxqMSuKrScD6QzXANuIHodEeMNpseY0WmfHAoENIt6oBmST
        drCKU0afBgywOhtU3BHPVsravsqQwS3X1cOKm7264w==
X-Google-Smtp-Source: AKy350Y9Uw/8f7pazxV3PMYbY89EXnBeEuk/+Eklbdk/p1WwIt7ERal+SInGsYR1XEfjiFun6WMUTvg08leundjP2qM=
X-Received: by 2002:a81:e60d:0:b0:544:94fe:4244 with SMTP id
 u13-20020a81e60d000000b0054494fe4244mr322754ywl.10.1680562289601; Mon, 03 Apr
 2023 15:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-17-vipinsh@google.com>
 <ZCOEiVT31xEPKZ3H@google.com>
In-Reply-To: <ZCOEiVT31xEPKZ3H@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 3 Apr 2023 15:50:53 -0700
Message-ID: <CAHVum0cEMmHMQY=9S17eNjP7cfTOPSz0MG4v3Avzs6p+3Bb07g@mail.gmail.com>
Subject: Re: [Patch v4 16/18] KVM: x86/mmu: Allocate numa aware page tables
 during page fault
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 5:21=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Mar 06, 2023 at 02:41:25PM -0800, Vipin Sharma wrote:
> > +                     r =3D mmu_topup_sp_memory_cache(&vcpu->arch.mmu_s=
hadow_page_cache[nid],
> > +                                                   PT64_ROOT_MAX_LEVEL=
);
>
> This ignores the return value of mmu_topup_sp_memory_cache() for all but
> the last node.
>

Yeah, I will change it to exit the function on the first error.

> >  static int mmu_memory_cache_try_empty(struct kvm_mmu_memory_cache *cac=
he,
>
> nit: s/cache/caches/
>

Okay.

> > -                                   struct mutex *cache_lock)
> > +                                   int cache_count, struct mutex *cach=
e_lock)
>
> nit: s/cache_count/nr_caches/

Okay.

>
> >  {
> > -     int freed =3D 0;
> > +     int freed =3D 0, nid;
>
> nit: s/nid/i/
>
> (nothing in this function knows about NUMA so "nid" is an odd name here)

Okay.

> > +static inline bool kvm_numa_aware_page_table_enabled(struct kvm *kvm)
> > +{
> > +     return kvm->arch.numa_aware_page_table;
>
> No need for this helper function. Accessing the variable directly makes
> lines shorter, does not introduce any code duplication, and reduces
> abstraction.
>

Okay.
