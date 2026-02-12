Return-Path: <kvm+bounces-70993-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6FmiL035jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70993-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:01:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3108512F2E2
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3446A3164B93
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B4C35D5E3;
	Thu, 12 Feb 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="taYhWl0V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8779532FA18
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911958; cv=none; b=ifCoDGK4iIRVZtMEXPweYis4afoogZJ3MfE8OE82YMvDK8kC/oZzkOhwbNVWIuWJv+jcGgwj98W2PHv88uCwfSG7lfFA54oLShBxtbWR5wwhMNcP4Sg+egJacP1ZV356PQD8Hwgpuiem1HckGu/qWb4IrP/jm1ZQEoIhAT/uBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911958; c=relaxed/simple;
	bh=s4DygJeXL0KLLS5zyD1EU8BmPQvpE/qt7AMgOQ0hWEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpBs45eR3NJDByka6i3/hLxG+ADec1y0LJ9yechH3Yk9HlgO4K7DINfMip8vmqTcINOcaEYME3BAjytbwtK814b2YgHqk9hq8RluC18HtUCrrP4H5raY00Vadg25kuFaSTQIt1ceStudLHgXxQrVsAzwebsOPGRm/Gg8k9e205I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=taYhWl0V; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a92a3f5de9so22262115ad.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911957; x=1771516757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NXWGIZTswQvFKRAzrwUvmCg40y2DnJJnM3/XWRTJ8no=;
        b=taYhWl0VakB0+GWUKmGV5DQjC/DmSRoYMX3fcdswEOWsXo85OAOOeEuzw9x1nx7lhV
         z6QUtL2RtrTl5n1TbCjWO9juQn9hiLOLlUh7fE0eos6LYAxCkXy7dEBmjGG2o2kMADQi
         iTaJxSI3GxCSyvSt+gWRR79luHr1yPitmZwidq+2KmF97naRUEFMVJMYsmQHk09QL+kY
         dV2Eya9KLQiT7Et+pLS5R2L3tUZjdbJetRv3QKzhx+wwLXBRq2qPySCmFK+fNXv1jlzy
         yA1eYGC45t8YkIHRjN1DOklxmQ/zbQHCWLDoWBQ4v27dAdcr88uBXI57N5ls1c00xZjG
         IIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911957; x=1771516757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXWGIZTswQvFKRAzrwUvmCg40y2DnJJnM3/XWRTJ8no=;
        b=QivDs4UIC1oLoQmxPI06mDFlYtYTvZ6YJ1o0BLoXEiIvc3Qpjy/gWYnRTBuB40MtnD
         T/flg+DVdU8ZykL7f4/6bKOvq7CShciMZrKoBikDiUGQm0Smrcx9ozT/ncqjO4xkja3Z
         1RLBr/zSu/1KnoTrfCAff5a964Ncx2kt9VziBK4fHxZPRMXQuQvFI2YiSKiYwlSs8Eci
         nKBFNsyQhj4KytMEdShTnsBo8QxzwLQwSaISr7cTYKuRVsjZyfxTYHXYDw0QD2HcQIcn
         Hxg5/IXT9tjX4e0O8U+TDnTN3BVVDSKuTOkHheMGuPLaflaN6GEZeJNx4kjNxl0bHM3n
         uTOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHqjfKzHRXLNDQc71kXXgvzaXLgNDWaanqtK1hL/wISXDLwcetHaVgy1ExRHurro76Ph8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6kDjgLka3nL4WJv49tB4iPCIwjhPQl3eNRnXUZzxqJuY8VFZh
	d304aXiz2wMR5Ka0Mtce2Bf8RYIQtoS9qVo14lLsSK/lHcJHeB2xmq+77/Mlf2Z+NbuMNX+3Srt
	/7Rh3jD4O47DwIA==
X-Received: from plbje12.prod.google.com ([2002:a17:903:264c:b0:2ab:f1d:4446])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2d1:b0:2a9:602c:159 with SMTP id d9443c01a7336-2ab3b1a00c3mr29570985ad.19.1770911956923;
 Thu, 12 Feb 2026 07:59:16 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:51 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-4-jmattson@google.com>
Subject: [PATCH v4 3/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-70993-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3108512F2E2
X-Rspamd-Action: no action

When nested NPT is enabled in vmcb12, copy the (cached and validated)
vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
register lives in svm->nested.save.g_pat.

When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.

When NPT is disabled, the g_pat field is ignored by hardware.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 91b35adb83f8..dc8275837120 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -724,9 +724,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	nested_vmcb02_compute_g_pat(svm);
-	vmcb_mark_dirty(vmcb02, VMCB_NPT);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -757,6 +754,13 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 		vmcb_mark_dirty(vmcb02, VMCB_CET);
 	}
 
+	if (nested_npt_enabled(svm)) {
+		if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_NPT)))
+			vmcb_set_gpat(vmcb02, svm->nested.save.g_pat);
+	} else if (npt_enabled) {
+		vmcb_set_gpat(vmcb02, vcpu->arch.pat);
+	}
+
 	kvm_set_rflags(vcpu, save->rflags | X86_EFLAGS_FIXED);
 
 	svm_set_efer(vcpu, svm->nested.save.efer);
-- 
2.53.0.239.g8d8fc8a987-goog


