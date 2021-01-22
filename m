Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECE300DEF
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbhAVUmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730424AbhAVUlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:41:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7203EC061786
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:40:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v187so6662749ybv.21
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=FIOLACkSO6nryo8JeCYd3HKHXp0oZhl7wC2aMQwMaBA=;
        b=SzyXwjEX2caDz80LmuG/3wfIagraEzkLGr5vD9SXkZ1xc4ZDawzMdOrzZ+pdApm9Ba
         eyE5GGffRAqt5F/y9/pnXY7uBdh+MARNJsgF+Xb2tDsXQzrr+Z+pSkdP1mQo1W15Lcgf
         4Q8pORTcoXNTqCpls4c9Pmb4rHE9br3NLgy0+AK7IV8AEJbW7LvzUIOBBYLj9+jLsHq9
         EI5qSXrZdjWbWqFtj7Hcnc+TNjls6BKgUfDIyxVGSX7wuS6Pz884X8N1Ei62u1jjQ2Qe
         oH8PbZ1XFmdOp5V+exKBg2OAiC22iCVyhkF8OZ91T7iRZd1t9wyvQH8Kf6O/Lwefinnr
         ws1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=FIOLACkSO6nryo8JeCYd3HKHXp0oZhl7wC2aMQwMaBA=;
        b=ZblefyGDBAaphnd6LiwudGmlKvgBg0Zc02mxEL16/yU8ZhhisLOEXj3a2fI54EUp9D
         VJvIvCLE1/lc+s1bc7jmLX2lnd6b3pgsh+i0xIbD9thjGjDVAZbp8BgIInKc5deYpmnj
         lznOC8PUXH5hGwhj8hREKKD9ANwtaOFQ43/B2AVkDqdR3qa465/Up/X17LVsEHkCZL1j
         a9vwt4BQTgkkFB/jFvByGiOx9Bole5Bsp0Lx7KOgFOYA+xquGK4+MjNp65rZx0PGwjDz
         rRi1KG/Dvm6wqs/G1CG5CLAMx1eDNgbw2AxLIdsS3UDYNmPtAYWsFThCYGpHMhAtiqQ4
         oFBQ==
X-Gm-Message-State: AOAM532+aHDwllvOwiwSYVKl223rN2p4kAqyXb2RIQByKxuA2c6ZzlO5
        i/Dcd3k1TMjRepji2V8oTOGHqkkdBuA=
X-Google-Smtp-Source: ABdhPJxw2kXOylXelY+e+VrRcikSrMQvWa+F8P8gAbto9U4XixM49Rj0DclM5mdOXsaVfZna2NR5UI2F3PE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:cacc:: with SMTP id a195mr9176545ybg.306.1611348055581;
 Fri, 22 Jan 2021 12:40:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:40:45 -0800
Message-Id: <20210122204047.2860075-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 0/2] x86/cpufeatures: KVM: Add mem encrypt word
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gather the AMD memory encryption features into a dedicated word for CPUID
0x8000001F[EAX] and use the new word in KVM to adjust its reporting of SEV
support based on host kernel enabling.

Paolo, can you ack patch 2?  Boris is planning on taking this through the
tip tree.  Thanks!

Split out from a larger KVM SEV cleanup series[*], thus the somewhat
questionable v3 tag.

Based on v5.11-rc4.

[*] https://lkml.kernel.org/r/20210114003708.3798992-1-seanjc@google.com

Sean Christopherson (2):
  x86/cpufeatures: Assign dedicated feature word for
    CPUID_0x8000001F[EAX]
  KVM: x86: Override reported SME/SEV feature flags with host mask

 arch/x86/include/asm/cpufeature.h              |  7 +++++--
 arch/x86/include/asm/cpufeatures.h             | 17 +++++++++++------
 arch/x86/include/asm/disabled-features.h       |  3 ++-
 arch/x86/include/asm/required-features.h       |  3 ++-
 arch/x86/kernel/cpu/common.c                   |  3 +++
 arch/x86/kernel/cpu/scattered.c                |  5 -----
 arch/x86/kvm/cpuid.c                           |  2 ++
 arch/x86/kvm/cpuid.h                           |  1 +
 tools/arch/x86/include/asm/disabled-features.h |  3 ++-
 tools/arch/x86/include/asm/required-features.h |  3 ++-
 10 files changed, 30 insertions(+), 17 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

