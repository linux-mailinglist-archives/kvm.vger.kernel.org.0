Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D201456A64
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 07:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhKSGwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 01:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKSGwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 01:52:07 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947DFC061574;
        Thu, 18 Nov 2021 22:49:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x5so8636910pfr.0;
        Thu, 18 Nov 2021 22:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGiUb6VNu65Q9SC3WDDuRHXEAYLFGT/+dhifViSQsHA=;
        b=QdByiIA6wny1MP23GPJdb2XDFgPaxMyq7+S2DFWEhbX4St3Q6XqHB/pewnka90vtb4
         dWpLMxmCvGpnjBJjVDkSmRwSOwPBKo9i9YSsS7Xf6jIrQHLHj4HVK+gB1vDm6MQyS+Q9
         z8JMJMxQmhrbidr4LesphavAGqy++wo1/RZaOBEyQ2S5UFch9YZStwgqV0t641Q+0eai
         9bTdXcqFZUt93myioWcgxkKlHfKTPe56Yewa5tHA9H9JbTwLjjF5fsuLmPXys5/aDgr4
         6kt6uxPbMMrZYhNklmJFYj03yfLhmAX1EFgDrwS43GwNCRCm9uFXi74yXcfE+RgErOGQ
         4M4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGiUb6VNu65Q9SC3WDDuRHXEAYLFGT/+dhifViSQsHA=;
        b=OcTm/F6P/wG9uea3cT5CXHWOAEq/1QYgkxAPo/qedEEewt1dVbDKdnXUkw0E7UImCG
         4yZ123LCCV+eJJGOD6cl/RXUENyfWA4+d6SP9O83il+Oy8/6qQcNBQ0T1c/+7w4FDucB
         5iUttq5bfsWnP5FCDYpXYk7nTP9E/QP+zy5W4fI1wAV5Q7Eje2/RzTXyB81BfcEHitr0
         QuP6M/iQF5X9+p4/aiwMNEILxhXRfOIBALCckCZ372qwxiQIrSMh2dTFtXP4KNbHhLHI
         5u51TUqWPBP/fOaQR/yXfYdqePeoeVYl6uzk9VZOq+8lc766byZUFCr5uJAXKLh76O/K
         aupA==
X-Gm-Message-State: AOAM530TnZWL4/AOoo9lHRiJ8YQa0THAo4uTEmXEsut712HiTpFnjabT
        QZROoSXM4dqG0jUsjd2EY40=
X-Google-Smtp-Source: ABdhPJxLbpwoz6EieMFAtcTut9fnkKZfSLomk6tr9iVZSoly4JAni8zvajTXqtrObg1vwfepjJbrsw==
X-Received: by 2002:a63:491:: with SMTP id 139mr15775283pge.285.1637304546174;
        Thu, 18 Nov 2021 22:49:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mr2sm1286928pjb.25.2021.11.18.22.49.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 22:49:05 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: x86/pmu: Refactoring code by reusing pmc->eventsel for fixed_counters
Date:   Fri, 19 Nov 2021 14:48:52 +0800
Message-Id: <20211119064856.77948-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch set is essentially triggered by Jim's patch set[1]
(especially patch 01 and 04).

The new idea to set up and maintain pmc->eventsel for fixed counters.
This would unify all fixed/gp code logic based on the same semantics
"pmc->eventsel". (I demonstrated this in patch 01-03, more can be done)

v1 -> v2 Changelog:
- Rename find_perf_hw_id() to pmc_perf_hw_id(); [Paolo]
- Add WARN_ON for amd_pmc_perf_hw_id(); [Paolo]
- Add pmc->intr to drop dummy need_overflow_intr(pmc); [Paolo]

Previous:
https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/T/#t

[1] https://lore.kernel.org/kvm/96170437-1e00-7841-260e-39d181e7886d@gmail.com/T/#t

Please check each commit message for more details
and let me know if there is any room for improvement,

Thanks.

Like Xu (4):
  KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
  KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
  KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
  KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 58 +++++++++++++--------------------
 arch/x86/kvm/pmu.h              |  4 +--
 arch/x86/kvm/svm/pmu.c          | 19 +++++------
 arch/x86/kvm/vmx/pmu_intel.c    | 54 ++++++++++++++++++++----------
 5 files changed, 69 insertions(+), 67 deletions(-)

-- 
2.33.1

