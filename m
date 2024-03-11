Return-Path: <kvm+bounces-11528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 918F1877E44
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 486C5282750
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B344239AEC;
	Mon, 11 Mar 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ULWjsCex"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E02383A5
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710153688; cv=none; b=KpRiCM3YqPazNOMJ1brP7sMQyVWcR6aIdwezRQS7p2/F52i7dqTyYyPGL03R55FQXUYdveHUeat/CAuMeRjXAXemmYysaSv/cZD19PLOWye++gE+J8FbCcfDWDAMbPQUxS2RejOko3NoQ/Pl7+pb+upS/qbAFGjKGavoDdo8mNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710153688; c=relaxed/simple;
	bh=wNQWV9m5lg2Q/ZLIsshGqcqhSd7zUgPrvwwLBsVQSOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLEXBV0YwFrn0B2+k9F5goJ06dYVEy4wnjlCV22IuBPyuhl7ik63uFpFMqNQvkOrshjliZRMIIaStE9TpRx7qBW/OvPLpC0E5uJ2MwOPGssydF9JBKFikhbah8FC1b+7qdbQXlRllj0VtefMzj0dpb5XBryVuohriV1nMV/J4Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ULWjsCex; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710153686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdFoJ0S3Ws2r5D6hxRfBUYjuRbcIe+72RXvO0x96RWs=;
	b=ULWjsCexfaunKaFOocEma1ntNjpu2hD8DQHqLMPdzumiFBXujbxxsHfGxLwwrp4YEbPd9u
	5+ZSY/E2KnB1A/ITuW7qEMxHYfMSCZ5ZVJcBRGZUHYbMOONhTdDk67hY1f6GF3spdpSgMP
	rudhfxwyAixHSlM0A7eS3tv9HqxlzLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-zr7cbkAyO46agYXBu59uFQ-1; Mon, 11 Mar 2024 06:41:21 -0400
X-MC-Unique: zr7cbkAyO46agYXBu59uFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F1FC18A6385;
	Mon, 11 Mar 2024 10:41:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89A8640C6CB8;
	Mon, 11 Mar 2024 10:41:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id B06611801A91; Mon, 11 Mar 2024 11:41:18 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v3 2/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
Date: Mon, 11 Mar 2024 11:41:17 +0100
Message-ID: <20240311104118.284054-3-kraxel@redhat.com>
In-Reply-To: <20240311104118.284054-1-kraxel@redhat.com>
References: <20240311104118.284054-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

The AMD APM (3.35) defines GuestPhysBits (EAX[23:16]) as:

  Maximum guest physical address size in bits.  This number applies
  only to guests using nested paging.  When this field is zero, refer
  to the PhysAddrSize field for the maximum guest physical address size.

Tom Lendacky confirmed that the purpose of GuestPhysBits is software use
and KVM can use it as described below.  Hardware always returns zero
here.

Use the GuestPhysBits field to communicate the max addressable GPA to
the guest.  Typically this is identical to the max effective GPA, except
in case the CPU supports MAXPHYADDR > 48 but does not support 5-level
TDP.

GuestPhysBits is set only in case TDP is enabled, otherwise it is left
at zero.

GuestPhysBits will be used by the guest firmware to make sure resources
like PCI bars are mapped into the addressable GPA.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/cpuid.c   | 31 +++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu.c |  5 +++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..b410a227c601 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
 
+u8 kvm_mmu_get_max_tdp_level(void);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c638b5fb2144..cd627dead9ce 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1221,8 +1221,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0x80000008: {
+		/*
+		 * GuestPhysAddrSize (EAX[23:16]) is intended for software
+		 * use.
+		 *
+		 * KVM's ABI is to report the effective MAXPHYADDR for the
+		 * guest in PhysAddrSize (phys_as), and the maximum
+		 * *addressable* GPA in GuestPhysAddrSize (g_phys_as).
+		 *
+		 * GuestPhysAddrSize is valid if and only if TDP is enabled,
+		 * in which case the max GPA that can be addressed by KVM may
+		 * be less than the max GPA that can be legally generated by
+		 * the guest, e.g. if MAXPHYADDR>48 but the CPU doesn't
+		 * support 5-level TDP.
+		 */
 		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
-		unsigned int phys_as;
+		unsigned int phys_as, g_phys_as;
 
 		if (!tdp_enabled) {
 			/*
@@ -1232,11 +1246,24 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			 * for memory encryption affect shadow paging, too.
 			 */
 			phys_as = boot_cpu_data.x86_phys_bits;
+			g_phys_as = 0;
 		} else {
+			/*
+			 * If TDP is enabled, the effective guest MAXPHYADDR
+			 * is the same as the raw bare metal MAXPHYADDR, as
+			 * reductions to HPAs don't affect GPAs.  The max
+			 * addressable GPA is the same as the max effective
+			 * GPA, except that it's capped at 48 bits if 5-level
+			 * TDP isn't supported (hardware processes bits 51:48
+			 * only when walking the fifth level page table).
+			 */
 			phys_as = entry->eax & 0xff;
+			g_phys_as = phys_as;
+			if (kvm_mmu_get_max_tdp_level() < 5)
+				g_phys_as = min(g_phys_as, 48);
 		}
 
-		entry->eax = phys_as | (virt_as << 8);
+		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..ffd32400fd8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 	return max_tdp_level;
 }
 
+u8 kvm_mmu_get_max_tdp_level(void)
+{
+	return tdp_root_level ? tdp_root_level : max_tdp_level;
+}
+
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_cpu_role cpu_role)
-- 
2.44.0


