Return-Path: <kvm+bounces-21276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6B092CC28
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E57EB21C9E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 07:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9A984A3E;
	Wed, 10 Jul 2024 07:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jRP6Jtcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B274F28DC1
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 07:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720597496; cv=none; b=YEdnJwfpDYopxUbfgHzTIlRQoflFPUOuLIDj3q6lWsgx5SvzUCjJ9tZ3DteVOK2eV+Ww6+vGGSnueVCslWCvvRMZECpaC9ms+lLRvePN0Ooo8vypLmwsJolpF/3bHfeANNZ9QKlAAJhhQv/lAeL348uheVwhzGyD46rqrYYGxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720597496; c=relaxed/simple;
	bh=NFA/eGJ5BiT1NRTpFcQsH6l/2DvH5iwAnJIzXS/rcws=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=NS+XzGiKaDvQBGY+/PHse9490ccUeA/XfpVeFMGFMXN92vgqwxZbnW2Bom9rYenpEd9WMB/8jw45VKHiHiS+lHzjAWSp1yvKGS7LHC9ovBoMMv2w4/441r3mPmpVPvrEKGv747A0MGurwJ35C6TD8nxsnWc/91ycAz9uR6npZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jRP6Jtcf; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65026e6285eso99758587b3.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720597493; x=1721202293; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=397VaajrQh7vF2cn+LZkVRkZgjP1ICYXhLEIeqhys40=;
        b=jRP6JtcfASFHOCJi1xQuzM3L3aaA+OAW4CFfsdemCS+HhPO7Fspgor1M1JkF3dXWOq
         gJLou/3MLGpKCttln9rSIe7MSPT5wWx56xR2mcrl2C2ZdU//Y6PoKKQJ82uvMTqx3BOB
         bDmMEJ/aQpzo4sVqloudCu7458oYIAworTQeUyA9WNSIGy34g4D+wk+OSNwkOrIF2geU
         SprRSh2/3t0B1/v90NFy08z1ceMZGTfCCS07cN+3bn1Ocibv8+cjRhg6h6T+wCQGPmoE
         fYUnvhfNXbwfDx+xmjgJvNSn7GP8sN+JN2H7b8sPE7ovpeEMR7MlzKyzMsSvWsQOMK7I
         PKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720597493; x=1721202293;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=397VaajrQh7vF2cn+LZkVRkZgjP1ICYXhLEIeqhys40=;
        b=k6Xedmr0KuhidqZZ3yq/NXSfuOpO2K5volK76U/qqeGgSjJMy234dj10w2BzcuhM/e
         YnxjFSjtZSqWFf0mBbv+H5W5wzBF1Si5+f+34FowMs2YAgoAlvVU101hm013OmPh2F21
         P3n506UWNK26YySDXLlt593tM3eOocNbw3qOCsYSBj82TZ304llGexz1jbMIEU/RlpY5
         73P+orWI666PDN0jVO3iFk4SblNROU7mVCIytDweL9ozEUXifxVmdrplq4eUMYOT+ExU
         VKkAkIyCOXbBHH/F49DmhRfJSxxxJTEvQJOxffYKYFmkcsua6IIYs8jJaS983f8SBmNB
         38Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUODuWv0DE58TYxrFC9ohXFostVfplWK2R2Ghn7qHqcYqHDR/0sUzY4uqyEdkYTqyrsuXNJVd4ZnssSBeCWe4344SCH
X-Gm-Message-State: AOJu0YydovK+e4/8isxj1UPzWpGW6tH9G6bdVE2zqd+6+E3QXPdD8e1S
	msCBX9nJ8VtTAl1SbKIFHp82nLorrqzjcdTR836lodAeQVdZOQ1lLXTYuwHvMZYrGJDMMbDI2zA
	MlfGPOiIxiQ==
X-Google-Smtp-Source: AGHT+IHt5kZdtoS2H5Syk1A9nS7O+9pjqO3zvXAExnyo/nWo9plh0LoU/4cjf5Sn2oO9CdnEP3PWZ45EqBuCtA==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:43d8:8a15:a169:cf89])
 (user=suleiman job=sendgmr) by 2002:a05:6902:70b:b0:e03:5144:1d48 with SMTP
 id 3f1490d57ef6-e041b142c52mr9887276.11.1720597493668; Wed, 10 Jul 2024
 00:44:53 -0700 (PDT)
Date: Wed, 10 Jul 2024 16:44:10 +0900
Message-Id: <20240710074410.770409-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Subject: [PATCH] KVM: x86: Include host suspended time in steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: ssouhlal@FreeBSD.org, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling. This can be particularly noticeable
if the guest task was RT, as it can end up getting throttled for a
long time.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest can subtract the
duration from the tasks' runtime.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
 include/linux/kvm_host.h |  4 ++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0763a0f72a067f..94bbdeef843863 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-	u64 steal;
+	u64 steal, suspend_duration;
 	u32 version;
 
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
@@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 			return;
 	}
 
+	suspend_duration = 0;
+	if (READ_ONCE(vcpu->suspended)) {
+		suspend_duration = vcpu->kvm->last_suspend_duration;
+		vcpu->suspended = 0;
+	}
+
 	st = (struct kvm_steal_time __user *)ghc->hva;
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
@@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	unsafe_get_user(steal, &st->steal, out);
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
+	steal += suspend_duration;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
 	unsafe_put_user(steal, &st->steal, out);
 
@@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		WRITE_ONCE(vcpu->suspended, 1);
 		if (!vcpu->arch.pv_time.active)
 			continue;
 
@@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 	}
 	mutex_unlock(&kvm->lock);
 
+	kvm->suspended_time = ktime_get_boottime_ns();
+
 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
+static int
+kvm_arch_resume_notifier(struct kvm *kvm)
+{
+	kvm->last_suspend_duration = ktime_get_boottime_ns() -
+	    kvm->suspended_time;
+	return NOTIFY_DONE;
+}
+
 int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 {
 	switch (state) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18ef..2d37af9a348648 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -366,6 +366,8 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+	bool suspended;
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	/*
 	 * Cpu relax intercept or pause loop exit optimization
@@ -840,6 +842,8 @@ struct kvm {
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+	u64 last_suspend_duration;
+	u64 suspended_time;
 };
 
 #define kvm_err(fmt, ...) \
-- 
2.45.2.993.g49e7a77208-goog


