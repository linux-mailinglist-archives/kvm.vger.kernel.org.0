Return-Path: <kvm+bounces-54608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC06B253E9
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 21:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 379365A164E
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C268830E82A;
	Wed, 13 Aug 2025 19:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nb8rKPgR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664BC309DC2
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755113011; cv=none; b=S3ooGKHmt6fKOhUpIET+o6c3hlOYjU7BzEDFOkXeahW1MnOhv9OY7fcgqT6kCqpJ1iNZ2nPDsvocuBuuwyLx+kWt96Udu1/MzSt+xDn9Lbo7EdYR0jcAKt0nuvXFhn1O2NrH5SreTplXfsOlCGjzrVn+sS6wgZL+C+xrrou3FPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755113011; c=relaxed/simple;
	bh=WrZiC3yintwTEHzCwmrJW2sxgMlptqFr7NyVVui6y2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXi1UcZRZ9sjfsE3O+iiWC8QoNgoL+myX86sRamcba6c4GFuTn+ESesqum4ff2CKrO1dgeURSw73z6H+6tEyStH0mRHrf05WZKJqbDE3HSO614VUXTKAr4TSv3BbabDwqJ9mPyeo9N/8efUcNHEVfbaNsppOuyl9at+FKdq+q1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nb8rKPgR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755113008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RG8e3jlgteGbX5xrgI1qpHzDVK7pfheXycxrt2lf9j4=;
	b=Nb8rKPgRdMLC7SJgZFkdlga42Rqun8LEB9vEv6TZcwtTM/hszoByYBvTfanAODW8mZZT68
	PYUeh76cCpMewhFqnA7lDV1o7jVANHCZmy0IgOCpeGV8gdqucd1klCmk50CEHGV2v69jpU
	Kh7lmvAdnEQ7kO1QeQ8RQ/NUEslKNC0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-GiD2sf_qM4yT4xtrwpT80w-1; Wed,
 13 Aug 2025 15:23:25 -0400
X-MC-Unique: GiD2sf_qM4yT4xtrwpT80w-1
X-Mimecast-MFC-AGG-ID: GiD2sf_qM4yT4xtrwpT80w_1755113003
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C543A180034F;
	Wed, 13 Aug 2025 19:23:23 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.81.148])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE788195608F;
	Wed, 13 Aug 2025 19:23:21 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: x86: Fix the interaction between SMM and the asynchronous pagefault
Date: Wed, 13 Aug 2025 15:23:13 -0400
Message-ID: <20250813192313.132431-4-mlevitsk@redhat.com>
In-Reply-To: <20250813192313.132431-1-mlevitsk@redhat.com>
References: <20250813192313.132431-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Currently a #SMI can cause KVM to drop an #APF ready event and
subsequently causes the guest to never resume the task that is waiting
for it.
This can result in tasks becoming permanently stuck within the guest.

This happens because KVM flushes the APF queue without notifying the guest
of completed APF requests when the guest exits to real mode.

And the SMM exit code calls kvm_set_cr0 with CR.PE == 0, which triggers
this code.

It must be noted that while this flush is reasonable to do for the actual
real mode entry, it is actually achieves nothing because it is too late to
flush this queue on SMM exit.

To fix this, avoid doing this flush altogether, and handle the real
mode entry/exits in the same way KVM already handles the APIC
enable/disable events:

APF completion events are not injected while APIC is disabled,
and once APIC is re-enabled, KVM raises the KVM_REQ_APF_READY request
which causes the first pending #APF ready event to be injected prior
to entry to the guest mode.

This change also has the side benefit of preserving #APF events if the
guest temporarily enters real mode - for example, to call firmware -
although such usage should be extermery rare in modern operating systems.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 11 +++++++----
 arch/x86/kvm/x86.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d45a4cd08a4..5dfe166025bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1118,15 +1118,18 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 	}
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-
 		/*
 		 * Clearing CR0.PG is defined to flush the TLB from the guest's
 		 * perspective.
 		 */
 		if (!(cr0 & X86_CR0_PG))
 			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
+		/*
+		 * Re-check APF completion events, when the guest re-enables paging.
+		 */
+		if ((cr0 & X86_CR0_PG) && kvm_pv_async_pf_enabled(vcpu))
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
 	}
 
 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
@@ -3547,7 +3550,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
 {
 	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bcfd9b719ada..3949c938a88d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -698,5 +698,6 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 })
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
+bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.49.0


