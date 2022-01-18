Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197C4913D8
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 02:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiARB5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 20:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiARB5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 20:57:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6189C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s8-20020a056a00178800b004c480752316so2498958pfg.7
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
        b=AiNhonZ8w18AjTZDIERNhgzwKTJ7KI9+QJJd8eVZ97usyEfyImywldUVzLovaShH9S
         cLGIp0JfORuBbqRrDQbnT8FEtXaKIml5rY0QTX1c3EsLUO1u1lusYyOq6/fGFppMM1//
         aMwpKmSOqoGv//5rZZjp+PvOE9ATF7D2w1i5j/1B1kIeL+BxfVCHYeJZm8XKHz56xqbV
         rTigTGzw72EsIWpvKlFSWwdzmOeSxzJ3UTPMbpRY8v00WHB1Iw74Xq6c0G1rYfZNMenY
         43HurKrjCLaAFTZl6EzVTXc58H9IJkNCVSaKrl3M7BJdjavfNTeXC6nyEIxAsJu5lIxx
         fctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
        b=LDIThpAMxNljTaUmWRwjaFFZvlJzypD8vNYAT0yI/xuDUfB3Uye1RoJmyZUuTdF8al
         NyeC8fLuVgbdZ5KqATa4lmjgv0hlSDimgCx8rthgoa7tI81ll7wRmLV1QpXwBLf+MUXB
         Db45zLQP71cQNz6GQ0kwQHgmgPcvaY16JPA7+HxQIxO/U/fQYpW0pE1MMcvd872B0neS
         +1sd9CZhN6Mb6y/93EfqTBIsyOvOXtFoR77fuNzssKvrnazzhA0BGo22+EPzKMfRIEBR
         4qycOtUyE1sY06f75KEwNz7dYpXpjRblufTjDK8aLQbASSPkL0gv74nNF4Ne8fnolRGj
         p9GA==
X-Gm-Message-State: AOAM530jBBle0PSbEC3S5eZ1TUp2GI6nGYInAIK8LJD1gv0YlNIwoo20
        19/OjVofleMkQDP+l2yzuE/pHVL/t70yBs+TsgncHXXuxqhZwxNjHwEKh6sgNXjyfcofBa4eqzk
        tSBzG4bugkuGC0fEoK7jPzyiq/FApiIyLVrujVrZOjbNgPU1YBsQOPeclnRdjPJSGYuM2AR8=
X-Google-Smtp-Source: ABdhPJy3MfvyC98SST6vF79hK6xhszFOokBw22k4x5+KH+epIuRlSbBOdJSPcTvn8fxkwxwF8De41dpAJAhSSAm4Fw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:4d84:: with SMTP id
 oj4mr1115111pjb.0.1642471031804; Mon, 17 Jan 2022 17:57:11 -0800 (PST)
Date:   Tue, 18 Jan 2022 01:57:03 +0000
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
Message-Id: <20220118015703.3630552-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 3/3] KVM: selftests: Add vgic initialization for dirty log
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

