Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A956467A50E
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 22:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbjAXVhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 16:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjAXVhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 16:37:43 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED7C118
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 13:37:42 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so13057070pji.3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 13:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCg+14KhdGv7fDnqb2rUDWNTTTL3orxb6Lg6ROb71qM=;
        b=bqryvfh/KBC/5NXKHYJZ0a9Jy2d6IlGtG0JOTS7QF96tYE8zMNzUvhCVnXfvJEt2YV
         0qgrpUr5VGeO3/A++oBiRYp/0U+ORZ2U0NniFmlFE1yig3fjukEUqNXLWsIqogpWtK0h
         n3pEGCAx91Bm+4Y8Lyur18S5rJ5jieQvtfruWWYoCrkfrI8vf0JDWTDmH05cBLZCxNaH
         g61bXKhXQdncJ3GWly7Ga/2YFUZM7WttST3Jc4HJps86NcPYKBhS6VgP+IwOfF0t2mvG
         bHAIUSNtomwtMrot4HD074x+hN7XUWAlG5GzzZJSai6fkLzcJXQBOHCgIIbGz8JmYsIo
         xxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCg+14KhdGv7fDnqb2rUDWNTTTL3orxb6Lg6ROb71qM=;
        b=ZBusFZczpkja1//xqBlfF2dVo0SsZB5AlLudeu1lSQv5RtFNx4HRaP+w2LNizTseMi
         muK2CcE0uoTCorbsNnosdvVRffZSD5z2+nU59UTrPyf5M/4QPpPmOcpuE+RU8FKsdaiP
         BBB2iT5e2I/6BToYez5qe6RRYoLe0jeUGwQp+oNxLhSVFaoErKI0Iqh/POkWFd8jbp0R
         cVeCFkY6RuQr6E4TnOQBPm/ZNFEKg4ZDR+jJpCl9p/c1//2p+Ows9CHIwhwFAFg/oqXz
         LrVWolWK16WBfMmR5WIBGQvqwKSV9FJSCjSVtHKtpZzKOrTEKZ1DBSDdCE0BdsR8XGsH
         r8Lw==
X-Gm-Message-State: AO0yUKV9tPUI24EgEgpdUTCBZeEnlnhOhFg3kzyr6EAmQC3/t6JTbfkI
        c5qFy9oFp/EcrTIbdDXEUjVVZA==
X-Google-Smtp-Source: AK7set86jseu/vYRkmTo3r44uV1Oupq7/YteqiMcddsfINv9XXxhuDed8J59rP/5cL3MDxIbQhc2ng==
X-Received: by 2002:a05:6a20:4c08:b0:a4:efde:2ed8 with SMTP id fm8-20020a056a204c0800b000a4efde2ed8mr400647pzb.0.1674596261827;
        Tue, 24 Jan 2023 13:37:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00180500b0058d97b624f0sm2068374pfa.75.2023.01.24.13.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 13:37:38 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:37:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/8] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <Y9BPnTJSI247DV50@google.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124163319.2277355-1-kim.phillips@amd.com>
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

On Tue, Jan 24, 2023, Kim Phillips wrote:
> Kim Phillips (8):
>   x86/cpu, kvm: Add support for CPUID_80000021_EAX
>   KVM: x86: Move open-coded cpuid leaf 0x80000021 EAX bit propagation
>     code
>   x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
>   x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to its native leaf
>   x86/cpu, kvm: Add the Null Selector Clears Base feature
>   x86/cpu, kvm: Add the SMM_CTL MSR not present feature
>   x86/cpu: Support AMD Automatic IBRS
>   KVM: x86: Propagate the AMD Automatic IBRS feature to the guest
> 
>  Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++--
>  .../admin-guide/kernel-parameters.txt         |  6 ++--
>  arch/x86/include/asm/cpufeature.h             |  7 +++--
>  arch/x86/include/asm/cpufeatures.h            | 11 ++++++--
>  arch/x86/include/asm/disabled-features.h      |  3 +-
>  arch/x86/include/asm/msr-index.h              |  2 ++
>  arch/x86/include/asm/required-features.h      |  3 +-
>  arch/x86/kernel/cpu/amd.c                     |  2 +-
>  arch/x86/kernel/cpu/bugs.c                    | 20 +++++++------
>  arch/x86/kernel/cpu/common.c                  | 26 +++++++++--------
>  arch/x86/kvm/cpuid.c                          | 28 ++++++-------------
>  arch/x86/kvm/reverse_cpuid.h                  |  1 +
>  arch/x86/kvm/svm/svm.c                        |  3 ++
>  arch/x86/kvm/x86.c                            |  3 ++
>  14 files changed, 70 insertions(+), 51 deletions(-)
> 
> -- 

With my goof in the LFENCE_RDTSC patch fixed,

Acked-by: Sean Christopherson <seanjc@google.com>
