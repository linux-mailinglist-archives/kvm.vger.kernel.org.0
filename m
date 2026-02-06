Return-Path: <kvm+bounces-70518-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJ7LI19rhmk/NAQAu9opvQ
	(envelope-from <kvm+bounces-70518-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 461F4103CE0
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CAC493060F99
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C7B314D34;
	Fri,  6 Feb 2026 22:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ECyf30SX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC535313556
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 22:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416926; cv=none; b=X4bw4oP7SKZUUKRizj6aSQPwYRyBBNUzrcCX9JXI1KiwBzcStA9dv3w1PYDqpcm1KSJ0Faw21kuv202Dfkm2Ga+GeEVjaioQt8uees3hYCPHFQTROZh1eTpk1dvkKHGZD2WbjUylT9JI0EK2C8DzbMuCR1WJZRvXyjd9b1YUZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416926; c=relaxed/simple;
	bh=BZpL1RE9XfDIgFESeYrbtsYlln4FTRDnK6vMRKcrB4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WgMcJGZGOuMZw+Y3RYx5PB6pvbADNBHbyUBad7tPP5Fvx89h9c1zxyTNQ2vu1WleyJmAhsyhLRdJkgndCqyfMAn7mR8bONOT6FUjv/ZCw6pudgp7JP0fLHwi47cxY85GcOmyjhRfK3kqBVQgNzjgDIeVA1/4OtCIz+u/W/2+vj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ECyf30SX; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-409496a48c3so2069607fac.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 14:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770416925; x=1771021725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sPoqEhUMmdDPahIwHzxtMUXZ8ToMdzI8JESAi3VAuZ4=;
        b=ECyf30SXfnbDrAsm2d9JaAmd1cS0YS8eSkvmGyqH01syNolvs+g9Bd1r6NrXy3+alr
         K2fW3to9Mq9jSQoVFDNoQBYTNrX0gCO2vsEgHJZ+lBm1g1+K/lJ2ierqJste6DqxpNsO
         +m6cBcIGIoUA+X/PPQkj3ATQkEnF3jkLppHuqpIGm/reQg1yLXOaKog84p5kPd1c7Fxg
         joGNmkq4Cavw1zZF6aLVkWG/OVnZvqSENxqe9GH5B3TehRGHdiSF27K+CRu1No4PNkfa
         3zhKdQ8Q7WlZksFQL1PPpMOJ+AoZZpnCVfBTCAQvpRnAB5kPIgzRj4HSfBsDiCgvWWAZ
         yCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770416925; x=1771021725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPoqEhUMmdDPahIwHzxtMUXZ8ToMdzI8JESAi3VAuZ4=;
        b=b3SPnu6v6Tg9BlF/uz6iToHJ1eWkLFCzuOd3B9PTj1cXNVRp7/Px7+Z4lUWMUUghOF
         366OYYGqJHeq7ymJaufEJUFmVNdMvGtrUKsfwMmlMl/V22YaR4qb1FehgzgsHHNRlvnU
         W5iB0Y3glxIrZdS4DP+iWQwQjnTnDbhgXvG1ma6AwV9ts4vXamb85pqZ20rgBxyNO6k1
         SOpelUNQUB8BCY4E1DmcmCO4bm+/16Nmnj1493GbAJWVnYrxUUM7+ZJ1KufdzpLqBsRE
         snqJXyQ+gOruuaPLcdRID5wI1cJ1sNhv8q4C4nOl0yJJMbqRW9GPD5HFcb1uYighZ7FD
         kEJA==
X-Forwarded-Encrypted: i=1; AJvYcCVqP5f9TuzN9gQ94sdbk+5mlXGKfFoDfHopUUujU1fsgmWElDC1Vh4dthZf8DI6FKzY/14=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRkplT1RfivC0nzdjV1D1ONRM8zNyzW+VLQRYblBjdbXo3lMVJ
	KrZ3CpdayVSf1o21VBokFfInbh7gy7FLA+jyxUVVEr6xoibG7b+Op/OA7s7JnaZHz3j8GDZH4/U
	Ewg==
X-Received: from iofm8-n2.prod.google.com ([2002:a05:6602:83c8:20b0:957:7451:a858])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:2910:b0:663:23a:caf6
 with SMTP id 006d021491bc7-66d09ac270bmr2203902eaf.5.1770416924752; Fri, 06
 Feb 2026 14:28:44 -0800 (PST)
Date: Fri,  6 Feb 2026 22:28:29 +0000
In-Reply-To: <20260206222829.3758171-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206222829.3758171-1-sagis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260206222829.3758171-3-sagis@google.com>
Subject: [PATCH v3 2/2] KVM: SEV: Restrict userspace return codes for KVM_HC_MAP_GPA_RANGE
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Sagi Shahar <sagis@google.com>
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
	TAGGED_FROM(0.00)[bounces-70518-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 461F4103CE0
X-Rspamd-Action: no action

To align with the updated TDX api that allows userspace to request
that guests retry MAP_GPA operations, make sure that userspace is only
returning EINVAL or EAGAIN as possible error codes.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..5f78e4c3eb5d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3722,9 +3722,13 @@ static int snp_rmptable_psmash(kvm_pfn_t pfn)
 
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (vcpu->run->hypercall.ret)
+	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+		return -EINVAL;
+
+	if (hypercall_ret)
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 	else
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
@@ -3815,10 +3819,14 @@ static void __snp_complete_one_psc(struct vcpu_svm *svm)
 
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
-	if (vcpu->run->hypercall.ret) {
+	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+		return -EINVAL;
+
+	if (hypercall_ret) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1; /* resume guest */
 	}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


