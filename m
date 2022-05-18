Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84CC52C013
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiERQhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiERQhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:37:47 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1B01A15F8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:37:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m12so2302349plb.4
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OlUGigunER2dUQovHcmZ08w4DbPhm8v/S8Qaa0mftNM=;
        b=g6AEVguYfYkUMW5pTSZT4JC8WIruEWrizuHoM9NBCSmpT54HponQsh+JSFHRJH5oes
         5xHoGHCW02PlVpG5ae5rU6f04G7MSNBoK52Q67Q/9WhQ74mK/0Y0eAzmnFLw2XxFATck
         NV6RsFpOVKY6eQIBVsyXraqc7zsxVev3AVJkgpQ4P6ZhuCWLZWzsTld4dKGx82tqZQjZ
         +nJJbZx0htV07O1aM5plILoLvR3dDPir09C6a2oDgiNeSXD138r4xlEde4LHIY1G0PSG
         iABe3D/KZb7Ui2LH+zVMyYbI7e0VupHtXd7EWaWHo1sPdq0IInND9NobPnLma3CmBKXA
         HkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OlUGigunER2dUQovHcmZ08w4DbPhm8v/S8Qaa0mftNM=;
        b=xz17ygG7FAuD1hakjLzXI/Gw5M3kJQA3MHemW0UfUg4I5+Jh0U6Q+WomL2zGx1yKZm
         tg+O05A4X74T/JG6auIvmu6H609wdCWR0cv6fqRuBeGoBr3jUnH9K9cC2kPtK1NzXunr
         nhjtqimHVKPQP7wXer+DUHiPTgVZOwT/k7+ASq3NWBo/+/dKPJOpDsKfAtLn3YmUBkVB
         XkvSkAeE0LpUZMCk4O74disFKQ6fI/VR7+DJ/S/WRl5dcUwLOdOOMf7Fiqrg8Pa3f2rZ
         kTWW8yGoVPrO0/Yt/ttwdFcsxgeZnaRsDJQlbwldvFN/BSZsj5FqF7rOdr7q3WBE6fs4
         RfVQ==
X-Gm-Message-State: AOAM530PW9F1pMIq/Rymn0MtqsI8wA4XIZfKbjSFYXvn92KaYEduo3Qe
        EQLb1PN4vDGsbwPgKLyX6D80yQ==
X-Google-Smtp-Source: ABdhPJywSP4hndDCPZEIjn0VwLPzwKqjE+0I1Dtt2M9SLG1nyqLRrRMOxdxRY6iieZ7YHnfkTtQpTw==
X-Received: by 2002:a17:902:7c13:b0:156:ca91:877f with SMTP id x19-20020a1709027c1300b00156ca91877fmr236602pll.15.1652891864884;
        Wed, 18 May 2022 09:37:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902710900b0015e8d4eb1c6sm1914791pll.16.2022.05.18.09.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:37:44 -0700 (PDT)
Date:   Wed, 18 May 2022 16:37:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
Message-ID: <YoUg1Fq1tMGISJX5@google.com>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local>
 <YoT5/TRyA/QKTsqL@xz-m1.local>
 <YoUPtB0KtRuWl4p7@google.com>
 <CALzav=crRhStBy8zouM964ygU7-n72LkMo0m0g4xc5un4Cp1mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=crRhStBy8zouM964ygU7-n72LkMo0m0g4xc5un4Cp1mA@mail.gmail.com>
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

On Wed, May 18, 2022, David Matlack wrote:
> On Wed, May 18, 2022 at 8:24 AM Sean Christopherson <seanjc@google.com> wrote:
> > Page table allocations are currently hardcoded to come from memslot0.  memslot0
> > is required to be in lower DRAM, and thus tops out at ~3gb for all intents and
> > purposes because we need to leave room for the xAPIC.
> >
> > And I would strongly prefer not to plumb back the ability to specificy an alternative
> > memslot for page table allocations, because except for truly pathological tests that
> > functionality is unnecessary and pointless complexity.
> >
> > > I don't think it's very hard - walk the mem regions in kvm_vm.regions
> > > should work for us?
> >
> > Yeah.  Alternatively, The test can identity map all of memory <4gb and then also
> > map "guest_test_phys_mem - guest_num_pages".  I don't think there's any other memory
> > to deal with, is there?
> 
> This isn't necessary for 4-level, but also wouldn't be too hard to
> implement. I can take a stab at implementing in v3 if we think 5-level
> selftests are coming soon.

The current incarnation of nested_map_all_1g() is broken irrespective of 5-level
paging.  If MAXPHYADDR > 48, then bits 51:48 will either be ignored or will cause
reserved #PF or #GP[*].  Because the test puts memory at max_gfn, identity mapping
test memory will fail if 4-level paging is used and MAXPHYADDR > 48.

I think the easist thing would be to restrict the "starting" upper gfn to the min
of max_gfn and the max addressable gfn based on whether 4-level or 5-level paging
is in use.

[*] Intel's SDM is comically out-of-date and pretends 5-level EPT doesn't exist,
    so I'm not sure what happens if a GPA is greater than the PWL.

    Section "28.3.2 EPT Translation Mechanism" still says:

    The EPT translation mechanism uses only bits 47:0 of each guest-physical address.

    No processors supporting the Intel 64 architecture support more than 48
    physical-address bits. Thus, no such processor can produce a guest-physical
    address with more than 48 bits. An attempt to use such an address causes a
    page fault. An attempt to load CR3 with such an address causes a general-protection
    fault. If PAE paging is being used, an attempt to load CR3 that would load a
    PDPTE with such an address causes a general-protection fault.
