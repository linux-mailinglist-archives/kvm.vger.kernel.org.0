Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FB14140E7
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 06:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhIVFAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 01:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVFAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 01:00:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7865C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so3640963pjb.2
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8pnqtJ/F9dtMSy/EL+bGh8IDZAtWEdBtDhk0Wjztm0=;
        b=Du+uSsA4PBLae+9JAQuRNrZm3uPgW9fksM5M1X2Ex1FCd+Egj4prlRHnEo1B52xkAK
         3uifhC4i7N5eJwHNl5jdbyPmjxZsqlppuAJxkMPpazWYiFeqr/G7EO0v9SSrQ7zNYex8
         o/CSYx9lBA3kZAuEGJuZM0HoWR/gbBCa+a0IY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8pnqtJ/F9dtMSy/EL+bGh8IDZAtWEdBtDhk0Wjztm0=;
        b=2WfkUDKFnqyg12kbjjL9Ye4FAQdRuy9sK6V/3wKIwT5K6zXdfOpMKftcSx+kaBbOfO
         nPSFW6ngiOdI7wKKSdz72GcR++orjY13QSanPemyBhlckyp15n3jsFGrDd09MSCjUbaQ
         QMXd720tBxmdcFKwmqBSjEqgTnyQe89VvAkGHP/1ZtkzQMWLeRNBu/nEVxUl683P5xDP
         S3jo+D+DfNbvhXwHWGRWrwIGwpPW1UJ3UJAHFKUctrVSnm1EDAYKHDkQPeN0O0j/fe6n
         5j6SLkveYWwkSRzku0lrMd6PINbDT4BGMQjn/jK7YawYVGDYEId6aJ6AFiHexHuOTjSH
         /hFQ==
X-Gm-Message-State: AOAM532JaBX5pXHFaiBKjylVlTyGpPOanyiWjKCMCe9lL3eIX4Z63Itq
        jOF1UnePvnHPPAYOX1dblPsg5KaGJ/Qokw==
X-Google-Smtp-Source: ABdhPJxYIlEiNMPJdImKxEKui7PG5ale479F/pI/UJmFAIAARNbsBTndPIXykFqKCp8H1Y6WOUf0+w==
X-Received: by 2002:a17:90a:7782:: with SMTP id v2mr9114675pjk.9.1632286745479;
        Tue, 21 Sep 2021 21:59:05 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:9a20:20f1:af4d:610c])
        by smtp.gmail.com with UTF8SMTPSA id g14sm700500pjk.20.2021.09.21.21.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:59:05 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v2 0/2] KVM: x86: skip gfn_track allocation when possible
Date:   Wed, 22 Sep 2021 13:58:57 +0900
Message-Id: <20210922045859.2011227-1-stevensd@google.com>
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
GVT-g. If tdp_enable is set and the kernel is compiled without GVT-g,
then the gfn_track arrays can be allocated lazily when the shadow MMU is
initialized.

v1 -> v2:
 - lazily allocate gfn_track when shadow MMU is initialized, instead
   of looking at cpuid

David Stevens (2):
  KVM: x86: add config for non-kvm users of page tracking
  KVM: x86: only allocate gfn_track when necessary

 arch/x86/include/asm/kvm_host.h       |  8 ++++
 arch/x86/include/asm/kvm_page_track.h |  5 +-
 arch/x86/kvm/Kconfig                  |  3 ++
 arch/x86/kvm/mmu/mmu.c                |  7 +++
 arch/x86/kvm/mmu/page_track.c         | 69 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                    |  2 +-
 drivers/gpu/drm/i915/Kconfig          |  1 +
 7 files changed, 91 insertions(+), 4 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

