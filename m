Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE66D2F8357
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbhAOSKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbhAOSKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 13:10:42 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98BDC0613C1
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 10:10:01 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id n25so6520362pgb.0
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 10:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A8HU57lnNGXivwjmV5hD7UIXYBjhrtMp5tMlgZSsho0=;
        b=YgjCZxlUX8zIn6UUzJNeBbd/T6EBt4wgcjHLo6RzW50hLGTjG6rqz5Uq0SOCDcWT96
         Co6Z1YZE5sY8El66WZy7CsA45bBR31DpKk5qD9dDCyEMvaCbZWhXIZkHMqYGA/wcVdTm
         LwvWdURhcQYsNLp2TvpmD7fcKV+sMH1s/r0h3iI43hcSSIJDPQM+yie14SpuDeWUv1v+
         Q2sJK5/rfaEiyEgI0XQ4Lb13GCGT3VY0oxSZMmqN/vgZXot9ySDK2KT+Y8Nsh/ERd5JX
         g4QLmw2/TecEKSHYhFR3Ui/gpX+R1/stZlzDf52p46JLvyUuSkEM//RwrIxPq364c6Jo
         fFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A8HU57lnNGXivwjmV5hD7UIXYBjhrtMp5tMlgZSsho0=;
        b=GPk83Xadmyb8T0VcOn98uiWmSdzEdyTeS5X1YZHJJDqFIoGKztFEUWyKycyX+/wVhl
         2jIrYQMmqRZ8kR+NG0Sd1koRD7Nlc+pBM8glDUW7Sx5XiTlJgocUF+P4ETGhOGIcesQq
         GzAA37cS+71Mff16PmHXv+muq4sxIBgbm+ju2lR1hGKP2aVHE+C+n2DGsTOV2qR//fJV
         yNdcxeOYerhYQBnIaWErVHcu/Af9RHHZwKyQ24dZtIuL7txvbZCJr/ey01z1SPpXTIIF
         eqggqIOfBJM+2lCpcF5W7R4XrTAK8BkRWDm380d4LAIu6LHfUk3ZVjH2nD2qI0rvF/hv
         xv0g==
X-Gm-Message-State: AOAM531L51+IsV/uiydS6RjCphwf+a7nZRz41kMvia0RQr55jV0xihzz
        Vy6kGV8xhotloPVZ+AgDvAZL9A==
X-Google-Smtp-Source: ABdhPJwPv/lvnonyIREFYeM8j+JUI2wrlGzj8IloDhV+QBYpX2nG/g0QM/KmYtg+wSyPkEnfC4YvNg==
X-Received: by 2002:a62:d14f:0:b029:1ae:72f9:254c with SMTP id t15-20020a62d14f0000b02901ae72f9254cmr13740607pfl.38.1610734201153;
        Fri, 15 Jan 2021 10:10:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x23sm10738953pge.47.2021.01.15.10.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:10:00 -0800 (PST)
Date:   Fri, 15 Jan 2021 10:09:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/3] x86/KVM/VMX: Introduce and use try_cmpxchg64()
Message-ID: <YAHaceikAK+xYxUg@google.com>
References: <20201215182805.53913-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215182805.53913-1-ubizjak@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020, Uros Bizjak wrote:
> This patch series introduces try_cmpxchg64() atomic locking function.
> 
> try_cmpxchg64() provides the same interface for 64 bit and 32 bit targets,
> emits CMPXCHGQ for 64 bit targets and CMPXCHG8B for 32 bit targets,
> and provides appropriate fallbacks when CMPXCHG8B is unavailable.
> 
> try_cmpxchg64() reuses flags from CMPXCHGQ/CMPXCHG8B instructions and
> avoids unneeded CMP for 64 bit targets or XOR/XOR/OR sequence for
> 32 bit targets.
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> 
> Uros Bizjak (3):
>   asm-generic/atomic: Add try_cmpxchg64() instrumentation
>   locking/atomic/x86: Introduce arch_try_cmpxchg64()
>   KVM/VMX: Use try_cmpxchg64() in posted_intr.c

For anyone else trying to apply this, it depends on v5.11-rc1 (commit
29f006fdefe6, "asm-generic/atomic: Add try_cmpxchg() fallbacks"), which hasn't
yet been merged into Paolo's tree.

>  arch/x86/include/asm/cmpxchg_32.h         | 62 +++++++++++++++++++----
>  arch/x86/include/asm/cmpxchg_64.h         |  6 +++
>  arch/x86/kvm/vmx/posted_intr.c            |  9 ++--
>  include/asm-generic/atomic-instrumented.h | 46 ++++++++++++++++-
>  scripts/atomic/gen-atomic-instrumented.sh |  2 +-
>  5 files changed, 108 insertions(+), 17 deletions(-)
> 
> -- 
> 2.26.2
> 
