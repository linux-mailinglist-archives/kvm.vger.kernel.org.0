Return-Path: <kvm+bounces-7624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F2C844D52
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4455FB3962C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0994482DF;
	Wed, 31 Jan 2024 23:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1he+ssN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B73C465
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743865; cv=none; b=RlTTtIVZk918uIMs8QanKuXgQcjGI8FFHm3ctRlZjfV6zwvNKSssIfuULZpo8yFERg6C/TcLTix9kcol9rMjX3pBzvpowhEdQBHNB5kv3qgOn4/giiA+71RYVd91O/jPF3vXSn5WjFZ7UQJJ3IGMh7EutVt4YZGohewkLvxWJrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743865; c=relaxed/simple;
	bh=8o3/8syqf7n2/Gv2LAdMhkd0dmDvEMgaYeogylunOwo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lam9fRNc4mkj4+Ly6nqCm9ftjLLhMai6I5OGz/qrbPmr7wWJjCo9WSxSlsA+SsBdgrLD+Mg1GKj+sXRIjqau9fFE316ZEzIPoNEV997fh+EiEq+DuO8ddti2TCCfzSxbMx2DGQoNRWrJ5KhFPiITl62iKfP/0DwG4prmJQ0qLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1he+ssN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrrbFXu6Bep9UlBaPoKDJV9ChwKD1VqnhXtY2x/ZEGc=;
	b=A1he+ssNYEwsUKgAecmbfaSQlZBig9WZOdTeRxzWmDsB/jTM2y8OyU/8XLZavd+YtcA9Xu
	+5a081OCpXI724b0UBpVpfvfx3saLmBzY8i6rbhaNKIj8oP3utKBXIIV0QH2qsO6kkgf0f
	sH078vZIqCKeHoq9AiquzHNETfL+LgE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-mK0OFjNiMCKAInbBnB-fow-1; Wed,
 31 Jan 2024 18:30:57 -0500
X-MC-Unique: mK0OFjNiMCKAInbBnB-fow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D8CE299E755;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65A1CC2590D;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 6/8] kvm: replace __KVM_HAVE_READONLY_MEM with Kconfig symbol
Date: Wed, 31 Jan 2024 18:30:54 -0500
Message-Id: <20240131233056.10845-7-pbonzini@redhat.com>
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
References: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

KVM uses __KVM_HAVE_* symbols in the architecture-dependent uapi/asm/kvm.h to mask
unused definitions in include/uapi/linux/kvm.h.  __KVM_HAVE_READONLY_MEM however
was nothing but a misguided attempt to define KVM_CAP_READONLY_MEM only on
architectures where KVM_CHECK_EXTENSION(KVM_CAP_READONLY_MEM) could possibly
return nonzero.  This however does not make sense, and it prevented userspace
from supporting this architecture-independent feature without recompilation.

Therefore, these days __KVM_HAVE_READONLY_MEM does not mask anything and
is only used in virt/kvm/kvm_main.c.  Userspace does not need to test it
and there should be no need for it to exist.  Remove it and replace it
with a Kconfig symbol within Linux source code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm.h     | 1 -
 arch/arm64/kvm/Kconfig                | 1 +
 arch/loongarch/include/uapi/asm/kvm.h | 2 --
 arch/loongarch/kvm/Kconfig            | 1 +
 arch/mips/include/uapi/asm/kvm.h      | 2 --
 arch/mips/kvm/Kconfig                 | 1 +
 arch/riscv/include/uapi/asm/kvm.h     | 1 -
 arch/riscv/kvm/Kconfig                | 1 +
 arch/x86/include/uapi/asm/kvm.h       | 1 -
 arch/x86/kvm/Kconfig                  | 1 +
 include/uapi/linux/kvm.h              | 7 +++++++
 virt/kvm/Kconfig                      | 3 +++
 virt/kvm/kvm_main.c                   | 2 +-
 13 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 75809c8dc2f0..9c1040dad4eb 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -39,7 +39,6 @@
 
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 99193d3b8312..01398d2996c7 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,6 +34,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_IRQ_BYPASS
+	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 923d0bd38294..109785922cf9 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -14,8 +14,6 @@
  * Some parts derived from the x86 version of this file.
  */
 
-#define __KVM_HAVE_READONLY_MEM
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index ac4de790dc31..c4ef2b4d9797 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMIO
+	select HAVE_KVM_READONLY_MEM
 	select KVM_XFER_TO_GUEST_WORK
 	help
 	  Support hosting virtualized guest machines using
diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index edcf717c4327..9673dc9cb315 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -20,8 +20,6 @@
  * Some parts derived from the x86 version of this file.
  */
 
-#define __KVM_HAVE_READONLY_MEM
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /*
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 8916b3ed0f90..ab57221fa4dd 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_MMIO
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select HAVE_KVM_READONLY_MEM
 	help
 	  Support for hosting Guest kernels.
 
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 7499e88a947c..fdf4ba066131 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -16,7 +16,6 @@
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index d490db943858..26d1727f0550 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select HAVE_KVM_READONLY_MEM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf68e56fd484..c5e682ee7726 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -51,7 +51,6 @@
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
-#define __KVM_HAVE_READONLY_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 5692393b7565..d43efae05794 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
+	select HAVE_KVM_READONLY_MEM
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index aa8a7ee0f554..29b73eedfe74 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -52,6 +52,9 @@ config KVM_ASYNC_PF_SYNC
 config HAVE_KVM_MSI
        bool
 
+config HAVE_KVM_READONLY_MEM
+       bool
+
 config HAVE_KVM_CPU_RELAX_INTERCEPT
        bool
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..ff588677beb7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1614,7 +1614,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
 		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-#ifdef __KVM_HAVE_READONLY_MEM
+#ifdef CONFIG_HAVE_KVM_READONLY_MEM
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
-- 
2.39.0



