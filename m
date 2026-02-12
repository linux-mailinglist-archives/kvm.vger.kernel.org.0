Return-Path: <kvm+bounces-70995-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ISuEH6z5jWlI+AAAu9opvQ
	(envelope-from <kvm+bounces-70995-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:02:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB6912F317
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 303EC31A68CF
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2C8344D88;
	Thu, 12 Feb 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVdHkij9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C435D608
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911961; cv=none; b=feSRkhrOwO/IWaYiQvWvmDXXhlZtmd4w6/Nmn1JvfvjlP2y08oLb9mFQ7lMQ1YVKLlGGfQvF6idzbuE+cbExcxIBWlWouBf6W41n3w31KB+m391tHmPM+f/jbYSX69AdLRLMcfiRpcL7Bcv8TGkAWqDm79/aepKDT1vIHKb/HZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911961; c=relaxed/simple;
	bh=++djy9qE0Jp6xQfXeogvywVaePhWe023CD1zQ9+shs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p/BOap3CHVnnXIlP9qNK+ZniKDCNg5V0IFr1lJu9uIN3VbSukoNVXI9J6mpX9O5coOw/REew7s2HicvBPjjo8Qv0uvtTjJmAcXSDc0kmbYEp/nIK2H8WzZ7yRTogmK9S+jH1hInYMXGoORC6slRVeyrtmgLUGErIeWr3t+Apjck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AVdHkij9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7d7b87977so38053025ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911960; x=1771516760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2K3QbxzwUqR/5mBjTZowvxoPbPjbPH0qQe3lheBbwSQ=;
        b=AVdHkij9pCKnFB9bD7XnQI0kNTUFT0ksN5cPC3jqige7G8d9DOKdY8eIu7g5NoWjKI
         RoOPqXE7B+cRKp02J2cmlROmYCn7/zK/P4sd61PclhPxOm4ED6Zcy3pOi5p8b6LlY7V2
         gYiwUIqd4//gHihuovbu8lT8PGV3xotfIv5Cql9BndZ7aBS8RzeuGVLsR2m467ZaiC6n
         9qLdHuDmzQL72Pg+/y0ef6bMS7QvDIDteIxhk5d/sojvJuHqy31EqG8Ha58YggK+ek4b
         +mB+ZV3R8zHb05QZeHfummTdDkCXsbhwKEokW23z1tKdEXy5pmqWZ8Veaf5BV6JYbIVb
         Rdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911960; x=1771516760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2K3QbxzwUqR/5mBjTZowvxoPbPjbPH0qQe3lheBbwSQ=;
        b=DsU76hOgbeagz/xnwTh1zZS9Iet/q5SsFAvizXQ6u8m5LL5vRN5+52H1g+Vz1AvhnB
         shrdgYQe6M/GDW5fpCeo5+lpb22/CPUYivoSuydVvB0KkTBFgG9hxLVfwTxzOlqx5Ne2
         9X7ITvjCfwR5vb3HwPXfDdES7J6TsbsA2IIHcO0BGbgdvN8xBbUK2PY1WRuVAxVgNGZv
         APZ7tnm85irT/y0smfaNEiCiFHjIjBDz4QYJIv/RF+PwsPZZp5tJ64J4TaP3KcjQKM15
         7gNdBGnEIhkUC8gbNz2ov/equuAEE5a2Qoh5bwpwsyVZpWOH92eZrd3NBqnzwvFsXyhV
         23rg==
X-Forwarded-Encrypted: i=1; AJvYcCVBr7+xcui4kEByjtW/4jhDa2xJzBB+yOPElFnzjVkdaGqxT/z2D4A2SgWXwu/i8U376P8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcdyFgpBFAezuBHEwLvXLLzwvGwX9bQJHpcIJWZAjGXdwVjGFx
	rsfYTOtGJRXJ9VGocrbyJQmDWBokwqtDkpfHiYY7HyjjJFlQvm9jb4Njm6kSePgDNiITTBzywt+
	6OaRt8Fzvls/67g==
X-Received: from plbla13.prod.google.com ([2002:a17:902:fa0d:b0:2a9:622c:47d6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:9cf:b0:2a7:d5c0:c659 with SMTP id d9443c01a7336-2ab3b1581a3mr26923795ad.5.1770911960328;
 Thu, 12 Feb 2026 07:59:20 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:53 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-6-jmattson@google.com>
Subject: [PATCH v4 5/8] KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
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
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70995-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BCB6912F317
X-Rspamd-Action: no action

According to the APM volume 3 pseudo-code for "VMRUN," when nested paging
is enabled in the vmcb, the guest PAT register (gPAT) is saved to the vmcb
on emulated VMEXIT.

When nested NPT is enabled, save the vmcb02 g_pat field to the vmcb12 g_pat
field on emulated VMEXIT.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 69b577a4915c..26f758e294ab 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1312,6 +1312,9 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb02->save.cpl;
 
+	if (nested_npt_enabled(svm))
+		vmcb12->save.g_pat = vmcb02->save.g_pat;
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
 		vmcb12->save.s_cet	= vmcb02->save.s_cet;
 		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
-- 
2.53.0.239.g8d8fc8a987-goog


