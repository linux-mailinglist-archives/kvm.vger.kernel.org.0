Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F572441F75
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 18:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhKARoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 13:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhKARoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 13:44:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74625C061766
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 10:41:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so16549483pjl.2
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 10:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rtTqRA7823rLhhDHR/FeABtCXlD+vQwUZXFhSKbl7nw=;
        b=otcBvN/3IcuDrr15J0K5CvKDj9ic0jccTokbwB/sVPFst2f0LLD/XC7PPmPO9eJXRu
         P2OBNUe1RlpO0zOo26l/3DPAdKxfcfvQY3tyTT+VRt2u50F02VgF8OTA49ToznF2ILGt
         Yy6m85iKMGx1XCrOjugojlIHRrq3kXSGg8wFybO1VALqYGLus50IE17TDpBh8OqfqKK1
         AAKVEsJcdEBK8202Jfb1yydMhJbNy9mJ8dChJ1pRBEEAKk0vwWevUCT/VxYAjLKOhhmx
         ip94OeR4ZQJbCq2qfgBZUaSsgLQoBT6PDF+7fUOqfu8QIWy5qh2RFzJV0Hmhvl6+AMgp
         M0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtTqRA7823rLhhDHR/FeABtCXlD+vQwUZXFhSKbl7nw=;
        b=rs3Zs5s5A8KTiY2q1rr+YZw3+S3+ToGcs4ntEoK35TZ9JoGy6D1a21WnP3pM7FMksR
         quHCmqMueOIswuTzCPugAZhNcXTMkK0E9b3dd4xr0vbXZH9SsRHQN37L5XDW71iftkEB
         U4LpOcCr5Pp9fMwbT0ZyGSBKJr64+qnivQt6IPhbHPVIkvEl35f9panpWCNCmR+qSb5F
         DysegDZkGm1d7viv4Bc2qLt7CN1fxfG1Qf92fvXPKUXO5YeYSYuO+y246oxQl1gafBYj
         bX3KVwwML3pZoDztlBaAos95XhXtjfa2N528GBmEGuBB6MuG6pRk1DdpjYCTgYjY9kiF
         MhrA==
X-Gm-Message-State: AOAM533B3pH1+ifLRYpUNsYKUCgjpUmFC65KPKnHXqtL2Qo6JGCbRYhl
        8EB/SKoiL8clrgjJ1AB13RtxCQ==
X-Google-Smtp-Source: ABdhPJyQ2rd8AtzfLKSk7pcRIWMkAF0QH30KhY5NHLgIkgccLRDTnxh33KsvfNWVKvhaR3vGZrvloQ==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr365778pjb.27.1635788493615;
        Mon, 01 Nov 2021 10:41:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cv1sm86275pjb.48.2021.11.01.10.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 10:41:33 -0700 (PDT)
Date:   Mon, 1 Nov 2021 17:41:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
Message-ID: <YYAmyUZhmcSntUza@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-27-seanjc@google.com>
 <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
 <YXrH/ZZBOHrWHz4j@google.com>
 <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 01, 2021, Maxim Levitsky wrote:
> On Thu, 2021-10-28 at 15:55 +0000, Sean Christopherson wrote:
> > On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> > > so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> > > logic.
> > 
> > Hmm, I think you could make an argument that ON and thus the whole "control"
> > word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
> > There's even in a clause in Documentation/process/volatile-considered-harmful.rst
> > that calls this out as a (potentially) legitimate use case.
> > 
> >   - Pointers to data structures in coherent memory which might be modified
> >     by I/O devices can, sometimes, legitimately be volatile.
> > 
> > That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
> > requires more protections than what volatile provides, namely that all writes need
> > to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
> > the code itself be more self-documenting.
> 
> I took a look at how READ_ONCE/WRITE_ONCE is implemented and indeed they use volatile
> (the comment above __READ_ONCE is worth gold...), so there is a bit of contradiction:
> 
> volatile-considered-harmful.rst states not to mark struct members volatile since
> you usually need more that than (very true often) and yet, I also heard that
> READ_ONCE/WRITE_ONCE is very encouraged to be used to fields that are used in lockless
> algorithms, even when not strictly needed,
> so why not to just mark the field and then use it normally? I guess that
> explicit READ_ONCE/WRITE_ONCE is much more readable/visible that a volatile
> in some header file.

Are you asking about this PI field in particular, or for any field in general?

In this particular case, visibility and documentation is really the only difference,
functionally the result is the same.  But that's also very much related to why this
case gets the exception listed above.  The "use it normally" part is also why I
don't want to tag the field volatile since writing the field absolutely cannot be
done "normally", it must be done atomically, and volatile doesn't capture that
detail.

If you're asking about fields in general, the "volatile is harmful" guideline is
to deter usage of volatile for cases where the field/variable in question is not
intrinsically volatile.  As the docs call out, using volatile in those cases often
leads to worse code generation because the compiler is disallowed from optimizing
accesses that are protected through other mechanisms.

A good example in x86 KVM is the READ_ONCE(sp->unsync) in mmu_try_to_unsync_pages() to
force the compiler to emit a load of sp->unsync after acquiring mmu_unsync_pages_lock.
Tagging "unsync" as volatile is unnecessary since the vast majority of its usage is
protected by holding a spinlock for write, and would prevent optimizing references in
kvm_mmu_get_page() and other flows that are protected by mmu_lock in the legacy MMU.
