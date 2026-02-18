Return-Path: <kvm+bounces-71285-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OnSMehGlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71285-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD1D15ACFD
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 373D4304C94E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF0633A9F4;
	Wed, 18 Feb 2026 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rr+bWUra"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4E633A9E8
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456205; cv=none; b=BGWGbEElPFRM0lBu6OQpMq8LaH2dHiw2nuO5p2/xXQCSiHreKtbvz3b0TSsnOMbTh3icGvai/UiwcVRfoC5noUJJm6X6/f9/ZtjSHEyzzm13q0G1UqGB8AqeqfpfKfJYphLK02oV94gD4pGoBKB3yGshfKWMxzdxo9h5MGx0nYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456205; c=relaxed/simple;
	bh=u8MGwEnZw80aUxcAFAsNwbLOYPY2LFnMw6ire5CTzNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YXWYSP6prrvWGPCe9x97UAC/hoyWbPUc8gksIhFt7ZUBb4+jZ1x2Ccv82uo+1Pi5eHHPO3N2x8juc4IXYJD1B+cIGN3S051vVAxIOJxjdZCqkYqFXhW5FN9o05VqqbrrYR4wBHCDyP9I/+tP2aQFDUb1Q1/6XLVWFR7/3O8is9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rr+bWUra; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso1612570a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456203; x=1772061003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8f/RMBwrSD0PDWAtnxpBhLzUqfwgiAT8TNGlxIco9LY=;
        b=rr+bWUraDkb2cB43XvV6POEJeOr/hP+qQ09HH4jwCS/0T1LagsDFwZ7zV3RTl+PrHp
         xKvLrDyfIgvYaIuu5e1JJKaKGm7wThy4nAdrCfEeOD3K23G0TEMkiD0Pnk7I2jgtcq0h
         xc+gcG4Hi16uupYovdnwO9X7txYjXVbH0oA5B/LmAJsu0RrXwFefONZB7C7Njz0XfhZs
         Hiq0s5AXMAqLB+HdUHRJUl5kOCwTtFopPbIY4s8iVeAndyMe2FmyDmlim8yYEQdZLp3J
         AieqGlrLnelEtsmrLPA3IBE8MXZQsCbv0NLbD7KBzHxvgPsAtPyW8NRjpuKmxvXMQFS1
         mx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456203; x=1772061003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8f/RMBwrSD0PDWAtnxpBhLzUqfwgiAT8TNGlxIco9LY=;
        b=jYDOoK1lFV9DMn3K6uAqEo1PiNABY4+5nM5qoXUXPtu49RqG7CWcoC5AThcv+H8VOU
         fMHUCKM2NT5P/ujD27aqx+uTU/1YmoNbWbkLByAjmr1KLJs8aCWnL7DEd4d7KWPhnMoy
         gJZ9zTiX7TF2yRcvBiFyV+HhTbu+c3CWf1WRRDbG5ECsS2gCgj94/JPToYcjwVFMlx9Y
         WGzFM6ySDHeetcDguinV/S9nVBNPa9BHrVK944adWFfMvfwNWq8L5Cs4JJGH3VJvIVQL
         VrYjDTVUsLvwSvzpwBmmsmIxnnhkjozMowRvid0YRpg/dGKphOB/91VJtnP+vELJJtcc
         hHsw==
X-Gm-Message-State: AOJu0YxUW7mhu59Vc/Xdgaz7gelvZvlJPlUrIfxhZamyRGZVe8nkO7kL
	fsL5iffPJmz85gM24WLP7dv/ZIRBgOlfLGZqS6LfSezWKSlxxrgbd/p5OH7Yefu6o8NzMivH+dr
	pumn2MA==
X-Received: from pjbkb11.prod.google.com ([2002:a17:90a:e7cb:b0:352:d931:fa5b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c8:b0:341:8c8b:b8e6
 with SMTP id 98e67ed59e1d1-358890eaf88mr2943575a91.16.1771456203178; Wed, 18
 Feb 2026 15:10:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:51 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-2-seanjc@google.com>
Subject: [PATCH v2 1/8] KVM: SVM: Explicitly mark vmcb01 dirty after modifying
 VMCB intercepts
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71285-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 2DD1D15ACFD
X-Rspamd-Action: no action

When reacting to an intercept update, explicitly mark vmcb01's intercepts
dirty, as KVM always initially operates on vmcb01, and nested_svm_vmexit()
isn't guaranteed to mark VMCB_INTERCEPTS as dirty.  I.e. if L2 is active,
KVM will modify the intercepts for L1, but might not mark them as dirty
before the next VMRUN of L1.

Fixes: 116a0a23676e ("KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..66701106a51b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -128,11 +128,13 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
-	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
 
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+
 	c = &svm->vmcb->control;
 	h = &svm->vmcb01.ptr->control;
 	g = &svm->nested.ctl;
-- 
2.53.0.345.g96ddfc5eaa-goog


