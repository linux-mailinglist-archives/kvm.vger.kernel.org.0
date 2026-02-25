Return-Path: <kvm+bounces-71742-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBE9EvRPnmleUgQAu9opvQ
	(envelope-from <kvm+bounces-71742-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:27:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E21918EA92
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34B65309BE8C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC0F279DA2;
	Wed, 25 Feb 2026 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WxnGNGx9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD45428488D
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982480; cv=none; b=e+P7Jm5SewAmKan96YSkYPc7oBvohNHLnoESLrBMmoslrj4xf6l6+XQENrHxcnNfOb7BmmDQ1OMuPA/0xMlGIAMfR6kmOWV1YPr5TGJHGOgV77NL/rmC+u+zDYdgJ+d/fWeUSuPjaqWdMqdxmEB5XTGMl08Hj3RR1A6h0AHx2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982480; c=relaxed/simple;
	bh=85i39OWQhVtkn+KmWvGw+H0S5qjkbaqht3+QjSVkoLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CnjfJK/Q4y2u/vYa47qwTIBj4uBrg5ZvbsqNcQ+JR7yXVttKKpJJ3GJcdLly3BmXRNOYJmgHPTDOcfI9x8JV69yiTqBJMy+Wda4s4GYFkUjREiqpencPzuLqWZ2OMupBJP5Vj1VtT+uao0Lo5aqBDgnFlw8DUj8G3ZcQdbhw5zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WxnGNGx9; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70e8e7fe55so51235a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982475; x=1772587275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PEtXjeylvLkO6uPQdY2VXz1BpnUVZoay6R5c8Z2Fy64=;
        b=WxnGNGx9MHeq6Vnm9AblAYlxLtsfYWdaxUYa51xS2cIYozLVBka5m3nTHIYUOwfeMF
         e0e6LBhGb0UHaY1JDiWeCSDeox/awWImdp49hc9f//17RYa97DWlCPAq0hRw+R8U5q5X
         9lt6KCyq4G68ZLtNKoQC0yXclx9CF7Hnya2VrZj1EB0N0lI0M1LngyV9wnH1YkSbb0W5
         2osq3hozdRJAgImHkNE6NXHyEOqR6dYZVXZK3HRJAhzacHEDsAurB9+lnxJuOTZLr7Z0
         gcq+J/PVrMKqZqYoQzh5yRQ6zkXVaKDC/4K6xc4k9Pg89EFa8dEZEhU2KTwBvPVVXzzI
         daBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982475; x=1772587275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEtXjeylvLkO6uPQdY2VXz1BpnUVZoay6R5c8Z2Fy64=;
        b=qXqtYCWw37yFpLTSYjmaD27terrfYybqY/d/ysIsr8iCrdA9DDGrZykXzth4LHegqS
         Rj/ZlnEAheKWMqrSxT2lo8cIS86XRsk0wxyANU71urB0pcvGZ6vH1/L6Ux+KHTc2jwum
         kzsl++sT8BVJhG4JP5ZpHaVlVAqhj09qBLqdbS7aFqNEDFP9Vowt3xmB4YbCke/LR9BI
         X1Y+b+Bets9hvYokZRf/WCtVzdC1r9Nrnl7ngAAqyhUOSKnMp9Mhh4OfHTIW09Z59JPm
         mKxrAQ9XyPkJv15MrBIHZiZs3AUsjz+UWdul8VZ2j5jTjTnbv9N3/HargaOaJxeNxyce
         rcfQ==
X-Gm-Message-State: AOJu0YyuZUuPeVTGkjLCZ7bUuTXA0dIg+k/Y6A4samJJRmgCFPSzx8T7
	4rLRmnLl89Wrd63yJeDMPsB8/ZJOEAco2uAAXVcorlQc8hA/BIxg5OPjJm0bgoJMS2gqXZj4CIo
	dsgwJnA==
X-Received: from pgbdw17.prod.google.com ([2002:a05:6a02:4491:b0:c6e:2e2c:d4a2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cf85:b0:395:9d89:db69
 with SMTP id adf61e73a8af0-3959f270843mr632443637.7.1771982474849; Tue, 24
 Feb 2026 17:21:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:47 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-13-seanjc@google.com>
Subject: [PATCH 12/14] KVM: x86: Rename .read_write_emulate() to .read_write_guest()
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
	TAGGED_FROM(0.00)[bounces-71742-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9E21918EA92
X-Rspamd-Action: no action

Rename the ops and helpers to read/write guest memory to clarify that they
do exactly that, i.e. aren't generic emulation flows and don't do anything
related to emulated MMIO.

Opportunistically add comments to explain the flow, e.g. it's not exactly
obvious that KVM deliberately treats "failed" accesses to guest memory as
emulated MMIO.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a3ba161db7b..f3e2ec7e1828 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8103,21 +8103,21 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 }
 
 struct read_write_emulator_ops {
-	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
-				  void *val, int bytes);
+	int (*read_write_guest)(struct kvm_vcpu *vcpu, gpa_t gpa,
+				void *val, int bytes);
 	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       int bytes, void *val);
 	bool write;
 };
 
-static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
-			void *val, int bytes)
+static int emulator_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       void *val, int bytes)
 {
 	return !kvm_vcpu_read_guest(vcpu, gpa, val, bytes);
 }
 
-static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
-			 void *val, int bytes)
+static int emulator_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa,
+				void *val, int bytes)
 {
 	int ret;
 
@@ -8157,11 +8157,22 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
+	/*
+	 * If the memory is not _known_ to be emulated MMIO, attempt to access
+	 * guest memory.  If accessing guest memory fails, e.g. because there's
+	 * no memslot, then handle the access as MMIO.  Note, treating the
+	 * access as emulated MMIO is technically wrong if there is a memslot,
+	 * i.e. if accessing host user memory failed, but this has been KVM's
+	 * historical ABI for decades.
+	 */
+	if (!ret && ops->read_write_guest(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
 	/*
-	 * Is this MMIO handled locally?
+	 * Attempt to handle emulated MMIO within the kernel, e.g. for accesses
+	 * to an in-kernel local or I/O APIC, or to an ioeventfd range attached
+	 * to MMIO bus.  If the access isn't fully resolved, insert an MMIO
+	 * fragment with the relevant details.
 	 */
 	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
 	if (handled == bytes)
@@ -8182,6 +8193,13 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 		frag->data = val;
 	}
 	frag->len = bytes;
+
+	/*
+	 * Continue emulating, even though KVM needs to (eventually) do an MMIO
+	 * exit to userspace.  If the access splits multiple pages, then KVM
+	 * needs to exit to userspace only after emulating both parts of the
+	 * access.
+	 */
 	return X86EMUL_CONTINUE;
 }
 
@@ -8279,7 +8297,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
 				  struct x86_exception *exception)
 {
 	static const struct read_write_emulator_ops ops = {
-		.read_write_emulate = read_emulate,
+		.read_write_guest = emulator_read_guest,
 		.read_write_mmio = vcpu_mmio_read,
 		.write = false,
 	};
@@ -8294,7 +8312,7 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 			    struct x86_exception *exception)
 {
 	static const struct read_write_emulator_ops ops = {
-		.read_write_emulate = write_emulate,
+		.read_write_guest = emulator_write_guest,
 		.read_write_mmio = vcpu_mmio_write,
 		.write = true,
 	};
-- 
2.53.0.414.gf7e9f6c205-goog


