Return-Path: <kvm+bounces-70370-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QI/fMqYPhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70370-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:46:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD68F7D93
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 847103019A30
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF523382DE;
	Thu,  5 Feb 2026 21:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VrkP8LCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15471337B99
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327827; cv=none; b=cXJkSOVGgza6O6j+6UA9rnawQ1Dn0pwmUmLAe6r+QwxskPF8pF4yxwacCCwNvZ2FiTifXus4ymz402iEkQZLnSRcbQrR4GzlcH0K535eJNUGrUO11VSvRIZ+h/oeeQ4xF1J5RjNyATV009mXV8GZrw2Bp1SyYCuO5S4rF8zBJ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327827; c=relaxed/simple;
	bh=REMk7MsNEK46ltVnyaD2qUn2Wq3i1H3LHfd2I6/ePAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mTRnE97wWilao3kREI4OhqSSpiIHuLJ0ftjHWMiwAn8Qj0sh8tiG+v/PqSG7Srg7MgFp2WKvMIUw51QK7VPnFvK8+LgyTVAgSBDJhCIpOC39uuLUBjF+bOawgXbVJxN09MDCQKr5Rkts55ZZwRler1YwaHJuo77/ZvYxnLYzCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VrkP8LCG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c56848e6f53so819674a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327826; x=1770932626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4KbIplwSpOgL8y77jJIQF/6UFPYYOp7aggt19vghWY=;
        b=VrkP8LCG4GKYYzkmPlZ9/1Y+U6sAc/Alv8yMlTxscyNXD8QqKNjjJ0NXbeIRWscEKF
         nF19crYtRaMYwTMJsgQt44O7WuE4m6FVDiHXyeeJ38KfHhYOfm5LesKIOJn9fg9ECYpa
         MioRdoBZ+Qv2kUovJLYnjUYEj/zD+0Ec796gJ4079L0is2x08tPCi8kbjFnWaWDpSIuQ
         XbIrc0Hyvwy+eOVW+0FIJnliupj+5Qs71V4/sKh3fiXNrI4RlRU7EbJBUGdbQ4NM/4SX
         x4TOL/aPYsvGZ8wIFVAB4pkzQYWZ2P3IiFGdg6NTP/u0vpwUgpz0oCCfePAG1dhZZBTU
         W8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327826; x=1770932626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4KbIplwSpOgL8y77jJIQF/6UFPYYOp7aggt19vghWY=;
        b=ti98GXGbS6XirsFv69K7vqqM4iUtjYU76KF+D86K0MQz0goZamEvWvx79UTMStZQLy
         bcG10eHKQ9ZolH9+fR9ADq3s1a8pgdIJY1bG2QDGmzcP5NJBdv5VxQEbeRM3c5Ym6qXR
         5X7JjiIEMy1+VlQoYKBF7iu/VscKnEB6+GW3OqQxJ5kTLTB/gh3QuHQZZoPYieXzzkFw
         SfXacrWsgM12AiMXPbAPGwxE649jl8zEbxiQQ30Uh3sqeYpiVWKr1E2cEnuxDpk4keUz
         05LK2F4+8znNzPTtfAMrSELFHWdJOgrHeIoNNKtes2itgONW+2T5bP5IVBuZ3bPkhQGW
         W5zg==
X-Forwarded-Encrypted: i=1; AJvYcCVK9IfhGpnfYpPmvFPXiXZt9VnVIHoolRM6eOzJRd6QqfzLZ5GPzD+GZ5e/HaROjS/RdP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRWPBEFQTu6duTl5+49hvfloYZEb8L2+l+M8x8u+e1/a2tvgH3
	2E7g0T5tELhsDyFSyKCwRp1R6TyBE+0t56R1PyB+N60kYaKbqDgHESAQBTJ5SR5L2ILf7uXbPO0
	FNEF6iJ66pogu4A==
X-Received: from pjup21.prod.google.com ([2002:a17:90a:d315:b0:354:a065:ec58])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:69b:b0:38d:f084:e351 with SMTP id adf61e73a8af0-393af2a9b96mr335204637.80.1770327826507;
 Thu, 05 Feb 2026 13:43:46 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:06 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-7-jmattson@google.com>
Subject: [PATCH v3 6/8] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70370-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0AD68F7D93
X-Rspamd-Action: no action

Add a 'flags' field to the SVM nested state header, and use bit 0 of the
flags to indicate that gPAT is stored in the nested state.

If in guest mode with NPT enabled, store the current vmcb->save.g_pat value
into the header of the nested state, and set the flag.

Note that struct kvm_svm_nested_state_hdr is included in a union padded to
120 bytes, so there is room to add the flags field and the gpt field
without changing any offsets.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/svm/nested.c       | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

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
index 0b95ae1e864b..3f512fb630db 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1764,6 +1764,10 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
 		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
+		if (nested_npt_enabled(svm)) {
+			kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
+			kvm_state.hdr.svm.gpat = svm->nested.gpat;
+		}
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
@@ -1889,6 +1893,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	    !__nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
+	/*
+	 * Validate gPAT, if provided.
+	 */
+	if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
+	    !kvm_pat_valid(kvm_state->hdr.svm.gpat))
+		goto out_free;
 
 	/*
 	 * All checks done, we can enter guest mode. Userspace provides
@@ -1926,6 +1936,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
+	if (nested_npt_enabled(svm) &&
+	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
+		svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+
 	svm->nested.force_msr_bitmap_recalc = true;
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


