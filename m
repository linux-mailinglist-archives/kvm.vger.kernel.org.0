Return-Path: <kvm+bounces-71739-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOgUG1VPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71739-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A005B18EA13
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6FC80307829A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E812848BE;
	Wed, 25 Feb 2026 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O9TYJ9n7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8100256C84
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982477; cv=none; b=N1FOYVz8SkhOmBW1Z29gW7CKrwrV2C9VW/vxAlYSe5VCGQzrXVpiTTA92j/r6wIG7/JAzCHHP1G9ijEeXwyy3oKlVrX+4RyqGMRql1BVAZHlddhoyYuEeejpSB+zMBfCjC8Lrfn1PcGeGEwUTYtnEMnkPBzEEZlzhSWRtCTLekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982477; c=relaxed/simple;
	bh=4zmfeUoFw0++ZD2R7XqZF7I3p6nxfaKrCAs/KOcytN0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=icvsvMtHaVuFqijcuNV6YsiD/qcarlTifvcrm9eEHGB9knxb6XMT08ljWXxTZ9W8GT+oGuZOkYMirw3NyaSbhTQ3gwLKAYqJ6lZHB32RytTsFJ4yga/P2+gw0AKHUQDtgZspTAVM5kjG0QOyhBIcFqumJm5ypn/KU99R5qHgPmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O9TYJ9n7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2adae76a9d0so10808275ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982468; x=1772587268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LNNapYowtT0YYRygm4WC7Vz/wQDCwBu2kBJka11VtD0=;
        b=O9TYJ9n7RHCsH7UGDZAJ5Ib0hBi5YppZ+tPlu+EIN8rIlN/bHFlPMI800sm+DdXgNT
         +JdJoPqVdHJqfMzI4wYuYRvdlAvvmnN430z0T/Xm2pRQlhN4w0IbzJhDc0ioRlx6GZLk
         BP9vnTrDNA0xI2ID53Q9laWvviaLXd3hYZ/JahYYgGEAwSwqkQjZZQ1Cu4Qk90u1/3AH
         EHiBV6HNyNvwl3lXBEr9QloNaRoqC0CrgdYHcp0eDC30W4r1TKU+kBtvNEGUE4R6wF5i
         3yt50VCrGJ3gfbZwKNGYQxgzRrOg+BCjYCaunx3UJlL1bpsYjgzkHOO3ZmRJzX1j7k1L
         nkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982468; x=1772587268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNNapYowtT0YYRygm4WC7Vz/wQDCwBu2kBJka11VtD0=;
        b=n7pHx78rvZauKiAxeYogLhGAcIaIJRHNaxLuW3TvB64ZNm2sT19OhWUOkCzFwrbNOC
         8j8xljUeQx+mnG78WEsIpBWyO3ut8ezME+iW0H12kTFwNw4SXJqcAEfBVH8YEZCjTGzM
         OsFKmrDYY9PWlLbavtra1EtgnV2nLSGb/ADvoEn5ERVxcHVBbD57gcnGAI6vFNJ0zNe7
         hoyyFeUyEY+wG/U0D8+FiMNCZ+nxQ8oDJ3zSszsh/pD7K46yJm1wOfcBtew4NywnZPS0
         do1VDgG8MER58JiwmOz2LMfWivi6q8FiiqGv4xev7AdAbfEF8nrabEHt6zjyo67+RuOm
         WQwA==
X-Gm-Message-State: AOJu0YxG50/UOBgF+NZ3IMY+48lVDA111a3PDJK24KCQuH9HbDT4UHSb
	JkuTPM7HJCo74f3Mqr0fTmG3kJcMFKCv0e8vjqpfET5EpnX6d+zl/rctrsORdAPNcFYBJzTsY5Q
	2frt5QQ==
X-Received: from pjbnh18.prod.google.com ([2002:a17:90b:3652:b0:358:dfd8:3150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a8f:b0:2aa:f2ce:5ac5
 with SMTP id d9443c01a7336-2ad744e0d19mr151791755ad.32.1771982468138; Tue, 24
 Feb 2026 17:21:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:43 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-9-seanjc@google.com>
Subject: [PATCH 08/14] KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
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
	TAGGED_FROM(0.00)[bounces-71739-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A005B18EA13
X-Rspamd-Action: no action

Dedup the SEV-ES emulated MMIO code by using the read vs. write emulator
ops to handle the few differences between reads and writes.

Opportunistically tweak the comment about fragments to call out that KVM
should verify that userspace can actually handle MMIO requests that cross
page boundaries.  Unlike emulated MMIO, the request is made in the GPA
space, not the GVA space, i.e. emulation across page boundaries can work
generically, at least in theory.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 110 +++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db0bf738d2d..f93f0f8961af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14293,80 +14293,60 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_sev_es_do_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
+			      unsigned int bytes, void *data,
+			      const struct read_write_emulator_ops *ops)
+{
+	struct kvm_mmio_fragment *frag;
+	int handled;
+
+	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
+		return -EINVAL;
+
+	handled = ops->read_write_mmio(vcpu, gpa, bytes, data);
+	if (handled == bytes)
+		return 1;
+
+	bytes -= handled;
+	gpa += handled;
+	data += handled;
+
+	/*
+	 * TODO: Determine whether or not userspace plays nice with MMIO
+	 *       requests that split a page boundary.
+	 */
+	frag = vcpu->mmio_fragments;
+	vcpu->mmio_nr_fragments = 1;
+	frag->len = bytes;
+	frag->gpa = gpa;
+	frag->data = data;
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_cur_fragment = 0;
+
+	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.len = min(8u, frag->len);
+	vcpu->run->mmio.is_write = ops->write;
+	if (ops->write)
+		memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
+
+	return 0;
+}
+
 int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 			  void *data)
 {
-	int handled;
-	struct kvm_mmio_fragment *frag;
-
-	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
-		return -EINVAL;
-
-	handled = write_emultor.read_write_mmio(vcpu, gpa, bytes, data);
-	if (handled == bytes)
-		return 1;
-
-	bytes -= handled;
-	gpa += handled;
-	data += handled;
-
-	/*TODO: Check if need to increment number of frags */
-	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
-	frag->len = bytes;
-	frag->gpa = gpa;
-	frag->data = data;
-
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
-
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = 1;
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-
-	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
-
-	return 0;
+	return kvm_sev_es_do_mmio(vcpu, gpa, bytes, data, &write_emultor);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio_write);
 
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 			 void *data)
 {
-	int handled;
-	struct kvm_mmio_fragment *frag;
-
-	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
-		return -EINVAL;
-
-	handled = read_emultor.read_write_mmio(vcpu, gpa, bytes, data);
-	if (handled == bytes)
-		return 1;
-
-	bytes -= handled;
-	gpa += handled;
-	data += handled;
-
-	/*TODO: Check if need to increment number of frags */
-	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
-	frag->len = bytes;
-	frag->gpa = gpa;
-	frag->data = data;
-
-	vcpu->mmio_needed = 1;
-	vcpu->mmio_cur_fragment = 0;
-
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = 0;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-
-	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
-
-	return 0;
+	return kvm_sev_es_do_mmio(vcpu, gpa, bytes, data, &read_emultor);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio_read);
 
-- 
2.53.0.414.gf7e9f6c205-goog


