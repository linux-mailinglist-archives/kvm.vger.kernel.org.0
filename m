Return-Path: <kvm+bounces-58081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4942CB87777
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 056C93AD9DB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C29B258EEF;
	Fri, 19 Sep 2025 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rj4f3aMY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E882580E2
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241312; cv=none; b=q/qSQH95o0jFV9baqs9nW/jgS4ElQ2/7Jyk5FLVGOX7mpbXYoIhfTvfLE1or41H5UAcyEhdqUt0bgu+iuBG//IEtW2V2JOK6jecps0SbbRTxC4llxr3IZ3pKW+MX0GcU7Bu0+EW8WZO2NJXYSLXS6npSTNubfrmG7dK9eEWsmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241312; c=relaxed/simple;
	bh=eAdWQ20STC+aO22I2NiOUBHDbeTXMI50HdJIM8a1srw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dtoPEJiEXCgVYT+48oQnU48xmEg/jda93QOnl5ESlyYAdsT2WrkhhWv1XbEyKUNAAsEJIYnw+Ox7ZTvHHbp1C8jT/Czsl55tER35B9zmTyvOm0kmL41Z1oTFM5kOYRvl/N2qq8wvUxK2S5+QQNl9mH60fzbRgCG5xg7UvssU7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rj4f3aMY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54a30515cfso1992726a12.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241310; x=1758846110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/XnisBKELA9d2tGgdsS2eYQoo8Hi6oyi85jDkjSCWOk=;
        b=Rj4f3aMYA++cvtreyg3LVVAwAf0DMoNqJXWpBAzpv9yPFt/jhBb1r/HRrPVbwMOO09
         +XuoOhBW6SIvS3bwMPX32amjZkmNMCoRufvr2//aRJYxp/wUFiGl0bAo3Rf9aq8ETIGP
         14VRpnKqZwJRc97KExS7Cjgu8yri5hy3Oc5KwXSKt4RTtZHHVcQInnMM5QJJUyggOlyX
         Gts3nujYjDm8uQwo2irWPXhMjR3cH0bRDA+AuL2pYR+HJAkL+GplPyCXmj2ARM3AN8ad
         iDHvgzB8PunXt0TFC51jyII2qaUadnjaTdHYLvPMn/MRJjjcNe7XKcJ5N8ovUaA5JCTr
         s8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241310; x=1758846110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XnisBKELA9d2tGgdsS2eYQoo8Hi6oyi85jDkjSCWOk=;
        b=dX8Nb0CcH8D/4dgloxJXijBQFln04i8zmfGqanJ33DLTp8H9B2MW9lkvLz4pSQFbbL
         QGWYWKmf90FNZ/lw9JpOIRZNQGrTjY88aMSlZBenozbpDOXvphhvze4QHG7guhkPt6Uj
         AaNLH5rzBg3RJR1BIrFx3ZJOZf8LMCkYSm1RVHqP321VMLphru+UZ8W3d+3Hfb8d6huT
         6Xtaz0li8jbpmojKhrPRjNLNwHo6uVz5vIbXD6c+0uXfQTuyIQVD0nX4BEMsjecDEZJu
         Bfwuk9MiMzKdszbw/JQBFcfSMJNSbGIbYvK2x7dP3Ac4OqKrJ9KOELfnrc6s/sFLDtaA
         R7oQ==
X-Gm-Message-State: AOJu0YynucbfPdLNuIv/GH5qhoxDxs2dRrRSO5aAPAOVQCCGUp00Mhon
	AX4MQGmReCHH8gI+JbTG72BhZnI9xYYsbzlph6uMXNOy0TO25P4lA5fVU5/yzZpIHuYCjH/oRBm
	ph/iLpQ==
X-Google-Smtp-Source: AGHT+IHetFezI39yArnj+htGSxD3veR1qrJfTAeWbX6VuCSVOeIs07E0erJA6DVDdazEQt3+OKd6+pSGb4o=
X-Received: from pga10.prod.google.com ([2002:a05:6a02:4f8a:b0:b54:928e:2e3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a114:b0:240:1e4a:64cc
 with SMTP id adf61e73a8af0-2844f6c7b0fmr8375584637.12.1758241310153; Thu, 18
 Sep 2025 17:21:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:36 -0700
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-7-seanjc@google.com>
Subject: [PATCH v3 6/6] KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC
 is support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Naveen N Rao <naveen@kernel.org>

AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
errata.  Enable AVIC and x2AVIC by default on Zen4+ so long as x2AVIC is
supported (to avoid enabling partial support for APIC virtualization by
default).

Internally, convert "avic" to an integer so that KVM can identify if the
user has asked to explicitly enable or disable AVIC, i.e. so that KVM
doesn't override an explicit 'y' from the user.  Arbitrarily use -1 to
denote auto-mode, and accept the string "auto" for the module param in
addition to standard boolean values, i.e. continue to allow to the user
configure the "avic" module parameter to explicitly enable/disable AVIC.

To again maintain backward compatibility with a standard boolean param,
set KERNEL_PARAM_OPS_FL_NOARG, which tells the params infrastructure to
allow empty values for %true, i.e. to interpret a bare "avic" as "avic=y".
Take care to check for a NULL @val when looking for "auto"!

Lastly, always print "avic" as a boolean, since auto-mode is resolved
during module initialization, i.e. the user should never see "auto" in
sysfs.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e059dcae6945..5cccee755213 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -64,12 +64,31 @@
 
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
@@ -1151,6 +1170,18 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static bool __init avic_want_avic_enable(void)
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


