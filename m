Return-Path: <kvm+bounces-10617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C196686DF1C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 631A61F25B09
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5821A6BB2B;
	Fri,  1 Mar 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWA1XQes"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B296A325
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709288241; cv=none; b=u9LeV2aZlamUv4/1AHa7EY0eWfZIHrGLRO2YI5Kzu+KTcJLwNXF+ZMnRvRkArKKPA9yjiMXA5mcV1GgPwUKWZzy7ADR+BUIJ8TOA91ajPy6LVVVWjYCK5VDJtjJqff6lArifhig3Lh234bYuZlbnv1yau3VZL44hzKjc4GEB56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709288241; c=relaxed/simple;
	bh=Q5N5VgbHX3TyzlddZsaRmdtq+vL9Es8FKg6tBnOdhao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2fe4+vpoCB/P4bFtXaSnK1AmNC045WAHogm1MnF0GaUuV/RreiGeKRkdnYLwWWfmhZn4JwOoh91vIlErtKhEj3ukh9I+WC+W5oKwYj3qzg6VFggcBsScQHTwIYUzy3h8C/YoNvRvhMtxnpz/Dtxti72lFLc2mjKduWK8Qz30L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWA1XQes; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709288238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L4tloGzTclE01aZgDWKwhvpvN6goYAyVoicNQ/4Whak=;
	b=DWA1XQes43zqy8U4WOESvsHeng9GLZEeEjZ2dAJbjhAntQN1K2snUsSd8ZrMdckoViYx01
	7l6/+rkWUXjVdJpcghWjGfphCcLwTH7qK54yi6U46PCDoQNtO9pgs5JCNVOOWjtd5UcxyW
	Yepv2fKv14YW+dMkDpowS6pUgbrF7Lg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-0LGv2Pw8Pa683wrQIr3ktg-1; Fri,
 01 Mar 2024 05:17:15 -0500
X-MC-Unique: 0LGv2Pw8Pa683wrQIr3ktg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57E6728EC113;
	Fri,  1 Mar 2024 10:17:15 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.121])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0073492BE2;
	Fri,  1 Mar 2024 10:17:14 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 0B6E3180148E; Fri,  1 Mar 2024 11:17:14 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 1/1] kvm: add support for guest physical bits
Date: Fri,  1 Mar 2024 11:17:13 +0100
Message-ID: <20240301101713.356759-2-kraxel@redhat.com>
In-Reply-To: <20240301101713.356759-1-kraxel@redhat.com>
References: <20240301101713.356759-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

query kvm for supported guest physical address bits using
KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
(leaf 0x80000008, eax, bits 16-23).

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.h     | 1 +
 target/i386/cpu.c     | 1 +
 target/i386/kvm/kvm.c | 8 ++++++++
 3 files changed, 10 insertions(+)

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
index 2666ef380891..1a6cfc75951e 100644
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
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 42970ab046fa..e06c9d66bb01 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1716,6 +1716,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
     uint32_t limit, i, j, cpuid_i;
+    uint32_t guest_phys_bits;
     uint32_t unused;
     struct kvm_cpuid_entry2 *c;
     uint32_t signature[3];
@@ -1751,6 +1752,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
 
+    guest_phys_bits = kvm_check_extension(cs->kvm_state, KVM_CAP_VM_GPA_BITS);
+    if (guest_phys_bits &&
+        (cpu->guest_phys_bits == 0 ||
+         cpu->guest_phys_bits > guest_phys_bits)) {
+        cpu->guest_phys_bits = guest_phys_bits;
+    }
+
     /*
      * kvm_hyperv_expand_features() is called here for the second time in case
      * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
-- 
2.44.0


