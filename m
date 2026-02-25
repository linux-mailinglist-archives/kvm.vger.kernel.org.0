Return-Path: <kvm+bounces-71737-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WE1bBMZPnmleUgQAu9opvQ
	(envelope-from <kvm+bounces-71737-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79BB218EA41
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1837D30467C2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C51326D4CA;
	Wed, 25 Feb 2026 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xC4R8j28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22A265CBE
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982471; cv=none; b=GHzAX9xJkMbiAUZG5qHxwIKMtxVoSk9z2pk8LxpfWiVrf8UKYY+/SQWVpqh5Rk8aQ+vXbZgRNhmjPpLdEk8Bwaw5mcRkowNULgf+3LKwfaX+V/ZiFCREpocB3wCvwCO8lVqg3Q9kNhmlT3VVXb5avQGm+tTj9hI9bs24rsxCCKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982471; c=relaxed/simple;
	bh=jhFdYJ/k2G4ufjPQSuQbjjN1qZ0Psh4hxK61qelisac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Timk2gvTfrpDG1wRlsxNDwrJD6YhlhPdWUX49i4KP92ZfV+tnWAiEEhtmStb5+hVItX5UVJmNl1wPo7ls1fXYneI6spMaBgUlJwXmuocvYx8vAGDgC4WyVejCZuvN1XTKbiVY2nyb5O+TkcRsKWOJRG69R1n/CWBDFA16rC22Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xC4R8j28; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso39449265a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982470; x=1772587270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sb25WqFS5MOa5y8whWmlEi7jKLk6DH13/xEv6hI9zy0=;
        b=xC4R8j28BYATpbd4dNrttLzukZgp4xeTD460YuiSAiIKVOUbvqmHHn4vIV7upcAM3N
         3vLWzOGvlCuLOydh3/n6icAZpWu0d+bhvyXe/9B25tkpqlh5wTIEbNaq94VXlknwzU5V
         +16gLG0hng1RzWTVnTTuGZX1pTkpwtqHlYK5VjtMMiV/yL3YlfSHyWShcn1Bo3mySqpW
         B21CixIfnMBbaKJRA3vtWVmkRedDCvXPURcYICVHa/PG6nE7pGS3q6gzS3mDHdu5ryY4
         Rq31VrO+2n0XZREPbJmGjhHJzTj0myd7T+booGaY0cB5/tv9oNV1ksSE+PKs8uVPY3Ew
         rkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982470; x=1772587270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sb25WqFS5MOa5y8whWmlEi7jKLk6DH13/xEv6hI9zy0=;
        b=bYSmdQbpgpCCus6e3zgTPfb8yHQqlQYggllwmF3nmmxQ3iuwAb3ZhcTL0OXNoiVIIl
         R65Y24L8Gsi68jPyERKLG7e0RlzB1Bx6FRJaCj1jl0kHAqA01CzCkJtpRCr3IFBllrkY
         1cdEdzS7Q6/UWlQtAtbafSbWms67QeR595MXPeKPuHnx8xJbCXgZytHWf/kZNEFyUjvp
         tnqncKcawqJO2mwj0ogPjX7PmmsYi1BT1NcqBNktZnmAszZ4I6YdHJr1rAPsSUIFSIzN
         fjEpmZhB6WSDTc4SpcPSTGqi37bwUt8V6HgNzbwL7dmk3v61k9Y2B4PUdE3sNXA9ZMqx
         iJaQ==
X-Gm-Message-State: AOJu0YzcA1E8n9X2iUPr9mJhdvihGRiO6R9smJZB97DM8accgZD/UDuE
	NRbz6jnCz7NYVdjFqc27g1cQMK7yWQCXbessCzFlnz2D7lHgMs+RecorQcxfel/WGa6h/02FWzQ
	xUG9sSA==
X-Received: from pjz13.prod.google.com ([2002:a17:90b:56cd:b0:354:c1db:b113])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:356:2c7b:c013
 with SMTP id 98e67ed59e1d1-3590f205431mr539675a91.29.1771982469774; Tue, 24
 Feb 2026 17:21:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:44 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-10-seanjc@google.com>
Subject: [PATCH 09/14] KVM: x86: Consolidate SEV-ES MMIO emulation into a
 single public API
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
	TAGGED_FROM(0.00)[bounces-71737-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 79BB218EA41
X-Rspamd-Action: no action

Dedup kvm_sev_es_mmio_{read,write}() into a single API, as the "cost" of
plumbing in a boolean is largely negligible since KVM pulls out a boolean
for ops->write anyways, and consolidating the APIs will allow for
additional cleanups.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 20 ++++++--------------
 arch/x86/kvm/x86.c     | 29 +++++++++--------------------
 arch/x86/kvm/x86.h     |  6 ++----
 3 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..723f4452302a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4434,25 +4434,17 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	switch (control->exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
-		if (ret)
-			break;
+	case SVM_VMGEXIT_MMIO_WRITE: {
+		bool is_write = control->exit_code == SVM_VMGEXIT_MMIO_WRITE;
 
-		ret = kvm_sev_es_mmio_read(vcpu,
-					   control->exit_info_1,
-					   control->exit_info_2,
-					   svm->sev_es.ghcb_sa);
-		break;
-	case SVM_VMGEXIT_MMIO_WRITE:
-		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
+		ret = setup_vmgexit_scratch(svm, !is_write, control->exit_info_2);
 		if (ret)
 			break;
 
-		ret = kvm_sev_es_mmio_write(vcpu,
-					    control->exit_info_1,
-					    control->exit_info_2,
-					    svm->sev_es.ghcb_sa);
+		ret = kvm_sev_es_mmio(vcpu, is_write, control->exit_info_1,
+				      control->exit_info_2, svm->sev_es.ghcb_sa);
 		break;
+	}
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		++vcpu->stat.nmi_window_exits;
 		svm->nmi_masked = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f93f0f8961af..022e953906f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14293,9 +14293,8 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int kvm_sev_es_do_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
-			      unsigned int bytes, void *data,
-			      const struct read_write_emulator_ops *ops)
+int kvm_sev_es_mmio(struct kvm_vcpu *vcpu, bool is_write, gpa_t gpa,
+		    unsigned int bytes, void *data)
 {
 	struct kvm_mmio_fragment *frag;
 	int handled;
@@ -14303,7 +14302,10 @@ static int kvm_sev_es_do_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (!data || WARN_ON_ONCE(object_is_on_stack(data)))
 		return -EINVAL;
 
-	handled = ops->read_write_mmio(vcpu, gpa, bytes, data);
+	if (is_write)
+		handled = vcpu_mmio_write(vcpu, gpa, bytes, data);
+	else
+		handled = vcpu_mmio_read(vcpu, gpa, bytes, data);
 	if (handled == bytes)
 		return 1;
 
@@ -14326,8 +14328,8 @@ static int kvm_sev_es_do_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	vcpu->run->mmio.phys_addr = gpa;
 	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = ops->write;
-	if (ops->write)
+	vcpu->run->mmio.is_write = is_write;
+	if (is_write)
 		memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
 
@@ -14335,20 +14337,7 @@ static int kvm_sev_es_do_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	return 0;
 }
-
-int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
-			  void *data)
-{
-	return kvm_sev_es_do_mmio(vcpu, gpa, bytes, data, &write_emultor);
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio_write);
-
-int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
-			 void *data)
-{
-	return kvm_sev_es_do_mmio(vcpu, gpa, bytes, data, &read_emultor);
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio_read);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio);
 
 static void advance_sev_es_emulated_pio(struct kvm_vcpu *vcpu, unsigned count, int size)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 94d4f07aaaa0..1d0f0edd31b3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -712,10 +712,8 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	__reserved_bits;                                \
 })
 
-int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
-			  void *dst);
-int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
-			 void *dst);
+int kvm_sev_es_mmio(struct kvm_vcpu *vcpu, bool is_write, gpa_t gpa,
+		    unsigned int bytes, void *data);
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
-- 
2.53.0.414.gf7e9f6c205-goog


