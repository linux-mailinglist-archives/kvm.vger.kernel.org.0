Return-Path: <kvm+bounces-69923-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIayIfslgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69923-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:32:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C036D232D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ABA353015B99
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C233563E8;
	Mon,  2 Feb 2026 22:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tpo/r1IR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A854D359F98
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071439; cv=none; b=Xax8dd1Yq019CSniJKZf0jAScD5a2sQk+195UW/vQPzLOgIASYEtVEpI7KachjCXMuGioLsvXrEnxywzKI27wI9mzzU/+fnBoRJs/f+a/b1dLaexSQJnfRX97vhVCoFr74tOFoT015iZtGziLRN2M2xrDkmdZMPvTEMyoUD1+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071439; c=relaxed/simple;
	bh=R40mwcCMun6/j9110X9mQgTyizI2cQm+7L6dXW4nnMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jewClNlaw0J/vKLHOnN02YThlk3zVKPBddEgt7VF1J+KjTgowm32xW7wUynRTToSxpsfN/hNUYN3vu76hLbxxrN5az4sqYDydLk7NG0SfsBPSjCglwpteDN/J4gg+2Ci0/nZ7XH69oVJ4cxDyAznD6O6R9BYgd/FkOnxUCfcDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tpo/r1IR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c61dee98720so2934807a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071437; x=1770676237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ht8AlBzPzy7ufL/rSOcyDdqUQhHfsU0tKVmCnhhQqyw=;
        b=Tpo/r1IRvPp793vRqC4/rSHFiFwcn4KwUwr7COS4XXiHPzNFO0v/k29pfxMj9looUK
         G2riAd+h5nSCdGOJ38DrofExPnvph+WGp4U8FnbH1b2Q6eXQuzZmyvqWawcEgCTzMvQv
         6ifuwd/qrEFUXAhukrjLNxSCJ8RUE9FP2zCL/w2Hrzw1xJ8XnKq6YyBzU+Q0MebbfDau
         hhMQrPFbsqT6DcZ3FPOZy9/tc180k3cNmBv+WOXeFNWzjZ4uIa6XtjY3qIWmWaA32QLp
         KKXsXMOAtu447+ynkMvwuyqPxcgRWAM4Uhhz3gQ0qeEzVflkhBvzLDWjbXvmGqIQzAF9
         aXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071437; x=1770676237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ht8AlBzPzy7ufL/rSOcyDdqUQhHfsU0tKVmCnhhQqyw=;
        b=GalTB72zkkyGz98m3ax31m/t/1DksiAbf7iYel8PCBgTquliGulN+Rncu/ppDITQ6Z
         1X1y6PguuDwPuz6hHpIHv8zVUl1XBZVtxURcx0Us0+5o1UrJgOgGXaSH3AdyieI/2qc1
         Vzij17e9nEGZqXBVziSwyVckmIJC8kCNhXiMicWg7x91E2bG0iK65r2Go0RrutvIOZ3O
         xbiXsFIHF20Hc4rgVv4yWoxqYANGCBCXYfGR94+sMj5jEmbww0HvmGlfSXW1sdCl5LJO
         MBq5XOJCWxd7UbIMo13X+2vgy13rxbsJWQeG3fuIHDBSxv0dOT0ODYH59bGUKyAjJG5y
         98Jg==
X-Gm-Message-State: AOJu0YxRo1UGahiKY9I1z2URilmBGTHNTWMf3gFOPJXgCE2Nw8Ds1N5b
	x3YicSY5iv/7WZcPmxkSBqBrfLXdnJtVf5H+BMLD/jw0kAR704SpiJyG6w9aBjos4T2ZO2Yn7v8
	FigO25vY2+UEK4QB3lC2m+yiKx5WFfYYFfaCzu/81wMI1szyZO+rK9TlNBWZMsknZNphLGqzzvO
	RnT17Di+cj3X21AiSdTGktdJmY/BLR27fkQak5hka/mXE55DxJCbHIs0rfKV8=
X-Received: from pgbcs5.prod.google.com ([2002:a05:6a02:4185:b0:c65:c4d1:9d34])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:8044:b0:393:1ca0:17fa with SMTP id adf61e73a8af0-3931ca01889mr4471166637.67.1770071435848;
 Mon, 02 Feb 2026 14:30:35 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:46 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <0df75ffa37360aeabac009454eafc796c4b7edf2.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 08/37] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69923-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2C036D232D
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
are disabled, i.e. when it's actually possible for a guest_memfd instance
to contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2e93f836dca..6518cdb4569f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13984,14 +13984,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
+	 * in which case guest_memfd can _only_ be used for private memory.
+	 */
+	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-- 
2.53.0.rc1.225.gd81095ad13-goog


