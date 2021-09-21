Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C827E412FEC
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 10:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhIUIME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 04:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhIUIMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 04:12:01 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A2EC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so1941966pjb.4
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z1XhbmNjXuxATXULuRYAdEo5pXlezWSkYfiPLBzzUfs=;
        b=U83bLqev3pRm8sTSPZ4rnpHt3wXQ4oKXvlcl3wjlCuQiJzNeLy/+9rUuQoGOc40KHY
         07/IH1lYr9TJf2NuJl2UJxjLU5NE1cWjqayNFQSh/qKAkG9qqTLlMYM03CEyQDQIeR5T
         V4XwsDK45HRaEwumcPHtrwtwlRMwMSj6XiUnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z1XhbmNjXuxATXULuRYAdEo5pXlezWSkYfiPLBzzUfs=;
        b=DJNzA1GzP0oAQJsscVJVMNfIsY5U5trHo+Gq7ytPStGWKUfnKssJMbSdBHt2Gl0HUs
         h7ZXHBaI1jp7I/OdZAst6pdHm6XxfRtU7ErorwzBK/1M9mZpd3bOA1Bxckq18NvLhllG
         WJ22aM/+SMfyaiMOF/eEY1xhax3VM9ggdXdoyp8LPGQZQB4OoVFkvr79BYB3y001qLzn
         9Z1gQVBk0e7L0SX+/qMd0AU+BtlvqtGPYVrmY+RTGOqkGtREK35nVzOfBN82Dyzdm27/
         uF0d0xzpYBz6pVtQsReikms1velz3TG5L1ZYh3B6LiRWtd9CKczes6nbUr9dCAdR3DzW
         0MoQ==
X-Gm-Message-State: AOAM532+oA4DeL7/+p+bHH66a1YQAE2AiJxcA1MpJP4q38uPVAJvpa80
        crK2wyflFP1vzx+X/tMI9llcBj4uYuGX1g==
X-Google-Smtp-Source: ABdhPJz5VDycvTD77TKaG0JLsFI8IbnpJ0VyeVpNS+ZZTTexE0J9DFPiLhV/Rzil95TilYH+dj2A/Q==
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr3877285pjh.62.1632211832640;
        Tue, 21 Sep 2021 01:10:32 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:2b35:ed47:4cb5:84b])
        by smtp.gmail.com with UTF8SMTPSA id y3sm5669658pfr.140.2021.09.21.01.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 01:10:32 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 0/3] KVM: x86: skip gfn_track allocation when possible
Date:   Tue, 21 Sep 2021 17:10:07 +0900
Message-Id: <20210921081010.457591-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Skip allocating gfn_track arrays when tracking of guest write access to
pages is not required. For VMs where the allocation can be avoided, this
saves 2 bytes per 4KB of guest memory.

Write tracking is used to manage shadow page tables in three cases -
when tdp is not supported, when nested virtualization is used, and for
GVT-g. By combining the existing tdp_enable flag and nested module param
with a new config that indicates when something outside of KVM (i.e.
GVT-g) needs write tracking, KVM can determine when initializing a VM
if gfn_track arrays are definitely not necessary.

This straightforward approach has the downside that for VMs where nested
virtualization is enabled but never used, gfn_track arrays are still
allocated. Instead of going so far as to try to initialize things on
demand, key off of whether or not X86_FEATURE_VMX is set in the guest's
cpuid to support per-VM configuration instead of system wide
configuration based on the nested module param.

David Stevens (3):
  KVM: x86: add config for non-kvm users of page tracking
  KVM: x86/mmu: skip page tracking when possible
  KVM: VMX: skip page tracking based on cpuid

 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  4 +-
 arch/x86/include/asm/kvm_page_track.h |  7 ++-
 arch/x86/kvm/Kconfig                  |  3 ++
 arch/x86/kvm/cpuid.c                  | 55 +++++++++++++++-----
 arch/x86/kvm/mmu/page_track.c         | 74 +++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c                | 10 +++-
 arch/x86/kvm/vmx/vmx.c                | 13 ++++-
 arch/x86/kvm/x86.c                    |  5 +-
 drivers/gpu/drm/i915/Kconfig          |  1 +
 10 files changed, 150 insertions(+), 23 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

