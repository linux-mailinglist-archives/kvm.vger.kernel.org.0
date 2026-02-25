Return-Path: <kvm+bounces-71734-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOxgCWdPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71734-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7EA18EA21
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27B3131214DF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A23C262FC0;
	Wed, 25 Feb 2026 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zYMeJgCP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6576626056D
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982466; cv=none; b=az3RFwHGsgYDEkH3nzBLPL0dAPgFR6orxsOPj7czfhpBwGFvGYiyUQrVNBGMOyGufuxfMiktGk+jk0nNINhnoAF4XL4HqWrzBULNul/oMMCRWxbDtRQd+2MUrC+eJPCERqEE/e/0308/IivPH7kSh1KWu0WheXhvAJz1wfBmRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982466; c=relaxed/simple;
	bh=iyxIPblZQF7VigUXYeAExOzxkERFEm+SJWV+/cinaYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=goM3zqONw7D5tvaw94GPV1YDauPRt57LR1pkYLLmvbQ/aRieuUKajqlA1maEMgbGV3AfeFRmDpwsREZSRhufWv9qklIQLxYtv1MqJQp7OO6NPxPivu2L+6FgDRiz+jQXRvrscWbvfuDq7beH/oLvFeNLveb90p5AJnwMaTUMiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zYMeJgCP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6df833e1efso25400135a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982462; x=1772587262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iAM51bp4Q7vtLVTuwPEvx5LguTW6LfJ4+fu/BmQleqk=;
        b=zYMeJgCPC8e8ZZrN9bYnKZA0FtR5BhIDDC+9MUmF7IxvUihatePxZLes3O+KkV+QI1
         byVnyhqlR1NKdBMY4HvbViqcDPi3pYV2HQlknMs8A20llalvf4RfQBMPpZ2ho1pw3nzc
         zWw5xtEniGJDVvfOYPO0tC5JhvurbxIJzFYM9oGuXEC5Qe+mQzflIqBUXerC4mbQfH8r
         iPtEo3MOHj1ZP130rUz1MeZi8EWiPnegbdfp2/T3Xeva4xToXCUp1Y+OEwEyq0QAWge4
         C3S+mSoks4j6FFHwJLVl/L4gMO2WZEl4Ns6q27SNR/ztA0ZLNfL/GRJyE2LZ8oY8BPUd
         o0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982462; x=1772587262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iAM51bp4Q7vtLVTuwPEvx5LguTW6LfJ4+fu/BmQleqk=;
        b=Fep6TVsWSjO+VckLMjwpV3w6oqblU3bOEqBHQYLWSn4HEpcrK8MolVxILPR+ubkAyt
         gTi7JBEyyiLovuoXsaDt5XkFApLEqJJLhMVGpa6cFmCC9wWXwjztzQDaM6UtgtGpr8xk
         ulq3KWwwuP5PX8hsQ2FtbzaAoD5t+qBiuctsmb7e0BAhK2o7KRKg8w2u6zcyT/u+FSVL
         03SSNGX1SvSkjW+ohCVwyL8Ip3ZOLrJv7fOHOz4GdkHlvZk3sguEc9B4168xue9UrnZ2
         A/kStJVUTmTi8ydTqLXSGjvI7TUzjuL3PxirDqEg0CmH/pJ3RAa1AYrTBNNoqCbkPmiI
         lpYg==
X-Gm-Message-State: AOJu0YyHBQ/FU9Kuq4asbj4jMbJQ/zn30Zn4Lp75EQiniP4N7J0DTjxP
	rzaKso4uqaynntEvOVxWam5B8M0F7sz3ajxBPbgX/x1ftmnc/BZ+lOe6oQxwD1327t2OsXkrVBi
	NnKUynw==
X-Received: from pgla15.prod.google.com ([2002:a63:b4f:0:b0:c07:89a0:6746])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4c0e:b0:393:7575:a8d5
 with SMTP id adf61e73a8af0-39545ed0443mr12719399637.22.1771982461746; Tue, 24
 Feb 2026 17:21:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:40 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-6-seanjc@google.com>
Subject: [PATCH 05/14] KVM: x86: Open code read vs. write userspace MMIO exits
 in emulator_read_write()
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
	TAGGED_FROM(0.00)[bounces-71734-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7F7EA18EA21
X-Rspamd-Action: no action

Open code the differences in read vs. write userspace MMIO exits instead
of burying three lines of code behind indirect callbacks, as splitting the
logic makes it extremely hard to track that KVM's handling of reads vs.
write is _significantly_ different.  Add a comment to explain why the
semantics are different, and how on earth an MMIO write ends up triggering
an exit to userspace.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7cbd6f7d8578..5fde5bb010e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8116,8 +8116,6 @@ struct read_write_emulator_ops {
 				  void *val, int bytes);
 	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       int bytes, void *val);
-	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
-				    void *val, int bytes);
 	bool write;
 };
 
@@ -8139,31 +8137,14 @@ static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
 	return vcpu_mmio_write(vcpu, gpa, bytes, val);
 }
 
-static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
-			  void *val, int bytes)
-{
-	return X86EMUL_IO_NEEDED;
-}
-
-static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
-			   void *val, int bytes)
-{
-	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
-
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
-	return X86EMUL_CONTINUE;
-}
-
 static const struct read_write_emulator_ops read_emultor = {
 	.read_write_emulate = read_emulate,
 	.read_write_mmio = vcpu_mmio_read,
-	.read_write_exit_mmio = read_exit_mmio,
 };
 
 static const struct read_write_emulator_ops write_emultor = {
 	.read_write_emulate = write_emulate,
 	.read_write_mmio = write_mmio,
-	.read_write_exit_mmio = write_exit_mmio,
 	.write = true,
 };
 
@@ -8296,7 +8277,19 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
 	vcpu->run->mmio.phys_addr = frag->gpa;
 
-	return ops->read_write_exit_mmio(vcpu, frag->gpa, val, bytes);
+	/*
+	 * For MMIO reads, stop emulating and immediately exit to userspace, as
+	 * KVM needs the value to correctly emulate the instruction.  For MMIO
+	 * writes, continue emulating as the write to MMIO is a side effect for
+	 * all intents and purposes.  KVM will still exit to userspace, but
+	 * after completing emulation (see the check on vcpu->mmio_needed in
+	 * x86_emulate_instruction()).
+	 */
+	if (!ops->write)
+		return X86EMUL_IO_NEEDED;
+
+	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	return X86EMUL_CONTINUE;
 }
 
 static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
-- 
2.53.0.414.gf7e9f6c205-goog


