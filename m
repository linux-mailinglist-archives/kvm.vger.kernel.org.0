Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C5C5FF582
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJNVhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNVhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:37:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F10183AD
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h185so5393378pgc.10
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
        b=koXuqSvky1riggc/IjIcBJ5QKS2r76UwNF0+m1YmtoN6x5TLzY40OyFxikqY09ee+d
         IWauiMTz1Uitfu3NbLRMgzzx2z50RtgVV/3czdNQkQ+VM1MvdWcrkAlrIVbbqRcn0fDb
         PwjvqrFQooRxEcUEpHH+d/XgavD1URG0v7hE3UyLPIjdYo1E+0nBkhHzvNBWTB20/5ws
         D/Z/CbMFtTLggU44MEzsvVbzh9AK7ugtr7wZgHSxwy1WZPmiPJ1lWT5whqPctMZ5nRJ5
         sPO62x9KQr4V/lLMM8AqrcJC2uaMw8dQMgUlwAKzsim2YjmaOC29XqKsNG95dG7+4X7l
         FHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
        b=QaCJcGux77kUXDuTfL1xqSaMajUEdCDd2DKg/Cc4QSYuNKDRRfIJgjDpwGXRzzQQkE
         BuJkJ+4M0+Dm0NSDAmnM7tna88ub6kZpvU0VEisZtgeZSnNTqBhrlljfkKz3aOwMTxah
         yBPtUKrCJnSjSSL8Pg4F7CFHykqWu8huOTko+6qWjiDeynogMczsOkxPb12QE0AoIQPs
         asfLY3y2YUZnr67rR5HAfskBeEE3VkqwSGMl3VsTbcIe2x7ZW0+MjMNYfW/OLTj1nGPL
         s9xhFLHPMOTnpOCx6kcxy4j8FLq59Ys4ZQNLnBf+koI1arXLE2ycl9fmciPLsTA2k5uo
         aSCg==
X-Gm-Message-State: ACrzQf15nwNEjUCm2IgljL1vF1iF0gOqBC8DGR/pvcKvPFcZW8TbVw9k
        NfMcXc5DHiYQjZXtc0l8FhVyo3Kr/kcKrA==
X-Google-Smtp-Source: AMsMyM41AXX3Xp6kESIBHSUm21LCu3v/fFVnruKqRqDloxK7fMPiUbElSAmaa5TqV5mp/qM93oOECQ==
X-Received: by 2002:a65:6a12:0:b0:445:84f6:676a with SMTP id m18-20020a656a12000000b0044584f6676amr6173417pgu.40.1665783459080;
        Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id a6-20020a1709027e4600b0017a0f40fa19sm2122355pln.191.2022.10.14.14.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:37:38 -0700 (PDT)
Date:   Fri, 14 Oct 2022 14:37:34 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nWnr7GaPbBfLtf@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <Y0nU4vIIyjfQuQGV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0nU4vIIyjfQuQGV@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 09:30:10PM +0000, Sean Christopherson wrote:
> On Tue, Oct 11, 2022, Ricardo Koller wrote:
> > Ricardo Koller (14):
> >   KVM: selftests: Add a userfaultfd library
> >   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
> >   KVM: selftests: Add missing close and munmap in
> >     __vm_mem_region_delete()
> >   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
> >     macros
> >   tools: Copy bitfield.h from the kernel sources
> >   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
> >   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
> >   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
> >     vm_vaddr_alloc()
> >   KVM: selftests: Use the right memslot for code, page-tables, and data
> >     allocations
> >   KVM: selftests: aarch64: Add aarch64/page_fault_test
> >   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
> >   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
> >   KVM: selftests: aarch64: Add readonly memslot tests into
> >     page_fault_test
> >   KVM: selftests: aarch64: Add mix of tests into page_fault_test
> 
> A bunch of nits, mostly about alignment/indentation, but otherwise no more whining
> on my end.  A v10 would probably be nice to avoid churn?  But I'm also ok if y'all
> want to merge this asap and do the cleanup on top.

No prob, will send a v10 (most likely on Monday).

Thanks!
Ricardo
