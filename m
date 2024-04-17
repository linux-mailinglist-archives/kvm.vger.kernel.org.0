Return-Path: <kvm+bounces-14984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B580C8A87C4
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68451C21776
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C4D15CD59;
	Wed, 17 Apr 2024 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TWTl87f1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB61482E0
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368100; cv=none; b=K1WWN29JeTR0nC4g6Va7oFa6X9Jw5jb/D9/boChYXuWOX0b48GDr3n+UHgXch0W/4w6QMdm/pUliuwvDKtQCfkDS8Vgrs4aVDTfcUJnAniDJ3RpqgAsYI761jt9HoIPYNGjOi2mcr0Wm3ixwgrh8HciZBziFKdpSG41zpt6D39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368100; c=relaxed/simple;
	bh=G4BeGUCOTVOkjx4yq6ODKlpxEE4XU7Y7irIUQ5bbs2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZkqNCjjFPNaG1uTCQ0DWeyZJUcY18bYsIRgcUYBcOFC6AnRn9Uex460lJvIvpP1QsTmapLA9ShCBNZ6BRPcTppMu9xpaxs13N6XXjStW21bk1cyKperxmVdbD3HFR/JT3Y2NfMiwYu2huBlC6xwd+LgnX/STau/4XNCyIqnJT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TWTl87f1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/d1W9bLkoHDklV8ryGGFJMux2mNI4+NsiCtwVFElLs=;
	b=TWTl87f1PqTJIc/tn3BZOYNjcWSFptz1CRpcb1KprHIrVSPjJUH0gu5CtGIXRh/m0FxYs1
	3CW2CFoSMugWXSXxH9Sx2z17/PDuDtqyt+uAiT6c0tCsjzRoEUxuQ4+ymusAonMtnsx+HP
	Ine4+PKgmdEDCPKHKAQ/zcD7aHtAz4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-FMU6Mw0mOXiB4R0LUQNZSA-1; Wed, 17 Apr 2024 11:34:53 -0400
X-MC-Unique: FMU6Mw0mOXiB4R0LUQNZSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA724188ACB0;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79DF4581CD;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 6/7] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Date: Wed, 17 Apr 2024 11:34:49 -0400
Message-ID: <20240417153450.3608097-7-pbonzini@redhat.com>
In-Reply-To: <20240417153450.3608097-1-pbonzini@redhat.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
memory.  When KVM_CREATE_VCPU creates vCPU, it initializes the x86
KVM MMU part by kvm_mmu_create() and kvm_init_mmu().  vCPU is ready to
invoke the KVM page fault handler.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig |  1 +
 arch/x86/kvm/x86.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7632fe6e4db9..e58360d368ec 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_GENERIC_MAP_MEMORY
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83b8260443a3..f84c75c2a47f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
+	case KVM_CAP_MAP_MEMORY:
+		r = tdp_enabled;
+		break;
 	case KVM_CAP_EXIT_HYPERCALL:
 		r = KVM_EXIT_HYPERCALL_VALID_MASK;
 		break;
@@ -5867,6 +5870,46 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			     struct kvm_map_memory *mapping)
+{
+	u64 mapped, end, error_code = 0;
+	u8 level = PG_LEVEL_4K;
+	int r;
+
+	/*
+	 * Shadow paging uses GVA for kvm page fault.  The first implementation
+	 * supports GPA only to avoid confusion.
+	 */
+	if (!tdp_enabled)
+		return -EOPNOTSUPP;
+
+	/*
+	 * reload is efficient when called repeatedly, so we can do it on
+	 * every iteration.
+	 */
+	kvm_mmu_reload(vcpu);
+
+	if (kvm_arch_has_private_mem(vcpu->kvm) &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(mapping->base_address)))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
+	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
+	if (r)
+		return r;
+
+	/*
+	 * level can be more than the alignment of mapping->base_address if
+	 * the mapping can use a huge page.
+	 */
+	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
+		KVM_HPAGE_SIZE(level);
+	mapped = min(mapping->size, end - mapping->base_address);
+	mapping->size -= mapped;
+	mapping->base_address += mapped;
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-- 
2.43.0



