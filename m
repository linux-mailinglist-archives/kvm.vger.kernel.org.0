Return-Path: <kvm+bounces-39036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E203A42AD5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B19A61779E8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7902661BA;
	Mon, 24 Feb 2025 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L2wUpFga"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F3265CC9
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420804; cv=none; b=NU7WL4vmsS86kbU3MO0L64sw2YXq7YiDGWQmKz9xQ65oifnTXRIi3slBx0ldqC0m2XEuVzqks0M7OnnPFF0nTpTtQs94O3KYpb0cVB6Jg+91VHAmmpfQEl1LeOmMz+HMyEYw5EqAYtSmjyjvE0o8P4ry8WIa8cIJbjYXVCQahZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420804; c=relaxed/simple;
	bh=Chqd3phLcy2hAWvY1UXFVhCZpvMnwC8AQtxFWIuQrRA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cLSw76SQQ5fTZbm94RwoBfgGLKgvOXwCssGi11YF9oTD8oOBywNUQD4vSmhL8IHs1PRdMDXO/OYMK8st9y6M4eUCPQO5BNF+QGsj07Or1UdBWC4jvQ+vgfjgtl4x/ZLLzIiWdZAV7GglxgQmdeCSDr0nPqNSYfBH+R8fz2w9HH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L2wUpFga; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fbfa786a1aso15356277a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740420802; x=1741025602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iMoEw2TCR/jsf9eyPYGtk4uQ2XLZ2x5LTJoq82YfUM8=;
        b=L2wUpFgaNLioPXQCdv2uWhdv63LaQER15emZhdOc0Ij1428uvCmePIfPDLN2EmPWqS
         XhFP7sfZQopXcWt22njvf/b6yF58hbFk7wqJlqMrajxgRbJh3iIIPuvhYpR5l4ejy0ks
         uqkkfaaqh9Z4x1UDtSshK83nLjc/fO0ODXzpGRhdkGIaV/ZYNPv5C+W1xcTHCSg7dWyI
         Dn28MHt8rIp2vFd9UKcEQ/exo8GsmDu/YilhuDxahQDbcCHMCGZPxD3Tfu+iLV9RsLUu
         ei8MFg99x6auFuYlEkJ9rRFOqNYm4bQV4WVCGeFo3MmlHbCCeoMGpZDo8eGudCVIHQtD
         CBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740420802; x=1741025602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMoEw2TCR/jsf9eyPYGtk4uQ2XLZ2x5LTJoq82YfUM8=;
        b=N/odxudWURxGNInntWtga4OUZvqtdFXT9H8g8oSq9ywx2bAH4+p3emTap7hVjdD5Wo
         jTK+0b3o4szBwKiW1UkgtX77vD6+8JyES5kre+cjZGJORBG5MZElV3xZerOUvxGmAC56
         ZQn2a6VWH4t0kYpAjIcHBI11ih7WjRTFg/JG7HrOKgxWb9cM4uxDsPgBQKk4qmlum5GT
         42Y/O4njCxg31yO1u/44gQxw/tNgKV9fjBBsIQHwhQjk2OGpVjrgzglAkia96RGiG9OL
         C4ZOZDFblXJocU5g++vDfLUJ2QlZ6O/6k/6MlD/ZIkA3Jn6KoAkKZYzhKX2wfYZQhj8L
         BfWg==
X-Gm-Message-State: AOJu0YwrD9feed1Rgga2ujDGBo6G8cfp/jgNyscGzDhShhCG9ZIRCJIC
	+dV57D4M3y9aj555Z5mf7d5hBP9yVgiulCPdNBuM7FDqJqaHGBMBMmrBars7UmSd1S4pcGOo5IJ
	eUg==
X-Google-Smtp-Source: AGHT+IGSIS9bceyurPPbtSnVKs/aKbjpXnz1oxcEFb9JiCN90lWjLNGNlYKKZ+JFk+uet8XnEKZWwcnTVY0=
X-Received: from pfjc10.prod.google.com ([2002:a05:6a00:8a:b0:730:8de5:1c16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a93:b0:1ee:e0c0:85a8
 with SMTP id adf61e73a8af0-1f0fc139c4fmr34437637.15.1740420802145; Mon, 24
 Feb 2025 10:13:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 10:13:14 -0800
In-Reply-To: <20250224181315.2376869-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224181315.2376869-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224181315.2376869-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: SVM: Manually zero/restore DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rangemachine@gmail.com, 
	whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Manually zero DEBUGCTL prior to VMRUN if the host's value is non-zero and
LBR virtualization is disabled, as hardware only context switches DEBUGCTL
if LBR virtualization is fully enabled.  Running the guest with the host's
value has likely been mildly problematic for quite some time, e.g. it will
result in undesirable behavior if host is running with BTF=1.

But the bug became fatal with the introduction of Bus Lock Trap ("Detect"
in kernel paralance) support for AMD (commit 408eb7417a92
("x86/bus_lock: Add support for AMD")), as a bus lock in the guest will
trigger an unexpected #DB.

Note, suppressing the bus lock #DB, i.e. simply resuming the guest without
injecting a #DB, is not an option.  It wouldn't address the general issue
with DEBUGCTL, e.g. for things like BTF, and there are other guest-visible
side effects if BusLockTrap is left enabled.

If BusLockTrap is disabled, then DR6.BLD is reserved-to-1; any attempts to
clear it by software are ignored.  But if BusLockTrap is enabled, software
can clear DR6.BLD:

  Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2)
  to 1.  When bus lock trap is enabled, ... The processor indicates that
  this #DB was caused by a bus lock by clearing DR6[BLD] (bit 11).  DR6[11]
  previously had been defined to be always 1.

and clearing DR6.BLD is "sticky" in that it's not set (i.e. lowered) by
other #DBs:

  All other #DB exceptions leave DR6[BLD] unmodified

E.g. leaving BusLockTrap enable can confuse a legacy guest that writes '0'
to reset DR6.

Reported-by: rangemachine@gmail.com
Reported-by: whanos@sergal.fun
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219787
Closes: https://lore.kernel.org/all/bug-219787-28872@https.bugzilla.kernel.org%2F
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8aa0f36850f..d5519e592cb3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4253,6 +4253,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	/*
+	 * Hardware only context switches DEBUGCTL if LBR virtualization is
+	 * enabled.  Manually zero DEBUGCTL if necessary (and restore it after
+	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
+	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
+	 */
+	if (vcpu->arch.host_debugctl &&
+	    !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK))
+		update_debugctlmsr(0);
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/*
@@ -4280,6 +4290,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
+	if (vcpu->arch.host_debugctl &&
+	    !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK))
+		update_debugctlmsr(vcpu->arch.host_debugctl);
+
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
-- 
2.48.1.658.g4767266eb4-goog


