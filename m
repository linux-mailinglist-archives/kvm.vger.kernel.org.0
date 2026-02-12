Return-Path: <kvm+bounces-70996-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBFQMd35jWlI+AAAu9opvQ
	(envelope-from <kvm+bounces-70996-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:03:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 726A712F341
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E4DB31D3038
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3612E35E522;
	Thu, 12 Feb 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rk7lUsRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CBE3446C7
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911964; cv=none; b=R55OVWaxvqK36lYfm+NWDOk022+MSZSnNqutYCIWicinFlGePI42gD9+11eJRksSSS+dZhIGZPEHeMIk/gqccUpylLtaRWd5OPWFa2rIe6bskAUCZhPURuoyd9bB57AoVD0+oy+26o3Z01co9E11hvI1T4TKULkg1oWM8OLDAXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911964; c=relaxed/simple;
	bh=IPS4V3Xedp44qKMO94o2K4sQEaOjEKl0DVkxqcvXKYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+1cN3ZfMRp3IaQQwbaETEtLByEGOyuwL6ZqCkY3Y6BcVNsvA9JYyAKYWbiXiuS2FtwpteRCSY8TWy0wX9tfUFGIBGU7T7T7BTusYNij/O5h4CbUKbwjXn7Em2teW2E2vqkp52n9EUtO3440zZEzw5+ih2MkyNgRhTP/FPdztsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rk7lUsRQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562171b56dso18172a91.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911962; x=1771516762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VRlL7csLSSKDZLO+EBN/PvZlh3NDnCHP9xjp5VbQz/o=;
        b=Rk7lUsRQlQl//uUdrDEVniH1nIzVU71SbuF+C8bAsWBkXeZFHVAX7JExUi0Go0cngD
         STiD1RqFWvHhB3uW6DMPeLEa3GFWcpRjtGJ2HlG4IiRuC1/GRZBsV4HrloJEyjGQ/L7/
         lE59ROP/3XTiptLaYbHd170cag7CJF1BEcZLJ5Rf35xaH5Fh1zj1D7SjtN2wlqfvucbN
         EWoYX5SCveD2+y8GVjxPpCIhE05BmJ/e5x97b9TlH5kduPequDPaQ7DQdQevqcKNmVW2
         Qgh0qMq8DKDnM6SV3m4R90dh5Muo1E2pAwPxKASbZQ7F3OXnJqsHohFarpYR+B0DYp/9
         Gw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911962; x=1771516762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRlL7csLSSKDZLO+EBN/PvZlh3NDnCHP9xjp5VbQz/o=;
        b=Zr7CABz1j90QL4dqTKk/m6ba5QCSbOQtJhKFnq3ACxi8SQtBNYMAKZ/WpJlRG+/jL8
         0yEqGQ4n82P4HOyD/Ev5Q5tOOzFcjxIhIpj2eAQCDZO/A7BnIn8lE9Z3VKYuOABb58iO
         ZGzYVHPU+nUXJkq0P2S1wo2PdH8oGBVEzvytNUdWmYSVipMCOUxlT3WHegDJ6AUU7JBm
         QL6OFwfvFPwga1fkJydZGV3mdEDTJuboEB25RTEBBAihyvsdTvKJJiqu06s0OHSagA4u
         MsSp21wvl7fe43qzeWjB7ccAax//WU9N0Xzkbo/UhdJLdcRygAG4Uoh5lxYaSQ6OfSYM
         nLHg==
X-Forwarded-Encrypted: i=1; AJvYcCXiK+BUXNGbsSISndo7vvOQYXIhAIBZ0Ldl7aVGk2F8pGY6r02Uz1KDPDy1YMaBNiA0O2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YytlSNsCXDXh4P4PGS+gR34bkPz1LRoKybsUDEhfqFEj3MZI3qo
	krQbMie+inPTWttFg4ExON+VhazoeT/KvDvoFE1X30ZT5MiMg9u1+DfWecLflJYT78aFzlKwLeN
	qxUfOqRvp1aoSYw==
X-Received: from pjbgv21.prod.google.com ([2002:a17:90b:11d5:b0:354:c1db:b113])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e0d:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-3568f2be796mr3007216a91.1.1770911961810;
 Thu, 12 Feb 2026 07:59:21 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:54 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-7-jmattson@google.com>
Subject: [PATCH v4 6/8] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
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
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.b.d.0.0.1.0.0.e.a.0.c.3.0.0.6.2.asn6.rspamd.com:server fail];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70996-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 726A712F341
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
---
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/svm/nested.c       | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

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
index 26f758e294ab..f73f3e586012 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1893,6 +1893,10 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
 		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
+		if (nested_npt_enabled(svm)) {
+			kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
+			kvm_state.hdr.svm.gpat = svm->nested.save.g_pat;
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
@@ -2061,6 +2073,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
+	if (nested_npt_enabled(svm) &&
+	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
+		svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
-- 
2.53.0.239.g8d8fc8a987-goog


