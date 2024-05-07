Return-Path: <kvm+bounces-16861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96678BE811
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16F811C20E3E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7F316D4D0;
	Tue,  7 May 2024 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7UWObKc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8782F16ABC1
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097505; cv=none; b=Ksic893j1tLn614Tbw6JiGWRtfkAgtPdMrS8tMXjr0NhByzDWQKGoC+07+NwRkxxTTP0HA+zR73t0uTDDIVXqnwOjKRDFzpXJ4XYqPGonGzx8lqJu5t0aiXZkJYcDlVSfnJKYlbkiDz/qKScIgjNJXaKig1KhOGg/DIf/dXUExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097505; c=relaxed/simple;
	bh=AwlqnsCSKXmL+zh7tGroTBL13MxtFzkuzy2rZlOyj3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ktKWWm4jHMC/wgrAohicgErI8VcPwje4mmYCo6/XBkk3VUQNjgAqwABpt3G4BEhUqFPvKdU6hNzAQnQIg9XWEAfzryKIApM9tNGy09KivS6GIbIM+QAi/HGaAUCRInyDpUNCQheFAlREwZggMddy1huvO7eTdI6wqndurSE3W68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g7UWObKc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PXxjl50hEC2qppHKNMFhSPiYPocMPg5Dd/CMdIJMIV0=;
	b=g7UWObKc7k9DyMwyiQ8gPFdFYyUUsq7sRwaXw/RqwB6sdey5ZiyFhgNC3j4bGwyJJKBPFw
	F8o+ZEXhRrl8tPnBtzeYFLaU4wXcEyf4xsXT5FBChfJ1hTfD0aev2JJAiv2ShNzgmnSz6p
	9yXLiCj+IzyYa15M1+3rtN3HEb49e7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-jNxS35wVOeWvEGg1J_5CaA-1; Tue, 07 May 2024 11:58:19 -0400
X-MC-Unique: jNxS35wVOeWvEGg1J_5CaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 115AB80027F;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E46D0200B2F6;
	Tue,  7 May 2024 15:58:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 06/17] KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are non-zero
Date: Tue,  7 May 2024 11:58:06 -0400
Message-ID: <20240507155817.3951344-7-pbonzini@redhat.com>
In-Reply-To: <20240507155817.3951344-1-pbonzini@redhat.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

WARN if bits 63:32 are non-zero when handling an intercepted legacy #PF,
as the error code for #PF is limited to 32 bits (and in practice, 16 bits
on Intel CPUS).  This behavior is architectural, is part of KVM's ABI
(see kvm_vcpu_events.error_code), and is explicitly documented as being
preserved for intecerpted #PF in both the APM:

  The error code saved in EXITINFO1 is the same as would be pushed onto
  the stack by a non-intercepted #PF exception in protected mode.

and even more explicitly in the SDM as VMCS.VM_EXIT_INTR_ERROR_CODE is a
32-bit field.

Simply drop the upper bits if hardware provides garbage, as spurious
information should do no harm (though in all likelihood hardware is buggy
and the kernel is doomed).

Handling all upper 32 bits in the #PF path will allow moving the sanity
check on synthetic checks from kvm_mmu_page_fault() to npf_interception(),
which in turn will allow deriving PFERR_PRIVATE_ACCESS from AMD's
PFERR_GUEST_ENC_MASK without running afoul of the sanity check.

Note, this is also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)
and AMD uses bit 31 for RMP (highest bit on AMD CPUs); using the highest
bit minimizes the probability of a collision with the "other" vendor,
without needing to plumb more bits through microcode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 28b1e7657d7f..3609167ba30e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4501,6 +4501,13 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	if (WARN_ON_ONCE(fault_address >> 32))
 		return -EFAULT;
 #endif
+	/*
+	 * Legacy #PF exception only have a 32-bit error code.  Simply drop the
+	 * upper bits as KVM doesn't use them for #PF (because they are never
+	 * set), and to ensure there are no collisions with KVM-defined bits.
+	 */
+	if (WARN_ON_ONCE(error_code >> 32))
+		error_code = lower_32_bits(error_code);
 
 	/* Ensure the above sanity check also covers KVM-defined flags. */
 	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
-- 
2.43.0



