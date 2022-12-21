Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E179C65367B
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 19:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiLUSol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 13:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiLUSoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 13:44:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3029021891
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 10:44:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id l10so16380267plb.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 10:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqMLve4a+7yaawxIrTIZNKm2QG2HHAaYLBOV4f2gVjs=;
        b=lP5/16iiEYGHg9x3sdKqI41DZkM7CC4/jVRfG1JUluigHimrXgJ1BwwVBqPAJw6SLF
         FIgymM96JKS8LdWm8L4kciMCnvqhtX/lW6UloIH8bFCIsH6QflcXBvIa+fQBYFo3U86/
         QroUendE8aUHa7TufrfR00JWJ0NbIJTwKDSAMR5RHnIOiaX6xl0pDzo3e6duurK0kza9
         NfewXU0wGGhp9rU++dvhKVqIpHCfBNygPi5Qv60T3j3RYPH5aH8dB5POTXUrpWSbbW8F
         D670zUy5bQ8CwJqRo8x955cwaETg9qzeRHzzQfS8zR/qtvVN6M/26rabgDuM6mptso56
         ezXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqMLve4a+7yaawxIrTIZNKm2QG2HHAaYLBOV4f2gVjs=;
        b=DQCn8KEzVh4fphH+w9Kmoq8sKLkrRaLqgF9msUGGflEjtI+dvKdj47DUJQYj48Q8hU
         HwohQ4icGy9WZu9MkAW50MVM2xqd3y8xBZ0TQun/CAUJBYMcTI+ps1qxYf44mByXNDo3
         6m44+AJn5mxoJJo1IU7y6eRNWmZf81ERoWi9qeEYEUBiuGraWsnoDdj5aYsIAwTZU+bU
         qimB5ceeqVa/k+NdjEZ4vfefqzAIcnqZcHeEn0WoCD89vf05h+BUASYFPuTrTQ30CZ0X
         N9BtTPGPIo4rb19jvLmf0j43ykAa7IkhRZBtOORWgWRv8X8vhukbzO0TZUSgnFSh4Wdi
         xGWQ==
X-Gm-Message-State: AFqh2kq19EM3eMUHdByQSvthpRYZApSzSEsxKPYjFTNuKtT2Te72dOie
        VKUmaZ5FCLPJnBtWdW9afB3OGQ==
X-Google-Smtp-Source: AMrXdXvNy7clAG/b1GRRifsfntw7rfmh3YaG2BEb1whiRVyvQQr2/FQky5QwMXMFn7Qq1kUV2xB3IQ==
X-Received: by 2002:a17:90b:35d0:b0:218:7bf2:4ff2 with SMTP id nb16-20020a17090b35d000b002187bf24ff2mr700519pjb.0.1671648277545;
        Wed, 21 Dec 2022 10:44:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gm16-20020a17090b101000b00219752c8ea5sm1731495pjb.37.2022.12.21.10.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 10:44:36 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:44:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Santosh Shukla <santosh.shukla@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 00/11] SVM: vNMI (with my fixes)
Message-ID: <Y6NUEV3FTq29R64F@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <7af086556ff794bbe78e48c882b6e91aa5ad4022.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7af086556ff794bbe78e48c882b6e91aa5ad4022.camel@redhat.com>
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

On Tue, Dec 20, 2022, Maxim Levitsky wrote:
> On Tue, 2022-11-29 at 21:37 +0200, Maxim Levitsky wrote:
> > Hi!
> > 
> > This is the vNMI patch series based on Santosh Shukla's vNMI patch series.
> > 
> > In this version of this patch series I addressed most of the review feedback
> > added some more refactoring and also I think fixed the issue with migration.
> > 
> > I only tested this on a machine which doesn't have vNMI, so this does need
> > some testing to ensure that nothing is broken.
> > 
> > Best regards,
> >        Maxim Levitsky
> > 
> > Maxim Levitsky (9):
> >   KVM: nSVM: don't sync back tlb_ctl on nested VM exit
> >   KVM: nSVM: clean up the copying of V_INTR bits from vmcb02 to vmcb12
> >   KVM: nSVM: explicitly raise KVM_REQ_EVENT on nested VM exit if L1
> >     doesn't intercept interrupts
> >   KVM: SVM: drop the SVM specific H_FLAGS
> >   KVM: x86: emulator: stop using raw host flags
> >   KVM: SVM: add wrappers to enable/disable IRET interception
> >   KVM: x86: add a delayed hardware NMI injection interface
> >   KVM: SVM: implement support for vNMI
> >   KVM: nSVM: implement support for nested VNMI
> > 
> > Santosh Shukla (2):
> >   x86/cpu: Add CPUID feature bit for VNMI
> >   KVM: SVM: Add VNMI bit definition
> > 
> >  arch/x86/include/asm/cpufeatures.h |   1 +
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> >  arch/x86/include/asm/kvm_host.h    |  24 +++--
> >  arch/x86/include/asm/svm.h         |   7 ++
> >  arch/x86/kvm/emulate.c             |  11 +--
> >  arch/x86/kvm/kvm_emulate.h         |   7 +-
> >  arch/x86/kvm/smm.c                 |   2 -
> >  arch/x86/kvm/svm/nested.c          | 102 ++++++++++++++++---
> >  arch/x86/kvm/svm/svm.c             | 154 ++++++++++++++++++++++-------
> >  arch/x86/kvm/svm/svm.h             |  41 +++++++-
> >  arch/x86/kvm/x86.c                 |  50 ++++++++--
> >  11 files changed, 318 insertions(+), 83 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> A very kind ping on these patches.

Sorry, I won't get to this (or anything else) until the new year.
