Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9134AF87F
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiBIR3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiBIR3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:29:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC4FC0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:29:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a15-20020a17090ad80f00b001b8a1e1da50so2246983pjv.6
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WsnRsbBsDc8gvMsvdV4tgXAMjf21efLQcPTqwxO95E0=;
        b=D3AnBTU0cPC1us4Wn+1cAVWZeFLR3tj3rMzlI38++5guZFFFOmks8Y1n9loUxtrS3p
         LQP3jEF5KPS880fGqbCTHCc+33mg96ygHysPBe4rM+nOYUOiso/yoGh/DdxQUNQFHVJH
         1TepVJWFLxc9nEjuRZXXNPGx/LiKV43JmzLizxa0/oZbchs4HTZXKKT7Z7eSIO2RU62u
         ZQXF7aZK5TCr9vRMKJ8P9986UsycAgSnfGFgu0AGsXAeaSCiebLjC40dyG+Fn62KB8nC
         qHPDEpGhbRox1G4+V2vuuk40Qrgw4GOMdS2tirz0fuF5Am1g/A3Qnae0z+faw3iWXTuu
         4XOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WsnRsbBsDc8gvMsvdV4tgXAMjf21efLQcPTqwxO95E0=;
        b=KxULayyG3mfL5e7elejuxnfnl+VKa6W/IhLJ5bHSCwm7fuj2YpK1A+DpOyk7HCikB3
         poD7Ie4DyTzL4Kbm+AkVl8XigzBKphLQOBL3h948Hnmzhvg3aP7iefw+ask8um1+pcB9
         Xri9uBXYUNh5oPdXPFBecTGHzZZPwV/aIPt3tg3lJXHs4Mb8pkB3ucyt5n8+DzEYihGn
         oarBgFlPiMHuflrBbQwoLEww9pNEHFPQIZP0k5B/78XTEOiugAuqEiANLfGIS0HQiT3g
         WtW+zzIfi3Ne4CNek2urpWmh8bQR01bNc2R+FKoEA5rw3UaDaxYTvtT6A36uNMs556W2
         ms7w==
X-Gm-Message-State: AOAM533M5aUtcoQqDWwx2iJnCUcA4kP7xxeXOy5hlTi0lo9JhYNt58J3
        6xvfAXcBoP+Ye8Ffy6njDibZU86TcijJHr0=
X-Google-Smtp-Source: ABdhPJyL3BnbpxwhULL+hHNm0LeGSwbknxKZbG2QUUDOKMRaXTAGE4AWup+eEjnRIswYbOHYJfoVNgi5BFuA/aw=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6a00:10c1:: with SMTP id
 d1mr3401085pfu.84.1644427789571; Wed, 09 Feb 2022 09:29:49 -0800 (PST)
Date:   Wed,  9 Feb 2022 17:29:42 +0000
Message-Id: <20220209172945.1495014-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v6 0/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set allows usermode to disable PMU virtualization on
individual x86 VMs.  When disabled, the PMU is not advertised to
or accessible from the guest.

v5: https://lore.kernel.org/kvm/20220123184541.993212-1-daviddunn@google.com/

v5 -> v6
 * resolve minor conflicts that were queued after v5 was reviewed

v4 -> v5
 * Remove automatic CPUID adjustment when PMU disabled [Like]
 * Update documentation and changelog to reflect above.
 * Update documentation to document arg[0] and return values.  [Like].

David Dunn (3):
  KVM: x86: Provide per VM capability for disabling PMU virtualization
  KVM: selftests: Allow creation of selftest VM without vcpus
  KVM: selftests: Verify disabling PMU virtualization via
    KVM_CAP_CONFIG_PMU

 Documentation/virt/kvm/api.rst                | 22 ++++++++++++
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 12 +++++++
 include/uapi/linux/kvm.h                      |  4 +++
 tools/include/uapi/linux/kvm.h                |  4 +++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
 10 files changed, 112 insertions(+), 8 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

