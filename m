Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E050C59A8F3
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiHSWxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 18:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243173AbiHSWxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 18:53:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F5810E788
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:53:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y4so5268591plb.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=bxsKzsoodl9uJzFJZZrQwWPMoj9Im81AmgcsZB9Gfmw=;
        b=qt/sbuA4OKmJaHmOuxnwa2lGGy6KF/9YxtJ8CEBc62ECZi8/Xq0wY0tron+FkYYdUs
         X9/M4egtRP0lG6q4e8/IWltnCwwAIXqgqPcmV59AnmXMmxflSpitxJaAXuVmi8jeOb7u
         ZYWkCe4cfUOnwv+GJ6FAghcaXtVFWtU/VjFn+HZAKAe7LVuzmplI1YXQYgelBcp8xph3
         XxuS2HQx3IoH2+jqfCiCLhnkIeS5J/e3C/uJb7oa4kLmq1AEXHLKDQEqspeDUi54j69u
         rkCsWutnedC/95sn0+Cf9uinQ+8ih+35v91Myr1oidh4MK/5DNYfVzYMeF+QXp50vSUG
         yQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=bxsKzsoodl9uJzFJZZrQwWPMoj9Im81AmgcsZB9Gfmw=;
        b=NfmDaGiAQ3HnBCv3R8cvpzlw4NaSTptrqCJQN7ZVzaw3o/0AN1hGXXf2FsJoPGAq43
         feU3uvoX+/rQM8PwBASGj99mKxpBZ+TAp1J8Iy9bKr8/+Q6fpLiuRVC1K8hmI7f05AQe
         lx3QiauPtih/8aFoReACscnH3KEpc2Nfvu8427Uwf7lTbe0gGFOz1ByGo8VK5BA4GvTx
         v7EXnzYI4Rgvm4aPWYqqoSJGxmGx7VFGF0t066pcbo9CaOcr9GRg/Vs6cEUQXxjr46OR
         p8R71poIl1VPSFEXfFvJ4MKxD9Pera1CStQDmVPHzMYTbSiF5pZGdhJSoENVVh2x47mp
         WGEw==
X-Gm-Message-State: ACgBeo1V+OM6HppLGoxERhIXBBcLW7zGy/YYIX0b5I0kTEv4LdSGKLSe
        fgSIxZVsyCfELAGJLZ9R70IO1A==
X-Google-Smtp-Source: AA6agR5KPMZr3qT4HevDmGgIVF/eFJY3pV4hPcGRLPDFcNa+kb45vL5UZGGsRX6sXCEs8crjgoKfEw==
X-Received: by 2002:a17:90b:1b4a:b0:1f5:5578:6398 with SMTP id nv10-20020a17090b1b4a00b001f555786398mr10621956pjb.122.1660949586764;
        Fri, 19 Aug 2022 15:53:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h2-20020a63c002000000b0040cb1f55391sm3280975pgg.2.2022.08.19.15.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 15:53:06 -0700 (PDT)
Date:   Fri, 19 Aug 2022 22:53:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hugh Dickins <hughd@google.com>
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, luto@kernel.org,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        david@redhat.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH v7 00/14] KVM: mm: fd-based approach for supporting KVM
 guest private memory
Message-ID: <YwAUTk5BOkUQSF3B@google.com>
References: <20220706082016.2603916-1-chao.p.peng@linux.intel.com>
 <ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com>
 <20220818132421.6xmjqduempmxnnu2@box>
 <Yv7XTON3MwuC1Q3U@google.com>
 <226ab26d-9aa8-dce2-c7f0-9e3f5b65b63@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226ab26d-9aa8-dce2-c7f0-9e3f5b65b63@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Hugh Dickins wrote:
> On Fri, 19 Aug 2022, Sean Christopherson wrote:
> > On Thu, Aug 18, 2022, Kirill A . Shutemov wrote:
> > > On Wed, Aug 17, 2022 at 10:40:12PM -0700, Hugh Dickins wrote:
> > > > If your memory could be migrated, that would be some reason to use
> > > > filesystem page cache (because page migration happens to understand
> > > > that type of memory): but it cannot be migrated.
> > > 
> > > Migration support is in pipeline. It is part of TDX 1.5 [1]. 
> > 
> > And this isn't intended for just TDX (or SNP, or pKVM).  We're not _that_ far off
> > from being able to use UPM for "regular" VMs as a way to provide defense-in-depth
> 
> UPM? That's an acronym from your side of the fence, I spy references to
> it in the mail threads, but haven't tracked down a definition.  I'll
> just take it to mean the fd-based memory we're discussing.

Ya, sorry, UPM is what we came up with as shorthand for "Unmapping guest Private
Memory".  Your assumption is spot on, it's just a fancy way of saying "guest is
backed with inaccessible fd-based memory".

> > without having to take on the overhead of confidential VMs.  At that point,
> > migration and probably even swap are on the table.
> 
> Good, the more "flexible" that memory is, the better for competing users
> of memory.  But an fd supplied by KVM gives you freedom to change to a
> better implementation of allocation underneath, whenever it suits you.
> Maybe shmem beneath is good from the start, maybe not.

The main flaw with KVM providing the fd is that it forces KVM to get into the
memory management business, which us KVM folks really, really do not want to do.
And based on the types of bugs KVM has had in the past related to memory management,
it's a safe bet to say the mm folks don't want us getting involved either :-)

The combination of gup()/follow_pte() and mmu_notifiers has worked very well.
KVM gets a set of (relatively) simple rules to follow and doesn't have to be taught
new things every time a new backing type comes along.  And from the other side, KVM
has very rarely had to go poke into other subsystems' code to support exposing a
new type of memory to guests.

What we're trying to do with UPM/fd-based memory is establish a similar contract
between mm and KVM, but without requiring mm to also map memory into host userspace.

The only way having KVM provide the fd works out in the long run is if KVM is the
only subsystem that ever wants to make use of memory that isn't accessible from
userspace and isn't tied to a specific backing type, _and_ if the set of backing
types that KVM ever supports is kept to an absolute minimum.
