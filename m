Return-Path: <kvm+bounces-68846-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBnVGe+vcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68846-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:04:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 328FC61E34
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B002B545B4A
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773E142980E;
	Thu, 22 Jan 2026 04:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MfX7BzmK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA3646AF3F
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057883; cv=none; b=pW2o/Sl0Nhhd2wINBFGAabZCVWYXNg8RNL2Gie2llR90dJ9jqaDLRxPsQoQ1HMrC9Wz2jTz9veACyLGPUZRTWd2XUuwBQHtdxtY2BMRSNvyyk/5SPo57yNwVMd0xUsb5A/P336gu+lMgVxgosMNUUnAsnyV3AqN8CzWgCnm4YXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057883; c=relaxed/simple;
	bh=9zQZI3WlU6jPhXYD2z6AcxtaZlWBL61afEB7pez8jtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mNxgavirmXxOzr72tl8UTEVHZG2YHDu+5Pxozfz70seQrVj4nrW37YUX4I+6+rD3cdG290WDcTy89FvOxG3hakwG+W/0O8eZuz5+aQEWJg45DeT3qFf3vLIZK8Yv9PSC0bq70efAgXUfGffSpGW2pYLzFhv/QpD2GsDc7QEdYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MfX7BzmK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f53295ac2so1404744b3a.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057881; x=1769662681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=13hBXw1e/wQdlND4nbuAHkzt9/+Bh7eimLwFf/NzxYc=;
        b=MfX7BzmK+PksPp+/3yufZXuRDa6AIqDtlT+NSaq+pKVikI0qulCnfgSg6SmAJtluqz
         43lRs+k1P+sLCUK7/Ym9CY92IMCAw3g0M6FjkVgnH1cVo9Hfba4LDqqXWekaiIBnctN8
         FZdfIjgrxVd7VXl3Qv82ZkG37zqrq0/RxbJ9eIb8+8trwQOD9brZAueRv3VL9Lip+fhi
         nm8s5OCYSKdpRJmHY/PpxoOvaPtgoBnAn4j9veZZbpDrApSNIyTgsW4Zw5CV5QBFalsY
         lw0T2eoaHPkm5n/ycM78u/5lShs5373Odtl23adHLLpUwUHlowvuR/xgErq8AwQwyqrt
         v3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057881; x=1769662681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13hBXw1e/wQdlND4nbuAHkzt9/+Bh7eimLwFf/NzxYc=;
        b=tD1gfU4EdfYIjBrTpiaP90SLs/vj5+6YEgFE42TGPvyd0s6Zr/+dKe7qDtFhrq8tdX
         Pm/Nx6Jz9zRzBKy8jqwtX5HzPi6qwJpXb9boA8+jDKk/ktA4MIU6D0JGr0tGGs/+MBLA
         DBFlOjkRdzboVMiyBQ96P204W4AgOUBgkHhHsmYM58rxJ3E7ABM/x/FxB9DL1LtRn8zS
         Cts2H3EQq8v4RZr1mUJeigA855DJXSOAVmsGO96NRlCand6deJPUNtcK/doMpatcEDct
         cwr54t9XXbhRBPzYbucRNYdujIx1cF54yxj2drLPTT/EHCdS2vUINEoXyqOWaxpu9lo6
         MW4g==
X-Gm-Message-State: AOJu0YzkloQEEQ3FqIyt0PpjHuWzK4DLfuIoQv/yn3L6XZOHiVoTT05d
	aJXpk10GI2oHqOrQko+CuJL9rqC6RLlMk2d1wIn2h6rRkPpnTfEV7vpyZD/SwOtk3gnqoS8B+qI
	n3Y8spoWsf8G0Mg==
X-Received: from pfaw7.prod.google.com ([2002:a05:6a00:ab87:b0:7e5:5121:f943])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d8b:b0:81f:3461:9f78 with SMTP id d2e1a72fcca58-81fa185061fmr17024231b3a.48.1769057880741;
 Wed, 21 Jan 2026 20:58:00 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:51 +0000
In-Reply-To: <20260122045755.205203-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-3-chengkev@google.com>
Subject: [PATCH V3 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM
 Lock and DEV are not available
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68846-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 328FC61E34
X-Rspamd-Action: no action

The AMD APM states that STGI causes a #UD if SVM is not enabled and
neither SVM Lock nor the device exclusion vector (DEV) are supported.
Support for DEV is part of the SKINIT architecture. Fix the STGI exit
handler by injecting #UD when these conditions are met.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/nested.c |  9 +++++++--
 arch/x86/kvm/svm/svm.c    | 12 +++++++++++-
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372b..60bb320c34bda 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1466,9 +1466,9 @@ int nested_svm_exit_handled(struct vcpu_svm *svm)
 	return vmexit;
 }
 
-int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
+int __nested_svm_check_permissions(struct kvm_vcpu *vcpu, bool insn_allowed)
 {
-	if (!(vcpu->arch.efer & EFER_SVME) || !is_paging(vcpu)) {
+	if (!insn_allowed || !is_paging(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -1481,6 +1481,11 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
+{
+	return __nested_svm_check_permissions(vcpu, vcpu->arch.efer & EFER_SVME);
+}
+
 static bool nested_svm_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
 					   u32 error_code)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7a854e81b6560..e6b1f8fa98a20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2283,9 +2283,19 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 
 static int stgi_interception(struct kvm_vcpu *vcpu)
 {
+	bool insn_allowed;
 	int ret;
 
-	if (nested_svm_check_permissions(vcpu))
+	/*
+	 * According to the APM, STGI is allowed even with SVM disabled if SVM
+	 * Lock or device exclusion vector (DEV) are supported. DEV is part of
+	 * the SKINIT architecture.
+	 */
+	insn_allowed = (vcpu->arch.efer & EFER_SVME) ||
+		       guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) ||
+		       guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT);
+
+	if (__nested_svm_check_permissions(vcpu, insn_allowed))
 		return 1;
 
 	ret = kvm_skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d077..0ec09559767a3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -769,6 +769,7 @@ static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 }
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);
+int __nested_svm_check_permissions(struct kvm_vcpu *vcpu, bool insn_allowed);
 int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
-- 
2.52.0.457.g6b5491de43-goog


