Return-Path: <kvm+bounces-37418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B22A29DD9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 01:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6C2E164EE1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452DEDF60;
	Thu,  6 Feb 2025 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nW/ylQ78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A522907
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 00:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738801112; cv=none; b=ktjZTJrAxWWbhzw5/+nsUuah3DshA6qq9LGRQFlU8IZLSlQ0StT67gOhfckRNDs3q1QeAf9PViOQaw91TNxKLHxcF1t9b2BVUcNi7ii1OvUYqNj4MICuQj7wEv6MumyqAYAJE4OB4d2kEQ3arRjSnxL7E68ERXLOc2tgGEFqlJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738801112; c=relaxed/simple;
	bh=E10Fe+xOECzbVvSUHJIawMxUtiAytKMIxx8zDDSzvhw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cK2s2AKINLJVPtJwpCm5KXiZvjaOYswCKrPW2SeK8zDv2ySEFVkEmbBJCBUhS1Y5zCZSpCMvj5GXuYViJqqEXuzwKht0QbYnqgX53Gy8R/05H+WkCexlpAZfRq35BgAqHh3UrAwDQXWMPUQ7fsgVBOIA2b6iSw/Lwj4AkU+DqYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nW/ylQ78; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-71e17fbb9dbso408619a34.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 16:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738801109; x=1739405909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zr3/LuzVjUoCOE75RpPvv8HgrgBhtrHXf0v0cKrFx3I=;
        b=nW/ylQ78nbkOpGzAHWEtoBewz8Wmme3nLe8FZIZ4Fhgo6AJmyIDqDeFOAc3K2tYAmi
         E4ngPEivAsHBa9KslngCkeSAJNpg9DIkemB4wvNkd7BBvue+MMU19x1yJKVZ6Wo4SIQD
         KAT3p4kkGmR5YCcnbL0cgMY16IOq5mt8IUBA5tj1CllNT1wLoBiR9HfjEhIUGLC1e4nG
         4++AC0NJut9f60ehNs01eGI7iq4IDK6AzgSkIC345IgcjPahEmRoxCirsZQtvoctOEHr
         gaGA1KCEi21+zAYGpqnHLw6034ebF/Ufhks5vXa+wMeS2YOmHS9RV2k3HsytMt0LKext
         bslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738801109; x=1739405909;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zr3/LuzVjUoCOE75RpPvv8HgrgBhtrHXf0v0cKrFx3I=;
        b=QSNV5Zezf1PJLNU6pwh9L1j8FTIpiSb2r8PSsEiey2WE8zE2yQXqiUz7YZYgmxfPdf
         TIUIbW1FeEg6oNNzhZomL/oGrLuE0t2og+8oXZl5pemPTuP0GQp9WZdUxr1sRVuvx/w0
         oq925XDA/094Gpz4N4+xV/ZWboEy8Cci3GhKC1UMro/qTcLiK4h2459RB30SlLNhCOO8
         IWgUYwouU9B+FFN7nADXyz+Jz4shHorXhDLr73ZCNv/Wczv5rYqTkdUT+t1Glyo7ttcD
         f6QMFbi3O3eeXiJazS9qCYOGkp1c1nXVQ+HqXX5Appu0NF6UcrNAW7Ke22MHOJVPf06E
         2voQ==
X-Gm-Message-State: AOJu0YzohOomOcYIGJ/tHU58X5BZTp8RF5Xy79gIOyZ5W7hxAlOKxGCx
	gYx7fSH5V3fXmy36IclY9RLBwY90XNiJ0EjxBTFgHg65Dvpj/pYzPeWWGsP6hOi8Gcnt3EvWkxC
	l6vbyc8EdKB5FQDVUcnxFhwWb9e5yWfhq9ShXNnUSx3qqMuIDf6vQHkTvV2Cn9lB9QzG1b5IbNM
	ViPae/wkPrnZ4FV9t5W5x+TqXbf21FUptLCmhilAIGsp5oi7aCR2KShEQ=
X-Google-Smtp-Source: AGHT+IEVrsS8ZrjIpYlGyg1Ed1+MVibgRhSBBaTAljJpus0kxqPO6kMqiuj10XnP6c5iR6jfwp3/WzcdNy0U3kgBdA==
X-Received: from otqn6.prod.google.com ([2002:a9d:6f06:0:b0:71d:fe90:fac3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:3982:b0:71d:eee3:fd1a with SMTP id 46e09a7af769-726a3fbc8e8mr3724016a34.0.1738801108890;
 Wed, 05 Feb 2025 16:18:28 -0800 (PST)
Date: Thu,  6 Feb 2025 00:17:44 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250206001744.3155465-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
causes confusing compilation problems why trying to use anything
defined in any of the headers in any other headers. Header guards is
the only reason this cycle didn't create tons of redefinition
warnings.

The motivating example was figuring out it was impossible to use the
hypercall macros kvm_call_hyp* from kvm_host.h in arm_pmuv3.h. The
compiler will insist they aren't defined even though kvm_host.h is
included. Many other examples are lurking which could confuse
developers in the future.

Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
because asm/kvm_host.h is huge and we only need a few functions from
it. Move the required declarations to a new header asm/kvm_pmu.h.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

Possibly spinning more definitions out of asm/kvm_host.h would be a
good idea, but I'm not interested in getting bogged down in which
functions ideally belong where. This is sufficient to break the
cyclical dependency and get rid of the compilation issues. Though I
mention the one example I found, many other similar problems could
confuse developers in the future.

v2:
* Make a new header instead of moving kvm functions into the
  dedicated pmuv3 header

v1:
https://lore.kernel.org/kvm/20250204195708.1703531-1-coltonlewis@google.com/

 arch/arm64/include/asm/arm_pmuv3.h |  3 +--
 arch/arm64/include/asm/kvm_host.h  | 14 --------------
 arch/arm64/include/asm/kvm_pmu.h   | 26 ++++++++++++++++++++++++++
 include/kvm/arm_pmu.h              |  1 -
 4 files changed, 27 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pmu.h

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..54dd27a7a19f 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,9 +6,8 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H

-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
+#include <asm/kvm_pmu.h>
 #include <asm/sysreg.h>

 #define RETURN_READ_PMEVCNTRN(n) \
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..6d4a2e7ab310 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1385,25 +1385,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);

-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 #ifdef CONFIG_KVM
-void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u64 clr);
-bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
 void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
 #else
-static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u64 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
 static inline void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest) {}
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
new file mode 100644
index 000000000000..3a8f737504d2
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __KVM_PMU_H
+#define __KVM_PMU_H
+
+void kvm_vcpu_pmu_resync_el0(void);
+
+#ifdef CONFIG_KVM
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
+#else
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
+#endif
+
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return (!has_vhe() && attr->exclude_host);
+}
+
+#endif
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 147bd3ee4f7b..2c78b1b1a9bb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
-void kvm_vcpu_pmu_resync_el0(void);

 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
--
2.48.1.362.g079036d154-goog

