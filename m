Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C777D448
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbjHOUhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238543AbjHOUha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:30 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E461FE1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:36:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6887a398cd6so390257b3a.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131815; x=1692736615;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YoEkSRdBdZpCM/slmFWAIl3VceQSDmIEC1qF4OaGbzU=;
        b=043CYGX77s29ipG5tICs4k3MhRhmyS2MaijT4zgA9fT1ubJIFXDv0411+vP90njY4t
         KKZJ/UDTgbFXX9uQPh+qsyUKhSKhDJ9WWNjN49KE08N6TeohMBpah+yPA5GBuyoLYVvq
         ZW6ydmp/CAR2D2D1Uxj/S7G5z+rzoFAjjgXF8KHDU72nBmiJU+9N97G0vTVn446vHCWT
         7FD1qJA6A2s70U+g1KWqn9PJfvipJ/nLKJH6x2I2/nd2NF93mGTPS2Hxp9QkYC53KOTU
         uyO0e9cMXALFiqwaz777dAZhPfqfomssEEuJ39pwWe9g2DUl9PhuOEeFVg4Gykutr5s9
         ZlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131815; x=1692736615;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YoEkSRdBdZpCM/slmFWAIl3VceQSDmIEC1qF4OaGbzU=;
        b=hReTKcYimy3UtfUVhlPfK9r5viluBRhhe8R3tm386AMEQIP7d8HZT6VJ5njrmtMQWx
         lBRVsBequMyqZvxddw62P55HbEfYYI62O1q2016941Yatfh3PcZVjZHxf79LJeFwUe+l
         UH05eKOpDdrUoJrNvLg6HRge/goIsuWKZlZ6Y0ZhwJVTuRl7fqoA0tJYQec1yF/hWLPk
         HKOwL7hhNa1Or+Zs4iMho+fqKQ2MAGkokTxSIRrkuZaOj7vlaXWcdu8C83/T5N7aIuWu
         vm2TDDwmuwABLWOTz9lTllMNXAxzo3jpmcpXKAiRnFUnVfasv8gn60bvUfPMAODfkvIs
         GkTA==
X-Gm-Message-State: AOJu0YxLbwU3ML3e09wTZLr2sMUIdWA7GlrO+FKANne0Gncf0kwbTcJC
        YWUgYqKN4PwACWWnYtFuNB0UXred+pE=
X-Google-Smtp-Source: AGHT+IFknvuPI+mTAPx3GC1V2RZaoCHhNTR3vUISIodOT1mcxVXFnOAYopwpCuC9ZoRU8VLH8/02a8s6L+E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0f:b0:687:4554:5642 with SMTP id
 g15-20020a056a001a0f00b0068745545642mr5953855pfv.0.1692131815715; Tue, 15 Aug
 2023 13:36:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-1-seanjc@google.com>
Subject: [PATCH v3 00/15] KVM: x86: Add "governed" X86_FEATURE framework
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Third and hopefully final version of the framework to manage and cache
KVM-governed features, i.e. CPUID based features that require explicit
KVM enabling and/or need to be queried semi-frequently by KVM.

This version is just the governed features patches, as I kept the TSC
scaling patches in kvm-x86/misc but blasted away the goverend features
with a forced push.

My plan is again to apply this quite quickly so that it can be used as
a base for other series.

v3:
 - "Drop" TSC scaling patches (already applied).
 - Remove dead xsave_enabled code (snuck into v2 by a bad conflict
   resolution). [Zeng]
 - Make kvm_is_governed_feature() return a bool. [Zeng]
 - Collect a review. [Yuan]

v2:
 - https://lore.kernel.org/all/20230729011608.1065019-1-seanjc@google.com
 - Add patches to clean up TSC scaling.
 - Add a comment explaining the virtual VMLOAD/VMLAVE vs. SYSENTER on
   Intel madness.
 - Use a governed feature for X86_FEATURE_VMX.
 - Incorporate KVM capabilities into the main check-and-set helper. [Chao]

v1: https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com

Sean Christopherson (15):
  KVM: x86: Add a framework for enabling KVM-governed x86 features
  KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES
    enabled"
  KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
  KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE
    enabling
  KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_XYZ"
  KVM: x86: Use KVM-governed feature framework to track "XSAVES enabled"
  KVM: nVMX: Use KVM-governed feature framework to track "nested VMX
    enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling
    enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LOAD}
    enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "LBRv enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "Pause Filter
    enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "vGIF enabled"
  KVM: nSVM: Use KVM-governed feature framework to track "vNMI enabled"
  KVM: x86: Disallow guest CPUID lookups when IRQs are disabled

 arch/x86/include/asm/kvm_host.h  | 20 ++++++++-
 arch/x86/include/asm/vmx.h       |  2 +-
 arch/x86/kvm/cpuid.c             | 34 ++++++++++++++++
 arch/x86/kvm/cpuid.h             | 46 +++++++++++++++++++++
 arch/x86/kvm/governed_features.h | 21 ++++++++++
 arch/x86/kvm/mmu/mmu.c           | 20 ++-------
 arch/x86/kvm/svm/nested.c        | 46 ++++++++++++---------
 arch/x86/kvm/svm/svm.c           | 59 +++++++++++++++------------
 arch/x86/kvm/svm/svm.h           | 16 ++------
 arch/x86/kvm/vmx/capabilities.h  |  2 +-
 arch/x86/kvm/vmx/hyperv.c        |  2 +-
 arch/x86/kvm/vmx/nested.c        | 13 +++---
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           | 69 ++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h           |  3 +-
 arch/x86/kvm/x86.c               |  4 +-
 16 files changed, 232 insertions(+), 127 deletions(-)
 create mode 100644 arch/x86/kvm/governed_features.h


base-commit: aaf44a3a699309c77537d0abf49411f9dc7dc523
-- 
2.41.0.694.ge786442a9b-goog

