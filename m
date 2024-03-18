Return-Path: <kvm+bounces-11991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE04987ECB9
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 299FD1C2042A
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB67537E5;
	Mon, 18 Mar 2024 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9PFm9iE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C06535BA
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777228; cv=none; b=C89Qp7ik/vJqVj3bmh2EePiU3eH92aM7tiN9PLGSnOSkzIuLCj44qZSBIrIwAzmitJjNlTrHvWeWT5jxZEtq0L78SAFuRNox0NqY6xpqaDZAipEY+ZxdXp6rq9Au1JCVqn/WynNUOty08lfU3ScRgaOLZzVPBjWOuDnqr6D84dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777228; c=relaxed/simple;
	bh=GKFesQzs1JC56aI1Di7fgNijNcLsWn/lq02/Bsp+5Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbQesQinZlf5AIuqPjDbcGcx/8p0boZb+ZHmCOhEHTlBjwnhT3u6kJd72Ku/nfVBdVkJ197U3iqwxUn/70KANwoL2w7AIeW3u0JR76z2P7c9e7SCbx5sSeoF7aTVUeIEiyvocmd5LbE/sFEM4ama/5lzfCUTm1FYNPsy4HBTf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9PFm9iE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710777225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxXLz90XJ66qMz65jA/AYQZCGG6PJSqA6qXuRej7vJs=;
	b=D9PFm9iEAUDjem4iZ8rDbUMwTlsWjKWFwQ0Bfwi+zcUiE3vBl45KMUWFyq56MWrrBO9bV9
	Y5HhbwcHDftc0TCLdB2N05WtRD2VRbhf8MXcsnjQpmi9nVZLLzAWJ+Zoj3WCRQ8Wu5VP8K
	UMkAnk9ToPxxGoFOgH4bIcnW0KFz0jQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-TaExbda8N_2P6bivm3k7Vw-1; Mon, 18 Mar 2024 11:53:42 -0400
X-MC-Unique: TaExbda8N_2P6bivm3k7Vw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03A66822492;
	Mon, 18 Mar 2024 15:53:42 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.254])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A130492BD0;
	Mon, 18 Mar 2024 15:53:41 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 95CD41800D5E; Mon, 18 Mar 2024 16:53:36 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 1/2] kvm: add support for guest physical bits
Date: Mon, 18 Mar 2024 16:53:35 +0100
Message-ID: <20240318155336.156197-2-kraxel@redhat.com>
In-Reply-To: <20240318155336.156197-1-kraxel@redhat.com>
References: <20240318155336.156197-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

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
index 9c791b7b0520..5132bb96abd5 100644
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
+    if (cpu->host_phys_bits_limit &&
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


