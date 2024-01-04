Return-Path: <kvm+bounces-5682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 319078249EB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B0281F23362
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 21:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4B32C86B;
	Thu,  4 Jan 2024 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5T11Zdb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E941225D2
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704402003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9dVx1CFWN6pbrkgANRFGwDcyMCsqocFrWeybbXojmg=;
	b=a5T11ZdbJ9JC1hQh/ROQCG7D5ide7TazUpy1BT/hmaJl52Q9JQN6NoMNfgB0OdrXDzaFBi
	Scf2VwEPBAtwlfxncp2XUegHbtLt0OHnt1sSbnLeSRanbrmeN06AEz4MZgu3SLJgbOaRf3
	6bD3nYij747q7uTZofyrc6PuQd7ajj4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-EQHRe4WKN7qeYrD0uLNRUw-1; Thu,
 04 Jan 2024 16:00:00 -0500
X-MC-Unique: EQHRe4WKN7qeYrD0uLNRUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DB3A1C0515D;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21C641121312;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: ajones@ventanamicro.com
Subject: [PATCH 1/4] KVM: introduce CONFIG_KVM_COMMON
Date: Thu,  4 Jan 2024 15:59:56 -0500
Message-Id: <20240104205959.4128825-2-pbonzini@redhat.com>
In-Reply-To: <20240104205959.4128825-1-pbonzini@redhat.com>
References: <20240104205959.4128825-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

CONFIG_HAVE_KVM is currently used by some architectures to either
enabled the KVM config proper, or to enable host-side code that is
not part of the KVM module.  However, the "select" statement in
virt/kvm/Kconfig corresponds to a third meaning, namely to
enable common Kconfigs required by all architectures that support
KVM.

These three meanings can be replaced respectively by an
architecture-specific Kconfig, by IS_ENABLED(CONFIG_KVM), or by
a new Kconfig symbol that is in turn selected by the
architecture-specific "config KVM".

Start by introducing such a new Kconfig symbol, CONFIG_KVM_COMMON.
Unlike CONFIG_HAVE_KVM, it is selected by CONFIG_KVM, not by
architecture code.

Fixes: 8132d887a702 ("KVM: remove CONFIG_HAVE_KVM_EVENTFD", 2023-12-08)
Cc: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/Kconfig     | 1 +
 arch/loongarch/kvm/Kconfig | 1 +
 arch/mips/kvm/Kconfig      | 1 +
 arch/powerpc/kvm/Kconfig   | 1 +
 arch/riscv/kvm/Kconfig     | 1 +
 arch/s390/kvm/Kconfig      | 1 +
 arch/x86/kvm/Kconfig       | 1 +
 virt/kvm/Kconfig           | 3 +++
 8 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index b07c60c9737d..ad5ce0454f17 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -21,6 +21,7 @@ if VIRTUALIZATION
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
+	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index daba4cd5e87d..3b284b7e63ad 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	depends on HAVE_KVM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 428141b0b48f..2eb119e78b6e 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	depends on MIPS_FP_SUPPORT
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
+	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index b47196085a42..5da535e20b6a 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select PREEMPT_NOTIFIERS
+	select KVM_COMMON
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 1fd76aee3b71..55f81377d260 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index bb6d90351119..f89bedbe63bd 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -25,6 +25,7 @@ config KVM
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
+	select KVM_COMMON
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b07247b0b958..c8e62a371d24 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	depends on HIGH_RES_TIMERS
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
+	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 6793211a0b64..cce5c03ecc92 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -3,6 +3,9 @@
 
 config HAVE_KVM
        bool
+
+config KVM_COMMON
+       bool
        select EVENTFD
 
 config HAVE_KVM_PFNCACHE
-- 
2.39.1



