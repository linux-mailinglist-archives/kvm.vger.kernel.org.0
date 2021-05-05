Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFA37330E
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEEA2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhEEA2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10943C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:27:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a3-20020a2580430000b02904f7a1a09012so484904ybn.3
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=VKgVRByPslcwTvLjOdYrGp82XaC2KrJ5pPY9xex0Ink=;
        b=RZJ5s5vgHmlGIa5GRi9aBd1ACKmDRhWI1rFQ8DWxOR+x8CwUwwgOGzgTAd8Af0z/TD
         QVA/g9wiHqDQ+UkkRiUMGXVzYQbv/cDCfaErKFOga/u+10X9DVW7yG3Pdu22fqrjPflG
         aQKvZF2huCCbeUddmJeikoZAHwS4qi+VgqYZ+vhdBd2EeDbNfd/WPZd1Q6uIEXXneA0B
         l8iO9Z9mweUvuGwF1kdknf07tKK7AvO+7p4gCcfcD9KqNYCKUGDvQjiEi0y3Bzhey4my
         CnbFozb3ZOqAb7ZPND7BRSObRAFTfK8LgUJ5PQxMTmk+5BkrqPVN7iaF52NIDUsBdzJz
         U3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=VKgVRByPslcwTvLjOdYrGp82XaC2KrJ5pPY9xex0Ink=;
        b=pNS1zQRyzmbVzQe3cDVUs4Fl5P14gh++hoh8mA0WekiBIqwxJkBU+iOjHo/9rGcdCl
         w3lcz4A4M7tcEigErK4tCcGSwUocfQr2JJ0tWswLaB7udTf8Oby0bfvdohlepTlEwiRD
         fCAIYG6yM+sLsPmHHbBkjkDYdeHUxsoSTaRXutErAi/GgwQQAoLLTFkWSb60MsPujfwZ
         8eihaf9X8504usN9fswc/8Ztc2C3PdMmPkQUn/jtzkjM8fSXWBkqI9ZTflfdlM6DWZLT
         Y9KqU+qbZFEJupYAXPkdiAuaotCG2zk8QADb+e+JPk0DxWmFeE0rwq4ee68qHu9PCWJR
         bbww==
X-Gm-Message-State: AOAM532bB8Y9tuXjVmXzhggfsRVQfQv3i3i47GvsN185e6wSUExucYNS
        1GryqRVM588zzXaDXFu7G0ORauq4IyI=
X-Google-Smtp-Source: ABdhPJwV3cL8E3VbRB9iH5Ir/bfVm4wFsBBev6rxSscrx4ENE8zNzsNhqOGUZkwj5qcHec+NcEyrbDLhZrk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:880c:: with SMTP id c12mr38649622ybl.399.1620174465152;
 Tue, 04 May 2021 17:27:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:27 -0700
Message-Id: <20210505002735.1684165-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 0/8] KVM: Fix tick-based accounting for x86 guests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix tick-based accounting for x86 guests, and do additional cleanups to
further disentangle guest time accounting and to deduplicate code.

v4:
  - Add R-b's (dropped one due to code change). [Christian]
  - Drop instrumentation annotation shuffling since s390 may be gaining
    support. [Christian].
  - Drop "irqs_off" from context_tracking_guest_exit(). [Frederic]
  - Account guest time after enabling IRQs, even when using context
    tracking to precisely account time. [Frederic]

v3 (delta from Wanpeng's v2):
  - https://lkml.kernel.org/r/20210415222106.1643837-1-seanjc@google.com
  - s/context_guest/context_tracking_guest, purely to match the existing
    functions.  I have no strong opinion either way.
  - Split only the "exit" functions.
  - Partially open code vcpu_account_guest_exit() and
    __vtime_account_guest_exit() in x86 to avoid churn when segueing into
    my cleanups (see above).

older:
  - https://lkml.kernel.org/r/1618298169-3831-1-git-send-email-wanpengli@tencent.com
  - https://lkml.kernel.org/r/20210413182933.1046389-1-seanjc@google.com


Sean Christopherson (5):
  sched/vtime: Move vtime accounting external declarations above inlines
  sched/vtime: Move guest enter/exit vtime accounting to vtime.h
  context_tracking: Consolidate guest enter/exit wrappers
  context_tracking: KVM: Move guest enter/exit wrappers to KVM's domain
  KVM: x86: Consolidate guest enter/exit logic to common helpers

Wanpeng Li (3):
  context_tracking: Move guest exit context tracking to separate helpers
  context_tracking: Move guest exit vtime accounting to separate helpers
  KVM: x86: Defer vtime accounting 'til after IRQ handling

 arch/x86/kvm/svm/svm.c           |  39 +--------
 arch/x86/kvm/vmx/vmx.c           |  39 +--------
 arch/x86/kvm/x86.c               |   9 ++
 arch/x86/kvm/x86.h               |  45 ++++++++++
 include/linux/context_tracking.h |  92 ++++-----------------
 include/linux/kvm_host.h         |  45 ++++++++++
 include/linux/vtime.h            | 138 +++++++++++++++++++------------
 7 files changed, 205 insertions(+), 202 deletions(-)

-- 
2.31.1.527.g47e6f16901-goog

