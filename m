Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0E767A8C
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjG2BQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjG2BQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D33AA9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d27ac992539so1150974276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593372; x=1691198172;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJkpJZhQugJruq9ZGSna/diiNivrwzOkBsEj4Xcrf14=;
        b=3jil1H5CD9WwizZiZJ5IA2BD9pbWShS/TS6cFpS6ArxZOsfmKXhUSZrAsq/cLYuygd
         bEPFvXQRgI6MX1uxLhUPOv8mdq+Ji9kI3+yI6qlEl3xXLVi1ikhnTyWnXjAj577Wfomi
         rE72n/3qt7uBML4Yd4I3/EV8DNVwZmJfz+d3jCH4+IY5Jhl+AWU8NHe04wWTEzxvSaSy
         53dV5rfFQr5Gf0hpmexY89nHB07Y+gu7tPGJcG9bEKgQPwsvUR69Oeq2lAFF9iEFwdAh
         sWlWa72ygUDmrEm+2OKA8ZAWyq54Zjh2R0V8uFE1O7e+UHlgOR8ZpuxsX/B9/KErDsMj
         bElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593372; x=1691198172;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJkpJZhQugJruq9ZGSna/diiNivrwzOkBsEj4Xcrf14=;
        b=eJyxfu//9Gryt7nGRqjhe1x1n3eo+uDDVNzUWWnjA6yPsZVbxgCHOO7CJaedOWsq6D
         cLwAnFoEawN8aTXM88+aKzbJitHfK6j2ru/sFxkSDYz/OAO7X50QksA8nlLWu4pEmCwA
         zUa2N3pvzX58d7VDqz82imj7BxBOhwwApBw1q6Pk+uOjb32WWZ/esb2euhTQQIxPK5Ue
         ygxk/2PwNeZuUfa9Pv3s/Y2qaPKCSwxS6/M0Goh/tbLnqHcPGlSpKwN8mbLJXNGlo8W1
         Ri7pYIS006bbaQlDC1lmKU2LQhnjNStn1iqywtUiijqZYTQmy32xp3TDoBKAndxU9HdY
         YhKw==
X-Gm-Message-State: ABy/qLY3L5oWDmlEaJ+F3dzFEVfkhN51YTLgNjkpD3bbOCHe8c8Qhscg
        yeZknu0yDpzs2bMKfBjalqKvhTXF/Xc=
X-Google-Smtp-Source: APBJJlE5y3tnSBUxwgbG35HIdFij0gOVki64ZS/mUze8Vn96kzV+ZHOPTnqEU8nYD2+QEzghV3TRCFGVFMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7401:0:b0:d06:cbd:1f3e with SMTP id
 p1-20020a257401000000b00d060cbd1f3emr16966ybc.3.1690593372414; Fri, 28 Jul
 2023 18:16:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:47 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-1-seanjc@google.com>
Subject: [PATCH v2 00/21] KVM: x86: Add "governed" X86_FEATURE framework
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a framework to manage and cache KVM-governed features, i.e. CPUID
based features that require explicit KVM enabling and/or need to be
queried semi-frequently by KVM.  The idea originally came up in the
context of the architectural LBRs series as a way to avoid querying
guest CPUID in hot paths without needing a dedicated flag, but as
evidenced by the shortlog, the most common usage is to handle the ever-
growing list of SVM features that are exposed to L1.

The first six patches are fixes and cleanups related to TSC scaling.
nSVM has WARN_ONs that can be triggered by userspace at will, and the
code is a bit crusty.  They aren't directly related to the governed
stuff, I stumbled upon the issues they fix when staring at the patch to
convert "TSC scaling enabled".  I included them here mainly to avoid
code conflicts.  I'm hoping all of this can go into 6.6, e.g. so that CET
support can build on guest_can_use(), but I can always grab the TSC
patches for 6.6 if the governed stuff needs more time.

Note, I still don't like the name "governed", but no one has suggested
anything else, let alone anything better :-)

v2:
 - Add patches to clean up TSC scaling.
 - Add a comment explaining the virtual VMLOAD/VMLAVE vs. SYSENTER on
   Intel madness.
 - Use a governed feature for X86_FEATURE_VMX.
 - Incorporate KVM capabilities into the main check-and-set helper. [Chao]

v1: https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com

Sean Christopherson (21):
  KVM: nSVM: Check instead of asserting on nested TSC scaling support
  KVM: nSVM: Load L1's TSC multiplier based on L1 state, not L2 state
  KVM: nSVM: Use the "outer" helper for writing multiplier to
    MSR_AMD64_TSC_RATIO
  KVM: SVM: Clean up preemption toggling related to MSR_AMD64_TSC_RATIO
  KVM: x86: Always write vCPU's current TSC offset/ratio in vendor hooks
  KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if guest state isn't
    loaded
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

 arch/x86/include/asm/kvm_host.h  | 23 ++++++++-
 arch/x86/include/asm/vmx.h       |  2 +-
 arch/x86/kvm/cpuid.c             | 34 ++++++++++++++
 arch/x86/kvm/cpuid.h             | 46 ++++++++++++++++++
 arch/x86/kvm/governed_features.h | 21 +++++++++
 arch/x86/kvm/mmu/mmu.c           | 20 ++------
 arch/x86/kvm/svm/nested.c        | 57 ++++++++++++----------
 arch/x86/kvm/svm/svm.c           | 81 ++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.h           | 18 ++-----
 arch/x86/kvm/vmx/capabilities.h  |  2 +-
 arch/x86/kvm/vmx/hyperv.c        |  2 +-
 arch/x86/kvm/vmx/nested.c        | 13 ++---
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           | 81 +++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h           |  3 +-
 arch/x86/kvm/x86.c               |  9 ++--
 16 files changed, 261 insertions(+), 153 deletions(-)
 create mode 100644 arch/x86/kvm/governed_features.h


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

