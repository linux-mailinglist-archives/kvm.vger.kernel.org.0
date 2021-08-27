Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774CE3FA173
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhH0WTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 18:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhH0WTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 18:19:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B22EC0613D9
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 15:18:57 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x16so6841480pfh.2
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 15:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rd2j1K7U4hRg00mMM07NvFIy1Z4HrCM8V2x0jTRZdHc=;
        b=Ir0TCeJ/oEbBpLCFe3DigxZyeNESMUbjXWFtm1bmgt5YKV0hkbuJC3dJVW7OhLbAYW
         +CNFaoOcUPqHJVf9zdoevfwQEwaVfK040RXUOHFWgMWxLAAxp0xml+kSW7SHxsweEJe/
         BY2m5dfkHfvXcKceHJf0H659WAY7HhITZt8TS4NCzCeyZvTfTi5eOxTJx+fvAXfQbbF1
         D8C85ucITkf1U4rC+rnF1l6C9PW/QXV/LLiIF9IvfD89GiHBX5uwCUV1Ots0Oaq+XSpe
         mau9V6tRrcLxcPyKK2aQ/onBId9GLdt6RecXowjcw4UOBOUlt4xSmOyrjeeuhojAN0qF
         ixqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rd2j1K7U4hRg00mMM07NvFIy1Z4HrCM8V2x0jTRZdHc=;
        b=OVG+4pXCSTSWknJ7ay3e+H0qlLPQkos9FRO7mqfJVo9PVq/Esuer3ms6JPlafkpSsa
         BYPKV9RFQ0KretjGMUVNOnylqxi7qf+w2lDc9PK/IPlo6LqMkg44KEXorulfdzCu4MlY
         qlw+83auBCF7g++v34kvp8SkIYzChgViPOg0zkGLx9auR2daprf7u6LVLP/tbnFAJ1Kv
         43PLAio+/31JxKlfeBvKDhWD/zM+F9G5BfIIT579pKh1UIt3H+gGrUKdEBxKbGCQ4uoJ
         UkSeoBAxXflwSl1Q0pxGL98UPzeqCj0X1ntG0V509b9lB/CMQz1Ob//0k1M1/Df+iRE/
         E0kQ==
X-Gm-Message-State: AOAM533K99VbTEAucGjYa5qYM74uYW/R3YBjC3bdsR+RInOm0GiraEtL
        WfIg6UdlrrlGOIk8RTsowgNy8A==
X-Google-Smtp-Source: ABdhPJzuJP6dIT72j2d/aCBLY9krrtGRa2afNkv9q820gAKetasQmVhVHa+tvbyJjtZXZL8dDZGGhg==
X-Received: by 2002:a62:6007:0:b029:3cd:e67a:ef9e with SMTP id u7-20020a6260070000b02903cde67aef9emr11198834pfb.72.1630102736650;
        Fri, 27 Aug 2021 15:18:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q1sm6782229pfj.132.2021.08.27.15.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 15:18:56 -0700 (PDT)
Date:   Fri, 27 Aug 2021 22:18:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <YSlkzLblHfiiPyVM@google.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, David Hildenbrand wrote:
> You'll end up with a VMA that corresponds to the whole file in a single
> process only, and that cannot vanish, not even in parts.

How would userspace tell the kernel to free parts of memory that it doesn't want
assigned to the guest, e.g. to free memory that the guest has converted to
not-private?

> Define "ordinary" user memory slots as overlay on top of "encrypted" memory
> slots.  Inside KVM, bail out if you encounter such a VMA inside a normal
> user memory slot. When creating a "encryped" user memory slot, require that
> the whole VMA is covered at creation time. You know the VMA can't change
> later.

This can work for the basic use cases, but even then I'd strongly prefer not to
tie memslot correctness to the VMAs.  KVM doesn't truly care what lies behind
the virtual address of a memslot, and when it does care, it tends to do poorly,
e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn mappings, and
that's reflected in the infrastructure.  E.g. KVM relies on the mmu_notifiers
to handle mprotect()/munmap()/etc...

As is, I don't think KVM would get any kind of notification if userpaces unmaps
the VMA for a private memslot that does not have any entries in the host page
tables.   I'm sure it's a solvable problem, e.g. by ensuring at least one page
is touched by the backing store, but I don't think the end result would be any
prettier than a dedicated API for KVM to consume.

Relying on VMAs, and thus the mmu_notifiers, also doesn't provide line of sight
to page migration or swap.  For those types of operations, KVM currently just
reacts to invalidation notifications by zapping guest PTEs, and then gets the
new pfn when the guest re-faults on the page.  That sequence doesn't work for
TDX or SEV-SNP because the trusteday agent needs to do the memcpy() of the page
contents, i.e. the host needs to call into KVM for the actual migration.

There's also the memory footprint side of things; the fd-based approach avoids
having to create host page tables for memory that by definition will never be
used by the host.
