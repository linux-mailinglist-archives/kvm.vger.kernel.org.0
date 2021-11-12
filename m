Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E17644E430
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhKLJym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhKLJyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:40 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A95C061766;
        Fri, 12 Nov 2021 01:51:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so5849743pjb.1;
        Fri, 12 Nov 2021 01:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDKtx93jd8fAz2Pl35IpGMs1LZTHCC9vpdHi3HQr1lQ=;
        b=cG7jFK44F37B90w8Zvdzv7553lc2wv3hpVN3o+e0xNCKmb8nYg56sY3NQBlgUMg97e
         ZKx0S+8X1e9zPNfeFjDnrE8yGTcQWwsGuklmY4HckeJ21vkjFvUL+HDhdd6+z0unV90n
         uQJLJsfiCZhfrjULCmLhUg96ooMFhglIOhZ6hlIFhPIcA4/LjIowlywwI1ZZ1Id9nmTr
         Q0bSx5MYdAgMmO7/Z8qO7uucC+/1fcLHQBMAv2Ljt/+xR1XGWq4Giz0qx4E4W0VM4Tfg
         arg+hkEjI8V7IQ38RE7lKV6oK4wfBFgYxwjR8t5CrBLVA6R6DB5R+vvsVTUBCIfgqoNP
         xC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDKtx93jd8fAz2Pl35IpGMs1LZTHCC9vpdHi3HQr1lQ=;
        b=Ou8FWQLeUDsFnMV0RLALhwesPdP0aSNNggHm/LwaAqUdca4QClIRXSctvDd7yKf1hi
         566+0kCCmY7WwZtd+EtIPkg4QK7onfn8X0HMzQxi6j/Cn+UyEwxyLdGe0HulJ4Wn23y5
         Cri7Bz5EujrpmyCg5ENxEDcD/VnYd2eONGabQNN5bFYWbH+HHRgueSAIykYrjyJnI6zN
         gaHiY8mm33g5J8jSN3JT0R6qoR9itsBX3p9AjbrV+pPYm5bKmHGexhw/f/qDr4ORFk1n
         O0xRxp64vv9It4KidwHXWOL+3mKZwEOPQwIsDjSdv0jsCU4+LCpdkEwcLsxDc1IMXB4C
         HThA==
X-Gm-Message-State: AOAM533y/L8SEeP4WAGNIosxdAMzfsXtFO4iPo1XGzF8uN3YFLqVLpy5
        bRb04p2j4C9ye4vvxGVaFt0uarYuWJE=
X-Google-Smtp-Source: ABdhPJxQeYQmc2sLh/020us9gJNoXCLIUdNnLNo5nuO3r8W4k4KqSK/kNsh97MJKi/ThES/RpA/Mzw==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr35183316pjb.12.1636710709545;
        Fri, 12 Nov 2021 01:51:49 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.51.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:51:48 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 0/7] KVM: x86/pmu: Four functional fixes
Date:   Fri, 12 Nov 2021 17:51:32 +0800
Message-Id: <20211112095139.21775-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The first one (patch 01) is to fix my childish code about the disallowed
fixed ctr3. 

The second one (patch 02) is to fix the aged inconsistent behaviour
about CPUID 0AH.EBX. 

The third one (patch 03/04) is to avoid perf_event creation for
unavailable Intel CPUID events.

Finally a new way is proposed to
fix amd_event_mapping[] for new AMD platforms.

Please check each commit message for more details
and let me know if there is any room for improvement,

Thanks.

Like Xu (7):
  KVM: x86/pmu: Make top-down.slots event unavailable in supported leaf
  KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event
  KVM: x86/pmu: Pass "struct kvm_pmu *" to the find_fixed_event()
  KVM: x86/pmu: Avoid perf_event creation for invalid counter config
  KVM: x86/pmu: Refactor pmu->available_event_types field using BITMAP
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Setup the {inte|amd}_event_mapping[] when hardware_setup

 arch/x86/events/core.c            |   9 +++
 arch/x86/include/asm/kvm_host.h   |   2 +-
 arch/x86/include/asm/perf_event.h |   5 ++
 arch/x86/kvm/cpuid.c              |  14 ++++
 arch/x86/kvm/pmu.c                |  35 +++++++++-
 arch/x86/kvm/pmu.h                |   4 +-
 arch/x86/kvm/svm/pmu.c            |  24 ++-----
 arch/x86/kvm/vmx/pmu_intel.c      | 106 +++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                |   1 +
 9 files changed, 153 insertions(+), 47 deletions(-)

-- 
2.33.0

