Return-Path: <kvm+bounces-34182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD6A9F8792
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DD3C7A1A24
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 22:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CAAC1EE7D8;
	Thu, 19 Dec 2024 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUdTviV6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB71D79B1
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 22:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734646251; cv=none; b=Slp3PUUFVkT4DBJLIS0DiGWSsKKfb3H/svs7JPtHOKJtfqdV4ToIZ37Opy8/zO54txbOrrdmngmouFpGXktnG7A3ERIr4N+6i1LTU16qFxw6Q7XpIu+zk6lajL9PefXjUKzOlEZISTgl8dCEd/imwURNB1wEVpJr3giIA1DCc9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734646251; c=relaxed/simple;
	bh=Zhhm0ZpcBmst9JD3aVZLS37xkX0mSzRrgXUOWlXrNJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=om167DEfsZkN6lvK5vYCUTkst+UPoWAhsiTwqKckUktav/pTrzSnLV+tyUx2R+LghfHQPD6Px1udLv2G/+iup22xng22PApwtJbtortd0/C+HPnnFL1bojTWYGLPS5wZHm4WZbtHBysQpedG0H+KE3LMtGJfVgJpJ+9sbmXm/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BUdTviV6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734646247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O80D5yXFQRMxzbQOj64sE8dgntjB5gQ4EubvDrxxqXM=;
	b=BUdTviV6VWzHH/w2P2sI/xego122cCL9x/d5udCP/sPcA9in7MUiVE9oMrpI20UGZpWRBD
	BJ8HduzROMFmOwYbd3Z1DNLLRO0qGcpctmBMyN3EqjJIrrYDFbt4nC510C5xSLijeFa1sR
	s8Djzrryr5ZRna7AXOcx91xwwIXhMu4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-gaDJbv7bPE6Cdz50KGKLuQ-1; Thu,
 19 Dec 2024 17:10:44 -0500
X-MC-Unique: gaDJbv7bPE6Cdz50KGKLuQ-1
X-Mimecast-MFC-AGG-ID: gaDJbv7bPE6Cdz50KGKLuQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 677BE1955EB9;
	Thu, 19 Dec 2024 22:10:42 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.181])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E2101953953;
	Thu, 19 Dec 2024 22:10:40 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-kselftest@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] KVM: VMX: read the PML log in the same order as it was written
Date: Thu, 19 Dec 2024 17:10:34 -0500
Message-Id: <20241219221034.903927-3-mlevitsk@redhat.com>
In-Reply-To: <20241219221034.903927-1-mlevitsk@redhat.com>
References: <20241219221034.903927-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Intel's PRM specifies that the CPU writes to the PML log 'backwards'
or in other words, it first writes entry 511, then entry 510 and so on.

I also confirmed on the bare metal that the CPU indeed writes the entries
in this order.

KVM on the other hand, reads the entries in the opposite order, from the
last written entry and towards entry 511 and dumps them in this order to
the dirty ring.

Usually this doesn't matter, except for one complex nesting case:

KVM reties the instructions that cause MMU faults.
This might cause an emulated PML log entry to be visible to L1's hypervisor
before the actual memory write was committed.

This happens when the L0 MMU fault is followed directly by the VM exit to
L1, for example due to a pending L1 interrupt or due to the L1's
'PML log full' event.

This problem doesn't have a noticeable real-world impact because this
write retry is not much different from the guest writing to the same page
multiple times, which is also not reflected in the dirty log. The users of
the dirty logging only rely on correct reporting of the clean pages, or
in other words they assume that if a page is clean, then no writes were
committed to it since the moment it was marked clean.

However KVM has a kvm_dirty_log_test selftest, a test that tests both
the clean and the dirty pages vs the memory contents, and can fail if it
detects a dirty page which has an old value at the offset 0 which the test
writes.

To avoid failure, the test has a workaround for this specific problem:

The test skips checking memory that belongs to the last dirty ring entry,
which it has seen, relying on the fact that as long as memory writes are
committed in-order, only the last entry can belong to a not yet committed
memory write.

However, since L1's KVM is reading the PML log in the opposite direction
that L0 wrote it, the last dirty ring entry often will be not the last
entry written by the L0.

To fix this, switch the order in which KVM reads the PML log.

Note that this issue is not present on the bare metal, because on the
bare metal, an update of the A/D bits of a present entry, PML logging and
the actual memory write are all done by the CPU without any hypervisor
intervention and pending interrupt evaluation, thus once a PML log and/or
vCPU kick happens, all memory writes that are in the PML log are
committed to memory.

The only exception to this rule is when the guest hits a not present EPT
entry, in which case KVM first reads (backward) the PML log, dumps it to
the dirty ring, and *then* sets up a SPTE entry with A/D bits set, and logs
this to the dirty ring, thus making the entry be the last one in the
dirty ring.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 30fc54eefeb4..25ea43a8efb2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6211,25 +6211,33 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 *pml_buf;
-	u16 pml_idx;
+	u16 pml_idx, pml_tail_index;
+	int i;
 
 	pml_idx = vmcs_read16(GUEST_PML_INDEX);
 
 	/* Do nothing if PML buffer is empty */
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
+	/*
+	 * PML index always points to the next available PML buffer entity
+	 * unless PML log has just overflowed.
+	 */
+	pml_tail_index = (pml_idx >= PML_LOG_NR_ENTRIES) ? 0 : pml_idx + 1;
 
-	/* PML index always points to next available PML buffer entity */
-	if (pml_idx >= PML_LOG_NR_ENTRIES)
-		pml_idx = 0;
-	else
-		pml_idx++;
-
+	/*
+	 * PML log is written backwards: the CPU first writes the entry 511
+	 * then the entry 510, and so on.
+	 *
+	 * Read the entries in the same order they were written, to ensure that
+	 * the dirty ring is filled in the same order the CPU wrote them.
+	 */
 	pml_buf = page_address(vmx->pml_pg);
-	for (; pml_idx < PML_LOG_NR_ENTRIES; pml_idx++) {
+
+	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
 		u64 gpa;
 
-		gpa = pml_buf[pml_idx];
+		gpa = pml_buf[i];
 		WARN_ON(gpa & (PAGE_SIZE - 1));
 		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
 	}
-- 
2.26.3


