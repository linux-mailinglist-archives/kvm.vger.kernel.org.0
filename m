Return-Path: <kvm+bounces-27873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D61198FA42
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3142A284824
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7534B1D0BA9;
	Thu,  3 Oct 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FuMJ6dTK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268C51CFEBE
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727996897; cv=none; b=hQ4Cy0fgjUHHVwkn1H9wRygYS8yo2+FNTcAMnFfGQNxrLGfEpfZkTJkooB4yJ3I98ADKUp1HVLcuOJWBsicj3PUenWW9/qjowvtHVICgzx0X5RmRJjHe6yZIqpXXVuWbXpse8B7FeDKIns/2jlZP25/L6scusNuaJQVA6EhlKc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727996897; c=relaxed/simple;
	bh=2IX5e4v312UcCof0zH5Eau+p44cjWF1hGdp1QlTb3g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTa0aBqOAqEPjPF1IbA83QkD7R5nXzkVKqz7u0x1EpF9CcD49ox9f+GXSi5w5CxVoqQ5OKGt1BGloUKG/COk5TPCaYUZGe2o2tZ2Lev3KaDyb2XIDoIlkzVuSH4xt4zYOn9aBXKZiJ4o1j1dOlQFqUYtStWI+iG3HPLzntzY1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FuMJ6dTK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727996895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP/fmcCu3JQQY+vXBVp7Ap3zOT1BUDlHez9ToS07+nk=;
	b=FuMJ6dTKdQc5FLuA0oW6mt1BdvjLbn8FHvPIk6hlVdyRdFqXlQt6x8PQU1QNUD2ZjhwfaD
	4xYQqk8Kki6aN1Iix5tV3/7wuOIKCdBKfUAkrXWwwqpYxOtvKTMk5SaT6nqZQZrn4HDLC4
	0ACv6uAKZvYMzNA/u45zi5qa8nVAgcc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-bASMRJJZP2yF9GmNd1aHwA-1; Thu,
 03 Oct 2024 19:08:11 -0400
X-MC-Unique: bASMRJJZP2yF9GmNd1aHwA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E1401955EEA;
	Thu,  3 Oct 2024 23:08:10 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 468B51955E8C;
	Thu,  3 Oct 2024 23:08:09 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	torvalds@linux-foundation.org
Subject: [PATCH 2/2] x86/reboot: emergency callbacks are now registered by common KVM code
Date: Thu,  3 Oct 2024 19:08:06 -0400
Message-ID: <20241003230806.229001-3-pbonzini@redhat.com>
In-Reply-To: <20241003230806.229001-1-pbonzini@redhat.com>
References: <20241003230806.229001-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Guard them with CONFIG_KVM_X86_COMMON rather than the two vendor modules.
In practice this has no functional change, because CONFIG_KVM_X86_COMMON
is set if and only if at least one vendor-specific module is being built.
However, it is cleaner to specify CONFIG_KVM_X86_COMMON for functions that
are used in kvm.ko.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 590b09b1d88e ("KVM: x86: Register "emergency disable" callbacks when virt is enabled")
Fixes: 6d55a94222db ("x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/reboot.h | 4 ++--
 arch/x86/kernel/reboot.c      | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index d0ef2a678d66..7ec4c4d12277 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -26,13 +26,13 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_APM		1
 
 typedef void (cpu_emergency_virt_cb)(void);
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
+#if IS_ENABLED(CONFIG_KVM_X86_COMMON)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
 #else
 static inline void cpu_emergency_disable_virtualization(void) {}
-#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
+#endif /* CONFIG_KVM_X86_COMMON */
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0e0a4cf6b5eb..0e3f9479ccc8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -530,7 +530,7 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
+#if IS_ENABLED(CONFIG_KVM_X86_COMMON)
 /* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
@@ -600,7 +600,7 @@ static void emergency_reboot_disable_virtualization(void)
 }
 #else
 static void emergency_reboot_disable_virtualization(void) { }
-#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
+#endif /* CONFIG_KVM_X86_COMMON */
 
 void __attribute__((weak)) mach_reboot_fixups(void)
 {
-- 
2.43.5


