Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DCD48E02D
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiAMWSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiAMWSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:18:43 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5589EC06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:43 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o7-20020a17090a3d4700b001b4243e9ea2so2896407pjf.6
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
        b=fft9JkIaW7xsTLU71vFw/aLtoriiT7J7UJy8sqPLByjufAN+uQyN9czAcyq7ru4MJ2
         XyDtG8fy8Ce6vRZp3Pp6GJIN3SGHQcfVaJH8Fhs9x5mCXaUHfm6nittnC5lR0qEnR5cO
         4dG/zu8RNHu3TX6ghTUpu9qGZtxPzYopmTU2vArQoDkkDDA/Rb5DTGdJabqk/kVP4J+H
         nq2GuwAlwP0T5XaD2C3Yn69oznKkkhcM2cX2AVysyDTXnF43HhzZVkANdQzBufRjxMFV
         PHllAcNDm2BV1skpRUuXZJYtsATDIEi0rHDfdPS+n6qSRUpTE1BzSOBVX0YqdIcS43/J
         477g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
        b=jT3ofiMZ+r1du0HrcxOKhpaQyn2Zr1SgUk17sOfXJgsy3zWQB4XRM3zSDF44zvozsM
         68larPdiApUql/Gtv7t9zUF2rtuwgw0IzXX/O/F8mbChbzc2xROFF361W5Q6gLWzki8U
         I+HvNqFPuMnSNUUVZ5XO/d1rxqwpqAU7kraDHzVY+hgRKb2451gZTvvBuhWKRpMRBAU5
         hIHh7phLv1zEHHsEiYtvMLlfw1JfwGzJUwSEacEwkFVNMenYYccYd/Oi/rdg3vznnjkE
         AScxlamiFlL7wkMXwN0iVcLNV1R7pA0pkcEzbcs3C6+XQabDLnjO1twkEAZzDsoeR/Jz
         B9AQ==
X-Gm-Message-State: AOAM5326HPrvdh5VBD4dzAwhcJBwC/9rXg7HYyAI1GZpG70mB77fv1Dd
        5ZuInJfRUQDR5Aj0WZrlrMM2jkS0nHkzo9L8WHsKsgwJ1N5TvgCKxtip+5ugXGq9/FkZpHaRaNb
        jRmoIIdFX9kaUPLW9uv8QpQN5cRHjlEnYRcv1l7QCG6OYH+POC6oA/OfGGScHAIpctGttiKI=
X-Google-Smtp-Source: ABdhPJwbPHsrVTSgeSxfOcMPF5wphsJcDfZTXxLxP4XcJSJkbiS8jQ2Gsj6Ba5PUTFHp4GfFLXvfvXZq5tEe3bhpKQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:9ec7:0:b0:4be:19fa:f0f3 with SMTP
 id r7-20020aa79ec7000000b004be19faf0f3mr6129109pfq.8.1642112322722; Thu, 13
 Jan 2022 14:18:42 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:18:29 +0000
In-Reply-To: <20220113221829.2785604-1-jingzhangos@google.com>
Message-Id: <20220113221829.2785604-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220113221829.2785604-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v1 3/3] KVM: selftests: Add vgic initialization for dirty log
 perf test for ARM
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For ARM64, if no vgic is setup before the dirty log perf test, the
userspace irqchip would be used, which would affect the dirty log perf
test result.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..b501338d9430 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,6 +18,12 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+#ifdef __aarch64__
+#include "aarch64/vgic.h"
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+#endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
@@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
+#ifdef __aarch64__
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+#endif
+
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
-- 
2.34.1.703.g22d0c6ccf7-goog

