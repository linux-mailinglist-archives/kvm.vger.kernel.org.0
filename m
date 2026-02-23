Return-Path: <kvm+bounces-71531-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OSZC/nLnGlHKQQAu9opvQ
	(envelope-from <kvm+bounces-71531-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:51:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA7517DC47
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5724D302C287
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8ED376BD6;
	Mon, 23 Feb 2026 21:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Op12PJ/c"
X-Original-To: kvm@vger.kernel.org
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0843037998F;
	Mon, 23 Feb 2026 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883501; cv=none; b=dJIRu1lX/PrJ76YXi8rMlJhiOU65l8Zqj275RuXGX5LZm8vebggpv8feZ0V7fBGQ+/RF2yy2rSESYB0a+YSGmK2uY0RxTSvuhdH7mpTDIFhfLsTDk3OquTGHtMp+lg7MlYLdlGEcMRTrWvCdvJxqeisKUPw2c5paOMCZHBlToo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883501; c=relaxed/simple;
	bh=QYCXc/vB9DxQdb00BuJBNc58h9ZeSHNFRJ42Bx4WGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQNnNH3Tn7FrsZwC458lJsFSffAQhTxX/6//gx0UYv9bhXTJfHjK21sO8db7r7/0hpmC/W5llZEIV64eQFDXxM6g3IioyE/HdFvM0rN/FohgYU9Z3hDQFYNNdMoqx7nrEFltWF4IQJrpyYK1kbw9jAl+rSvPtYC3kyDwueA3u0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Op12PJ/c; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZLg5m91zlfddf;
	Mon, 23 Feb 2026 21:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883496; x=1774475497; bh=//njW
	9JPPBtas9P8/yhoGtlWZGfoIZrsR3E99SonYGE=; b=Op12PJ/ckHIuaNT5xF7V+
	paJphTNY4DXImgNT5ekQ8dSz/I6KzXYIlzUceskeO+GKX8UYAy6a9vqSaGLDOzux
	WGGDAO8UyJK+pKrMlY8LIdcpjaBS3+emK8H0NV80ka7vpcYzIDweGMkW8rDwGRjd
	hwMV5sjOrrktfCKHGPBvz4HVpbsFJZPAnv1BrWmyOHKJk0jzdB4rIrsswSew+06T
	zUuvTAToprMtfsWH4lcH32+iGPDG37FjOwoe1mssTkFTWFQQ7dXKXwCeiksJ+kUW
	SJqh1c4KNcL04/XlOWHb8X9X3iYwbbDjgRdNfCDcRiUPTjGkYheKFOug5fQVVCn7
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6v5hPw-TNd1z; Mon, 23 Feb 2026 21:51:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZLX4nHnzlfgQH;
	Mon, 23 Feb 2026 21:51:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
Date: Mon, 23 Feb 2026 13:50:16 -0800
Message-ID: <20260223215118.2154194-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223215118.2154194-1-bvanassche@acm.org>
References: <20260223215118.2154194-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-71531-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[acm.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,acm.org:mid,acm.org:dkim,acm.org:email]
X-Rspamd-Queue-Id: 0EA7517DC47
X-Rspamd-Action: no action

The Clang thread-safety analyzer does not support comparing expressions
that use per_cpu(). Hence introduce a new local variable to capture the
address of a per-cpu spinlock. This patch prepares for enabling the
Clang thread-safety analyzer.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_int=
r.c
index 4a6d9a17da23..f8711b7b85a8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -164,6 +164,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu =
*vcpu)
 	struct pi_desc *pi_desc =3D vcpu_to_pi_desc(vcpu);
 	struct vcpu_vt *vt =3D to_vt(vcpu);
 	struct pi_desc old, new;
+	raw_spinlock_t *wakeup_lock;
=20
 	lockdep_assert_irqs_disabled();
=20
@@ -179,11 +180,11 @@ static void pi_enable_wakeup_handler(struct kvm_vcp=
u *vcpu)
 	 * entirety of the sched_out critical section, i.e. the wakeup handler
 	 * can't run while the scheduler locks are held.
 	 */
-	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
-			     PI_LOCK_SCHED_OUT);
+	wakeup_lock =3D &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
+	raw_spin_lock_nested(wakeup_lock, PI_LOCK_SCHED_OUT);
 	list_add_tail(&vt->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_unlock(wakeup_lock);
=20
 	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking")=
;
=20

