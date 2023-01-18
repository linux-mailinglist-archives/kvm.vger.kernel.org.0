Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C97672592
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjARRx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjARRxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:12 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659C04AA7C
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id q9-20020a17090a304900b00226e84c4880so14690212pjl.4
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eLQ7+1VQS0cnnGkFkJF2+BG9BNqWWsu6xKEgIL21Bxk=;
        b=H1vFFmoUYuI5vo6OHlxhe/Tr92InVnObougeDuC2X8uxNmFi3r1PD9w5SMxZQX5UH/
         ES6nxOBUAd+Q+eNnpmIvh014clJP1z9z2buEQ1MxubhmYGQuNTsqTRw45Fo8O/cTQZus
         BKUt26F1qaszKfAhruboQH779o0Y92KAmRTWRAA8hJlRarn8XmyWJj59itQlbPc00XRD
         B2EA7jG5IIA2et8FUbb1zeh6KoccFy5Jf2VWqp7xaOAGB1ZXnjpY3Wn/y9bH5jx6Rh1K
         W7zhp4Y9lZX8EtlDNCxqSM6pqBfNT4gPH05/XFDToknHOnH84DivC6vrDMwn079Zp6Kr
         12VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLQ7+1VQS0cnnGkFkJF2+BG9BNqWWsu6xKEgIL21Bxk=;
        b=s2Td3ouMxjQN89KJdES70UWR7gSk+oVT5N5H5apSYEjPJpenqSPCHp7R4ElKpliibz
         WNSJmT0c19lqSMLapu+rwLhee5ugvI3GFDlTwemyz75a3wjAKHPyx60J0HyhVRu04rSI
         NW8pr9Gq4BxHo1Ko9H7fls6ebJwxTnxurHC5e2q3TpcM9ObcgAZUN4r02xEBkmbdG3Qr
         +pEUEPDJZrhkOTUs7HHGwnLmeGuQh+1T7o06DtKqv9rIQ9E8IebFpFRIBHwq+991mazB
         XQpFEbxU5LcyM2R9MujO5P09MaQUaEdUzYTod//6DXkq4W09MxD89ry0/4ZR7vtDKA/u
         3tHg==
X-Gm-Message-State: AFqh2koGOajJpTIn0YkQaKPlW0iaZcHBmgMtFmvNj16897nHrp+zmb2O
        YrEg4LFT3KG+8VerK9EPJAWvNo4hhvNeMA==
X-Google-Smtp-Source: AMrXdXtakeitXu8drONjerlJUIDenxKRRsZYSOoLlORelDRvY/VQ0QWBghyfH9sVjkWoToU5RaOGqcz6+K7Gag==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:2707:0:b0:477:c8ea:b734 with SMTP id
 n7-20020a632707000000b00477c8eab734mr513332pgn.294.1674064390885; Wed, 18 Jan
 2023 09:53:10 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:52:59 -0800
In-Reply-To: <20230118175300.790835-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230118175300.790835-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-5-dmatlack@google.com>
Subject: [PATCH 4/5] KVM: Allow custom names for stats
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow custom names to be specified for stats by providing inner macros
that allow passing a custom name. e.g.

  STATS_DESC_COUNTER(VM, foo),
  __STATS_DESC_COUNTER(VM, bar, "custom_name")

Custom name support enables decoupling the userspace-visible stat names
from their internal representation in C. This can allow future commits
to refactor the various stats structs without impacting userspace tools
that read KVM stats.

This also allows stats to be stored in data structures such as arrays,
without needing unions to access specific stats. For example, the union
for pages_{4k,2m,1g} is no longer necessary. At Google, we have several
other out-of-tree stats that would benefit from this support.

Support for stat names could be added incrementally (as needed) for all
the different STAT_DESC_*() macros. But doing it all at once avoids
future churn and ensures the different stat macros have a consistent
interface for specifying the name.

No functional change intended.

Link: https://lore.kernel.org/all/20211019000459.3163029-1-jingzhangos@google.com/
Suggested-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 104 ++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cceb159727b5..5e37acc2e80e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1753,18 +1753,18 @@ struct _kvm_stats_desc {
 	.size = _size,							       \
 	.bucket_size = _bucket_size
 
-#define VM_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,    \
-			      _bucket_size)				       \
+#define VM_GENERIC_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent,    \
+			      _size, _bucket_size)			       \
 	{								       \
 		{							       \
 			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
 					  _size, _bucket_size),		       \
 			.offset = offsetof(struct kvm_vm_stat, generic._stat)  \
 		},							       \
-		.name = #_stat,						       \
+		.name = _name,						       \
 	}
-#define VCPU_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,  \
-				_bucket_size)				       \
+#define VCPU_GENERIC_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent,  \
+				_size, _bucket_size)			       \
 	{								       \
 		{							       \
 			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
@@ -1772,9 +1772,9 @@ struct _kvm_stats_desc {
 			.offset =					       \
 				offsetof(struct kvm_vcpu_stat, generic._stat)  \
 		},							       \
-		.name = #_stat,						       \
+		.name = _name,						       \
 	}
-#define VM_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+#define VM_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent, _size,     \
 		      _bucket_size)					       \
 	{								       \
 		{							       \
@@ -1782,9 +1782,9 @@ struct _kvm_stats_desc {
 					  _size, _bucket_size),		       \
 			.offset = offsetof(struct kvm_vm_stat, _stat)	       \
 		},							       \
-		.name = #_stat,						       \
+		.name = _name,						       \
 	}
-#define VCPU_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+#define VCPU_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent, _size,   \
 			_bucket_size)					       \
 	{								       \
 		{							       \
@@ -1792,65 +1792,89 @@ struct _kvm_stats_desc {
 					  _size, _bucket_size),		       \
 			.offset = offsetof(struct kvm_vcpu_stat, _stat)	       \
 		},							       \
-		.name = #_stat,						       \
+		.name = _name,						       \
 	}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, _stat, _type, _unit, _base, _exponent, _size,        \
+#define STATS_DESC(SCOPE, _stat, _name, _type, _unit, _base, _exponent, _size, \
 		   _bucket_size)					       \
-	SCOPE##_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,       \
-			   _bucket_size)
+	SCOPE##_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent,       \
+			   _size, _bucket_size)	       \
 
-#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _unit, _base, exponent)	       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_CUMULATIVE,		       \
+#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, _unit, _base, exponent)     \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_CUMULATIVE,	       \
 		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_INSTANT(SCOPE, _stat, _unit, _base, exponent)	       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_INSTANT,		       \
+#define STATS_DESC_INSTANT(SCOPE, _stat, _name, _unit, _base, exponent)	       \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_INSTANT,		       \
 		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_PEAK(SCOPE, _stat, _unit, _base, exponent)		       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_PEAK,			       \
+#define STATS_DESC_PEAK(SCOPE, _stat, _name, _unit, _base, exponent)	       \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_PEAK,		       \
 		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _unit, _base, exponent, _size,    \
-			       _bucket_size)				       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
+#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _name, _unit, _base, exponent,    \
+			       _size, _bucket_size)			       \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LINEAR_HIST,	       \
 		   _unit, _base, exponent, _size, _bucket_size)
-#define STATS_DESC_LOG_HIST(SCOPE, _stat, _unit, _base, exponent, _size)       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LOG_HIST,		       \
+#define STATS_DESC_LOG_HIST(SCOPE, _stat, _name, _unit, _base, exponent,       \
+			    _size)					       \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LOG_HIST,	       \
 		   _unit, _base, exponent, _size, 0)
 
 /* Cumulative counter, read/write */
-#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
-	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_NONE,	       \
+#define __STATS_DESC_COUNTER(SCOPE, _stat, _name)			       \
+	STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
 			      KVM_STATS_BASE_POW10, 0)
+#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
+	__STATS_DESC_COUNTER(SCOPE, _stat, #_stat)
+
 /* Instantaneous counter, read only */
-#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
-	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
+#define __STATS_DESC_ICOUNTER(SCOPE, _stat, _name)			       \
+	STATS_DESC_INSTANT(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
 			   KVM_STATS_BASE_POW10, 0)
+#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
+	__STATS_DESC_ICOUNTER(SCOPE, _stat, #_stat)
+
 /* Peak counter, read/write */
-#define STATS_DESC_PCOUNTER(SCOPE, _stat)				       \
-	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
+#define __STATS_DESC_PCOUNTER(SCOPE, _stat, _name)			       \
+	STATS_DESC_PEAK(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
 			KVM_STATS_BASE_POW10, 0)
+#define STATS_DESC_PCOUNTER(SCOPE, _stat)				       \
+	__STATS_DESC_PCOUNTER(SCOPE, _stat, #_stat)
 
 /* Instantaneous boolean value, read only */
-#define STATS_DESC_IBOOLEAN(SCOPE, _stat)				       \
-	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,	       \
+#define __STATS_DESC_IBOOLEAN(SCOPE, _stat, _name)			       \
+	STATS_DESC_INSTANT(SCOPE, _stat, _name, KVM_STATS_UNIT_BOOLEAN,	       \
 			   KVM_STATS_BASE_POW10, 0)
+#define STATS_DESC_IBOOLEAN(SCOPE, _stat)				       \
+	__STATS_DESC_IBOOLEAN(SCOPE, _stat, #_stat)
+
 /* Peak (sticky) boolean value, read/write */
-#define STATS_DESC_PBOOLEAN(SCOPE, _stat)				       \
-	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,		       \
+#define __STATS_DESC_PBOOLEAN(SCOPE, _stat, _name)			       \
+	STATS_DESC_PEAK(SCOPE, _stat, _name, KVM_STATS_UNIT_BOOLEAN,	       \
 			KVM_STATS_BASE_POW10, 0)
+#define STATS_DESC_PBOOLEAN(SCOPE, _stat)				       \
+	__STATS_DESC_PBOOLEAN(SOPE, _stat, #_stat)
 
 /* Cumulative time in nanosecond */
-#define STATS_DESC_TIME_NSEC(SCOPE, _stat)				       \
-	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
+#define __STATS_DESC_TIME_NSEC(SCOPE, _stat, _name)			       \
+	STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,     \
 			      KVM_STATS_BASE_POW10, -9)
+#define STATS_DESC_TIME_NSEC(SCOPE, _stat)				       \
+	__STATS_DESC_TIME_NSEC(SCOPE, _stat, #_stat)
+
 /* Linear histogram for time in nanosecond */
-#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _size, _bucket_size)	       \
-	STATS_DESC_LINEAR_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
+#define __STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _name, _size,             \
+				       _bucket_size)			       \
+	STATS_DESC_LINEAR_HIST(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,    \
 			       KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _size, _bucket_size)	       \
+	__STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, #_stat, _size,	       \
+				       _bucket_size)
+
 /* Logarithmic histogram for time in nanosecond */
-#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _size)		       \
-	STATS_DESC_LOG_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
+#define __STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _name, _size)	       \
+	STATS_DESC_LOG_HIST(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,       \
 			    KVM_STATS_BASE_POW10, -9, _size)
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _size)		       \
+	__STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, #_stat, _size)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
-- 
2.39.0.246.g2a6d74b583-goog

