Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55BD52F572
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350317AbiETWBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 18:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiETWBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 18:01:48 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4977E5F8EF
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:01:47 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id v9so1774279lja.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2OmtdSFD1MOiuv/tuyQsaDrVVINJk96M3FnQI70Ddo=;
        b=n3Yffo9NkUibpVn4n87BJbYaSaoympIWdbwV7uAdxUpJ11c4Vdwq90YUtFpkRZiEOt
         nxK3XvPd9vcn2dGmxZbYItWoN08ORJc417Yw8wOT2NY7Nlo67n7zHhYdGjSaW/cLL8z1
         f9Hb+TYFQhwaB79CzigkUEhFVRV9lFx7UctbFbwYNHSjVMKkPNMgZr3VCDmTjkIQXR0B
         7vnLhdZEt761atn65wMlznUZQDMfB06ktBhbB+JaWZx50aRtOSFqMlXcQJxuckNesJK6
         7uFG8M8s+IgpEg0LGNeBIHpvBT+baPxWcDo8ld2oZnJJn+CReIUNyc68BnlOygJx0C9M
         c7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2OmtdSFD1MOiuv/tuyQsaDrVVINJk96M3FnQI70Ddo=;
        b=8MN96uIRJ+erYwdalN+UDiZUzyW9Ewz/3ftTnwWmEe826YI+fttpI11zCaImD8sx1q
         gO7aMUoNujJGVxQr+ngWzDtUpEMWlbMMSAnH9sYD8FA38PYxkzRzCjrz4JzQcHujPV5v
         4nRFwlJmVquxfdTmty6/Iy2NZbewYly5PDLLYxfhNgm1uk6Lexs20UkWef78LHjexIsW
         GCNlV/VAkU0cTLnYopXJOw9x+2vku/rk0FY0MkH2XIOtLUdxwuQ+gUo7odv1x2vlj6p9
         QTE2prb8pem70YWzTKJGMeKMs+kLl/9vF5hq6otZeCqOuOLs9AyDlooolWzX9ehbEiwd
         CACA==
X-Gm-Message-State: AOAM533SFaEjKD2pCtD4MCHNHjb7s1eB0UBL+5+DnJChmC8Lqj+IMhRD
        slrqqPwyanpPeQ48+Pt2uiR/AlcST1U27LLauLS7xQ==
X-Google-Smtp-Source: ABdhPJzcYqbi5Qav+egSHtPAhDz9Lt9ZIfepNDGCdVFGrED9NxPcs1huaU7W8bZlEFzQxrRq309g8gxXVwuXBbK4K+Y=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr6723577ljk.16.1653084105418; Fri, 20
 May 2022 15:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com> <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local> <YoT5/TRyA/QKTsqL@xz-m1.local>
 <YoUPtB0KtRuWl4p7@google.com> <CALzav=crRhStBy8zouM964ygU7-n72LkMo0m0g4xc5un4Cp1mA@mail.gmail.com>
 <YoUg1Fq1tMGISJX5@google.com>
In-Reply-To: <YoUg1Fq1tMGISJX5@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 20 May 2022 15:01:18 -0700
Message-ID: <CALzav=eNHA5r2CT9t6i5q18dkCrVakY5f0M+5CsSEZA1auiVXw@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, May 18, 2022 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 18, 2022, David Matlack wrote:
> > On Wed, May 18, 2022 at 8:24 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Page table allocations are currently hardcoded to come from memslot0.  memslot0
> > > is required to be in lower DRAM, and thus tops out at ~3gb for all intents and
> > > purposes because we need to leave room for the xAPIC.
> > >
> > > And I would strongly prefer not to plumb back the ability to specificy an alternative
> > > memslot for page table allocations, because except for truly pathological tests that
> > > functionality is unnecessary and pointless complexity.
> > >
> > > > I don't think it's very hard - walk the mem regions in kvm_vm.regions
> > > > should work for us?
> > >
> > > Yeah.  Alternatively, The test can identity map all of memory <4gb and then also
> > > map "guest_test_phys_mem - guest_num_pages".  I don't think there's any other memory
> > > to deal with, is there?
> >
> > This isn't necessary for 4-level, but also wouldn't be too hard to
> > implement. I can take a stab at implementing in v3 if we think 5-level
> > selftests are coming soon.
>
> The current incarnation of nested_map_all_1g() is broken irrespective of 5-level
> paging.  If MAXPHYADDR > 48, then bits 51:48 will either be ignored or will cause
> reserved #PF or #GP[*].  Because the test puts memory at max_gfn, identity mapping
> test memory will fail if 4-level paging is used and MAXPHYADDR > 48.

Ah good point.

I wasn't able to get a machine with MAXPHYADDR > 48 to test today so
I've just made __nested_pg_map() assert that the nested_paddr fits in
48 bits. We can add the support for 5-level paging or your idea to
restrict the perf_test_util gfn to 48-bits in a subsequent series when
it becomes necessary.

>
> I think the easist thing would be to restrict the "starting" upper gfn to the min
> of max_gfn and the max addressable gfn based on whether 4-level or 5-level paging
> is in use.
>
> [*] Intel's SDM is comically out-of-date and pretends 5-level EPT doesn't exist,
>     so I'm not sure what happens if a GPA is greater than the PWL.
>
>     Section "28.3.2 EPT Translation Mechanism" still says:
>
>     The EPT translation mechanism uses only bits 47:0 of each guest-physical address.
>
>     No processors supporting the Intel 64 architecture support more than 48
>     physical-address bits. Thus, no such processor can produce a guest-physical
>     address with more than 48 bits. An attempt to use such an address causes a
>     page fault. An attempt to load CR3 with such an address causes a general-protection
>     fault. If PAE paging is being used, an attempt to load CR3 that would load a
>     PDPTE with such an address causes a general-protection fault.
