Return-Path: <kvm+bounces-73357-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJExBwkhr2myOQIAu9opvQ
	(envelope-from <kvm+bounces-73357-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B82312401DB
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18DB5306F0D1
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF46410D1E;
	Mon,  9 Mar 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XUgzOMyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5140FD84
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084675; cv=none; b=OqSm+fHxz9hFdZlaqfzDBPhE0zP9ZLntuQ+sNNZFJXtlXYRfeKsAy2Aw1LhcA9TOGQyysDwy6YXJApQeDfGpnzpBkbu6ZagZ+KLvbOjktzF4/rp6T7Uvo8WyETqI2lAwiuUW8oCTsSyh8kTW1EpRyaTkw/T6D9P9PtMd0U/4v4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084675; c=relaxed/simple;
	bh=zqSouceZtFC5TpkGpy+KiFus4h62hOvNb+G9ZODiRYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KZUTEWyC2ji4avkh6e5m1nwuK43M1mz8AEsqfOCVrEoSugUeGVgsmLU405MiT8lEXzFaPesguBTwdRKjfcNsr64jRL7x+gEBL1Ndy8AgQ2ohVgTwFYF2g6NgRkOa7T1PQ45A8CMW6QcR429CjkeAr7UEjqSmTHPm8jYQ6ts0HrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XUgzOMyp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae61939fa5so193181575ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773084674; x=1773689474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wblNA6bj3f7w06PD/nTLmV/SuffW2mSGdWVBXF9Y8dI=;
        b=XUgzOMyp9Y1oN6fXRl22p6JHmy+Xk/0x9JJMz5aNgNrg+0pZAzkdJhdZsLswx6n5JD
         ciR4DVH6f4KR6mMlag6337uQsGjHDcGmcEtv/GvO9B9yvCj5MrUS6JDPZ37lI0Fkmmir
         wX8bMRkP4t+3Il56No5JdzJMxuKv5MWXfqu4R8t53MJ5f/pESOzRwkfvTabK7WdYBu1d
         WcKbWcr4u+FHYuLs/zV6DMOOAuWOlYx5l6lw/5+vLwLnpYT/JUJ/IETPlA/NQStMviGE
         JbEHh7ZDbsx/TSGttOlv/lUtV8hPCgo6sblYdZDRBWMMAIc+EBLPle/VpeqylZr7jlmq
         RVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084674; x=1773689474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wblNA6bj3f7w06PD/nTLmV/SuffW2mSGdWVBXF9Y8dI=;
        b=T+Dg4bug0iwMZuP57b6pf1dkjg5Mrj9kWcHfcGWEPn5/Xna7ZSfT3a7QZ6Jj9pQRVe
         VN9tP3JW2cAPp8/TJFTixfyOX9AdNnrwTd38g+GamsjQTczRuZnYTQQxJFN1bwadmX5L
         tFK8owl6r886bftZyfZTGqzFjSXq41AwR9844pZpii2tMASGEkEiHeIYX1t+KQzK6FKB
         1jXqPKEmpqYKtVaH3IAlLlFUaKb0uQGKlfs/iSE8MCfiFUxFa0jxWf1fbNr4jrhkZ5Qi
         rFacq+8+VL26GR5K8ig7eKilcZjvL6R315iKFQ8bUeTq3oc08H4hZTocXFSUiRngfJr0
         xfsw==
X-Forwarded-Encrypted: i=1; AJvYcCW4gNcXKkJsiC2g4c2Vqn2lmpcOl6DWq4KTiyZWpiwboa3x6cNsMPJo6JC6o5TLiKAXeko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0QwXpeAlF5UDs7KhKZwf+OG2aQxqBwb1B4xaWVVqgWfXX2bwJ
	K8Q/1YcJH2E89sjzAW2duv5wk7EXekKLJ5i17Lncs8/TyzA3voP2UXTDWAwJAb3TjCMoawx9K2t
	opyHU/g==
X-Received: from plcy10.prod.google.com ([2002:a17:903:10a:b0:2ae:45a4:ca9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2b06:b0:2ae:50ec:fa2e
 with SMTP id d9443c01a7336-2ae823a1f61mr121594565ad.21.1773084674028; Mon, 09
 Mar 2026 12:31:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  9 Mar 2026 12:30:57 -0700
In-Reply-To: <20260309193059.2244645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309193059.2244645-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309193059.2244645-2-seanjc@google.com>
Subject: [RFC PATCH 1/3] srcu: Declare exported symbols before including srcu{tiny,tree}.h
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: rcu@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B82312401DB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73357-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,joshtriplett.org,redhat.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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

Move the declarations of call_srcu(), cleanup_srcu_struct(), and
synchronize_srcu() above the inclusion of the implementation specific SRCU
header so that tiny SRCU can provide inline wrappers, e.g. for expedited
versions, without needing to re-declare synchronize_srcu() and call_srcu().

Opportunsitically use rcu_callback_t in the call_srcu() declaration instead
of an open coded equivalent (all implementations already use
rcu_callback_t).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/srcu.h     | 10 +++++-----
 include/linux/srcutiny.h |  2 --
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index bb44a0bd7696..1cbc37e3b59c 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -79,6 +79,11 @@ int init_srcu_struct_fast_updown(struct srcu_struct *ssp);
 						// instead of smp_mb().
 void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 
+void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
+	       rcu_callback_t func);
+void cleanup_srcu_struct(struct srcu_struct *ssp);
+void synchronize_srcu(struct srcu_struct *ssp);
+
 #ifdef CONFIG_TINY_SRCU
 #include <linux/srcutiny.h>
 #elif defined(CONFIG_TREE_SRCU)
@@ -87,11 +92,6 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases_shared(ssp)
 #error "Unknown SRCU implementation specified to kernel configuration"
 #endif
 
-void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
-		void (*func)(struct rcu_head *head));
-void cleanup_srcu_struct(struct srcu_struct *ssp);
-void synchronize_srcu(struct srcu_struct *ssp);
-
 #define SRCU_GET_STATE_COMPLETED 0x1
 
 /**
diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index dec7cbe015aa..4976536e8b28 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -64,8 +64,6 @@ struct srcu_usage { };
 #define init_srcu_struct_fast_updown init_srcu_struct
 #endif // #ifndef CONFIG_DEBUG_LOCK_ALLOC
 
-void synchronize_srcu(struct srcu_struct *ssp);
-
 /*
  * Counts the new reader in the appropriate per-CPU element of the
  * srcu_struct.  Can be invoked from irq/bh handlers, but the matching
-- 
2.53.0.473.g4a7958ca14-goog


