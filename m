Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A42410956
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 04:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhISCoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Sep 2021 22:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbhISCoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Sep 2021 22:44:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A26AC061574;
        Sat, 18 Sep 2021 19:42:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y1so1856588plk.10;
        Sat, 18 Sep 2021 19:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jL0YyZVYNJH18NhjsKC4FdXboGYe7Tnw5QmBZVOO0WU=;
        b=CE2LVR2Q5LIFuUVbwlSY3zrM0GK969+BFKkHmnW2ipzwoiTT7sCKT6l4Omebb79Z1H
         73EGTduin7EEbQ723Ooo8RJB+hP2laKGPpJQ4mKNgscpSY/Kl5J+V6zxLK1Ho6Wvjqln
         r0wwmEo8CiuzRrodfJlqiq4THNfpJUkoPDXOz5y6gRgzpO77dWiINPv7fcPTGM/MgK37
         oCZ0ohvmTCar+YzHMvRtPDnbUtblDcrD+SZaRByT+zCFDwtkCRLnjZj0qfJXgrwagejv
         e1SHQfpiGCTKLQKYozuC6xMQE+KZMpxeBlw/i5UMyykxQ9VZuhHaRv/7ONaL7RLMRlnU
         xIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jL0YyZVYNJH18NhjsKC4FdXboGYe7Tnw5QmBZVOO0WU=;
        b=YBoJgb/QAS2NEA2K/7NLJI6oPnXmQjNoJmEO+5KFohl9WcMFzVDRBrKlQJkKloj5II
         kESxDkxRL0rdomKeECj8sSZCJzAHcRPjOlolcv4X5qX5dox5gnJxCtSgmrB2gx+Ng34M
         gJbe9/qp2r7U6MWH3UXoX1Pdh+2mJOUOU1/9vjn1a4s0S+tkooT/FiktLDUk+dkSusrj
         3EvYQ7rHWHeHo/De87mUfwKjs1PiYh+vFtjbznXsJcbOWNhDmioiPcfTFR5DWpAa/B9e
         hjXCKELEDIzKH/Aq4+YWkKDSV6jt2EkZ0FO75kTe+65X1SvanxhTLiINkJ1/Ndu+2tKJ
         kZgQ==
X-Gm-Message-State: AOAM5329v7mI6S0DKKDwuNHbwFmNyFBbrT+Gf7Oxu1kPMGLsTV7PqAmd
        /1L38E5D/9t5lVWx5rKEIFbqd6vxmhWNmQ==
X-Google-Smtp-Source: ABdhPJx/wB3o5lG6xJlbJaRWTqWokYNiqF0hPzUuNzOutoCmmppCSa+HR07u5LIASG9vyu12W08VsA==
X-Received: by 2002:a17:90a:5583:: with SMTP id c3mr21002987pji.133.1632019359514;
        Sat, 18 Sep 2021 19:42:39 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id v197sm2409266pfc.125.2021.09.18.19.42.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Sep 2021 19:42:39 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 0/2] KVM: X86: Don't reset mmu context when changing PGE or PCID
Date:   Sun, 19 Sep 2021 10:42:44 +0800
Message-Id: <20210919024246.89230-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

This patchset uses kvm_vcpu_flush_tlb_guest() instead of kvm_mmu_reset_context()
when X86_CR4_PGE is changed or X86_CR4_PCIDE is changed 1->0.

Neither X86_CR4_PGE nor X86_CR4_PCIDE participates in kvm_mmu_role, so
kvm_mmu_reset_context() is not required to be invoked.  Only flushing tlb
is required as SDM says.

The patchset has nothing to do with performance, because the overheads of
kvm_mmu_reset_context() and kvm_vcpu_flush_tlb_guest() are the same.  And
even in the [near] future, kvm_vcpu_flush_tlb_guest() will be optimized,
the code is not in the hot path.

This patchset makes the code more clear when to reset the mmu context.
And it makes KVM_MMU_CR4_ROLE_BITS consistent with kvm_mmu_role.

Lai Jiangshan (2):
  KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
  KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE

 arch/x86/kvm/mmu.h | 5 ++---
 arch/x86/kvm/x86.c | 7 +++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.19.1.6.gb485710b

