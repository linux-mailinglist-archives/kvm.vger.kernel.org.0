Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FB644B4EE
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 22:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244219AbhKIV4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 16:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244174AbhKIVz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 16:55:59 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA8C061766
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 13:53:13 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x14-20020a627c0e000000b0049473df362dso624086pfc.12
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 13:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=vm1/z3g+vC5w97J0eeG7Qsh9oIK8ruQ0iTlwWy8IP/o=;
        b=nhL/yS0M61GJlon3p6dXxcIr4UVG+0uj1/At1dwAiHCoqBacwzrP2P0dLop0ZpsrZC
         nFboVlEnVXLv3Rui8x9TdT7WMd+3X4uHT1cdJIif3/drVrPAKH4fPqvRsBpil1GasrFu
         N+AWCyLhVhUdq9BEvEaAjEcpOLpmF9A0ffbkUpWHjzGqup5BBtQtabu0cF5CR8yqDjPa
         GzHfk5jM4NyFJ9QPnTvOpPicpW1OKbdOO5DZ4W+FSPVyBeH5lDPBuwQJFM1raQ7DU96V
         jsw2ToHIjvAWMRiF1x1jnti21gQz0b0oXWOqJH3yasMTxayEucOjiTYaLykxoYo60Yld
         4bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=vm1/z3g+vC5w97J0eeG7Qsh9oIK8ruQ0iTlwWy8IP/o=;
        b=yzC1swai6Le8OXl9s3JYfSUp7Rgc/p5G5ImXQ8gKSFRxQ0k6OcamxAy/EC/HXFIX+H
         +lNv913+h3W1aHQkjLdv5BAy7rxaeNqusVcTW31hTBr/rSpXBCipc0RtLeC0FZ23u027
         8Awq4dEjPmVeDN51Q6dXt4rORH54YODX63jkf/b0+ZXnZrZU2DHpowg1wcpLXJqGRnU/
         iJRg5gM+Hn014Gj49CFTvB/FfN4ZNlfajhj1YFUj3aC70r5Zvdbfcp3oKOYyJDEIA70/
         9LulmQSnVs6Mebl+ZoTeoCez5yoicBOThWRRfEwpyOBMHyYO5mSzCs+LOOIQ1U3rkExc
         ujrA==
X-Gm-Message-State: AOAM530B8XMHa3r39TDajzzUobjZB9R2Q9YTd/nQVp4EBsiqdf/nq2GZ
        77FO+PdJ1EwFpzwpATpufgRWmf59pVc=
X-Google-Smtp-Source: ABdhPJyDUdDMkIA9Rexpi4xCcoy4cvsHlm4kiDyB4KxpLmnrUwx9UalA3ivmLSsUuphJn7dJqv71a2GxVRo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr119733pjf.1.1636494792437; Tue, 09 Nov 2021 13:53:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 21:50:55 +0000
Message-Id: <20211109215101.2211373-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 0/6] KVM: SEV: Bug fix, cleanups and enhancements
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bug fix for COPY_ENC_CONTEXT_FROM that IIRC is very belated feedback (git
says its been sitting in my local repo since at least early September).

The other patches are tangentially related cleanups and enhancements for
the SEV and SEV-ES info, e.g. active flag, ASID, etc...

Booted an SEV guest, otherwise it's effectively all compile-tested only.

Sean Christopherson (6):
  KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs
  KVM: SEV: Explicitly document that there are no TOCTOU races in copy
    ASID
  KVM: SEV: Set sev_info.active after initial checks in sev_guest_init()
  KVM: SEV: WARN if SEV-ES is marked active but SEV is not
  KVM: SEV: Drop a redundant setting of sev->asid during initialization
  KVM: SEV: Fix typo in and tweak name of cmd_allowed_from_miror()

 arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.34.0.rc0.344.g81b53c2807-goog

