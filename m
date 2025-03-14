Return-Path: <kvm+bounces-41110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B708A6197D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0DF81737B8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CBD204C23;
	Fri, 14 Mar 2025 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjZ8JQcV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D54155747
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977271; cv=none; b=Ch5QPdPiDkrGdCOhIh1gab0eFxmKK5iHlhRPk50Om4Uh6jSdYaf/TLVwvRSvwTywAhViNJtujxchZ557yI+6sKdcv+9GD7zpLmM52iJuzUgER4VzqzVcc1LRvW+Gq4avHST1WCVby3CYRb7ab730AQhsgLL1v9c1wH4iNp1FOHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977271; c=relaxed/simple;
	bh=68btkTWWTRCQDsmiLtcpZcOEbnclaQWbjBWVbPwDxaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4dS8DlQmVuDTABwlCsEOUQiGLxvQxyqXiNW3S12KpTlZpvs73j2b9FyMJA7jB7DwzichmfXUpn0kQqIZcpZeDrEH9dkfuB53TQXUu4Hdf9zOLGa1yW16j0QjzIcY1lkfxtEZuBPHkUyTaaAwUCzQ8P+lZuUIqZICGLPodLxPxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GjZ8JQcV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741977268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hGTkI9w71jP6QTvlEK4FfH9TdAkK03errukJ7JcVf4=;
	b=GjZ8JQcV310ORLUr2owcpdADtCdUe+VQyoHlcmjDcM5SGMjJ7vRDhs8XzgArh4XdVAtmoe
	SmSE2DpnaI3VFUiyH/vxns1+GhyefhJp+lO4802o3MuYUWY1hkI2oCyGh5/EpOQTinpRL4
	52UNV9POsv5hUZBPDR3i5jMOnDLUe6I=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-ipG6cA7bMPG9Zbk4UXKNLg-1; Fri,
 14 Mar 2025 14:34:27 -0400
X-MC-Unique: ipG6cA7bMPG9Zbk4UXKNLg-1
X-Mimecast-MFC-AGG-ID: ipG6cA7bMPG9Zbk4UXKNLg_1741977266
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32A2319560B4;
	Fri, 14 Mar 2025 18:34:26 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 591ED180175A;
	Fri, 14 Mar 2025 18:34:25 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	nikunj@amd.com,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 2/2] KVM: x86: Add infrastructure for secure TSC
Date: Fri, 14 Mar 2025 14:34:22 -0400
Message-ID: <20250314183422.2990277-3-pbonzini@redhat.com>
In-Reply-To: <20250314183422.2990277-1-pbonzini@redhat.com>
References: <20250314183422.2990277-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add guest_tsc_protected member to struct kvm_arch_vcpu and prohibit
changing TSC offset/multiplier when guest_tsc_protected is true.

X86 confidential computing technology defines protected guest TSC so that
the VMM can't change the TSC offset/multiplier once vCPU is initialized.
SEV-SNP defines Secure TSC as optional, whereas TDX mandates it.

KVM has common logic on x86 that tries to guess or adjust TSC
offset/multiplier for better guest TSC and TSC interrupt latency
at KVM vCPU creation (kvm_arch_vcpu_postcreate()), vCPU migration
over pCPU (kvm_arch_vcpu_load()), vCPU TSC device attributes
(kvm_arch_tsc_set_attr()) and guest/host writing to TSC or TSC adjust MSR
(kvm_set_msr_common()).

The current x86 KVM implementation conflicts with protected TSC because the
VMM can't change the TSC offset/multiplier.
Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
offset/multiplier, the TSC timer interrupts is injected to the guest at the
wrong time if the KVM TSC offset is different from what the TDX module
determined.

Originally this issue was found by cyclic test of rt-test [1] as the
latency in TDX case is worse than VMX value + TDX SEAMCALL overhead.  It
turned out that the KVM TSC offset is different from what the TDX module
determines.

Disable or ignore the KVM logic to change/adjust the TSC offset/multiplier
somehow, thus keeping the KVM TSC offset/multiplier the same as the
value of the TDX module.  Writes to MSR_IA32_TSC are also blocked as
they amount to a change in the TSC offset.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..ee55d1f753e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1053,6 +1053,7 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+	bool guest_tsc_protected;
 
 	/*
 	 * Set when PDPTS were loaded directly by the userspace without
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2da75bbf7f94..053547fc6f89 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2569,6 +2569,9 @@ EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 {
+	if (vcpu->arch.guest_tsc_protected)
+		return;
+
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
 				   vcpu->arch.l1_tsc_offset,
 				   l1_offset);
@@ -2632,6 +2635,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 
+	if (vcpu->arch.guest_tsc_protected)
+		return;
+
 	if (user_set_tsc)
 		vcpu->kvm->arch.user_set_tsc = true;
 
@@ -3907,7 +3913,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
 			kvm_synchronize_tsc(vcpu, &data);
-		} else {
+		} else if (!vcpu->arch.guest_tsc_protected) {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
@@ -4987,7 +4993,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
-			vcpu->arch.tsc_catchup = 1;
+			if (!vcpu->arch.guest_tsc_protected)
+				vcpu->arch.tsc_catchup = 1;
 		}
 
 		if (kvm_lapic_hv_timer_in_use(vcpu))
-- 
2.43.5


