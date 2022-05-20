Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB052F5DF
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 00:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353958AbiETWtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 18:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiETWtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 18:49:45 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BAD179C1A
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:49:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bq30so16684443lfb.3
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wyp4OBNWnTnVSC4YoOUX/97QXWLKr+ui7XetRX8z1tM=;
        b=WGJqdyKdjg2hGcgT523VjGrSmpG5gZWBUwOfO31WP1aRrExoZKXdeE77X1HsAjdux/
         uP28kw7vyqVRMRMGjK4GKZHWECfQrlGDs4zUIiCMDpHz7O8yFb2kzK3oA08owwIviTuA
         uO7jJLQGU9spwcyPXDKibuP0EeE8CT31rcZO3vOLivDzr7CY3GKD6UkJxylP1JS+xx87
         I8UUMgjMCH+kKUL/74w43jd8yBTWp3RzHg8ilDcBP05H4ff2vmtFuuziq9BxLYq99+Qd
         PabmLGBPvk7+hd5Iv0YhMMlgnCqhqHZjXpb9V7Ac+AQpbRZaYCNtMM/52V71vkyfxuqo
         dQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wyp4OBNWnTnVSC4YoOUX/97QXWLKr+ui7XetRX8z1tM=;
        b=plkeyZqwe76QAqnJl1urQwNhB+oR5NTGnkGH0sXX/RZ1ZY5W7ja1vZk8nXCevPadcN
         SsUtyN1YxiJfsxlyhCzzZ2o49SiuSJnnPPN+rHVihq6nc3TviDG9XmGrSA68+Ci/GA6y
         q3tHFZddO7XTHinIyy2+NJEmm8GBIcG9c81pD8fr3gAEgXj0/CqGbYzBi/TYjcbropy7
         BjngNC2IHNmH+vkIislVSuQrbzsX6wBE71qB3IwyDtW8T5vyih0KHW2pndlYeeTBEeez
         boNDX9Z3h9r/cobswtOpOi/8PJ0X9m47GprqqyAq2Odo1xm6gsaPSnY7wWD9QyVnbRtb
         mlyw==
X-Gm-Message-State: AOAM533CEkSZLsr3GyG0bJgx3EAvSuZsZ33aWJjg6Xa2SCizLHZWHqDK
        rGGxZgRt5CLtMGXyXAaO6NsLbZgPkRiRFiXB4d32Iw==
X-Google-Smtp-Source: ABdhPJwAcnsBa/e0zpVKQ+pILMOvCHFuEvd/j70ubV8HdaZZBd1UwCchjVGUq97ZhiKZ6rif3MfxP7OS9ZxRe2n5jIg=
X-Received: by 2002:a05:6512:1502:b0:474:28db:7b37 with SMTP id
 bq2-20020a056512150200b0047428db7b37mr8486202lfb.250.1653086982449; Fri, 20
 May 2022 15:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com> <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local> <YoT5/TRyA/QKTsqL@xz-m1.local>
 <YoUPtB0KtRuWl4p7@google.com> <CALzav=crRhStBy8zouM964ygU7-n72LkMo0m0g4xc5un4Cp1mA@mail.gmail.com>
 <YoUg1Fq1tMGISJX5@google.com> <CALzav=eNHA5r2CT9t6i5q18dkCrVakY5f0M+5CsSEZA1auiVXw@mail.gmail.com>
In-Reply-To: <CALzav=eNHA5r2CT9t6i5q18dkCrVakY5f0M+5CsSEZA1auiVXw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 20 May 2022 15:49:16 -0700
Message-ID: <CALzav=dGQx+U=zeNZtUDANg2D=4GAMiqHqFS-jEs4dR1Ydf22w@mail.gmail.com>
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

On Fri, May 20, 2022 at 3:01 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, May 18, 2022 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, May 18, 2022, David Matlack wrote:
> > > On Wed, May 18, 2022 at 8:24 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > Page table allocations are currently hardcoded to come from memslot0.  memslot0
> > > > is required to be in lower DRAM, and thus tops out at ~3gb for all intents and
> > > > purposes because we need to leave room for the xAPIC.
> > > >
> > > > And I would strongly prefer not to plumb back the ability to specificy an alternative
> > > > memslot for page table allocations, because except for truly pathological tests that
> > > > functionality is unnecessary and pointless complexity.
> > > >
> > > > > I don't think it's very hard - walk the mem regions in kvm_vm.regions
> > > > > should work for us?
> > > >
> > > > Yeah.  Alternatively, The test can identity map all of memory <4gb and then also
> > > > map "guest_test_phys_mem - guest_num_pages".  I don't think there's any other memory
> > > > to deal with, is there?
> > >
> > > This isn't necessary for 4-level, but also wouldn't be too hard to
> > > implement. I can take a stab at implementing in v3 if we think 5-level
> > > selftests are coming soon.
> >
> > The current incarnation of nested_map_all_1g() is broken irrespective of 5-level
> > paging.  If MAXPHYADDR > 48, then bits 51:48 will either be ignored or will cause
> > reserved #PF or #GP[*].  Because the test puts memory at max_gfn, identity mapping
> > test memory will fail if 4-level paging is used and MAXPHYADDR > 48.
>
> Ah good point.
>
> I wasn't able to get a machine with MAXPHYADDR > 48 to test today so
> I've just made __nested_pg_map() assert that the nested_paddr fits in
> 48 bits. We can add the support for 5-level paging or your idea to
> restrict the perf_test_util gfn to 48-bits in a subsequent series when
> it becomes necessary.

Nevermind I've got a machine to test on now. I'll have a v4 out in a
few minutes to address MAXPHYADDR > 48 hosts. In the meantime I've
confirmed that the new assert in __nested_pg_map() works as expected
:)

>
> >
> > I think the easist thing would be to restrict the "starting" upper gfn to the min
> > of max_gfn and the max addressable gfn based on whether 4-level or 5-level paging
> > is in use.
> >
> > [*] Intel's SDM is comically out-of-date and pretends 5-level EPT doesn't exist,
> >     so I'm not sure what happens if a GPA is greater than the PWL.
> >
> >     Section "28.3.2 EPT Translation Mechanism" still says:
> >
> >     The EPT translation mechanism uses only bits 47:0 of each guest-physical address.
> >
> >     No processors supporting the Intel 64 architecture support more than 48
> >     physical-address bits. Thus, no such processor can produce a guest-physical
> >     address with more than 48 bits. An attempt to use such an address causes a
> >     page fault. An attempt to load CR3 with such an address causes a general-protection
> >     fault. If PAE paging is being used, an attempt to load CR3 that would load a
> >     PDPTE with such an address causes a general-protection fault.
