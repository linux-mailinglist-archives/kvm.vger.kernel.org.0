Return-Path: <kvm+bounces-71566-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6L1oKBn4nGlxMQQAu9opvQ
	(envelope-from <kvm+bounces-71566-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:00:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D310180627
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DC583101DCF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7461127E1DC;
	Tue, 24 Feb 2026 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P59LHSRL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5F25A2C6
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894526; cv=none; b=mnaCH6l2rLLE7NstlGjEqYrqh/K8zFtA2P2eCad6G6Fl+uB4rk4ARvL/smtjUlkw2IjIQyVEcsVMyhjR6NvF+sJHDcbKYJy+VEDaidLNqOCEumE3yuIFK/Xlb0SNqGdAkTqapRUTpoV2t4UMOOBaJft63ja3SOQrtH1rAMqBN94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894526; c=relaxed/simple;
	bh=dGfKpMcsKuI9NrO5UoOL8Z8WErizRM+WPY5uHc/kufY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9R5GsLu/Yap7O/yV4dEM6KSAUTXUhd0KrKGq5t4kRLrXqmdxNMT1qBrlVuj6LWTK3i+V5y38iI4QYItRAsO21kKRROyMMR9N+hOY4Z24TgSDMxgE+HlNFJxrqXn1gmfr3nUdOt8VRTVnqqqrMY3mivQ4d7AXNj0kX0XC9f4tDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P59LHSRL; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c61dee98720so2912798a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894521; x=1772499321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=73J77K9sCtPLLyG3an/3NM/PxhZrZVfK3xi/KqqIpdw=;
        b=P59LHSRLWVnqj8RbmW4Z8/AlMIag6x6mTzvIJWYm49vLEj3Qll32JOPx3LdMzNPb+9
         NZ9whuvXIQ9iE6fHj3cAhct3eDrZ3Kprs3rYgJs4DVraCLJxfd9+kPa6eDf3QQUC/lEq
         Mx96T6wP/gEs6qZsY8bWw8izkqBLc/xh01X8EhPWS8+B7b7NdrP/8Nd5ld4n0yIHzsoM
         5SsTMUM6fPm5UOf9x8lMxV5f9iFUlK9rm11kB2AGFRnd1GHSkaWcwNlhh62qakWSBo0T
         Um1hhgDyBoq3P4sQqO0d1vTaFeU5CHQJVoeYV3VhR8cpIfgGvaiSL7pR8ebJc8ieRj+8
         JQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894521; x=1772499321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73J77K9sCtPLLyG3an/3NM/PxhZrZVfK3xi/KqqIpdw=;
        b=Wxfp4L8RB+JiH4MvXF5N6OKNMp73bjgAfXPpAsxreSFKcG1S4jisIyS1v2A+eSxzmt
         QEOci+H4QGQmu++unfTcBKacNMiSwEdNyAkKqYWEUCnEKovaKwbipE8exRAyZgmhTme3
         1CSVdWg0+9qzrRxjx36e+R/mbuHYDOHe+gwL0b4FjUrATpixSycfILQ/WLfXQ59Wfz7t
         ZUGocdqZosTTo72HLeEOqKiXB7ETtRH5ya7PhyEbcBWLG5jolVivLBCNC0A0WxDjOAzt
         jc6SPNmd0meYV2F/pIhEdaCQsGBee983EtfYuRXuxaSVmy/DwpD7W4goZF+ncRjfZcck
         wfmA==
X-Forwarded-Encrypted: i=1; AJvYcCWOJ9HZDC1wqZEfV8KOUY/usYawnX+R9d0vlKUFh4TCsnwPJu0Dy++g3JORgFwlf3bBKTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP9L+KACcJTanpNxMXTyPa8mW6k7WISFHzqq0n6RQAPktndTRa
	gemo2uMq9dcLj0hgJkpOnGg+4UJm7f9H3LuKVsqrJwNEEk3kz5fhKMl9qCTCJXCi1MINr7sc8RK
	bFgBAf0pESe5Mpg==
X-Received: from pfbjt37.prod.google.com ([2002:a05:6a00:91e5:b0:7dd:8bba:63a2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:cc97:b0:361:63eb:d024 with SMTP id adf61e73a8af0-39545ebdc91mr9012480637.23.1771894520624;
 Mon, 23 Feb 2026 16:55:20 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:46 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-9-jmattson@google.com>
Subject: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71566-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D310180627
X-Rspamd-Action: no action

Add a 'flags' field to the SVM nested state header, and use bit 0 of the
flags to indicate that gPAT is stored in the nested state.

If in guest mode with NPT enabled, store the current vmcb->save.g_pat value
into the header of the nested state, and set the flag.

Note that struct kvm_svm_nested_state_hdr is included in a union padded to
120 bytes, so there is room to add the flags field and the gpat field
without changing any offsets.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/svm/nested.c       | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 846a63215ce1..664d04d1db3f 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -495,6 +495,8 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
+#define KVM_STATE_SVM_VALID_GPAT	0x00000001
+
 /* vendor-independent attributes for system fd (group 0) */
 #define KVM_X86_GRP_SYSTEM		0
 #  define KVM_X86_XCOMP_GUEST_SUPP	0
@@ -531,6 +533,9 @@ struct kvm_svm_nested_state_data {
 
 struct kvm_svm_nested_state_hdr {
 	__u64 vmcb_pa;
+	__u32 flags;
+	__u32 reserved;
+	__u64 gpat;
 };
 
 /* for KVM_CAP_NESTED_STATE */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 26f758e294ab..5a35277f2364 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1893,6 +1893,10 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
 		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
+		if (nested_npt_enabled(svm)) {
+			kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
+			kvm_state.hdr.svm.gpat = svm->vmcb->save.g_pat;
+		}
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
@@ -2022,6 +2026,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	    !nested_vmcb_check_save(vcpu, &save_cached, false))
 		goto out_free;
 
+	/*
+	 * Validate gPAT, if provided. This is done separately from the
+	 * vmcb_save_area_cached validation above, because gPAT is L2
+	 * state, but the vmcb_save_area_cached is populated with L1 state.
+	 */
+	if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
+	    !kvm_pat_valid(kvm_state->hdr.svm.gpat))
+		goto out_free;
 
 	/*
 	 * All checks done, we can enter guest mode. Userspace provides
@@ -2062,6 +2074,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+
+	if (nested_npt_enabled(svm) &&
+	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
+		vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
+
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
 	svm->nested.force_msr_bitmap_recalc = true;
-- 
2.53.0.371.g1d285c8824-goog


