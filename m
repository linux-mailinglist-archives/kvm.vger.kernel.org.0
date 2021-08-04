Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940183E048F
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbhHDPm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhHDPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 11:42:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7F7C061387
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 08:42:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z3so3411147plg.8
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ofFQyJiIJOQkTXzSM3r7/yq4jCe28tqrRs6j4ym+54=;
        b=QfH5iPJBNnOGYdUDxq8UFfARpio6lLVmOCCYAU4Yr+ex59GVda9SZczTDqhOf7dWxE
         iRfj2KBVpBm+C/5aIrFsbDFhLRDKW6GUxLZI1qNDnug86lvUHjFkwwGvq3zU+czFxV+H
         TxjVlSigDrrhg5hHlI0yxjbLJ6qhVZpdV52/KAG5KJcLwRUs7ateqLn2c0W9rTd/qrNO
         9x9IEU5PNchcKK5kX3GkxfoRBgw0AuK2mKGcXfGBt3CJx5uU78pyXtodqFpBzOxJ2XSv
         2TmZOHPOeL/s3PS0TW3yDKccM03JksLpcGq4PhJjYNY7Qw3mZDYL7QXiDeYIa9OvBEua
         hf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ofFQyJiIJOQkTXzSM3r7/yq4jCe28tqrRs6j4ym+54=;
        b=O109m1r+3Md+aBxXFmZqrSE7UPBfXqAfclDRvTRWIuzloZz2r6IU858pJ+RMDOb8W1
         U0BZ3TMqUKJ7lq/w7zB0DazQSbYkHYmghh09r3dbUoecpDaA7mVhBCOW3FubmimHOsMf
         /afxNufAZZVvCbZQPKrG0btCDdneri08clK2CXNbfwg2VI2W1ELYSAS68I28s5+XbTfN
         CszbWJgAXjTRNYzNa6s+iqBgi84tl63Ud/u7PVQl4zxMGv4Dmc8rnlWACUvD12HioCnm
         SyduGQjnsIz3pIQbPczMDSG/AyR3vGpy5YObRDgEaL0EL6m965vnqF3AtKm9c6MQZ80P
         X7ag==
X-Gm-Message-State: AOAM530pSjY47CHXLyMUqEalUT+31vqLh3Jv0AKQlUqAZJX15RN0NPZ+
        eRnYopE1nX1xjO+RK7frk/ubUA==
X-Google-Smtp-Source: ABdhPJxt++Uy8Sk5a8ClyTVphkj+DxmlDPiyKR8+Am8xhe3mYgVQr06+AXxlhj3uEwwG/GOBe1WiyQ==
X-Received: by 2002:a17:90a:bd98:: with SMTP id z24mr10364623pjr.99.1628091725523;
        Wed, 04 Aug 2021 08:42:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v15sm3354938pff.105.2021.08.04.08.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:42:04 -0700 (PDT)
Date:   Wed, 4 Aug 2021 15:42:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Gilbert <dgilbert@redhat.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: Possible minor CPU bug on Zen2 in regard to using very high GPA
 in a VM
Message-ID: <YQq1SVV9DKaZDhLp@google.com>
References: <f8071f73869de34961ea1a35177fc778bb99d4b7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8071f73869de34961ea1a35177fc778bb99d4b7.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021, Maxim Levitsky wrote:
> Hi!
>  
> I recently triaged a series of failures that I am seeing on both of my AMD machines in the kvm selftests.
> 
> One test failed due to a trivial typo, to which I had sent a fix, but most of the other tests failed
> due to what I now suspect to be a very minor but still a CPU bug.
>  
> All of the failing tests except two tests that timeout (and I haven't yet triaged them),
> use the perf_test_util.c library.
> All of these fail with SHUTDOWN exit reason.
> 
> After a relatively recent commit ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()"),
> vm_get_max_gfn() was fixed to return the maximum GFN that the guest can use.
> For default VM type this value is obtained from 'vm->pa_bit's which is in turn obtained
> from guest's cpuid in kvm_get_cpu_address_width function.
>  
> It is 48 on both my AMD machines (3970X and 4650U) and also on remote EPYC 7302P machine.
> (all of them are Zen2 machines)
>  
> My 3970X has SME enabled by BIOS, while my 4650U doesn't have it enabled.
> The 7302P also has SME enabled.
> SEV was obviously not enabled for the test.
> NPT was enabled.
>  
> It appears that if the guest uses any GPA above 0xFFFCFFFFF000 in its guest paging tables, 
> then it gets #PF with reserved bits error code.

LOL, I encountered this joy a few weeks back.  There's a magic Hyper-Transport
region at the top of memory that is reserved, even for GPAs.  You and I say
"CPU BUG!!!", AMD says "working as intended" ;-)

https://lkml.kernel.org/r/20210625020354.431829-2-seanjc@google.com
