Return-Path: <kvm+bounces-58220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49499B8B6F4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002983A7F52
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDA52DF3E7;
	Fri, 19 Sep 2025 21:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPECOsGO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64542DC790
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319190; cv=none; b=hqq6SkysXQn1uIejOBcvRco01jC47UjTJeZV+mRF4BfA3HEWmJU5KkPLMC2pnRsjjwbGAb4FS4SQLeYZz9g/iTnptJlO57ECy03/9C4V4dNwVTJ9odOKMoMGBkHLQMsUycOP2xGNdc02XZstvCQq+iWTtlsmja4eHqQ2G8CE4cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319190; c=relaxed/simple;
	bh=gsn2LS9MZ0/r32Bz+FAmilAqbI9lmLhCm/3NWyexLkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CgtXtpjZGmfoK7A7giSShDPbnqmambXZBU21LoAzOGRArcAIghs8eTcSscNXh2+V3Kdxr7X11qJpZmW0oA9zu1Q7Yo9P238oWvx/y789aJ063iQg2dJxM35HXKQ+/2C0j1zITFxDlUAJKtZO2k8hHtRVTux1sgIruMrnk4pPyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPECOsGO; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54b37ba2d9so2763638a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319188; x=1758923988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tb2CJ3cAd7NGczYuI0z0dLZESADxvuqEmD3PjMDN8y4=;
        b=JPECOsGOWfa2hEkQ7wl8nWl7uaYEgXMI03KPjTV9H3KaWUxP00UImRrYo/zMKLQj0w
         uRKcKKQ15fZtFKeaRgB9q7t54nu85HIOQmKIcK2nkTAsl4IbC4MlO/CTpQnqZDMEnzf4
         vxKVhCrRD2kKpx81AUyPJS3yu3E8J2CeSi33R7yy9YKz5QM1hJ1G5bBcwPgpvkncNqXl
         5BF2ukp7USHtyAZV9nUpt90sZYeoi+Ss00ARAHVg+07/e4TNC1x+JB5furDHwUMSZbPR
         f8IxxkjpiS84EbZYQeH2oMlUtIJsYhJ39E2KMetDCr7yUGWdAIIO/9YJyzQ6VK/svv/T
         OCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319188; x=1758923988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tb2CJ3cAd7NGczYuI0z0dLZESADxvuqEmD3PjMDN8y4=;
        b=DDGbIIw/e9F9BFC1DbqJzALyS+ReTG6EHv7C+/BFVqL3Ky+GaCFpdIGDCKX7QU6qIS
         4BHMgKDc7ZgZRhBSCUuoWmdjalbdaQNu8tJjzmPh15DJ+b44GFiCa9Nrj8OV/yCHIxrQ
         vk6P+LOVT18tkPSWsCPw0li1jfAcwlAguUcM+kzJmr9a/opPvkcfZzCOlkGiiAsAeBgu
         B3mGlOX4ZEjEnKnYgMUU7uxvU0xby9PmUWRPSU0JPlDYHFcoCYEhCnAYHjn2aeXzkJhy
         1B18MbqF6h6XF9eFGGqfj41zQiUuVd+vGIJZISDDw8GM3bPGaICeU8OpRE1UGgi/jBuO
         F9MQ==
X-Gm-Message-State: AOJu0Yy0eqURDFFT1yhbf0IfUdfZksMv9yT2f3O443MgGCoukeO/gLg/
	pVshoxBHH3QkBLMEUyaSjo67ALui8kQ2amfRVkNsRsLJbR5txdh5gUt8BfuERwCAn2yg0OAT9K5
	Q8nUplQ==
X-Google-Smtp-Source: AGHT+IHFJR0vBTAZhUhFWYQATSw48DKFzjt9Py0RyOipJEiS7BJGMQ6J8RRVJHpyIkCK2VMmnqt8BdNygEI=
X-Received: from pjcc8.prod.google.com ([2002:a17:90b:5748:b0:32e:8ff7:495])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1cc7:b0:32d:e309:8d76
 with SMTP id 98e67ed59e1d1-33093851ef6mr6452139a91.10.1758319188191; Fri, 19
 Sep 2025 14:59:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:59:34 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919215934.1590410-8-seanjc@google.com>
Subject: [PATCH v4 7/7] KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC
 is support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Naveen N Rao (AMD) <naveen@kernel.org>

AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
errata.  Enable AVIC and x2AVIC by default on Zen4+ so long as x2AVIC is
supported (to avoid enabling partial support for APIC virtualization by
default).

Internally, convert "avic" to an integer so that KVM can identify if the
user has asked to explicitly enable or disable AVIC, i.e. so that KVM
doesn't override an explicit 'y' from the user.  Arbitrarily use -1 to
denote auto-mode, and accept the string "auto" for the module param in
addition to standard boolean values, i.e. continue to allow the user to
configure the "avic" module parameter to explicitly enable/disable AVIC.

To again maintain backward compatibility with a standard boolean param,
set KERNEL_PARAM_OPS_FL_NOARG, which tells the params infrastructure to
allow empty values for %true, i.e. to interpret a bare "avic" as "avic=y".
Take care to check for a NULL @val when looking for "auto"!

Lastly, always print "avic" as a boolean, since auto-mode is resolved
during module initialization, i.e. the user should never see "auto" in
sysfs.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ec214062d136..f286b5706d7c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -64,12 +64,32 @@
 
 static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
 
+#define AVIC_AUTO_MODE -1
+
+static int avic_param_set(const char *val, const struct kernel_param *kp)
+{
+	if (val && sysfs_streq(val, "auto")) {
+		*(int *)kp->arg = AVIC_AUTO_MODE;
+		return 0;
+	}
+
+	return param_set_bint(val, kp);
+}
+
+static const struct kernel_param_ops avic_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = avic_param_set,
+	.get = param_get_bool,
+};
+
 /*
- * enable / disable AVIC.  Because the defaults differ for APICv
- * support between VMX and SVM we cannot use module_param_named.
+ * Enable / disable AVIC.  In "auto" mode (default behavior), AVIC is enabled
+ * for Zen4+ CPUs with x2AVIC (and all other criteria for enablement are met).
  */
-static bool avic;
-module_param(avic, bool, 0444);
+static int avic = AVIC_AUTO_MODE;
+module_param_cb(avic, &avic_ops, &avic, 0444);
+__MODULE_PARM_TYPE(avic, "bool");
+
 module_param(enable_ipiv, bool, 0444);
 
 static bool force_avic;
@@ -1151,6 +1171,18 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static bool __init avic_want_avic_enabled(void)
 {
+	/*
+	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
+	 * supported (to avoid enabling partial support by default, and because
+	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
+	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
+	 * aren't inclusive of previous generations, i.e. the kernel will set
+	 * at most one ZenX feature flag.
+	 */
+	if (avic == AVIC_AUTO_MODE)
+		avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
+		       (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));
+
 	if (!avic || !npt_enabled)
 		return false;
 
-- 
2.51.0.470.ga7dc726c21-goog


