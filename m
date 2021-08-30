Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557AE3FB079
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 06:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhH3EnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 00:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhH3EnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 00:43:18 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CE8C061756
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 21:42:25 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id n126so25673939ybf.6
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 21:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zY3qlsb7ZjPk5BEi04sy91garjJLfXOARzZj+ed5JFY=;
        b=oP7ov56BVt4hUGVpAFfO+U35vIDmLATzE+bzN7dmjB3nZKriANTROMFIMsbyVCoNca
         R07ZZtW+mnQ3I5G4ZAZufIrnxoGZDYAIWCXGpYM+DsPZVH5mCZbxdXcjg1GpMsQ9VUas
         9tJKOPC9k04ZzYYusZlsAa0Y/A/XHE0pZT7bwlaWlB5KPbDASNoLVIRue7eRnv/JgMXW
         Mm7ZuuPtb1EFFJX4Nz8ZJzfXhbXLqkGy1MMH7KM4qq72jUoCPd9gS+BG1PGtmkOpeBXl
         k9SQuK/dA137WcuN73yGI5/A8oTpSy7Nta0Kdf3nW6WDS3ibOfLpMysvGrYxwMyy/EyS
         HqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zY3qlsb7ZjPk5BEi04sy91garjJLfXOARzZj+ed5JFY=;
        b=fRJzOUp631kWreYKwR+GXClXfNUoOYKTv2eZ8XGCWx7SV2VtMykhXP0S0VhJOf6TtO
         BAQHtqCMJeHpJUcCFH0aFoBzWNKKk5F1SznUMi7X32hIV9tq/RGI5sEzlwnOyGEbPpyv
         3HRz2LIY1pwXv6Iyj6B8aaQhYYeSn9fQP5NiUQoJH8iIR+xOoP7bTdJPBWybfZ0rXIpH
         kSUXFt2gXHC/8SP+gksrXV16W5rDHBSs2WcW8eZPMGrONKboxtVxlFIMZ9xzfWnvLTYE
         lfn/ey5PHrur+X0VBFGiuXQgR15PNQeWn4+TsPMawpJKogujT5fWLeXwTzVWTTaRGqWb
         iVzA==
X-Gm-Message-State: AOAM530Tn3u99lUvq9iNZF41opMUzE8Yq3lrmjLd5DLDYoVn51MCcGF9
        CHOpWBrayBZjEtLoyRDChAwMWcKz+q1r2yqkr1U3Ww==
X-Google-Smtp-Source: ABdhPJwUk65aPlObB4jF1Mlst+wheGf7v9d0HcQ7LOWkfqADQ3NN4swdsHRfEE4mVQUuvIdWxUAkCEKeFQ51TkO0a5k=
X-Received: by 2002:a25:81c5:: with SMTP id n5mr21796587ybm.276.1630298544826;
 Sun, 29 Aug 2021 21:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210829182641.2505220-3-mizhang@google.com> <202108301131.HmLTqoX4-lkp@intel.com>
In-Reply-To: <202108301131.HmLTqoX4-lkp@intel.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Sun, 29 Aug 2021 21:42:13 -0700
Message-ID: <CAL715WJvYLyWS1dY_-69WEfp5HnTfCFrPNpx0OX1eOqN8D5DeA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests: KVM: use dirty logging to check if page
 stats work correctly
To:     kernel test robot <lkp@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kbuild-all@lists.01.org,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>    dirty_log_perf_test.c: In function 'run_test':
> >> dirty_log_perf_test.c:236:28: error: macro "TEST_ASSERT" requires 3 arguments, but only 1 given
>      236 |    "2M page number is zero");
>          |                            ^
>    In file included from include/kvm_util.h:10,
>                     from dirty_log_perf_test.c:17:
>    include/test_util.h:46: note: macro "TEST_ASSERT" defined here
>       46 | #define TEST_ASSERT(e, fmt, ...) \
>          |
> >> dirty_log_perf_test.c:235:3: error: 'TEST_ASSERT' undeclared (first use in this function)
>      235 |   TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) > 0
>          |   ^~~~~~~~~~~
>    dirty_log_perf_test.c:235:3: note: each undeclared identifier is reported only once for each function it appears in
>

Sorry, there is one fix not checked in before I sent it out. Will fix
it in the next version.
