Return-Path: <kvm+bounces-62360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 360FDC418C0
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01CF188952D
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C34334690;
	Fri,  7 Nov 2025 20:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MDvGG+tF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14D3093DF
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546326; cv=none; b=sZVrTDwpL07jBt8+0BEbRBUfy+576S5zCFoBc8dBgAgQjOEOAX7rj9TqgWdZeQbnLapiP4pqF41O+CRxF5UUkTiAVVWZzeBYgHW7vm6rLt25h1U0bvjvSwXyhPP8kLY3d8Om7LNjKnrJWS/elppWAe+zbYDAg7wjmE8xhA1XCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546326; c=relaxed/simple;
	bh=s0aUXhsTFzfk1DYtsdr82lS54IECwej4kn2Gtennk5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O8S3vr50f8/Q7XYeV6cN56STb5lUvlq0uJKP2nDo35ih2msyvLHiuIXH5xlcsHsWSQWcNkqnHJqXGxPwp1sTcfYbctUH6d0mkZguJeCcxzbwCDjSux+zXHgsmnZiqOhMpXQbgIBRi6A0SSlABvGVyp4reesTCt8yUdT/r9LimB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MDvGG+tF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a9fb6fcc78so997632b3a.3
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546324; x=1763151124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CY264xw56ZDC82FBQPjZ1NQ2YNykk6EQ4FAudA0Gbzg=;
        b=MDvGG+tFYQD2VQ9SAXQ2PmE9IJ5NY/imxKkt1WLgH1VApkHFJthlYwTffC8kRB/PV5
         XZA6sAwTqNH3wg2ioim8LAnTeUtc0i6tt70D/HKIH6kTbKcP57bqV/g7tmLxvI788wg1
         6P/2uTLGL03TlLOCp0wWTebkm4iZ8IWTd7PPXyOnzMMJqSbfzZZfi1FMC22CMEwlUzbw
         LpFYRddzqorV+9dqSFef4cjmulqXY0qf48a1cmMWzXzzxZymvP1kv+aUwut/pC20NaP5
         EJOgJkeQeuwpvn/ziCFaLfWdzISaIvW9pmvntg6P/MKkc998GgJDBWlMsiZcC7NfiDv1
         9mJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546324; x=1763151124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CY264xw56ZDC82FBQPjZ1NQ2YNykk6EQ4FAudA0Gbzg=;
        b=YAi9DdR3fiMR6DT0VX4uxWErGzoSqgZxkZg+fARDmNVOIjuueafSnurEcEqVDKYTrv
         W9pMIjCjTrr+YTeVrfX30FaY7iyGs5q9SB+FrQ3w3p1IYoSRSYhWxPjewvztYDciRDpH
         RE/47bE8GMKoj3aoNgEmp6sGbwyJ0rKxaiCKKdlVIOFfSNvPpsGvLiWC0zd1K9jKrq9+
         kSgjTyFZFq1rFX5nFdlhety7pSCkQuaOXFKvz7ztDZ3Yoefiiiw1WHtNvHCqMdzixvyn
         o5/7CFzUCtlbbIeB9TXPLj1/SE1+VplkY1kzxjcZl+5aOCqmYz9mIkwq+ca1ZLj1cNUC
         7PEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKlMP1NBzzSQfW8vZuqO3X6l2HbsEMqGLo5dUjirwI/raK68KPJEJz/O4ApFS7iJK4O+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoeWbyyoPF5ggyyyPu3pC3zBrUgSYD1Eei6sFLYHpdqi5NWGur
	PyQnFCLdXECJRuQO8RiEU4oVusPsM+PUW3mml5cGXNwdCm01yet9Ss/Svkjd3SC0f7UFs4TlRMG
	eXxCdF1jFMrkTtw==
X-Google-Smtp-Source: AGHT+IGJkeAiHWSbfAqAmbrJhJXI8l2dLLx+G2d5KdfR6vlYzKFWd4yJEYIk6DV9zBrXVdkdiXsmyfy5904hwA==
X-Received: from pfes7.prod.google.com ([2002:aa7:8d47:0:b0:7ae:ad77:dfcd])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1a8f:b0:772:3b9d:70fb with SMTP id d2e1a72fcca58-7b22718089dmr646594b3a.31.1762546323829;
 Fri, 07 Nov 2025 12:12:03 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:27 -0800
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107201151.3303170-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-5-jmattson@google.com>
Subject: [RFC PATCH 4/6] KVM: x86: nSVM: Cache g_pat in vmcb_ctrl_area_cached
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a g_pat field to the vmcb_ctrl_area_cached struct for caching the
VMCB12 g_pat at emulated VMRUN. This is a preliminary step to allow
for proper validation and handling of the VMCB12 g_pat when nested
paging is enabled in VMCB12.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 51a89d6aa29f..6e48572e2bd7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -984,6 +984,12 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+	/*
+	 * To facilitate independent validation of the cached state
+	 * save area and the cached control area, we cache the vmcb12
+	 * g_pat with the cached controls.
+	 */
+	svm->nested.ctl.g_pat = vmcb12->save.g_pat;
 
 	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu)) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e4b04f435b3d..c91e20aa3ec2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -176,6 +176,7 @@ struct vmcb_ctrl_area_cached {
 	u64 virt_ext;
 	u32 clean;
 	u64 bus_lock_rip;
+	u64 g_pat;
 	union {
 #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_KVM_HYPERV)
 		struct hv_vmcb_enlightenments hv_enlightenments;
-- 
2.51.2.1041.gc1ab5b90ca-goog


