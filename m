Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CC432B00
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 02:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhJSAHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 20:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSAHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 20:07:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A0CC06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 17:05:08 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j2-20020a056a00174200b0044d39a43c9bso9918822pfc.22
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 17:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a5KGS6HQnbzGDc6tuB1eDeih1YYo7+lwY+bPgl1AjIg=;
        b=Tg7DIe/CNALaZimeMqfNy2WLuqfJ/P26FtAsb/GK1ChmKQTJgtfvGhetIuHjB7W4xo
         T5i2A/YPpGG5rifW5+DIy2R5hCZggAM8x1dMgzGCy4CMsMrBOQ3PAKNKxRZub0H3l5uJ
         KCXgUYPg3pzJU+SutJj29zKmVr4DkrOtIhYDPJdqptNYd4bOCW8gPMH2i5KLLe+8RlkK
         1bzCH/rEV2kpR0huixVCUugMbkarMjI/XNqDHWp+9IrwQpT11K5a4fJf0CQjmpPjeU2x
         YvpCbIGB5rWA/zmO6FS7esKQWF+KNb9U7gGIz+MAhyLj0uwTbgHnCjl+ujUnWcCyUQTy
         cThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a5KGS6HQnbzGDc6tuB1eDeih1YYo7+lwY+bPgl1AjIg=;
        b=klN9e06NK1En5mwGv1btaZTzY3taSAYABrOyf1Cip6xX6tiQZFICG+712xVQRsk+HA
         UIb0Pg+wonp8JRZZ7pLOVHJIJNSC3PQAatWe7DoZrWeml9YGVZDj9E6c8Emcrq7AkGUO
         GTnTeJL9aYjLbeEEKdm/fQD53ZNwZJXnKyk3QvTR0ZTBANnWQigkUqNKxatA3RGzFNel
         pTobL8tPnz4SJN9E2BmTB/aBxobJ4mo1Z/3YKrGqBs6xsEFsoyjfQUsCTaweGSAYbI8Z
         pf4QXRoiHjWq4N7L1fDUc4SMXYDmyk2Orbj6T6Et8euY+n7oF/mLZCjH7spBuZJjcWhs
         DQCA==
X-Gm-Message-State: AOAM530hZMazntLHmMqQnnwv9Sh/3CiW2co3cHB66MqONPMWUDjoqA4s
        l1/P6ge895htcSc+Lulf3k5OpTmhT8Fmf78sKOxPJsCb7aoCX+IgWKSLyzNYodEjdJvLMTYYblC
        n3+RNdgTA9J4kz07AMfCmiSACl5P2IYMh3tGjsaLfG3cW8QP4pIAicFXw2I0+iuXk+fIlNnQ=
X-Google-Smtp-Source: ABdhPJx9XF/v9DvePw5f042O7u8jCgWGJtWCN7VaHIaJjEfm0GQKuTvhtBehD9YyAhk7AAJrv0gk1rX+nXJ7r7DqOw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:b105:: with SMTP id
 z5mr2365891pjq.64.1634601907573; Mon, 18 Oct 2021 17:05:07 -0700 (PDT)
Date:   Tue, 19 Oct 2021 00:04:59 +0000
Message-Id: <20211019000459.3163029-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v1] KVM: stats: Decouple stats name string from its field name
 in structure
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are situations we need to group some stats in a structure (like
the VM/VCPU generic stats). Improve stats macros to decouple the
exported stats name from its field name in C structure. This also
removes the specific macros for VM/VCPU generic stats.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 include/linux/kvm_host.h | 147 ++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 72 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..72f189c9c8f0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1364,102 +1364,105 @@ struct _kvm_stats_desc {
 	.size = sz,							       \
 	.bucket_size = bsz
 
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
+#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz, nm)		       \
 	{								       \
 		{							       \
 			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vm_stat, stat)	       \
 		},							       \
-		.name = #stat,						       \
+		.name = nm,						       \
 	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
+#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz, nm)	       \
 	{								       \
 		{							       \
 			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
 		},							       \
-		.name = #stat,						       \
+		.name = nm,						       \
 	}
-/* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
-
-#define STATS_DESC_CUMULATIVE(SCOPE, name, unit, base, exponent)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE,		       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_INSTANT(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT,			       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_PEAK(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK,			       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_LINEAR_HIST(SCOPE, name, unit, base, exponent, sz, bsz)     \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LINEAR_HIST,		       \
-		unit, base, exponent, sz, bsz)
-#define STATS_DESC_LOG_HIST(SCOPE, name, unit, base, exponent, sz)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LOG_HIST,		       \
-		unit, base, exponent, sz, 0)
+
+/* SCOPE: VM, VCPU */
+#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz, nm)	       \
+	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz, nm)
+
+#define STATS_DESC_CUMULATIVE(SCOPE, stat, unit, base, exp, name)	       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_CUMULATIVE,		       \
+		unit, base, exp, 1, 0, name)
+#define STATS_DESC_INSTANT(SCOPE, stat, unit, base, exp, name)		       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_INSTANT,			       \
+		unit, base, exp, 1, 0, name)
+#define STATS_DESC_PEAK(SCOPE, stat, unit, base, exp, name)		       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_PEAK,			       \
+		unit, base, exp, 1, 0, name)
+#define STATS_DESC_LINEAR_HIST(SCOPE, stat, unit, base, exp, sz, bsz, name)    \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
+		unit, base, exp, sz, bsz, name)
+#define STATS_DESC_LOG_HIST(SCOPE, stat, unit, base, exp, sz, name)	       \
+	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LOG_HIST,		       \
+		unit, base, exp, sz, 0, name)
 
 /* Cumulative counter, read/write */
-#define STATS_DESC_COUNTER(SCOPE, name)					       \
-	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
-		KVM_STATS_BASE_POW10, 0)
+#define _STATS_DESC_COUNTER(SCOPE, stat, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+		KVM_STATS_BASE_POW10, 0, name)
+#define STATS_DESC_COUNTER(SCOPE, stat)					       \
+	_STATS_DESC_COUNTER(SCOPE, stat, #stat)
 /* Instantaneous counter, read only */
-#define STATS_DESC_ICOUNTER(SCOPE, name)				       \
-	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
-		KVM_STATS_BASE_POW10, 0)
+#define _STATS_DESC_ICOUNTER(SCOPE, stat, name)				       \
+	STATS_DESC_INSTANT(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+		KVM_STATS_BASE_POW10, 0, name)
+#define STATS_DESC_ICOUNTER(SCOPE, stat)				       \
+	_STATS_DESC_ICOUNTER(SCOPE, stat, #stat)			       \
 /* Peak counter, read/write */
-#define STATS_DESC_PCOUNTER(SCOPE, name)				       \
-	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
-		KVM_STATS_BASE_POW10, 0)
+#define _STATS_DESC_PCOUNTER(SCOPE, stat, name)				       \
+	STATS_DESC_PEAK(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+		KVM_STATS_BASE_POW10, 0, name)
+#define STATS_DESC_PCOUNTER(SCOPE, stat)				       \
+	_STATS_DESC_PCOUNTER(SCOPE, stat, #stat)			       \
 
 /* Cumulative time in nanosecond */
-#define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
-	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9)
+#define _STATS_DESC_TIME_NSEC(SCOPE, stat, name)			       \
+	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, name)
+#define STATS_DESC_TIME_NSEC(SCOPE, stat)				       \
+	_STATS_DESC_TIME_NSEC(SCOPE, stat, #stat)			       \
 /* Linear histogram for time in nanosecond */
-#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, name, sz, bsz)		       \
-	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, sz, bsz)
+#define _STATS_DESC_LINHIST_TIME_NSEC(SCOPE, stat, sz, bsz, name)	       \
+	STATS_DESC_LINEAR_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, bsz, name)
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, stat, sz, bsz)		       \
+	_STATS_DESC_LINHIST_TIME_NSEC(SCOPE, stat, sz, bsz, #stat)	       \
 /* Logarithmic histogram for time in nanosecond */
-#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, name, sz)			       \
-	STATS_DESC_LOG_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, sz)
+#define _STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, stat, sz, name)		       \
+	STATS_DESC_LOG_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, name)
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, stat, sz)			       \
+	_STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, stat, sz, #stat)		       \
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush_requests)
+	_STATS_DESC_COUNTER(VM, generic.remote_tlb_flush, "remote_tlb_flush"), \
+	_STATS_DESC_COUNTER(VM, generic.remote_tlb_flush_requests,	       \
+			"remote_tlb_flush_requests")
 
 #define KVM_GENERIC_VCPU_STATS()					       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_attempted_poll),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
-			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
-			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+	_STATS_DESC_COUNTER(VCPU, generic.halt_successful_poll,		       \
+			"halt_successful_poll"),			       \
+	_STATS_DESC_COUNTER(VCPU, generic.halt_attempted_poll,		       \
+			"halt_attempted_poll"),				       \
+	_STATS_DESC_COUNTER(VCPU, generic.halt_poll_invalid,		       \
+			"halt_poll_invalid"),				       \
+	_STATS_DESC_COUNTER(VCPU, generic.halt_wakeup, "halt_wakeup"),	       \
+	_STATS_DESC_TIME_NSEC(VCPU, generic.halt_poll_success_ns,	       \
+			"halt_poll_success_ns"),			       \
+	_STATS_DESC_TIME_NSEC(VCPU, generic.halt_poll_fail_ns,		       \
+			"halt_poll_fail_ns"),				       \
+	_STATS_DESC_TIME_NSEC(VCPU, generic.halt_wait_ns, "halt_wait_ns"),     \
+	_STATS_DESC_LOGHIST_TIME_NSEC(VCPU, generic.halt_poll_success_hist,    \
+			HALT_POLL_HIST_COUNT, "halt_poll_success_hist"),       \
+	_STATS_DESC_LOGHIST_TIME_NSEC(VCPU, generic.halt_poll_fail_hist,       \
+			HALT_POLL_HIST_COUNT, "halt_poll_fail_hist"),	       \
+	_STATS_DESC_LOGHIST_TIME_NSEC(VCPU, generic.halt_wait_hist,	       \
+			HALT_POLL_HIST_COUNT, "halt_wait_hist")
 
 extern struct dentry *kvm_debugfs_dir;
 

base-commit: 73f122c4f06f650ddf7f7410d8510db1a92a16a0
-- 
2.33.0.1079.g6e70778dc9-goog

