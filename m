Return-Path: <kvm+bounces-71530-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNcdOaTLnGlHKQQAu9opvQ
	(envelope-from <kvm+bounces-71530-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:50:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A32F17DBCF
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80BEA3068150
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970983793C0;
	Mon, 23 Feb 2026 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="toFlxfnB"
X-Original-To: kvm@vger.kernel.org
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD6366DB0
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883404; cv=none; b=rZ54dDJRQo8LvPXuj9l1n726P1uDRCDkuqD6f5cWYrf8QwsM5s1F60MitjJ1D9TMgwz4NaQTKbYcQkhhrag9Opcfhmf5m6UUZIp41o+lJRAIGpgC4ryGxzYtGM0Im15W1+BmHimZhhnONf0KsIRlwpsu/d96Kwk43OM8n0RPF08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883404; c=relaxed/simple;
	bh=QYCXc/vB9DxQdb00BuJBNc58h9ZeSHNFRJ42Bx4WGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEy7GgcPuuAF1zz/UgpAXUJ7SjCI4CK75TY569+qVn4mIUO2I891CzcYzP71vl9GGhcKdyUdMh52+wl4UfUBjScs90rQ7CJfifEY4qQbDsaonTe50zCLgTa7OjD7e0dYNIoAEeraM0F79AtfsrgS0bf+uxrN7lXmD9bP6A1YYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=toFlxfnB; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZJq04RRzlfl5R;
	Mon, 23 Feb 2026 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883401; x=1774475402; bh=//njW
	9JPPBtas9P8/yhoGtlWZGfoIZrsR3E99SonYGE=; b=toFlxfnBstcJkctAfU9E3
	SLBHHaNN47sZHcsnjNgjRsovvQ3PCR9HT1GWoWriQVwQMC7WcUVzDLgj5Gh9whM8
	bmHLloffJ0nsejVx/7v1gZfHg/3R2tnd1yaq526RrOPt1PJ6Q+7nAh8NQfBUrRmV
	KFD+j/tx+33SPeYltpPzMxaYqW2cwPDgs8EkW1Z6reC4m/mMBluYeS7rYYoS8gez
	T7YIVRTNu5qg1F5BzzdCG6Mw3TnU2ZUkFNxuId5p4KfST3BVQWaARs5j+YW5eeSI
	1zVchjXFUsG9kaA3rn8NdtuPN7OowU5ObOsnKR4I5mFQuKKLXoHMpXyaReAA29w/
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cm7eS7EHkRS3; Mon, 23 Feb 2026 21:50:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZJm61gKzlfl89;
	Mon, 23 Feb 2026 21:50:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
Date: Mon, 23 Feb 2026 13:48:49 -0800
Message-ID: <20260223214950.2153735-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223214950.2153735-1-bvanassche@acm.org>
References: <20260223214950.2153735-1-bvanassche@acm.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71530-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[acm.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4A32F17DBCF
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

