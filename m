Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B11A4EB705
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiC2Xws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiC2Xwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:52:47 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F271204AB3
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id k69-20020a628448000000b004fd8affa86aso1443042pfd.12
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=WvAzX2UFzrcmnGH2vmugmzpfgQULkOHCxxh3/x0LXYU=;
        b=BPlx2KF1D8FGHH5fvfR/iEDQ83SwMjjzz/qj+xyb30YOS3YUQMblHjgRJ47tO+skVq
         k6IZmMkCv88Xu+AlID712AQM1WVpN61JbneX5V7OvxF/VO9waSGZV3kWefJSDRzm88Ov
         fs8GR01P+siNqRTGplL0gZZCRzy3YhMmHVGeV4Wyv+0GXtpdtUbTYGKNVLNQQd05qC9o
         D1lPrKR2tVKLPyDTBAGVSLjkj49pXIF3j/kgkMfHYgSBpk7PJFFoW6RAri6eXDDQaCkw
         ICHc2Kb/grs2xK///Gu7nfWGBxgJ6Y5LbE+GtwAQjr20+91orcJUiRLsXkGU4plOytYI
         xJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=WvAzX2UFzrcmnGH2vmugmzpfgQULkOHCxxh3/x0LXYU=;
        b=2xUeLxLV4PZU5ei8JlqIoB+Il1JO1P/RkPd9nQ2arjdzhEF85Kh74SoB22wDQvJpSr
         qfkvzVKD6kcVQlRO/ckcE5AAPVWcGt5e0esAi9/8nroE0/wJ0MXYKxjKkIgkqJ6n4bnF
         FCzCLDEXzkxTvCfgGZa6IF56vdhxAnGHzGORZn3g5MnBLEUNun/cQNdaUl4m2gyRiZx9
         z5j+iFlirG4YQn5IHGg4KYoLEA2yWq8FDF/4Fdw4djnV20PJ/XHT9sq5TEGbEtOZp9kl
         cQRk3IHT29xp7ac/tC3txDlW8bhs1Thid1bmyGg8CEfJS3lMQBeW3NrrCnp4UYEJYYpt
         G+gg==
X-Gm-Message-State: AOAM530exgHM9utAzG1KfLjCxTY+BIG3GeaORW0zRLvvIkXQ2jI8NVSw
        BMYnnhwONP9K8/RzeCUfZwcRpZ/KCwM=
X-Google-Smtp-Source: ABdhPJx7118GWysS/qqYEiOU63qQ829NqxgTMLaXG2hSAvMcoVU8gU73LCEArubw1Cu4QyMD/CisSipYb+Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9f98:b0:154:a809:7f0f with SMTP id
 g24-20020a1709029f9800b00154a8097f0fmr32287189plq.118.1648597863760; Tue, 29
 Mar 2022 16:51:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Mar 2022 23:50:50 +0000
Message-Id: <20220329235054.3534728-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3.1 0/4] KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

This is a minor iteration on Like's v3 to allow kvm_pmu_ops (the global
variable, not the struct) be static.  I ran the PMU unit tests and compiled,
but otherwise it's untested.  Strongly recommend waiting for Like to give
a thumbs up before applying :-)

[*] https://lore.kernel.org/all/20220307115920.51099-1-likexu@tencent.com

Like Xu (4):
  KVM: x86: Move kvm_ops_static_call_update() to x86.c
  KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
  KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
  KVM: x86: Use static calls to reduce kvm_pmu_ops overhead

 arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 ++++++++++++
 arch/x86/include/asm/kvm_host.h        | 17 +------
 arch/x86/kvm/pmu.c                     | 66 ++++++++++++++++++--------
 arch/x86/kvm/pmu.h                     |  7 +--
 arch/x86/kvm/svm/pmu.c                 |  2 +-
 arch/x86/kvm/svm/svm.c                 |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c                 |  2 +-
 arch/x86/kvm/x86.c                     | 21 +++++++-
 9 files changed, 102 insertions(+), 48 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h


base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
-- 
2.35.1.1021.g381101b075-goog

