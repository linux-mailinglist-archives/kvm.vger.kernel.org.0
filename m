Return-Path: <kvm+bounces-70369-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oATPBNYPhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70369-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:47:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F6AF7DB7
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9E2C307B810
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CC33375D5;
	Thu,  5 Feb 2026 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yN34Ik7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD423370ED
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327825; cv=none; b=VCaBAzt+QUKP8zMsBYdvtt2+ufrIAgYnxX5n7H0PKW+IErSBeTbvshyP1mmGnGqeECS5JBaRiqUo7MrAlFIsY/pn6XAyoTAJfbgoq37spGJJiKcI9hNnXVDJgD5p0nu/qJ0qLsmnFTZQakTWFSZQY9Cw2Zig9LHy7cWZa3Bf2wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327825; c=relaxed/simple;
	bh=VKK3FI5CznSAk7yWaDS4FKTM94PMhdrLBqenb/UE3CU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r/hSiFri/TqeydODJojvmUb2xebedsJ1Ng9hrCDrjYHhJUwQrKFer+eg/A0vDWdPqh/oNmR/wbREDEqHD38WiPvOntC+h+TA7v0ECAN44iYS0b3B9sh7JlvJr3t9s7hYrIX0hE9VnzQbYKU3DTcIv4VAFo0Ck0ZCuJvPFwkyqJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yN34Ik7Q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c634b862fcfso843535a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327825; x=1770932625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/y42SgBvf8dyV9xojnKcBJj98e4MjkxOU4lKNEYjtnI=;
        b=yN34Ik7QD3KL5yHDFPMvYywOYoh5TyfWVj++g6IoN2BDRMLrOItTWJqLJEPHjaetWe
         TkqQEARIDPbH75UO7AWCWF7HRnrXhgPjhywqCzglhIISD1KYp+1qn6WHS8x+jAgUZKPU
         8is009BGMGPbt0KIWkjlYtbhvFpnCfeHV+I01zsmWrNW5Fn1aBaBVYnPIeEDsfOWMTdg
         5dc5X0Y5UBVXVz8x4wuERTKGW43d0KIlgk1SNGN6/g8xTgT2xIhz4Dd9Ms7h2Xb1LteB
         fCmDLNzLhu+mL6KtECSmLArE9QBuuM4s9iIt1fDiIlOKisMLhNIRoJYA16KAFsy9vPen
         RonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327825; x=1770932625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/y42SgBvf8dyV9xojnKcBJj98e4MjkxOU4lKNEYjtnI=;
        b=QOV5QFCbOQK2CkFOG7clK+OM0uvmuuPBDvd67wfdd2nb+zoi1DuxD5aO/rwFjASd9A
         v+pWSglnzVRhVO8DkRF6G96TtNiPDo+9FCV9dNhYYycsc7cje6+QpQ/yVHYRnt75RmVX
         bsRWXsGKc/taCYKjn2PtXxGdxOxi7mbC5KoZrUiL2NCc+1EGgKhwoery1NUxWa/+vOPk
         4EoqV7XmZH90TtdgiAhc3kPmaKm6mJBwF24bzk0n6Jk0XFYRnaH+LZv6pc3TK3D89aSl
         RGJqON4zN5DUV9ZZ2ryc7iIMT/aJ38zRXrlT/+p/KxdJ4sHWl+u5TNyk6eaWZOBA6tnc
         R7qg==
X-Forwarded-Encrypted: i=1; AJvYcCWrX4SHleB1+xZtec06GVNGMwf4nWxmII9QiXmTuHz/l4z7ebNpWT/a6GRGJlH0mEARFIc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpK+5EAKHWK0jnRkEJmrqOKKWKWobr8MW7Ixa01iQ6QV/tbOIf
	uzU4E52pAh8dR1ArtZxdtgYkEDWghj+YkdiOrVEvicQLHUvd1kNOBu+KgCJNLkfEKfmJnv8ScGK
	UvLcYvqNWMsHlgg==
X-Received: from pge15.prod.google.com ([2002:a05:6a02:2d0f:b0:c64:8baa:4f1b])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:ce4d:b0:366:14ac:e200 with SMTP id adf61e73a8af0-393af250deamr354321637.62.1770327825224;
 Thu, 05 Feb 2026 13:43:45 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:05 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-6-jmattson@google.com>
Subject: [PATCH v3 5/8] KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70369-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 86F6AF7DB7
X-Rspamd-Action: no action

According to the APM volume 3 pseudo-code for "VMRUN," when nested paging
is enabled in the vmcb, the guest PAT register (gPAT) is saved to the vmcb
on emulated VMEXIT.

Under KVM, the guest PAT register lives in the vmcb02 g_pat field. Save
this value to the vmcb12 g_pat field on emulated VMEXIT.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 08844bc51b3c..0b95ae1e864b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1169,6 +1169,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb02->save.cpl;
 
+	if (nested_npt_enabled(svm))
+		vmcb12->save.g_pat = vmcb02->save.g_pat;
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
 		vmcb12->save.s_cet	= vmcb02->save.s_cet;
 		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
-- 
2.53.0.rc2.204.g2597b5adb4-goog


