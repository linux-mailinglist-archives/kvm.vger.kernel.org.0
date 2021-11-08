Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D5D447E7D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhKHLN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhKHLN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:28 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353DFC061570;
        Mon,  8 Nov 2021 03:10:44 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id n23so14810081pgh.8;
        Mon, 08 Nov 2021 03:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B5QkDkFRgrTh1wy7LZXHDc17CCRNeB4d5kKy2QGRT1w=;
        b=NhlFF4VtrAyQWXADI5PZiYQahUhVOTXpzHtpvUPNLE1hfFZ+ehEFc3L4V/KB8ITQv9
         /TgYirFNmJvZxyNBgUyjxqFUF7VxV+8NBVEXsNmoqxbZmZa9EzBIe6/42kefHeRYli+C
         bL0skRq8DboJbvz0ICgE09rjvjNh2VdDPQ9yDXoOwtkKuWLlJ4bWypewQB3pTkSjo/dZ
         7HUQBoYryl8H0zmpl0mMu1CfAMKjuIF7Blr0WolNWvxJ6lb982l8nx8g0PgXc6scdxXx
         herA3jlpkr16DKbTbMBRgGVpL0k3ZP6y+8aJ1mar/jWl9/uxpEnhN0k/z0XOecRVBa1n
         +UVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B5QkDkFRgrTh1wy7LZXHDc17CCRNeB4d5kKy2QGRT1w=;
        b=xmkfxa3uE0yUu22hKbz/wFh9Ivu67q6IhriO7yaBegVQx/InIa7UBZ8og9OYkCLC0Z
         xtQUWcWfT+lw63hh99Zz7TqoKayit8jOGsA6RyVGaoOQfcCaY55S7oPw8b1tdTpkYM/a
         OJKuMudxbxfBnqIF3v4I79JNW1IAwJvePwnohylqlxmk6ktJTbVG+bQ4A9Oweru7DQ86
         vm8IaPdiNsKjj7LQYPEM8pJxibB2VomNaeBdZS/2WzGcUaepQXBan+WruMlz6m5WNYax
         dd+z2ilxckuHaOe0mVcsQbt7wJultDbSbZD0haqfgUoGl9ioh8KhnU5vk2pAkZkA1Rph
         qlIw==
X-Gm-Message-State: AOAM531kdo6fPBIhAOyt+Jb3vMtMjUvEzTBW2IURV4iKYy4njIn9fJvP
        DSaKYAdp47Nr0vBUzpNTX+I=
X-Google-Smtp-Source: ABdhPJwt28vkefm3grMrWk0+lAGHCnXb/BbW58YeTwDckZGOpO2MNd1a8zk3MHXt9nTE1e/Te+JsvQ==
X-Received: by 2002:a63:555a:: with SMTP id f26mr58915161pgm.263.1636369843771;
        Mon, 08 Nov 2021 03:10:43 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:42 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] Use static_call for kvm_pmu_ops
Date:   Mon,  8 Nov 2021 19:10:25 +0800
Message-Id: <20211108111032.24457-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a successor to a previous patch set from Jason Baron. Let's convert
kvm_pmu_ops to use static_call. Shows good performance gains for
a typical perf use case [2] in the guest (results in patch 3/3).

V1 -> V2 Changelog:
- Export kvm_pmu_is_valid_msr() for nVMX [Sean]
- Land memcpy() above kvm_ops_static_call_update() [Sean]
- Move the pmu_ops to kvm_x86_init_ops and tagged as __initdata. [Sean]
- Move the kvm_ops_static_call_update() to x86.c [Sean]
- Drop kvm_pmu_ops_static_call_update() [Sean]
- Fix WARNING that macros KVM_X86_OP should not use a trailing semicolon

Previous:
https://lore.kernel.org/kvm/20211103070310.43380-1-likexu@tencent.com/

[1] https://lore.kernel.org/lkml/cover.1610680941.git.jbaron@akamai.com/
[2] perf record -e branch-instructions -e branch-misses \
-e cache-misses -e cache-references -e cpu-cycles \
-e instructions ./workload

Thanks,

Like Xu (7):
  KVM: x86: Export kvm_pmu_is_valid_msr() for nVMX
  KVM: x86: Fix WARNING that macros should not use a trailing semicolon
  KVM: x86: Move kvm_ops_static_call_update() to x86.c
  KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
  KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tagged as __initdata
  KVM: x86: Introduce definitions to support static calls for
    kvm_pmu_ops
  KVM: x86: Use static calls to reduce kvm_pmu_ops overhead

 arch/x86/include/asm/kvm-x86-ops.h     | 218 ++++++++++++-------------
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  32 ++++
 arch/x86/include/asm/kvm_host.h        |  14 +-
 arch/x86/kvm/pmu.c                     |  46 +++---
 arch/x86/kvm/pmu.h                     |   9 +-
 arch/x86/kvm/svm/pmu.c                 |   2 +-
 arch/x86/kvm/svm/svm.c                 |   2 +-
 arch/x86/kvm/vmx/nested.c              |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c           |   2 +-
 arch/x86/kvm/vmx/vmx.c                 |   2 +-
 arch/x86/kvm/x86.c                     |  16 +-
 11 files changed, 199 insertions(+), 146 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

-- 
2.33.0

