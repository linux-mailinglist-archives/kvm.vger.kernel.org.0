Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD333C591
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhCOS1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhCOS0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 14:26:49 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAD4C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:26:49 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id t18so23568894qva.6
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Mx5f7S+/5wRWBEBjRnHorBN6dS5pzBj5+cDT45N3twk=;
        b=PlpPMKkm7qu6wCcvrEVc6KzFMMrjwWRJ198xVmPtC9vIbZPfK6/sbqEIkegXWp8Btu
         MuIQ892Ph6/RTX7ffhra72wj5jtXEQuuBFixDZKDxr+zuyxADYTvREp3L5e5OodF94AT
         lJOhmjpkoeqmxNVRhGJ1hDxkMLk6kujS/9hJsmDQGmqUAMICEn1cY3LZCFyQrcnEhFjC
         okjVPg9vp712MltmkyLQGkoMeCtT4u99CMNjOupbhTJNiAs05rhfyB099QZpl71tRl3R
         6frsQawZnyoA3mdDyxlLQWcSkSJ3nEgD5sCr26s7oxJTLMq717hCj0SqxMVzHHJjuoL7
         l7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Mx5f7S+/5wRWBEBjRnHorBN6dS5pzBj5+cDT45N3twk=;
        b=oFOWqlCPISoRW2fGwqih7Uk2FKN0+h1cblIbMk/0GszbtMLhrBceT2lWUc0JwZQ7si
         lK0hJlbtS0IPN8FD/WbMfUq6vIx/BvWC7AX8Evqv4uE1/ZGHcW6PENOrnPS5HtcztOAf
         N5mqaAGEOBur28KddZcAJKuHnhmkwCaZZE6JGGGIxEvj7pE3hJvd6UFiVXMNJfasstWI
         szJZWgD9kLGT76Sgd6RSPR0yqDhJTkWTFRcjR87SKHnbe8iv1ajx+5USkhhMGWN1fhA8
         6RVvTcqXOWWLRZdrwRt7xXJNRycYcjXRCDZZ9yWlvz7fVhTtUdgjX5r2+uHiw3bLgnyz
         vlOQ==
X-Gm-Message-State: AOAM532qTG4NN8eh/zkM5eKjHcif0gb3l7LSWZARisiLfposjho29XFX
        5mCmMjr1I6t9i1r+vs8SBld3CBOpZ7e7
X-Google-Smtp-Source: ABdhPJyPnuqH28GMfLvsE6fntxec4xEAKml+R1kWf48drQz3przzmYm9EipdFRGFMISS6+0jw9PngSrS0NY1
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:ad4:5ec9:: with SMTP id
 jm9mr12014461qvb.56.1615832808291; Mon, 15 Mar 2021 11:26:48 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:26:39 -0700
Message-Id: <20210315182643.2437374-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 0/4] Fix RCU warnings in TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux Test Robot found a few RCU warnings in the TDP MMU:
https://www.spinics.net/lists/kernel/msg3845500.html
https://www.spinics.net/lists/kernel/msg3845521.html

Fix these warnings and cleanup a hack in tdp_mmu_iter_cond_resched.

Tested by compiling as suggested in the test robot report and confirmed
that the warnings go away with this series applied. Also ran
kvm-unit-tests on an Intel Skylake machine with the TDP MMU enabled and
confirmed that the series introduced no new failures.

Ben Gardon (4):
  KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
  KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
  KVM: x86/mmu: Factor out tdp_iter_return_to_root
  KVM: x86/mmu: Store the address space ID in the TDP iterator

 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_iter.c     | 30 +++++++++++++++----------
 arch/x86/kvm/mmu/tdp_iter.h     |  4 +++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 40 +++++++++++++--------------------
 4 files changed, 41 insertions(+), 38 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

