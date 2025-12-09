Return-Path: <kvm+bounces-65597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA290CB112A
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 21:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CF26A3043476
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 20:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A40309EEB;
	Tue,  9 Dec 2025 20:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vvNGip2s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C222FBE14
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313552; cv=none; b=oOgfj0ie0LOBKXuqjQNJTTUdpMygK+RnHPQnx8GRZMvVCuRBsuw8hZPGw2BV+3o2dXrY7fbQD7ADu/LwU8plOuo4SuFPkR7a1wQC2Xq+4lW6n4haHqnhyygR8kCyDW+yeHg1KYM2wcykmn8f4Kv2ghbNxI6xU/tbpOCejcW+5n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313552; c=relaxed/simple;
	bh=k/nMGCP44lTyxOTDNhpSpKnt2VfnuuwutQPmX8YXDEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ukVaEII4xR8aJa+VSJA+f/S+ZaF1Qn75J90V/ltOrLNRMVhwQqTgJkWKy4Aw/QhuQh/q2NmKuk3B5qRETx56wV/lI6Q5KVeML83+3G3jXzmRjzqz92gAwfExm7eMBnuSM8wkAiCGypguIUlCD3AMp+nxcvdrkLo8hrijGfYvsGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vvNGip2s; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c6ce3b9fa0so6819628a34.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313549; x=1765918349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=avZ9OXi40r9I3tBhG1OZSSWwPglo/DoIFRIQKLTo7zA=;
        b=vvNGip2saGXfoamJoPDLRSwEv/vGYfuN/YszvybUf5Tr8DoMKJM7qasWXIaQGlE6BO
         h21gD+YKR/lVgar3j2jMoL5HKLJGPCqrXFnPLtjIMst3UXBxGTXiRzEHA5nJ0fx2/eEv
         0eQqBSI/E7VzJ0nu5ymAdHYoxzbh0PMYR9mWeOAYe1AKzD7+ewAA/nIh81CVqRGfI7pq
         RmnICWKRepyMktQ7Ph4iM3iRQzPEwhpO37mnoEz2vg0huZDmEdiIOWDciOVLBYE3w1RS
         OhfqMVyEuqMl6cmaS6j3qaDJ4FT62D4g2BmegvG8QMOa/CTw5GaXk9Y0IBe02rmWmGMs
         KqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313549; x=1765918349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avZ9OXi40r9I3tBhG1OZSSWwPglo/DoIFRIQKLTo7zA=;
        b=axvIfuxKUJS7iXR4FT7WVm/eF06Um7rO4d2Jmv2cuQU9iHiP8SpVVQXSUqkZG8rXV8
         8QQogo1jFchaXu7Z0X+qitsl2cUI0ae+mn3huvpuM6FWUyD02Yggm0NzqLeYnHpu9gNr
         xDYLAKTn3UBe5rHqDsa/bgn0NmDu+I0cJGTUJ59gOXy8h8PivTvhG1D2/g24efzSzHF2
         HEyJS/pJtQwqajvU5+siYAMWpeKdO2VXCAOrcJBEStRPGPOl5XuJGGGXSIDCFgkUqXjj
         ytmpF4LNELMH9Adb40CJJYrEc073z3/jcOAjSVMfM+7l+98Eklgk7jpP3UWSoqYUGMbj
         LYMg==
X-Gm-Message-State: AOJu0Yx1JyNuweQFf53Co7iPS0+vzGc9yOMhcoCOEBZbNCKEc7CudRQ0
	g/1IUs6NeeLEfzCkEIPQtluO9k3pBf5JzdN9uaejmTYOD4kjZbNDb20XJNPZPt6PRAH2peUoCTN
	UG2SEjoHmcq8TDZNKcvF4MYnIt8y+Lt3xX2hEC+vyUlyCljerHKiOlTY9utiADh9JtslDXMk75I
	ourwixWqWSN/bNi6/prabXR3kKa2vAYpzXNTw9chGtYqt/JjER2iGIlJi5mDk=
X-Google-Smtp-Source: AGHT+IGBJBO46UR3T81/n2L+V0opSJVwtEO5cO1rJLAwUl/wZGtRFy5mrcug0+A8VGtDI6JSlEB8C9Gz2V+VpcB2Qw==
X-Received: from otbbq1.prod.google.com ([2002:a05:6830:3881:b0:7c7:583b:2e9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:4411:b0:7c7:1e8a:c9e0 with SMTP id 46e09a7af769-7cacec42631mr79191a34.23.1765313548734;
 Tue, 09 Dec 2025 12:52:28 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:00 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-4-coltonlewis@google.com>
Subject: [PATCH v5 03/24] KVM: arm64: Include KVM headers to get forward declarations
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Include include/uapi/linux/kvm.h and include/linux/kvm_types.h in ARM's
public arm_arch_timer.h and arm_pmu.h headers to get forward declarations
of things like "struct kvm_vcpu" and "struct kvm_device_attr", which are
referenced but never declared (neither file includes *any* KVM headers).

The missing includes don't currently cause problems because of the order
of includes in parent files, but that order is largely arbitrary and is
subject to change, e.g. a future commit will move the ARM specific headers
to arch/arm64/include/asm and reorder parent includes to maintain
alphabetic ordering.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250611001042.170501-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/kvm/arm_arch_timer.h | 2 ++
 include/kvm/arm_pmu.h        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..d55359e67c22c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_ARCH_TIMER_H
 #define __ASM_ARM_KVM_ARCH_TIMER_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..baf028d19dfc9 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 
-- 
2.52.0.239.gd5f0c6e74e-goog


