Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE6E3689A8
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 02:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhDWAJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 20:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbhDWAJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 20:09:39 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1824C061756
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:09:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g1-20020a17090adac1b0290150d07f9402so233943pjx.5
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nMfzkQEov6kIVHNuaAn8iFcBDyLGbYrJQC6NcLJ8Y0k=;
        b=MOieLRc2dtfBssKc/drPE5jrnqhvaOSHoX1ikwjvgMyDtGflicbL5w6KTO5ZxViai7
         kbByOq81BuV6XajiwS2fhVpdRigaLp8UnuwZjexAwNKeblgLrirAMrEs11+DjBVnj5cG
         ygYwgdov1P3rUjQ4D6Nx7diFlsnBhOB6L0b8ZTvbyjqFKw0WpxQnhf2+T6Q1q/QIq90d
         mpdOgZ8Jnpk9RKFnAMLfHdFw8JTdjTISf6yQcL4wxr4GwC/Fj2HJQ+pf3ICh7xPT6YnR
         oryyzeAOW1bMSYxI4Px1yvJ5zcPtzyY+5AOk49SBpNN426ZjX7VgqrksC1X52ltOHhYQ
         VelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nMfzkQEov6kIVHNuaAn8iFcBDyLGbYrJQC6NcLJ8Y0k=;
        b=CBPhUkUhrEDoWKzu9nZSF5FzS9S/urCVZ8GuC1fr5N6mu1h1PFi5aEH3b+ulnDTzUr
         Og27XF46zsXjp1XzJNDcq5DFeEmENG/IPAX/SvXs9CsRiU8t4W6H2DCFTdZNclFHFxkR
         oEZFEIBpkC6+bG5XSgdnxvDBHjbYOe2HVUu3B3EmECoZDyD9Q51I+NfJYGD65kZEL2uG
         uLkaEJjJ2QXnqxOfXO+cWa5zqR2yjLfspXNztLA6oCmYmYbyChMY9RYZimQUq2v4SaJw
         HssuDli7+a4eRsDfGzXp8GNOX3eVfN+x8nQ2bZlLJis/BKKmCkHUuePZAe5SrRWITw1d
         8cDw==
X-Gm-Message-State: AOAM532KtR2PVSHKxPaoTYvBwylxFNijX+cEwKPFE6kuT2o88YzyZCAk
        Syi2AjJJ0HZxRlfyS+1btGgxzQ==
X-Google-Smtp-Source: ABdhPJybGByf1Kk9YiSc1IOkyXvmd9WNT9e++V5g4QLN7WhkKtqrQ2uDQMiVse4F9jCpZfXPv2zbXw==
X-Received: by 2002:a17:902:e904:b029:eb:73f6:ac99 with SMTP id k4-20020a170902e904b02900eb73f6ac99mr1069354pld.12.1619136543044;
        Thu, 22 Apr 2021 17:09:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w123sm2906742pfb.109.2021.04.22.17.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:09:02 -0700 (PDT)
Date:   Thu, 22 Apr 2021 17:08:58 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 3/5] tools headers x86: Copy cpuid helpers from the kernel
Message-ID: <YIIQGu82bdqjpktA@google.com>
References: <20210422005626.564163-1-ricarkol@google.com>
 <20210422005626.564163-4-ricarkol@google.com>
 <404e903a-5752-6ab2-9b46-aa40f7fb0fba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404e903a-5752-6ab2-9b46-aa40f7fb0fba@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 08:59:50AM +0200, Paolo Bonzini wrote:
> On 22/04/21 02:56, Ricardo Koller wrote:
> > Copy arch/x86/include/asm/acpufeature.h and arch/x86/kvm/reverse_cpuid.h
> > from the kernel so that KVM selftests can use them in the next commits.
> > Also update the tools copy of arch/x86/include/asm/acpufeatures.h.
> 
> Typo.
> 
> > These should be kept in sync, ideally with the help of some script like
> > check-headers.sh used by tools/perf/.
> 
> Please provide such a script.
> 
> Also, without an automated way to keep them in sync I think it's better to
> copy all of them to tools/testing/selftests/kvm

Will move them to the kvm subdir. The only issue is cpufeatures.h as
that would create a third copy of it: there is one already at
tools/arch/x86/include/asm/cpufeatures.h. Note that we can't move
cpufeatures.h from tools/arch/x86/include/asm to
tools/testing/selftests/kvm as it's already included by others like
tools/perf.

> so that we can be sure that
> a maintainer (me) runs the script and keeps them up to date. I am fairly
> sure that the x86 maintainers don't want to have anything to do with all of
> this business!
> 
> Paolo
>

Thanks for the review!

I'll try this approach for the next version: copy the new headers to
tools/testing/selftests/kvm (except cpufeatures.h), and add the script.
