Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD364AFCA
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiLMGXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiLMGXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:23:13 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E61EC41
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:08 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c12-20020a170902d48c00b00189e5443387so12354334plg.15
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmvmDvEiSkpH/YGwz0bJ7xNMZ74ApopvE+r4HUSbg78=;
        b=PGTGmeX19GNxLIxoZP7vD/ivPXQBjWo5camHbZC1hQbW6s5JK4pfmP4O8IdsTQmfGs
         WOw3igW53ayuZ2RhdMtPs/ZgUI2gmIy/P3J/EMSHxFq5npjA+FnzzUMYMYJXNdLjWlEQ
         n+OWBdZvHPIFQN5ZVSHE5tt95AnmJoyBCLQw/F5XClZofkvDpEdF8siKBIwX4P5bZovU
         RFvUVxbqB+RZk63/5c29QG2Zn9FvspEXLfkH1q0hHhyuZD3hjwfF3y5+lrd08NJCHfEi
         l6WF1xlnJ0vpLfn1pQOghA6R4u+tWUOqx4mxmwMSSJOGlHPDj3zkvtGWSMegqY1tpdQA
         2sZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KmvmDvEiSkpH/YGwz0bJ7xNMZ74ApopvE+r4HUSbg78=;
        b=L3KPidRjiNON9rPEfSwFdvtrfNp4kp3KUSLjbHdKWZew6Qf3cWZh/1xTVib2ULxdq8
         PGHjcEldsF/TR/EIrnoXVy2Sjnx5XU4XjBdYtDSNlrExWEXucwN9EKEn8UQrOA47HmRu
         JgKMNfMw0B9U9Y40qX5jLsbGQEgzsvoqwq1WuENBIE5OBEPlKevytODdg4IlzuTzejKR
         t5Y2XQUymLk2TONl/t5+24F05XzIVuQu89PtFsiFCvUJGJqlc7o2YnfLxDvP45XrDRYi
         kHwD4JFX4g8xd5C1FSfWxkboiGiAjfxX8v//uXq45g6pbocl1Rpkb4x1mU/CJ7Y4UVFb
         8L1Q==
X-Gm-Message-State: ANoB5pnDU1TmsTVjsdZOtrNxuXz9TBrHPl6ICDq/1uv8+4caRuHgRdXJ
        qK+c9dN/JTHsdm1aMeDDxV1g4019tww=
X-Google-Smtp-Source: AA0mqf7eQ8F/9VcZw8Tw8xNYFfh0fcaZiZnHI4EEJuoFOAwW0Dv8ov92DC+o15NCFvX6zfXJWMVzsqZtOZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:938b:0:b0:576:9b24:ca60 with SMTP id
 t11-20020aa7938b000000b005769b24ca60mr24988932pfe.7.1670912588403; Mon, 12
 Dec 2022 22:23:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:23:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213062306.667649-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Fix bugs in KVM's (mis)handling of secondary execution controls.

KVM overrides the secondary execution control VMX MSR during KVM_SET_CPUID.
Similar to the somewhat recent reverts

  8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
  9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control"")

undo misguided KVM behavior where KVM overrides allowed-1 settings in the
secondary execution controls in response to changes to the guest's CPUID
model.  To avoid breaking userspace that doesn't take ownership of the
VMX MSRs, go hands off if and only if userpace sets the MSR in question.

Before fixing that, fix another bug it was hiding where the umwait/tpause
control was being exposed to L1 for nVMX only after KVM_SET_CPUID, and
harden KVM against similar bugs in the future.

v2: Fix the ENABLE_USR_WAIT_PAUSE bug too. [Aaron]

v1: https://lore.kernel.org/all/20221110005706.1064832-1-seanjc@google.com

Sean Christopherson (4):
  KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1
  KVM: nVMX: Don't stuff secondary execution control if it's not
    supported
  KVM: nVMX: Don't muck with allowed sec exec controls on CPUID changes
  KVM: selftests: Test KVM's handling of VMX's sec exec MSR on
    KVM_SET_CPUID

 arch/x86/kvm/vmx/capabilities.h               |  1 +
 arch/x86/kvm/vmx/nested.c                     |  6 +-
 arch/x86/kvm/vmx/vmx.c                        | 17 +++-
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/include/x86_64/vmx.h        |  4 +-
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 92 +++++++++++++++++++
 6 files changed, 116 insertions(+), 5 deletions(-)


base-commit: 02076de83f4de19a045227b9d44084a30e936c26
-- 
2.39.0.rc1.256.g54fd8350bd-goog

