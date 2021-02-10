Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43080316E9E
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhBJS3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 13:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhBJS0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 13:26:55 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06931C06178C
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:15 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id t5so2264949qti.5
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=q+sIuVQJ6KcFkT5QFvyQWYzcdJ2lh3h/xyy/iLNsRYQ=;
        b=di8qVqiUnwbZq+drUX5B4zxZ1i2Q93eORZ9i+xxj1lYzZzLPlYGgYljubSs5OY3tFS
         mYD3hl33pPNMC+maQ5KN8CfmbqqmoOQYr0E/fFKZip9vd/CscLrYAvff2xvLEnyk0loB
         gNG1WQhQKEBKiOuRQsD9xqjogNHt61/i5hpz573lRwpLmGRmDBbLQPcoRkZJl9Kr7k5j
         nofOLI/uzrLCKrM8gP6jpHO0hnJ6+OjFb9N4T+r2vsAkErDblZIns4dJ3fPOA8da1WvX
         B1RsREoFbnqXDGw0hRBspd9eIXSNxDO0rYqXl3HpEaPV2PYejQ65w2po74pXslOOvlNl
         l3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=q+sIuVQJ6KcFkT5QFvyQWYzcdJ2lh3h/xyy/iLNsRYQ=;
        b=kKb7rf6Zk4Sgdg0k3FMvGCshKxvzN94EnNA4pKXnQFD3Cwm8CrO+9/cNhJNE7SjfPs
         z8OR2G7FyVN3C1qSKDj5uPsbmsbdI2Wu05gJNq7TvbNxX2Es2VIeJAfL7xwkinrkeX4V
         gxOzxt4jduWLsPZwFAaJT6fgbi0G+J82n5xcZyWpjUF9+ZLEjquo4zsV/df7/MWkp+sE
         QVP1LHOL9DXePUIHl22EyjXV3IGPwDPUSTCvDwH/WpbE7spViRJvKwWPgEpC+3yfQ4J6
         WfrQPlqu5c03Sp0rs04P/GC5JJB9TniKwcWRkIrZEepxFBAredXf7Rp/GfWoL0RhNJaD
         Riag==
X-Gm-Message-State: AOAM5338GnGsx0hAsMGif6a97Qhn+EXxwU/c1hyjh0Q2UwWnHMrL4uak
        T7eFL28B0J6WiCtSbtrQ2XtNiaLP3ew=
X-Google-Smtp-Source: ABdhPJwWYtIBmeRMFFyrmnZp1CUY6dAfZLe3CPlBHlBdXORhWl9XfX/dsq8lvN1lhUh4QsJWeuA70xZbYLA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a0c:fdec:: with SMTP id m12mr3978002qvu.11.1612981574160;
 Wed, 10 Feb 2021 10:26:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 10:26:04 -0800
Message-Id: <20210210182609.435200-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 0/5]  KVM: x86/xen: Selftest fixes and a cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a '40' vs '0x40' bug in the new Xen shinfo selftest, and clean up some
other oddities that made root causing the problem far more painful than it
needed to be.

Note, Paolo already queued a patch from Vitaly that adds the tests to
.gitignore[*], i.e. patch 01 can likely be dropped.  I included it here
for completeness.

[*] https://lkml.kernel.org/r/20210129161821.74635-1-vkuznets@redhat.com

Sean Christopherson (5):
  KVM: selftests: Ignore recently added Xen tests' build output
  KVM: selftests: Fix size of memslots created by Xen tests
  KVM: selftests: Fix hex vs. decimal snafu in Xen test
  KVM: sefltests: Don't bother mapping GVA for Xen shinfo test
  KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64 bytes

 arch/x86/kvm/xen.h                                   | 11 ++++++-----
 tools/testing/selftests/kvm/.gitignore               |  2 ++
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 12 +++++-------
 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c |  3 +--
 4 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

