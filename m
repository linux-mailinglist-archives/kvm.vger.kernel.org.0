Return-Path: <kvm+bounces-71735-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGkMLGVPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71735-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C907918EA1A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13FA131203AF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90745258ED5;
	Wed, 25 Feb 2026 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t7HwgQyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D22690EC
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982466; cv=none; b=CfcmrREZI/NayfFJS5bkxRu4UoofxzgtEXf7n/JyXYnkM24tLCPa12EiBoU9QYN1+Zij/JwTdYSqBNn6z+jhyL1uDo6uZ9rYB4RR70g155PZ+PdAECugSqbtJhsDlqecxDmyKKmsXSPDxpyxW0VhIZiLv97sn+mQQf/0Qj8tSQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982466; c=relaxed/simple;
	bh=7lRp2eCkoo+DRHWUNEDaUBTQXTHdWU47sEkYGqsesug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQGK0QiGSO5uHc0mxfYDrkjcSjkY8TzCNG1fsSOoAFKM+So9o0QhJOD1r7XF1Q+QxNirqqURYyMy9uNBn1f3BquOdwUA2ASRcvaEw5zvYpDfmMnt7jskAxE9ChvA2U3gvtj+QZEqtd4/j+UCndPyFKpGQymVRaZHu/AFi+QmuPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t7HwgQyb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f8b01604so2567639a91.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982464; x=1772587264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gV7BZ60qmf3JAsxc6wDH0RQvnfJYSY1NcM7wseiHg1Y=;
        b=t7HwgQybqbbZUi30gFfENo1IvEUYBHKRNSWdodWfVKUDcAjRnPpqUKGyWoVAF53xDV
         i/tlYY+Z3bbE5sJQCfA2tOHRJJQ3ORd3NIUFhXHqrDVR/31dYplwHkzAWAPxnPe4qpnr
         g3sIEo+e5ICEsCxAeLZOIRXoYwM8s39Vya5zgW5THDZUZs5voTCkcr6AyVZmLTzkyDDa
         q01JqmMTaCNh2i2tNaLGe0rpLIlbC4/ygIwy6pMd+nDeL9miw2YMRdKKqlE+U4VRkU6W
         wy5PPXHD7g6HhSMSD4IFApFfQGbzhAjn3kej138uJ3WtRRIKu1MtvY4k3c+BGcS0JARQ
         OIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982464; x=1772587264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gV7BZ60qmf3JAsxc6wDH0RQvnfJYSY1NcM7wseiHg1Y=;
        b=TbBohRa12pBKSGTSDABln+2DjO70DVJqSlizgq1rQ93x+Pq7XOZ0zeH69CFoDzMpih
         1cYgpXRYqetusf0GYVNiZIUUD3E+rV4dEjPnmiMxIC0ifSV2f0it5B5aSqESSVW24+1h
         OItvAtpo9rgPSEfHJzxNsbThYtU0f5EA0ZKNN3RtJ/eFFG/18KdKQ+hjzxqlqqu4UnFE
         J8lQsYPA02ne4xhXWUG6uy9Re0HLLqFJDNcth/1DEHUKWoAtUnSFpWmLQNffktijm5oo
         5PjBDTCNpAYZ8xAzpNTXrXIPi2cik5BbBMvz5BawqpeqpuG8i5CjZ4kAROsG+yc1w6ZD
         hR5A==
X-Gm-Message-State: AOJu0YwDlaFAWEvr7vUE+tEZqUGDeRXA5j8Gt0kBNo1uqoN0qqrv9JuW
	YxKJdNoqn6AmyldfbKpRFlx8Gem9PrFjBsZUwWZC0cpfDnqUz9G6jDvl6aWvR3/HNcDiwrhKxQz
	0Cig0SA==
X-Received: from pjal2.prod.google.com ([2002:a17:90a:1502:b0:34a:bebf:c162])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5285:b0:354:c629:efaf
 with SMTP id 98e67ed59e1d1-3590f26515dmr508907a91.35.1771982463612; Tue, 24
 Feb 2026 17:21:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:41 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-7-seanjc@google.com>
Subject: [PATCH 06/14] KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-71735-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C907918EA1A
X-Rspamd-Action: no action

Move the invocation of MMIO write tracepoint into vcpu_mmio_write() and
drop its largely-useless wrapper to cull pointless code and to make the
code symmetrical with respect to vcpu_mmio_read().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5fde5bb010e7..7abd6f93c386 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7769,11 +7769,14 @@ static void kvm_init_msr_lists(void)
 }
 
 static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
-			   const void *v)
+			   void *__v)
 {
+	const void *v = __v;
 	int handled = 0;
 	int n;
 
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, addr, __v);
+
 	do {
 		n = min(len, 8);
 		if (!(lapic_in_kernel(vcpu) &&
@@ -8131,12 +8134,6 @@ static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return emulator_write_phys(vcpu, gpa, val, bytes);
 }
 
-static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
-{
-	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, bytes, gpa, val);
-	return vcpu_mmio_write(vcpu, gpa, bytes, val);
-}
-
 static const struct read_write_emulator_ops read_emultor = {
 	.read_write_emulate = read_emulate,
 	.read_write_mmio = vcpu_mmio_read,
@@ -8144,7 +8141,7 @@ static const struct read_write_emulator_ops read_emultor = {
 
 static const struct read_write_emulator_ops write_emultor = {
 	.read_write_emulate = write_emulate,
-	.read_write_mmio = write_mmio,
+	.read_write_mmio = vcpu_mmio_write,
 	.write = true,
 };
 
-- 
2.53.0.414.gf7e9f6c205-goog


