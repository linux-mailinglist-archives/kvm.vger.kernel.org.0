Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A9539BEA4
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFDR2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhFDR2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:28:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF971C061768
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:26:44 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k193-20020a633dca0000b029021ff326b222so6430347pga.9
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qle/BNdTsfUk9UPuCz2u36p9QAxi+ijtW0jx0slFuCQ=;
        b=COw+PsrE7byOvgE6GdmSD2nRs48lDa83gAU6lL+vzZYbPC9KPdGSi5MeBxshRl6EVc
         M5UPMuIGgY4lUmRChuFCGbqMQ78INWEF5YGa7r9DrB6jEHWHnj1qLiBC/oSpE3Omk1yS
         2qWV8sJd7+yV5yHuizTsvuimJETNNmQrf6iAxq4/9Yt19W8H2HZ/dW74lhqjEStgy8UA
         rR7w+y6POa5OXE6yFsVK+6pZdfOCViff+mTzbLexdbezvq4TMPjkoqcX5mso2RXdbTOG
         MQeLEBz7CpAflYNJ+ZaOHKvlb4bHVwNlehwX/nIX/1V0p2pwrbDvia3fyeXdBBI20rib
         Yftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qle/BNdTsfUk9UPuCz2u36p9QAxi+ijtW0jx0slFuCQ=;
        b=P3wjbxMjnRj+bQ4u/0R07lXex9oZG6iFPuFSKazuBo0vQNy13z8A/EWZ4ASko2mC1s
         +eXRQn79Whx64PHTFLZwT8G8Y7VM1NV9gZFXjpjclO46ew3eks6Kn5u7JXOaSvDyT0dv
         D5zuHV8wFUhYWu6t3yO/yr8IcG5KDhXPDjtO3E7zPX6PXk/PI45L+cAu490K51UKF1mB
         JjY1WzNaXKdTCdNhNlRlTFOcyA+YvpfDeTRjq5G1EHyUcfv77nte/Mltr1bH31N3HLQk
         +all6bIuDN+EBwLkCyNI/hNBxc35Ifm9pyxPgvRqEwqjMXORHvMiPC7CrmftSi4E5QH5
         IBmg==
X-Gm-Message-State: AOAM532TX0OueCPxN9e8ydpAlXiHKuEqy0xOQ8+yGl88Oy/gSNGvfkZB
        81x37rJzzNE0KA+RFSVF/CqXzVylR7yYXYrNB1dg3BJ7dxey0MtfIpxp0zIOXIMCaqb/uF/6Sqt
        fyOZx/c66zCBqh7wMf3OUcsn0D4qd8RONS/Tmc1on+sFosPP+83Ewt+zZ+hdIk54=
X-Google-Smtp-Source: ABdhPJyG0OcP8QKXb9UQ9ScShWjdr3sbPvg7jBnl/z0aHJUwM6tcUx3OahwhPL0L2n4koEDSA2nJ6p+ICn1UdA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:8695:b029:fd:6105:c936 with SMTP
 id g21-20020a1709028695b02900fd6105c936mr5397405plo.25.1622827604058; Fri, 04
 Jun 2021 10:26:44 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:09 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-11-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 10/12] KVM: selftests: Introduce x2APIC register
 manipulation functions
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Standardize reads and writes of the x2APIC MSRs.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/apic.h | 10 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/apic.c     |  5 ++---
 tools/testing/selftests/kvm/x86_64/smm_test.c     |  4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index e5a9fe040a6c..0be4757f1f20 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -78,4 +78,14 @@ static inline void xapic_write_reg(unsigned int reg, uint32_t val)
 	((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2] = val;
 }
 
+static inline uint64_t x2apic_read_reg(unsigned int reg)
+{
+	return rdmsr(APIC_BASE_MSR + (reg >> 4));
+}
+
+static inline void x2apic_write_reg(unsigned int reg, uint64_t value)
+{
+	wrmsr(APIC_BASE_MSR + (reg >> 4), value);
+}
+
 #endif /* SELFTEST_KVM_APIC_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/apic.c b/tools/testing/selftests/kvm/lib/x86_64/apic.c
index 31f318ac67ba..7168e25c194e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/apic.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/apic.c
@@ -38,9 +38,8 @@ void xapic_enable(void)
 
 void x2apic_enable(void)
 {
-	uint32_t spiv_reg = APIC_BASE_MSR + (APIC_SPIV >> 4);
-
 	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) |
 	      MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD);
-	wrmsr(spiv_reg, rdmsr(spiv_reg) | APIC_SPIV_APIC_ENABLED);
+	x2apic_write_reg(APIC_SPIV,
+			 x2apic_read_reg(APIC_SPIV) | APIC_SPIV_APIC_ENABLED);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 613c42c5a9b8..c1f831803ad2 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -55,8 +55,8 @@ static inline void sync_with_host(uint64_t phase)
 
 void self_smi(void)
 {
-	wrmsr(APIC_BASE_MSR + (APIC_ICR >> 4),
-	      APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
+	x2apic_write_reg(APIC_ICR,
+			 APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
 }
 
 void guest_code(void *arg)
-- 
2.32.0.rc1.229.g3e70b5a671-goog

