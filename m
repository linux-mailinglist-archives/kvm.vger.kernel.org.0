Return-Path: <kvm+bounces-10944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F8B871BF3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A922F1C22710
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67EA557899;
	Tue,  5 Mar 2024 10:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="csJy+wEZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98C535DC
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634917; cv=none; b=T7wpT2TP4LKG0tllUwn5gSRhcFSSjodqK+nwsBLh4heqFhYmRkOiWpOax35hm1c/tZb/grIp1xjeasAmTzixqzv/t4+LfPeWsoUyF1sES+9DusL1EaOWC/z3/NDe6xUF5nN315z38EKflkGe8BYoiupdAac461GTCDPPYO6GLR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634917; c=relaxed/simple;
	bh=rD7LNIXQgytgk1SuBjjFtl3xeLRotb12aTcaosK398I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MlsJeqRJ7bGB49r6uv0c5q/Qh+RJGF9DykJCRIvhlB8X9b+KKxnSCIttbAD2LdsXegDqu2oNQSmfVc55nd4vDBfDXAMZi2OWmG+v84Hmj4z9GfPnku5lrE8J4wwv5730+GmCRqREcfFPZ175IEIqv6Y6Aqk1Ov4oASHrZ9ksKjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=csJy+wEZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709634914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NbpRvhegxzAibgmjukvrlXm7mMqQtfg7UO/OQspIw34=;
	b=csJy+wEZpz8UmMEDkE4gh2FT1lGPN8rNsJ4oR3Ak6BKjQw8GPuYSnvY//xkiyR5EToLpe5
	vm60gjueuLLp3iRCHqICrk7CUW2yBp8R2INpWMYy/mlmz38UlTYAFBkMXB59BL6T8pFqdL
	5UmWmudxnv4oqOwRQDL6nfaaChYemfY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-TVz_IhSJNWKUXLei6GDKIQ-1; Tue, 05 Mar 2024 05:35:09 -0500
X-MC-Unique: TVz_IhSJNWKUXLei6GDKIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7A45803F60;
	Tue,  5 Mar 2024 10:35:08 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F53D111FE;
	Tue,  5 Mar 2024 10:35:08 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id F363218000B2; Tue,  5 Mar 2024 11:35:06 +0100 (CET)
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
Subject: [PATCH v2] kvm: set guest physical bits in CPUID.0x80000008
Date: Tue,  5 Mar 2024 11:35:06 +0100
Message-ID: <20240305103506.613950-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Set CPUID.0x80000008:EAX[23:16] to guest phys bits, i.e. the bits which
are actually addressable.  In most cases this is identical to the host
phys bits, but tdp restrictions (no 5-level paging) can limit this to
48.

Quoting AMD APM (revision 3.35):

  23:16 GuestPhysAddrSize Maximum guest physical address size in bits.
                          This number applies only to guests using nested
                          paging. When this field is zero, refer to the
                          PhysAddrSize field for the maximum guest
                          physical address size. See “Secure Virtual
                          Machine” in APM Volume 2.

Tom Lendacky confirmed the purpose of this field is software use,
hardware always returns zero here.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/cpuid.c   |  3 ++-
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..42b5212561c8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
 
+int kvm_mmu_get_guest_phys_bits(void);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..12037f1b017e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1240,7 +1240,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		else if (!g_phys_as)
 			g_phys_as = phys_as;
 
-		entry->eax = g_phys_as | (virt_as << 8);
+		entry->eax = g_phys_as | (virt_as << 8)
+			| kvm_mmu_get_guest_phys_bits() << 16;
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..8bebb3e96c8a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5267,6 +5267,21 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 	return max_tdp_level;
 }
 
+/*
+ * return the actually addressable guest phys bits, which might be
+ * less than host phys bits due to tdp restrictions.
+ */
+int kvm_mmu_get_guest_phys_bits(void)
+{
+	if (tdp_enabled && shadow_phys_bits > 48) {
+		if (tdp_root_level && tdp_root_level != PT64_ROOT_5LEVEL)
+			return 48;
+		if (max_tdp_level != PT64_ROOT_5LEVEL)
+			return 48;
+	}
+	return shadow_phys_bits;
+}
+
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_cpu_role cpu_role)
-- 
2.44.0


