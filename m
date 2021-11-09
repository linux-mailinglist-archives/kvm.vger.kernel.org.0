Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B344B21C
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241220AbhKIRrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 12:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhKIRrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 12:47:17 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C356CC061764
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 09:44:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso12943002pgi.21
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FN6HjG0tcv6VU84KzdC+5qqXmqwIf4ja4qG1uH2h6QI=;
        b=GP1yB+DXfQHn6aAWpkWj5hv/quucEvUQASEDNfG9t8E21/ixJumDrMQTCMamtqNaTw
         7rCHcTEf2qWaYMCeYPFpmGCyLqIE3CMiFD+NZw9Ayr5AX5JSui3Puokv9spWTPPOmWIv
         e+p+ZGx9L9S/zRKycprY459PmLrmFpNAXm34uYkqnIWtrW2jbVQwvPHzaXZyxMJW38AT
         iz3fm9aHwg3nhbq/8uqZmTlCGUM+liWFHHAs4+dR1w0nDtC2tWbXOZGbAbZB8xPyL9HZ
         Ri7X1WTVjCSaggNP29msvjyC8qGHRM1ZgVkh3pGbKysEr25EhrctEmNsZCIm+1igiArl
         NoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FN6HjG0tcv6VU84KzdC+5qqXmqwIf4ja4qG1uH2h6QI=;
        b=0ms8rvf+U3SNWLj8+qzoY/dvSo5Tf0HDv7aIV5Z5a6Px6rMr4zaYrnxaoJ0pYrJfmv
         vhFS31jhdjhfC/AYFZ4TO5bScnaFh5/v/C2aIdXgsQMExtB3HeODtKnjs+NG5gLuBKt2
         8a0X2thCfiunOC6Tqqx+yUFqVWARxNBm9PXLOHNL6GgPLTO8VRJIUOyZosUN7j7ZWnmB
         QJRyqCA/jhzV+WpkxZs8FUKwGGlW0EB8UGTbFIbUb8AxW7hBChF3I+KGo5fVTAFEI/MS
         hkzjCXYTFWOvSJKS/kFFGk+cReAYBkq4+wJWO3+p6tWRvn2En+pnbHLfg1Jen/lVlMoA
         MnPg==
X-Gm-Message-State: AOAM533wp/3h4Kdzfd7ejf3aYkVGLI1XPdqTSJdsRs4k9NYpPkCNFvNT
        mV1ByoL8dlEKHVw3S4gYn96hxDz19VF2
X-Google-Smtp-Source: ABdhPJxlWuiqZzuRC8gbqXKOO5ZT6HmKZbwnztkngDeq5qs3gRtGA5GbP3zrKElQjNabzUwe+YS/Dk6CbriU
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:4c0d:: with SMTP id
 na13mr9179482pjb.206.1636479871208; Tue, 09 Nov 2021 09:44:31 -0800 (PST)
Date:   Tue,  9 Nov 2021 17:44:24 +0000
Message-Id: <20211109174426.2350547-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 0/2] Add a helper to read GPR index and move INVPCID
 validation to a common place
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID, INVVPID, and INVEPT instructions retrieve the GPR index
similarly to find the invalidation type. Patch 1 moves the shift and
mask magic to a single place.

INVPCID invalidation type check is same for both VMX and SVM. This
instruction is not documented to verify the type before reading the
operand from memory. So, moving the check to a common place in patch 2.

v4:
- Changed commit message of the patch 1

v3:
- https://lore.kernel.org/lkml/20211103205911.1253463-1-vipinsh@google.com/
- Patch 2's commit message is more detailed now.

v2:
- https://lore.kernel.org/lkml/20211103183232.1213761-1-vipinsh@google.com/
- Keeping the register read visible in the functions.
- Removed INVPCID type check hardcoding and moved error condition to common 
  function.

v1: https://lore.kernel.org/lkml/20211011194615.2955791-1-vipinsh@google.com/

Vipin Sharma (2):
  KVM: VMX: Add a helper function to retrieve the GPR index for INVPCID,
    INVVPID, and INVEPT
  KVM: Move INVPCID type check from vmx and svm to the common
    kvm_handle_invpcid()

 arch/x86/kvm/svm/svm.c    |  5 -----
 arch/x86/kvm/vmx/nested.c | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c    |  9 +++------
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 arch/x86/kvm/x86.c        |  3 ++-
 5 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.34.0.rc0.344.g81b53c2807-goog

