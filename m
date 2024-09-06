Return-Path: <kvm+bounces-26041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9D996FDE5
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16DFA1C21DCB
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C3915CD7A;
	Fri,  6 Sep 2024 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q0GkqLiO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7800A15C132
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725661124; cv=none; b=AV95I4atccpJxA4AWfHdiUYTpvpsltGgI8Anue1g8tXXUXFyUzb/JCKyfVZpfTJLducshyFurQq+OPM66P7/SzrrWT8i4E6rlIr+mSk/xac18lz+Ybkun4hX7ur6qYM5i2pyxL3K4hmOIRYr0T4vX8ABsdT8sGIDMlN2+fRnJvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725661124; c=relaxed/simple;
	bh=6tQZjmV/dvfRxF9Li6PheFfIYhVI74ziIhgSAvvVHBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nm5WoxhTgzdsrZo3Av0U/vri23LfffxH4AdSG1/rWiyKMKCkaS+kmgtEFUNZ3sXWNQGNvNALLgWJiBG2O6Ko5CrOkb/YXMyuSVKpMFWVhYb6Jo6+s8DLFLfPiAD1r6wu7HzmUGIfphFeLNQfpAdZTNyJaO9sfvarxjiD/VJQEI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q0GkqLiO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725661121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0h7tDFpwf6rA/v9oZ6Iu/uTgVzCCOgBsTcrjPUAZ4Jg=;
	b=Q0GkqLiOxKZ1+Az1wn7UPxVtoun+e6EhwHy3nHigGhfM/2nSFUajZQYm4tfliXAznk5mhR
	dWCs/0KE8XohcOI7YrJyPoJJ+5LjmplZKp80oIxdMxF3f1y9R5LMO9UkDMBQOtZJ0JB156
	2hzw0K1wNUrdrv4YYz2Xp2wTVuZMTv8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-zx0tJ60dNVO2KPtU0Q28dg-1; Fri,
 06 Sep 2024 18:18:40 -0400
X-MC-Unique: zx0tJ60dNVO2KPtU0Q28dg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61B1B19560B2;
	Fri,  6 Sep 2024 22:18:38 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CB2C19560AA;
	Fri,  6 Sep 2024 22:18:35 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 4/4] KVM: nVMX: fix canonical check of vmcs12 HOST_RIP
Date: Fri,  6 Sep 2024 18:18:24 -0400
Message-Id: <20240906221824.491834-5-mlevitsk@redhat.com>
In-Reply-To: <20240906221824.491834-1-mlevitsk@redhat.com>
References: <20240906221824.491834-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

HOST_RIP canonical check should check the L1 of CR4.LA57 stored in
the vmcs12 rather than the current L1's because it is legal to change
the CR4.LA57 value during VM exit from L2 to L1.

This is a theoretical bug though, because it is highly unlikely that a
VM exit will change the CR4.LA57 from the value it had on VM entry.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a7b0674094473..38c9d3077d17a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2969,6 +2969,17 @@ static int nested_vmx_check_address_space_size(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
+{
+	/*
+	 * Check that the given linear address is canonical after a VM exit
+	 * from L2, based on HOST_CR4.LA57 value that will be loaded then.
+	 */
+	u8 l1_address_bits_on_exit = (vmcs12->host_cr4 & X86_CR4_LA57) ? 57 : 48;
+
+	return !__is_canonical_address(la, l1_address_bits_on_exit);
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -3019,7 +3030,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(is_noncanonical_base_address(vmcs12->host_gdtr_base, vcpu)) ||
 	    CC(is_noncanonical_base_address(vmcs12->host_idtr_base, vcpu)) ||
 	    CC(is_noncanonical_base_address(vmcs12->host_tr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu, 0)))
+	    CC(is_l1_noncanonical_address_on_vmexit(vmcs12->host_rip, vmcs12)))
 		return -EINVAL;
 
 	/*
-- 
2.26.3


