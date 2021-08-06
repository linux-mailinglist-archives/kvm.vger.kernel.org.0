Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB43E2816
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244840AbhHFKIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 06:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244792AbhHFKIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 06:08:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C06C061798
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 03:07:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so18784635pji.5
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 03:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahtnS9hLodXxU8A228rsRwAFPAlH8yhUkyVUwHFy6q0=;
        b=iux2l32kz4u5gaFj2drpMG3N5dya5a2e6JX3ibEFu+9mgVngK4aylu5KbQH0yNUfOO
         OeLbhLd/RbKRUof1FC9Uft8uU2jdtB6sO3ar4m1rcFIM5FPFAeT3uCChuQzYp4KUKfUx
         nNPR8MZjuZXja8FRMtWHsTNa72aLnkYtRa/Lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahtnS9hLodXxU8A228rsRwAFPAlH8yhUkyVUwHFy6q0=;
        b=VH8VliweV2skIpCW/CUUACcRGDHxDDs8Kk2Uf8OxGwCw6pVal6evUOsEGX5sLtP33S
         WHQycvocJMnj4tgDmMJmIpYRnWAUxX7kXOSw5gFd9nkUbyzFv+jyVyXTRtpvtD6sIdEd
         bx+L5wTUF48muvsdyn2hNFfNtiFYxnKhzRD9Y3F2o7fECt7/CUTmtxXkq9OzQyceXsGT
         qw0L2X+6AfXFnb3G1bcZnZzs+4WhmlUJwNouXkVb14OgVb/Ayoo+Ej5Jw4/Bh6FNFhUU
         gl/y1j9Ks3rn1cuG9wdWBqB8rug/aR/KNZOpJDcfh6b+9qnQ+jaZ23j32/6EaI6e6fQh
         2ozg==
X-Gm-Message-State: AOAM532l0PCYkP54qZx9Hy286pWlZsyelNqql5rTBrubBGsfNUUwLW/H
        55uPMCcJ8jnUpQ3LXP9JcnGS5Q==
X-Google-Smtp-Source: ABdhPJw3bI9NK0b7LP0Z0RwyqGh+SD3uL4QYvRwq8kygS5zpea6aC10cBBQ7N3HZovoUWgTVAQ6Fxw==
X-Received: by 2002:a63:b1a:: with SMTP id 26mr278462pgl.12.1628244478053;
        Fri, 06 Aug 2021 03:07:58 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:b731:9e91:71e2:65e7])
        by smtp.gmail.com with UTF8SMTPSA id t8sm11442791pgh.18.2021.08.06.03.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:07:57 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steve Wahl <steve.wahl@hpe.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [v2 PATCH 2/4] x86/kvm: Add definitions for virtual suspend time injection
Date:   Fri,  6 Aug 2021 19:07:08 +0900
Message-Id: <20210806190607.v2.2.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210806100710.2425336-1-hikalium@chromium.org>
References: <20210806100710.2425336-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add definitions of MSR, KVM_FEATURE bit, IRQ and a structure called
kvm_suspend_time that are used by later patchs to support the
virtual suspend time injection mechanism.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/include/asm/irq_vectors.h   | 7 ++++++-
 arch/x86/include/uapi/asm/kvm_para.h | 6 ++++++
 kernel/time/timekeeping.c            | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 43dcb9284208..6785054080c8 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -104,7 +104,12 @@
 #define HYPERV_STIMER0_VECTOR		0xed
 #endif
 
-#define LOCAL_TIMER_VECTOR		0xec
+#if defined(CONFIG_KVM_VIRT_SUSPEND_TIMING) || \
+	defined(CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST)
+#define VIRT_SUSPEND_TIMING_VECTOR	0xec
+#endif
+
+#define LOCAL_TIMER_VECTOR		0xeb
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 5146bbab84d4..ccea4e344f46 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -35,6 +35,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_HOST_SUSPEND_TIME	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -57,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_HOST_SUSPEND_TIME      0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -79,6 +81,10 @@ struct kvm_clock_pairing {
 	__u32 pad[9];
 };
 
+struct kvm_suspend_time {
+	__u64   suspend_time_ns;
+};
+
 #define KVM_STEAL_ALIGNMENT_BITS 5
 #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
 #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8a364aa9881a..233ceb6cce1f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
 #include <linux/audit.h>
+#include <linux/kvm_host.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
-- 
2.32.0.605.g8dce9f2422-goog

