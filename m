Return-Path: <kvm+bounces-71733-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QL6bASpPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71733-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:23:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F49818E9FC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7083730EEDC9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E4A2652B7;
	Wed, 25 Feb 2026 01:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="md6QiK/0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC9239099
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982461; cv=none; b=BdV0ekevgS3NTeJZQXR9Rl7koaiMQuV7BfOrDUZRg1d513AaQbeQ+3Y0JeHUh0wW89eIkMDIdMJVQJ116dXjxipEIc4VrGxV0pRxeE3iQa1ywE5MfqnDzBudfiEAWfbvPd6f2TSSFIB2DzJ739eYV963RmQ6fRRyOdethZH3cIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982461; c=relaxed/simple;
	bh=5WioRAn/exL/M/dDLMs+BGBP7zMGvVlgJ+hWWegWOB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pqxh9j3PQS+pVS/69PF+GAfjz0jHxfDK3VFa3n4s4kCuHr8+UYxlqNx/R1x4oMq2CCzsAxhVKMsFvC56r13FzUYKLM6db4f2RR7aq9UYipveBo2jV5VB2/Y9n7GYQIuVbdGVQPAwnZDP8fd5uKW+wMT0YDDyUHFZfCyqUBcsSpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=md6QiK/0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630753cc38so34290005a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982460; x=1772587260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dv3TZbd1nBU/AEQJbeAhZb6gpTw6vQIp0AVXQNpKYls=;
        b=md6QiK/0BuVkI1hqEPStqXIqHSYp4VhzieptPk+8zWvamoimyR/caDCl3rbe25EPV+
         Q4hqe/lkdD0svXec9h0QUbspkYjoqHfjVbjVuG6cJ1EXSiCq1KKBDSCHiF1vrgd4mymY
         ik6p5CEL/T+AdIs6J9fji0KRXU95Rsou1xZDodQDclANnK0PG2eDt1bT0vtXwQQZkU3P
         zsxHxHRRD3JVYl8AiZjwS9okXpi6UFWEyu3sAX/CxKXHpedljNcjjm+I0FoXVbPdchIb
         oYVezqLrlhxyAHMAeD2MRu3eyDalwBWhf91S+APbQqA6OLuLnWxRDxHlqkgsbm/k+HHg
         zufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982460; x=1772587260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dv3TZbd1nBU/AEQJbeAhZb6gpTw6vQIp0AVXQNpKYls=;
        b=NPywtBKo4rLad+bIwQRedmK04dHmXOuMm2+hguVJ6NgAwTxOl4trsceH1n6T99q+k0
         R2Gb3e5XUMuKg0rW9tGKSt1N3R41sVFhAhjoo0SCNrM7ZcuFWh82DrWMduWO1CV34inN
         T2MSpD/mq26lZTbLLmklsqGcXk8biveRlwcmG442fWMvSI9mDoDv0GgF99Bfm+dQgJFC
         DB0BTBKCh2eEW8pNByJ/ne4GPM3Qf2ws/eMniahRIUa9JEpAtaQH63O6L3xdF2V+eUvg
         PvikRKR5AW1/8VWVZNWviTKTwigQGQJMx+qsi1W5cj0gGt2aM4h2CmescamlY17UhXv2
         7sqw==
X-Gm-Message-State: AOJu0YzpL/N6kJjx3CUZXVmeuTPFbT47gvdNT13bFy6tVxK+Uv1CwcO2
	iq+h3s5TlWOYeTsDfTFA+9deoe31nwN9v1bri46DVTcAX+fVV4UXWGnxx3ACvD6ihazUOf9LpLd
	1EsOJDA==
X-Received: from pgbbq17.prod.google.com ([2002:a05:6a02:451:b0:c6e:288a:3ab9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:496:b0:394:f4fd:b751
 with SMTP id adf61e73a8af0-39545fc60c5mr11022872637.51.1771982460005; Tue, 24
 Feb 2026 17:21:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:39 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-5-seanjc@google.com>
Subject: [PATCH 04/14] KVM: x86: Use local MMIO fragment variable to clean up emulator_read_write()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
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
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71733-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 5F49818E9FC
X-Rspamd-Action: no action

Grab the MMIO fragment used by emulator_read_write() to initiate an exit
to userspace in a local variable to make the code easier to read.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a74ae3a81076..7cbd6f7d8578 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8231,7 +8231,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 			const struct read_write_emulator_ops *ops)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	gpa_t gpa;
+	struct kvm_mmio_fragment *frag;
 	int rc;
 
 	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
@@ -8287,17 +8287,16 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	if (!vcpu->mmio_nr_fragments)
 		return X86EMUL_CONTINUE;
 
-	gpa = vcpu->mmio_fragments[0].gpa;
-
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;
 
-	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
+	frag = &vcpu->mmio_fragments[0];
+	vcpu->run->mmio.len = min(8u, frag->len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.phys_addr = frag->gpa;
 
-	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
+	return ops->read_write_exit_mmio(vcpu, frag->gpa, val, bytes);
 }
 
 static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
-- 
2.53.0.414.gf7e9f6c205-goog


