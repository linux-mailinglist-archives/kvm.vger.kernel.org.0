Return-Path: <kvm+bounces-48062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 378F0AC8549
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A0E3AFE49
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC75726AAAA;
	Thu, 29 May 2025 23:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zh6fn9cu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424F126A087
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562063; cv=none; b=JmgpmR9q3tQKAZhMITq9X+FVCDg02WivXIbPLDiy7NVS0+DeaRYSkPpThkR7tJg75EU7uB1bKZKsU8050bmJ3caH7N9YQ57sTXV5iblfcE7wK9yL7XVFz7aSrQavkAB+krK7jeFLtD0zJXCKTiZ3XM5MrbAhbDcziQWnXmxzWtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562063; c=relaxed/simple;
	bh=uAvpkJ1kh9zyVF8zsh87KKvNUaHxXqBUn9OHKPL2zxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KuHoKuPRbHjkc+daKNPPxJqWJwLGJWP5tjvVXftQQ1M2UuWCjTAJvtim9JDo7vPJkNTXiPfC6juS1M/EhG6xM1WQ4XFtAu5PNa48S619K+//63+q++VxHA+um3suREKrKh4xWtxb+t/1teUPNBNqUZfpst0051PAbnuJZXOXznY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zh6fn9cu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so1612941a12.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562061; x=1749166861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tbq754Ngub1Qv1FsclXkkiEsExVwCE+OzSUyYEWmCng=;
        b=Zh6fn9cucIS1hJrs3BlYoAlDSJYk5fFFXnw3ncJlIUUlpskoX96vwt0tYqipovwbp1
         //OxisYaPRRrBqFfFx5vKtA/DnHZ6dpWLxhy/seIIXIMAwMdtlh6Q6pT6K+uRTBGYOel
         Ldg+iUAPsnj62jwYktexEGnbDQtcnNaDaYDx/0FoEyP8cJiMOvnJ7wH5dCqHFGxxMA3/
         Et84y0hsUCDLE8pR8MT45Uve85Hyo0WdVtXcO/PRBgAnvHSJ5Yvz6cQ3SGuNuC2wrt1n
         zojejrZzc5YBl/Xk0CzJQVGH13neoBmtoJXWqjltWppt3ki7c1fBnOfN2GcQmxKkS6ff
         U7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562061; x=1749166861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tbq754Ngub1Qv1FsclXkkiEsExVwCE+OzSUyYEWmCng=;
        b=E/fWD/hjF338Q0WlUONe9QwJmr8cCKz1CfmDYCqqZ7iuTrrn8wDON5S4bvoIxaIzZ9
         n+xIXVMHNAqgmk7Af5khDZ6FdOleHsLOCdIaMih5TCZDG1UgLNAwTejg7AtfuGGIr0iQ
         lPMu2PmcQc+spM2+lO3XrpEXF+tOb/aGn6zjzfsKRw/x+gj6pODAi9iDzTmhG/XZSrwd
         jAwS5loscxpirTt+axI2vBYboHRQuqJtt1qQfPit2c0cS7RPQZqyyZoF9+VtcuxJSIUE
         52P40vvUz8TANz0TZ5hlfklDF7/MNOcp4O7CFGvBoTLmTiQnoinqFS/09hWglxfgCJ1b
         kMSw==
X-Gm-Message-State: AOJu0YwnUquR1LfeBkgrEJG1uy/GzIq2+haUl7SFVJ337wkgW5ZnKNED
	s3oFoQpoQEe6DB8uGTKkY3JiIQWOImxC9/2jKuFwFcRewld/hau2PC1rFtYckfdyIz84u1PLUyt
	7g5AMEg==
X-Google-Smtp-Source: AGHT+IHsxkwYTOeBBNW9rzUAUGeHbr0ESRWe2CQWLtpJV7+H9jhCssfj6CJS4wpx0wj5vMu8jxd8n2ceNv4=
X-Received: from pfbgd11.prod.google.com ([2002:a05:6a00:830b:b0:736:47b8:9b88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e8c:b0:204:4573:d856
 with SMTP id adf61e73a8af0-21adff4c279mr304380637.4.1748562061484; Thu, 29
 May 2025 16:41:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:11 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-27-seanjc@google.com>
Subject: [PATCH 26/28] KVM: SVM: Return -EINVAL instead of MSR_INVALID to
 signal out-of-range MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Return -EINVAL instead of MSR_INVALID from svm_msrpm_offset() to indicate
that the MSR isn't covered by one of the (currently) three MSRPM ranges,
and delete the MSR_INVALID macro now that all users are gone.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 14 +++++++-------
 arch/x86/kvm/svm/svm.h    |  2 --
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a4e98ada732b..60f62cddd291 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -191,14 +191,14 @@ static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 	case SVM_MSRPM_FIRST_MSR(range_nr) ... SVM_MSRPM_LAST_MSR(range_nr):	\
 		return SVM_MSRPM_BYTE_NR(range_nr, msr);
 
-static u32 svm_msrpm_offset(u32 msr)
+static int svm_msrpm_offset(u32 msr)
 {
 	switch (msr) {
 	SVM_BUILD_MSR_BYTE_NR_CASE(0, msr)
 	SVM_BUILD_MSR_BYTE_NR_CASE(1, msr)
 	SVM_BUILD_MSR_BYTE_NR_CASE(2, msr)
 	default:
-		return MSR_INVALID;
+		return -EINVAL;
 	}
 }
 
@@ -228,9 +228,9 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 	int i, j;
 
 	for (i = 0; i < ARRAY_SIZE(merge_msrs); i++) {
-		u32 offset = svm_msrpm_offset(merge_msrs[i]);
+		int offset = svm_msrpm_offset(merge_msrs[i]);
 
-		if (WARN_ON(offset == MSR_INVALID))
+		if (WARN_ON(offset < 0))
 			return -EIO;
 
 		/*
@@ -1357,9 +1357,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
-	u32 offset, msr;
-	int write;
+	int offset, write;
 	u8 value;
+	u32 msr;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
@@ -1368,7 +1368,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	offset = svm_msrpm_offset(msr);
 	write  = svm->vmcb->control.exit_info_1 & 1;
 
-	if (offset == MSR_INVALID)
+	if (offset < 0)
 		return NESTED_EXIT_DONE;
 
 	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 155b6089fcd2..27c722fd766e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -677,8 +677,6 @@ BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 
-#define MSR_INVALID				0xffffffffU
-
 #define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
 /* svm.c */
-- 
2.49.0.1204.g71687c7c1d-goog


