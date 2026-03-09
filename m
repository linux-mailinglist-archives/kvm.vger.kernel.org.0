Return-Path: <kvm+bounces-73359-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBPROEAir2n6OQIAu9opvQ
	(envelope-from <kvm+bounces-73359-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:40:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 442532403BE
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B1A0317947B
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61987413255;
	Mon,  9 Mar 2026 19:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T8OOh4Xp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670741163E
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084679; cv=none; b=UCDvVhmQNWXwJGH6XB1OzbNP7kv3iHNXQS75ir73Kl3t/K0in5a11+5klk4i2BSmcaGo505pFGG0x+A5lLxVMtU43xGUiporym9e2/LCDSqWHjQVt+RG3G8vcWzP4yD++OxD3HfgriDDBxMfDDDZCNuziE7bCBm1C9xc+YmaOhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084679; c=relaxed/simple;
	bh=Nh7tJ/pXL5Y8LgZgxu8ghrpxcPTqp2B/CPbh/N2FO2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AIxjD4xKkw9V4WsSZhEQND6c2QMfL7A7D1dL5WzXTy5IZz+YO08lAvVKlGSDxWTaTrZ55/bddUyxNr9MC6slCv5zZgBkZZPp28Owtni1jUfSuV+QvB/5vqSvrZSSAR6I6HbY6KwluN6unDIMbo4m1yuZWFBoYV15vYmIKUr6kcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T8OOh4Xp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598007eb74so44883312a91.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773084678; x=1773689478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dwTNwSVWtekPolaPxHcXxrp4YHsI9DpDNNtRgjqHJNI=;
        b=T8OOh4XplhQwITKtupHWbpHnO9AipUvoIybVxEjI8yMS05fUcYk3dUt2Wn3nKuDYPr
         NwMv/6ehPFXa5pTb4Mjx8cVRpejXZElS3/blRbM21LFNEE6tJ52K0HdBfKMvgqZV3WvI
         byqS5d/Q4Cgx+0u/AKKUuxXc6bqikgfVOUCWC83WMRjCuU+yQ9W0XC5ji80FW0BbJcvd
         9coVuRAR7u/uoBD8tpBGlxyYOq9Dwak42M2fNLZpF9wPee57q1779Q/BIVeDkQ9S9HxD
         ifiXyv0QFGcaKNr3PxgeLbpAbPR8VV3V2BLCG1976Pl224nL73WTtTl9sV/6Iquj129x
         8nng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084678; x=1773689478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dwTNwSVWtekPolaPxHcXxrp4YHsI9DpDNNtRgjqHJNI=;
        b=ZTqE5UvuE7aERVJuGToNxsbfbFq3d/o9Z2XQn3K17f+B7EFpmUB9uyxi+TLDu1V0zV
         ESzY4mI2p8o1+TpjtsfC4fKCLO0EaoStiMjxu1e+IYbUnNSyNCzI0caY3OmJjQ65JTbd
         LRGhdTGdhTZH8shZ/hSIFwscBz+kqPP6Y9blNPLjtI155eicamKFrfghVpt/qxicyB9y
         b8N/E+t8OkT/Qr/rLup4MM05eVeTq117UKHlWXpx1sPUDAD/7+KDPYiZOhNJyuf/CABP
         L48Tg5eCWdboSVWmtjMfTVmOV7MJNSNW+PQO9nlaAwmxcZ3Yjxmq7/TnAsuIb8pdqGL/
         rCgw==
X-Forwarded-Encrypted: i=1; AJvYcCXhePHUt+6MxZHa55eI+Z3gx5+/Ns8Ymcm5vHFN3753Gx5sWqT3uXCoeBpBPXDePeMJHWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGcjOqe8uih83Wkwk0w0IQuUVnMn9VA1fmwsK73rzCDz5XK+w6
	f+/Hn5yS6/J1hbKZ1csLFtblqlDLNAy+FlmdjB79aXyNPbPvNI4r0jlmJhwuQoRm/d6qJOZmp5r
	XDdKPqQ==
X-Received: from pgbfq28.prod.google.com ([2002:a05:6a02:299c:b0:c6e:1ddf:c9ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:549f:b0:398:78cb:d85
 with SMTP id adf61e73a8af0-39878cb252emr6354695637.13.1773084677666; Mon, 09
 Mar 2026 12:31:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  9 Mar 2026 12:30:59 -0700
In-Reply-To: <20260309193059.2244645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309193059.2244645-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309193059.2244645-4-seanjc@google.com>
Subject: [RFC PATCH 3/3] KVM: Expedite SRCU callbacks when freeing objects
 during I/O bus registration
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: rcu@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 442532403BE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73359-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,joshtriplett.org,redhat.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Use the recently introduced call_srcu_expedited() when freeing the old I/O
bug during device registration to avoid triggering a non-expedited grace
period.  Delaying the freeing of the object by a full grace period is a
complete non-issue, but the grace period also gets transferred to future
synchronizations, e.g. to the synchronize_srcu_expedited() invocation in
kvm_swap_active_memslots().

For micro-VM use cases, effectively transferring the non-expedited grace
period to memslot updates results in a meaningful delay in overall boot
time.  E.g. with a CONFIG_HZ=100 kernel, the sync triggers a ~20ms delay,
increasing boot times by 15% or more.

Fixes: 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()")
Reported-by: Nikita Kalyazin <kalyazin@amazon.com>
Closes: https://lore.kernel.org/all/a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com
Cc: Keir Fraser <keirf@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9faf70ccae7a..ceaf08a03428 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6021,7 +6021,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
+	call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
 
 	return 0;
 }
-- 
2.53.0.473.g4a7958ca14-goog


