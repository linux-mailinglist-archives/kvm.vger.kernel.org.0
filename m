Return-Path: <kvm+bounces-71736-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WAANCbRPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71736-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A80318EA32
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72EED314EFC3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7996820C012;
	Wed, 25 Feb 2026 01:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EghX4vDZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E518126E708
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982469; cv=none; b=kAuWgfHEKLpIP4++7HbJ/w4KHMj0E9iPBEUDGhQ8goJAV+TQlgbzgCI+rTH68A72rKbL++bv8xkthhRmkcs47vdE3IR4t6runGKGPOZPZ+v9QHR6QKT+bb/EJSOCZIjq5IY6zL96zgfbduswmPqQxUIhVhJAGdm9xvqQfbdkc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982469; c=relaxed/simple;
	bh=YugX2YLyYIqesMyLVhe1vuRLpba0vyw2iEWUNwc9aeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fky8UW84wgrNPkEbEEzExyMog1d7hzKaioum/eiWDNQrGETP8jqqZ6DbkABhRrcTD9mnuKJS86ISD/7kFMZH7RkuJ1DHUe/pD/bte+C8sWiqozTPx+RbWruqVVx9nZplqmtjbvJwIuO1pR7Mog/T8XfYqPVemTI+Phz854h/xqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EghX4vDZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3561f5bd22eso5144329a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982466; x=1772587266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U5hmNv02IBvGPnO8Neh+XMn/il3YSxAkvHfsbK9B4L0=;
        b=EghX4vDZyn+mqoAu5lR8XTM56GUhSs0EV/EXjz0SQCYmIUvAvFNu7Nx68/ESPD82MF
         djiQIsBNz7FcqVrApJEPDV7VYUAtaTIbRUSQoLeBgfAa64Nf1QmbLTwfLY4vf+eu+Rnw
         NBDt3P86dI0YRcwahUHq8VWcpX2O18SK7I6G8bW5rtHQUlY9MU/hSJ/IIVfP2+5HuSeO
         gJgaUBVJQrPtrqthmd7sPO4kAyKK7Mitc3ECvwiTJhPmlZYQC5Q08H6xUIOSeCEeJ94O
         4b5yXvYKVnA4ox2n7ja8OuhpTLxjX44CcbQg4Smco5jW5QQJ9VPjiX7tOYxcZm4WCLv3
         L1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982466; x=1772587266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5hmNv02IBvGPnO8Neh+XMn/il3YSxAkvHfsbK9B4L0=;
        b=aFLheMYMXxunXm5vaO5FKXRwTUqd18KCnrcrAIozg+K1zogQ9r5T+HHobTMG63IxdR
         8Yto+mz9KhhBqx66IvOwAowkkcL3kUyMywh2KGk90GrdpaT/pfWkEUvbZd7NAVFxP4eZ
         EfRqpFlwLgXYrz8nJJv3SKoBhh6hOKojVSkl2iMNITLx3j9irLcQmH1ljjVP3hW1ZSEy
         BbCLQgtzMEKGhK1rCWXjRWZKUHpfZ9umJ2lBGBnV4ULbzXZB7PCRyTGDLWb94eoeD709
         UJ1hL+EqUBtJGqcCJfOXQrg/Gf+8+vhBRRGRa2i57o9OrOBuQlc/a+3L9nJ+BhBxRp5g
         6rZg==
X-Gm-Message-State: AOJu0YwOpetm8IRfzoJkT972wW7VT/2qixXDSB9khdH9Pj+cqW6wXkFi
	HVOHVkVnAd/r/2qS9qwxPrmBjyN9saqobH+Mwd9SmoyiuDlKuFC0Mo/hZRX7Lo0yBfqP8S+LUCL
	1Hll0QA==
X-Received: from pjee13.prod.google.com ([2002:a17:90b:578d:b0:358:f01f:25f3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:248f:b0:359:79e:39bb
 with SMTP id 98e67ed59e1d1-359079e3faemr996889a91.24.1771982465502; Tue, 24
 Feb 2026 17:21:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:42 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-8-seanjc@google.com>
Subject: [PATCH 07/14] KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
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
	TAGGED_FROM(0.00)[bounces-71736-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7A80318EA32
X-Rspamd-Action: no action

Add a sanity check to ensure KVM doesn't use an on-stack variable when
handling an MMIO request for an SEV-ES guest.  The source/destination
for SEV-ES MMIO should _always_ be the #VMGEXIT scratch area.

Opportunistically update the comment in the completion side of things
to clarify that frag->data doesn't need to be copied anywhere, and the
VMEGEXIT is trap-like (the current comment doesn't clarify *how* RIP is
advanced).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7abd6f93c386..2db0bf738d2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14273,8 +14273,10 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
 
-		// VMG change, at this point, we're always done
-		// RIP has already been advanced
+		/*
+		 * All done, as frag->data always points at the GHCB scratch
+		 * area and VMGEXIT is trap-like (RIP is advanced by hardware).
+		 */
 		return 1;
 	}
 
@@ -14297,7 +14299,7 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	int handled;
 	struct kvm_mmio_fragment *frag;
 
-	if (!data)
+	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
 		return -EINVAL;
 
 	handled = write_emultor.read_write_mmio(vcpu, gpa, bytes, data);
@@ -14336,7 +14338,7 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 	int handled;
 	struct kvm_mmio_fragment *frag;
 
-	if (!data)
+	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
 		return -EINVAL;
 
 	handled = read_emultor.read_write_mmio(vcpu, gpa, bytes, data);
-- 
2.53.0.414.gf7e9f6c205-goog


