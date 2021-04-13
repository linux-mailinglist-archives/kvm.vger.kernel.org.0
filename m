Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC135E65F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347759AbhDMSaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347755AbhDMSaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1F3C061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e187so46610yba.15
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=p83dQZ0k0Eku5abiiX2RjEKklE9nuw+yn1MAe8TcP90=;
        b=WGEETEvbMvrLyFMBiTAiYONPkYqzwOzAjj5TqcXJb7f2DOKCVBc5SnXYbf095GvieY
         2S2mZpybQt3p9wOmu75YEXGr0NVWpSTWueGJNFKG2gS8/qAJpTmtYFj7h1knDMA7VJV6
         1KNA7k6dWVV6wfmA9mWFl42uxC16zfwR5fBajJsI23DWzHHVJXf33hOfKldQI0HZ/K76
         JXj6Q0o2hqKTx5w6OHqhSk75Ln5rXr4cDgemAHVl08JxiA/N7D+p7l/4xhHqibUQyT1+
         4JHPLjNwNG4OsW0wN6nJoeh139xm5lQI23sDfFXscPbqSyhDQBWRJTj8ImaE5qd2jp86
         rJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=p83dQZ0k0Eku5abiiX2RjEKklE9nuw+yn1MAe8TcP90=;
        b=k0u9+tuUFmzNHUB8QWew1/jvWeBTPkb406ZQG+PDAFK75nXn2B/Suw7OmAKJSDoDh2
         BBNubrZFRRFzQRLX87HqO1QYP7XhZuW8KRbXfpufJxm5b9xedc5itgYJJ1vNhg7nnna7
         Ko0KKho68rsL1GrGMT0ZRgJNHCJgOpsiTcTREa3fXee/jV1lx7sA24O9jqm3X95rlL2P
         lj+lNtQwJltCSZKdwHJVzbWnexkMzsqkLZFlcjiWPczYG9VwjdGmRsHl69NJgQ0UsPZs
         sOiNc1nNAMbFrSE1Rn3sLYdJZliLwXrzSGL7KWOdRB5yrBY1oxmBA7yx7p6zL85kGGqy
         1yPQ==
X-Gm-Message-State: AOAM532GheCvbTmdlea+D0JiYA5tu2QiGrAV5eKIvh3mxP8mydqKSQfn
        eP+Hbmkq4gGcd9J8MPPUFGd5KGdLCHo=
X-Google-Smtp-Source: ABdhPJxBMDkmeyEto5eh42lN8cMHROwXTUtvBnzTEYFcNOkJOkf/rgYS0/lHDysrjGIZzbyEsxmuAMbUxXk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a5b:7c5:: with SMTP id t5mr46632593ybq.190.1618338580729;
 Tue, 13 Apr 2021 11:29:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:26 -0700
Message-Id: <20210413182933.1046389-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 0/7] KVM: Fix tick-based vtime accounting on x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an alternative to Wanpeng's series[*] to fix tick-based accounting
on x86.  The approach for fixing the bug is identical: defer accounting
until after tick IRQs are handled.  The difference is purely in how the
context tracking and vtime code is refactored in order to give KVM the
hooks it needs to fix the x86 bug.

x86 compile tested only, hence the RFC.  If folks like the direction and
there are no unsolvable issues, I'll cross-compile, properly test on x86,
and post an "official" series.

Sean Christopherson (7):
  sched/vtime: Move guest enter/exit vtime accounting to separate
    helpers
  context_tracking: Move guest enter/exit logic to standalone helpers
  context_tracking: Consolidate guest enter/exit wrappers
  context_tracking: KVM: Move guest enter/exit wrappers to KVM's domain
  KVM: Move vtime accounting of guest exit to separate helper
  KVM: x86: Consolidate guest enter/exit logic to common helpers
  KVM: x86: Defer tick-based accounting 'til after IRQ handling

 arch/x86/kvm/svm/svm.c           |  39 +-----------
 arch/x86/kvm/vmx/vmx.c           |  39 +-----------
 arch/x86/kvm/x86.c               |   8 +++
 arch/x86/kvm/x86.h               |  48 +++++++++++++++
 include/linux/context_tracking.h | 100 ++++++++-----------------------
 include/linux/kvm_host.h         |  50 ++++++++++++++++
 include/linux/vtime.h            |  45 ++++++++++++--
 7 files changed, 175 insertions(+), 154 deletions(-)

-- 
2.31.1.295.g9ea45b61b8-goog

