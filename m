Return-Path: <kvm+bounces-68849-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNreDj2wcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68849-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:06:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6DF61E54
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 14C2B5475F8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BE147AF61;
	Thu, 22 Jan 2026 04:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LDPXKL3N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA17478863
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057888; cv=none; b=tugXPyJvXrVVtV3pPUIxKAB7T+NRrcKmPf2Y+Jd/mBsa8uz94ga3I+Lxqdx/kCOdCZP055GfM8eV0fg+C5ZgJsrn1xcrgrCtj2cytb279Zg7TAJSiOZARsLWZXWFB8JPLDYzjndrJXAlQv4MBL1/ffp6kKM9/nlphw3iFss/Aps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057888; c=relaxed/simple;
	bh=waNza6ufOseXNYdZ4iVFICGFrkhQuOPflJIt8OcW/0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cWBSsVwFfGDSB6FEjKpUkB0QzhmQU7iWxiYetokFtRUKnXXQnJPy+jTl4PTtmlozKjTy/Oz/zsEjaDUOasQn/gPjcziiq2lZ3pPvp0VElJRRacnTnmOLPPUrnlx7haGWZVh3pLvaF+NbjetGol7bhL/e6ysyqPRfx6Ms+ex6Oos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LDPXKL3N; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a58c1c74a3so5932865ad.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057885; x=1769662685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jbL906JuFTdICHTDLle0kX3rDHil0lzZwr4G0LAGmzw=;
        b=LDPXKL3NVpfE+kjiFf7KbIULy8I/3vpp+3AJA2oIrOVUx2tKhw7MGFENuZqKLAN8Vs
         wttmVLGOqR4kZNxqQei7wSbSJlIWiim3Eis9sgH0URu8PMfKwE4puvoCyDVbVtwQaV70
         0KOl/kWWifa9hwjfefVdcPwJZZOCnZBUvNWUUdVEy5zS8nZY5bKGxaqRXTdhjMKSsnS3
         RhKZtgZBk+dlUXZ7l6i9oRZUy1g9zQOcsR6KHJqUl1rX+HwdFNulSguoWGbKu/8nXeeQ
         ObW2C6lZiKcXiFvmJhXB1jvrOarD1SibV3r2kwrvoPHLu9EeAdAXBXZMXr7XkA9mCm3F
         WSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057885; x=1769662685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbL906JuFTdICHTDLle0kX3rDHil0lzZwr4G0LAGmzw=;
        b=ZyNhbki6oaXs0t3sKiFLDWRHCxoPB0YaH2OK/siYUEbcFhVulf1QRpKASSVjtBshlR
         +WdHE1X3HwbK4NPZSMTuOa2BWAg6vHA5/oDeu/dpvLTTCH8k7eqBNQERA8fjPp8vUq7N
         hn0XX557XH7MzDbZxgC6vmBmUHVSE62VSY5R18YcYeB6Kq7eRnK8iPRh4kzJBg1gVCPL
         b39rZ8amU2hT8k3A0Q/hjUyBxgFHyStFfMOb+2jQpLUXGqCwqIdTQVxG+a516tLrlkz3
         QMZggkAFyJettkVsGoRYz2VhOk2XwZ4+tq83Cws+z5FR29NmFzACxb557SegfYUO5va2
         eQYw==
X-Gm-Message-State: AOJu0YwW1k+dq8AQUZhMdRbZXUfl4d+nq6RcAJGuVND0gPm5265Di/0c
	Xffz02ms+7moI6pmUD55AR5bJGugIOT85XhpZvPI5JYdGigT79hyEbTx44NSKJyx66MGlK3bkUt
	X9gRY12VAty4lCQ==
X-Received: from pgbl12.prod.google.com ([2002:a63:570c:0:b0:bac:a20:5eeb])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:83:b0:35f:aa1b:bbfb with SMTP id adf61e73a8af0-38e00d1b9edmr18459118637.50.1769057885381;
 Wed, 21 Jan 2026 20:58:05 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:54 +0000
In-Reply-To: <20260122045755.205203-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-6-chengkev@google.com>
Subject: [PATCH V3 5/5] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>, Manali Shukla <manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68849-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,linux.dev:email,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: AF6DF61E54
X-Rspamd-Action: no action

The AMD APM states that if VMMCALL instruction is not intercepted, the
instruction raises a #UD exception.

Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
from L2 is being handled by L0, which means that L1 did not intercept
the VMMCALL instruction.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Manali Shukla <manali.shukla@amd.com>
Tested-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1888211e20988..9257976ded539 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3194,6 +3194,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
+	 * and only if the VMMCALL intercept is not set in vmcb12.
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
@@ -3244,7 +3258,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
-- 
2.52.0.457.g6b5491de43-goog


