Return-Path: <kvm+bounces-71288-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHgeAD5HlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71288-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FC915AD40
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 042F23079646
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810D833AD92;
	Wed, 18 Feb 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZu3KLKI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9216333A9F2
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456210; cv=none; b=pHB3DLgqt/vg1SsMQ0GgcI4AuuIkqCWi/NsuOcwwPNfV/iWMkCrCNUL+yz2ytblbDGFDTtTE/w78KiFmF+9PcSswzb/scI4Kf/9XI/+cQp51AE7tAFnvk8N6alyE631OuYdNx2CljVbexUeVDVT8jwYqpL6zGpmE9btcvVi2rBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456210; c=relaxed/simple;
	bh=TJc3a0fOKqplazQ93Hs1c6kkIjHj5kNcKANcDg2K5q0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DLbeaLdZ3AJ6j3nQuEHiIt6SVxCRxrFam705JQEWlBIodXYNFjlJT1q3BseFoQpLp6ApjJy8J7pX1k4l5BH+fp+eLvrBqnTwrJcCQs+oVUQx/Zwh5/HcuiIRaX4srIJoN+dSWnC3rUFq8hyrNJr3gfirUa2qRoxswMP/vtorQj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZu3KLKI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso255428a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456209; x=1772061009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=twtjOlMbJ4yptA1dUwvsBsUlXuZKEvWo2vQHzG7BXWs=;
        b=WZu3KLKIK2izaUr4xY3z8tG//vtO1NQbKZTH+L3/H+/y49dL6l03YcHo1OeslRv2zF
         Yl4beFOdzujvQaSgJeX2Uc2PDo7OktMXng4R6dWILhBCm/cYGvfgFgIXtM8c61Io/Nzz
         JmznaI8yPkGn0qhIIZYFUoVnZBdbwL5QN4oxq95RyQvwW2zqPgjzystozTWGZTPQIF1g
         E7R2Ie07ssKw5NmAiZuv1qLxNJkZTWDkfCxry5HDsTq0jPhE5bo0A0IyXzyVzNHxZVVC
         gf/2mjjL5iffLpPaoRez60Anr5BNaPmwH1EMWisZvRsBITw/fQqqHOhAVQGj2SAm4GFd
         8few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456209; x=1772061009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twtjOlMbJ4yptA1dUwvsBsUlXuZKEvWo2vQHzG7BXWs=;
        b=KVRoE0OVYq8mY2oZBuvKuASz5ViLB+fNhLc7osW7wgWPQAOiba2OJKK8YiTnjx6gwC
         kxpwCxO8h1NEpf9mFCXXTckrtSzBy6FvyJPgNMkEETEhLXhuRaHPPSNyIb1wNOxDTgRz
         L0U8M/9LDYrndzyJ39jetMUByUM+CbJVwA8NU5LtGjg8TBYqwg52cPDqBVEWZ4WR3Wdz
         y4e1xIhdyrIB5s2AhhHZlrsRbNNWvWMCgpBEhO3kkuQaHATkN6tPdDa7+fndksf7xPgU
         EZR86Td8ulpXPP3kzW90MQyYGAylGty3fvWNMp9RbFgk9C9QDzVadHzQe5GzgD7ufVyh
         3A5w==
X-Gm-Message-State: AOJu0YwMr94PLssoNpwPdQjyd4f+0mKjiZAo2/mTy7sJzudMl0DljNlT
	GMwkGg88oA99/6IpRN8UZ4DexqBxyiUugRN6RB8E9L6Gp+ItaCKggPL50PTUTzyc0LY0CCw0VCz
	2F64RbA==
X-Received: from pjug8.prod.google.com ([2002:a17:90a:ce88:b0:354:7c11:76e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548f:b0:354:c6a9:ee33
 with SMTP id 98e67ed59e1d1-358450ed21amr15098266a91.36.1771456208874; Wed, 18
 Feb 2026 15:10:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:54 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-5-seanjc@google.com>
Subject: [PATCH v2 4/8] KVM: nSVM: Directly (re)calc vmcb02 intercepts from nested_vmcb02_prepare_control()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71288-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 61FC915AD40
X-Rspamd-Action: no action

Now that nested_vmcb02_recalc_intercepts() provides guardrails against it
being incorrectly called without vmcb02 active, invoke it directly from
nested_vmcb02_recalc_intercepts() instead of bouncing through
svm_mark_intercepts_dirty(), which unnecessarily marks vmcb01 as dirty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 793f5d2eed3a..e8512de5aef7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -916,7 +916,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
 	 */
-	svm_mark_intercepts_dirty(svm);
+	nested_vmcb02_recalc_intercepts(svm);
 }
 
 static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
-- 
2.53.0.345.g96ddfc5eaa-goog


