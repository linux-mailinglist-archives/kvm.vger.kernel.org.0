Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DE568865E
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjBBS2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjBBS23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7B44FCE8
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:20 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a27-20020aa78e9b000000b00593f636220cso1361142pfr.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHjrByIjcxf6uyMzubBepGQGIbAZvtvLNJ/Zm5bnRdA=;
        b=ZB0eKaxiZ3/Ak/n3wqBW2vXjAmt8s+9Y41MJ8UO/egw3Id2O1nDXGiaOExY5lDfoGp
         U1Hh5tcNrCS3IMs33JmYD1DDgSVojBO/EA+fQeDUv1/c7mzXULgaMqaLMpGPnd+LMiPz
         Oa7Dh0bHoq5M0EKB5UyQ5Ykt9pv3+O+qx8c1CVfIe7fBm83dYyZb563mFrrYW5ew5962
         QELr1HWyA+dONy8FH+TEmz27qbFuh7L83uiN/BwGECp0SJhCimTf5GiNj61MWJyR5FgE
         9YQJCXmvxLaAH4sNH2bSVt4zlczfUxq5omwt7wmzgMI/WtGDk8skbN16D8wvjGRofapA
         O57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHjrByIjcxf6uyMzubBepGQGIbAZvtvLNJ/Zm5bnRdA=;
        b=ndUaF3EOGaQDGASRp98Z2Joun7b7mEqKBDZBmUlSMIBF2O7vhosd/xxRCUID8YDJqj
         gsp7xr4YpUox1N9oR3kyHxN0aa+ahW1L0l41KipPOUUdQ4+GRkfkkKdV6Efdw8RufLhT
         gAB2dgt1uk2DwqzATy6dFjUBMOpAu6ER0wSooiXZwc9PL26EHMChfOPDcssvAZY5NHkm
         6Bw05ft6z43mte/y7/KP/GtAToHqUrFkjf3WsRC6OR0XN5PjszaHIrGXgs3mxdTpJrVf
         MstwBklFncWDMwfCzdQJkYclYZObRNj9qAOLMkGDmqgK0zBt7VQgwrY0eKx0zA3bcjHs
         kXow==
X-Gm-Message-State: AO0yUKVNuf6ZBc+OIxaTS58bJRR8sZvfvxHH5OFPc+jqSQXUU5c1/jB/
        NqjiIxJhFsnp1kIZDu8fybQlpmA50oM=
X-Google-Smtp-Source: AK7set9sp2Ug7HmkFT9RNxuM0I5JUgtR7l2VFKmlpFI1fPuW2gdKa537KqXzkpHlIxJM4faSwuXubwtbMmo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:410c:b0:22c:8ba9:4ce2 with SMTP id
 u12-20020a17090a410c00b0022c8ba94ce2mr729494pjf.96.1675362500323; Thu, 02 Feb
 2023 10:28:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  2 Feb 2023 18:28:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182817.407394-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: x86/mmu: Drop dedicated self-changing mapping code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Hang <hhuang@linux.alibaba.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excise the MMU's one-off self-changing mapping logic and instead detect
self-changing mappings in the primary "walk" flow, and rely on
kvm_mmu_hugepage_adjust() to naturally handle "disallowed hugepage due to
shadow page" conditions.

When is_self_change_mapping() was first added, KVM did hugepage adjustments
before the primary walk, and so didn't account for shadow pages that were
allocated for the current page fault, i.e. effectively consumed a stale
disallow_lpage.  Now that KVM adjust after allocating new shadow pages, the
one-off code is superfluous.

Dropping the one-off code fixes an issue where KVM will force 4KiB pages
for a 1GiB guest page even when using a 2MiB would be safe (1GiB overlaps
a shadow page but 2MiB does not).

v2:
 - Track the "write #PF to shadow page" using an EMULTYPE flag.
 - Split the main patch in two.

v1: https://lore.kernel.org/all/20221213125538.81209-1-jiangshanlai@gmail.com

Lai Jiangshan (2):
  KVM: x86/mmu: Detect write #PF to shadow pages during FNAME(fetch)
    walk
  KVM: x86/mmu: Remove FNAME(is_self_change_mapping)

Sean Christopherson (1):
  KVM: x86/mmu: Use EMULTYPE flag to track write #PFs to shadow pages

 arch/x86/include/asm/kvm_host.h | 37 +++++++++++---------
 arch/x86/kvm/mmu/mmu.c          |  5 +--
 arch/x86/kvm/mmu/mmu_internal.h | 12 ++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  | 61 ++++++---------------------------
 arch/x86/kvm/x86.c              | 15 ++------
 5 files changed, 46 insertions(+), 84 deletions(-)


base-commit: 11b36fe7d4500c8ef73677c087f302fd713101c2
-- 
2.39.1.519.gcb327c4b5f-goog

