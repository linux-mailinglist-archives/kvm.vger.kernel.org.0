Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215073331A5
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhCIWmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhCIWmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 17:42:14 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DE1C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 14:42:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b127so18938692ybc.13
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7aKMO2SpBi/2Jz5ddHg49VoZBghMh9FLvFL9AICAYkg=;
        b=HqQeKzbp5rUdScMKxM5d8PuM/rJvjSiWPy0g9UPtNBCZwfsKdi69aYTzYIb1/qfg4C
         /a5CaBtfkCxqwZxJrA9EGSil4/G7r/ODBT2YTsZqWQRRgWj0MMW1JDs/UqyjfLWfB2CP
         ZsHcq2s6a8CWilWWBOn8IiaIoySs8PofJLR23ejm+emMMkzpqx5Xr+GNbXYFgej8n6fq
         9weleJ3jdffP0YIv98g/Ts3a3O635s85Rc3T2fg1z0NY9wfK55LdHtYatRdvh679sqZz
         RMrcVaswESabOtP0DaN5bceak8Jrp2sGZ1/w5A9aiH8tKBZuwShzHpCZTepgoI50nRB8
         WuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=7aKMO2SpBi/2Jz5ddHg49VoZBghMh9FLvFL9AICAYkg=;
        b=N9NfYFechwBn/7DcVV7Hzn28ejcFKwoJxPw2Zu0Mgd6SpngS4q/Z3tZGFR61ArkKm2
         88SnJnTSHvYf7OMc8J3k9/wCZFr/TuPsvEB6ydrmgloliXGKD6+31xdioWCbHGsOikkU
         nMD8U3JgRtLqc9hv0uYNlMVWzeTAOl1mHf9AXdAs14L5XOhEMn+XGlKcmFBBYnkBZRH6
         RgdzvY82UBYqEAG/Ugsd3z2+GlDbA+4FrlKKqwqSrTGNSyTJJBefUhMtv5pzM4opVdrN
         F7IQy49AsCV2mTYmm/jpDj9NfvphFudH8KaJjcsYs4SwQcb7UEQOGB6yiHcT+TEf34gL
         ienw==
X-Gm-Message-State: AOAM531Gtb8MUIqcbzG5M6/pDboiPdlJbsXTKPIaw1+a2ePZUaCYTxDd
        NgfPmM2ueN7n69msMA0H7hKpOzn1CQE=
X-Google-Smtp-Source: ABdhPJx3sXyVswQOYX3CiUvIyjRJH0JBj2aUh6zpV8P1spFgKD9Bxb6y2Vr+NUvEN0oDWXlJkM4KFFuYlR4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a25:4dc4:: with SMTP id a187mr162417ybb.78.1615329733767;
 Tue, 09 Mar 2021 14:42:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 14:42:03 -0800
Message-Id: <20210309224207.1218275-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 0/4] KVM: x86: Fixups and PAE+SME fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few stragglers bundled together to hopefully avoid more messy conflicts.

v2 (relative to the fixup mini-series):
  - Moved SME fixes from "PCID fixup" to its correct location, in "Mark
    PAE roots decrypted".
  - Collected Reviewed/Tested-by tags for MMU_PRESENT+MMIO snafu, though
    I expect they'll get squashed away.
  - Added the PAE patches from the SME shadow paging fixes to avoid
    spreading out the dependencies.

Sean Christopherson (4):
  KVM: x86: Fixup "Get active PCID only when writing a CR3 value"
  KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO SPTE's generation
  KVM: x86/mmu: Use '0' as the one and only value for an invalid PAE
    root
  KVM: x86/mmu: Mark the PAE roots as decrypted for shadow paging

 arch/x86/kvm/mmu/mmu.c          | 46 ++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/mmu_audit.c    |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++
 arch/x86/kvm/mmu/spte.h         | 12 +++++----
 arch/x86/kvm/svm/svm.c          |  9 +++++--
 5 files changed, 59 insertions(+), 20 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

