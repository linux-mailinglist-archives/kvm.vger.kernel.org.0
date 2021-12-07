Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7B846C3A3
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhLGTdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhLGTdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:33:41 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AD5C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:30:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so2939904pll.11
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=MoB4jyyuM207pVL6/iUpbqYwkxDsVhtPToauP0BYAVI=;
        b=IukAaH+brEOfA6uAAmYlfeQn5Z9ENUrwh7/plyA6VjvQv0ScLwr/5tusnfM2lYiNxo
         SJBp9P5tU9t24TDHoGZpp7AI/hoq1Or/SO2uQY+m0+xqAtGISl66jDkDwq8Zs3nvjyM+
         zJVPvPdlt9G7VO1I708vmSvc0z9Ai6chUT7X+TW74QfQajgHpOwafQafp1iwvANxkIuP
         ZHTALzJQLelcpFOr2Mmc2g+bX0Qz0aEFRUGfzzonj6gGovTsClTb2QbWQo8XlEHe3TEG
         R1fn91teJjnw+9UgU2abqzuhBdj5KZV6pDV7cpiESMFVL892obWRkWaHLwdlRT5lZFGy
         rXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=MoB4jyyuM207pVL6/iUpbqYwkxDsVhtPToauP0BYAVI=;
        b=PSgdp6Ai+g83qFWDrjvohUqf6dvg8pCZJIDYw5pSHCegJHMj+7PW/gXUwKL9PTEBfY
         AOB7cMhDblyBxzmrYvrnoVldFCafVs4OuQWsePog83nParkIrD0R20kNzzv/3SzhUQmy
         pYfQTj2bhCqsNXbudjM8ydI7nX71pcgvOxXLPaHEXML1jsgnLHruuG76QcOdjBqsH2sB
         S6oM0v5S+Nlhp0tpX/d9u97gFQiS82A+tbsSjRYJHpnYJOpJ2A/BZf42/MyieWXNphwX
         SmwqG5QsebFmFLgGVB/UuJLI00zWDYSfygBCKokbWF39GwkYm3cMjCfQqEPygoyxlPFj
         yBsw==
X-Gm-Message-State: AOAM531XUOcJZ9B2lY4Q/9Y9CUtu0ohqhAJ2LDfSh6aMVKf/lVNHE523
        54JZ6aCwz2vP9WJN8FKvxoCTMO/ZWrU=
X-Google-Smtp-Source: ABdhPJyHSZ0dpc4ulcH9BdyTZms9DzkIG21zOKBsrIyBcO2fL0yJBWYjtfhhN4e8QI13tmZOMK23KZ2CwCg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:4043:b0:142:4f21:6976 with SMTP id
 n3-20020a170903404300b001424f216976mr53889305pla.62.1638905410479; Tue, 07
 Dec 2021 11:30:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 19:30:02 +0000
Message-Id: <20211207193006.120997-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 0/4] KVM: VMX: Fix handling of invalid L2 guest state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes and a test for invalid L2 guest state.  TL;DR: KVM should never
emulate L2 if L2's guest state is invalid.

Patch 01 fixes a regression found by syzbot. Patch 02 closes what I suspect
was the hole the buggy patch was trying to close.  Patch 03 is a related
docs update.  Patch 04 is a selftest for the regression and for a subset
of patch 02's behavior.

Sean Christopherson (4):
  KVM: VMX: Always clear vmx->fail on emulation_required
  KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
  KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
  KVM: selftests: Add test to verify TRIPLE_FAULT on invalid L2 guest
    state

 .../admin-guide/kernel-parameters.txt         |   8 +-
 arch/x86/kvm/vmx/vmx.c                        |  36 ++++--
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../x86_64/vmx_invalid_nested_guest_state.c   | 105 ++++++++++++++++++
 5 files changed, 138 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c

-- 
2.34.1.400.ga245620fadb-goog

