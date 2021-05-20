Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB9738B9FD
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhETXFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhETXFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE3BC061761
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so24452860ybp.0
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+3q9om17bTqPH2OesSYY1pKJuwPpvDBvm1QrRLFR54Y=;
        b=VHVyUIe1ERl5hNnQgTbqEttXupxPlK0R6KI5lyanvIbdNWxr8Wu+88ERzdEoU3c49s
         5N3iLsBlLcznAHegMQ+FzZCtHGplUD60a2GPXAIm4mYPrYzugbeCwgkV2HV2km8d+C0b
         CGi+IUKm/HYkfh+2wMiCdRXU/iF2O2tNDIZnZvyW3+qkXCjPXTNx531ZDtAW8VXiM0U3
         w7DxFMmwUBQ2mlQLdbqDLzTrpGtunyUErNPIVmtUD19vjZl7aQyKZsGEzSOQPCPLUOLo
         CIibqMxEqwwj5JOlnUX5I5T+0PXiajISi8F+uEn/hClhkA9cY+XqqFSlz9IhL+U9qTd6
         X/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+3q9om17bTqPH2OesSYY1pKJuwPpvDBvm1QrRLFR54Y=;
        b=oOY6xYQSxbtMbLilNoaaCfQZggH2UEPycmXR3ngWDW2l21MwMenbCdcD2nhZrhxZJ5
         nn7gfuzy9YYBIOmY9LEWlfAqUoZdiC+HwI+beOLY4Tl60y8FqJNNSMS6UdhDHSrvlPjI
         jeABRBg4iews07FO3zu3UMLJZ3mJ+HsAyOIBJ4XFPTKnkc6sWxjo7/Fbyv6ZJdeR7rak
         MvaqzjjuJBoRZ04+3DWMFFLVV6oHKQ5YVc3aAdk1Oo5gBqogek+5oUZbrzE+8hsPRTWF
         sPBclsygsphgrCM7fBlSWgiDHMd8g/mvhkUbvLHv9VjI0McvVjc195TmKoykhpqJ/45Z
         Nt0g==
X-Gm-Message-State: AOAM531QLtNkxZxgrQZtBaqOn4OrmO6dHgKIGGGPQQede3bDP+L+ZkVS
        uN1uLgooMbN90xOGrihwO2EIaJSZjjxYxyuEcs9kA5H0wJrXXf2BUSPNI+qmW38htIx9a22tDJD
        oL2vb+2e97/hBz1IjM5p7fJ+mmuLwRdC6vrWFV0H4qQ86AYsrjQtMQWK6APb4e1c=
X-Google-Smtp-Source: ABdhPJzRaHS6oC9aAmD7sDjaDWjusQYfsGcQGVj/ug4NvatEYzMQJslvCFOHcv/ogY2EFFd7fGno7iyeN5ZttQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6902:4ed:: with SMTP id
 w13mr10783042ybs.92.1621551848281; Thu, 20 May 2021 16:04:08 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:37 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-11-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 10/12] KVM: selftests: Introduce x2APIC register manipulation functions
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
2.31.1.818.g46aad6cb9e-goog

