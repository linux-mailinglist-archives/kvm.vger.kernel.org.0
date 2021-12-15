Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E909475061
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 02:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhLOBQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 20:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhLOBQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 20:16:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ABBC061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:01 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r9-20020a63d909000000b003312e182b9cso11367967pgg.16
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Dum5uuzQc6+fBFUfChCShPcDaDaNlCCyh9HPYMxf5Zg=;
        b=QZkYv1zHcaSU4WgRP3rO/8co9P6jsA5heGxdb6RYei05MrXmBjtsPhuSU4VF04HZdR
         Dl3U5u4Y+/Nt4igCegP5WmBTYDR9uwQACBeyeWpubcz0/LK8fCYIRRhG7YnXcKyQmiO6
         UH/u218aSBtoksjxqUDBJ5CX6xSC6UoK9qPJuCsQtpfiAfv9w4p7KEj5ENUvFnO9fHs9
         dKK7NI0zHObr085VSP81MtlGUp24KKdH4St5Wy2LUyQtYbZ8AYXNYAsGBaNnO/CtmgdL
         EkO5l1V0D4mWGQl5cML/QipSwSfj7/yQRGzIYMhyY7mIZsK2DrfuTM6296rV9nKk1pmd
         26OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Dum5uuzQc6+fBFUfChCShPcDaDaNlCCyh9HPYMxf5Zg=;
        b=jm6s5wb02HsyFU1Xfx2FE7taSxLw4sWz5Nm2qZChkAByGxFsWjxI6ASr8n7hF/ZXEi
         ddFd2HbBv20xmk1VE9UjJrybvtWg7ESYI2b2Alplzn0yjaP36Ytm1/sLlT/AYXSFBdxj
         EAiO2Be7saXThDv3j1MuRJeY5vbALsJYu4TkQu2E88ykTJWIRVO8tEk/+4CafcQzd7Oj
         IMYxeV1SxBbhGCZ2p9K98UBWp4/+3MFXKX7zIXspp/h03ATXgP60VmvykEnvCCQUQFQV
         4cJrPrsEcdKraqjwtGqvoA0XZj6u/hurL7B7oHYAEQvbAlUImPZdR9s7ZtyciaEij1JC
         8tUg==
X-Gm-Message-State: AOAM530zEGHjc9up/DafeOtGM6DLhLOaCKUgWz/N6HUylSnRWCUwtogT
        kYE7IVfHiPpUPktumB7YnxbqvikyraY=
X-Google-Smtp-Source: ABdhPJz1PCplQTuJimb/SA1V1PBxiqkExCSXsWQhQ7jSf7YEDuSD2V3/9bVvP0OBS/7OQm9HpR15aBeFRSM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:30e:: with SMTP id
 ay14mr9007932pjb.60.1639530960510; Tue, 14 Dec 2021 17:16:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Dec 2021 01:15:53 +0000
Message-Id: <20211215011557.399940-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH 0/4] KVM: x86/mmu: Zap invalid TDP MMU roots when unmapping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 01-03 implement a bug fix by ensuring KVM zaps both valid and
invalid roots when unmapping a gfn range (including the magic "all" range).
Failure to zap invalid roots means KVM doesn't honor the mmu_notifier's
requirement that all references are dropped.

set_nx_huge_pages() is the most blatant offender, as it doesn't elevate
mm_users and so a VM's entire mm can be released, but the same underlying
bug exists for any "unmap" command from the mmu_notifier in combination
with a memslot update.  E.g. if KVM is deleting a memslot, and a
mmu_notifier hook acquires mmu_lock while it's dropped by
kvm_mmu_zap_all_fast(), the mmu_notifier hook will see the to-be-deleted
memslot but won't zap entries from the invalid roots.

Patch 04 is cleanup to reuse the common iterator for walking _only_
invalid roots.

Sean Christopherson (4):
  KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
    hook
  KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
  KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
  KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots

 arch/x86/kvm/mmu/tdp_mmu.c | 116 +++++++++++++++++--------------------
 arch/x86/kvm/mmu/tdp_mmu.h |   3 -
 2 files changed, 53 insertions(+), 66 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

