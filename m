Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3147402E29
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345698AbhIGSLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345653AbhIGSLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:11:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37770C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:10:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso152392ybq.10
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1uFfaY/CovA+5IRgcetklkh/mmF9o80NZlcBkfT1O4k=;
        b=lqWJXZALiaVw/thW4AlSJVx2csOcUTLC8gGFw2k2qok7tIRUmDd79x8MBXSsqbsadO
         H0j0Ud0zFUeB7tei+pZ/amtAgtojA0KqfiwwNLwvhmInpbd7YZVthRogTGyP0NRVHbO7
         mnvgp6UGg4Mi6M8IYiu/xA2towCK2Pqmwo3rjnlL/kTphVOVhZDy30W6js+zm7gYtmHY
         il2qjR1iAgevs6kf3GdwSiYuMKwrI5xaVymzq2DeKhFMBhhLxCOl5yI5q9OU1AdypEmd
         9+ejT/DsGzLHNschhhkRZI86EI0+rJWc5BTnAaTrJ0oD3Cg/wowg/gj7Jv1ZVKHd/pMC
         cyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1uFfaY/CovA+5IRgcetklkh/mmF9o80NZlcBkfT1O4k=;
        b=kzwL4/9c8H0OQ/liPWznWJ1jdOtBOYZnu/SmPfF2hYeraFM9xzapRDHRti4iDvfikh
         8u1Kxbhr6xQpLIqDv5WtGLl+exToSyFqYkESjdfCdokhDdpcONjfS5kx9bW4T2ziPuPJ
         oW1EuuXa+s5+0doEpRrNj+jbv3m4SOv+/nQPN1+dVMH2J2+uCgYjMk4kAecobZA8odgn
         9UP0MT49gezbuwtcwNDN2yV6Tbk423IR14Od+W0sLMOb2vd99cR7PXItQGGDf1zhfzFW
         rfN12YkhAWzi+hfb8r1N3aAlJ/K30hCEdBJya5uakiIISrbsjZUAErEaLQbABkYMZlbu
         +TJA==
X-Gm-Message-State: AOAM531Y+ouyi3n7VUobjrDZaZ+7drMPkzmQRJqlwHpFPfOx3Fc+8+gp
        0Awps5ye+8y89k7pi58QNOl+Mp5iGnz8CTQ+2Nkmu8ve882xUNNCxSVbGPj1XaizRzB2dU1pm0l
        xTN6vQO/WnhVFLZHtNAYJNPyjKXq7RSs6rO1R+WC+hor6xL+PssaL/5gNMogMabs=
X-Google-Smtp-Source: ABdhPJyadT6SGgfRjBZaa5CqgsqP4c1HP4Y8XQA8avzsmPqGIbF0Sp0hAb5f8uuPoDPcrKeTXyJErM/l/NEZaw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:b98b:: with SMTP id
 r11mr23645830ybg.189.1631038205374; Tue, 07 Sep 2021 11:10:05 -0700 (PDT)
Date:   Tue,  7 Sep 2021 11:09:57 -0700
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
Message-Id: <20210907180957.609966-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add memslot_perf_test and memslot_modification_stress_test to the list
of aarch64 selftests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..5ed203b9314c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -92,6 +92,8 @@ TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
-- 
2.33.0.153.gba50c8fa24-goog

