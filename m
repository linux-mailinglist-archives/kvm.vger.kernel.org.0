Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5457E4EE13E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbiCaTCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiCaTCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:02:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7101C8A91
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:01:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j13so413296plj.8
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6xhUFLRScuyFCnUhUoIR3SPfrzjg+j6qyCN8RW8eGig=;
        b=cuv4YQG5MhHIlxGxGuK8VWdC9U8nDgoP1kzwTDzs5EyNCNy8rN4SwPQDWAVBywvesN
         EvNGP8X7KSwj1vBpUHEBsRnkaTffUo6CSmYbWuEuRADNw5vRD25X3RFa9nFHwdMRofzg
         5kQXICBz5BsL25hQAMVOjA8L6Fy8AI1yifJs5EpM/CUH1MQa5AOr8V1Dh2SfBMF1hH02
         mN+HrQRF5mAaEP8fkB5MCMsFD9+90nPv4oy5b91NYlNHk+f7Vyv8zsIQHIrVaBD+c21W
         /yEHBJRog/07hBAPKfz6+2NGxVuXoQXEFSgzCJDdPIWX6C3UEJEe5SVyyJpb1Rq3vqcN
         6TwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6xhUFLRScuyFCnUhUoIR3SPfrzjg+j6qyCN8RW8eGig=;
        b=AL8/gQ40s2/QqTTyPlexsRxlc6Cg+3Mnw1PSCdJ+/IPoagW9l3Ei0n8gAvUU1emo7b
         6e25RDzE0H/40G1yL7Wqpphr7EwPk7hKPwac729DQC9S008bvsBPmpdwSAkspTfkNCxt
         jQk5LaTo5KRJonrVO/QCyhDhqXqN7b4TyX+/OVPAI5hBlSJwXfSobajRcg2zjBs7zCH7
         GXZnBS7diovtdPpQZhVOsHbUC9B4RQBEwXzOz1qD+ZjvQ0xiSlIYxvpKpXIoBdmhBLuJ
         4LE06rjG8ZAITuFF/R3bqWFpjl3JabptMcv82JqmZPlX6yjDGrVVaver5s8HTfCwiWBZ
         6snA==
X-Gm-Message-State: AOAM530Y3Tx9dF0AAotDNswlI15STJUEFbAh0/r9zi2UOI0UVKjmRKmy
        c6uNhj93x1lqTDd4f0x+7EJJAw==
X-Google-Smtp-Source: ABdhPJw0AlKQbF+uCKjX/JX2oHG2v/Udn6CSrjjBxCsVX8kCItH/3f8mL7O11osIreTtmhUbeaWsqw==
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id p11-20020a1709026b8b00b0014d66c4f704mr43195285plk.53.1648753260011;
        Thu, 31 Mar 2022 12:01:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm225805pfh.143.2022.03.31.12.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:00:59 -0700 (PDT)
Date:   Thu, 31 Mar 2022 19:00:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     "Nikunj A. Dadhania" <nikunj@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Message-ID: <YkX6aKymqZzD0bwb@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com>
 <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
 <YkSz1R3YuFszcZrY@google.com>
 <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com>
 <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
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

On Thu, Mar 31, 2022, Peter Gonda wrote:
> On Wed, Mar 30, 2022 at 10:48 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
> > On 3/31/2022 1:17 AM, Sean Christopherson wrote:
> > > On Wed, Mar 30, 2022, Nikunj A. Dadhania wrote:
> > >> On 3/29/2022 2:30 AM, Sean Christopherson wrote:
> > >>> Let me preface this by saying I generally like the idea and especially the
> > >>> performance, but...
> > >>>
> > >>> I think we should abandon this approach in favor of committing all our resources
> > >>> to fd-based private memory[*], which (if done right) will provide on-demand pinning
> > >>> for "free".
> > >>
> > >> I will give this a try for SEV, was on my todo list.
> > >>
> > >>> I would much rather get that support merged sooner than later, and use
> > >>> it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
> > >>> term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
> > >>> memory.
> > >>
> > >>> That would require guest kernel support to communicate private vs. shared,
> > >>
> > >> Could you explain this in more detail? This is required for punching hole for shared pages?
> > >
> > > Unlike SEV-SNP, which enumerates private vs. shared in the error code, SEV and SEV-ES
> > > don't provide private vs. shared information to the host (KVM) on page fault.  And
> > > it's even more fundamental then that, as SEV/SEV-ES won't even fault if the guest
> > > accesses the "wrong" GPA variant, they'll silent consume/corrupt data.
> > >
> > > That means KVM can't support implicit conversions for SEV/SEV-ES, and so an explicit
> > > hypercall is mandatory.  SEV doesn't even have a vendor-agnostic guest/host paravirt
> > > ABI, and IIRC SEV-ES doesn't provide a conversion/map hypercall in the GHCB spec, so
> > > running a SEV/SEV-ES guest under UPM would require the guest firmware+kernel to be
> > > properly enlightened beyond what is required architecturally.
> > >
> >
> > So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting
> > KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared
> > pages to the hypervisor, this information can be used to mark page shared/private.
> 
> One concern here may be that the VMM doesn't know which guests have
> KVM_FEATURE_HC_MAP_GPA_RANGE support and which don't. Only once the
> guest boots does the guest tell KVM that it supports
> KVM_FEATURE_HC_MAP_GPA_RANGE. If the guest doesn't we need to pin all
> the memory before we run the guest to be safe to be safe.

Yep, that's a big reason why I view purging the existing SEV memory management as
a long term goal.  The other being that userspace obviously needs to be updated to
support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
would be to restrict it to new VM types that have a disclaimer regarding additional
requirements.

[*] I believe Peter coined the UPM acronym for "Unmapping guest Private Memory".  We've
    been using it iternally for discussion and it rolls off the tongue a lot easier than
    the full phrase, and is much more precise/descriptive than just "private fd".
