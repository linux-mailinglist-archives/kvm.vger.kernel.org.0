Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8E67D5F6
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 21:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjAZUJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 15:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjAZUJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 15:09:46 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F273EFC6
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:09:45 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id d8so1499216ybe.9
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c+NzW40rV7jGj0x8hq/4PfBMwZ32g9LoSmeMFZgGTRU=;
        b=fsWn5e62pzILYcSqv2gIzK/MnKsPYqo+jDc+OQawlFAtWzuJCKWsXSfiGW0YwBLnoT
         tRPZiRQfda8O8Tz+B+41M0cZRkGKQw6ZelOvgcxC7p3SBqIR8bUiMJ7WSoKA16De8PeG
         i4x76JfYQag0QkJ/BAcQcBeeAmOGcnXmVNSKqBbLbesPQwNGRcsYom2efat/63jSoeM8
         Ph7GgQroUG/jCx6KnRKYa3GgPPKTAlo4CVAgoYbHzRhAsKRbLSw/98cAE61At3od+c5/
         zuEKDd5WIsusRU8A43+bQP2v5+htd2IT24sGPLH8XV65t0YcBDAWFqmRNBSxxlSOJVFj
         /Rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c+NzW40rV7jGj0x8hq/4PfBMwZ32g9LoSmeMFZgGTRU=;
        b=6TgQC++DANDbzA2ofu/UVnD82HLsovqJr5V2a4zUQsL/dZxntJvfk/P+83nF7cK7L0
         pOTDT7BjK9MLsfrSMUlI8vKs/jI4R+x0sGuO7e8lgvspi9O7Z/h6/KxTYmbjYIw/9g5n
         B3Wa53yIAHDX2MQlsEB/hPHIma44JB6z7MmsJp2hQWnwNk3aUnQEXVKrgtHVy3aaE1oU
         eyC3pjSPnOcyTTaoxEr9C21DK4rzWFRazkGq9kwQqnYEV3g+XEuO4h8sL9Mj1KS0E15N
         Ws6b1NavnXHI821T0mRJ21ls3pYyGnPDf+Zbwsx9IAqE4+tXev9+Z2+Js5LSCdbbdNAb
         Cahg==
X-Gm-Message-State: AO0yUKW8vAlUmBW9ntS0N8/Me3jBm5KvGwnhgj50uHXuxwwPZ/0/xjZp
        NQRSIvHS6SNpqNfS7Gu5f7fdm9tteVN8mmOYdtOIAw==
X-Google-Smtp-Source: AK7set+FHB0NwKdq/VPToS+YGauyrMTcRZHhpSNMnjBTcZvCWfNxUOCj4i7p8uuSLW8x/Ui4U+6TAD1oJem51pNyGVY=
X-Received: by 2002:a25:d907:0:b0:80b:69f5:3966 with SMTP id
 q7-20020a25d907000000b0080b69f53966mr1391344ybg.519.1674763784142; Thu, 26
 Jan 2023 12:09:44 -0800 (PST)
MIME-Version: 1.0
References: <20230125182311.2022303-1-bgardon@google.com>
In-Reply-To: <20230125182311.2022303-1-bgardon@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 26 Jan 2023 12:09:08 -0800
Message-ID: <CAHVum0eKdcsZ-6L0ypqL1CBW+2quyj_dPiqw83b-XMShoRkvig@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] selftests: KVM: Add a test for eager page splitting
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 10:23 AM Ben Gardon <bgardon@google.com> wrote:
>
> David Matlack recently added a feature known as eager page splitting
> to x86 KVM. This feature improves vCPU performance during dirty
> logging because the splitting operation is moved out of the page
> fault path, avoiding EPT/NPT violations or allowing the vCPU threads
> to resolve the violation in the fast path.
>
> While this feature is a great performance improvement, it does not
> have adequate testing in KVM selftests. Add a test to provide coverage
> of eager page splitting.
>
> Patch 1 is a quick refactor to be able to re-use some code from
> dirty_log_perf_test.
> Patch 2 adds the actual test.
>
> V1->V2:
Links of previous versions of patches are helpful and avoid searching
if one wants to read previous discussions.

>         Run test in multiple modes, as suggested by David and Ricardo
>         Cleanups from shameful copy-pasta, as suggested by David
> V2->V3:
>         Removed copyright notice from the top of
>         dirty_log_page_splitting.c
>         Adopted ASSERT_EQ for test assertions
>         Now skipping testing with MANUAL_PROTECT if unsupported
> V3->V4:
>         Added the copyright notices back. Thanks Vipin for the right
>         thing to do there.
>
> Ben Gardon (2):
>   selftests: KVM: Move dirty logging functions to memstress.(c|h)
>   selftests: KVM: Add dirty logging page splitting test
>
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/dirty_log_perf_test.c       |  84 +-----
>  .../selftests/kvm/include/kvm_util_base.h     |   1 +
>  .../testing/selftests/kvm/include/memstress.h |   8 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
>  tools/testing/selftests/kvm/lib/memstress.c   |  72 +++++
>  .../x86_64/dirty_log_page_splitting_test.c    | 257 ++++++++++++++++++
>  7 files changed, 351 insertions(+), 77 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
>
> --
> 2.39.1.456.gfc5497dd1b-goog
>
