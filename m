Return-Path: <kvm+bounces-12589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 092AE88A9A2
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C344341DE7
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 16:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C426F14D28D;
	Mon, 25 Mar 2024 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VTDaU+zl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BE6149C71
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378058; cv=none; b=SCiKIfHbax0PZRZHD9oKBEZ3bOViuyGCfwowfPDzcP1ER+C1N82jzc1obAGcxseJvHXgR+8fbRVLCGg5v7xi9XUuf9pwEkMUE2pxozpYojTwBHWhHKF5F+AJfZg8FRr9Vqlh1xf26XFO78HAgQq1fKeRepRcZXhiLB+Iv18hqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378058; c=relaxed/simple;
	bh=5mR6JrlRkPWNHwwvfTrPgPZxflRV/rXqRreiaqG43i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gio7CRiv9REn29cpQ+8tF/ZdOwTh4rnGDFPD2vVYzCBPv1Yq9T6aeTADtuGDoNaOqZqoSrVlomomwirS5TGiy8sMT9nLLcNTlJkN7O51Vgq2aJRPLwhKLNECgDIhKGcU7v5iU0vhnyIc1nM4eitNn/8kstMeetTUUwPrccqqp6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VTDaU+zl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711378056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VazSRcTbku3LywnN/7Q7TrP0Ppb/9wCf++7ePYqCWwE=;
	b=VTDaU+zl17//s7wQap/uwcgv+phe3k4Y1CFEnETBcP2DbTggTwJr10TbsPD9q9RChwDLM1
	qg+TIwqfjI+u/ddGCOp5bRjl2BmkHoJ2deMgZLlhOmqg7koxeoazIIIm9KM0ELCnVEDVnE
	yVZdj+P+AeyUM7UMq5NoRmT981ach/8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-U76x7RzGPXSkPRtX21nQRg-1; Mon,
 25 Mar 2024 10:47:31 -0400
X-MC-Unique: U76x7RzGPXSkPRtX21nQRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5ACD2800E84;
	Mon, 25 Mar 2024 14:47:30 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.158])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 672CA2166B31;
	Mon, 25 Mar 2024 14:47:30 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 653DA1801CDB; Mon, 25 Mar 2024 15:47:25 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v5 1/2] kvm: add support for guest physical bits
Date: Mon, 25 Mar 2024 15:47:23 +0100
Message-ID: <20240325144725.1089192-2-kraxel@redhat.com>
In-Reply-To: <20240325144725.1089192-1-kraxel@redhat.com>
References: <20240325144725.1089192-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

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
 target/i386/kvm/kvm-cpu.c | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6b0573807918..83e473584517 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2026,6 +2026,7 @@ struct ArchCPU {
 
     /* Number of physical address bits supported */
     uint32_t phys_bits;
+    uint32_t guest_phys_bits;
 
     /* in order to simplify APIC support, we leave this pointer to the
        user */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 33760a2ee163..3b7bd506baf1 100644
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
index 9c791b7b0520..c5c24f6a8282 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -18,10 +18,33 @@
 #include "kvm_i386.h"
 #include "hw/core/accel-cpu.h"
 
+static void kvm_set_guest_phys_bits(CPUState *cs)
+{
+    X86CPU *cpu = X86_CPU(cs);
+    uint32_t eax, guest_phys_bits;
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
+    if (cpu->host_phys_bits && cpu->host_phys_bits_limit &&
+        cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
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
@@ -50,7 +73,13 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
                                                    MSR_IA32_UCODE_REV);
         }
     }
-    return host_cpu_realizefn(cs, errp);
+    ret = host_cpu_realizefn(cs, errp);
+    if (!ret) {
+        return ret;
+    }
+
+    kvm_set_guest_phys_bits(cs);
+    return true;
 }
 
 static bool lmce_supported(void)
-- 
2.44.0


