Return-Path: <kvm+bounces-67093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E0ACF6A4E
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 18718300923E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560D827F724;
	Tue,  6 Jan 2026 04:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yhpbmgfU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255E27CB04
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767672781; cv=none; b=XQTDeIQNToKAzi2iFhzlFoW0dbxOkqZyZAyjh/jCHM7JPDGS6H5Q4Z25jQJx5MPrKFu/eAYCp7LN+w0B275gQCzFu+Czc/20bzHODEmh/oKMWzQlBaIqhKrJEHcsl9gJNdVhayS5CAIeP9behDoNiI9YY8TGwKFR132xpsQz0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767672781; c=relaxed/simple;
	bh=JAlAEtdbo80N7OYe4Cu0PS/PpFRLFX2PISvANkzvpeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iNBOJ3gtjWWCZFAZF99oI8ByscfTARSbnWLvbC4+fUxSwogajHvmJSZq0piJUnxThHSEa8rJ1XL86S1L2cES6AOtXGOFNELYJ8+u6PZh4Ij54zZHVJnAIm3zrn3ZZHFqtUGpap5oChusPPP7sRQ2lXgg4o4NEpebv5jhTbbt1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yhpbmgfU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34aa6655510so808817a91.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 20:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767672779; x=1768277579; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LH3hLDiZ3ov0lC1gcsWvC0RzXwXYlG/q9OQvvLs1Xs=;
        b=yhpbmgfUsqKvXbPlnBshw1dOVVj/BvWP2Cg69fM3fyqhdfln+9UoEHkl1l+A1/p0CO
         ys12fLjbCAYoZy0QQTDC9ssrnQTKZwgDTlPFe4xwhgMTkdBgHsfhAJ8th6cJnElRJloh
         G98IYlf3ak99wQ4YNrwYGGlhbcmz0O4fQE/H8yokgobVIFb1zD5soWWPXl7yVgPvQMo9
         0qfuuSBpv2uF2vp7IPHNiBjxxmAlSN3miwYTjMChxGiCFKyj0OKZ5qqWypgBM/IbgsbH
         nF/p9NY/qnDKlyn0vH87b1WfQ4xAtKyaRd+F+3m4mQszzGB/spX1/2qgZDdveak8ihUj
         URhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767672779; x=1768277579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LH3hLDiZ3ov0lC1gcsWvC0RzXwXYlG/q9OQvvLs1Xs=;
        b=mvyqnmvGwb6llSUWOVeU4ypZw7And9T4HbAKcGqaKplt0z6qHG3hBDaPMveRQFa5Vo
         F2ZYAFMDDhbRSFA5rRoJwOfQHgsoZq49W6of4ZAjAVcZvRBpDxmYMDL26O9Di0b7lJv3
         ZX3A+PjKyOsY3arL61iZWWZ5CHgOGSmZG8/WK/X86q/hSI6LQQB1L9KKZXdXAGBzXNwX
         EpdO0DdLzFQcJ2pKXWLW042UwCI+buefFprN/PUd51lA/Aeg4eqA3I79OSnk+BzSlRgx
         du/9XcVZP/n4WGw9B4A/46RMW4BkImmjLRdN0+thl8DDzMht6sl5D5lRMaJyfiAH2Sc7
         kqWQ==
X-Gm-Message-State: AOJu0YwuiW0RhEFtlJzyOm6Xt0WN+Neul0/BBqDcPRn35vPtrrgE2+Pd
	HFPwfaWwcxFkALk1PSWHHhdtKmiy6/njQGj+MmpCAeAgntUIVrul1xw+54P8NtHT4banHJoPTYJ
	GmbQt/DkUUopwTA==
X-Google-Smtp-Source: AGHT+IHcPJlLz/huni8seshB7udOPPqBmPg7WhGHOUJcqy2MpxEI82MXE0JD6sf8Tn4XFXiVjrrbfZ56BlB5Dg==
X-Received: from pjbrs7.prod.google.com ([2002:a17:90b:2b87:b0:34a:bebf:c162])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1f82:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-34f5f32c3ffmr1274852a91.26.1767672779370;
 Mon, 05 Jan 2026 20:12:59 -0800 (PST)
Date: Tue,  6 Jan 2026 04:12:50 +0000
In-Reply-To: <20260106041250.2125920-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106041250.2125920-3-chengkev@google.com>
Subject: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD APM states that if VMMCALL instruction is not intercepted, the
instruction raises a #UD exception.

Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
from L2 is being handled by L0, which means that L1 did not intercept
the VMMCALL instruction.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc1b8707bb00c..482495ad72d22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3179,6 +3179,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If VMMCALL from L2 is not intercepted by L1, the instruction raises a
+	 * #UD exception
+	 */
+	if (is_guest_mode(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_emulate_hypercall(vcpu);
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3229,7 +3243,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
-- 
2.52.0.351.gbe84eed79e-goog


