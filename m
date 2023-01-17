Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AF66DCED
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 12:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbjAQLzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 06:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbjAQLy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 06:54:59 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD0732E62;
        Tue, 17 Jan 2023 03:54:57 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7D9C31EC05F1;
        Tue, 17 Jan 2023 12:54:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673956496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EzEq0Nv/DDJ1PRGvIJ8dUuiGUaHmCTgowpM6A+bZV48=;
        b=DbSYv0J7+Weay6rxHomE8SkUNrWBXRpDfz8ErjXf/A2VDmLZ+Zgv8MikctMsn/eGzYHTFl
        OS8uLfvGRyf5A6dUIvBI+70YBbP7UatR2Mz6xKnNQelg8GsPzhbppZcUw96Q3bcGCWxGb/
        gkLT543mMMKjUSMYDp6vCBL1YEgIuA0=
Date:   Tue, 17 Jan 2023 12:54:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <Y8aMiH74WFmVM5Rk@zn.tnic>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230116230159.1511393-1-kim.phillips@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 05:01:52PM -0600, Kim Phillips wrote:

> Kim Phillips (7):
>   x86/cpu, kvm: Add support for cpuid leaf 80000021/EAX (FeatureExt2Eax)
>   x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
>   x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE always serializing
>     feature
>   x86/cpu, kvm: Add the Null Selector Clears Base feature
>   x86/cpu, kvm: Add the SMM_CTL MSR not present feature
>   x86/cpu: Support AMD Automatic IBRS
>   x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
> 
>  Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++--
>  .../admin-guide/kernel-parameters.txt         |  6 ++--
>  arch/x86/include/asm/cpufeature.h             |  7 +++--
>  arch/x86/include/asm/cpufeatures.h            | 11 +++++--
>  arch/x86/include/asm/disabled-features.h      |  3 +-
>  arch/x86/include/asm/msr-index.h              |  2 ++
>  arch/x86/include/asm/required-features.h      |  3 +-
>  arch/x86/kernel/cpu/amd.c                     |  2 +-
>  arch/x86/kernel/cpu/bugs.c                    | 20 ++++++++-----
>  arch/x86/kernel/cpu/common.c                  | 22 +++++++++-----
>  arch/x86/kvm/cpuid.c                          | 30 +++++++------------
>  arch/x86/kvm/reverse_cpuid.h                  |  1 +
>  arch/x86/kvm/svm/svm.c                        |  3 ++
>  arch/x86/kvm/x86.c                            |  3 ++
>  14 files changed, 71 insertions(+), 48 deletions(-)

KVM folks,

I'm going to route this through the tip tree, along with the KVM bits.

Holler if we should do something else to avoid any potential conflicts.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
