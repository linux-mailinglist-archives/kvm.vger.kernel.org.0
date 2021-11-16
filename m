Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6308453206
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhKPMYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbhKPMYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:24:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA66AC061570;
        Tue, 16 Nov 2021 04:21:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id iq11so15620741pjb.3;
        Tue, 16 Nov 2021 04:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGunNnA0ehqJBZXzMtKjllq/AXIDZHQK3zRwqjaEorw=;
        b=iYsibB7z4Ip5qrb9o0dLivJ+TFnOnFslqjDmKwAFoPZcYTP/rqbP3AplBlNPNbOlcl
         RtV+VqasUO8GvQT6zf1FhTcJdc30uA0BFb7+pm+VAehBkhTchEbeoyzZbvmD0plIR4Ei
         xcVmzAKrXKGw3Bvq8G8E3I9vGmvXWA7SB4n2Lky1YdERX/rBj99vdEhwa8w3ceRtorWQ
         XorYF9hsTsTrEMIPtYT0201pnS7L9TlHbShg02t48h6G7EeiinBYkQ5Tsa9/Hewe1zqs
         MVJRw9bh1vplzoF3Q41GTUa1Kr1kHSbda5DmC/IriNo3xUu2Qvi/NFmH0+gCZR3kC0lL
         eHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGunNnA0ehqJBZXzMtKjllq/AXIDZHQK3zRwqjaEorw=;
        b=pREV61xx7bYQTfit/uiknDNYXpTkb67Y9lo6UTfKg7KYJTggMb/3IWfIRGlhNnEfk5
         e1wsg/UWJ1/Q2qEHzs/u/DiRyAaVR/4Tg+K1NyyHy9vjpksW9ciO9NXh1xfRxj/rGpBd
         JNFf1gH5g4p19K0vYVa5LKfrD1U+BgZAnzpRp57Zrvegm39qsk06PbiYNf+tUEqUhxy9
         EeIsT35A5cDJ4SHS5iPvLXK2zIErrgrOA1IWCeskR3zqUpIPKr+2mY8LMKNneJqFWuoJ
         Sk0cVxy7WheS3XyyQxptjOueuylwTpKh517QK6uX6OkncHUpVPh0kU16gELSr2aQLVvc
         MU7w==
X-Gm-Message-State: AOAM531Ap671rlLGahynzfc2ZaMWLL3vnn7Ex9WvAgrMEUz9iebdpggR
        3ar4xu3OQbz+NTI3nbIzyWc=
X-Google-Smtp-Source: ABdhPJzgiFbkF2ly462apig3kWTJllNzQf1adcNZK3/mxuDL/SJGSZRjeh3fiCL6VlCCMPlDKZ1MZQ==
X-Received: by 2002:a17:902:d88b:b0:142:8acf:615b with SMTP id b11-20020a170902d88b00b001428acf615bmr44900441plz.62.1637065281224;
        Tue, 16 Nov 2021 04:21:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i67sm18557613pfg.189.2021.11.16.04.21.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 04:21:13 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: x86/pmu: An insightful refactoring of vPMU code
Date:   Tue, 16 Nov 2021 20:20:26 +0800
Message-Id: <20211116122030.4698-1-likexu@tencent.com>
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
"pmc->eventse". (I demonstrated this in patch 01-03, more can be done)

[1] https://lore.kernel.org/kvm/96170437-1e00-7841-260e-39d181e7886d@gmail.com/T/#t

Please check each commit message for more details
and let me know if there is any room for improvement,

Thanks.

Like Xu (4):
  KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
  KVM: x86/pmu: Refactoring find_arch_event() to find_perf_hw_id()
  KVM: x86/pmu: Reuse find_perf_hw_id() and drop find_fixed_event()
  KVM: x86/pmu: Refactoring kvm_perf_overflow{_intr}()

 arch/x86/kvm/pmu.c           | 74 ++++++++++++++++++------------------
 arch/x86/kvm/pmu.h           |  4 +-
 arch/x86/kvm/svm/pmu.c       | 19 ++++-----
 arch/x86/kvm/vmx/pmu_intel.c | 54 +++++++++++++++++---------
 4 files changed, 83 insertions(+), 68 deletions(-)

-- 
2.33.1

