Return-Path: <kvm+bounces-33763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B359F16A1
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A11028858B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 19:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B9B1F37D5;
	Fri, 13 Dec 2024 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DkjgQu8F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F31F1F2386
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734118907; cv=none; b=G8q1C3vYXJFnzP9tF/Ihy07Hb9BYGOwMoqNGFmJN8kfYcDPpDKBfIt9FML4phwzUlgS4mG0+71TtdO2AvHcQNn5+qFc0DY/bGbvUeZ5piNqliLAtZHI15F78OdnEGhqP8tnjgIu6BDTvTUsUbgupkPNXj/vedxVFxdx/+6xAL/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734118907; c=relaxed/simple;
	bh=Yh+sne4IpfqCJSwrc1iRvM2s6394h3cXE90gTTysKLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i6U9BIjxf7QCZfuB9z7xpPxL3721zypKiC34RA+7jyFo1TA53/c/RETyUxkGSiSiTwnKYshd43TO2WhtiqqQcTCHnZm69oaKwmssDl5K2j/8sq9M/Su2FtBHW1+CCGFtEEqaDSA9pDL6VvuC00Uzs1zvWQAd9oGQwJvtdoCFYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DkjgQu8F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734118903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wVuHcWlwHXbKjGdfLpNkCYLXye6nsoXJz08iuoO6Nbc=;
	b=DkjgQu8FIgN3oZuCNeuBQgjGH+l5c1Ct4liQ2Y05khz0cFUTEXWOtGnW5W6YbgIjJH2wAU
	2YkBIXS9U4foObiQYClY6QMk98dnwr5HVL9DwraGwjbMuAFjj9XDwzlMp1VUfQMlHGB7uF
	q7k84di0dHWPtPoDPKtVT/fdfXUEM6c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-oCsgWXqENNmU8kI3BFUZNA-1; Fri,
 13 Dec 2024 14:41:40 -0500
X-MC-Unique: oCsgWXqENNmU8kI3BFUZNA-1
X-Mimecast-MFC-AGG-ID: oCsgWXqENNmU8kI3BFUZNA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC1331956064;
	Fri, 13 Dec 2024 19:41:38 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DBF611955F41;
	Fri, 13 Dec 2024 19:41:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH] KVM: x86: clear vcpu->run->hypercall.ret before exiting for KVM_EXIT_HYPERCALL
Date: Fri, 13 Dec 2024 14:41:37 -0500
Message-ID: <20241213194137.315304-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

QEMU up to 9.2.0 is assuming that vcpu->run->hypercall.ret is 0 on exit and
it never modifies it when processing KVM_EXIT_HYPERCALL.  Make this explicit
in the code, to avoid breakage when KVM starts modifying that field.

This in principle is not a good idea... It would have been much better if
KVM had set the field to -KVM_ENOSYS from the beginning, so that a dumb
userspace that does nothing on KVM_EXIT_HYPERCALL would tell the guest it
does not support KVM_HC_MAP_GPA_RANGE.  However, breaking userspace is
a Very Bad Thing, as everybody should know.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 14 ++++++++++++++
 arch/x86/kvm/x86.c     |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..9ffb0fb5aacd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3634,6 +3634,13 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 
 	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
 	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+	/*
+	 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
+	 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
+	 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
+	 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
+	 */
+	vcpu->run->hypercall.ret = 0;
 	vcpu->run->hypercall.args[0] = gpa;
 	vcpu->run->hypercall.args[1] = 1;
 	vcpu->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
@@ -3797,6 +3804,13 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	case VMGEXIT_PSC_OP_SHARED:
 		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
 		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+		/*
+		 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
+		 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
+		 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
+		 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
+		 */
+		vcpu->run->hypercall.ret = 0;
 		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
 		vcpu->run->hypercall.args[1] = npages;
 		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..705fa475179f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10052,6 +10052,13 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 
 		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
 		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
+		/*
+		 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
+		 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
+		 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
+		 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
+		 */
+		vcpu->run->hypercall.ret = 0;
 		vcpu->run->hypercall.args[0]  = gpa;
 		vcpu->run->hypercall.args[1]  = npages;
 		vcpu->run->hypercall.args[2]  = attrs;
-- 
2.43.5


