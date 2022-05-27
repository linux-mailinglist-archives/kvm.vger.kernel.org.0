Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED15536654
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347698AbiE0RHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 13:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346544AbiE0RHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 13:07:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C76C0FE
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:01 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z24-20020a056a001d9800b0051868682940so2739548pfw.1
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=9DJdjdQfpcnVpPyggfIa1qFXIxfq8b79BilK9w/NCMk=;
        b=VpE0RCMwbMTen5kAKvFC8lT8COxhcuz8NIbXoPPx5NG5zwnsMY47H7V95OAyz8LCzr
         R6fQRQG9L/ZuTtN9tQUWcWrABH1YkePU7l5rBlHbj6MafvfM7jtvnZCP4kcuPbTw1r0a
         7wWjhtp5HGbJkBzO4LsIexzDCNMwoUUmLnDqhIOC5rG6FtijeTky5NL5ShGtXOg1nQwx
         LLwWavtHpb4vRbo5mAROTm3R3K9TYAuM8lTXxs+YZ8S5NtTVEd3Ls9kBm2BLbmMGWtcS
         YcvCClR2qjnO/3QD+XLyJsRTC0UmWMuWKg9jfJTJ5wIcF61cIPUPtJ5BdRmvThmNKvTN
         fMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=9DJdjdQfpcnVpPyggfIa1qFXIxfq8b79BilK9w/NCMk=;
        b=1oYzp/8aSm/HkYagOPLbM+K37xam4NNGQ/s2ALLEKfGWsfnHBOyNaL+JGn8WBCrHmN
         DDqmDFp3QT2XEkx9Znl1/hFl9pVuy1v4iFV0AdkYMQ8nAngN6pMgOxw9SmgDOW4tuL6V
         mpul0XaOcEY3RCBLXacvMfAiZAjj38YsVxhCXEDb4uVsPC9TRtTfGjo4774nS1SFn8qU
         I947aV3+9iTDFlOraXtOllun55RLxuqWHLx5ExtyEzObHpsVYq7geJN3+KieM6B1zsce
         9nxtIG5ao7AcYtsaL/Lf3favO2sOMYOEYlPkVc278fMMuR02+/W3ZV+7OMrd5wjfYr+v
         5byA==
X-Gm-Message-State: AOAM532n7+8VRtqAxiGIWC3UX4uWaOAoDD2WJ31N4DcZUYagmywu6gDd
        xCBlvq18PvpsA0JYYf36vJA9CP3A/jg=
X-Google-Smtp-Source: ABdhPJy/MxK8R9tE/ppkI9QXVvxv+Y2LEn6i6YQMe01XhN/mFom9mlwlSW5NzeEUm9FlqBFt91qCZ5ZhLXg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id
 g24-20020a170902869800b0015899d46256mr44760250plo.104.1653671220960; Fri, 27
 May 2022 10:07:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 May 2022 17:06:56 +0000
Message-Id: <20220527170658.3571367-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 0/2] KVM: VMX: Sanitize VM-Entry/VM-Exit pairs during setup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
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

Sanitize the VM-Entry/VM-Exit load+load and load+clear pairs when kvm_intel
is loaded instead of checking both controls at runtime.  Not sanitizing
means KVM ends up setting non-dynamic bits in the VMCS.

Add an on-by-default knob to reject kvm_intel if an inconsistent VMCS
config is detected instead of using a degraded and/or potentially broken
setup.

v2:
  - Drop the macros. [Paolo]
  - Tweak the module param name to try to capture that KVM doesn't check
    for all possible inconsistencies. [Jim]
  - Enable the knob by default. [Paolo]

v1: https://lore.kernel.org/all/20220525210447.2758436-1-seanjc@google.com

Sean Christopherson (2):
  KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at kvm_intel load
    time
  KVM: VMX: Reject kvm_intel if an inconsistent VMCS config is detected

 arch/x86/kvm/vmx/capabilities.h | 13 +++------
 arch/x86/kvm/vmx/vmx.c          | 52 +++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 12 deletions(-)


base-commit: 90bde5bea810d766e7046bf5884f2ccf76dd78e9
-- 
2.36.1.255.ge46751e96f-goog

