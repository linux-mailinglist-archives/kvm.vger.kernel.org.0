Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32D85AA760
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 07:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiIBFso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 01:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiIBFsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 01:48:32 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B21B7ECD;
        Thu,  1 Sep 2022 22:48:31 -0700 (PDT)
Received: from nazgul.tnic (dynamic-089-204-154-243.89.204.154.pool.telefonica.de [89.204.154.243])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CFC051EC0666;
        Fri,  2 Sep 2022 07:48:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1662097706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/LU3di8KsXx6XUa2Nf3vVOJOBGN0ZW7PQ2Lfq5dneO8=;
        b=QweYvVfFE9i4n3wMR98UUdjyMdkKxjcgRZvoqNIX9fmLm0qp14E36M+FjfMRBW7lI+jslO
        pxs/x8MMOiD3TeEuBDEVcMLijLo+RAJwOCzuyZwvK51JrI9cRCalLAfIeKaV+9ChxuV4bu
        lay5NDvgz0lf2ZNv0ehx2WveB1c0kIQ=
Date:   Fri, 2 Sep 2022 07:48:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/cpufeatures: Add macros for Intel's new fast
 rep string features
Message-ID: <YxGZH7aOXQF7Pu5q@nazgul.tnic>
References: <20220901211811.2883855-1-jmattson@google.com>
 <f956753b-1aae-37c9-9c9d-88e1550dd541@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f956753b-1aae-37c9-9c9d-88e1550dd541@zytor.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 09:14:24PM -0700, H. Peter Anvin wrote:
> Any reason why these bits are hidden from /proc/cpuinfo?

Yes, we aim to hide such purely CPUID bits from /proc/cpuinfo because it
becomes a dumping ground for "enablement" of new features. But

1. those features are not really used - most userspace like binutils and
gcc, etc do their own detection. (Yes, yes, I'd like to have ubiquitous
CPUID faulting).

2. /proc/cpuinfo is an ABI so we have to carry *all* those gazillion
flags for no good reason

So we have tools/arch/x86/kcpuid/ which we control and we can extend
with all the CPUID querying needs we have.

These kvm enablement things are kinda needed because guest userspace
gets an emulated CPUID so in order to detect features on its own, it
needs them. And kvm has tied features to x86's X86_FEATURE stuff and
there are sometimes weird interactions with it too but that's another
topic...

Oh and we still do add visible flags to /proc/cpuinfo but only when
they're features which need and have received non-trivial kernel
enablement like TDX or SNP or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
