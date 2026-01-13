Return-Path: <kvm+bounces-67872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8336CD15FFF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F00F4303ACDC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637542652B0;
	Tue, 13 Jan 2026 00:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GwM/QI3I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2023957D
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264240; cv=none; b=JfD2Gm03l21ERvdgAWIlEX/LE32h0WYzCYvD91wUKVaUPGVgfAg87uELy6WCzY+u+TyQTf0EPDJQ5XmGlgBjG9oTtUh91Gkotzj3bfKaQRzBN1S5XHGAzKAlB8EL3CyLDnIZf/MfM0LPD/ZPXY0Lk2GLmxhxguSNkxMXhnj52l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264240; c=relaxed/simple;
	bh=Ui/XUDGeY/+Q+sHshnx+alC9tTo/Vg2ztYyLctjToo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U3mhgGZBrgnlXyQMHQQNZ01SdawORs24U/rdUVKNBGrdNxdn6ZAyRuOiHtPb8ffEQOF6aKiDTPbrufgjFHBkKM/PFcUj8LfIlvZExaa37pTFVc2L7Qnu5ciVjJPrKdSSDqnNsPD+eBcr1Lb2Z7AdsqkFMyzKE2XP5aY7tKRkoAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GwM/QI3I; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so3465171a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264239; x=1768869039; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmQ9PjY09gqi0kYdJAs4HO7SIXa24cDXIcMDQNhHsdk=;
        b=GwM/QI3I83+sd6HheXvQ9wOUyjn08n0cYYlE4jk+6ln4XlYTD8u4r+k5z7Z3lOBiO8
         4AU2lQUjlaSddpXg5YvUoLBozEy8ESX7ysxLhkLfRY+DgD9YZ6ikOrzMKZuUusgwai7X
         y1PEtmXjMS3g1uS4U7w/zbscL2p/WnjF82ySIlz/7Dv68TdzJSmLQap+gbcBKAqJ5U7H
         tXTvMfSbED8o/CoAockTW2b+fTkVr3+IpPH6KBR5Ieix9kBQhyIR1XPXB5FVx0/TtsxI
         BGJG+aZLQDfLs/gv6Ye/HPf/OGvOokPTmbDAdb+32Wsqj50IBddEV16sjKzObcm30s8w
         Hzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264239; x=1768869039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmQ9PjY09gqi0kYdJAs4HO7SIXa24cDXIcMDQNhHsdk=;
        b=JMubBZMQNA5bY946zc+1AkT5QPvG1wpU6PEbRdFTX/H02Xr9NV1LIYND2axfLyAOen
         8h4uBdf3tdAcLtcQ+wLZkSHDG/ZaR7ElTcUCFzc6rXQeFLxBO1jQwEjgspvbL3oyDnhi
         ERCOcWqKrmvKzblsBBaolGesma8t5NvLMXOHVA/97lurQVD/TjbgVTJ1XsC+ybhLk+0v
         ZeN5qMnnDJgc1XdmJsIAOwKIHdCZF4OAGfR/lIE2z7xlS7F9aDkF7nGwAASn4I4kePT8
         OAFg9kQxhgacX2eM/7se3Abmyp1dhaPb3nSS2bc5FPG4TIVegdHCNZEWqyIZ4fO8cD4W
         yYdw==
X-Forwarded-Encrypted: i=1; AJvYcCVtzmc8oIX1R/XMy4x3Ie3v1FRHAlTIbCNCG5Mfzjow+MKBqhRyFC3us6evQjuEaxQyRsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIN8/l2m5FdJNAe9oJFent+6wyhqxSbR5Wqk+yZAA6NDtDJcMy
	GGbtCH6hVVvuEg61FGlhXe3x2YAObz0lPwVw/bCeXuZpz/0G3Fgs94Vmdg4fnZTmwnV19ycznm2
	fZ3RFdax7s0nVkw==
X-Google-Smtp-Source: AGHT+IH/xW0B9YTnUc6Tre/AN51y9XcCmjAIiRBOk0NtxIjZpkCE1FCgRSNgggbRuJfP/HCE+gF4FkdVm16wgQ==
X-Received: from pjbqo8.prod.google.com ([2002:a17:90b:3dc8:b0:34c:3239:171f])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c09:b0:349:2154:eef4 with SMTP id 98e67ed59e1d1-34f68b83d71mr15324988a91.5.1768264238794;
 Mon, 12 Jan 2026 16:30:38 -0800 (PST)
Date: Mon, 12 Jan 2026 16:29:57 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003016.3511895-3-jmattson@google.com>
Subject: [PATCH 02/10] KVM: x86: nSVM: Add VALID_GPAT flag to kvm_svm_nested_state_hdr
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the svm_copy_vmrun_state() copies the g_pat field, L1's g_pat
will be stored in the serialized nested state. Add a 'flags' field to
the SVM nested state header, define a VALID_GPAT flag, and start
reporting this flag in the serialized nested state populated by
KVM_GET_NESTED_STATE.

Note that struct kvm_svm_nested_state_hdr is included in a union
padded to 120 bytes, so there is room to add the flags field without
changing any offsets.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 3 +++
 arch/x86/kvm/svm/nested.c       | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..18581c4b2511 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -495,6 +495,8 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
+#define KVM_STATE_SVM_VALID_GPAT	0x00000001
+
 /* vendor-independent attributes for system fd (group 0) */
 #define KVM_X86_GRP_SYSTEM		0
 #  define KVM_X86_XCOMP_GUEST_SUPP	0
@@ -530,6 +532,7 @@ struct kvm_svm_nested_state_data {
 
 struct kvm_svm_nested_state_hdr {
 	__u64 vmcb_pa;
+	__u32 flags;
 };
 
 /* for KVM_CAP_NESTED_STATE */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a0e5bf1aba52..ed24e08d2d21 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1769,6 +1769,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
 		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
+		kvm_state.hdr.svm.flags = KVM_STATE_SVM_VALID_GPAT;
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
-- 
2.52.0.457.g6b5491de43-goog


