Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3056C359E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjCUP0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjCUP0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:26:53 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [IPv6:2001:41d0:1004:224b::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D544A1CD
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:26:52 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:26:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679412410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FgYGwRrLAUU0RjVaToMoeANvITEEdSg9WXChDyLn7uI=;
        b=BgwrBKkk7UIj9CZ+Psd3r/T+xBfX8hsAzbGUjZFLWCLCscBOQGuMrWw38k+Fgnnz/y2GKP
        yyhRhcoZ5cL+4z0tBG2wpTYcdQ/vbX/UY+SLBm5/S1Jqn1D1C1VMNkKNe9OSyL+7JztlH3
        bN/+cXfIvX7s8Rjlvwk7IU9umD01zQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 0/7] MTTCG sanity tests for ARM
Message-ID: <20230321152649.zae7edlfub76fyqq@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 11:28:38AM +0000, Alex Bennée wrote:
> I last had a go at getting these up-streamed at the end of 2021 so
> its probably worth having another go. From the last iteration a
> number of the groundwork patches did get merged:
> 
>   Subject: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
>   Date: Thu,  2 Dec 2021 11:53:43 +0000
>   Message-Id: <20211202115352.951548-1-alex.bennee@linaro.org>
> 
> So this leaves a minor gtags patch, adding the isaac RNG library which
> would also be useful for other users, see:
> 
>   Subject: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
>   Date: Tue, 22 Nov 2022 18:11:36 +0200
>   Message-Id: <20221122161152.293072-12-mlevitsk@redhat.com>
> 
> Otherwise there are a few minor checkpatch tweaks.
> 
> I would still like to enable KVM unit tests inside QEMU as things like
> the x86 APIC tests are probably a better fit for unit testing TCG
> emulation than booting a whole OS with various APICs enabled.
> 
> Alex Bennée (7):
>   Makefile: add GNU global tags support
>   add .gitpublish metadata
>   lib: add isaac prng library from CCAN
>   arm/tlbflush-code: TLB flush during code execution
>   arm/locking-tests: add comprehensive locking test
>   arm/barrier-litmus-tests: add simple mp and sal litmus tests
>   arm/tcg-test: some basic TCG exercising tests
> 
>  Makefile                  |   5 +-
>  arm/Makefile.arm          |   2 +
>  arm/Makefile.arm64        |   2 +
>  arm/Makefile.common       |   6 +-
>  lib/arm/asm/barrier.h     |  19 ++
>  lib/arm64/asm/barrier.h   |  50 +++++
>  lib/prng.h                |  83 +++++++
>  lib/prng.c                | 163 ++++++++++++++
>  arm/tcg-test-asm.S        | 171 +++++++++++++++
>  arm/tcg-test-asm64.S      | 170 ++++++++++++++
>  arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
>  arm/locking-test.c        | 321 +++++++++++++++++++++++++++
>  arm/spinlock-test.c       |  87 --------
>  arm/tcg-test.c            | 340 ++++++++++++++++++++++++++++
>  arm/tlbflush-code.c       | 209 ++++++++++++++++++
>  arm/unittests.cfg         | 170 ++++++++++++++
>  .gitignore                |   3 +
>  .gitpublish               |  18 ++
>  18 files changed, 2180 insertions(+), 89 deletions(-)
>  create mode 100644 lib/prng.h
>  create mode 100644 lib/prng.c
>  create mode 100644 arm/tcg-test-asm.S
>  create mode 100644 arm/tcg-test-asm64.S
>  create mode 100644 arm/barrier-litmus-test.c
>  create mode 100644 arm/locking-test.c
>  delete mode 100644 arm/spinlock-test.c
>  create mode 100644 arm/tcg-test.c
>  create mode 100644 arm/tlbflush-code.c
>  create mode 100644 .gitpublish
> 
> -- 
> 2.39.2
>

I don't see any problem with the series, but I didn't review it closely.
I think it's unlikely we'll get reviewers, but, as the tests are
nodefault, then that's probably OK. Can you make sure all tests have a
"tcg" type prefix when they are TCG-only, like the last patch does for
its tests? That will help filter them out when building all tests as
standalone tests. Someday mkstandalone could maybe learn how to build
a directory hierarchy using the group names, e.g.

 tests/mttcg/tlb/all_other

but I don't expect to have time for that myself anytime soon, so prefixes
will likely have to do for now (or forever).

Thanks,
drew
