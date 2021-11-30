Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097FB462DAD
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhK3Hpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbhK3Hpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:45:50 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A5C061574;
        Mon, 29 Nov 2021 23:42:31 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i12so19736286pfd.6;
        Mon, 29 Nov 2021 23:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xS7DiSXPiwXIXVS3bMn+o90IeUNq7sqrwQBrl7B1pTY=;
        b=nhahWABz1xtVJyr3rZhdRMAbs0tZ1KjI8ZpVWUQW7v1YEjocgQCAq15syPEBCs4xme
         xNT+RYAFgWOmbHaSdxrn2x39Nde/+yOBMR9JwQWeKhyqQZ33+ZgXOk5BV7fBDnwJihHg
         KZ7NnW0Sk/GYfRQlJBpM4r9g4aPSvdfOCJi47Ha0aeytSjdbXdEmWJfc7ToNFQRebHvc
         45znFqSip27NbI58PERrLBMAgeR/sARHTKVizKh7ANOpd0NOB2H9hFxaCMRtbpSYjmHU
         pNJKwpyVRdlIBONmCC9qRm6EnFwozQYeid1lxblDuuDuQ09VRmIN7uTEsphOP7XXF9fv
         h6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xS7DiSXPiwXIXVS3bMn+o90IeUNq7sqrwQBrl7B1pTY=;
        b=uywglGLjrVqHaTe5a7uqGoLDTStmiHgejx9E3ya3YAxni9MIZg4EUntYDtEMUU6x2+
         UyVN1TcXRlzpGbvnRwbPuanlXq7zq3rOvmEE6UE6EoJTX/po+hmIzjPDphpdZTNQNB5i
         KZJnFZmC4yebHKUkK9jaPB2KRNZqty4b0mGkOfT4gS8sPJkvFBR5yHoKYED2FmXR5dTs
         FYW4e2W6AHZqpc+5P2v6w0f3qnVW5Dw95/Nno3WjEtHZEd/6GZ9VFkl3oiuPPBZ6rgR6
         S205VX1l1vL09yGwBMGjo6CY+GvQxbmDWQ3pQH/izgamgPCTypJmyR8NWS/cymoAlzU9
         bvcA==
X-Gm-Message-State: AOAM533UR7IP4oGUfSVlFxWD18fULdUBkx2ib03Pa8j8ZuMH0Uf8kX0u
        u+BF4xVurlP/Bks1xIRmiZaPxFXZAQI=
X-Google-Smtp-Source: ABdhPJze2OYhZJHSDl089lBw18AKk3BAPRklyW0dQdAp7N+o4rjOvICnQwRsPsox/sLJ9Tc7dnEi5A==
X-Received: by 2002:a62:1cc4:0:b0:49f:99b6:3507 with SMTP id c187-20020a621cc4000000b0049f99b63507mr45010524pfc.76.1638258150888;
        Mon, 29 Nov 2021 23:42:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v2 0/6] KVM: x86/pmu: Count two basic events for emulated instructions
Date:   Tue, 30 Nov 2021 15:42:15 +0800
Message-Id: <20211130074221.93635-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

[ Jim is on holiday, so I'm here to continue this work. ]

Some cloud customers need accurate virtualization of two
basic PMU events on x86 hardware: "instructions retired" and
"branch instructions retired". The existing PMU virtualization code
fails to account for instructions (e.g, CPUID) that are emulated by KVM.

Accurately virtualizing all PMU events for all microarchitectures is a
herculean task, let's just stick to the two events covered by this set.

Eric Hankland wrote this code originally, but his plate is full, so Jim
and I volunteered to shepherd the changes through upstream acceptance.

Thanks,

v1 -> v2 Changelog:
- Include the patch set [1] and drop the intel_find_fixed_event(); [Paolo]
  (we will fix the misleading Intel CPUID events in another patch set)
- Drop checks for pmc->perf_event or event state or event type;
- Increase a counter once its umask bits and the first 8 select bits are matched;
- Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
- Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
- Add counter enable check for kvm_pmu_trigger_event();
- Add vcpu CPL check for kvm_pmu_trigger_event(); [Jim]

Previous:
https://lore.kernel.org/kvm/20211112235235.1125060-2-jmattson@google.com/

[1] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/

Jim Mattson (1):
  KVM: x86: Update vPMCs when retiring branch instructions

Like Xu (5):
  KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
  KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
  KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
  KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
  KVM: x86: Update vPMCs when retiring instructions

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/emulate.c          |  55 ++++++++------
 arch/x86/kvm/kvm_emulate.h      |   1 +
 arch/x86/kvm/pmu.c              | 128 ++++++++++++++++++++++----------
 arch/x86/kvm/pmu.h              |   5 +-
 arch/x86/kvm/svm/pmu.c          |  19 ++---
 arch/x86/kvm/vmx/nested.c       |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  44 ++++++-----
 arch/x86/kvm/x86.c              |   5 ++
 9 files changed, 167 insertions(+), 98 deletions(-)

-- 
2.33.1

