Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F5051B360
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbiEDXAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379788AbiEDW60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:26 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9956218
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t70-20020a638149000000b0039daafb0a84so1348124pgd.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=36MP1emo2zk5OGkKkF+DZacxN5PgxLSoE7Zm4l3PLFU=;
        b=PCvMrfENqwL4KF2jfXrzGcapgqFJoYJzEm5QdV5NI7q49HboZ6ibIpXBIEicTJ1v7l
         4Ee0BgY9mIqHvgzwuFGPvfr/KT1FOiSGWDm9JSrKpiYFD7GPpCbxdF549ge+oKiInoUX
         mXfwLp3ETc4j0sJcJBP/tyzhnhW3Yo65DVYb4UK1IS3O5BlvspyND/eem7w84Bw05xhq
         6J34qZlFtA6OEsxsx4+hbPS1MCcqMHXu3OxHyvKnHihm6aGH91pr23QQ6foLP1y7d6Tw
         LPzRTR/9WknJuYuzi4KuGsESlE58zwHh+ZERamrzTvGpyP8HeDmWZHGmA9Xmmxhdhypd
         uJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=36MP1emo2zk5OGkKkF+DZacxN5PgxLSoE7Zm4l3PLFU=;
        b=HqsApNkMZ+4BcAMc5LpV573xzRWgKGnh7wOETcJ0ADZP/xCpUPCudtFmziuvgqwWhk
         N+YE1/OsuX1+zMKZJ02rYB6rQvpKnAuKrAZ1Dsyvarc5rcVG+4ubftTlB0EpL27LsFyS
         G6AD7rcjyxZ7t1wSsfDn9sDuuCM1XTOPkHc1ZGn54Cs/jEtZ84fbobtl0vKv4/Rznngw
         qS7wPlqSpHaOY63h7Y0b0wp1qwNqkuFVLD4zROrv5by+3V54K4i0zlFHm+4E9xvLsN5V
         RYQBdy1bYxTASTZd/AYKPDEfvbN5WFD4kT14/aI4dEJNciLEWt+dGNsU+VEWrE1z+kRn
         slEg==
X-Gm-Message-State: AOAM531FwX2djpMHALKo4b5YFD7EGWBmBegL53nBi+vwPytuiNVddBWy
        7vNlCKH14b2sr2rwQcdK++Dz6J2YZeI=
X-Google-Smtp-Source: ABdhPJx0yf6Wd7rpduiwh8C1FljRINilw9SerEN7Zutz2ba9UwqHPrm8AF+xI+kFOwdfZOpAf4UvwFQBims=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b83:b0:15d:1ea2:4f80 with SMTP id
 p3-20020a1709026b8300b0015d1ea24f80mr23518012plk.41.1651704725816; Wed, 04
 May 2022 15:52:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:36 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-91-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 090/128] KVM: selftests: Make arm64's guest_get_vcpuid()
 declaration arm64-only
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Move the declaration of guest_get_vcpuid() to include/aarch64/processor.h,
it is implemented and used only by arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 2 ++
 tools/testing/selftests/kvm/include/kvm_util_base.h     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..9a430980100e 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -185,4 +185,6 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+uint32_t guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4487d5bce9b4..f621f7ffc150 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -706,6 +706,4 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
-uint32_t guest_get_vcpuid(void);
-
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
-- 
2.36.0.464.gb9c8b46e94-goog

