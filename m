Return-Path: <kvm+bounces-17664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E84E8C8B60
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 311D31C20F92
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF944142E65;
	Fri, 17 May 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="luOOJ54Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA64142659
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967608; cv=none; b=g/nAw5QhUkI9bciXDqhO7tQT2odnBRO5wTBZV2oWCCMLuryldMExQOX0Id9N8S3uC6c0+0l4XgzpRTITclANTDguPi2tJPqlnuO+R1uUy9yXFEkKWlxfGOYMkqrSssDUCZc8LwncSMhATf9WI6PmGQjCudYaCTKYDAFAurrUTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967608; c=relaxed/simple;
	bh=Ny0YS5Ci5iDbfiYGdSEuCN2DM71VzftUth8aPtOLvj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gm/613WwyixLZpu3VWaHp+/aL8AnNhSbjkavignHqm6d6gDHvMQshecSu/5UyBHIbLFAaRFJ1HWzsKsacS94QE8hoj1CeMIlW1oKVWTknJNHzBhhtTtx4DUxwlWat5GWb3tuTq9bfeAnC/VAee+xbPBYz1GNaYKxg18wwzYe4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=luOOJ54Q; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f44b2e0bf2so8671259b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967607; x=1716572407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GlfT4D0nZkheimCIXsCGzsH6cGoNcyys8O/qCTYmhzc=;
        b=luOOJ54QJVZ9QSftatE3qb5UWsj+Zl8DiSNcb74ZHWrhoo/HUhEScmdn/Rk4FQ4sON
         su+Zy5m1RQQzk3so3WEO8tKTcn8t3+czjTF1CSxuWCBEQZKcMWK9rGghtLrQfEY7tUgE
         +5OJQJmjXgh5IuW+mUAS7YBPIpNTSzQiajzs8V+8d9emtZFarU2yg5jxAGDEMh70kJUf
         uTwAzdLenTAKWsUQ9LQBw8F1X7LV+X6fKgFGV1jtpEhEQK4Oss90b699Y1uvY5lRmfmu
         Snog+qC/Z9vaVbNgVM2Ua+Ro7JNx5uEdjCos7lFHPI4+6qS0MyduggQEfnWAC51eMu3U
         LWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967607; x=1716572407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlfT4D0nZkheimCIXsCGzsH6cGoNcyys8O/qCTYmhzc=;
        b=FDWEWvv6bSxJD8oVTCxgqUytzNqLMMiJ8448rszW2DO3nsmVTBr3gAw80Q8VWwDdxD
         W+Hri+f/ZOSQrUXPMy6JNu+4VeWuYAIpcosT9AyYaYh0/rdXa5QT0amm2zgL69XniTmW
         dDIOIuwuFxyEdgPmm0xFu6JQKO76j2DTwYZPV4ymHwt1uCUmWUhIq+Z0n6EZ1p2KusPY
         jBlkgYzXAlMaqD5b8i68es5YQRisfNroZCXsEr8xsUvOlklxIZtFqHZEhyKlnD6SsK7C
         wT9+Ywa9xNejC1aHuCDOnigScsEsuBKq3BAbGJTZT5vWm5oPwQwltjpH5wh1hSw0Q1K8
         ieRQ==
X-Gm-Message-State: AOJu0Yz5DZ+wk1cPbvmQcKwMUWyLpyilEnFNjSzO9779gAGXiV8Govyc
	pKwJUrfEBBhGpO0smxKfxG25k5RoMIFp7M58so9Qx9s4gndh3P1VgV51lgJXA5IePnAR4wP2PF/
	o7Q==
X-Google-Smtp-Source: AGHT+IH1nm9H6ExpFEXT0KIxXL+/Lj6EKXREGQfM+XuqXkrbJCrWWVg1jMKKJtHx+aJKSsvrubC9asciPNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:88d1:0:b0:6ea:ad01:358f with SMTP id
 d2e1a72fcca58-6f4e03a9c5amr295714b3a.6.1715967606749; Fri, 17 May 2024
 10:40:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:49 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-13-seanjc@google.com>
Subject: [PATCH v2 12/49] KVM: x86: Reject disabling of MWAIT/HLT interception
 when not allowed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT or
HLT exits and KVM previously reported (via KVM_CHECK_EXTENSION) that
disabling the exit(s) is not allowed.  E.g. because MWAIT isn't supported
or the CPU doesn't have an aways-running APIC timer, or because KVM is
configured to mitigate cross-thread vulnerabilities.

Cc: Kechen Lu <kechenl@nvidia.com>
Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
Fixes: 6f0f2d5ef895 ("KVM: x86: Mitigate the cross-thread return address predictions bug")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 54 ++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cb0c150a2f8..c729227c6501 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4590,6 +4590,20 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
+
+	if (!mitigate_smt_rsb) {
+		r |= KVM_X86_DISABLE_EXITS_HLT |
+			KVM_X86_DISABLE_EXITS_CSTATE;
+
+		if (kvm_can_mwait_in_guest())
+			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+	}
+	return r;
+}
+
 #ifdef CONFIG_KVM_HYPERV
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
@@ -4726,15 +4740,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r = KVM_X86_DISABLE_EXITS_PAUSE;
-
-		if (!mitigate_smt_rsb) {
-			r |= KVM_X86_DISABLE_EXITS_HLT |
-			     KVM_X86_DISABLE_EXITS_CSTATE;
-
-			if (kvm_can_mwait_in_guest())
-				r |= KVM_X86_DISABLE_EXITS_MWAIT;
-		}
+		r |= kvm_get_allowed_disable_exits();
 		break;
 	case KVM_CAP_X86_SMM:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
@@ -6565,33 +6571,29 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
 			break;
 
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-
 #define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
 		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
 
-		if (!mitigate_smt_rsb) {
-			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
-			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
-				pr_warn_once(SMT_RSB_MSG);
-
-			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			    kvm_can_mwait_in_guest())
-				kvm->arch.mwait_in_guest = true;
-			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-				kvm->arch.hlt_in_guest = true;
-			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-				kvm->arch.cstate_in_guest = true;
-		}
+		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
+		    cpu_smt_possible() &&
+		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+			pr_warn_once(SMT_RSB_MSG);
 
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
+			kvm->arch.pause_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
+			kvm->arch.mwait_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
+			kvm->arch.hlt_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+			kvm->arch.cstate_in_guest = true;
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
-- 
2.45.0.215.g3402c0e53f-goog


