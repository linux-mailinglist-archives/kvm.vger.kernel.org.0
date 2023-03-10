Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539FE6B3CDA
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCJKyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCJKyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:15 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F73FA8D8;
        Fri, 10 Mar 2023 02:54:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id ky4so5151529plb.3;
        Fri, 10 Mar 2023 02:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gVqG5NhG0nFZmXI2zWBr8TMVr7KzZm+96Iaa0+M5eGY=;
        b=Dj4TlmMtlXrruQ0V7HDrvBLHRbciMnWq2Kg8LWEd3h5ewWKEyOPOF/JwfOFLt25VQ8
         0eBOg56t4woIxq9AQxJC+BC9485cVNjyESBFVf08+QPOEwrxjQIorCGobf6+Sb5KUEQ7
         Z7HSvGalMtRN1bdOLlc5AzZAtDjg0WSehGtMMNki4pEgD50z9mu2uBwGZArxTSOu0Pvh
         mDpSrRY265pZMuoK2H4dzS2cfYU4N4/xBuacMHM8J+wcr5CpClO0n4haFV5i0BJyXa2h
         fWtsWUXJRq+y8HSIbMvaMCTJMTjD4T/75VCGHsrzTWaw3a0xj/z3XJo7DiqW3TPmzE0b
         e8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVqG5NhG0nFZmXI2zWBr8TMVr7KzZm+96Iaa0+M5eGY=;
        b=c0YsAO5cUdLxlHtpqP+mHh37dkC9A9DG+pCbAfs04lJO78as2AUyF90ZQOSKjgztYd
         GCFDF5jB0hTbrClA0Dd437WFPIyGBayU+BsXGSS0yRK5MXpdjGlY+4QBvDs9/B7Bh27R
         YP00shEOKEhzKaWd0lYrSvtVp4keoEo6j2AA9cSBisvgm5A+atX1F6F19TfbNaGXVLRF
         iJ9IIT1Hf/IxXFvXRG8+/ax80vkqkiQXYfM7pO4aGPoPPS15IiM8fkh7GS3bcQnkbS5A
         3ZovYTq/mSw2nNjaRR4m/iAwsbbw8RpPA9RqdQx4MoqsxrOOSlJEN0Lk6PwEiiLFgDKc
         Xiiw==
X-Gm-Message-State: AO0yUKVNAE8kvu3EGkeftU1Lp8DD28MoLGTRc06wh8xCWbFJlwskhmHw
        pol+Bm/NoNvisoFbfdntbxb5QpNcuoSh0VsoYRA=
X-Google-Smtp-Source: AK7set8yjfikTU4EBTUM4RvV2kKKFIIb0lfdGd4xr5qtng7HWzL+02QDFM2hx0Hk6IR65S2Hd3zU5A==
X-Received: by 2002:a17:902:6a83:b0:19e:866c:3547 with SMTP id n3-20020a1709026a8300b0019e866c3547mr21378804plk.65.1678445644511;
        Fri, 10 Mar 2023 02:54:04 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ks3-20020a170903084300b0019cbabf127dsm1174167plb.182.2023.03.10.02.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:03 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: x86/pmu: Hide guest counter updates from the VMRUN instruction
Date:   Fri, 10 Mar 2023 18:53:41 +0800
Message-Id: <20230310105346.12302-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Considering that developers are more likely to have access to AMD VMs
and use vPMU inside guest, there's a dark cloud that needs to rain.
The x86_64/pmu_event_filter_test always fails on Zen3 boxes:

  test_amd_deny_list: Branch instructions retired = 43 (expected 42)
  test_without_filter: Branch instructions retired = 43 (expected 42)
  test_member_allow_list: Branch instructions retired = 43 (expected 42)
  test_not_member_deny_list: Branch instructions retired = 43 (expected 42)

,which is not caused by the event_filter feature (otherwise it's zero).

After some dubious guessing and microtesting on Zen3+ pmu hardware,
we found that VMRUN or one of the instructions in __svm_vcpu_run()
causes a guest-only enabled counter for counting guest instruction (in the
pmu_event_filter case, the branch instruction) to always increase by one
right after each vm_entry.

This creates an inconsistency with the AMD64_EVENTSEL_GUESTONLY,
where the vPMU user in the VM does not expect to see any counter
changes due to the SVM transaction at all. This patch set provides a low
overhead software fix until HW change arrives or simply no fix planned.

Prerequisite:
KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
KVM: x86/pmu: Prevent the PMU from counting disallowed events

Please feel free to run more tests, add more or share comments.

Thanks,

Like Xu (5):
  KVM: x86/pmu: Emulate CTR overflow directly in kvm_pmu_handle_event()
  KVM: x86/pmu: Add a helper to check if pmc has PEBS mode enabled
  KVM: x86/pmu: Move the overflow of a normal counter out of PMI context
  KVM: x86/pmu: Reorder functions to reduce unnecessary declarations
  KVM: x86/pmu: Hide guest counter updates from the VMRUN instruction

 arch/x86/include/asm/kvm_host.h |  4 ++
 arch/x86/kvm/pmu.c              | 81 +++++++++++++++++++++------------
 arch/x86/kvm/pmu.h              | 37 +++++++++++++--
 arch/x86/kvm/svm/pmu.c          |  1 +
 arch/x86/kvm/svm/svm.c          | 28 ++++++++++++
 5 files changed, 119 insertions(+), 32 deletions(-)


base-commit: e79412ef245c53b2157458754327f39f43dd6a49
-- 
2.39.2

