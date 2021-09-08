Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49E9404044
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350595AbhIHUrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350572AbhIHUrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:03 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C1C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:45:54 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c22-20020ac80096000000b0029f6809300eso5662979qtg.6
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F9GYQd7GnFGl03eeAiMHP1LfsWzd2DbdzCfDnk6lJ9g=;
        b=Kulwlklj5NjUxZuN+cZwpyFysa7xy7hOm1brOciy1YxETDPAyXQAZ9h25pOHMErwED
         /TtDwlR/7GP/UWfpySkpmHzgj/NRooD0+x4Bme6+pqaa6GQCJCpmkGgCUB1Ya4mtUIEj
         MfJMXOWf+3uCBh7MTgGJmfYBMmYe21V3qi4W4IAiob0rX1FXzjoAPZ9KEA6dAWy1ONC2
         3uOg1mJ6W8uGHrtnnzquePp1S3VdX6x42JDtiPhdYfYP0hDBnB4iWRmHJNIA6ylDMY/o
         LzthFUDAhsp66ko2gXYPfhU2vEmhX51it00pK/SBjafsPtPoKRQNKAn30zbz77cQYmPi
         2Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F9GYQd7GnFGl03eeAiMHP1LfsWzd2DbdzCfDnk6lJ9g=;
        b=jocoVM2VUqh9ea0COFsqNN5zrLSccghPyamUAj50Rk6WjjVeQHYpoKwznh6aBSbFLn
         JD6RoO8K4Dfpevp8OiAiqPjTDXrneAObxA1ViCtROQzIm/B4NwJyegRJaevT8gM7IhNY
         mrlMQ/pAzL2kkc4o5J99f4VuyKkGGDY5y3oV0qKtpYkLnuXkD7NrGu4ITxN3GHzy0Tw0
         Mde6FMD7BKmE2ChdnJ8SWpvV1XIypbuG6ayUyYVeOvErV/FGjFOg5+mcMXJ1XhE1h5xI
         A8ZnKSfIhb2JJep08E9gQeUG9VORgtqyLBgKjyScUUbaSlHqTluFIzUm4ZLCuynNP3J6
         fX6A==
X-Gm-Message-State: AOAM5338qqJUQSiG+zfsW8rOhfU4PCAm1rzYBA+Zqygv+HM2htGWoQ5q
        egNdBpMlIK/fU01POWacDsCQiOWxiyjFFxubXf9oo093Osva6+XtmktB92VH86emMckAzCLV3ll
        +7zcgAalGP3rKE8OjBp0cuInYwcEGiE85V4a6BIROabgxc8uobWc8Ag==
X-Google-Smtp-Source: ABdhPJw8RC7dDMcblawJtQJfyUNOttHaUhjPdtfIUO2NSDUA7jtC+4gdmgjiju6TP/4fGNhn9brwyh0bRQ==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:ad4:5506:: with SMTP id az6mr219966qvb.8.1631133953998;
 Wed, 08 Sep 2021 13:45:53 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:36 -0700
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Message-Id: <20210908204541.3632269-1-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 0/5] Prevent inlining for asm blocks with labels
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang may decide to inline some functions that have inline asm with labels.
Doing this duplicates the labels, causing the assembler to be complain. These
patches add the "noinline" attribute to the functions to prevent this.

v2: Combine "libcflat.h" change and use the new "noinline" macro.

Bill Wendling (5):
  libcflag: define the "noinline" macro
  x86: realmode: mark exec_in_big_real_mode as noinline
  x86: svm: mark test_run as noinline
  x86: umip: mark do_ring3 as noinline
  x86: vmx: mark some test_* functions as noinline

 lib/libcflat.h | 1 +
 x86/pmu_lbr.c  | 4 ++--
 x86/realmode.c | 2 +-
 x86/svm.c      | 2 +-
 x86/umip.c     | 2 +-
 x86/vmx.c      | 6 +++---
 6 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

