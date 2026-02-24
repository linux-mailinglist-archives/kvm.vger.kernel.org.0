Return-Path: <kvm+bounces-71563-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KAoMC33nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71563-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B898180586
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 898E7309A2D0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC752550A4;
	Tue, 24 Feb 2026 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+kQ3/lq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D5723E25B
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894522; cv=none; b=j6V51FxEaN1KfEIb337f6t2idwfPBgloO6BXK2G6VlVFuhRDQ0w/Mzfpi5gFhiglSXxqyIsJemUIV5NOqJ03n1DTSsksaCG9ss2qfr1gmTzXV2qL1qImB6WaCDpQDXkiOquXGoYU6eVjC57Bf/DVnCjDc4kFGhkwwSy1yQKLHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894522; c=relaxed/simple;
	bh=KvLeiV0Vjji8SiyrDnRu5DIWGXhZccf7uaKSyEhILb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQ9d5MoFUss2QF6+6/9hx1qO+mnVBCyy3inxfA3Idd/LoKbCemez4Q07OfBOM9jRFg/c0KR57mzfc7jJaS3DSt+iUqDg4VWGVBzNWsnU/xqlKbK1dC4XzKaRYZOEk6Fz6xYQcUP1U3OLTHg5p/5LKBQ831dMNbFWfabqRi1UwRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+kQ3/lq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso4536663a91.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894519; x=1772499319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bUKIiVYJTDw1mDZ4aEBlsw/+AO2q4TbZR44wBl/k5uE=;
        b=k+kQ3/lqZA6XjICx5lIKP6ZpehY9zGIj2KM4h9jUPkyDo9ClwPc876tL9OL/3nuogA
         Iy5VebPGyl8Nor/oRlpfi/kkfUBxBFAi7Gb9NomB0oG+dqpJm/C31/dVwrI2e1T1z8C0
         YbSNAjywOsecqiGOxFjeLVPebZZNlwD45Z+tFVuBkVIAa6vF6SvgQemMbHHYTu4DhcCg
         awOnfvKci+W1ldsk/opbRQ6pnjnBZY5HB262LtllkVrzLk8bwPRD3WdSL//F1YN+sCP3
         /nQpHe17wFKHjNerFvHAGgPaegLaytHfJXzTIqp+SU97E06JUivzDIUzON03unHKRquZ
         dRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894519; x=1772499319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bUKIiVYJTDw1mDZ4aEBlsw/+AO2q4TbZR44wBl/k5uE=;
        b=RcbtiV/EAkgdJC6MitaZUWrnygHXiohGY8HzcL1ZmNqfhWY4n0e55EoIAOgurj2gjN
         M7RQprjbjsM9DCD1n2YpaH1klVuL6XyhZZ0dTJ+t2AH+G4TCqEl1FpnUTQ54iG9ls1c6
         TzwWaBNExQ1hr3Ae+/x7N7Jg/hhqFD7Y8uoHw62ZAs1v96x1KLRAqYC3jIBB9Lbmyk4m
         8unAXsWLh07rzoSpxtEEEsIwRH7ALQ9P2wup8gmyJ8imCELqikoB//c1jaB31x72Nn7s
         G689juSCZTwWoMlCSjv/RE8C4BSkpBR4CBoITTprt9GDwzeMCp6ryDkv/Dypk5pxxjkN
         1VrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvuESv2MQDzfte6WrHq9s+Be3xwacgMtHq5tb24J0WfG0evgZL4jN0/MP444/mKGg9mbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTmYwsY9RYVEJstpk2d93xPeXpehtUSCKlxqPNpFNRMhXKjs7L
	6iv/aPzRK/iwh5GEF5cM54haoIK+S+ycXxJwZi/e63FRAvQVQL4dAUvShQtehTgJz/Q0LuQlXvf
	kWF+c03l9yrHgLQ==
X-Received: from pjbmu3.prod.google.com ([2002:a17:90b:3883:b0:34c:34ab:8fd9])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5864:b0:34c:635f:f855 with SMTP id 98e67ed59e1d1-358ae7ceb11mr9530118a91.7.1771894519240;
 Mon, 23 Feb 2026 16:55:19 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:45 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-8-jmattson@google.com>
Subject: [PATCH v5 07/10] KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71563-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3B898180586
X-Rspamd-Action: no action

According to the APM volume 3 pseudo-code for "VMRUN," when nested paging
is enabled in the vmcb, the guest PAT register (gPAT) is saved to the vmcb
on emulated VMEXIT.

When nested NPT is enabled, save the vmcb02 g_pat field to the vmcb12 g_pat
field on emulated VMEXIT.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
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
2.53.0.371.g1d285c8824-goog


