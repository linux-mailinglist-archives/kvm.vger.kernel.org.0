Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F33FE377
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 21:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbhIAT62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 15:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhIAT61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 15:58:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E7DC061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 12:57:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so411338pje.0
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 12:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tMTG80t3wz+BbsYt7/vMbgUKt2cALKcGrfxmvyDVycI=;
        b=GDxzDHx6y4t2OpIpS+RJgk1VtJMeiB8knpDgvYQPSsFfHb9myS2i8Y8zKivTuXuXjD
         80WQ7dy0hlk1NsTkOvIPxXdqWLOvHI003J78+jnvMmt2AHjFlmWer9qGm5PPsff+b2qd
         aOvfuEe5agrtLAxrPIEsh+gBgAiw95ASoDg+uPHtcGd0X5xUl+uFpwYV5yGFPfy3nYSe
         X7GTPNiKRIHN5GQzk78FQkxMTyXT4uS5O8MwskFj3Q3faG/t/NUqScAQalxcqTeIbxdC
         r6CJv4p/DQwb/7mJW/KCjNyL/lqHQmBPjT5leuOBgEo6MdmgGRm0IRJ3pJtpXO6I5Yni
         WUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tMTG80t3wz+BbsYt7/vMbgUKt2cALKcGrfxmvyDVycI=;
        b=SzB1nvPUhjpkE5AzgQWnGg30HwJo00x9ncODp5qBAKcFZr3fCLSOra6tdADwjhXCyR
         iuWSoYapfe36yNzTHIxhvajntcnmAOtPNKvwpSded0t7VDnZmq03226Xsa+jETNJxEKz
         AxZTrJo6cPYyVnwdmU+t4CkudszAlSz3rjbcdQho+ZqzWMrHFOxpU+bJr8DqgGb1s+vX
         04nrYQ7tlmg2AAxHXjDfhevL0ZHMRr5myikLFJ7F8I++LRMsmLCtK2RaABD73EHsktxx
         aMs27iLFg8d9yDpUm2xsGdom3zo1hyiNwCsvxY30y3v2ve5t8Svqr0WeodtAXqaMsq+Y
         zR5g==
X-Gm-Message-State: AOAM531DngEImk9//+xk9CBKq7n0Qhy2uQpgNUAUMwyiBy+Eeo+bO0zf
        YlXQRdMMmhzftzR1ZjzAtA9lmg==
X-Google-Smtp-Source: ABdhPJyjE7jv9C7nQQ332L+GGCxxc0l51kKj4TvBYL6j4Mk0NOTmNP6mrLfjZrAOXlarJRfAETU5Gg==
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr1067223pjb.115.1630526249849;
        Wed, 01 Sep 2021 12:57:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z7sm306742pjr.42.2021.09.01.12.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 12:57:29 -0700 (PDT)
Date:   Wed, 1 Sep 2021 19:57:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jia He <justin.he@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Remove unused field mmio_cached in struct
 kvm_mmu_page
Message-ID: <YS/bJbzgG+pasIxu@google.com>
References: <20210830145336.27183-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830145336.27183-1-justin.he@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021, Jia He wrote:
> After reverting and restoring the fast tlb invalidation patch series,
> the mmio_cached is not removed. Hence a unused field is left in
> kvm_mmu_page.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jia He <justin.he@arm.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 

There's also additional cleanup we can do to take advantage of the free byte.
I'll include this patch in a follow-up mini-series to hopefully make life a bit
easier for Paolo.

Thanks!
