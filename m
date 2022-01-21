Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9749575B
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 01:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378398AbiAUAaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 19:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347824AbiAUAaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 19:30:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05289C061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id v5-20020a17090a960500b001b4da78d668so6654197pjo.4
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gIv3nKLi74GBkEdnpctQGpKVZ6CdoxVNxEiBpGXp6DA=;
        b=FXbzieR+He5wg0Xdlup2wNjEaKzN8V0p4DyBkbzTrPaVa6d9l2rs6U3pY0SoWEUBDG
         zu3RRLCXY7rPQyru2icCcOhOZF1291/a0UnivKW9UYipwZgvCsCqLNlYyZP1zTCjy56W
         xm3anDSd/rP0F+JBebnLq+hc5amxaITF1xz3LNe7wT9ZUPyoPg7tFRF261PcdP/OQFwg
         m+e3faMmkXrm0JlidMjogO140s4vvfykazOQXPbU8go0L3EAJWZXUYdqY2uhcd0al/as
         4FadhUnj9SbtFbzz62zl4+vewTpPNKuqaPUCccIYRkd0tytum5+mzj9ygz4TYMNLWIxE
         isTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gIv3nKLi74GBkEdnpctQGpKVZ6CdoxVNxEiBpGXp6DA=;
        b=vP1twU8Z6Dh9dMV4Q61xS83i6cED0n2oEFvEMAVfA/YY6i2gpi42bdviPc6OKjLJQH
         TJIpFqHF6j/2tIQvKjIiNVhiKf/dNH1G756ywC6wBVhDAM1G6G3zHzZ3ttVVM4N9R6Gi
         cznENHuZVahZms4P6u33FQT0BPUoZwHB8PpJa6DEmLLURlxF5stkVvSFpJNdL4YDvpW2
         RhDJ2uudHk5wxHNqxN5+x8J6LLnugY/59AaZSmHruihsUtbV4bDgq4dRXNJ0sUjmhEyL
         tDm6zaLGPYslJjZoe1tsMftfJ+S4SZuQorlQSjfeHiCTi0wEVGZVOQByAn6ZFYj1Oq+W
         KlsA==
X-Gm-Message-State: AOAM532QUxoSxkQkT1cXWqoC8sIvmMua/z8BWWQcymEYftulECp0TsmM
        rqgcwpu19KWZs5l3UsalEgm12CnkXUeMuNfRap1fkVGo1u1y75BgoinJP6ydcURQ01oZgD6MfMM
        +mcjw7PyM72p6RCREw/32Og2ApLZYr9EQLts+g+raXK6x58N9/zcXuiI/Nn7prO7L7A==
X-Google-Smtp-Source: ABdhPJy237n7mq9yKoV38ys6xzWhDQNursakB3RD4Ja4mSqpGyjsEKGQglELlbQ+W5alAoCyFrGxpb3RXADfDzU=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a63:c65:: with SMTP id
 37mr1049758pgm.608.1642725012270; Thu, 20 Jan 2022 16:30:12 -0800 (PST)
Date:   Fri, 21 Jan 2022 00:29:49 +0000
Message-Id: <20220121002952.241015-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 0/3] Provide VM capability to disable PMU virtualization
 for individual VMs
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset adds a new per VM capability for configuring the x86 PMU.
Right now the only configuration is to disable the PMU for an entire VM.

Thanks to Sean and Like for great feedback on v1.

I've incorporated most of the comments.  Unfortunately I wasn't able to
get the AMD version to work by using pmu->version == 0 as a flag.  And
it makes the Intel pmu->refresh() logic complicated.  So this version
stays with the kvm->arch.enable_pmu boolean on each VM.

David Dunn (3):
  Provide VM capability to disable PMU virtualization for individual VMs
  selftests: introduce function to create test VM without vcpus.
  selftests: Verify disabling PMU via KVM_CAP_CONFIG_PMU

 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 12 +++++
 include/uapi/linux/kvm.h                      |  4 ++
 tools/include/uapi/linux/kvm.h                |  4 ++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 48 ++++++++++++++-----
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 ++++++++++++++
 9 files changed, 96 insertions(+), 15 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

