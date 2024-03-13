Return-Path: <kvm+bounces-11735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6F487A84F
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1026E1F215D2
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1B644369;
	Wed, 13 Mar 2024 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Skh3m9Re"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A463E49D
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336450; cv=none; b=BegyICchn6FRjBr43jM/Il2LQiFceWiT2VbpPWICHuxZbrDYX1fUApabm2XN2KBbZ+k6aY/3otsUx163FiF0eMq7rNjBea1fDGe8iLsJUpdZYBUMO4Ka//OnpZxmmIcxzblk4e8iheysnn8oXXeyyh6ebnmxUbTNBw+B+yf8BIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336450; c=relaxed/simple;
	bh=71gp/zzs3WphxA6Djdk4XzBX2ZaggifqR0e0o7ph/3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFMnBQswI5Db7WlNdw/GUfZQUUuZ4pszIo1/a5JB26zAxJU8v6cP5u9gDZo5/6JIawxO1+iIEPp/rFC1MpPO0BTE7WzFkBZJPXuVOYKxA2JSEIbDXTm/gkLF/kig8HZ0wARTRS8DODIDlTGjstM5PeLY1HBRYyX+5hVADEiWLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Skh3m9Re; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710336447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QGYvvZR4jGdn9+/GBMZ0LAAhl9jnO/kUhJccqRJQQeA=;
	b=Skh3m9ReDHT9mWVMx0OwtUyglyocMxhEE6vhrJhajL6X1X0Yu1IfWJgW7EjA5toc/k2zWA
	44RrxNGdHUSMUgpkZ+NNzPIu+yttlYjOQXc4sHWuLQjA9XnVrO8AYlOo6snfaJPbi0URaP
	3E7h4NQ/E9SPqGVwMKsnRuujgUJ/nZs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-uvQRTopFNG6hXpki4SpRsA-1; Wed, 13 Mar 2024 09:27:23 -0400
X-MC-Unique: uvQRTopFNG6hXpki4SpRsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1A691800393;
	Wed, 13 Mar 2024 13:27:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 532D740C6CB2;
	Wed, 13 Mar 2024 13:27:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 9D2931801494; Wed, 13 Mar 2024 14:27:19 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 2/3] kvm: add support for guest physical bits
Date: Wed, 13 Mar 2024 14:27:18 +0100
Message-ID: <20240313132719.939417-3-kraxel@redhat.com>
In-Reply-To: <20240313132719.939417-1-kraxel@redhat.com>
References: <20240313132719.939417-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Query kvm for supported guest physical address bits, in cpuid
function 80000008, eax[23:16].  Usually this is identical to host
physical address bits.  With NPT or EPT being used this might be
restricted to 48 (max 4-level paging address space size) even if
the host cpu supports more physical address bits.

When set pass this to the guest, using cpuid too.  Guest firmware
can use this to figure how big the usable guest physical address
space is, so PCI bar mapping are actually reachable.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.h         |  1 +
 target/i386/cpu.c         |  1 +
 target/i386/kvm/kvm-cpu.c | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 952174bb6f52..d427218827f6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2026,6 +2026,7 @@ struct ArchCPU {
 
     /* Number of physical address bits supported */
     uint32_t phys_bits;
+    uint32_t guest_phys_bits;
 
     /* in order to simplify APIC support, we leave this pointer to the
        user */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9a210d8d9290..c88c895a5b3e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
             /* 64 bit processor */
              *eax |= (cpu_x86_virtual_addr_width(env) << 8);
+             *eax |= (cpu->guest_phys_bits << 16);
         }
         *ebx = env->features[FEAT_8000_0008_EBX];
         if (cs->nr_cores * cs->nr_threads > 1) {
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 9c791b7b0520..a2b7bfaeadf8 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -18,10 +18,36 @@
 #include "kvm_i386.h"
 #include "hw/core/accel-cpu.h"
 
+static void kvm_set_guest_phys_bits(CPUState *cs)
+{
+    X86CPU *cpu = X86_CPU(cs);
+    uint32_t eax, guest_phys_bits;
+
+    if (!cpu->host_phys_bits) {
+        return;
+    }
+
+    eax = kvm_arch_get_supported_cpuid(cs->kvm_state, 0x80000008, 0, R_EAX);
+    guest_phys_bits = (eax >> 16) & 0xff;
+    if (!guest_phys_bits) {
+        return;
+    }
+
+    if (cpu->guest_phys_bits == 0 ||
+        cpu->guest_phys_bits > guest_phys_bits) {
+        cpu->guest_phys_bits = guest_phys_bits;
+    }
+
+    if (cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
+        cpu->guest_phys_bits = cpu->host_phys_bits_limit;
+    }
+}
+
 static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
+    bool ret;
 
     /*
      * The realize order is important, since x86_cpu_realize() checks if
@@ -50,7 +76,11 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
                                                    MSR_IA32_UCODE_REV);
         }
     }
-    return host_cpu_realizefn(cs, errp);
+    ret = host_cpu_realizefn(cs, errp);
+
+    kvm_set_guest_phys_bits(cs);
+
+    return ret;
 }
 
 static bool lmce_supported(void)
-- 
2.44.0


